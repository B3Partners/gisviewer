/*-----------------------------------------------------------------------------
Copyright (C) 2006  Menko Kroeske

This file is part of Flamingo MapComponents.

Flamingo MapComponents is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-----------------------------------------------------------------------------*/
/** @component Map
* The Map is a container for layers.
* @file Map.as  (sourcefile)
* @file Map.fla (sourcefile)
* @file Map.swf (compiled Map, needed for publication on internet)
* @file Map.xml (configurationfile for Map, needed for publication on internet)
* @see LayerArcIMS
* @see LayerOGWMS
* @see LayerImage
* @see LayerGrid
* @see LayerOverview
*/
dynamic class Map extends MovieClip {
	//
	static var version:String = "F2 beta";
	public var __width:Number;
	public var __height:Number;
	public var holdonidentify:Boolean;
	public var holdonupdate:Boolean;
	public var updating:Boolean;
	public var identifying:Boolean;
	public var maxscale:Number;
	public var minscale:Number;
	public var movetime:Number;
	public var movesteps:Number;
	public var fadesteps:Number;
	public var hit:Boolean;
	public var prevextents:Array;
	public var nextextents:Array;
	//
	public var testnr:Number = 0;
	//
	private var _mapextent:Object;
	private var _currentextent:Object;
	private var _fullextent:Object;
	private var _extent:Object;
	private var _updatedextent:Object;
	private var _identifyextent:Object;
	private var rememberextent:Boolean;
	private var nrprevextents:Number;
	private var cursorid:String;
	//
	private var layersupdating:Object;
	private var layersidentifying:Object;
	//
	private var moveid:Number;
	private var updateid:Number;
	//
	public var hasextent:Boolean;
	function Map() {
		if (flamingo == undefined) {
			var readme:String = "Map.swf, "+version;
			readme += newline+"";
			readme += newline+"--------------------------------------------------------------------------------------------------------------";
			readme += newline+"Copyright (C) 2006  Menko Kroeske";
			readme += newline+"";
			readme += newline+"This file is part of Flamingo MapComponents.";
			readme += newline+"";
			readme += newline+"Flamingo MapComponents is free software; you can redistribute it and/or";
			readme += newline+"modify it under the terms of the GNU General Public License";
			readme += newline+"as published by the Free Software Foundation; either version 2";
			readme += newline+"of the License, or (at your option) any later version.";
			readme += newline+"";
			readme += newline+"This program is distributed in the hope that it will be useful,";
			readme += newline+"but WITHOUT ANY WARRANTY; without even the implied warranty of";
			readme += newline+"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the";
			readme += newline+"GNU General Public License for more details.";
			readme += newline+"";
			readme += newline+"You should have received a copy of the GNU General Public License";
			readme += newline+"along with this program; if not, write to the Free Software";
			readme += newline+"Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.";
			readme += newline+"--------------------------------------------------------------------------------------------------------------";
			readme += newline+"";
			readme += newline+"http://www.flamingo-mc.org/";
			var t:TextField = this.createTextField("readme", 0, 0, 0, 500, 400);
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.size = 12;
			tf.color = 0x33333;
			t.setNewTextFormat(tf);
			t.text = readme;
			return;
		}
		//defaults     
		hit = false;
		rememberextent = true;
		nrprevextents = 0;
		holdonidentify = false;
		holdonupdate = false;
		updating = false;
		identifying = false;
		fadesteps = 3;
		movetime = 200;
		movesteps = 5;
		//10;
		hasextent = false;
		layersupdating = new Object();
		layersidentifying = new Object();
		this.prevextents = new Array();
		//because this is a superclass we have to correct the target information
		flamingo.correctTarget(this._parent, this);
		//
		var thisObj = this;
		//------------------------------------------
		//step1: Listeners
		//------------------------------------------
		//parent
		var lParent:Object = new Object();
		lParent.onResize = function() {
			thisObj.resize();
		};
		flamingo.addListener(lParent, flamingo.getParent(this));
		//
		//flamingo
		var lFlamingo:Object = new Object();
		lFlamingo.onLoadComponent = function(mc:MovieClip) {
			if (thisObj.mLayers[mc._name] == mc) {
				flamingo.raiseEvent(thisObj, "onAddLayer", thisObj, mc);
			}
		};
		flamingo.addListener(lFlamingo, "flamingo");
		//
		//special listener for mousewheel
		var lMouse:Object = new Object();
		lMouse.onMouseWheel = function(delta, target) {
			if (thisObj.hit) {
				flamingo.raiseEvent(thisObj, "onMouseWheel", thisObj, delta);
			}
		};
		Mouse.addListener(lMouse);
		//
		//------------------------------------------
		// step2: Movies
		//------------------------------------------
		//var mc:MovieClip = this.attachMovie("bg", "mBG", 0);
		var mc = this.createEmptyMovieClip("mBG", 0);
		mc.beginFill(0x0000FF, 0);
		mc.moveTo(0, 0);
		mc.lineTo(300, 0);
		mc.lineTo(300, 300);
		mc.lineTo(0, 300);
		mc.lineTo(0, 0);
		mc.endFill();
		this.createEmptyMovieClip("mLayers", 1);
		this.createEmptyMovieClip("mLayers2", 2);
		this.createEmptyMovieClip("mAcetate", 3);
		//
		mc.useHandCursor = false;
		mc.onRollOver = function() {
			flamingo.raiseEvent(thisObj, "onRollOver", thisObj);
			flamingo.showCursor(thisObj.cursorid);
			thisObj.hit = true;
			this.onMouseMove = function() {
				if (thisObj.hit) {
					var coord = this._parent.point2Coordinate({x:thisObj._xmouse, y:thisObj._ymouse});
					flamingo.raiseEvent(thisObj, "onMouseMove", thisObj, thisObj._xmouse, thisObj._ymouse, coord);
				}
				updateAfterEvent();
			};
			this.onMouseDown = function() {
				if (thisObj.hit) {
					this.md = true;
					var coord = this._parent.point2Coordinate({x:thisObj._xmouse, y:thisObj._ymouse});
					flamingo.raiseEvent(thisObj, "onMouseDown", thisObj, thisObj._xmouse, thisObj._ymouse, coord);
				}
			};
			this.onDragOver = function() {
				flamingo.showCursor(thisObj.cursorid);
				flamingo.raiseEvent(thisObj, "onDragOver", thisObj);
				thisObj.hit = true;
			};
			this.onDragOut = function() {
				flamingo.hideCursor();
				flamingo.raiseEvent(thisObj, "onDragOut", thisObj);
				thisObj.hit = false;
			};
			this.onMouseUp = function() {
				if (this.md) {
					delete this.md;
					var coord = this._parent.point2Coordinate({x:thisObj._xmouse, y:thisObj._ymouse});
					flamingo.raiseEvent(thisObj, "onMouseUp", thisObj, thisObj._xmouse, thisObj._ymouse, coord);
				}
				if (not thisObj.hit) {
					delete this.onMouseMove;
					delete this.onMouseUp;
					delete this.onMouseDown;
					delete this.onDragOver;
					delete this.onDragOut;
				}
			};
		};
		mc.onRollOut = function() {
			thisObj.hit = false;
			flamingo.hideCursor();
			flamingo.raiseEvent(thisObj, "onRollOut", thisObj);
			delete this.coord;
			delete this.onMouseMove;
			delete this.onMouseUp;
			delete this.onMouseDown;
			delete this.onDragOver;
			delete this.onDragOut;
		};
		//------------------------------------------
		// step 3: XML
		//------------------------------------------
		/** @tag <fmc:Map>  
		* A Map can contain different layer tags
		* @hierarchy childnode of <flamingo> or <fmc:Window>
		* @example 
		* @attr holdonupdate  (defaultvalue "false") true = the Map cannot update until the previous update is completed.
		* @attr holdonidentify (defaultvalue "false") true = the Map cannot perform an identify until the previous identify is completed.
		* @attr fadesteps  (defaultvalue "0")  Number of steps of the fade-effect, which layers use to appear.
		* @attr extent  Comma seperated list of minx,miny,maxx,maxy, defining the current view of the map. 
		* @attr fullextent  Comma seperated list of minx,miny,maxx,maxy. When defined, a map cannot zoom further out than this extent.
		* @attr minscale  A map cannot zoom further in than this scale (defined in mapunits per pixel).
		* @attr maxscale  A map cannot zoom further out than this scale (defined in mapunits per pixel).
		* @attr movetime  (defaultvalue "200") The time in miliseconds (1000 = 1 second) the map needs for moving to a new extent.
		* @attr movesteps  (defaultvalue "5") The number of steps (resolution) of a move from the one extent to the other. More steps = smoother animation = more computer stress.
		* @attr fadesteps  (defaultvalue "3") The number of steps in which a layer will appear smoothly (fadein).
		* @attr nrprevextents (defaultvalue "0") Number of extents that are remembered.
		*/
		var xml:XML = flamingo.getXML(this);
		//if (xml.localName.toLowerCase() == this.componentname.toLowerCase()) {
		for (var attr in xml.attributes) {
			var attr:String = attr.toLowerCase();
			var val:String = xml.attributes[attr];
			switch (attr) {
			case "nrprevextents" :
				this.nrprevextents = Number(val);
				break;
			case "holdonupdate" :
				if (val.toLowerCase() == "true") {
					this.holdonupdate = true;
				} else {
					this.holdonupdate = false;
				}
				break;
			case "holdonidentify" :
				if (val.toLowerCase() == "true") {
					this.holdonidentify = true;
				} else {
					this.holdonidentify = false;
				}
				break;
			case "fadesteps" :
				this.fadesteps = Number(val);
				break;
			case "extent" :
				this._extent = this.string2Extent(val);
				this._extent.name = "initialextent";
				break;
			case "fullextent" :
				this._fullextent = this.string2Extent(val);
				this._fullextent.name = "fullextent";
				break;
			case "minscale" :
				this.minscale = Number(val);
				break;
			case "maxscale" :
				this.maxscale = Number(val);
				break;
			case "movetime" :
				this.movetime = Number(val);
				break;
			case "movesteps" :
				this.movesteps = Number(val);
				break;
			default :
				break;
			}
		}
		resize();
		flamingo.raiseEvent(this, "onInit", this);
		//component resized further with adding layers
		//go on with adding layers
		var xlayers:Array = xml.childNodes;
		if (xlayers.length>0) {
			for (var i:Number = xlayers.length-1; i>=0; i--) {
				this.addLayer(xlayers[i]);
			}
		}
		//delete xml from repository                                                                                                                                                      
		flamingo.deleteXML(this);
	}
	//private function cacheMap() {
	//trace("cache");
	//this.bmpcache = new flash.display.BitmapData(__width, __height, true);
	//this.mCache.attachBitmap(this.bmpcache, 0, "auto", true);
	//this.bmpcache.draw(this.mLayers);
	//}
	//function releaseCache() {
	//trace("release");
	//this.bmpcache.dispose();
	//}
	/**
	* Forces a resize of the map
	* This will raise the onResize event.
	*/
	public function resize():Void {
		_xscale = _yscale=100;
		var r:Object = flamingo.getPosition(this, this._parent._parent);
		this._x = r.x;
		this._y = r.y;
		this.__width = r.width;
		this.__height = r.height;
		this.mBG._width = __width;
		this.mBG._height = this.__height;
		this.mBorder._width = __width;
		this.mBorder._height = this.__height;
		this.scrollRect = new flash.geom.Rectangle(0, 0, (this.__width), (this.__height));
		this.rememberextent = false;
		this.moveToExtent(this._extent, undefined, 0);
		flamingo.raiseEvent(this, "onResize", this);
		this.update();
	}
	/**
	* Adds a layer to the map
	* If a layer is added the onAddLayer event will dispatch.
	* @param xml:XML xml with layer definition
	* @return Movieclip of the layer.
	*/
	public function addLayer(xml:Object, mLayerMovie:MovieClip):MovieClip {
		if (typeof (xml) == "string") {
			xml = new XML(String(xml)).firstChild;
		}
		var id = xml.attributes.id;
		if (id == undefined) {
			id = flamingo.getUniqueId();
		}
		if (mLayerMovie == undefined) {
			mLayerMovie = this.mLayers;
		}
		var mc:MovieClip = mLayerMovie.createEmptyMovieClip(id, mLayerMovie.getNextHighestDepth());
		var thisObj = this;
		var lLayer:Object = new Object();
		lLayer.onUpdate = function(layer:MovieClip, nrtry:Number) {
			thisObj.layersupdating[layer._name] = new Object();
			thisObj.layersupdating[layer._name].updatecomplete = false;
		};
		lLayer.onUpdateError = function(layer:MovieClip, error:String) {
			flamingo.raiseEvent(thisObj, "onUpdateError", thisObj, layer, error);
			thisObj.layersupdating[layer._name].updatecomplete = true;
			thisObj.layersupdating[layer._name].error = error;
			thisObj.checkUpdate();
		};
		lLayer.onUpdateComplete = function(layer:MovieClip) {
			thisObj.layersupdating[layer._name].updatecomplete = true;
			thisObj.checkUpdate();
		};
		lLayer.onIdentify = function(layer:MovieClip) {
			//thisObj.identifying = true;
			thisObj.layersidentifying[layer._name] = new Object();
			thisObj.layersidentifying[layer._name].identifycomplete = false;
		};
		lLayer.onIdentifyError = function(layer:MovieClip, error:String) {
			flamingo.raiseEvent(thisObj, "onIdentifyError", thisObj, layer, error);
			thisObj.layersidentifying[layer._name].identifycomplete = true;
			thisObj.layersidentifying[layer._name].error = error;
			thisObj.checkIdentify();
		};
		lLayer.onIdentifyData = function(layer:MovieClip, data:Object, identifyextent:Object) {
			//trace(thisObj.extent2String(thisObj._identifyextent));
			//trace(thisObj.extent2String(identifyextent));
			trace("same identifyextent:"+thisObj.isEqualExtent(identifyextent, thisObj._identifyextent));
			flamingo.raiseEvent(thisObj, "onIdentifyData", thisObj, layer, data, identifyextent);
		};
		lLayer.onIdentifyComplete = function(layer:MovieClip) {
			thisObj.layersidentifying[layer._name].identifycomplete = true;
			thisObj.checkIdentify();
		};
		flamingo.addListener(lLayer, id);
		//layer listener
		flamingo.loadComponent(xml, mc);
		return (mc);
	}
	private function checkUpdate() {
		var updatetotal:Number = 0;
		var layersupdated:Number = 0;
		this.updating = true;
		for (var attr in this.layersupdating) {
			updatetotal++;
			if (this.layersupdating[attr].updatecomplete) {
				layersupdated++;
			}
		}
		flamingo.raiseEvent(this, "onUpdateProgress", this, layersupdated, updatetotal);
		if (updatetotal == layersupdated) {
			this.updating = false;
			flamingo.raiseEvent(this, "onUpdateComplete", this);
		}
	}
	private function checkIdentify() {
		var identifytotal:Number = 0;
		var layersidentifying:Number = 0;
		this.identifying = true;
		for (var attr in this.layersidentifying) {
			identifytotal++;
			if (this.layersidentifying[attr].identifycomplete) {
				layersidentifying++;
			}
		}
		flamingo.raiseEvent(this, "onIdentifyProgress", this, layersidentifying, identifytotal);
		trace("onIdentifyProgress:"+layersidentifying+","+identifytotal);
		if (identifytotal == layersidentifying) {
			this.identifying = false;
			flamingo.raiseEvent(this, "onIdentifyComplete", this);
		}
	}
	/**
	* Removes a layer from the map.
	* This will raise the onRemoveLayer event.
	*/
	public function removeLayer(id:String):Void {
		delete layersupdating[id];
		flamingo.killComponent(id);
		flamingo.raiseEvent(this, "onRemoveLayer", this);
	}
	/**
	* Change layer order.
	* This will raise the onSwapLayer event.
	* @param id:String layerid
	* @param index:Number new layer position
	*/
	public function swapLayer(id:String, index:Number):Void {
		this.mLayers[id].swapDepths(index);
		flamingo.raiseEvent(this, "onSwapLayer", this);
	}
	/**
	* Sets the visibility of a layer to false.
	* This will raise the onHideLayer event.
	* @param id:String layerid
	*/
	public function hideLayer(id:String):Void {
		this.mLayers[id].hide();
		flamingo.raiseEvent(this, "onHideLayer", this, this.mLayers[id]);
	}
	/**
	* Sets the visibility of a layer to true.
	* This will raise the onShowLayer event.
	* @param id:String layerid
	*/
	public function showLayer(id:String):Void {
		this.mLayers[id].show();
		flamingo.raiseEvent(this, "onShowLayer", this, this.mLayers[id]);
	}
	/**
	* Hides the map.
	* This will raise the onHide event.
	*/
	public function hide():Void {
		this._visible = false;
		flamingo.raiseEvent(this, "onHide", this);
	}
	/**
	* Sets the visibility of the map to true.
	* This will raise the onShow event.
	*/
	public function show():Void {
		this._visible = true;
		flamingo.raiseEvent(this, "onShow", this);
	}
	/**
	* Performs an identify on a map.
	* This will raise the onIdentify event.
	* @param identifyextent:Object extent defining identify area
	*/
	public function identify(identifyextent:Object):Void {
		if (this.holdonidentify and this.identifying) {
			return;
		}
		this._identifyextent = this.copyExtent(identifyextent);
		flamingo.raiseEvent(this, "onIdentify", this, this._identifyextent);
		this.checkIdentify();
	}
	/**
	* Returns the mapscale based on the fullextent and the current aspectratio.
	* @return  scale when map is zoomed to fullextent
	* @see getMapExtent
	*/
	public function getFullScale():Number {
		if (not this.isValidExtent(this._fullextent)) {
			return;
		}
		var e:Object = this.copyExtent(this._fullextent);
		this.correctExtent(e);
		return ((e.maxx-e.minx)/this.__width);
	}
	/**
	* Returns the mapscale based on the currentextent
	* @return  current scale of the map
	* @see getMapExtent
	*/
	public function getCurrentScale():Number {
		return ((this._currentextent.maxx-this._currentextent.minx)/this.__width);
	}
	/**
	* Returns the mapscale based on the mapextent
	* @return  scale of the mapextent
	* @see getMapExtent
	*/
	public function getMapScale():Number {
		return ((this._mapextent.maxx-this._mapextent.minx)/this.__width);
	}
	/**
	* Returns the mapextent.
	* extent = the uncorrected extent of a map set by 'moveToExtent'.
	* mapextent = the corrected extent of a map.
	* fullextent = the maximum extent of a map, you can not further zoom out.
	* currentextent = the actually corrected extent during animation. When animation is finished then mapextent = currentextent.
	* @return mapextent
	*/
	public function getMapExtent():Object {
		return this.copyExtent(this._mapextent);
	}
	/**
	* Returns the fullextent
	* @return fullextent
	* @see getMapExtent
	*/
	public function getFullExtent():Object {
		return this.copyExtent(this._fullextent);
	}
	/**
	* Returns the currentextent.
	* @return currentextent
	* @see getMapExtent
	*/
	public function getCurrentExtent():Object {
		return this.copyExtent(this._currentextent);
	}
	/**
	* Return the extent
	* @return extent
	* @see getMapExtent
	*/
	public function getExtent():Object {
		return this.copyExtent(this._extent);
	}
	/**
	* Sets the full extent.
	* @param extent:Object An extent is an object with minx, miny, maxx, maxy
	*/
	public function setFullExtent(extent:Object):Void {
		if (this.isValidExtent(extent)) {
			this._fullextent = this.copyExtent(extent);
		}
	}
	/**
	* Moves or zooms the map to a given coordinate. With or without animation.
	* The user can zoom by using a scale or a percentage.
	* @param coord:Object  [optional] Coordinate, an object with x and y. If undefined the map will zoom in the center of the current mapextent.
	* @param scale:Number [optional] Mapscale (mapunits per pixel) If scale and percentage are both undefined, the map will not zoom.
	* @param percentage:Number [optional]  Percentage, 100 means 100% of the current mapextent, Number smaller than 100 means zooming out. Number greater than 100 means zooming in.
	* @param  updatedelay:Number [optional]  Delay in milliseconds. If updatedelay is undefined or -1 there will be no onUpdate event.  
	* @param  movetime:Number [optional]  Total time of move-animation. If movetime is 0, there wil be no animation. The Extent is set immediately. If movetime is undefined, the default movetime of the map will be used.  
	*/
	public function moveToCoordinate(coord:Object, scale:Number, percentage:Number, updatedelay:Number, movetime:Number):Void {
		if (scale == undefined and percentage == undefined and coord == undefined) {
			return;
		}
		var ext:Object = new Object();
		if (scale == undefined and percentage == undefined) {
			var nw = this._currentextent.maxx-this._currentextent.minx;
			var nh = this._currentextent.maxy-this._currentextent.miny;
		} else if (percentage == undefined) {
			var nw = this.__width*scale;
			var nh = this.__height*scale;
		} else {
			var nw = (this._currentextent.maxx-this._currentextent.minx)/percentage*100;
			var nh = (this._currentextent.maxy-this._currentextent.miny)/percentage*100;
		}
		if (coord == undefined) {
			var x = (this._currentextent.maxx+this._currentextent.minx)/2;
			var y = (this._currentextent.maxy+this._currentextent.miny)/2;
		} else {
			var x = coord.x;
			var y = coord.y;
		}
		ext.minx = x-nw/2;
		ext.miny = y-nh/2;
		ext.maxx = ext.minx+nw;
		ext.maxy = ext.miny+nh;
		this.moveToExtent(ext, updatedelay, movetime);
	}
	/**
	* Moves the map to the next extent. The array with next extents is filled by 'moveToPrevExtent'
	* @param  movetime:Number [optional]  Total time of move-animation. If movetime is 0, there wil be no animation. The Extent is set immediately. If movetime is undefined, the default movetime of the map will be used.  
	*/
	public function moveToNextExtent(movetime:Number):Void {
		if (this.nextextents.length<=0) {
			return;
		}
		var ext = this.nextextents.pop();
		this.prevextents.push(this.copyExtent(this._updatedextent));
		this.rememberextent = false;
		this.moveToExtent(ext, 0, movetime);
	}
	/**
	* Moves the map to the previous extent. 
	* @param  movetime:Number [optional]  Total time of move-animation. If movetime is 0, there wil be no animation. The Extent is set immediately. If movetime is undefined, the default movetime of the map will be used.  
	*/
	public function moveToPrevExtent(movetime:Number):Void {
		if (this.prevextents.length<=0) {
			return;
		}
		this.nextextents.push(this.copyExtent(this._updatedextent));
		var ext = this.prevextents.pop();
		this.rememberextent = false;
		this.moveToExtent(ext, 0, movetime);
	}
	/**
	* Sets the extent of the map with or without move-animation. 
	* @param extent:Object Extent, an extent is an object with minx, miny, maxx, maxy
	* @param updatedelay:Number [optional] Delay in milliseconds. If updatedelay is undefined or -1 there will be no onUpdate event.
	* @param movetime:Number [optional]  Total time of move-animation. If movetime is 0, there wil be no animation. The Extent is set immediately. If movetime is undefined, the default movetime of the map will be used.  
	*/
	public function moveToExtent(extent:Object, updatedelay:Number, movetime:Number):Void {
		if (not this.isValidExtent(extent)) {
			return;
		}
		// remember the original uncorrected extent                                                                                
		this._extent = this.copyExtent(extent);
		// correct the extent and set as mapextent  
		this._mapextent = this.copyExtent(extent);
		this.correctExtent(this._mapextent);
		// stop previous animation                                        
		clearInterval(this.moveid);
		// start new animtion 
		if (movetime == undefined) {
			movetime = this.movetime;
		}
		if (movetime<=0 or not this.hasextent) {
			this._currentextent = this.copyExtent(this._mapextent);
			flamingo.raiseEvent(this, "onStartMove", this);
			_quality = "LOW";
			flamingo.raiseEvent(this, "onChangeExtent", this);
			_quality = "BEST";
			flamingo.raiseEvent(this, "onStopMove", this);
		} else {
			var obj:Object = new Object();
			obj.startextent = this.copyExtent(this._currentextent);
			obj.step = 0;
			obj.nrsteps = Math.abs(this.movesteps);
			if (this.movesteps<=0) {
				var t = movetime;
			} else {
				var t = Math.round(movetime/this.movesteps);
			}
			flamingo.raiseEvent(this, "onStartMove", this);
			this.moveid = setInterval(this, "_move", t, obj);
		}
		this.hasextent = true;
		if (updatedelay == undefined) {
			return;
		}
		if (updatedelay<0) {
			return;
		}
		this.update(updatedelay);
	}
	//
	private function _move(obj:Object) {
		if (obj.step>=obj.nrsteps) {
			this._currentextent = this.copyExtent(this._mapextent);
			clearInterval(this.moveid);
			_quality = "LOW";
			flamingo.raiseEvent(this, "onChangeExtent", this);
			_quality = "BEST";
			flamingo.raiseEvent(this, "onStopMove", this);
		} else {
			var p:Number = Math.sin((90/obj.nrsteps*obj.step)*Math.PI/180);
			var ext:Object = new Object();
			ext.minx = obj.startextent.minx+((this._mapextent.minx-obj.startextent.minx)*p);
			ext.miny = obj.startextent.miny+((this._mapextent.miny-obj.startextent.miny)*p);
			ext.maxx = obj.startextent.maxx+((this._mapextent.maxx-obj.startextent.maxx)*p);
			ext.maxy = obj.startextent.maxy+((this._mapextent.maxy-obj.startextent.maxy)*p);
			this._currentextent = ext;
			_quality = "LOW";
			flamingo.raiseEvent(this, "onChangeExtent", this);
			_quality = "BEST";
		}
		updateAfterEvent();
		obj.step++;
	}
	public function refresh():Void {
		this.update(0, true);
	}
	/**
	* Updates the map. 
	* This will fire the onUpdate event.
	* @param delay:Number [optional] if omitted the onUpdate event will raise immediatelly, otherwhise after the delay time (milliseconds)
	*/
	public function update(delay:Number, forceupdate:Boolean):Void {
		if (this.holdonupdate and this.updating) {
			return;
		}
		clearInterval(this.updateid);
		if (delay>0) {
			this.updateid = setInterval(this, "_update", Number(delay), forceupdate);
		} else {
			this._update(forceupdate);
		}
	}
	private function _update(forceupdate:Boolean) {
		// stop previous update call
		clearInterval(this.updateid);
		if (forceupdate == undefined) {
			forceupdate = false;
		}
		if (this.isEqualExtent(this._updatedextent, this._mapextent)) {
			if (not forceupdate) {
				return false;
			}
		} else {
			if (this.rememberextent and this.nrprevextents>0) {
				this.prevextents.push(this.copyExtent(this._updatedextent));
				this.nextextents = new Array();
				if (this.prevextents.length>this.nrprevextents) {
					this.prevextents.splice(0, 1);
				}
			}
		}
		// remember the  extent for previuos extent
		this._updatedextent = this.copyExtent(this._mapextent);
		this.rememberextent = true;
		// no delay, so fire event
		flamingo.raiseEvent(this, "onUpdate", this);
		//check if any layer is updating, if so don't bother because the layerlistener takes care for raising
		// a onUpdateComplete-event, if not > raise onUpdateCompleteEvent
		this.checkUpdate();
	}
	/**
	* Cancels an update.
	*/
	public function cancelUpdate():Void {
		clearInterval(this.updateid);
	}
	//
	/**
	* Calculates the distance between two coordinates.
	* @param coord1:Object  first coordinate.
	* @param coord2:Object  second coordinate.
	* @return distance  
	*/
	public function getDistance(coord1:Object, coord2:Object):Number {
		var distance:Number = Math.sqrt((Math.pow((coord1.x-coord2.x), 2)+Math.pow((coord1.y-coord2.y), 2)));
		return (distance);
	}
	/**
	* Calculates an extent(=map dimensions) to a rect(=screen dimensions).
	* @param extent:Object the extent which has to be calculated to a rect.
	* @param extent:Object [optional] Reference extent. By default the calculations will use the currentextent.
	* @return rect, an object with x,y, width and height  
	*/
	public function extent2Rect(extent:Object, extent2:Object):Object {
		//calculates an extent to a rect using the currentextent
		//a rect contains screen coordinates and the properties:x,y,width and height
		//an extent contains mapcoordiates and the properties:minx,maxx, miny, maxy
		if (extent2 == undefined) {
			extent2 = this._currentextent;
		}
		var ms = (extent2.maxx-extent2.minx)/this.__width;
		var r:Object = new Object();
		r.x = (extent.minx-extent2.minx)/ms;
		r.y = (extent2.maxy-extent.maxy)/ms;
		r.width = (extent.maxx-extent.minx)/ms;
		r.height = (extent.maxy-extent.miny)/ms;
		return (r);
	}
	/**
	* Calculates a rect(=screen dimensions) to an extent(=map dimensions).
	* @param rect:Object the rect which has to be calculated to an extent.
	* @param extent:Object [optional] Reference extent. By default the calculations will use the currentextent.
	* @return extent, an object with minx, miny, maxx and maxy  
	*/
	public function rect2Extent(rect:Object, extent:Object):Object {
		//calculates a rect to an extent using the current mapextent
		//a rect contains screen coordinates and the properties:x,y,width and height
		//an extent contains mapcoordiates and the properties:minx,maxx, miny, maxy
		if (extent == undefined) {
			extent = this._currentextent;
		}
		var e = new Object();
		var ms = (extent.maxx-extent.minx)/this.__width;
		e.minx = extent.minx+(rect.x*ms);
		e.maxy = extent.maxy-(rect.y*ms);
		e.maxx = e.minx+(rect.width*ms);
		e.miny = e.maxy-(rect.height*ms);
		return (e);
	}
	/**
	* Calculates a point(=screen dimensions) to a coordinate(=map dimensions)
	* @param point:Object the point which has to be calculated to a coordinate.
	* @param extent:Object [optional] Reference extent. By default the calculations will use the currentextent.
	* @return coordinate, an object with x and y.  
	*/
	public function point2Coordinate(point:Object, extent:Object):Object {
		//calculates a pointto a coordinate using the current mapextent
		//a coordinate contains mapcoordinates
		//a point contains screen coordinates
		//both objects have the same properties:x and y
		if (extent == undefined) {
			extent = this._currentextent;
		}
		var c:Object = new Object();
		var ms = (extent.maxx-extent.minx)/this.__width;
		c.x = extent.minx+(point.x*ms);
		c.y = extent.maxy-(point.y*ms);
		return (c);
	}
	/**
	* Calculates a coordinate(=map dimensions) to a point(=screen dimensions) .
	* @param coordinate:Object the coordinate which has to be calculated to a point.
	* @param extent:Object [optional] Reference extent. By default the calculations will use the currentextent.
	* @return point, an object with x and y.  
	*/
	public function coordinate2Point(coordinate:Object, extent:Object):Object {
		//calculates a coordinate to a point using the current mapextent
		//a coordinate contains mapcoordinates
		//a point contains screen coordinates
		//both objects have the same properties:x and y
		if (extent == undefined) {
			extent = this._currentextent;
		}
		var p:Object = new Object();
		var ms = (extent.maxx-extent.minx)/this.__width;
		p.x = (coordinate.x-extent.minx)/ms;
		p.y = (extent.maxy-coordinate.y)/ms;
		return (p);
	}
	/**
	* Determines if a map is busy executing an update.
	    * @return true or false  
	*/
	public function isUpdating():Boolean {
		if (this.updating) {
			return (false);
		} else {
			return (true);
		}
	}
	/**
	* Determines if a map is busy executing an identify.
	* @return true or false  
	*/
	public function isIdentifying():Boolean {
		if (this.identifying) {
			return (false);
		} else {
			return (true);
		}
	}
	/** 
	* converts an extent to a comma seperated string.
	* @param extent:Object the extent which has to be converted
	* @return String representation of an extent.
	*/
	public function extent2String(extent:Object):String {
		return (extent.minx+","+extent.miny+","+extent.maxx+","+extent.maxy);
	}
	/** 
	* converts comma seperated string to an extent object.
	* The string has the format:minx,miny,maxx,maxy
	* @param str:String the string which has to be converted
	* @return extent
	*/
	public function string2Extent(str:String):Object {
		var extent:Object = new Object();
		var a:Array = str.split(",");
		extent.minx = Number(a[0]);
		extent.maxx = Number(a[2]);
		extent.miny = Number(a[1]);
		extent.maxy = Number(a[3]);
		if (extent.minx>extent.maxx) {
			var maxx = extent.maxx;
			extent.maxx = extent.minx;
			extent.minx = maxx;
		}
		if (extent.miny>extent.maxy) {
			var maxy = extent.maxy;
			extent.maxy = extent.miny;
			extent.miny = maxy;
		}
		return (extent);
	}
	/**  
	* Checks if two extents are the same.
	* @param extent:Object extent 1
	* @param extent2:Object extent 2
	* @return true or false
	*/
	public function isEqualExtent(extent:Object, extent2:Object):Boolean {
		if (extent2 == undefined) {
			extent2 = this._mapextent;
		}
		if (extent.minx != extent2.minx) {
			return false;
		}
		if (extent.miny != extent2.miny) {
			return false;
		}
		if (extent.maxx != extent2.maxx) {
			return false;
		}
		if (extent.maxy != extent2.maxy) {
			return false;
		}
		return true;
	}
	/** 
	* Checks if an extent has consist of numbers and is not empty.
	* @param extent:Object extent 
	* @return true or false
	*/
	public function isValidExtent(extent:Object):Boolean {
		if (isNaN(extent.minx)) {
			return false;
		}
		if (isNaN(extent.miny)) {
			return false;
		}
		if (isNaN(extent.maxy)) {
			return false;
		}
		if (isNaN(extent.maxx)) {
			return false;
		}
		return true;
	}
	/** 
	* Checks if an extent is hit by another extent.
	* @param extent:Object extent 1
	* @param extent2:Object [optional] By default hit is calculated with mapextent
	* @return true or false
	*/
	public function isHit(extent:Object, extent2:Object):Boolean {
		if (extent2 == undefined) {
			extent2 = this._mapextent;
		}
		if (extent.maxx<extent2.minx) {
			return false;
		}
		if (extent.minx>extent2.maxx) {
			return false;
		}
		if (extent.maxy<extent2.miny) {
			return false;
		}
		if (extent.miny>extent2.maxy) {
			return false;
		}
		return true;
	}
	private function copyExtent(obj:Object):Object {
		var extent = new Object();
		for (var attr in obj) {
			extent[attr] = obj[attr];
		}
		return extent;
	}
	private function correctAspectRatio(extent:Object) {
		//This method modifies the extent without making a copy!
		var w:Number = extent.maxx-extent.minx;
		var h:Number = extent.maxy-extent.miny;
		if ((__width/__height)<(w/h)) {
			// width is ok, calculate new height
			var nh:Number = w*this.__height/this.__width;
			extent.miny = extent.miny-((nh-h)/2);
			extent.maxy = extent.miny+nh;
		} else {
			//height is ok, calculate new height
			var nw:Number = h*this.__width/this.__height;
			extent.minx = extent.minx-((nw-w)/2);
			extent.maxx = extent.minx+nw;
		}
	}
	private function correctExtent(extent:Object) {
		//This method modifies the extent without making a copy!
		//check 1. does the extent has the same aspectratio as the mapcomponent     
		correctAspectRatio(extent);
		var w:Number = extent.maxx-extent.minx;
		var h:Number = extent.maxy-extent.miny;
		//check 2. does the extent exceeds the fullextent, if so , correct it
		if (this._fullextent != undefined) {
			//var full = this._fullextent.copy();
			//full.correctAspectRatio(this.__width, this.__height)
			//var wfull = full.getWidth();
			//var hfull = full.getHeight();
			//check boundaries
			if (extent.minx<this._fullextent.minx) {
				extent.minx = this._fullextent.minx;
				extent.maxx = extent.minx+w;
				if (extent.maxx>this._fullextent.maxx) {
					extent.maxx = this._fullextent.maxx;
				}
			}
			if (extent.maxx>this._fullextent.maxx) {
				extent.maxx = this._fullextent.maxx;
				extent.minx = extent.maxx-w;
				if (extent.minx<this._fullextent.minx) {
					extent.minx = this._fullextent.minx;
				}
			}
			if (extent.miny<this._fullextent.miny) {
				extent.miny = this._fullextent.miny;
				extent.maxy = extent.miny+h;
				if (extent.maxy>this._fullextent.maxy) {
					extent.maxy = this._fullextent.maxy;
				}
			}
			if (extent.maxy>this._fullextent.maxy) {
				extent.maxy = this._fullextent.maxy;
				extent.miny = extent.maxy-h;
				if (extent.miny<this._fullextent.miny) {
					extent.miny = this._fullextent.miny;
				}
			}
			correctAspectRatio(extent);
			w = extent.maxx-extent.minx;
			h = extent.maxy-extent.miny;
		}
		//check 3. Does the extent exceeds the minscale or maxscale, if so, correct it                                                                                                         
		if (this.minscale != undefined) {
			var s:Number = w/this.__width;
			if (s<this.minscale) {
				var nw:Number = this.__width*this.minscale;
				var nh:Number = nw*this.__height/this.__width;
				var x:Number = (extent.minx+extent.maxx)/2;
				var y:Number = (extent.miny+extent.maxy)/2;
				extent.minx = x-nw/2;
				extent.maxx = extent.minx+nw;
				extent.miny = y-nh/2;
				extent.maxy = extent.miny+nh;
			}
		}
		if (this.maxscale != undefined) {
			var s:Number = w/this.__width;
			if (s>this.maxscale) {
				var nw:Number = this.__width*this.maxscale;
				var nh:Number = nw*this.__height/this.__width;
				var x:Number = (extent.minx+extent.maxx)/2;
				var y:Number = (extent.miny+extent.maxy)/2;
				extent.minx = x-nw/2;
				extent.maxx = extent.minx+nw;
				extent.miny = y-nh/2;
				extent.maxy = extent.miny+nh;
			}
		}
	}
	/** 
	 * Sets a custom cursor.
	 * @param value:String cursorid
	 * @example
	 * map.setCursorId(flamingo.getCursorId("myPan", "grab"));
	 */
	public function setCursorId(value:String):Void {
		this.cursorid = value;
		if (this.hit) {
			flamingo.showCursor(this.cursorid);
		}
	}
	/** 
	 * Gets the custom cursorid.
	 * @return custom cursorid
	 */
	public function getCursorId():String {
		return this.mouseid;
	}
	/** Sets the time of the animated moving between two extents. 
	 * @param value:Number The time in milliseconds (1000 = 1 second).
	 */
	public function setMoveTime(value:Number):Void {
		this.movetime = value;
	}
	/** 
	 * Gets the movetime
	 * @return movetime
	 */
	public function getMoveTime():Number {
		return (this.movetime);
	}
	/** 
	 * Sets the number of steps of the moving animation.
	 * More steps means a smoother animation.
	 * @param value:Number 
	 */
	public function setMoveSteps(value:Number) {
		this.movesteps = value;
	}
	/** 
	 * Gets the number of movesteps.
	 * @return custom movesteps
	 */
	public function getMoveSteps():Number {
		return (this.movesteps);
	}
	/** 
	 * Sets the number of steps by which layers will fadein.
	 * @param value:Number number of fadesteps
	 */
	public function setFadeSteps(value:Number) {
		this.fadesteps = value;
	}
	/**
	 * Gets the number of steps by which layers will fadein.
	 * @return number of fadesteps
	 */
	public function getFadeSteps():Number {
		return (this.fadesteps);
	}
	/**
	 * Sets the minimum scale of a map. The map cannot zoom further in.
	 * @param value:Number minscale, a number of mapunits by pixels
	 */
	public function setMinScale(value:Number) {
		this.minscale = value;
	}
	/** 
	 * Gets the minimum scale.
	 * @return minscale
	 */
	public function getMinScale():Number {
		return (this.minscale);
	}
	/** 
	 * Sets the maximum scale of a map. The map cannot zoom further out.
	 * @param value:Number maxscale, a number of mapunits by pixels
	 */
	public function setMaxScale(value:Number) {
		this.maxscale = value;
	}
	/** Gets the maximum scale.
	 * @return maxscale
	 */
	public function getMaxScale():Number {
		return (this.maxscale);
	}
	/** 
	 * If set to true a map can only identify when the previous identify is completed.
	 * @param value:Boolean  true or false
	 */
	public function setHoldOnIdentify(value:Boolean) {
		this.holdonidentify = value;
	}
	/**
	 * Gets the holdonidentify.
	 * @return true or false
	 */
	public function getHoldOnIdentify():Boolean {
		return (this.holdonidentify);
	}
	/** 
	 * If set to true a map can only update when the previous update is completed.
	 * @param value:Boolean  true or false
	 */
	public function setHoldOnUpdate(value:Boolean) {
		this.holdonupdate = value;
	}
	/** 
	 * Gets the holdonupdate.
	 * @return true or false
	 */
	public function getHoldOnUpdate():Boolean {
		return (this.holdonupdate);
	}
	/** 
	 * Sets the total number of previous extents.
	 * @param value:Number 
	 */
	public function setNrPrevExtents(value:Number) {
		this.nrprevextents = value;
	}
	/** Gets the total number of previous extents.
	 * @return total
	 */
	public function getNrPrevExtents():Number {
		return (this.nrprevextents);
	}
	/** 
	 * Dispatched when a map is up and ready to run.
	 * @param map:MovieClip a reference to the map.
	 */
	//public function onInit(map:MovieClip):Void {
	//}
	/** 
	 * Dispatched when a layer is added.
	 * @param map:MovieClip a reference to the map.
	 * @param layer:MovieClip a reference to the layer.
	 */
	//public function onAddLayer(map:MovieClip, layer:MovieClip):Void {
	//}
	/** 
	 * Dispatched when a layer is removed.
	 * @param map:MovieClip a reference to the map.
	 */
	//public function onRemoveLayer(map:MovieClip):Void {
	//}
	/** 
	 * Dispatched when a layer is swapped.
	 * @param map:MovieClip a reference to the map.
	 */
	//public function onSwapLayer(map:MovieClip):Void {
	//}
	/**
	* Dispatched when a layer is hidden.
	* @param map:MovieClip a reference to the map.
	* @param layer:MovieClip a reference to the layer.
	*/
	//public function onHideLayer(map:MovieClip, layer:MovieClip):Void {
	//}
	/**
	* Dispatched when a layer is shown.
	* @param map:MovieClip a reference to the map.
	* @param layer:MovieClip a reference to the layer.
	*/
	//public function onShowLayer(map:MovieClip, layer:MovieClip):Void {
	//}
	/** 
	* Dispatched when a map resizes.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onResize(map:MovieClip):Void {
	//}
	/**
	* Dispatched when the map is shown.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onShow(map:MovieClip):Void {
	//}
	/**
	* Dispatched when the map is hidden.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onHide(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when a map updates.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onUpdate(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when one or more maplayers are ready with their update sequence.
	* @param map:MovieClip a reference to the map.
	* @param layersupdated:Number number of layers already updated.
	* @param updatetotal:Number total number of layers that have to be updated
	*/
	//public function onUpdateProgress(map:MovieClip, layersupdated:Number, updatetotal:Number):Void {
	//}
	/** 
	* Dispatched when a layer encounters  an error during an update sequence.
	* @param map:MovieClip a reference to the map.
	* @param layer:MovieClip a reference to the layer.
	* @param error:String an error message.
	*/
	//public function onUpdateError(map:MovieClip, layer:MovieClip, error:String):Void {
	//}
	/** 
	* Dispatched when an update sequence is completed.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onUpdateComplete(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the extent of the map changes.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onChangeExtent(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the map performs an identify.
	* @param map:MovieClip a reference to the map.
	* @param extent:Object the area of the identify.
	*/
	//public function onIdentify(map:MovieClip, extent:Object):Void {
	//}
	/** 
	* Dispatched when a layer has completed its identify.
	* @param map:MovieClip a reference to the map.
	* @param  layersindentified:Number number of layers already identified.
	* @param  identifytotal:Number total number of layers that have to be identified.
	*/
	//public function onIdentifyProgress(map:MovieClip, layersindentified:Number, identifytotal:Number):Void {
	//}
	/** 
	* Dispatched when a layer has come up with information. When a layer has to identify more layerid's this event will fire each time a layerid has identified.
	* @param map:MovieClip a reference to the map.
	* @param layer:MovieClip a reference to the identified layer
	    * @param data:Object data object with the information 
	    * @param identifyextent:Object the  extent that is identified 
	*/
	//public function onIdentifyData(map:MovieClip, layer:MovieClip, data:Object, identifyextent:Object):Void {
	//}
	/** 
	* Dispatched when a layer encounters an error during identify
	* @param map:MovieClip a reference to the map.
	* @param layer:MovieClip a reference to the layer.
	* @param error:String an error message.
	*/
	//public function onIdentifyError(map:MovieClip, layer:MovieClip, error:String):Void {
	//}
	/** 
	* Dispatched when  an identify sequence is completed.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onIdentifyComplete(map:MovieClip):Void {
	//}
	/**
	* Dispatched when the mouse is moved over the map. Fired only once.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onRollOver(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the mouse is moved of the map. Fired only once.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onRollOut(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the mouse is moved over the map, when the left mousebutton is pushed. Fired only once.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onDragOver(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the mouse is moved of the map, when the left mousebutton is pushed. Fired only once.
	* @param map:MovieClip a reference to the map.
	*/
	//public function onDragOut(map:MovieClip):Void {
	//}
	/** 
	* Dispatched when the mouse is moved over the map. This event fires repeatly when the mouse moves.
	* @param map:MovieClip a reference to the map.
	* @param xmouse:Number x-pixel position of the mouse 
	* @param ymouse:Number  y-pixel position of the mouse 
	* @param coord:Object coordinate of the mouse. Object with x and y
	*/
	//public function onMouseMove(map:MovieClip, xmouse:Number, ymouse:Number, coord:Object):Void {
	//}
	/**
	* Dispatched when the mouse is on the map and the user pushes the mousebutton.
	* @param map:MovieClip a reference to the map.
	* @param xmouse:Number x-pixel position of the mouse 
	* @param ymouse:Number  y-pixel position of the mouse 
	* @param coord:Object coordinate of the mouse. Object with x and y
	*/
	//public function onMouseDown(map:MovieClip, xmouse:Number, ymouse:Number, coord:Object):Void {
	//}
	/** 
	* Dispatched when the mouse is on the map and the user pushes the mousebutton.
	* @param map:MovieClip a reference to the map.
	* @param xmouse:Number x-pixel position of the mouse 
	* @param ymouse:Number  y-pixel position of the mouse 
	* @param coord:Object coordinate of the mouse. Object with x and y
	*/
	//public function onMouseUp(map:MovieClip, xmouse:Number, ymouse:Number, coord:Object):Void {
	//}
	/**
	* Dispatched when the mouse is on the map and the user turns the mousewheel.
	* @param map:MovieClip a reference to the map.
	* @param delta:Number number of steps moved.
	*/
	//public function onMouseWheel(map:MovieClip, delta:Number):Void {
	//}
}
