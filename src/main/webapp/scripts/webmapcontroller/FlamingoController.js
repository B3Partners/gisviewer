/**
 *Controller subclass for Flamingo
 *@param domId
 **/
function FlamingoController(domId) {
    var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "100%", "100%", "8", "#FFFFFF");
    so.addParam("wmode", "transparent");
    so.write(domId);
    this.viewerObject = document.getElementById("flamingo");

    Controller.call(this, domId);
}
//extends Controller
FlamingoController.prototype = new Controller();
FlamingoController.prototype.constructor = FlamingoController;

/**
 * Initialize the events. These events are specific for flamingo.
 */
FlamingoController.prototype.initEvents = function() {
    this.eventList[Event.ON_EVENT_DOWN] = "onEvent";
    this.eventList[Event.ON_EVENT_UP] = "onEvent";
    this.eventList[Event.ON_GET_CAPABILITIES] = "onGetCapabilities";
    this.eventList[Event.ON_CONFIG_COMPLETE] = "onConfigComplete";
    this.eventList[Event.ON_FEATURE_ADDED] = "onGeometryDrawFinished";
    this.eventList[Event.ON_REQUEST] = "onRequest";
    this.eventList[Event.ON_SET_TOOL] = "onSetTool";
    this.eventList[Event.ON_GET_FEATURE_INFO] = "onIdentify";
    this.eventList[Event.ON_GET_FEATURE_INFO_DATA] = "onIdentifyData";
    this.eventList[Event.ON_ALL_LAYERS_LOADING_COMPLETE] = "onUpdateComplete";
    this.eventList[Event.ON_FINISHED_CHANGE_EXTENT] = "onReallyChangedExtent";
    this.eventList[Event.ON_CHANGE_EXTENT] = "onChangeExtent";
};

/**
 *Creates a Openlayers.Map object for this framework. See the openlayers.map docs
 *@param id the id of the map that is configured in the configuration xml
 *@returns a FlamingoController
 */
FlamingoController.prototype.createMap = function(id) {
    return new FlamingoMap(id, this.viewerObject);
};

/**
 *See @link Controller.createWMSLayer
 *@param name
 *@param url
 *@param ogcParams
 *@param options
 */
FlamingoController.prototype.createWMSLayer = function(name, url, ogcParams, options) {
    var object = new Object();
    object["name"] = name;
    object["url"] = url;
    var id = null;
    for (var key in ogcParams) {
        object[key] = ogcParams[key];
    }
    for (var key in options) {
        if (key.toLowerCase() == "id") {
            id = options[key];
        } else {
            object[key] = options[key];
        }
    }
    return new FlamingoWMSLayer(id, object, this.viewerObject);
};

/**
 *See @link Controller.createWMScLayer
 *@param name
 *@param url
 *@param options
 */
FlamingoController.prototype.createWMScLayer = function(name, url, options) {
    if (options == undefined)
        options = new Object();
    options["type"] = "wmsc";
    options["SERVICE"] = "WMS";
    //options["VERSION"]="1.1.1";
    options["REQUEST"] = "GetMap";
    return this.createTilingLayer(name, url, options);
};

/**
 *Creates the flamingo tiling layer.
 *@param name
 *@param url
 *@param options
 */
FlamingoController.prototype.createTilingLayer = function(name, url, options) {
    if (options == undefined || options["type"] == undefined) {
        throw "No tiling type for Flamingo tiling layer!"
    }
    options["url"] = url;
    options["name"] = name;
    return new FlamingoTilingLayer(name, options, this.viewerObject);
};

/**
 * See @link Controller.createTool
 * TODO: make the parameter layer part of the options. 
 * @param id
 * @param type
 * @param options
 */
FlamingoController.prototype.createTool = function(id, type, options) {
    var tool = new FlamingoTool(id, this.viewerObject);
    if (type == Tool.GET_FEATURE_INFO) {
        webMapController.registerEvent(Event.ON_GET_FEATURE_INFO, webMapController.getMap(), options["handlerBeforeGetFeatureHandler"]);
        webMapController.registerEvent(Event.ON_GET_FEATURE_INFO_DATA, webMapController.getMap(), options["handlerGetFeatureHandler"]);
    }
    return tool;
};

/**
 * @param id
 * See @link Controller.createVectorLayer
 */
FlamingoController.prototype.createVectorLayer = function(id) {
    return new FlamingoVectorLayer(id, this.viewerObject);
};

