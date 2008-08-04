// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.gui.*;

import flamingo.event.*;
import flamingo.gismodel.GIS;
import flamingo.gismodel.Layer;
import flamingo.gismodel.CreateGeometry;

class flamingo.gui.EditMap extends AbstractComponent implements StateEventListener {
    
    private var mask:MovieClip = null;
    private var gis:GIS = null;
    private var editMapLayers:Array = null;
    private var editMapCreateGeometry:EditMapCreateGeometry = null;
    private var editMapCreateGeometryDepth:Number = 1001; // Assumes that there will never be more than 1000 layers at the same time.
    
    function addComposite(name:String, config:XMLNode):Void {
        if (name == "GIS") {
            gis = new GIS(config, _global.flamingo.getComponent(listento[0]), _global.flamingo.getComponent(listento[1]));
        }
    }
    
    function setBounds(x:Number, y:Number, width:Number, height:Number):Void {
        if (mask == null) {
            mask = createEmptyMovieClip("mMask", editMapCreateGeometryDepth + 1);
        } else {
            mask.clear();
        }
        mask.lineStyle(1, 0x000000, 100);
        mask.beginFill(0xFF0000);
        mask.moveTo(0, 0);
        mask.lineTo(width, 0);
        mask.lineTo(width, height);
        mask.lineTo(0, height);
        mask.endFill();
        setMask(mask);
        
        super.setBounds(x, y, width, height);
    }
    
    function init():Void {
        editMapLayers = new Array();
        
        gis.addEventListener(this, "GIS", StateEvent.ADD_REMOVE, "layers");
        gis.addEventListener(this, "GIS", StateEvent.CHANGE, "createGeometry");

        var layers:Array = gis.getLayers();
        var layer:Layer = null;
        for (var i:Number = 0; i < layers.length; i++) {
            layer = Layer(layers[i]);
            layer.addEventListener(this, "Layer", StateEvent.CHANGE, "visible");
            if (layer.isVisible()) {
                addEditMapLayer(layer);
            }
        }
    }
    
    function layout():Void {
        for (var i:String in editMapLayers) {
            EditMapLayer(editMapLayers[i]).setSize(__width, __height);
        }
        if (editMapCreateGeometry != null) {
            editMapCreateGeometry.setSize(__width, __height);
        }
    }
    
    function onStateEvent(stateEvent:StateEvent):Void {
        var sourceClassName:String = stateEvent.getSourceClassName();
        var actionType:Number = stateEvent.getActionType();
        var propertyName:String = stateEvent.getPropertyName();
        if (sourceClassName + "_" + actionType + "_" + propertyName == "GIS_" + StateEvent.ADD_REMOVE + "_layers") { // Removing is not supported at the moment, because we use this event only at init time.
            var layers:Array = AddRemoveEvent(stateEvent).getAddedObjects();
            var layer:Layer = null;
            for (var i:Number = 0; i < layers.length; i++) {
                layer = Layer(layers[i]);
                layer.addEventListener(this, "Layer", StateEvent.CHANGE, "visible");
                if (layer.isVisible()) {
                    addEditMapLayer(layer);
                }
            }
        } else if (sourceClassName + "_" + actionType + "_" + propertyName == "GIS_" + StateEvent.CHANGE + "_createGeometry") {
            var createGeometry:CreateGeometry = gis.getCreateGeometry();
            if (createGeometry == null) {
                removeEditMapCreateGeometry();
            } else {
                addEditMapCreateGeometry(createGeometry);
            }
        } else if (sourceClassName + "_" + actionType + "_" + propertyName == "Layer_" + StateEvent.CHANGE + "_visible") {
            var layer:Layer = Layer(stateEvent.getSource());
            if (layer.isVisible()) {
                addEditMapLayer(layer);
            } else {
                removeEditMapLayer(layer);
            }
        }
    }
    
    function getGIS():GIS {
        return gis;
    }
    
    private function addEditMapLayer(layer:Layer):Void {
        removeEditMapLayer(layer);
        
        var depth:Number = editMapCreateGeometryDepth - 1 - gis.getLayerPosition(layer);
        var initObject:Object = new Object();
        initObject["gis"] = gis;
        initObject["layer"] = layer;
        initObject["width"] = __width;
        initObject["height"] = __height;
        editMapLayers.push(attachMovie("EditMapLayer", "mEditMapLayer" + depth, depth, initObject));
    }
    
    private function removeEditMapLayer(layer:Layer):Void {
        var editMapLayer:EditMapLayer = null;
        for (var i:Number = 0; i < editMapLayers.length; i++) {
            editMapLayer = EditMapLayer(editMapLayers[i]);
            if (editMapLayer.getLayer() == layer) {
                editMapLayer.remove();
                editMapLayers.splice(i, 1);
                break;
            }
        }
    }
    
    private function addEditMapCreateGeometry(createGeometry:CreateGeometry):Void {
        removeEditMapCreateGeometry();
        
        var initObject:Object = new Object();
        initObject["gis"] = gis;
        initObject["createGeometry"] = createGeometry;
        initObject["width"] = __width;
        initObject["height"] = __height;
        editMapCreateGeometry = EditMapCreateGeometry(attachMovie("EditMapCreateGeometry", "mEditMapCreateGeometry", editMapCreateGeometryDepth, initObject));
    }
    
    private function removeEditMapCreateGeometry():Void {
        if (editMapCreateGeometry != null) {
            editMapCreateGeometry.remove();
            editMapCreateGeometry = null; // MovieClip.removeMovieClip does not nullify the reference.
        }
    }
    
}
