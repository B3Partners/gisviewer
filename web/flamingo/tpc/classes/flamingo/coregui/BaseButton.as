// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.coregui.*;

import flamingo.event.ActionEventListener;
import flamingo.event.ActionEvent;

class flamingo.coregui.BaseButton extends MovieClip {
    
    private var id:Number = -1; // Set by init object.
    private var bar:ButtonBar = null; // Set by init object.
    private var graphicURL:String = null; // Set by init object.
    private var width:Number = -1; // Set by init object.
    private var height:Number = -1; // Set by init object.
    private var toolTipText:String = null; // Set by init object.
    private var actionEventListener:ActionEventListener = null; // Set by init object;
    private var url:String = null; // Set by init object.
    private var windowName:String = null; // Set by init object.
    
    private var graphic:MovieClip = null;
    
    function onLoad():Void {
        useHandCursor = false;
        
        addGraphic();
    }
    
    function getID():Number {
        return id;
    }
    
    function getWidth():Number {
        return _width;
    }
    
    function getHeight():Number {
        return _height;
    }
    
    function getToolTipText():String {
        return toolTipText;
    }
    
    private function addGraphic():Void {
        graphic = attachMovie(graphicURL, "mcGraphic", 0);
        graphic.gotoAndStop(1);
        
        if (width > -1) {
            _width = width;
        }
        if (height > -1) {
            _height = height;
        }
        
        bar.layout();
    }
    
    function onRollOver():Void {
        _root.mTooltip.show(toolTipText, this);
    }
    
    function onPress():Void {
        if (graphic._totalframes > 1) {
            graphic.gotoAndStop(2);
        }
        
        if (actionEventListener != null) {
            actionEventListener.onActionEvent(new ActionEvent(this, "Button", ActionEvent.CLICK));
        } else {
            getURL("javascript:openNewWindow('" + url + "', '" + windowName + "', 'width=500, height=400, top=50, left=50, toolbar=no, resizable=yes, scrollbars=yes')");
        }
    }
    
    function onRelease():Void {
        graphic.gotoAndStop(1);
    }
    
    function onReleaseOutside():Void {
        graphic.gotoAndStop(1);
    }
    
}
