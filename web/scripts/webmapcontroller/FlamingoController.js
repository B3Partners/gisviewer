/**
 *Controller subclass for Flamingo
 **/
function FlamingoController(domId){
    var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "100%", "100%", "8", "#FFFFFF");
    so.addParam("wmode", "transparent");
    so.write(domId);
    this.viewerObject = document.getElementById("flamingo");
    
    Controller.call(this,domId);
}
//extends Controller
FlamingoController.prototype = new Controller();
FlamingoController.prototype.constructor=FlamingoController;

/**
* Initialize the events. These events are specific for flamingo.
*/
FlamingoController.prototype.initEvents = function(){
    this.eventList[Event.ON_EVENT_DOWN]              	= "onEvent";
    this.eventList[Event.ON_EVENT_UP]                	= "onEvent";
    this.eventList[Event.ON_GET_CAPABILITIES]        	= "onGetCapabilities";
    this.eventList[Event.ON_CONFIG_COMPLETE]         	= "onConfigComplete";
    this.eventList[Event.ON_FEATURE_ADDED]		= "onGeometryDrawFinished";
    this.eventList[Event.ON_REQUEST]			= "onRequest";
    this.eventList[Event.ON_CHANGE_TOOL]		= "onSetTool";
    this.eventList[Event.ON_GET_FEATURE_INFO]		= "onIdentify";
    this.eventList[Event.ON_GET_FEATURE_INFO_DATA]	= "onIdentifyData";
}

/**
*Creates a Openlayers.Map object for this framework. See the openlayers.map docs
*@param id the id of the map that is configured in the configuration xml
*@returns a FlamingoController
*/
FlamingoController.prototype.createMap = function(id){
    return new FlamingoMap(id,this.viewerObject);
}

/**
*See @link Controller.createWMSLayer
*/
FlamingoController.prototype.createWMSLayer = function(name, url,ogcParams,options){
    var object=new Object();
    object["name"]=name;
    object["url"]=url;
    var id=null;
    for (var key in ogcParams){
        object[key]=ogcParams[key];
    }
    for (var key in options){
        if (key.toLowerCase()=="id"){
            id=options[key];
        }else{
            object[key]=options[key];
        }
    }
    return new FlamingoWMSLayer(id,object,this.viewerObject);
}
/**
* See @link Controller.createTool
* TODO: make the parameter layer part of the options. 
*/
FlamingoController.prototype.createTool= function (id,type,layer,options){
    var tool = new FlamingoTool(id,this.viewerObject);
    if(type == Tool.GET_FEATURE_INFO){
        webMapController.registerEvent(Event.ON_GET_FEATURE_INFO, webMapController.getMap(), options["handlerBeforeGetFeatureHandler"]);
        webMapController.registerEvent(Event.ON_GET_FEATURE_INFO_DATA, webMapController.getMap(), options["handlerGetFeatureHandler"]);
}
    return tool;
}

/**
* See @link Controller.createVectorLayer
*/
FlamingoController.prototype.createVectorLayer = function (id){
    return new FlamingoVectorLayer(id,this.viewerObject);
}

/**
*See @link Controller.addTool
*/
FlamingoController.prototype.addTool = function(tool){
    if (!(tool instanceof FlamingoTool)){
        throw("The given tool is not of type 'FlamingoTool'");
    }
    this.viewerObject.callMethod(tool.getId(),'setVisible',true);
    Controller.prototype.addTool.call(this,tool);
}

/**
*See @link Controller.removeTool
*/
FlamingoController.prototype.removeTool = function (tool){
    if (!(tool instanceof FlamingoTool)){
        throw("The given tool is not of type 'FlamingoTool'");
    }
    this.viewerObject.callMethod(tool.getId(),'setVisible',false);
    Controller.prototype.removeTool.call(this,tool);
}
/**
*Add a map to the controller.
*For know only 1 map supported.
*/
FlamingoController.prototype.addMap = function (map){
    if (!(map instanceof FlamingoMap)){
        throw("FlamingoController.addMap(): The given map is not of the type 'FlamingoMap'");
    }
    this.maps.push(map);
}

/**
* See @link Controller.removeToolById
*/
FlamingoController.prototype.removeToolById = function (id){
    var tool = this.getTool(id);
    if(tool == null || !(tool instanceof FlamingoTool)){
        throw("The given tool is not of type 'FlamingoTool' or the given id does not exist");
    }
    this.removeTool(tool);
}

