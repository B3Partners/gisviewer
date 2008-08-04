// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.gismodel.*;

import flamingo.event.*;
import flamingo.geometrymodel.Envelope;

class flamingo.gismodel.GIS extends AbstractComposite {
    
    private var map:MovieClip = null;
    private var authentication:MovieClip = null;
    private var extent:Envelope = null;
    private var layers:Array = null;
    private var updateAfterCommit:Boolean = false;
    private var activeFeature:Feature = null;
    private var createGeometry:CreateGeometry = null;
    private var serversBusy:Number = 0;
    
    private var stateEventDispatcher:StateEventDispatcher = null;
    
    function GIS(xmlNode:XMLNode, map:MovieClip, authentication:MovieClip) {
        if (map == null) {
            _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.<<init>>()");
            return;
        }
        
        this.map = map;
        this.authentication = authentication;
        var nativeExtent:Object = map.getMapExtent();
        extent = new Envelope(nativeExtent.minx, nativeExtent.miny, nativeExtent.maxx, nativeExtent.maxy);
        layers = new Array();
        
        _global.flamingo.addListener(this, map ,this);
        
        stateEventDispatcher = new StateEventDispatcher();
        
        parseConfig(xmlNode);
    }
    
    function setAttribute(name:String, value:String):Void {
        if (name == "updateaftercommit") {
            updateAfterCommit = (value == "true"? true: false);
        }
    }
    
    function addComposite(name:String, xmlNode:XMLNode):Void {
        if (name == "Layer") {
            addLayer(new Layer(this, xmlNode));
        }
    }
    
    function onChangeExtent():Void {
        var nativeExtent:Object = map.getCurrentExtent();
        setExtent(new Envelope(nativeExtent.minx, nativeExtent.miny, nativeExtent.maxx, nativeExtent.maxy));
    }
    
    private function setExtent(extent:Envelope):Void {
        if (this.extent.equals(extent)) {
            return;
        }
        
        this.extent = extent;
        
        stateEventDispatcher.dispatchEvent(new StateEvent(this, "GIS", StateEvent.CHANGE, "extent"));
    }
    
    function getExtent():Envelope {
        return extent;
    }
    
    function addLayer(layer:Layer):Void {
        if (layer == null) {
            _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.addLayer()\nNo layer given.");
            return;
        }
        if (getLayer(layer.getName()) != null) {
            _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.addLayer(" + layer.getName() + ")\nGiven layer already exists.");
            return;
        }
        
        var roles:Array = layer.getRoles();
        var authorized:Boolean = false;
        if (roles.length == 0) {
            authorized = true;
        }
        for (var i:String in roles) {
            if ((authentication != null) && (authentication.isRole(roles[i]))) {
                authorized = true;
            }
        }
        if (!authorized) {
            return;
        }
        
        layers.push(layer);
        
        stateEventDispatcher.dispatchEvent(new AddRemoveEvent(this, "GIS", "layers", new Array(layer), null));
    }
    
    function getLayers():Array {
        return layers.concat();
    }
    
    function getLayer(name:String):Layer {
        var layer:Layer = null;
        for (var i:String in layers) {
            layer = Layer(layers[i]);
            if (layer.getName() == name) {
                return layer;
            }
        }
        return null;
    }
    
    function getLayerPosition(layer:Layer):Number {
        for (var i:Number = 0; i < layers.length; i++) {
            if (layers[i] == layer) {
                return i;
            }
        }
        return -1;
    }
    
    function setActiveFeature(activeFeature:Feature):Void {
        if (this.activeFeature == activeFeature) {
            return;
        }
        
        var previousActiveFeature:Feature = this.activeFeature;
        this.activeFeature = activeFeature;
        
        stateEventDispatcher.dispatchEvent(new ChangeEvent(this, "GIS", "activeFeature", previousActiveFeature));
    }
    
    function getActiveFeature():Feature {
        return activeFeature;
    }
    
    function setCreateGeometry(createGeometry:CreateGeometry):Void {
        this.createGeometry = createGeometry;
            
        stateEventDispatcher.dispatchEvent(new StateEvent(this, "GIS", StateEvent.CHANGE, "createGeometry"));
    }
    
    function getCreateGeometry():CreateGeometry {
        return createGeometry;
    }
    
    function commit():Void {
        for (var i:String in layers) {
            if (Layer(layers[i]).isTransactionProblematic4Server()) {
                _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.commit()\nAt least one of the layers, \"" + Layer(layers[i]).getName() +  "\", has problems to send its transaction to the server. Sending transactions is cancelled for all layers.");
                return;
            }
        }
        
        serversBusy += layers.length;
        for (var i:String in layers) {
            Layer(layers[i]).commit();
        }
    }
    
    function onServerReady():Void {
        serversBusy--;
        if ((serversBusy == 0) && (updateAfterCommit)) {
            map.update(0, true);
        }
    }
    
    function addEventListener(stateEventListener:StateEventListener, sourceClassName:String, actionType:Number, propertyName:String):Void {
        if (
                (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_extent")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.ADD_REMOVE + "_layers")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_activeFeature")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_createGeometry")
           ) {
            _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.addEventListener(" + sourceClassName + ", " + propertyName + ")");
            return;
        }
        stateEventDispatcher.addEventListener(stateEventListener, sourceClassName, actionType, propertyName);
    }
    
    function removeEventListener(stateEventListener:StateEventListener, sourceClassName:String, actionType:Number, propertyName:String):Void {
        if (
                (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_extent")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.ADD_REMOVE + "_layers")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_activeFeature")
             && (sourceClassName + "_" + actionType + "_" + propertyName != "GIS_" + StateEvent.CHANGE + "_createGeometry")
           ) {
            _global.flamingo.tracer("Exception in flamingo.gismodel.GIS.removeEventListener(" + sourceClassName + ", " + propertyName + ")");
            return;
        }
        stateEventDispatcher.removeEventListener(stateEventListener, sourceClassName, actionType, propertyName);
    }
    
    function toString():String {
        return "GIS()";
    }
    
}
