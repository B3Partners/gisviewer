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
/** @component Flamingo Framework
* This class is the framework of Flamingo MapComponents.
* It provides several methods to load, manage and control the (map)components.
* A configuration file determines which components have to be loaded and how they interact with eachother.
* @file flamingo.as  (sourcefile)
* @file flamingo.fla (sourcefile)
* @file flamingo.swf (compiled framework, needed for publication on internet)
* @file flamingo.xml (configurationfile for framework, needed for publication on internet)
* @configstyle .tooltip Fontstyle for tooltips
* @configstyle .preloadtitle Fontstyle for title on logo
*/
import flash.external.ExternalInterface;
class Flamingo {
	private var version:String = "F2 Release Candidate 2";
	//reference to main movie from which this class is loaded
	//the main has error, tooltip and logo movies in library, which can be attached
	//at the main movie the components are loaded at 'moviedepth'++
	//at the main movie a cursor movie is loaded at depth 9999
	//at the main movie a tooltip movie can be loaded at depth 9998
	//at the main movie a error movie can be loaded at depth 9997
	private var mFlamingo:MovieClip;
	//repository for storing custom information of every loaded component (per component id)
	private var components:Object;
	//repository for storing default information per component url
	private var components_per_url:Object;
	//
	//repository for storing xmls
	private var xmlpool:Object;
	//repository for storing configs
	private var configpool:Object;
	//default language setting
	//default tooltip delay
	//depth of first component
	public var moviedepth:Number = 0;
	//filename of configfile
	private var useexternalinterface:Boolean;
	private var preloadtitle:String;
	private var tooltipdelay:Number = 500;
	private var skin:String = "";
	private var lang:String = "en";
	private var width:String = "100%";
	private var height:String = "100%";
	private var maxheight:Number;
	private var minheight:Number;
	private var maxwidth:Number;
	private var minwidth:Number;
	private var nocache:String;
	private var languages:String = "en";
	private var resizeid:Number;
	private var backgroundcolor:Number;
	private var backgroundalpha:Number = 100;
	private var bordercolor:Number;
	private var borderwidth:Number;
	private var borderalpha:Number = 100;
	private var flamingoid:String = "flamingo";
	private var configs:Array;
	private var loading:Boolean;
	private var uniqueid:Number;
	private var rooturl:String
	//Flamingo class constructor
	//@param mc MovieClip containing error-, logo- and tooltip movies in library
	public function Flamingo(mc:MovieClip) {
		//save base url of flamingo.swf
		var url = mc._url.split("?")[0]
		var a_url = url.split("/")
		a_url.pop()
		this.rooturl = a_url.join("/")
		// make it possible to communicate from a html page with flamingo through the callFlamingo function
		//ExternalInterface.addCallback("call", this, callMethod);
		ExternalInterface.addCallback("callMethod", this, callMethod);
		ExternalInterface.addCallback("setProperty", this, setProperty);
		ExternalInterface.addCallback("getProperty", this, getProperty);
		ExternalInterface.addCallback("call", this, callMethod);
		ExternalInterface.addCallback("set", this, setProperty);
		ExternalInterface.addCallback("get", this, getProperty);
		this.xmlpool = new Object();
		this.configpool = new Object();
		this.components = new Object();
		this.components_per_url = new Object();
		//add the flamingo object to the components list and components per url list
		this.components.flamingo = new Object();
		this.components.flamingo.target = mc._target;
		this.components.flamingo.url = "flamingo";
		this.components_per_url.flamingo = new Object();
		this.components_per_url.flamingo.strings = new Object();
		this.components_per_url.flamingo.cursors = new Object();
		this.components_per_url.flamingo.styles = new TextField.StyleSheet();
		//keep a reference to the movie
		this.mFlamingo = mc;
		//listener for Stage resize-event
		var flamingo:Object = this;
		var stageListener:Object = new Object();
		stageListener.onResize = function() {
			clearInterval(flamingo.resizeid);
			flamingo.resizeid = setInterval(flamingo, "resize", 500);
			//flamingo.resize()
		};
		//do some tricks with the Stage
		//Stage.showMenu = false;
		Stage.addListener(stageListener);
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		//add custom context menu
		var cm:ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();
		cm.customItems.push(new ContextMenuItem("About Flamingo MapComponents...", about));
		_root.menu = cm;
		//
		//var keyListener:Object = new Object();
		//keyListener.onKeyDown = function() {
		// 55 is key code for 7
		//if (Key.getCode() == 116) {
		//flamingo.loadConfig(flamingo.configfile);
		//}
		//};
		//Key.addListener(keyListener);
		//finally load flamingo.xml
		var xml:XML = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = function(success:Boolean) {
			if (success) {
				if (this.firstChild.nodeName.toLowerCase() == "flamingo") {
					flamingo.parseString(this.firstChild, flamingo.components_per_url.flamingo.strings);
					flamingo.parseCursor(this.firstChild, flamingo.components_per_url.flamingo.cursors);
					flamingo.parseStyle(this.firstChild, flamingo.components_per_url.flamingo.styles);
				}
			}
			delete xml;
		};
		xml.load(getNocacheName(this.correctUrl("flamingo.xml"), "second"));
		//create movie for cursors
		this.mFlamingo.createEmptyMovieClip("flamingoCursors", 9999);
		this.mFlamingo.createEmptyMovieClip("flamingoBorder", 9998);
		this.init();
	}
	private function init() {
		this.useexternalinterface = true;
		this.moviedepth = 0;
		this.preloadtitle = undefined;
		this.tooltipdelay = 500;
		this.loading = false;
		this.skin = "";
		this.lang = "en";
		this.width = "100%";
		this.height = "100%";
		this.maxheight = undefined;
		this.minheight = undefined;
		this.maxwidth = undefined;
		this.minwidth = undefined;
		this.nocache = "";
		this.languages = "en";
		this.backgroundcolor = undefined;
		this.backgroundalpha = 100;
		this.bordercolor = undefined;
		this.borderwidth = undefined;
		this.borderalpha = 100;
		this.flamingoid = "flamingo";
		this.mFlamingo.width = "100%";
		this.mFlamingo.height = "100%";
		this.raiseEvent(this, "onInit");
		this.uniqueid = 1;
	}
	