/**
*Get the map by id. If no id is given and 1 map is available that map wil be returned
*@param mapId the mapId
*@returns the Map with the id, or the only map.
*/
FlamingoController.prototype.getMap = function (mapId){
    if (mapId==undefined && this.maps.length==1){
        return this.maps[0];
    }
    var availableMaps="";
    for (var i=0; i < this.maps.length; i++){
        if (i!=0)
            availableMaps+=",";
        availableMaps+=this.maps[i].getId();
        if (this.maps[i].getId()==mapId){
            return this.maps[i];
        }
    }
    throw("FlamingoController.getMap(): Map with id: "+mapId+" not found! Available maps: "+availableMaps);
}

/****************************************************************Event handling***********************************************************/

/**
 * Registers an event to a handler, on a object. Flamingo doesn't implement per component eventhandling,
 * so this controller stores the event in one big array.
 * This array is a two-dimensional array: the first index is the eventname (the generic one! Actually, not a name, but the given id).
 * The second index is the id of the object. 
 */
FlamingoController.prototype.registerEvent = function (event,object,handler){
    if( this.events[event] == undefined){
        this.events[event] = new Object();
    }
    this.events[event][object.getId()] = handler;
}

/**
 * Handles all the events. This function retrieves the function registered to this event.
 * Flamingo doesn't understand per object eventhandling, but instead it fires an event, with a id of the object (and a bunch of parameters).
 * In this function we translate the events to per object events, and more specific events (button up/down)
 */
FlamingoController.prototype.handleEvents = function (event, component){
    var id = component[0];
    // onEvent is a general event, fired when a jsButton is hovered over, pressed or released. Here we specify which it was.
    if(event == "onEvent"){
        if(component[1]["down"]){
            event = Event.ON_EVENT_DOWN;
        }else{
            // TODO: specify more events. This is not ONLY ON_EVENT_UP, but also hover.
            event = Event.ON_EVENT_UP;
        }
    }else{
        // Translate the specific name to the generic name. 
        event = this.getGenericEventName(event);
    }
    if (event=="onRequest"){
        var obj=component[2];
        if (obj.requesttype=="GetMap"){
            var tokens= component[0].split("_");
            if (tokens.length==2){
                this.getMap(tokens[0]).getLayer(tokens[1]).setURL(obj.url);
            }
        }        
    }else if(event==this.eventList[Event.ON_CHANGE_TOOL]){
        //onchange tool is called for a tool group but event is registerd on the controller
        id=this.getId();
    }else{
        if(event == "onGeometryDrawFinished"){
			// Make sure "component" is the drawn feature
            var feature = new Feature(id,component[1]);
            component = feature;
        }else if( event == "onIdentify"){
            component = component[1];
        }else if( event == "onIdentifyData"){
            component = component[2];
        }
    }    
    this.events[event][id](id,component);
}

/**
 * Entrypoint for flamingoevents. This function propagates the events to the webMapController (handleEvents).
 */
function dispatchEventJS(event, comp) {
    if(comp [0]== null){
        comp[0] = webMapController.getId();
        comp[1] = new Object();
    }
    console.log("event:",event);
    webMapController.handleEvents(event,comp);
}

/** Flamingomap */
function FlamingoMap(id,flamingoObject){
    if (id==undefined || flamingoObject==undefined)
        throw("FlamingoMap.constructor: Id or Flamingo object is undefined");
    this.id=id;
    Map.call(this,flamingoObject);
}
//set inheritance
FlamingoMap.prototype = new Map();
FlamingoMap.prototype.constructor=FlamingoMap;

/**
*See @link Map.getId
*/
FlamingoMap.prototype.getId = function(){
    return this.id;
}

/**
 *See @link Map.getAllWMSLayers
 */
