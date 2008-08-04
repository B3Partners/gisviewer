// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.gui.*;

import flamingo.event.*;
import flamingo.gismodel.GIS;
import flamingo.gismodel.Layer;

class flamingo.gui.EditLegend extends AbstractComponent implements StateEventListener {
    
    private var gis:GIS = null;
    private var editLegendLayers:Array = null;
    private var legendHeight:Number = 25;
    
    function init():Void {
        gis = _global.flamingo.getComponent(listento[0]).getGIS();
        editLegendLayers = new Array();
        
        gis.addEventListener(this, "GIS", StateEvent.ADD_REMOVE, "layers");
        
        var layers:Array = gis.getLayers();
        var layer:Layer = null;
        for (var i:Number = 0; i < layers.length; i++) {
            layer = Layer(layers[i]);
            addEditLegendLayer(layer);
        }
    }
    
    function layout():Void {
        for (var i:String in editLegendLayers) {
            EditLegendLayer(editLegendLayers[i]).setSize(__width, legendHeight);
        }
    }
    
    function onStateEvent(stateEvent:StateEvent):Void {
        var sourceClassName:String = stateEvent.getSourceClassName();
        var actionType:Number = stateEvent.getActionType();
        var propertyName:String = stateEvent.getPropertyName();
        if (sourceClassName + "_" + actionType + "_" + propertyName == "GIS_" + StateEvent.ADD_REMOVE + "_layers") { // Removing is not supported at the moment, because we use this event only at init time.
            var layers:Array = AddRemoveEvent(stateEvent).getAddedObjects();
            for (var i:Number = 0; i < layers.length; i++) {
                addEditLegendLayer(Layer(layers[i]));
            }
        }
    }
    
    private function addEditLegendLayer(layer:Layer):Void {
        var depth:Number = gis.getLayerPosition(layer);
        var initObject:Object = new Object();
        initObject["_y"] = depth * legendHeight;
        initObject["width"] = __width;
        initObject["height"] = legendHeight;
        initObject["gis"] = gis;
        initObject["layer"] = layer;
        editLegendLayers.push(attachMovie("EditLegendLayer", "mEditLegendLayer" + depth, depth, initObject));
    }
    
}