/**
 * See @link Controller.createPanel
 * @param name
 */
FlamingoController.prototype.createPanel = function(name) {
    this.panel = name;
};

/**
 *See @link Controller.addTool
 *@param tool
 */
FlamingoController.prototype.addTool = function(tool) {
    if (!(tool instanceof FlamingoTool)) {
        throw("The given tool is not of type 'FlamingoTool'");
    }
    this.viewerObject.callMethod(tool.getId(), 'setVisible', true);
    Controller.prototype.addTool.call(this, tool);
};

/**
 *See @link Controller.activateTool
 *@param id
 */
FlamingoController.prototype.activateTool = function(id) {
    this.viewerObject.call(this.panel, "setTool", id);
};

/**
 *See @link Controller.removeTool
 *@param tool
 */
FlamingoController.prototype.removeTool = function(tool) {
    if (!(tool instanceof FlamingoTool)) {
        throw("The given tool is not of type 'FlamingoTool'");
    }
    this.viewerObject.callMethod(tool.getId(), 'setVisible', false);
    Controller.prototype.removeTool.call(this, tool);
};

/**
 *Add a map to the controller.
 *For know only 1 map supported.
 *
 *@param map
 */
FlamingoController.prototype.addMap = function(map) {
    if (!(map instanceof FlamingoMap)) {
        throw("FlamingoController.addMap(): The given map is not of the type 'FlamingoMap'");
    }
    this.maps.push(map);
};

/**
 * See @link Controller.removeToolById
 * @param id
 */
FlamingoController.prototype.removeToolById = function(id) {
    var tool = this.getTool(id);
    if (tool == null || !(tool instanceof FlamingoTool)) {
        throw("The given tool is not of type 'FlamingoTool' or the given id does not exist");
    }
    this.removeTool(tool);
};

/**
 *Get the map by id. If no id is given and 1 map is available that map wil be returned
 *@param mapId the mapId
 *@returns the Map with the id, or the only map.
 */
FlamingoController.prototype.getMap = function(mapId) {
    if (mapId == undefined && this.maps.length == 1) {
        return this.maps[0];
    }
    var availableMaps = "";
    for (var i = 0; i < this.maps.length; i++) {
        if (i != 0)
            availableMaps += ",";
        availableMaps += this.maps[i].getId();
        if (this.maps[i].getId() == mapId) {
            return this.maps[i];
        }
    }
    throw("FlamingoController.getMap(): Map with id: " + mapId + " not found! Available maps: " + availableMaps);
};

/****************************************************************Event handling***********************************************************/

/**
 * Registers an event to a handler, on a object. Flamingo doesn't implement per component eventhandling,
 * so this controller stores the event in one big array.
 * This array is a two-dimensional array: the first index is the eventname (the generic one! Actually, not a name, but the given id).
 * The second index is the id of the object. 
 * 
 * @param event
 * @param object
 * @param handler
 */
FlamingoController.prototype.registerEvent = function(event, object, handler) {
    if (this.events[event] == undefined) {
        this.events[event] = new Object();
    }
    if (this.events[event][object.getId()] == undefined) {
        this.events[event][object.getId()] = new Array();
    }
    this.events[event][object.getId()].push(handler);
};

/**
 *Unregister the event @link see Controller.unRegisterEvent
 *@param event
 *@param object
 *@param handler
 */
FlamingoController.prototype.unRegisterEvent = function(event, object, handler) {
    var newHandlerArray = new Array();

    if (this.events[event][object.getId()] != undefined) {
        for (var i = 0; i < this.events[event][object.getId()].length; i++) {
            if (handler != this.events[event][object.getId()][i]) {
                newHandlerArray.push(this.events[event][object.getId()][i]);
            }
        }
        if (newHandlerArray.length == 0) {
            delete this.events[event][object.getId()];
        } else {
            this.events[event][object.getId()] = newHandlerArray;
        }
    }
};

/**
 * Handles all the events. This function retrieves the function 
 * registered to this event. Flamingo doesn't understand per 
 * object eventhandling, but instead it fires an event, with 
 * a id of the object (and a bunch of parameters). In this
 * function we translate the events to per object events,
 * and more specific events (button up/down)
 *  
 * @param event
 * @param component
 */