	/**
	* Opens the internet page of flamingo-mc.
	*/
	public function about():Void {
		getURL("http://www.flamingo-mc.org","_blank");
	}
	/**
	* Resizes the application and fires the 'onResize' event.
	* This function is triggered by a resize of the stage.
	*/
	public function resize():Void {
		//the dimensions (__width and __height) are stored at the flamingo movie
		clearInterval(this.resizeid);
		var mFlamingo = this.getComponent("flamingo");
		var h:Number = this.getAbs(mFlamingo.height, Stage.height-1);
		var w:Number = this.getAbs(mFlamingo.width, Stage.width-1);
		if (mFlamingo.minheight>0) {
			h = Math.max(mFlamingo.minheight, h);
		}
		if (mFlamingo.maxheight>0) {
			h = Math.min(mFlamingo.maxheight, h);
		}
		if (mFlamingo.maxwidth>0) {
			w = Math.min(mFlamingo.maxwidth, w);
		}
		if (mFlamingo.minwidth>0) {
			w = Math.max(mFlamingo.minwidth, w);
		}
		mFlamingo.__height = h;
		mFlamingo.__width = w;
		//log
		if (mFlamingo.mLogo != undefined) {
			mFlamingo.mLogo._x = (Stage.width/2);
			mFlamingo.mLogo._y = (Stage.height/2);
		}
		if (mFlamingo.mError != undefined) {
			mFlamingo.mError._x = (Stage.width/2);
			mFlamingo.mError._y = (Stage.height/2);
		}
		//                                                                                                                                
		mFlamingo.clear();
		mFlamingo.beginFill(backgroundcolor, backgroundalpha);
		mFlamingo.moveTo(0, 0);
		mFlamingo.lineTo(mFlamingo.__width, 0);
		mFlamingo.lineTo(mFlamingo.__width, mFlamingo.__height);
		mFlamingo.lineTo(0, mFlamingo.__height);
		mFlamingo.lineTo(0, 0);
		mFlamingo.endFill();
		mFlamingo.flamingoBorder.clear();
		mFlamingo.flamingoBorder.lineStyle(this.borderwidth, this.bordercolor, this.borderalpha);
		mFlamingo.flamingoBorder.moveTo(0, 0);
		mFlamingo.flamingoBorder.lineTo(mFlamingo.__width, 0);
		mFlamingo.flamingoBorder.lineTo(mFlamingo.__width, mFlamingo.__height);
		mFlamingo.flamingoBorder.lineTo(0, mFlamingo.__height);
		mFlamingo.flamingoBorder.lineTo(0, 0);
		this.components.flamingo.broadcastMessage("onResize");
	}
	/**
	* Checks if a configuration file is being loaded.
	* @return Boolean True if flamingo is busy loading a configuration.
	*/
	public function isLoading():Boolean {
		return (this.loading);
	}
	/**
	* Removes all loaded components and initilizes Flamingo for a fresh start.
	*/
	public function clear():Void {
		for (var id in this.components) {
			if (id != "flamingo") {
				this.killComponent(id);
			}
		}
		//refresh (remove) all old listeners
		AsBroadcaster.initialize(this.components["flamingo"]);
		this.init();
	}
	/**
	* loads a xml-file in flamingo for later use.
	*/
	public function loadXMLPool(file:String) {
		if (file == undefined) {
			//no file entered, quit
			return;
		}
		if (this.xmlpool[file] != undefined) {
			//file is already downloaded or is being downloaded, so quit
			return;
		}
		this.xmlpool[file] = new XML();
		this.xmlpool[file].ignoreWhite = true;
		var flamingo = this;
		this.xmlpool[file].onLoad = function(success:Boolean) {
			if (success) {
				flamingo.raiseEvent(flamingo, "onLoadXMLPool", file);
			} else {
				flamingo.raiseEvent(flamingo, "onError", "Error opening '"+file+"'...");
				flamingo.showError("Flamingo error", "Error opening '"+file+"'...");
				delete flamingo.xmlpool[file];
			}
		};
		this.xmlpool[file].load(getNocacheName(file, "second"));
	}
	public function clearXMLPool(file:String) {
		// a clear is being performed with a delay
		// in the mean time other functions can still make use of the xml
		_global['setTimeout'](this, '_clearXMLPool', 2000, file);
	}
	private function _clearXMLPool(file:String) {
		if (file == undefined) {
			for (var id in this.xmlpool) {
				delete this.xmlpool[id];
			}
			delete this.xmlpool;
			this.xmlpool = new Object();
		} else {
			delete this.xmlpool[file];
		}
	}
	public function getXMLfromPool(file:String, attributeid:String):String {
		if (this.xmlpool[file] == undefined) {
			return;
		}
		if (attributeid == undefined or attributeid.length == 0) {
			return this.xmlpool[file].toString();
		} else {
			var node = findNode(this.xmlpool[file].firstChild, attributeid);
			this.addNameSpaces(node);
			return node.toString();
		}
	}
	private function addNameSpaces(node:XMLNode) {
		if (node.getNamespaceForPrefix(node.prefix) != null) {
			node.attributes["xmlns:"+node.prefix] = node.getNamespaceForPrefix(node.prefix);
		}
		var childnodes = node.childNodes;
		for (var i = 0; i<childnodes.length; i++) {
			addNameSpaces(childnodes[i]);
		}
	}
	private function findNode(node:XMLNode, id:String):XMLNode {
		for (var attr in node.attributes) {
			if (attr.toLowerCase() == "id") {
				if (node.attributes[attr] == id) {
					return node;
				}
			}
		}
		for (var i = 0; node.childNodes && i<node.childNodes.length; i++) {
			var foundNode = findNode(node.childNodes[i], id);
			if (foundNode != null) {
				return foundNode;
			}
		}
		return;
	}
	/**
	* Sets a configuration. This configuration can be a xml or a string representing a valid xml.
	* @param xml:Object Xml or string with configuration.
	*/
	public function setConfig(xml:Object, showlogo:Boolean, id:String, targetid:String):Void {
		if (typeof (xml) == "string") {
			xml = new XML(String(xml));
		}
		if (showlogo == undefined) {
			showlogo = true;
		}
		if (showlogo) {
			this.showLogo();
		}
		this.configs.push({xml:xml, id:id, targetid:targetid});
		this.processConfig();
	}
	/**
	* Loads a configuration file.
	* @param file:String Xml file with configuration.
	* @param showlogo:Boolean [optional] True or false (default true)
	* @param id:String [optional] Only the xml part belonging to this id will be loaded.
	* @param target:String [optional] The xml will be loaded into this component.
	*/
	public function loadConfig(file:String, showlogo:Boolean, id:String, targetid:String):Void {
		if (file == undefined or file.length == 0) {
			return;
		}
		if (showlogo == undefined) {
			showlogo = true;
		}
		if (showlogo) {
			this.showLogo();
		}
		if (this.configs == undefined) {
			this.configs = new Array();
		}
		// add config to the configs array                                               
		this.configs.push({file:this.correctUrl(file), id:id, targetid:targetid});
		this.processConfig();
	}
	private function processConfig():Void {
		if (this.loading) {
			// an other config is in the progress of loading, wait and return later
			return;
		}
		if (this.configs.length == 0) {
			//all configs are loaded
			this.mFlamingo.mLogo.txt.htmlText = "";
			this.mFlamingo.mLogo.gotoAndStop(1);
			delete this.mFlamingo.mLogo.onPress;
			this.removeLogo();
			this.raiseEvent(this, "onLoadConfig");
			for (var id in this.configpool) {
				delete this.configpool[id];
			}
			delete this.configpool;
			this.configpool = new Object();
			return;
		}
		//trace("PROCESSINI")                                 
		//load next config              
		this.loading = true;
		var obj = this.configs.shift();
		var file = obj.file;
		var xml = obj.xml;
		var id = obj.id;
		var targetid = obj.targetid;
		if (file != undefined) {
			if (this.configpool[file] == undefined) {
				//load config
				this.configpool[file] = new XML();
				this.configpool[file].ignoreWhite = true;
				var flamingo = this;
				this.configpool[file].onLoad = function(success:Boolean) {
					if (success) {
						if (id == undefined) {
							flamingo.parseConfigXML(this);
						} else {
							var xml = flamingo.findNode(this.firstChild, id);
							flamingo.addComponent(xml, targetid);
						}
					} else {
						flamingo.raiseEvent(flamingo, "onError", "Error opening '"+file+"'...");
						flamingo.showError("Flamingo error", "Error opening '"+file+"'...");
						flamingo.loading = false;
						flamingo.processConfig();
					}
				};
				this.configpool[file].load(getNocacheName(file, "second"));
			} else {
				//config already loaded 
				if (id == undefined) {
					//parse complete config
					this.parseConfigXML(this.configpool[file]);
				} else {
					var xml = this.findNode(this.configpool[file].firstChild, id);
					flamingo.addComponent(xml, targetid);
				}
			}
		} else {
			if (id == undefined) {
				//parse complete config
				this.parseConfigXML(xml);
			} else {
				var xml = this.findNode(xml.firstChild, id);
				flamingo.addComponent(xml, targetid);
			}
		}
	}
	/**
	* Returns a filename with a unique argument so the application is forced to get this file fresh from a server.
	* @param filename:String Filename.
	* @return String Filename with a postfix. 
	*/
	public function getNocacheName(filename:String, nocache:String):String {
		if (nocache == undefined) {
			nocache = "second";
		}
		if (nocache.length == 0) {
			return filename;
		}
		if (_root._url.substr(0, 5).toLowerCase() == "file:") {
			return filename;
		} else {
			var postfix = "";
			var d:Date = new Date();
			switch (nocache.toLowerCase()) {
			case "second" :
				postfix = "?noCache="+d.getTime();
				break;
			case "minute" :
				postfix = "?noCache="+d.getFullYear()+"-"+d.getMonth()+"-"+d.getDate()+"-"+d.getHours()+"-"+d.getMinutes();
				break;
			case "hour" :
				postfix = "?noCache="+d.getFullYear()+"-"+d.getMonth()+"-"+d.getDate()+"-"+d.getHours();
				break;
			case "day" :
				postfix = "?noCache="+d.getFullYear()+"-"+d.getMonth()+"-"+d.getDate();
				break;
			case "month" :
				postfix = "?noCache="+d.getFullYear()+"-"+d.getMonth();
				break;
			case "year" :
				postfix = "?noCache="+d.getFullYear();
				break;
			default :
				postfix = "?noCache="+d.getTime();
			}
			return filename+postfix;
		}
	}
	/** @tag <flamingo>  
	* Each configuration file starts with the 'flamingo' node. This node is a good place to define the namespaces for the componentnodes.
	* @hierarchy root-node
	* @example 
	* <flamingo xmlns:fmc="fmc" lang="en" languages="en,nl">
	* ...
	* child tags
	* ...
	* </flamingo>
	* @attr preloadtitle  Title which is shown in the preload-logo. If undefined then flamingo will show loading progress per component.
	* @attr tooltipdelay (defaultvalue "500") Time in milliseconds (1000 = 1 second) between showing a tooltip and moving the mouse over a component.
	* @attr lang  (defaultvalue "en") The language of the application.
	* @attr languages (defaultvalue "en") Comma seperated list of 'lang' abbreviations. e.g. languages="en,nl,de" Flamingo will load these language strings. By default only english strings are loaded. When languages="" flamingo will load all available language strings. 
	* @attr minwidth  The minimum width of the application in pixels.
	* @attr maxwidth  The maximum width of the application in pixels.
	* @attr maxheight  The maximum height of the application in pixels.
	* @attr minheight  The minimum height of the application in pixels.
	* @attr width  (defaultvalue "100%") The width of the application. By default the application fills the available space of the flamingo.swf. This space is controled in the html page.
	* @attr height (defaultvalue "100%") The height of the application. By default the application fills the available space of the flamingo.swf. This space is controled in the html page.
	* @attr useexternalinterface (defaultvalue "true") If set to "true" flamingo will pass all events to the browser. And with javascript you can talk with Flamingo.
	* @attr bordercolor  Color of a border arround the application in a hexadecimal notation. e.g. bordercolor="#00ff33" 
	* @attr borderwidth  Width of the border in pixels. If set to "0" (meaning 'hairline') or greater Flamingo will draw a border.
	* @attr borderalpha (defaultvalue "100") Transparency of border. Default is "100" meaning opaque.
	* @attr backgroundcolor  Color of the backgound in hexadecimal notation. If set, Flamingo will have a background, otherwhise Flamingo's background is transparent.
	* @attr backgroundalpha (defaultvalue "100") Transparency of background if backgroundcolor is set.
	* @attr clear  True or false. True: all existing components will be removed from the application.
	*/
	private function parseConfigXML(xml:Object):Void {
		//parses the ini-xml
		var mFlamingo = this.getComponent("flamingo");
		//defaults
		if (xml.firstChild.nodeName.toLowerCase() == "flamingo") {
			//retreive and convert the attributes 
			for (var attr in xml.firstChild.attributes) {
				var val:String = xml.firstChild.attributes[attr];
				switch (attr.toLowerCase()) {
				case "clear" :
					if (val.toLowerCase() == "true") {
						this.clear();
					}
					break;
				case "id" :
					this.flamingoid = val;
				case "bordercolor" :
					if (val.charAt(0) == "#") {
						this.bordercolor = Number("0x"+val.substring(1, val.length));
					} else {
						this.bordercolor = Number(val);
					}
					break;
				case "backgroundcolor" :
					if (val.charAt(0) == "#") {
						this.backgroundcolor = Number("0x"+val.substring(1, val.length));
					} else {
						this.backgroundcolor = Number(val);
					}
					break;
				case "borderwidth" :
					this.borderwidth = Number(val);
					break;
				case "borderalpha" :
					this.borderalpha = Number(val);
					break;
				case "backgroundalpha" :
					this.backgroundalpha = Number(val);
					break;
				case "nocache" :
					this.nocache = val;
					break;
				case "preloadtitle" :
					this.preloadtitle = val;
					break;
				case "tooltipdelay" :
					this.tooltipdelay = Number(val);
					break;
				case "lang" :
					this.lang = val;
					break;
				case "languages" :
					this.languages = val;
					break;
				case "maxwidth" :
					mFlamingo.maxwidth = Number(val);
					break;
				case "minwidth" :
					mFlamingo.minwidth = Number(val);
					break;
				case "maxheight" :
					mFlamingo.maxheight = Number(val);
					break;
				case "minheight" :
					mFlamingo.minheight = Number(val);
					break;
				case "width" :
					mFlamingo.width = val;
					break;
				case "height" :
					mFlamingo.height = val;
					break;
				case "useexternalinterface" :
					if (val.toLowerCase() == "true") {
						this.useexternalinterface = true;
					} else {
						this.useexternalinterface = false;
					}
					break;
				}
			}
			//gathered enough information for a proper resize
			this.resize();
			//get custom language settings
			this.parseString(xml.firstChild, this.components_per_url.flamingo.strings);
			//get custom cursors
			this.parseCursor(xml.firstChild, this.components_per_url.flamingo.cursors);
			//get styles
			this.parseStyle(xml.firstChild, this.components_per_url.flamingo.styles);
			//get guides
			if (mFlamingo.guides == undefined) {
				mFlamingo.guides = new Object();
			}
			this.parseGuide(xml.firstChild, mFlamingo.guides);
		}
		//load the components                                                                                      
		//these components are responible for loading their own (child)components
		this.addComponents(xml.firstChild);
		delete xml;
	}
	public function addComponents(xml:Object):Void {
		if (typeof (xml) == "string") {
			xml = new XML(String(xml)).firstChild;
		}
		var xnode:Array = xml.childNodes;
		if (xnode.length>0) {
			for (var i:Number = xnode.length-1; i>=0; i--) {
				this.addComponent(xnode[i]);
			}
		}
	}
	/**
	* Adds a component to the flamingo framework.
	* A component has to have a prefix.
	* @param xml:Object Xml-node (or valid string representation of it) describing the component.
	* @param targetid:String [optional] Id at which the component will be registered. If omitted the id in the xml will be used. If there is no id at all, flamingo will generate a unique id.
	*/
	public function addComponent(xml:Object, targetid:String):Void {
		//trace("-------------------ADDCOMPONENT:"+targetid);
		//trace(xml);
		if (typeof (xml) == "string") {
			xml = new XML(String(xml)).firstChild;
		}
		if (xml == undefined) {
			this.doneLoading();
			return;
		}
		if (targetid == undefined) {
			for (var attr in xml.attributes) {
				if (attr.toLowerCase() == "id") {
					targetid = xml.attributes[attr];
					break;
				}
			}
			if (targetid == undefined) {
				targetid = this.getUniqueId();
			}
		}
		if (this.components[targetid].target == undefined) {
			//create e new movieclip
			var mc:MovieClip = this.mFlamingo.createEmptyMovieClip(targetid, this.moviedepth++);
			mc._visible = false;
			this.loadComponent(xml, mc, targetid);
		} else {
			//id already exists
			//load component into existing component when url's are the same
			var url:String = this.correctUrl(xml.namespaceURI+"/"+xml.localName);
			if (url == this.components[targetid].url) {
				var mc = getComponent(targetid);
				this.loadComponent(xml, mc, targetid);
			} else {
				this.raiseEvent(this, "onError", "The id '"+targetid+"' is already in use...");
				this.showError("Flamingo error", "The id '"+targetid+"' is already in use...");
				this.doneLoading();
				return;
			}
		}
	}
	/**
	* Loads a component and register it at the flamingo framework. This function should be used by components which can load other components.
	* rule 1: a component has always a prefix
	* rule 2: double ids are allowed, if the nodename and prefix are the same of the used id and the component has a 'setConfig' method, if the prefix or nodename is different, the new component will be ignored
	* @param xml:Object Xml-node describing the component.
	* @param mc:Movieclip movieclip at which the component will be loaded
	* @param targetid:String Id at which the component will be registered. 
	*/
	public function loadComponent(xml:Object, mc:MovieClip, targetid:String):Void {
		//rule1: a component has a prefix and an id 
		//rule2: a component can register only once, double ids are not allowed
		if (xml == undefined) {
			return;
		}
		if (mc == undefined) {
			return;
		}
		if (targetid == undefined) {
			return;
		}
		//                      
		if (xml instanceof XML) {
			xml = xml.firstChild;
		}
		if (xml.prefix.length == 0) {
			return;
		}
		var url:String = this.correctUrl(xml.namespaceURI+"/"+xml.localName);
		if (url.length == 0) {
			return;
		}
		if (this.components[targetid].target != undefined and this.components[targetid].url != url) {
			this.raiseEvent(this, "onError", "The id '"+targetid+"' is already in use...");
			this.showError("Flamingo error", "The id '"+targetid+"' is already in use...");
			this.doneLoading();
			return;
		}
		if (this.components[targetid].target != undefined) {
			mc = eval(this.components[targetid].target);
		}
		if (this.components[targetid].url == url and mc.setConfig != undefined) {
			//component already exists and it can be configurated
			this.components[targetid].init = false;
			this.components[targetid].xml = xml;
			mc.setConfig(xml);
			this.components[targetid].init = true;
			this.doneLoading();
		} else {
			//component new or existing component has no setConfig, so treat as new component 
			//add a reference for a component to the components object    
			//save xml, target, url and parent in components object
			//if a component is loaded, its target should be known and registered > see loadComponent_source
			if (this.components[targetid] == undefined) {
				this.components[targetid] = new Object();
			}
			this.components[targetid].init = false;
			this.components[targetid].target = "";
			this.components[targetid].url = url;
			this.components[targetid].xml = xml;
			//climb in the tree and search a good parent  
			//find component parent
			//component parent is the first parent movie that is registered in components
			//can be differ from the flash _parent!!
			var parentmc:MovieClip = mc._parent;
			while (parentmc != undefined) {
				if (parentmc._target == this.components.flamingo.target) {
					this.components[targetid].parent = "flamingo";
					break;
				}
				if (this.components[parentmc._name].target != undefined) {
					this.components[targetid].parent = parentmc._name;
					break;
				}
				parentmc = parentmc._parent;
			}
			//get custom language, style and cursor definitions
			this.loadComponent_defaults(url, targetid, mc);
		}
	}
	private function loadComponent_defaults(url:String, id:String, mc:MovieClip) {
		//load xml belonging to the component and retreive strings,styles and cursors
		//load defaults once per component
		if (this.components_per_url[url] == undefined) {
			this.components_per_url[url] = new Object();
			var flamingo = this;
			var xmlx:XML = new XML();
			xmlx.ignoreWhite = true;
			//this.components_per_url[url].xmlx = new XML();
			//this.components_per_url[url].xmlx.ignoreWhite = true;
			//this.components_per_url[url].xmlx.onLoad = function(success:Boolean) {
			xmlx.onLoad = function(success:Boolean) {
				if (success) {
					if (this.firstChild.nodeName.toLowerCase() == "flamingo") {
						//flamingo.components_per_url[url] = new Object();
						flamingo.components_per_url[url].strings = new Object();
						if (not flamingo.parseString(this.firstChild, flamingo.components_per_url[url].strings)) {
							delete flamingo.components_per_url[url].strings;
						}
						flamingo.components_per_url[url].cursors = new Object();
						if (not flamingo.parseCursor(this.firstChild, flamingo.components_per_url[url].cursors)) {
							delete flamingo.components_per_url[url].cursors;
						}
						flamingo.components_per_url[url].styles = new TextField.StyleSheet();
						if (not flamingo.parseStyle(this.firstChild, flamingo.components_per_url[url].styles)) {
							delete flamingo.components_per_url[url].styles;
						}
					} else {
						delete flamingo.components_per_url[url];
					}
				} else {
					delete flamingo.components_per_url[url];
				}
				//delete flamingo.components_per_url[url].xmlx;
				//delete xmlx;
				flamingo.loadComponent_source(url, id, mc);
			};
			xmlx.load(getNocacheName(url+".xml", this.nocache));
			//this.components_per_url[url].xmlx.load(url+".xml");
		} else {
			//defaults already loaded
			//this.loadComponent_source(url, id, mc);
			var delay = Math.floor(Math.random()*(100-0+1))+0;
			_global['setTimeout'](this, 'loadComponent_source', delay, url, id, mc);
		}
	}
	private function loadComponent_source(url:String, id:String, mc:MovieClip) {
		//load the actually component movie
		var thisObj = this;
		var mcLoader:MovieClipLoader = new MovieClipLoader();
		var lLoader:Object = new Object();
		//lLoader.onLoadProgress = function(mc:MovieClip, bytesLoaded:Number, bytesTotal:Number) {
		//thisObj.components[id].progress = "..."+Math.round(bytesLoaded/bytesTotal*100)+"%";
		//};
		lLoader.onLoadComplete = function(mc:MovieClip) {
			//At this point we can set variables of a movieclip but scripts of the clip are not yet executed yet
			//So we can set basic flamingo properties and store them at the movieclip itself
			//retreive the basic attributes from the xml and store them at the componentmovie 
			//thisObj.parseComponentXML(thisObj.components[id].xml, mc);
			//thisObj.parseGuide(thisObj.components[id].xml, mc);
			// tell flamingo where this component can be found
			thisObj.components[id].target = mc._target;
			thisObj.components.flamingo.broadcastMessage("onLoadComponent", mc);
			//if logo is visible then check if all components are loaded
		};
		lLoader.onLoadInit = function(mc:MovieClip) {
			//trace("INIT");
			// tell flamingo what  component it is and wat version
			// it's a decent habbit to start every componentmovie with these 2 variables
			//delete thisObj.components[id].progress;
			//componenent is up and running, so shout it to the world
			//if (thisObj.mFlamingo.mLogo._visible and thisObj.mFlamingo.mLogo._currentframe == 1) {
			thisObj.components[id].init = true;
			thisObj.doneLoading();
		};
		lLoader.onLoadError = function(mc:MovieClip, error:String, httpStatus:Number) {
			this.raiseEvent(this, "onError", url+".swf\n"+error);
			thisObj.showError("Flamingo", url+".swf\n"+error);
		};
		mcLoader.addListener(lLoader);
		mcLoader.loadClip(getNocacheName(url+".swf", this.nocache), mc);
	}
	private function doneLoading():Void {
		//trace("----------------------------------------")
		// this function is called after a component is loaded
		if (not this.loading) {
			return;
		}
		var nrloaded:Number = 0;
		var nrtotal:Number = 0;
		for (var id in this.components) {
			if (id != "flamingo") {
				//trace(id+this.components[id].target+","+this.components[id].init);
				if (this.components[id].init != undefined) {
					nrtotal++;
					if (this.components[id].init) {
						nrloaded++;
					}
				}
			}
		}
		if (this.mFlamingo.mLogo != undefined) {
			var p = Math.round(nrloaded/nrtotal*100);
			if (this.preloadtitle != undefined) {
				this.mFlamingo.mLogo.gotoAndStop(2);
				this.mFlamingo.mLogo.txt.htmlText = "<span class='preloadtitle'>"+this.preloadtitle+newline+" "+p+"%</span>";
			} else {
				this.mFlamingo.mLogo.txt.htmlText = "<span class='preloadtitle'>"+this.version+" "+p+"%</span>";
			}
		}
		//trace(nrloaded +"=="+nrtotal)           
		if (nrloaded == nrtotal) {
			this.loading = false;
			_global['setTimeout'](this, 'processConfig', 100);
		}
	}
	private function showLogo():Void {
		var flamingo = this;
		if (this.mFlamingo.mLogo == undefined) {
			var mc = this.mFlamingo.attachMovie("logo", "mLogo", 9997);
			mc._x = (Stage.width/2);
			mc._y = (Stage.height/2);
			mc.onPress = function() {
				flamingo.doneLoading();
			};
			mc.hitArea = _root;
			this.mFlamingo.mLogo.txt.styleSheet = this.getStyleSheet("flamingo");
		}
	}
	private function removeLogo(obj:Object):Void {
		this.mFlamingo.mLogo.onEnterFrame = function() {
			this._xscale = this._yscale=this._xscale-10;
			this._alpha = this._alpha-10;
			if (this._alpha<=0) {
				this.removeMovieClip();
			}
		};
	}
	public function parseXML(comp:Object, xml:XML) {
		var id:String = this.getId(comp);
		if (id == undefined) {
			return;
		}
		var mc = this.getComponent(id);
		if (xml == undefined) {
			xml = this.getXML(id);
		}
		//strings                 
		if (mc.strings == undefined) {
			mc.strings = new Object();
		}
		this.parseString(xml, mc.strings);
		//cursors
		if (mc.cursors == undefined) {
			mc.cursors = new Object();
		}
		this.parseCursor(xml, mc.cursors);
		//styles
		if (mc.styles == undefined) {
			mc.styles = new TextField.StyleSheet()
		}
		this.parseStyle(xml, mc.styles);
		//guides
		if (mc.guides == undefined) {
			mc.guides = new Object();
		}
		this.parseGuide(xml, mc.guides);
		//default flamingo attributes
		this.parseComponentXML(xml, mc);
	}
	/** @tag <cursor> 
	* With cursor you can add custom cursors to Flamingo. This tag can be situated in the configuration file of a component or in the configuration file of an application.
	* @hierarchy child-node of <flamingo> or child-node of <fmc:{component}>
	* @attr id Unique identifier. See the components documentation at 'Cursor id's' for supported id's.
	* @attr xoffset Offset in pixels of the cursor's hotspot. By default this is on the upperleft of the cursor. When using a swf as a cursor, the hotspot can be defined in the swf.
	* @attr yoffset See xoffset.
	* @attr url The filename of the swf, png or jpg which contains the cursor. When using relative filenames, the path is always relative to flamingo.swf
	 */
	public function parseCursor(xml:Object, cursors:Object):Boolean {
		//searches for cursornodes, loads cursors in the mCursor movie
		var b:Boolean = false;
		var nodes = xml.childNodes;
		var count = nodes.length;
		for (var i:Number = 0; i<count; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName.toLowerCase() == "cursor") {
				var id:String;
				var url:String;
				var cname:String;
				var dx:Number = 0;
				var dy:Number = 0;
				for (var attr in node.attributes) {
					var val:String = node.attributes[attr];
					switch (attr.toLowerCase()) {
					case "id" :
						id = val.toLowerCase();
						break;
					case "xoffset" :
						dx = Number(val);
						break;
					case "yoffset" :
						dy = Number(val);
						break;
					case "url" :
						url = this.correctUrl(val);
						

						
						break;
					}
				}
				if (id.length>0 and url.length>0) {
					var cursormovie:String
					for (var attr in this.mFlamingo.flamingoCursors){
						if (this.mFlamingo.flamingoCursors[attr].url == url) {
							
							cursormovie = attr
							break 
						}
					}
					
					if (cursormovie == undefined) {
						var cursormovie = "cursor_"+this.mFlamingo.flamingoCursors.getNextHighestDepth()
						var mc:MovieClip = this.mFlamingo.flamingoCursors.createEmptyMovieClip(cursormovie, this.mFlamingo.flamingoCursors.getNextHighestDepth());
						mc._x = dx;
						mc._y = dy;
						mc.url = url
						var mcLoader:MovieClipLoader = new MovieClipLoader();
						var lLoader:Object = new Object();
						lLoader.onLoadInit = function(mc:MovieClip) {
							mc._visible = false;
						};
						lLoader.onLoadError = function(mc:MovieClip, error:String, httpStatus:Number) {
							mc.removeMovieClip();
						};
						mcLoader.addListener(lLoader);
						mcLoader.loadClip(getNocacheName(url, this.nocache), mc);
					}
					
					cursors[id] = cursormovie
					
					
					b = true;
					
					
				}
			}
		}
		return (b);
	}
	/**
	* Sets a cursor for a component
	* @param id:String Id of component.
	* @param cursorid:String Id of cursor.
	* @param url:String The url of the cursor movie.
	*/
	public function setCursor(id:String, cursorid:String, url:String, xoffset:Number, yoffset:Number) {
		if (this.components[id] == undefined) {
			return;
		}
		var mc = this.getComponent(id);
		if (cursorid.length>0 and url.length>0) {
			var cname = url.split("/").join("#");
			cname = cname.split(".").join("#");
			if (mc.cursors == undefined) {
				mc.cursors = new Object();
			}
			mc.cursors[cursorid] = cname;
			if (xoffset == undefined) {
				xoffset = 0;
			}
			if (yoffset == undefined) {
				yoffset = 0;
			}
			//var b:Boolean  = true;                                 
			if (this.mFlamingo.flamingoCursors[cname] == undefined) {
				var mc:MovieClip = this.mFlamingo.flamingoCursors.createEmptyMovieClip(cname, this.mFlamingo.flamingoCursors.getNextHighestDepth());
				mc._x = xoffset;
				mc._y = yoffset;
				var mcLoader:MovieClipLoader = new MovieClipLoader();
				var lLoader:Object = new Object();
				lLoader.onLoadInit = function(mc:MovieClip) {
					mc._visible = false;
				};
				lLoader.onLoadError = function(mc:MovieClip, error:String, httpStatus:Number) {
					mc.removeMovieClip();
				};
				mcLoader.addListener(lLoader);
				mcLoader.loadClip(getNocacheName(url, this.nocache), mc);
			}
		}
	}
	/** @tag <string> 
	* With string you can add multi-language support to flamingo. This tag can be situated in the configuration file of a component or in the configuration file of an application.
	* @hierarchy child-node of <flamingo> or child-node of <fmc:{component}>
	* @example 
	* <flamingo  lang="nl" languages="en,nl" >
	* <fmc:Window>
	* <string id="title" en="title" nl="titel" />
	* </fmc:Window>
	* </flamingo>
	* @attr id Unique identifier. See the components documentation for supported string id's.
	* @attr {lang} You can define your own 'lang' attributes, followed by the correct string. See example.
	*/
	public function parseString(xml:Object, language:Object):Boolean {
		//posibilities
		//<string id="label" en="a label" nl="een label" de="ein label"/>
		//or
		//<string id="label">
		// <en>a label</en>
		//<nl>een label</nl>
		//<de>ein label</de>
		//</string>
		// or a combination of both
		//searches for language nodes and store them in a language object
		// make helperobject for loading only languages  in languagesstring
		var a:Array = this.asArray(this.languages.toLowerCase());
		var langs:Object;
		if (this.languages.length>0) {
			langs = new Object();
			for (var j:Number = 0; j<a.length; j++) {
				//langs[a[j].split(" ").join("")] = "";
				langs[a[j]] = "";
			}
		}
		var b:Boolean = false;
		var nodes = xml.childNodes;
		var count = nodes.length;
		for (var i:Number = 0; i<count; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName.toLowerCase() == "string") {
				var obj:Object = new Object();
				var id:String;
				for (var attr in node.attributes) {
					var val:String = node.attributes[attr];
					switch (attr.toLowerCase()) {
					case "id" :
						id = val.toLowerCase();
						break;
					default :
						if (this.languages.length>0) {
							//get only the languages in the languageobj
							if (langs[attr.toLowerCase()] != undefined) {
								obj[attr.toLowerCase()] = val;
							}
						} else {
							//get all
							obj[attr.toLowerCase()] = val;
						}
						break;
					}
				}
				if (id.length>0) {
					// search for next nodes
					// the next nodes in a string tag are language nodes
					for (j=0; j<node.childNodes.length; j++) {
						var l = node.childNodes[j].nodeName.toLowerCase();
						var val = node.childNodes[j].childNodes[0].nodeValue;
						if (this.languages.length>0) {
							if (langs[l] != undefined) {
								obj[l] = val;
							}
						} else {
							obj[l] = val;
						}
					}
					b = true;
					language[id] = new Object();
					language[id] = obj;
				}
				delete obj;
			}
		}
		return (b);
	}
	/**
	* Sets a language string for a component
	* @param id:String Id of component.
	* @param stringid:String Id of string.
	* @param string:String The actually string.
	* @param lang:String Language identifier.
	*/
	public function setString(id:String, stringid:String, string:String, lang:String) {
		if (this.components[id] == undefined) {
			return;
		}
		var mc = this.getComponent(id);
		if (mc.strings == undefined) {
			mc.strings = new Object();
		}
		lang = lang.toLowerCase();
		if (mc.strings[lang] == undefined) {
			mc.strings[lang] = new Object();
		}
		mc.strings[lang][stringid] = string;
	}
	/** @tag <style> 
	* With style you can css-support to flamingo. This tag can be situated in the configuration file of a component or in the configuration file of an application.
	* @hierarchy child-node of <flamingo> or child-node of <fmc:{component}>
	* @example 
	* <flamingo>
	* <style id=".tooltip" font-family="Verdana" font-size="11" color="#000088" display="block">
	* </flamingo>
	* @attr id Unique identifier. See the components documentation for supported id's.
	* @attr color Only hexadecimal color values are supported. Named colors (such as blue) are not supported. Colors are written in the following format: #FF0000.
	* @attr display  Supported values are inline, block, and none.
	* @attr font-family  A comma-separated list of fonts to use, in descending order of desirability. Any font family name can be used. If you specify a generic font name, it is converted to an appropriate device font. The following font conversions are available: mono is converted to _typewriter, sans-serif is converted to _sans, and serif is converted to _serif.
	* @attr font-size  Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	* @attr font-style Recognized values are normal and italic.
	* @attr font-weight  Recognized values are normal and bold. 
	* @attr kerning  Recognized values are true and false. Kerning is supported for embedded fonts only. Certain fonts, such as Courier New, do not support kerning. The kerning property is only supported in SWF files created in Windows, not in SWF files created on the Macintosh. However, these SWF files can be played in non-Windows versions of Flash Player and the kerning still applies.
	* @attr letter-spacing The amount of space that is uniformly distributed between characters. The value specifies the number of pixels that are added to the advance after each character. A negative value condenses the space between characters. Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	* @attr margin-left  Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	* @attr margin-right Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	* @attr text-align Recognized values are left, center, right, and justify.
	* @attr text-decoration Recognized values are none and underline.
	* @attr text-indent  Only the numeric part of the value is used. Units (px, pt) are not parsed; pixels and points are equivalent.
	*/
	private function parseStyle(xml:Object, stylesheet:Object):Boolean {
		//searches for stylenodes and stores them in the stylesheet objects
		var b:Boolean = false;
		var nodes = xml.childNodes;
		var count = nodes.length;
		for (var i:Number = 0; i<count; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName.toLowerCase() == "style") {
				var obj:Object = new Object();
				var style:String;
				for (var attr in node.attributes) {
					var val:String = node.attributes[attr];
					switch (attr.toLowerCase()) {
					case "id" :
						style = val;
						break;
					case "color" :
						obj.color = val;
						break;
					case "display" :
						obj.display = val;
						break;
					case "font-family" :
						obj.fontFamily = val;
						break;
					case "font-size" :
						obj.fontSize = val;
						break;
					case "font-style" :
						obj.fontStyle = val;
						break;
					case "font-weight" :
						obj.fontWeight = val;
						break;
					case "kerning" :
						obj.kerning = val;
						break;
					case "letter-spacing" :
						obj.letterSpacing = val;
						break;
					case "margin-left" :
						obj.marginLeft = val;
						break;
					case "margin-right" :
						obj.marginRight = val;
						break;
					case "text-align" :
						obj.textAlign = val;
						break;
					case "text-decoration" :
						obj.textDecoration = val;
						break;
					case "text-indent" :
						obj.textIndent = val;
						break;
					}
				}
				if (style.length>0) {
					b = true;
					stylesheet.setStyle(style, obj);
				}
				delete obj;
			}
		}
		return (b);
	}
	/**
	* Sets a stylestheet for a component
	* @param id:String Id of component.
	* @param styleid:String Id of stylesheet
	* @param style:Object Stylesheet object. style.color, style.font-family...etc.
	*/
	public function setStyle(id:String, styleid:String, style:Object) {
		if (this.components[id] == undefined) {
			return;
		}
		var mc = this.getComponent(id);
		if (mc.styles == undefined) {
			mc.styles = new TextField.StyleSheet();
		}
		mc.styles.setStyle(styleid, style);
	}
	/** @tag <xguide> 
	  * With xguide you can add invisible vertical lines to flamingo at which components can be aligned. This tag is situated in the configuration file of an application. There are two default yguides: "left" and "right", referering to the outer bounds of the movie.
	  * @hierarchy child-node of <flamingo> or child-node of <fmc:{component}>
	  * @example 
	  * <flamingo  lang="nl" languages="en,nl">
	  * <xguide id="x50 x="50" />
	  * <yguide id="y50 x="50" />
	  * <fmc:Window left="x50" top="y50" width="200" height="300"/>
	  * </flamingo>
	  * @attr id  Unique identifier. You can define youre own.
	  * @attr x  position, absolute (in pixels) or percentage (%). e.g.  x="50" or x="50%"
	  */
	/** @tag <yguide> 
	  * With yguide you can add invisible horizontal lines to flamingo at which components can be aligned. This tag is situated in the configuration file of an application. There are two default yguides: "top" and "bottom", referering to the outer bounds of the movie.
	  * @hierarchy child-node of <flamingo> or child-node of <fmc:{component}>
	  * @example 
	  * <flamingo  lang="nl" languages="en,nl">
	  * <xguide id="x50 x="50" />
	  * <yguide id="y50 x="50" />
	  * <fmc:Window left="x50" top="y50" width="200" height="300"/>
	  * </flamingo>
	  * @attr id  Unique identifier. You can define youre own.
	  * @attr y  position, absolute (in pixels) or percentage (%). e.g.  y="50" or y="50%"
	  */
	private function parseGuide(xml:Object, guides:Object):Boolean {
		//this function searches for xguide and yguide, makes a collection if not extist
		var b:Boolean = false;
		var len = xml.childNodes.length;
		for (var i:Number = 0; i<len; i++) {
			var node:XMLNode = xml.childNodes[i];
			var tag = node.nodeName;
			switch (tag.toLowerCase()) {
			case "yguide" :
				if (guides.y == undefined) {
					guides.y = new Object();
				}
				guides.y[node.attributes.id] = node.attributes.y;
				b = true;
				break;
			case "xguide" :
				if (guides.x == undefined) {
					guides.x = new Object();
				}
				guides.x[node.attributes.id] = node.attributes.x;
				b = true;
				break;
			}
		}
		return (b);
	}
	/** @tag <{component}>  
	  * The Flamingo Framework will parse these (default) attributes for each component in the configuration file.
	  * @attr id  Unique identifier. Usefull when components have to listen to eachother.
	  * @attr name  Name
	  * @attr width  Width of a component. In pixels or percentage. e.g. width="100"  or width="100%"
	  * @attr height  Height of a component. In pixels or percentage. e.g. height="100"  or height="100%"
	  * @attr left  Left position of a component, can be a number (left="50"), a percentage (left="50%") or a guideid (left="mx"). There are four intrinsic guides: "left", "right" and "top", "bottom". The value can be followed by a space and an offset number. Examples: left="50" , right="50%", xcenter="mx", left="mx -2", xcenter="50% 10". 
	  * @attr right  Right position of a component. See left.
	  * @attr top  Top position of a component. See left.
	  * @attr bottom Bottom position of a component. See left.
	  * @attr xcenter Vertical center position of a component. See left.
	  * @attr ycenter  Horizontal center position of a component. See left.
	  * @attr listento  Comma seperated list of component id's. See the component documentation if this attribute is supported and to which components a component can listen.
	  * @attr visible  Visiblity of the component. Reconized values: "true" and "false"
	  * @attr maxwidth  Maximum width of a component in pixels.
	  * @attr minwidth  Minimum width of a component in pixels.
	  * @attr maxheight  Maximum height of a component in pixels.
	  * @attr minheight Minimum height of a component in pixels.
	  */
	private function parseComponentXML(xml:Object, mc:MovieClip) {
		// this function get the basic attributes for a component and transform them to variables in the movieclip
		for (var attr in xml.attributes) {
			var attr:String = attr.toLowerCase();
			var val:String = xml.attributes[attr];
			switch (attr) {
			case "name" :
				mc.name = val;
				break;
			case "width" :
				mc.width = val;
				break;
			case "height" :
				mc.height = val;
				break;
			case "left" :
				mc.left = val;
				break;
			case "right" :
				mc.right = val;
				break;
			case "top" :
				mc.top = val;
				break;
			case "bottom" :
				mc.bottom = val;
				break;
			case "xcenter" :
				mc.xcenter = val;
				break;
			case "ycenter" :
				mc.ycenter = val;
				break;
			case "listento" :
				if (val.length>0) {
					mc.listento = this.asArray(val);
				}
				break;
			case "visible" :
				if (val.toLowerCase() == "false") {
					mc.visible = false;
					mc._visible = false;
				} else {
					mc.visible = true;
					mc._visible = true;
				}
				break;
			case "maxwidth" :
				mc.maxwidth = Number(val);
				break;
			case "minwidth" :
				mc.minwidth = Number(val);
				break;
			case "maxheight" :
				mc.maxheight = Number(val);
				break;
			case "minheight" :
				mc.minheight = Number(val);
				break;
			}
		}
	}
	/**
	* Shows a tooltip.
	* Tooltip disappear automatic when cursor is moved of the object.
	* @param tiptext:String Text to be shown.
	* @param object:Object Movieclip to which the tiptext belongs.
	* @param delay:Number [optional] Time between hoovering over object and showing tip.
	*/
	public function showTooltip(tiptext:String, object:Object, delay:Number):Void {
		if (tiptext.length == 0 or tiptext == undefined) {
			return;
		}
		if (delay == undefined) {
			delay = this.tooltipdelay;
		}
		var obj:Object = new Object();
		obj.tip = tiptext;
		obj.object = object;
		obj.flamingo = this;
		obj.mflamingo = this.mFlamingo;
		_global['setTimeout'](this, '_showTooltip', delay, obj);
	}
	private function _showTooltip(obj):Void {
		// interval: checks if object is hit, of not so let tooltip dissapear
		var tip = obj.tip;
		var object = obj.object;
		var flamingo = obj.flamingo;
		if (object.hitTest(_root._xmouse, _root._ymouse)) {
			var mc:MovieClip = eval(flamingo.components.flamingo.target).___mTooltip9998;
			if (mc == undefined) {
				mc = eval(flamingo.components.flamingo.target).createEmptyMovieClip("___mTooltip9998", 9998);
				mc._alpha = 0;
				var b = mc.attachMovie("tooltip_background", "mBG", 1);
				var t = mc.attachMovie("tooltip_text", "mText", 2);
				t.txt.styleSheet = flamingo.getStyleSheet("flamingo");
				mc.object = object;
				mc.onMouseMove = function() {
					if (not this.object.hitTest(_root._xmouse, _root._ymouse)) {
						this.onEnterFrame = function() {
							this._alpha = this._alpha-49;
							if (this._alpha<=0) {
								this.removeMovieClip();
							}
						};
					}
				};
				mc.onEnterFrame = function() {
					this._alpha = this._alpha+50;
					if (this._alpha>=100) {
						delete this.onEnterFrame;
					}
				};
			}
			mc.mText.txt._width = 1000;
			mc.mText.txt.htmlText = "<span class='tooltip'>"+tip+"</span>";
			mc.mText.txt._width = mc.mText.txt.textWidth+5;
			mc.mBG._width = mc.mText.txt.textWidth+5;
			mc.mText.txt._height = mc.mText.txt.textHeight+5;
			mc.mBG._height = mc.mText.txt.textHeight+2;
			if (_root._xmouse+mc._width>Stage.width) {
				mc._x = Stage.width-mc._width-5;
			} else {
				mc._x = _xmouse+8;
			}
			if (_root._ymouse+mc._height+20>Stage.height) {
				mc._y = Stage.height-mc._height-5;
			} else {
				mc._y = _ymouse+20;
			}
		}
	}
	/**
	* Let tooltip disappear.
	*/
	public function hideTooltip():Void {
		this.mFlamingo.___mTooltip9998.removeMovieClip();
	}
	/**
	* Gets the internal Flamingo cursorid of a cursor of a component.
	* @param comp:Object  Id or MovieClip representing the component.
	* @param cursorid:String Id of the cursor used in the configuration file. See for supported cursor ids' the component documentation.
	* @return String Id of a cursor.
	*/
	public function getCursorId(comp:Object, cursorid:String):String {
		var id:String = this.getId(comp);
		var mc = this.getComponent(id);
		var url = this.components[id].url;
		var cursor = mc.cursors[cursorid];
		if (cursor == undefined) {
			cursor = this.components_per_url[url].cursors[cursorid];
		}
		return cursor;
	}
	/**
	* Shows custom cursor.
	* A cursor is a flash movie which will be preloaded when the configuration file is loaded.
	* It belongs to a component and is identified by an internal id. This id can be obtained by 'getCursorId'.
	* @param cursorid:String identifier used in configuration file.
	*/
	public function showCursor(cursorid:String):Void {
		//var id = this.getId(comp);
		//var url = this.components[id].url;
		//var cursor = this.components_per_url[url].cursor[cursorid];
		if (cursorid == undefined) {
			return;
		}
		if (cursorid.length == 0) {
			return;
		}
	
		var mc = this.mFlamingo.flamingoCursors[cursorid];
		if (mc != undefined) {
			this.mFlamingo.flamingoCursors.getInstanceAtDepth(0)._visible = false;
			this.mFlamingo.flamingoCursors.onMouseMove = function():Void  {
				this._x = _xmouse;
				this._y = _ymouse;
				updateAfterEvent();
			};
			this.mFlamingo.flamingoCursors._x = _xmouse;
			this.mFlamingo.flamingoCursors._y = _ymouse;
			mc.swapDepths(0);
			mc._visible = true;
			this.mFlamingo.flamingoCursors._visible = true;
			Mouse.hide();
		}
	}
	/** 
	* Hides custom cursor.
	*/
	function hideCursor():Void {
		this.mFlamingo.flamingoCursors._visible = false;
		delete this.mFlamingo.flamingoCursors.onMouseMove;
		Mouse.show();
	}
	/**
	* Shows an simple error window.
	* Window will disappear after timeout or when the user clicks on it.
	* @param title:String Window title.
	* @param error:String Error text.
	* @param timeout:Number [optional] The window will disappear after this time.
	*/
	function showError(title:String, error:String, timeout:Number):Void {
		var mc:MovieClip = this.mFlamingo.attachMovie("error", "mError", 9997);
		mc._x = Stage.width/2;
		//- mc._width/2;
		mc._y = Stage.height/2;
		//- mc._height/2;
		mc.title.htmlText = title;
		mc.error.htmlText = error;
		mc.useHandCursor = false;
		mc.onPress = function() {
		};
		mc.onMouseDown = function() {
			this.removeMovieClip();
		};
		if (timeout>0) {
			var obj:Object = new Object();
			obj.mc = this.mFlamingo.mError;
			_global['setTimeout'](this, 'closeError', timeout, obj);
		}
	}
	private function closeError(obj) {
		obj.mc.removeMovieClip();
	}
	//* Sets the skin.
	//* @param skin:String skin string.
	public function setSkin(skin:String):Void {
		this.skin = skin;
		this.components.flamingo.broadcastMessage("onSetSkin", skin);
	}
	//Gets the skin
	// @return skin string
	public function getSkin():String {
		return (this.skin);
	}
	/**
	* Sets the language. This method will invoke the onSetLanguage event.
	* @param lang:String Language string.
	*/
	public function setLanguage(lang:String):Void {
		this.lang = lang;
		this.components.flamingo.broadcastMessage("onSetLanguage", lang);
	}
	/**
	* Gets the language. 
	* @return String Language string.
	*/
	public function getLanguage():String {
		return (this.lang);
	}
	/**
	* Gets the real component parent of a component. 
	* This parent is not the same as the 'flash' _parent parent.
	* @param comp:Object  Id or MovieClip representing the component.
	* @return MovieClip The component parent.
	*/
	public function getParent(comp:Object):MovieClip {
		var id = this.components[this.getId(comp)].parent;
		return (getComponent(id));
	}
	/**
	* Removes a component and delete all its data in the repository.
	* @param comp:Object  Id or MovieClip representing the component.
	*/
	public function killComponent(comp:Object):Void {
		var id:String = this.getId(comp);
		if (id == undefined) {
			return;
		}
		//determine target movie                                                
		if (this.components[id].killtarget != undefined) {
			var mc = eval(this.components[id].killtarget);
		} else {
			var mc = eval(this.components[id].target);
		}
		//give a change for components to clean things up 
		this.raiseEvent(this, "onKillComponent", mc);
		//remove children ids from the components object 
		for (var c_id in this.components) {
			if (this.components[c_id].parent == id) {
				this.killComponent(c_id);
			}
		}
		//removelisteners
		for (var listenerid in this.components[id]._addedlisteners) {
			for (var i = 0; i<this.components[id]._addedlisteners[listenerid].length; i++) {
				this.removeListener(this.components[id]._addedlisteners[listenerid][i], listenerid);
			}
		}
		//check  if there are other components with same url
		// if not remove reference from components_per_url and remove cursors
		var lastcomp:Boolean = true;
		var url = this.getUrl(id);
		for (var c_id in this.components) {
			if (c_id != id) {
				if (this.components[c_id].url == url) {
					lastcomp = false;
					break;
				}
			}
		}
		if (lastcomp) {
			delete this.components_per_url[url];
		}
		//remove clip                                                
		mc.removeMovieClip();
		//finaly delete entrance in repository
		delete this.components[id];
	}
	/**
	* Gets a component by its identifier.
	* @param id:String Id of a component.
	* @return MovieClip The component.
	*/
	public function getComponent(id:String):MovieClip {
		return eval(this.components[id].target);
	}
	/** 
	* Gets the url of a component.
	* @param comp:Object  Id or MovieClip representing the component.
	* @return String Url of component.
	*/
	public function getUrl(comp:Object):String {
		var url = this.components[this.getId(comp)].url;
		return (url);
	}
	/** 
	* Gets the id of a component.
	* @param comp:Object Id or MovieClip representing the component.
	* @return String Id of component.
	*/
	public function getId(comp:Object):String {
		if (comp == this) {
			return ("flamingo");
		}
		switch (typeof (comp)) {
		case "string" :
			return String(comp);
			break;
		case "movieclip" :
			for (var id in this.components) {
				if (this.components[id].target == comp._target) {
					return (id);
				}
			}
			return;
			break;
		default :
			return;
			break;
		}
	}
	//function getError(comp:Object):String {
	//return (this.components[this.getId(comp)].error);
	//}
	//function setError(comp:Object, error:String) {
	//this.components[this.getId(comp)].error = error;
	//}
	/** 
	* Gets a reference of the xml belonging to a component.
	* @param comp:Object  Id or MovieClip representing the component.
	* @return XML 
	*/
	function getXML(comp:Object):XML {
		return (this.components[this.getId(comp)].xml);
	}
	/** 
	* Deletes the xml of a component from the repository. 
	* @param comp:Object Id or MovieClip representing the component.
	*/
	public function deleteXML(comp:Object):Void {
		delete this.components[this.getId(comp)].xml;
	}
	/** 
	* Removes a listener of (a) component(s)
	* @param listener:Object Listener object.
	* @param listento:Object MovieClip or componentid or array of componentids.
	* @see addListener
	*/
	public function removeListener(listener:Object, listento:Object, caller:Object):Void {
		var id:String;
		if (listento == this) {
			id = "flamingo";
		} else if (listento == undefined) {
			id = "flamingo";
		} else {
			switch (typeof (listento)) {
			case "object" :
				for (var i = 0; i<listento.length; i++) {
					this.removeListener(listener, listento[i]);
				}
				return;
				break;
			case "string" :
				id = String(listento);
				break;
			case "movieclip" :
				if (listento == this.mFlamingo) {
					id = "flamingo";
				} else {
					id = getId(listento);
					//search for the main movie of the parent
					//the main movie always extists in components
					//while (this.components[id] == undefined) {
					//listento = listento._parent;
					//id = listento._name;
					//if (listento == undefined) {
					//break;
					//}
					//}
				}
				break;
			}
		}
		if (id == undefined) {
			return;
		}
		this.components[id].removeListener(listener);
		if (caller != undefined) {
			//remove a reference of the functions at the component repository
			//if component get killed  the listeners first based on this list
			var callerid = getId(caller);
			for (var i = 0; i<this.components[callerid]._addedlisteners[id].length; i++) {
				if (this.components[callerid]._addedlisteners[id][i] == listener) {
					this.components[callerid]._addedlisteners[id].splice(i);
					break;
				}
			}
		}
	}
	/** 
	* Adds a listener to (a) component(s).
	* @param listener:Object Listener object.
	* @param listento:Object MovieClip or componentid or array of componentids.
	* @see removeListener
	*/
	public function addListener(listener:Object, listento:Object, caller:Object):Void {
		var id:String;
		if (listento == this) {
			id = "flamingo";
		} else if (listento == undefined) {
			id = "flamingo";
		} else {
			switch (typeof (listento)) {
			case "object" :
				for (var i = 0; i<listento.length; i++) {
					this.addListener(listener, listento[i]);
				}
				return;
				break;
			case "string" :
				id = String(listento);
				break;
			case "movieclip" :
				if (listento == this.mFlamingo) {
					id = "flamingo";
				} else {
					id = getId(listento);
					//search for the main movie of the parent
					//the main movie always extists in components
					//while (this.components[id] == undefined) {
					//listento = listento._parent;
					//id = listento._name;
					//if (listento == undefined) {
					//break;
					//}
					//}
				}
				break;
			}
		}
		if (id == undefined) {
			return;
		}
		if (this.components[id] == undefined) {
			//Just make a reference 
			this.components[id] = new Object();
			//trace(">"+listento+"<");
			//trace(id);
			//this.showError("Warning", "a component wants to listen to <b>'"+id+"'</b>"+newline+"Unfortunaly <b>"+id+"</b> doesn't exist"+newline+"Please check your ini.xml...");
			//return;
		}
		if (this.components[id].addListener == undefined) {
			AsBroadcaster.initialize(this.components[id]);
		}
		this.components[id].addListener(listener);
		if (caller != undefined) {
			//store a reference of the functions at the component repository
			//if component get killed  the listeners first based on this list
			var callerid = getId(caller);
			if (this.components[callerid]._addedlisteners == undefined) {
				this.components[callerid]._addedlisteners = new Object();
			}
			if (this.components[callerid]._addedlisteners[id] == undefined) {
				this.components[callerid]._addedlisteners[id] = new Array();
			}
			this.components[callerid]._addedlisteners[id].push(listener);
		}
	}
	/** 
	* Fires an event for a component.
	* @param comp:Object MovieClip or componentid.
	* @param event:String  Eventname.
	* @param arg0:?  [optional] argument
	* @param arg1:?  [optional] argument...etc
	* @see removeListener
	* @see addListener
	*/
	public function raiseEvent(comp:Object, event:String) {
		var id:String = this.getId(comp);
		//remove first element (=comp) from arguments array 
		arguments.shift();
		//first element of arguments is now: event
		this.components[id].broadcastMessage.apply(this.components[id], arguments);
		//this.components[id].broadcastMessage(event, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
		//trace("-------------------------------------------------");
		//trace(id+":"+event);
		if (this.useexternalinterface) {
			for (var i = 0; i<arguments.length; i++) {
				//if (typeof (arguments[i]) == "movieclip") {
				//arguments[i] = this.getId(arguments[i]);
				//} else {
				arguments[i] = this.objects2Javascript(arguments[i]);
				//this.traceObj(arguments[i])
				//}
			}
			var e = arguments.shift();
			if (id == "flamingo") {
				e = this.flamingoid+"_"+e;
			} else {
				e = id+"_"+e;
			}
			arguments.unshift(e);
			//var s
			//for (var i = 0; i < arguments.length ; i++){
			//if (i ==0){
			//s = "raiseEvent:"+arguments[i]
			//}else{
			//s += ","+arguments[i]
			//}
			//}
			//trace(s)
			ExternalInterface.call.apply(null, arguments);
			delete arguments;
		}
	}
	private function traceObj(obj:Object) {
		if (typeof (obj) == "object") {
			for (var attr in obj) {
				trace(attr+":");
				traceObj(obj[attr]);
			}
		} else {
			trace(">"+obj);
		}
	}
	private function objects2Javascript(obj:Object):Object {
		var new_obj;
		if (typeof (obj) == "movieclip") {
			new_obj = this.getId(obj);
		} else if (typeof (obj) == "object") {
			for (var attr in obj) {
				if (new_obj == undefined) {
					if (obj.length and obj.splice and obj.sort) {
						//probably an array
						new_obj = new Array();
					} else {
						new_obj = new Object();
					}
				}
				//turn all attributenames (that are not numeric) into quoted attributenames                                                                                                               
				if (isNaN(attr)) {
					new_obj["'"+attr+"'"] = objects2Javascript(obj[attr]);
				} else {
					new_obj[attr] = objects2Javascript(obj[attr]);
				}
			}
		}
		if (new_obj == undefined) {
			return obj;
		} else {
			return new_obj;
		}
	}
	/** 
	* Get simular components.
	* @param comp:Object MovieClip or componentid.
	* @param sameurl:Boolean [optional] default=true  See example.
	* @param sameparent:Boolean  [optional]  default=false See example.
	* @return  Object List of same components.
	* @example flamingo.getSameComponents(this) > Get all the components in the application with the same url.
	* flamingo.getSameComponents(this,true,true) > Get all the components with the same url and the same component parent.
	* flamingo.getSameComponents(this,false,true) > Get all components with the same component parent.
	* flamingo.getSameComponents(this,false,false) > returns nothing.
	*/
	public function getSameComponents(comp:Object, sameurl:Boolean, sameparent:Boolean):Object {
		if (sameurl == undefined) {
			sameurl = true;
		}
		if (sameparent == undefined) {
			sameparent = false;
		}
		if (not sameurl and not sameparent) {
			return;
		}
		var a:Object = new Object();
		var compid = this.getId(comp);
		var url = this.components[compid].url;
		var parent = this.components[compid].parent;
		for (var id in this.components) {
			if (id<>compid) {
				if (sameurl and sameparent) {
					if (this.components[id].url == url and this.components[id].parent == parent) {
						a[id] = eval(this.components[id].target);
					}
				} else if (sameurl) {
					if (this.components[id].url == url) {
						a[id] = eval(this.components[id].target);
					}
				} else {
					if (this.components[id].parent == parent) {
						a[id] = eval(this.components[id].target);
					}
				}
			}
		}
		return (a);
	}
	/**
	* Gets a string from the repository corresponding to the language setting.
	* @param comp:Object MovieClip or componentid.
	* @param stringid:String  Identifier in the configuration files, see component documentation for supported id's
	* @param defaultstring:String [optional] defaultstring if no match is found.
	* @param lang:String  [optional] language setting.
	* @return String String belonging to language setting and the stringid.
	*/
	public function getString(comp:Object, stringid:String, defaultstring:String, lang:String):String {
		// this function gets a language string (if exists) from the language objects in the flamingo-core
		var id:String = this.getId(comp);
		var mc = this.getComponent(id);
		if (lang == undefined) {
			lang = this.lang;
		}
		//1 search in langauge object of component                                                                                                                                                                                                                  
		var strings:Object = mc.strings;
		if (strings != undefined) {
			var s = strings[stringid.toLowerCase()][lang.toLowerCase()];
			if (s == undefined) {
				for (var l in strings[stringid.toLowerCase()]) {
					s = strings[stringid.toLowerCase()][l];
				}
			}
			if (s != undefined) {
				return (s);
			}
		}
		//2 search string in main language object                                                                                                                                                                                                                                                                                                                                          
		var url = this.components[id].url;
		var strings = this.components_per_url[url].strings;
		if (strings == undefined) {
			return;
		}
		var s = strings[stringid.toLowerCase()][lang.toLowerCase()];
		if (s == undefined) {
			for (var l in strings[stringid.toLowerCase()]) {
				s = strings[stringid.toLowerCase()][l];
			}
		}
		if (s == undefined) {
			s = defaultstring;
		}
		return (s);
	}
	//--------------------------------------------------------
	//the following functions are functions for positioning a movie clip
	//--------------------------------------------------------
	// these functions helps positioning a movie based on some extra custom position- and size-properties
	// the position properties are:
	// left, right, xcenter, top, bottom, ycenter
	// a position property is a string with syntax: "{guideid} position" 
	// examples:left="50" left="guidemx -5"  left="75%" right="right -10"
	// position is a number(absolute) or a percentage(relative)
	// the size properties are:
	// width, height
	// a size property is a string.
	// examples: width="20" width="50%"
	// calculation of the position and size is based on the size of the parentmovie
	// and the availability of the extra poperties
	// the parent movie is the flash _parent!!!!
	// the folowing rules are aplied:
	// when available:
	// 1. left and width -> _x = left, _width = width
	// 2. right and width -> _x = right-width, _width = width
	// 3. xcenter and width -> _x = xcenter - (width/2), _width = width
	// 4. left and right  -> _x = _left, _width = right-left
	// 5. left and xcenter -> _x = left,  _width = (xcenter-left)* 2
	// 6. xcenter and right -> _width = (right-center) *2, _x = right - (_width/2)
	// 7 left -> _x = left, _width = _width
	// 8 right -> _x = right -_width, _width = _width
	// 9 xcenter ->  _x = xcenter - (_width/2) , _width = _width
	// 10 width ->  _x = _x, _width = width
	//  same rules are applied to top, bottom, ycenter and height
	/**
	* Gets a position of a component.
	* @param comp:Object MovieClip or componentid.
	* @param parent:MovieClip [optional] parent MovieClip,  default is the flash _parent
	* @return  Object Rect, a rect is an object with the properties; x, y, width, height
	* @example 
	* function resize(){
	* var rect:Object = flamingo.getPosition(this)
	* this._x = rect.x
	* this._y = rect.y
	* this._width = rect.width
	* this._height = rect.height
	* }
	*/
	public function getPosition(comp:Object, parent:MovieClip):Object {
		var mc:MovieClip = this.getComponent(this.getId(comp));
		//mc = comp   
		var rect:Object = new Object();
		var ps = getXPS(mc, parent);
		rect.x = ps.x;
		rect.width = ps.width;
		//correct with max-, minwidth
		if (mc.maxwidth != undefined) {
			rect.width = Math.min(rect.width, mc.maxwidth);
		}
		if (mc.minwidth != undefined) {
			rect.width = Math.max(rect.width, mc.minwidth);
		}
		var ps = getYPS(mc, parent);
		rect.y = ps.y;
		rect.height = ps.height;
		//correct with max-, minheight
		if (mc.maxheight != undefined) {
			rect.height = Math.min(rect.height, mc.maxheight);
		}
		if (mc.minheight != undefined) {
			rect.height = Math.max(rect.height, mc.minheight);
		}
		rect.x = Math.round(rect.x);
		rect.width = Math.round(rect.width);
		rect.y = Math.round(rect.y);
		rect.height = Math.round(rect.height);
		return (rect);
	}
	/**
	* Positions a component.
	* @param comp:Object MovieClip or componentid.
	* @param parent:MovieClip [optional] parent MovieClip,  default _parent
	* @see getPosition
	*/
	public function position(comp:Object, parent:MovieClip):Void {
		var mc:MovieClip = this.getComponent(this.getId(comp));
		var r:Object = this.getPosition(mc, parent);
		mc._x = r.x;
		mc._y = r.y;
		mc._width = r.width;
		mc._height = r.height;
	}
	private function getXPS(mc:MovieClip, parent:MovieClip):Object {
		if (parent == undefined) {
			var parent = mc._parent;
		}
		var pw = parent.__width;
		if (pw == undefined) {
			pw = parent._width;
		}
		if (pw == undefined) {
			pw = Stage.width;
		}
		var pt:Object = new Object();
		if (mc.left.length>0 and mc.width.length>0) {
			//trace("x1")
			pt.width = getAbs(mc.width, pw);
			pt.x = convertPosition(mc.left, pw, parent.guides.x);
			return (pt);
		}
		if (mc.right.length>0 and mc.width.length>0) {
			//trace("x2")
			pt.width = getAbs(mc.width, pw);
			pt.x = convertPosition(mc.right, pw, parent.guides.x)-pt.width;
			return (pt);
		}
		if (mc.xcenter.length>0 and mc.width.length>0) {
			//trace("x3")
			pt.width = getAbs(mc.width, pw);
			pt.x = convertPosition(mc.xcenter, pw, parent.guides.x)-(pt.width/2);
			return (pt);
		}
		if (mc.left.length>0 and mc.right.length>0) {
			//trace("x4")
			pt.x = convertPosition(mc.left, pw, parent.guides.x);
			pt.width = convertPosition(mc.right, pw, parent.guides.x)-pt.x;
			return (pt);
		}
		if (mc.left.length>0 and mc.xcenter.length>0) {
			//trace("x5")
			pt.x = convertPosition(mc.left, pw, parent.guides.x);
			pt.width = (convertPosition(mc.xcenter, pw, parent.guides.x)-pt.x)*2;
			return (pt);
		}
		if (mc.right.length>0 and mc.xcenter.length>0) {
			//trace("x6")
			var r = convertPosition(mc.right, pw, parent.guides.x);
			var c = convertPosition(mc.xcenter, pw, parent.guides.x);
			pt.width = (r-c)*2;
			pt.x = r-(pt.width/2);
			return (pt);
		}
		if (mc.left.length>0) {
			//trace("x7");
			pt.x = convertPosition(mc.left, pw, parent.guides.x);
			pt.width = mc._width;
			return (pt);
		}
		if (mc.right.length>0) {
			//trace("x8")
			pt.x = convertPosition(mc.right, pw, parent.guides.x)-mc._width;
			pt.width = mc._width;
			return (pt);
		}
		if (mc.xcenter.length>0) {
			//trace("x9")
			pt.x = convertPosition(mc.xcenter, pw, parent.guides.x)-(mc._width/2);
			pt.width = mc._width;
			return (pt);
		}
		if (mc.width.length>0) {
			//trace("x10")
			pt.x = mc._x;
			pt.width = getAbs(mc.width, pw);
			return (pt);
		}
		pt.x = mc._x;
		pt.width = mc._width;
		return (pt);
	}
	private function getYPS(mc:MovieClip, parent:MovieClip):Object {
		if (parent == undefined) {
			var parent = mc._parent;
		}
		var pt:Object = new Object();
		var ph = parent.__height;
		if (ph == undefined) {
			ph = parent._height;
		}
		if (ph == undefined) {
			ph = Stage.height;
		}
		if (mc.top.length>0 and mc.height.length>0) {
			pt.height = getAbs(mc.height, ph);
			pt.y = convertPosition(mc.top, ph, parent.guides.y);
			return (pt);
		}
		if (mc.bottom.length>0 and mc.height.length>0) {
			pt.height = getAbs(mc.height, ph);
			pt.y = convertPosition(mc.bottom, ph, parent.guides.y)-pt.height;
			return (pt);
		}
		if (mc.ycenter.length>0 and mc.height.length>0) {
			pt.height = getAbs(mc.height, ph);
			pt.y = convertPosition(mc.ycenter, ph, parent.guides.y)-(pt.height/2);
			return (pt);
		}
		if (mc.top.length>0 and mc.bottom.length>0) {
			pt.y = convertPosition(mc.top, ph, parent.guides.y);
			pt.height = convertPosition(mc.bottom, ph, parent.guides.y)-pt.y;
			return (pt);
		}
		if (mc.top.length>0 and mc.ycenter.length>0) {
			pt.y = convertPosition(mc.top, ph, mc._parent.guides.y);
			pt.height = (convertPosition(mc.ycenter, ph, parent.guides.y)-pt.y)*2;
			return (pt);
		}
		if (mc.bottom.length>0 and mc.ycenter.length>0) {
			var b = convertPosition(mc.bottom, ph, parent.guides.y);
			var c = convertPosition(mc.ycenter, ph, parent.guides.y);
			pt.height = (b-c)*2;
			pt.y = b-(pt.width/2);
			return (pt);
		}
		if (mc.top.length>0) {
			pt.y = convertPosition(mc.top, ph, parent.guides.y);
			pt.height = mc._height;
			return (pt);
		}
		if (mc.bottom.length>0) {
			pt.y = convertPosition(mc.bottom, ph, parent.guides.y)-mc._height;
			pt.height = mc._height;
			return (pt);
		}
		if (mc.ycenter.length>0) {
			//trace("y9")
			pt.y = convertPosition(mc.ycenter, ph, parent.guides.y)-(mc._height/2);
			pt.height = mc._height;
			return (pt);
		}
		if (mc.height.length>0) {
			pt.y = mc._y;
			pt.height = getAbs(mc.height, ph);
			return (pt);
		}
		pt.y = mc._y;
		pt.height = mc._height;
		return (pt);
	}
	private function convertPosition(pos:String, abs:Number, guides:Object):Number {
		if (pos == undefined or pos.length == 0) {
			return;
		}
		// determine second element, which should be a offset in pixels                                                                                                                                                                                                                                                                                                                                                                           
		var offset:Number = 0;
		if (pos.indexOf(" ")>0) {
			var a:Array = pos.split(" ");
			pos = a[0];
			offset = Number(a[1]);
			if (isNaN(offset)) {
				offset = 0;
			}
		}
		// calculate first element, which  can be a number, a percentage or a guide                                                                                                                                                                                                                                                                                                                                                                           
		var n:Number = 0;
		if (isNaN(pos)) {
			if (pos.substr(pos.length-1, 1) == "%") {
				n = getAbs(pos, abs);
			} else {
				switch (pos.toLowerCase()) {
				case "bottom" :
					n = abs;
					break;
				case "right" :
					n = abs;
					break;
				default :
					pos = guides[pos];
					if (pos.length>0) {
						n = convertPosition(pos, abs, guides);
					}
					break;
				}
			}
		} else {
			n = Number(pos);
		}
		return (n+offset);
	}
	private function getAbs(rel:String, abs:Number):Number {
		//calculates absolute position  from a relative string
		//getAbs("50%", 100) returns 50
		var n:Number;
		if (rel.substr(rel.length-1, 1) == "%") {
			n = Number(rel.substr(0, rel.length-1));
			n = (abs*n/100);
		} else if (not isNaN(rel)) {
			n = Number(rel);
		}
		return (n);
	}
	/**
	* Gets the stylesheet object of a component.
	* @param comp:Object MovieClip or componentid.
	* @return Object StyleSheet.
	*/
	public function getStyleSheet(comp:Object):Object {
		var id:String = this.getId(comp);
		var url:String = this.components[id].url;
		//get the default stylesheet
		var stylesheet = new TextField.StyleSheet();
		var stylenames:Array = this.components_per_url[url].styles.getStyleNames();
		for (var i = 0; i<stylenames.length; i++) {
			var stylename = stylenames[i];
			var styleobj:Object = this.components_per_url[url].styles.getStyle(stylename);
			stylesheet.setStyle(stylename, styleobj);
		}
		var mc = this.getComponent(id);
		var stylenames:Array = mc.styles.getStyleNames();
		for (var i = 0; i<stylenames.length; i++) {
			var stylename = stylenames[i];
			var styleobj:Object = mc.styles.getStyle(stylename);
			stylesheet.setStyle(stylename, styleobj);
		}
		return (stylesheet);
	}
	/** 
	* Correct the targetreference of a component in the repository.
	* Component are movieclips that are loaded by flamingo with the loadMovie method.
	* By default flamingo assumes that the loaded movieclip is actually the component.
	* When you make components by using subclasses of MovieClips than things are a bit different.
	* In that case the component movieclip can be situated one or more levels deeper and a correction is necesarry.
	* @param from:Object MovieClip or componentid representing the default location at which flamingo assumes the component is loaded.
	* @param to:Movieclip MovieClip representing the correct location of the component.
	* @example 
	* flamingo.correctTarget(this._parent, this)
	*/
	public function correctTarget(from:Object, to:MovieClip):Void {
		var id = this.getId(from);
		from = eval(this.components[id].target);
		this.components[id].killtarget = this.components[id].target;
		this.components[id].target = to._target;
	}
	/** 
	* Gets every property of loaded components by using the component-id and propertyname.
	* This function can be accessed by Javascript when the 'useexternalinterface' attribute is set to true.
	* For javascript this method is aliased as 'get'.
	* @param id:String Id of a component.
	* @param prop:String String representation of property.
	* @return Object Value of property.
	* @example 	
	* flamingo.getProperty("map", "width");
	*/
	public function getProperty(id:String, prop:String):Object {
		if (id == undefined) {
			return;
		}
		if (prop == undefined) {
			return;
		}
		var comp = this.components[id].target;
		if (comp == undefined) {
			return;
		}
		if (id.toLowerCase() == "flamingo") {
			return this[prop];
		} else {
			return eval(comp)[prop];
		}
	}
	/** 
	* Sets every property of loaded components by using the component-id and propertyname.
	* This function can be accessed by Javascript when the 'useexternalinterface' attribute is set to true.
	* For javascript this method is aliased as 'set'. 
	* @param id:String Id of a component.
	* @param prop:String String representation of property.
	* @param value:Object Value of property.
	* @example 	
	* flamingo.setProperty("myMap", "width", "100%");
	*/
	public function setProperty(id:String, prop:String, value:Object):Void {
		if (id == undefined) {
			return;
		}
		if (prop == undefined) {
			return;
		}
		if (value == undefined) {
			return;
		}
		var comp = this.components[id].target;
		if (comp == undefined) {
			return;
		}
		if (id.toLowerCase() == "flamingo") {
			this[prop] = value;
		} else {
			eval(comp)[prop] = value;
		}
	}
	/**
	* Converts a string list into an array. Null values are removed.
	* @param list:String String representing a list.
	* @param sep:String [optional] Seperator, default = ",".
	* @return Array
	*/
	public function asArray(list:String, sep:String):Array {
		if (sep == undefined) {
			sep = ",";
		}
		var a = list.split(sep);
		for (var i = 0; i<a.length; i++) {
			a[i] = trim(a[i]);
			if (a[i].length == 0) {
				a.splice(i, 1);
				i--;
			}
		}
		return a;
	}
	/**
	* Trims leading and trailing spaces, returns, tabs, and line feeds from a string.
	* @param s:String
	* @return String
	*/
	public function trim(s:String):String {
		return lTrim(rTrim(s));
	}
	/**
	* Trims leading spaces, returns, tabs, and line feeds  from a string.
	* @param s:String
	* @return String
	*/
	public function lTrim(s:String):String {
		var TAB = 9;
		var LINEFEED = 10;
		var CARRIAGE = 13;
		var SPACE = 32;
		var i = 0;
		while (s.charCodeAt(i) == SPACE || s.charCodeAt(i) == CARRIAGE || s.charCodeAt(i) == LINEFEED || s.charCodeAt(i) == TAB) {
			i++;
		}
		return s.substring(i, s.length);
	}
	/**
	* Trims trailing spaces, returns, tabs, and line feeds from a string.
	* @param s:String
	* @return String
	*/
	public function rTrim(s:String):String {
		var TAB = 9;
		var LINEFEED = 10;
		var CARRIAGE = 13;
		var SPACE = 32;
		var i = s.length-1;
		while (s.charCodeAt(i) == SPACE || s.charCodeAt(i) == CARRIAGE || s.charCodeAt(i) == LINEFEED || s.charCodeAt(i) == TAB) {
			i--;
		}
		return s.substring(0, i+1);
	}
	/** 
	* Calls every method of the loaded components by using the component-id and methodname.
	* This function can be accessed by Javascript when the 'useexternalinterface' attribute is set to true.
	* For javascript this method is aliased as 'call'. 
	* @param id:String Id of a component.
	* @param method:String String representation of method to be called.
	* @param args:Object one or more arguments the method demands. See documentation.
	* @return whatever the method returns. See documentation.
	* @example 	
	* flamingo.callMethod("map", "moveToExtent", {minx:203044, miny:607628, maxx:218802, maxy:614073}, 0);
	*/
	public function callMethod(id:String, method:String):Object {
		if (id == undefined) {
			return;
		}
		arguments.shift();
		if (method == undefined) {
			return;
		}
		arguments.shift();
		var comp = this.components[id].target;
		if (comp == undefined) {
			return;
		}
		if (id.toLowerCase() == "flamingo") {
			if (this[method] == undefined) {
				return;
			}
			var r = this[method].apply(this, arguments);
			if (typeof (r) == "movieclip") {
				r = this.getId(r);
			}
			return r;
		} else {
			var func = eval(comp+"."+method);
			if (func == undefined) {
				return;
			}
			var r = func.apply(eval(comp), arguments);
			if (typeof (r) == "movieclip") {
				r = this.getId(r);
			}
			return r;
		}
	}
	//events	
	/**
	* Fires when the language is changed.
	* @param lang:String language which is set.
	*/
	public function onSetLanguage(lang:String):Void {
	}
	/**
	* Fires when the stage is resized.
	*/
	public function onResize():Void {
	}
	/**
	* Fires when a component is removed
	* @param  mc:MovieClip The component to be killed.
	*/
	public function onKillComponent(mc:MovieClip):Void {
	}
	/**
	* Fires when an error occurs.
	* @param error:String Error message.
	*/
	public function onError(error:String):Void {
	}
	/**
	* Fires when a component is loaded.
	* @param mc:MovieClip The loaded component.
	*/
	public function onLoadComponent(mc:MovieClip):Void {
	}
	/**
	* Fires when flamingo initializes.
	*/
	public function onInit():Void {
	}
	/**
	* Fires when a XML is loaded.
	* @param file:String The loaded file.
	*/
	public function onLoadXMLPool(file:String):Void {
	}
	/**
	* Fires when a configuration file is loaded or set
	*/
	public function onLoadConfig():Void {
	}

	/**
	* Returns an unigue unused identifier.
	* @return  String Id
	*/
	public function getUniqueId():String {
		var id:String = "fmc_"+this.uniqueid;
		var found:Boolean = false;
		while (not found) {
			if (this.components[id] == undefined) {
				found = true;
				this.uniqueid++;
			} else {
				id = "fmc_"+this.uniqueid++;
			}
		}
		//store id for use
		return (id);
	}
	/**
	* Returns the version of a component.
	* @param comp:Object MovieClip or componentid.
	* @return String Version.
	*/
	public function getVersion(comp:Object):String {
		var id:String = this.getId(comp);
		if (id == "flamingo") {
			s = this.version;
		} else {
			var s:String = this.getComponent(id).version;
		}
		return (s);
	}
	/**
	* Returns list of components ids.
	* @return Array List of components ids.
	*/
	public function getComponents():Array {
		var a:Array = new Array();
		for (var id in this.components) {
			a.push(id);
		}
		a.reverse();
		return a;
	}
	
	public function print() {
		//point=0.35mm
		//pixel=0.28mm
		// create PrintJob object
		var my_pj:PrintJob = new PrintJob();
		// display print dialog box, but only initiate the print job
		// if start returns successfully.
		if (my_pj.start()) {
			// use a variable to track successful calls to addPage
			var pagesToPrint:Number = 0;
			// add specified area to print job
			// repeat once for each page to be printed
			var paperheight = my_pj.pageHeight;
			var paperwidth = my_pj.pageWidth;
			var flamingoheight = this.mFlamingo.__height;
			var flamingowidth = this.mFlamingo.__width;
			var scale = paperwidth/flamingowidth;
			var scale = Math.min(scale, (paperheight/flamingoheight));
			var xscale = this.mFlamingo._xscale;
			var yscale = this.mFlamingo._yscale;
			this.mFlamingo._xscale = this.mFlamingo._yscale=scale;
			trace(">>"+scale);
			if (my_pj.addPage(this.mFlamingo, {xMin:0, xMax:flamingowidth, yMin:0, yMax:flamingoheight}, {printAsBitmap:true}, 1)) {
				pagesToPrint++;
			}
			this.mFlamingo._xscale = xscale;
			this.mFlamingo._yscale = yscale;
			// send pages from the spooler to the printer, but only if one or more   
			// calls to addPage() was successful. You should always check for successful 
			// calls to start() and addPage() before calling send().
			if (pagesToPrint>0) {
				my_pj.send();
				// print page(s)
			}
		}
		// clean up         
		delete my_pj;
		// delete object
	}
	/**
	* Determines if a component is registered at the framework.
	* @param comp:Object  MovieClip or componentid.
	* @return Boolean True or false.
	*/
	public function exists(comp:Object):Boolean {
		return this.components[this.getId(comp)].url != undefined;
	}
	/**
	* Returns the type of a component. This is actually the filename without the path and the ".swf"
	* @param comp:Object  MovieClip or componentid.
	* @return String Component's type.
	*/
	public function getType(comp:Object):String {
		var a:Array = this.components[this.getId(comp)].url.split("/");
		return (a[a.length-1]);
	}
	/**
	* Determines if a component is really visible, not just _visible.
	* It checks al the parents. If they are visible, the component is also visible.
	* @param comp:Object MovieClip or componentid.
	* @return Boolean True or false.
	*/
	public function isVisible(comp:Object):Boolean {
		var mc = this.getComponent(getId(comp));
		while (mc != undefined) {
			if (not mc._visible) {
				return (false);
				break;
			}
			mc = mc._parent;
		}
		return (true);
	}
	/**
	* Gets a saved 'flamingo' cookie.
	* @param id:String Cookie-identifyer.
	* @return Object The cookie-object.
	*/
	public function getCookie(id:String):Object {
		var so:SharedObject = SharedObject.getLocal("flamingo", "/");
		return (so.data[id]);
	}
	/**
	* Stores a 'flamingo' cookie.
	* @param id:String Cookie-identifyer.
	* @param obj:Object Object to be stored.
	*/
	public function setCookie(id:String, obj:Object):Void {
		var so:SharedObject = SharedObject.getLocal("flamingo", "/");
		so.data[id] = obj;
		so.flush();
	}
	/** 
	* Shows a simple textbox with a message. Tracer is intended for debugging in a browser environment.
	* @param msg:String A message.
	*/
	public function tracer(msg:String) {
		if (_root.mFlamingoTracer == undefined) {
			_root.attachMovie("mTracer", "mFlamingoTracer", 10000);
			_root.mFlamingoTracer.txt.text = msg;
		} else {
			_root.mFlamingoTracer.txt.text = _root.mFlamingoTracer.txt.text+newline+msg;
		}
		_root.mFlamingoTracer.txt.scroll = _root.mFlamingoTracer.txt.maxscroll;
	}
	public function degree2decdegree(d:String):Number {
		//var d = "6 34 54.5";
		var a = d.split(" ");
		var g = Number(a[0]);
		var m = Number(a[1]);
		var s = Number(a[2]);
		return g+(m/60)+(s/3600);
	}
	/**
	* Corrects a relative url with the flamingo root location.
	* That is where flamingo.swf is located.
	* @param url:String Url
	* @return String The corrected url.
	*/
	public function correctUrl(url):String {
		if (url.toLowerCase().indexOf("http", 0) == 0) {
			return url;
		}
		if (url.toLowerCase().indexOf("file", 0) == 0) {
			return url;
		}
		return this.rooturl+"/"+url
	}
}
