// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.coregui.*;

class flamingo.coregui.ButtonBar extends MovieClip {
    
    static var HORIZONTAL:Number = 0;
    static var VERTICAL:Number = 1;
    
    private var buttonWidth:Number = 10; // Set by init object.
    private var buttonHeight:Number = 10; // Set by init object.
    private var orientation:Number = HORIZONTAL; // Set by init object.
    private var spacing:Number = 5; // Set by init object.
    private var expandable:Boolean = false; // Set by init object.
    private var buttonConfigs:Array = null; // Set by init object.
    private var buttons:Array = null;
    
    function onLoad():Void {
        if ((orientation != HORIZONTAL) && (orientation != VERTICAL)) {
            _global.flamingo.tracer("Exception in flamingo.coregui.ButtonBar.<<init>>(" + orientation + ")");
        }
        if (buttonConfigs == null) {
            _global.flamingo.tracer("Exception in flamingo.coregui.ButtonBar.<<init>>()");
        }
        
        buttons = new Array();
        
        if (expandable) {
            addBackground();
        } else {
            addButtons();
        }
    }
    
    private function addBackground():Void {
        var background:MovieClip = createEmptyMovieClip("mBackground", 0);
        background.moveTo(0, 0);
        background.lineStyle(1, 0x000000, 100);
        background.beginFill(0x000000, 0);
        background.lineTo(buttonWidth - 1, 0);
        background.lineTo(buttonWidth - 1, buttonHeight - 1);
        background.lineTo(0, buttonHeight - 1);
        background.endFill();
    }
    
    private function addButtons():Void {
        for (var i:Number = 0; i < buttonConfigs.length; i++) {
            addButton(ButtonConfig(buttonConfigs[i]), i);
        }
    }
    
    private function addButton(buttonConfig:ButtonConfig, id:Number):Void {
        var initObject:Object = new Object();
        initObject["bar"] = this;
        initObject["id"] = id;
        initObject["graphicURL"] = buttonConfig.getGraphicURL();
        initObject["width"] = buttonWidth;
        initObject["height"] = buttonHeight;
        initObject["toolTipText"] = buttonConfig.getToolTipText();
        initObject["actionEventListener"] = buttonConfig.getActionEventListener();
        initObject["url"] = buttonConfig.getURL();
        initObject["windowName"] = buttonConfig.getWindowName();
        buttons.push(attachMovie("BaseButton", "mBaseButton" + id, id + 1, initObject));
    }
    
    private function removeButtons():Void {
        for (var i:String in buttons) {
            BaseButton(buttons[i]).removeMovieClip();
        }
        buttons = new Array();
    }
    
    function layout():Void {
        var pos:Number = 0;
        var button:BaseButton = null;
        for (var i:Number = 0; i < buttons.length; i++) {
            button = BaseButton(buttons[i]);
            if (orientation == HORIZONTAL) {
                button._x = pos;
                pos += spacing + button.getWidth();
            } else { // VERTICAL
                button._y = pos;
                pos += spacing + button.getHeight();
            }
        }
    }
    
    function onMouseMove():Void {
        if (!expandable) {
            return;
        }
        
        if (hitTest(_root._xmouse, _root._ymouse)) {
            if (buttons.length > 0) {
                return;
            }
            
            addButtons();
        } else {
            if (buttons.length == 0) {
                return;
            }
            
            removeButtons();
        }
    }
    
}