FlamingoController.prototype.handleEvents = function(event, component) {
    var id = component[0];

    // onEvent is a general event, fired when a jsButton is hovered over, pressed or released. Here we specify which it was.
    if (event == "onEvent") {
        if (component[1]["rollover"] || component[1]["rolloff"]) {
            event = Event.ON_EVENT_OVER;
        } else {
            if (component[1]["toggle"]) {
                if (component[1]["selected"] && component[1]["down"]) {
                    event = Event.ON_EVENT_DOWN;
                } else if (!component[1]["selected"] && component[1]["down"]) {
                    event = Event.ON_EVENT_UP;
                }
            } else {
                if (component[1]["down"]) {
                    event = Event.ON_EVENT_DOWN;
                }
            }
        }

    } else {
        // Translate the specific name to the generic name. 
        event = this.getGenericEventName(event);
    }
    if (event == Event.ON_REQUEST) {
        var obj = component[2];
        if (obj.requesttype == "GetMap") {
            var tokens = component[0].split("_");

            /* TODO kijken of we de functie kunnen uitbreiden zodat dit werkt met meer
             * dan 3 tokens en of dat nut heeft. Kun je weten aan de hand van aantal tokens
             * om wat voor layer het gaat ? */
            if (tokens.length == 2) {
                this.getMap(tokens[0]).getLayer(tokens[1]).setURL(obj.url);
            }

            if (tokens.length == 3) {
                this.getMap(tokens[0]).getLayer(tokens[1] + "_" + tokens[2]).setURL(obj.url);
            }
        }
    } else if (event == Event.ON_SET_TOOL) {
        //onchange tool is called for a tool group but event is registerd on the controller
        id = component[1];
    } else {
        if (event == Event.ON_FEATURE_ADDED) {
            // Make sure "component" is the drawn feature. For < 4.2 don't use .wkt geom, for >= 4.2 .wktgeom
            var feature = null;
            if (component[1].wktgeom != undefined) {
                feature = new Feature(id, component[1].wktgeom);
            } else {
                feature = new Feature(id, component[1]);
            }
            component = feature;
        } else if (event == Event.ON_GET_FEATURE_INFO) {
            component = component[1];
        } else if (event == Event.ON_GET_FEATURE_INFO_DATA) {
            component = component[2];
        }
    }
    for (var i = 0; i < this.events[event][id].length; i++) {
        this.events[event][id][i](id, component);
    }
};

/**
 * Entrypoint for flamingoevents. This function propagates 
 * the events to the webMapController (handleEvents).
 * 
 * @param event
 * @param comp
 */
function dispatchEventJS(event, comp) {
    if (comp [0] == null) {
        comp[0] = webMapController.getId();
        comp[1] = new Object();
    }

    webMapController.handleEvents(event, comp);
}

/** Flamingomap 
 * @param id
 * @param flamingoObject
 **/
function FlamingoMap(id, flamingoObject) {
    if (id == undefined || flamingoObject == undefined)
        throw("FlamingoMap.constructor: Id or Flamingo object is undefined");
    this.id = id;
    Map.call(this, flamingoObject);
}

//set inheritance
FlamingoMap.prototype = new Map();
FlamingoMap.prototype.constructor = FlamingoMap;

/**
 *See @link Map.getId
 */
FlamingoMap.prototype.getId = function() {
    return this.id;
};

/**
 *See @link Map.getAllWMSLayers
 */