FlamingoMap.prototype.getAllWMSLayers = function(){
    var lagen = new Array();
    for(var i = 0 ; i < this.layers.length;i++){
        if(this.layers[i] instanceof FlamingoWMSLayer){
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
}
/**
 *See @link Map.getAllVectorLayers
 */
FlamingoMap.prototype.getAllVectorLayers = function(){
    var lagen = new Array();
    for(var i = 0 ; i < this.layers.length;i++){
        if(this.layers[i] instanceof FlamingoVectorLayer){
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
}
/**
*see @link Map.remove
*/
FlamingoMap.prototype.remove = function(){
    this.getFrameworkMap().callMethod("flamingo","killComponent",this.getId());
}

/**
*Add a layer(service) to the map
*@param layer a FlamingoLayer that needs to be added.
*see @link Map.addLayer
**/
FlamingoMap.prototype.addLayer = function(layer){
    if (!(layer instanceof FlamingoLayer))
        throw("FlamingoMap.addLayer(): Given layer not of type FlamingoLayer");
    //call super function
    Map.prototype.addLayer.call(this,layer);
    if (!(layer instanceof FlamingoVectorLayer)){
        this.getFrameworkMap().callMethod(this.getId(),'addLayer',layer.toXML());
    }
}
    
/**
*remove the specific layer. See @link Map.removeLayer
**/
FlamingoMap.prototype.removeLayer=function(layer){
    if (!(layer instanceof FlamingoLayer))
        throw("FlamingoMap.removeLayer(): Given layer not of type FlamingoLayer");
    //call super function
    Map.prototype.removeLayer.call(this,layer);
    if (!(layer instanceof FlamingoVectorLayer)){
        this.getFrameworkMap().callMethod(this.getId(),'removeLayer',this.getId()+'_'+layer.getId());
    }
}

/**
*see @link Map.setLayerIndex
*/
FlamingoMap.prototype.setLayerIndex = function (layer, newIndex){
    if (!(layer instanceof FlamingoLayer)){
        throw("FlamingoMap.setLayerIndex(): Given layer not of type FlamingoLayer.");
    }

    if (!(layer instanceof FlamingoVectorLayer)){
        this.getFrameworkMap().callMethod(this.getId(),"swapLayer",this.getId()+'_'+layer.getId(),newIndex);
    }
    return Map.prototype.setLayerIndex(layer,newIndex);
}
/**
* See @link Map.zoomToExtent
*/
FlamingoMap.prototype.zoomToExtent = function (extent){
    this.getFrameworkMap().callMethod(this.getId(), "moveToExtent", extent, 0);
}

/**
* See @link Map.zoomToMaxExtent
*/
FlamingoMap.prototype.zoomToMaxExtent = function(){
    this.zoomToExtent(this.getFrameworkMap().callMethod(this.getId(), "getFullExtent"));
}

/**
* see @link Map.setMaxExtent
*/
FlamingoMap.prototype.setMaxExtent=function(extent){
    this.getFrameworkMap().callMethod(this.getId(), "setFullExtent", extent);
}
/**     
*See @link Map.getFullExtent()
*/
FlamingoMap.prototype.getMaxExtent=function(){
    var extent=this.getFrameworkMap().callMethod(this.getId(), "getFullExtent");
    return new Extent(extent.minx,extent.miny,extent.maxx,extent.maxy);
}

/**
*See @link Map.doIdentify
*/
FlamingoMap.prototype.doIdentify = function(x,y){
    throw("Map.doIdentify() Not implemented!");
}

/**
*see @link Map.getExtent
*/
FlamingoMap.prototype.getExtent= function(){
    var extent= this.getFrameworkMap().callMethod(this.getId(),'getExtent');
    return new Extent(extent.minx,extent.miny,extent.maxx,extent.maxy);
}

/**
*see @link Map.update
*/
FlamingoMap.prototype.update = function (){
    this.getFrameworkMap().callMethod(this.getId(),'update', 100, true);
}

/**
*see @link Map.setMarker
*/
FlamingoMap.prototype.setMarker = function(markerName,x,y,type){
    this.getFrameworkMap().callMethod(this.getId(),"setMarker",markerName,type,Number(x),Number(y));
}
/**
*see @link Map.removeMarker
*/
FlamingoMap.prototype.removeMarker = function(markerName){
    this.getFrameworkMap().callMethod(this.getId(),"removeMarker",markerName);
}

/** The FlamingLayer Class **/
function FlamingoLayer(id,options,flamingoObject){
    if (id==null){
        id="";
    }
    this.id=id;
    this.options=options;
    Layer.call(this,flamingoObject,id);
}
FlamingoLayer.prototype = new Layer();
FlamingoLayer.prototype.constructor = FlamingoLayer;



FlamingoLayer.prototype.getId = function(){
    return this.id;
}

FlamingoLayer.prototype.toXML = function(){
    throw("FlamingoLayer.toXML(): .toXML() must be made!");
}

FlamingoLayer.prototype.getTagName = function(){
    throw("FlamingoLayer.getTagName: .getTagName() must be made!");
}

/**
*Gets a option of this layer
*@return the option value or null if not exists
*/
FlamingoLayer.prototype.getOption = function(optionKey){
    var availableOptions=""
    for (var op in this.options){
        if (op.toLowerCase()==optionKey.toLowerCase())
            return this.options[op];
        availableOptions+=op+",";
    }
    return null;
}
/**
*sets or overwrites a option
*/
FlamingoLayer.prototype.setOption = function(optionKey,optionValue){
    this.options[optionKey]=optionValue;
}

/** The FlamingoVectorLayer class. In flamingo also known as EditMap. **/
function FlamingoVectorLayer(id,flamingoObject){
    FlamingoLayer.call(this,id,null,flamingoObject);
    this.layerName = "layer1";
}
FlamingoVectorLayer.prototype = new FlamingoLayer();
FlamingoVectorLayer.prototype.constructor= FlamingoVectorLayer;

FlamingoVectorLayer.prototype.toXML = function(){
    return "";
}

FlamingoVectorLayer.prototype.getLayerName = function(){
    return this.layerName;
}

/**
* Removes all the features from this vectorlayer
*/
FlamingoVectorLayer.prototype.removeAllFeatures = function(){
    var flamingoObj = this.getFrameworkLayer();
    flamingoObj.callMethod(this.getId(),'removeAllFeatures');
}


/**
* Gets the active feature from this vector layer
* @return The active - generic type - feature from this vector layer.
*/
FlamingoVectorLayer.prototype.getActiveFeature = function(){
    var flamingoObj = this.getFrameworkLayer();
    var flaFeature = flamingoObj.callMethod(this.id,'getActiveFeature');
    var feature = Feature.fromFlamingoFeature(flaFeature);

    return feature;
}

/**
* Get the feature on the given index
* @param index The index of the feature.
* @return The generic feature type on index
*/
FlamingoVectorLayer.prototype.getFeature = function(index){
    return this.getAllFeatures()[index];
}

/**
* Add a feature to this vector layer.
* @param feature The generic feature to be added to this vector layer.
*/
FlamingoVectorLayer.prototype.addFeature = function(feature){
    var flamingoObj = this.getFrameworkLayer();
    flamingoObj.callMethod(this.getId(),'addFeature',this.getLayerName(),feature.toFlamingoFeature());
}

/**
* Gets all features on this vector layer
* @return Array of generic features.
*/
FlamingoVectorLayer.prototype.getAllFeatures = function(){
    var flamingoObj = this.getFrameworkLayer();
    var flamingoFeatures = flamingoObj.callMethod(this.getId(),"getAllFeaturesAsObject");
    var features = new Array();
    for(var i = 0 ; i< flamingoFeatures.length ; i++){
        var flFeature = flamingoFeatures[i];
        var feature = Feature.fromFlamingoFeature(flFeature);
        features.push(feature);
    }
    return features;
}
    
/** Flamingo WMS layer class **/
function FlamingoWMSLayer(id,options,flamingoObject){
    FlamingoLayer.call(this,id,options,flamingoObject);
    this.url=null;
}
FlamingoWMSLayer.prototype = new FlamingoLayer();
FlamingoWMSLayer.prototype.constructor= FlamingoWMSLayer;

FlamingoWMSLayer.prototype.getTagName = function(){
    return "LayerOGWMS";
}
/**
 *Gets the last wms request-url of this layer
 *@returns the WMS getMap Reqeust.
 */
FlamingoWMSLayer.prototype.getURL = function(){
    return this.url;
}
FlamingoWMSLayer.prototype.setURL = function(url){
    this.url= url;
}
/**
*makes a xml string so the object can be added to flamingo
*@return a xml string of this object
**/
FlamingoWMSLayer.prototype.toXML = function(){
    var xml="<fmc:";
    xml+=this.getTagName();
    xml+=" xmlns:fmc=\"fmc\"";
    xml+=" id=\""+this.getId()+"\"";
    xml+=" url=\""+this.getOption("url");
    //fix for SLD support in flamingo
    if (this.getOption("sld") && this.getOption("url")){
        xml+=this.getOption("url").indexOf("?")>=0 ? "&" : "?";
        xml+="sld="+this.getOption("sld")+"&";
    }
    xml+="\"";
    for (var optKey in this.options){
        //skip these options.
        if (optKey.toLowerCase()== "url" ||
            optKey.toLowerCase()== "sld"){}
        else{
            xml+=" "+optKey+"=\""+this.options[optKey]+"\"";
        }
    }
    xml+="/>";
    return xml;
}

/**
*Get the id of this layer
*/
FlamingoWMSLayer.prototype.getId =function (){
    return this.id;
}

/** The flamingo Tool Class **/
function FlamingoTool(id,flamingoObject){
    Tool.call(this,id,flamingoObject);
}
FlamingoTool.prototype = new Tool();
FlamingoTool.prototype.constructor= FlamingoTool;

FlamingoTool.prototype.setVisible = function(visibility){
    this.getFrameworkTool().callMethod(this.getId(),'setVisible',visibility);
}
