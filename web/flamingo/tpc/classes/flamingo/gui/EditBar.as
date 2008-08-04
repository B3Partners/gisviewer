// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.gui.*;

import flamingo.event.ActionEventListener;
import flamingo.event.ActionEvent;
import flamingo.coregui.BaseButton;
import flamingo.coregui.ButtonBar;
import flamingo.coregui.ButtonConfig;
import flamingo.gismodel.GIS;

class flamingo.gui.EditBar extends AbstractComponent implements ActionEventListener {
    
    private var gis:GIS = null;
    
    function init():Void {
        gis = _global.flamingo.getComponent(listento[0]).getGIS();
        
        drawButtonBar();
    }
    
    private function drawButtonBar():Void {
        var buttonConfigs:Array = new Array();
        buttonConfigs.push(new ButtonConfig("RemoveFeatureGraphic", "object verwijderen", this, null, null));
        buttonConfigs.push(new ButtonConfig("SaveEditsGraphic", "wijzigingen opslaan", this, null, null));
        var initObject:Object = new Object();
        initObject["buttonWidth"] = 20;
        initObject["buttonHeight"] = 20;
        initObject["orientation"] = ButtonBar.HORIZONTAL;
        initObject["spacing"] = 10;
        initObject["buttonConfigs"] = buttonConfigs;
        attachMovie("ButtonBar", "mButtonBar", 0, initObject);
    }

    function onActionEvent(actionEvent:ActionEvent):Void {
        var sourceClassName:String = actionEvent.getSourceClassName();
        var actionType:Number = actionEvent.getActionType();
        if (sourceClassName + "_" + actionType == "Button_" + ActionEvent.CLICK) {
            var buttonID:Number = BaseButton(actionEvent.getSource()).getID();
            if (buttonID == 0) { // Remove feature button.
                var feature:flamingo.gismodel.Feature = gis.getActiveFeature();
                if (feature != null) {
                    feature.getLayer().removeFeature(feature, true);
                }
            } else if (buttonID == 1) { // Commit button.
                gis.commit();
            }
        }
    }
    
}