FlamingoMap.prototype.getAllWMSLayers = function() {
    var lagen = new Array();
    for (var i = 0; i < this.layers.length; i++) {
        if (this.layers[i] instanceof FlamingoWMSLayer) {
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
};

/**
 *See @link Map.getAllVectorLayers
 */
FlamingoMap.prototype.getAllVectorLayers = function() {
    var lagen = new Array();
    for (var i = 0; i < this.layers.length; i++) {
        if (this.layers[i] instanceof FlamingoVectorLayer) {
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
};

FlamingoMap.prototype.getAllTilingLayers = function() {
    var lagen = new Array();
    for (var i = 0; i < this.layers.length; i++) {
        if (this.layers[i] instanceof FlamingoTilingLayer) {
            lagen.push(this.layers[i]);
        }
    }

    return lagen;
};

/**
 *see @link Map.remove
 */
FlamingoMap.prototype.remove = function() {
    this.getFrameworkMap().callMethod("flamingo", "killComponent", this.getId());
};

/**
 *Add a layer(service) to the map
 *@param layer a FlamingoLayer that needs to be added.
 *see @link Map.addLayer
 **/
FlamingoMap.prototype.addLayer = function(layer) {
    if (!(layer instanceof FlamingoLayer))
        throw("FlamingoMap.addLayer(): Given layer not of type FlamingoLayer");
    //call super function
    Map.prototype.addLayer.call(this, layer);
    if (!(layer instanceof FlamingoVectorLayer)) {
        this.getFrameworkMap().callMethod(this.getId(), 'addLayer', layer.toXML());
    }
};

/**
 *remove the specific layer. See @link Map.removeLayer
 *@param layer
 **/
FlamingoMap.prototype.removeLayer = function(layer) {
    if (!(layer instanceof FlamingoLayer))
        throw("FlamingoMap.removeLayer(): Given layer not of type FlamingoLayer");
    //call super function
    Map.prototype.removeLayer.call(this, layer);
    if (!(layer instanceof FlamingoVectorLayer)) {
        this.getFrameworkMap().callMethod(this.getId(), 'removeLayer', this.getId() + '_' + layer.getId());
    }
};

/**
 *see @link Map.setLayerIndex
 *@param layer
 *@param newIndex
 */
FlamingoMap.prototype.setLayerIndex = function(layer, newIndex) {
    if (!(layer instanceof FlamingoLayer)) {
        throw("FlamingoMap.setLayerIndex(): Given layer not of type FlamingoLayer.");
    }

    if (!(layer instanceof FlamingoVectorLayer)) {
        this.getFrameworkMap().callMethod(this.getId(), "swapLayer", this.getId() + '_' + layer.getId(), newIndex);
    }
    return Map.prototype.setLayerIndex(layer, newIndex);
};

/**
 * See @link Map.zoomToExtent
 * @param extent
 */
FlamingoMap.prototype.zoomToExtent = function(extent) {
    this.getFrameworkMap().callMethod(this.getId(), "moveToExtent", extent, 0);
};

/**
 * See @link Map.zoomToMaxExtent
 */
FlamingoMap.prototype.zoomToMaxExtent = function() {
    this.zoomToExtent(this.getFrameworkMap().callMethod(this.getId(), "getFullExtent"));
};

/**
 * See @link Map.zoomToResolution
 * @param resolution
 */
FlamingoMap.prototype.zoomToResolution = function(resolution) {
    this.getFrameworkMap().callMethod(this.getId(), "moveToScale", resolution, undefined, 0);
};

/**
 * See @link Map.zoomToScale
 * @param resolution
 * @deprecated, use zoomToResolution because it zooms to a resolution and not a scale!
 */
FlamingoMap.prototype.zoomToScale = function(resolution) {
    this.zoomToResolution(resolution);
};

/**
 * see @link Map.setMaxExtent
 * @param extent
 */
FlamingoMap.prototype.setMaxExtent = function(extent) {
    this.getFrameworkMap().callMethod(this.getId(), "setFullExtent", extent);
};

/**     
 *See @link Map.getFullExtent()
 */
FlamingoMap.prototype.getMaxExtent = function() {
    var extent = this.getFrameworkMap().callMethod(this.getId(), "getFullExtent");
    return new Extent(extent.minx, extent.miny, extent.maxx, extent.maxy);
};

/**
 *See @link Map.doIdentify
 *@param x
 *@param y
 */
FlamingoMap.prototype.doIdentify = function(x, y) {
    throw("Map.doIdentify() Not implemented!");
};

/**
 *see @link Map.getExtent
 */
FlamingoMap.prototype.getExtent = function() {
    var extent = this.getFrameworkMap().callMethod(this.getId(), 'getCurrentExtent');

    if (extent) {
        return new Extent(extent.minx, extent.miny, extent.maxx, extent.maxy);
    } else {
        return null;
    }
};

/**
 *see @link Map.update
 */
FlamingoMap.prototype.update = function() {
    this.getFrameworkMap().callMethod(this.getId(), 'update', 100, true);
};

/**
 *see @link Map.setMarker
 *@param markerName
 *@param x
 *@param y
 *@param type
 */
FlamingoMap.prototype.setMarker = function(markerName, x, y, type) {
    this.getFrameworkMap().callMethod(this.getId(), "setMarker", markerName, type, Number(x), Number(y));
};

/**
 *see @link Map.removeMarker
 *@param markerName
 */
FlamingoMap.prototype.removeMarker = function(markerName) {
    this.getFrameworkMap().callMethod(this.getId(), "removeMarker", markerName);
};

FlamingoMap.prototype.removeAllMarkers = function(markerName) {
    this.getFrameworkMap().callMethod(this.getId(), "removeMarker", markerName);
};

/**
 *see @link Map.getScale
 *@deprecated use: getResolution because it returns the resolution and not the scale
 */
FlamingoMap.prototype.getScale = function() {
    return this.getResolution();
};

/**
 *see @link Map.getResolution
 */
FlamingoMap.prototype.getResolution = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getScale");
};

/**
 *see @link Map.getScaleHint
 */
FlamingoMap.prototype.getScaleHint = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getScaleHint");
};

/**
 * see @link Map.coordinateToPixel
 * @param x
 * @param y
 */
FlamingoMap.prototype.coordinateToPixel = function(x, y) {
    return this.getFrameworkMap().callMethod(this.getId(), "coordinate2Point", {
        x: x,
        y: y
    });
};

/**
 * see @link Map.getCenter
 */
FlamingoMap.prototype.getCenter = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getCenter");
};

/**
 *Get the width in pixels of the map
 */
FlamingoMap.prototype.getScreenWidth = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getMovieClipWidth");
};

