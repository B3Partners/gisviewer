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
class FlamingoShape extends MovieClip {
	public var linecolor:Number;
	public var linewidth:Number;
	public var linealpha:Number;
	public var fillcolor:Number;
	public var fillalpha:Number;
	public var points:Array;
	public var shape:MovieClip;
	function FlamingoShape(mc:MovieClip, points:Array, props:Object) {
		if (mc == undefined) {
			return;
		}
		this.points = points;
		this.shape = mc;
		for (var prop in props) {
			switch (prop.toLowerCase()) {
			case "linecolor" :
				this.linecolor = props[prop];
				break;
			case "linewidth" :
				this.linewidth = props[prop];
				break;
			case "linealpha" :
				this.linealpha = props[prop];
				break;
			case "fillcolor" :
				this.fillcolor = props[prop];
				break;
			case "fillalpha" :
				this.fillalpha = props[prop];
				break;
			}
		}
		this.draw()
	}
	function draw() {
		
		var drawline:Boolean;
		var drawfill:Boolean;
		var x:Number;
		var y:Number;
		if (this.points.length<4) {
			return;
		}
		
		if (this.linecolor == undefined) {
			drawline = false;
		} else {
			drawline = true;
			if (this.linewidth == undefined) {
				this.linewidth = 0;
			}
			if (this.linealpha == undefined) {
				this.linealpha = 100;
			}
		}
		if (this.fillcolor == undefined) {
			drawfill = false;
		} else {
			drawfill = true;
			if (this.fillalpha == undefined) {
				this.fillalpha = 100;
			}
		}
		trace("beibg draw")
		if (drawfill) {
			this.shape.beginFill(this.fillcolor,this.fillalpha);
		}
		if (drawline) {
			this.shape.lineStyle(this.linewidth, this.linecolor, this.linealpha);
		}
		x = points[0];
		y = points[1];
		this.shape.moveTo(x, y);
		for (var i = 2; i<this.points.length; i=i+2) {
			x = points[i];
			y = points[i+1];
			this.shape.lineTo(x, y);
		}
		if (drawfill) {
			this.shape.endFill();
		}
	}
	function refresh() {
		this.draw();
	}
	function clear() {
		this.shape.clear();
	}
}