/**
 *Get the height in pixels of the map
 */
FlamingoMap.prototype.getScreenHeight = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getMovieClipHeight");
};

/**
 *Get the height in pixels of the map
 */
FlamingoMap.prototype.isUpdating = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "isUpdating");
};

/**
 * Set the tiling resolutions on the Map
 * @param resolutions comma or space seperated list of resolutions
 */
FlamingoMap.prototype.setTilingResolutions = function(resolutions) {
    var res = resolutions.trim();

    if (res.indexOf(",") == -1) {
        res = replaceAll(res, " ", ",");
    }

    this.getFrameworkMap().callMethod(this.getId(), "setResolutionsByString", res);
};

FlamingoMap.prototype.getTilingResolutions = function() {
    return this.getFrameworkMap().callMethod(this.getId(), "getResolutions");
};

/**
 *see @link Map.updateSize
 */
FlamingoMap.prototype.updateSize = function() {
};

function replaceAll(stack, needle, replaceWith) {
    return stack.replace(new RegExp(needle, 'g'), replaceWith);
}

/** The FlamingLayer Class 
 * @param id
 * @param options
 * @param flamingoObject
 * **/
function FlamingoLayer(id, options, flamingoObject) {
    if (id == null) {
        id = "";
    }
    this.id = id;
    this.options = options;
    Layer.call(this, flamingoObject, id);
}
FlamingoLayer.prototype = new Layer();
FlamingoLayer.prototype.constructor = FlamingoLayer;

FlamingoLayer.prototype.getType = function() {
    return Layer.RASTER_TYPE;
};

FlamingoLayer.prototype.getId = function() {
    return this.id;
};

FlamingoLayer.prototype.toXML = function() {
    throw("FlamingoLayer.toXML(): .toXML() must be implemented by Layer subclass!");
};

FlamingoLayer.prototype.getTagName = function() {
    throw("FlamingoLayer.getTagName: .getTagName() must be made!");
};

/**
 *Gets a option of this layer
 *@param optionKey
 *@return the option value or null if not exists
 */
FlamingoLayer.prototype.getOption = function(optionKey) {
    var availableOptions = ""
    for (var op in this.options) {
        if (op.toLowerCase() == optionKey.toLowerCase())
            return this.options[op];
        availableOptions += op + ",";
    }
    return null;
};

/**
 *sets or overwrites a option
 *@param optionKey
 *@param optionValue
 */
FlamingoLayer.prototype.setOption = function(optionKey, optionValue) {
    this.options[optionKey] = optionValue;
};

FlamingoLayer.prototype.setOpacity = function(opacity) {
    var alpha = 100 - opacity * 100;
    this.frameworkLayer.callMethod(webMapController.getMap().getId() + "_" + this.getId(), "setAlpha", alpha);
};

/** The FlamingoVectorLayer class. In flamingo also known as EditMap. 
 * @param id
 * @param flamingoObject
 * **/
function FlamingoVectorLayer(id, flamingoObject) {
    FlamingoLayer.call(this, id, null, flamingoObject);
    this.layerName = "layer1";
}

FlamingoVectorLayer.prototype = new FlamingoLayer();
FlamingoVectorLayer.prototype.constructor = FlamingoVectorLayer;

FlamingoVectorLayer.prototype.getType = function() {
    return Layer.VECTOR_TYPE;
};

FlamingoVectorLayer.prototype.toXML = function() {
    return "";
};

FlamingoVectorLayer.prototype.getLayerName = function() {
    return this.layerName;
};

/**
 * Removes all the features from this vectorlayer
 */
FlamingoVectorLayer.prototype.removeAllFeatures = function() {
    var flamingoObj = this.getFrameworkLayer();
    flamingoObj.callMethod(this.getId(), 'removeAllFeatures');
};


/**
 * Gets the active feature from this vector layer
 * @return The active - generic type - feature from this vector layer.
 */
FlamingoVectorLayer.prototype.getActiveFeature = function() {
    var flamingoObj = this.getFrameworkLayer();
    var flaFeature = flamingoObj.callMethod(this.id, 'getActiveFeature');

    /* als er geen tekenobject op scherm staat is flaFeature null */
    if (flaFeature == null) {
        return null;
    }

    var featureObj = new Feature();
    var feature = featureObj.fromFlamingoFeature(flaFeature);

    return feature;
};

/**
 * Get the feature on the given index
 * @param index The index of the feature.
 * @return The generic feature type on index
 */
FlamingoVectorLayer.prototype.getFeature = function(index) {
    return this.getAllFeatures()[index];
};

/**
 * Add a feature to this vector layer.
 * @param feature The generic feature to be added to this vector layer.
 */
FlamingoVectorLayer.prototype.addFeature = function(feature) {
    var flamingoObj = this.getFrameworkLayer();
    flamingoObj.callMethod(this.getId(), 'addFeature', this.getLayerName(), feature.toFlamingoFeature());
};

/**
 * Gets all features on this vector layer
 * @return Array of generic features.
 */
FlamingoVectorLayer.prototype.getAllFeatures = function() {
    var flamingoObj = this.getFrameworkLayer();
    var flamingoFeatures = flamingoObj.callMethod(this.getId(), "getAllFeaturesAsObject");
    var features = new Array();
    var featureObj = new Feature();
    for (var i = 0; i < flamingoFeatures.length; i++) {
        var flFeature = flamingoFeatures[i];
        var feature = featureObj.fromFlamingoFeature(flFeature);
        features.push(feature);
    }
    return features;
};

FlamingoVectorLayer.prototype.drawFeature = function(type) {
    this.getFrameworkLayer().callMethod(this.getId(), "editMapDrawNewGeometry", this.getLayerName(), type);
};

/* stop editing */
FlamingoVectorLayer.prototype.stopDrawDrawFeature = function() {
    this.getFrameworkLayer().callMethod(this.getId(), "removeEditMapCreateGeometry", this.getLayerName());
};

/** Flamingo WMS layer class 
 * @param id
 * @param options
 * @param flamingoObject
 * **/
function FlamingoWMSLayer(id, options, flamingoObject) {
    FlamingoLayer.call(this, id, options, flamingoObject);
    this.url = null;
}

FlamingoWMSLayer.prototype = new FlamingoLayer();
FlamingoWMSLayer.prototype.constructor = FlamingoWMSLayer;

FlamingoWMSLayer.prototype.getTagName = function() {
    return "LayerOGWMS";
};

/**
 *Gets the last wms request-url of this layer
 *@returns the WMS getMap Reqeust.
 */
FlamingoWMSLayer.prototype.getURL = function() {
    return this.url;
};

FlamingoWMSLayer.prototype.setURL = function(url) {
    this.url = url;
};

/**
 *makes a xml string so the object can be added to flamingo
 *@return a xml string of this object
 **/
FlamingoWMSLayer.prototype.toXML = function() {
    var xml = "<fmc:";
    xml += this.getTagName();
    xml += " xmlns:fmc=\"fmc\"";
    xml += " id=\"" + this.getId() + "\"";
    //xml+=" initService=\""+this.getOption("initService")+"\"";
    xml += " url=\"" + this.getOption("url");
    //fix for SLD support in flamingo
    if (this.getOption("sld") && this.getOption("url")) {
        xml += this.getOption("url").indexOf("?") >= 0 ? "&" : "?";
        xml += "sld=" + this.getOption("sld") + "&";
    }
    xml += "\"";
    for (var optKey in this.options) {
        //skip these options.
        if (optKey.toLowerCase() == "url" ||
                optKey.toLowerCase() == "sld") {
        }
        else {
            xml += " " + optKey + "=\"" + this.options[optKey] + "\"";
        }
    }
    xml += ">";
    //add the maptips
    for (var i = 0; i < this.getMapTips().length; i++) {
        var maptip = this.getMapTips()[i];
        xml += "<layer";
        xml += " id=\"" + maptip.layer + "\"";
        if (maptip.mapTipField != null)
            xml += " maptip=\"" + maptip.mapTipField + "\"";
        if (maptip.aka != null) {
            xml += " aka=\"" + maptip.aka + "\"";
        }
        xml += "/>";
    }
    xml += "</fmc:" + this.getTagName() + ">";

    return xml;
};

/**
 *Get the id of this layer
 */
FlamingoWMSLayer.prototype.getId = function() {
    return this.id;
};

FlamingoWMSLayer.prototype.reload = function() {
    this.getFrameworkLayer().callMethod(webMapController.getMap().getId() + "_" + this.getId(), "setConfig", this.toXML());
};

FlamingoWMSLayer.prototype.setVisible = function(visibility) {
    this.setOption("visible", visibility);

    this.reload();
};

/** 
 * @param id
 * @param options
 * @param flamingoObject
 * **/
function FlamingoTilingLayer(id, options, flamingoObject) {
    FlamingoLayer.call(this, id, options, flamingoObject);
}

FlamingoTilingLayer.prototype = new FlamingoLayer();
FlamingoTilingLayer.prototype.constructor = FlamingoTilingLayer;

FlamingoTilingLayer.prototype.getTagName = function() {
    return "TilingLayer";
};

function rtrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}

FlamingoTilingLayer.prototype.toXML = function() {
    var xml = "<fmc:";
    xml += this.getTagName();
    xml += " xmlns:fmc=\"fmc\"";
    xml += " id=\"" + this.getId() + "\"";
    //xml+=" initService=\""+this.getOption("initService")+"\"";
    xml += " serviceurl=\"" + this.getOption("url");
    xml += "\"";
    if (this.getOption("resolutions") != null) {
        var res = this.getOption("resolutions");

        /* als er in service bij de resolutions een spatie achter staat deze eerst 
         * weghalen zodat er geen komma aan het einde komt. 
         */
        res = rtrim(res, " ");

        res = res.replace(/ /g, ",");
        xml += " resolutions=\"" + res + "\"";
    }
    xml += " minscale=\"" + this.getOption("minscale") + "\"";
    xml += " maxscale=\"" + this.getOption("maxscale") + "\"";
    xml += " serviceenvelope=\"" + this.getOption("bbox") + "\"";
    xml += " type=\"" + this.getOption("type") + "\"";
    if (this.getOption("tileheight") != null)
        xml += " tileheight=\"" + this.getOption("tileheight") + "\"";
    if (this.getOption("tilewidth") != null)
        xml += " tilewidth=\"" + this.getOption("tilewidth") + "\"";
    /*for (var optKey in this.options){
     //skip these options.
     if (optKey.toLowerCase()== "url" ||
     optKey.toLowerCase()== "sld"){}
     else{
     xml+=" "+optKey+"=\""+this.options[optKey]+"\"";
     }
     }*/
    xml += ">";
    //add the maptips
    for (var optKey in this.options) {
        //skip these options.
        if (optKey.toLowerCase() == "url" ||
                optKey.toLowerCase() == "resolutions" ||
                optKey.toLowerCase() == "bbox" ||
                optKey.toLowerCase() == "type" ||
                optKey.toLowerCase() == "tileheight" ||
                optKey.toLowerCase() == "tilewidth") {
        }
        else {
            xml += "<TilingParam name=\"" + optKey + "\">" + this.options[optKey] + "</TilingParam>";
        }
    }
    xml += "</fmc:" + this.getTagName() + ">";

    return xml;
};

/** The flamingo Tool Class 
 * @param id
 * @param flamingoObject
 * **/
function FlamingoTool(id, flamingoObject) {
    Tool.call(this, id, flamingoObject);
}
FlamingoTool.prototype = new Tool();
FlamingoTool.prototype.constructor = FlamingoTool;

FlamingoTool.prototype.setVisible = function(visibility) {
    this.getFrameworkTool().callMethod(this.getId(), 'setVisible', visibility);
};