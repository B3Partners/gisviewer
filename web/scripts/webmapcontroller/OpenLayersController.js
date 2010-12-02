/**
 *Controller subclass for OpenLayers
 */
function OpenLayersController(){
    this.panel=null;
    Controller.call(this,'');
}
//extends Controller
OpenLayersController.prototype = new Controller();
OpenLayersController.prototype.constructor=OpenLayersController;

OpenLayersController.prototype.initEvents = function(){
    this.eventList[Event.ON_EVENT_DOWN]         = "activate";
    this.eventList[Event.ON_EVENT_UP]           = "deactivate";
    this.eventList[Event.ON_GET_CAPABILITIES]   = "onGetCapabilities";
    this.eventList[Event.ON_CONFIG_COMPLETE]    = "onConfigComplete";
    this.eventList[Event.ON_FEATURE_ADDED]      = "featureadded";
    this.eventList[Event.ON_CLICK]              = "click";
    this.eventList[Event.ON_CHANGE_TOOL]	= "activate";
}
/**
     *Gets the panel of this controller and OpenLayers.Map. If the panel is still
     *null, the panel is created and added to the map.
     *@return a OpenLayers.Control.Panel
     */
OpenLayersController.prototype.getPanel = function(){
    if (this.panel==null){
        this.panel=new OpenLayers.Control.Panel();
        this.maps[0].getFrameworkMap().addControl(this.panel);
    }
    return this.panel;
}

OpenLayersController.prototype.createPanel = function (controls){
    var panel= new OpenLayers.Control.Panel();
    panel.addControls(controls);
}
/**
     *Creates a Openlayers.Map object for this framework. See the openlayers.map docs
     *@param id the id the DomElement where the map must be set
     *@param options extra options for the map. See the OpenLayers.Map docs.
     *@returns a OpenLayersMap
     */
OpenLayersController.prototype.createMap = function(id, options){
    options["theme"]=OpenLayers._getScriptLocation()+'theme/b3p/style.css';
    var map=new OpenLayers.Map(id,options);
    return new OpenLayersMap(map);
}
/**
     *See @link Controller.createWMSLayer
     */
OpenLayersController.prototype.createWMSLayer = function(name, wmsurl,ogcParams,options){
    options["id"]=null;
    options["isBaseLayer"]=false;
    options["singleTile"]=true;
    var wmsLayer = new OpenLayersWMSLayer(new OpenLayers.Layer.WMS(name,wmsurl,ogcParams,options),name);
    if(ogcParams["query_layers"] != null && ogcParams["query_layers"] != ""){

        var info = new OpenLayers.Control.WMSGetFeatureInfo({
            url: wmsurl,
            title: 'Identify features by clicking',
            queryVisible: true,
            layers: [wmsLayer.getFrameworkLayer()],
            queryLayers : ogcParams["query_layers"],
            infoFormat : "text/xml"
        });
        info.request = doGetFeatureRequest;
        wmsLayer.setGetFeatureInfoControl(info);
    }

    return wmsLayer;
}

/**
     *Create a tool: the initializing of a piece of functionality to link to a button
     *
     * type: the type of the tool. Possible values: DRAW_FEATURE, ...
     * layer: the layer on which the tool has effect. Possible values: handlerType,container
     * options: the options used for initializing the Tool 
     **/
OpenLayersController.prototype.createTool= function (id,type,layer, options){
    if (type==Tool.DRAW_FEATURE){
        //  var container = params["container"];

        var toolbar= new OpenLayers.Control.EditingToolbar( layer.getFrameworkLayer() );
        
        // Voeg de individuele knoppen toe
        var openLayersTools = new Array();
        openLayersTools.push(new OpenLayersTool(id,toolbar.controls[1],type));
        openLayersTools.push(new OpenLayersTool(id,toolbar.controls[2],type));
        openLayersTools.push(new OpenLayersTool(id,toolbar.controls[3],type));
        
       
        return openLayersTools;
    }else if (type==Tool.NAVIGATION_HISTORY){
        return new OpenLayersTool(id,new OpenLayers.Control.NavigationHistory(),type);
    }else if (type==Tool.ZOOM_BOX){
        return new OpenLayersTool(id,new OpenLayers.Control.ZoomBox(),type);
    }else if (type==Tool.PAN){
        return new OpenLayersTool(id,new OpenLayers.Control.Navigation(),type)
    }else if (type==Tool.BUTTON){
        return new OpenLayersTool(id,new OpenLayers.Control(
        {
            displayClass: "olControl"+id,
            type: OpenLayers.Control.TYPE_BUTTON
        }
        ),type);
    }else if (type==Tool.TOGGLE){
        return new OpenLayersTool(id,new OpenLayers.Control(
        {
            displayClass: "olControl"+id,
            type: OpenLayers.Control.TYPE_TOGGLE
        }
        ),type);
    }else if (type==Tool.CLICK){
        return new OpenLayersTool(id,new OpenLayers.Control.Click(
        {
            displayClass: "olControl"+id
        }),type);
    }else if (type==Tool.LOADING_BAR){
        return new OpenLayersTool(id,new OpenLayers.Control.LoadingPanel(),type);
    }else if (type == Tool.GET_FEATURE_INFO) {
        var identifyTool = new OpenLayersIdentifyTool(id,new OpenLayers.Control(
        {
            displayClass: "olControl"+id,
            type: OpenLayers.Control.TYPE_TOOL
        }
        ),type);            
        identifyTool.getFrameworkTool().events.register("activate",this,this.activateGetFeatureControls);
        identifyTool.getFrameworkTool().events.register("deactivate",this,this.deactivateGetFeatureControls);

        identifyTool.setGetFeatureInfoHandler(options["handlerGetFeatureHandler"]);
        identifyTool.setBeforeGetFeatureInfoHandler(options["handlerBeforeGetFeatureHandler"]);
        //this.getMap().setGetFeatureInfoControl(identifyTool);
        return identifyTool;
    }else{
        throw ("Type >" + type + "< not recognized. Please use existing type.");
    }
}

OpenLayersController.prototype.activateGetFeatureControls = function(){
    var layers=this.getMap().getAllWMSLayers();
    //var controls = webMapController.getMap().getGetFeatureInfoControl().controls;
    for (var i = 0 ; i< layers.length ; i++ ){
        var con = layers[i].getGetFeatureInfoControl();
        if (con!=null)
            con.activate();
    }
}

OpenLayersController.prototype.deactivateGetFeatureControls = function(){
    var layers=this.getMap().getAllWMSLayers();
    //var controls = webMapController.getMap().getGetFeatureInfoControl().controls;
    for (var i = 0 ; i< layers.length ; i++ ){
        var con = layers[i].getGetFeatureInfoControl();
        if (con!=null)
            con.deactivate();
    }
}
/**
     *See @link Controller.addTool
     */
OpenLayersController.prototype.addTool = function(tool){
    /* if (!(tool instanceof OpenLayersTool)){
        throw("The given tool is not of type 'OpenLayersTool'");
    }*/
    if (this.maps.length==0){
        throw("No map in Controller!");
    }
    if( tool instanceof Array){
        for(var i = 0 ; i < tool.length; i++){
            this.getMap().getFrameworkMap().addControl(tool[i].getFrameworkTool());
            this.addTool(tool[i]);
            Controller.prototype.addTool.call(this,tool[i]);
        }
    }else if (tool.getType()==Tool.NAVIGATION_HISTORY){
        this.maps[0].getFrameworkMap().addControl(tool.getFrameworkTool());
        this.getPanel().addControls([tool.getFrameworkTool().next, tool.getFrameworkTool().previous]);
    }else if (tool.getType() == Tool.CLICK){
        this.maps[0].getFrameworkMap().addControl(tool.getFrameworkTool());
        this.getPanel().addControls([tool.getFrameworkTool().button]);
    }else if (tool.getType() == Tool.LOADING_BAR){
        this.maps[0].getFrameworkMap().addControl(tool.getFrameworkTool());
    }else if( tool.getType() == Tool.GET_FEATURE_INFO ){
        this.getPanel().addControls([tool.getFrameworkTool()]);
        this.maps[0].getFrameworkMap().addControl(tool.getFrameworkTool());
    }else{
        this.getPanel().addControls([tool.getFrameworkTool()]);
    }

    if(!(tool instanceof Array) ){
        Controller.prototype.addTool.call(this,tool);
    }
}

OpenLayersController.prototype.removeToolById = function (id){
    var tool = this.getTool(id);
    this.removeTool(tool);
}

/**
     *See @link Controller.removeTool
     */
OpenLayersController.prototype.removeTool = function (tool){
    if (!(tool instanceof OpenLayersTool)){
        throw("The given tool is not of type 'OpenLayersTool'");
    }    
    if (tool.type==Tool.NAVIGATION_HISTORY){
        OpenLayers.Util.removeItem(this.getPanel().controls, tool.getFrameworkTool().next);
        OpenLayers.Util.removeItem(this.getPanel().controls, tool.getFrameworkTool().previous);
        tool.getFrameworkTool().destroy();
    }else{
        OpenLayers.Util.removeItem(this.getPanel().controls, tool.getFrameworkTool());
    }
    this.maps[0].getFrameworkMap().removeControl(tool.getFrameworkTool());
    if (this.getPanel().controls.length==0){
        this.getPanel().destroy();
        this.panel=null
    }else{
        this.getPanel().redraw();
    }
    Controller.prototype.removeTool.call(this,tool);
}
/**Add a map to the controller.
     *For know only 1 map supported.
     */
OpenLayersController.prototype.addMap = function (map){
    if (!(map instanceof OpenLayersMap)){
        throw("The given map is not of the type 'OpenLayersMap'");
    }
    if (this.maps.length>=1)
        throw("Multiple maps not supported yet");
    this.maps.push(map);
}
/**
     *Get the map by id. For openlayers only 1 map....
     *@param mapId the mapId
     *@returns the Map with the id, or the only map.
     */
OpenLayersController.prototype.getMap = function (mapId){
    return this.maps[0];
}
/**
     *Remove the map from the
     */
OpenLayersController.prototype.removeMap = function (removeMap){
    removeMap.remove();
    this.maps=new Array();
}

OpenLayersController.prototype.createVectorLayer = function(id){
    return new OpenLayersVectorLayer(new OpenLayers.Layer.Vector(id, {
        isBaseLayer: false
    }),id);
}

/****************************************************************Event handling***********************************************************/

/**
 * Registers an event to a handler, on a object. Flamingo doesn't implement per component eventhandling,
 * so this controller stores the event in one big array (Object..).
 */
OpenLayersController.prototype.registerEvent = function (event,object,handler){
    var specificName = this.getSpecificEventName(event);
    object.register(specificName,handler);
}

/**
 * Register an event to the Controller.
 */
OpenLayersController.prototype.register = function (event,handler){
    var genericName= this.getGenericEventName(event);
    if (genericName== Event.ON_CHANGE_TOOL){
        this.getPanel().events.register(event,this.getPanel(),handler);
    }else{
        this.events[event] = handler;
    }
}

OpenLayersController.prototype.handleEvent = function(event){
    var handler = this.events[event];
    handler();
}

OpenLayersController.prototype.onIdentifyDataHandler = function(data){
    var obj = new Object();
    for( var i = 0 ; i < data.features.length ; i++){
        var featureType = data.features[i].gml.featureType;
        if(obj[featureType] == undefined){
            obj [featureType] = new Array();
        }
        obj [featureType].push( data.features[i].attributes);
    }
    //get The identifyTool that is active to call the onIdentifyData handler
    var getFeatureTools=this.getToolsByType(Tool.GET_FEATURE_INFO);
    for (var i=0; i < getFeatureTools.length; i++){
        if (getFeatureTools[i].isActive()){
            getFeatureTools[i].getFeatureInfoHandler("onIdentifyData",obj);
            return;
        }
    }
}
// onIdentify event handling
OpenLayersController.prototype.onIdentifyHandler = function(extent){
    //get The identifyTool that is active to call the onIdentify handler
    var getFeatureTools=this.getToolsByType(Tool.GET_FEATURE_INFO);
    for (var i=0; i < getFeatureTools.length; i++){
        if (getFeatureTools[i].isActive()){
            getFeatureTools[i].beforeGetFeatureInfoHandler("onIdentify",extent);
            return;
        }
    }
}

$j(document).ready(function() {
    if( webMapController instanceof OpenLayersController){
        var specificName = webMapController.getSpecificEventName(Event.ON_CONFIG_COMPLETE);
        webMapController.handleEvent(specificName);
    }
});

/**
 *The openlayers map object wrapper
 */
function OpenLayersMap(olMapObject){
    if (!(olMapObject instanceof OpenLayers.Map)){
        throw("The given map is not of the type 'OpenLayers.Map'");
    }
    this.markerLayer=null;
    this.defaultIcon=null;
    this.markers=new Object();
    this.getFeatureInfoControl = null;
    Map.call(this,olMapObject);
}
//set inheritens
OpenLayersMap.prototype = new Map();
OpenLayersMap.prototype.constructor=OpenLayersMap;

/**
     *See @link Map.getId
     */
OpenLayersMap.prototype.getId = function(){
    //multiple maps not supported yet
    return "";
}

/**
 *See @link Map.getAllWMSLayers
 */
OpenLayersMap.prototype.getAllWMSLayers = function(){
    var lagen = new Array();
    for(var i = 0 ; i < this.layers.length;i++){
        if(this.layers[i] instanceof OpenLayersWMSLayer){
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
}
/**
 *See @link Map.getAllVectorLayers
 */
OpenLayersMap.prototype.getAllVectorLayers = function(){
    var lagen = new Array();
    for(var i = 0 ; i < this.layers.length;i++){
        if(this.layers[i] instanceof OpenLayersVectorLayer){
            lagen.push(this.layers[i]);
        }
    }
    return lagen;
}


/**
     *See @link Map.remove
     */
OpenLayersMap.prototype.remove = function(){
    this.getFrameworkMap().destroy();
}

/**
     *Add a layer. Also see @link Map.addLayer
     **/
OpenLayersMap.prototype.addLayer = function(layer){
    if (!(layer instanceof OpenLayersLayer)){
        throw("The given layer is not of the type 'OpenLayersLayer'. But: "+layer);
    }
    this.layers.push(layer);
    if (layer instanceof OpenLayersWMSLayer && layer.getGetFeatureInfoControl()!=null){
        var info=layer.getGetFeatureInfoControl();
        this.getFrameworkMap().addControl(info);
        info.events.register("getfeatureinfo",webMapController, webMapController.onIdentifyDataHandler);
        info.events.register("beforegetfeatureinfo",webMapController, webMapController.onIdentifyHandler);
        //this.getGetFeatureInfoControl().addControl(info);
        //check if a getFeature tool is active.
        var getFeatureTools=webMapController.getToolsByType(Tool.GET_FEATURE_INFO);
        for (var i=0; i < getFeatureTools.length; i++){
            if (getFeatureTools[i].isActive()){
                info.activate();
            }
        }        
    }      
    this.getFrameworkMap().addLayer(layer.getFrameworkLayer());
}
/**
     *remove the specific layer. See @link Map.removeLayer
     **/
OpenLayersMap.prototype.removeLayer=function(layer){
    if (!(layer instanceof OpenLayersLayer))
        throw("OpenLayersMap.removeLayer(): Given layer not of type OpenLayersLayer");
    //call super function
    Map.prototype.removeLayer.call(this,layer);
    //this.getFrameworkMap().remove(layer.getFrameworkLayer());
    if (layer instanceof OpenLayersWMSLayer && layer.getGetFeatureInfoControl()!=null){
        layer.getGetFeatureInfoControl().destroy();
    }
    layer.getFrameworkLayer().destroy(false);
}
/**
     *see @link Map.setLayerIndex
     */
OpenLayersMap.prototype.setLayerIndex = function (layer, newIndex){
    if (!(layer instanceof OpenLayersLayer)){
        throw("OpenLayersMap.setLayerIndex(): Given layer not of type OpenLayersLayer.");
    }
    this.getFrameworkMap().setLayerIndex(layer.getFrameworkLayer(),newIndex);
    return Map.prototype.setLayerIndex(layer,newIndex);
}

/**
 *Sets the getfeatureinfo control of this map
 */
OpenLayersMap.prototype.setGetFeatureInfoControl = function (control){
    if( control.type != Tool.GET_FEATURE_INFO){
        throw ("Type of given control not of type GET_FEATURE_INFO, but: " + control.type);
    }
    this.getFeatureInfoControl = control;
}

/**
     *Move the viewport to the maxExtent. See @link Map.zoomToMaxExtent
     **/
OpenLayersMap.prototype.zoomToMaxExtent = function (){
    this.getFrameworkMap().zoomToExtent(this.getFrameworkMap().getMaxExtent());
}
/**
     *See @link Map.zoomToExtent
     **/
OpenLayersMap.prototype.zoomToExtent = function(extent){
    var bounds=Utils.createBounds(extent)
    this.getFrameworkMap().zoomToExtent(bounds);
}
/**
     * See @link Map.setMaxExtent
     */
OpenLayersMap.prototype.setMaxExtent=function(extent){
    this.getFrameworkMap().setOptions({
        maxExtent: Utils.createBounds(extent)
    });
}
/**
     *See @link Map.getMaxExtent     
     */
OpenLayersMap.prototype.getMaxExtent=function(){
    return Utils.createExtent(this.getFrameworkMap().getMaxExtent());
}
/**
     *See @link Map.getExtent
     */
OpenLayersMap.prototype.getExtent=function(){
    return Utils.createExtent(this.getFrameworkMap().getExtent);
}
/*TODO:
    OpenLayersMap.prototype.doIdentify = function(x,y){}
    OpenLayersMap.prototype.update = function(){}    
    OpenLayersMap.prototype.removeMarker = function(markerName){}
     */
/**
     *see @link Map.setMarker
     *TODO: marker icon path...
     */
OpenLayersMap.prototype.setMarker = function(markerName,x,y,type){
    if (this.markerLayer==null){
        this.markerLayer = new OpenLayers.Layer.Markers("Markers");
        this.frameworkMap.addLayer(this.markerLayer);
        var size = new OpenLayers.Size(17,17);
        var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
        this.defaultIcon= new OpenLayers.Icon('scripts/openlayers/img/marker.png',size,offset);
    }
    /*According the 'type' load a icon: no types yet only default*/
    var icon= this.defaultIcon.clone();
    this.markers[markerName]= new OpenLayers.Marker(new OpenLayers.LonLat(x,y),icon);
    this.markerLayer.addMarker(this.markers[markerName]);
}
/**
     *see @link Map.removeMarker
     */
OpenLayersMap.prototype.removeMarker = function(markerName){
    if (this.markers[markerName] && this.markerLayer!=null){
        this.markerLayer.removeMarker(this.markers[markerName]);
    }
}

OpenLayersMap.prototype.register = function (event,handler){
    var specificName = webMapController.getSpecificEventName(event);
    if(this.getFrameworkMap().eventListeners == null){
        this.getFrameworkMap().eventListeners = new Object();
    }
    this.getFrameworkMap().eventListeners [specificName]= handler;
}

function OpenLayersLayer(olLayerObject,id){
    if (!olLayerObject instanceof OpenLayers.Layer){
        throw("The given layer object is not of type 'OpenLayers.Layer'. But: "+olLayerObject);
    }
    Layer.call(this,olLayerObject,id);
}
OpenLayersLayer.prototype = new Layer();
OpenLayersLayer.prototype.constructor = OpenLayersLayer;

/**
     *see @link Layer.getOption
     */
OpenLayersLayer.prototype.getOption = function(optionKey){
    var lowerOptionKey=optionKey.toLowerCase();
    for (var key in this.getFrameworkLayer().options){
        if (key.toLowerCase()==lowerOptionKey){
            return this.getFrameworkLayer().options[key];
        }
    }
    for (var key in this.getFrameworkLayer().params){
        if (key.toLowerCase()==lowerOptionKey){
            return this.getFrameworkLayer().params[key];
        }
    }
    return null;
}
/**
     *see @link Layer.setOption
     */
OpenLayersLayer.prototype.setOption = function(optionKey,optionValue){
    var object=new Object();
    object[optionKey]= optionValue;
    this.getFrameworkLayer().setOptions(object);
}

/* Eventhandling for layers */
OpenLayersLayer.prototype.register = function (event,handler){
    var genericName = webMapController.getGenericEventName(event);
    if(event == webMapController.eventList[Event.ON_FEATURE_ADDED]){
        if( webMapController.events[genericName] == undefined){
            webMapController.events[genericName] = new Object();
        }
        webMapController.events[genericName][this.getFrameworkLayer().id] = handler;
        this.getFrameworkLayer().events.register(event, this.getFrameworkLayer(), layerFeatureHandler);
    }else{
        this.getFrameworkLayer().events.register(event, this.getFrameworkLayer(), handler);
    }
}

function layerFeatureHandler(obj){
    var id = obj.object.id;
    var eventName = webMapController.getGenericEventName(obj.type);
    var wkt = obj.feature.geometry.toString();
    var feature = new Feature(id,wkt);
    webMapController.events[eventName][id](id,feature);
}
function OpenLayersWMSLayer(olLayerObject,id){
    if (!olLayerObject instanceof OpenLayers.Layer.WMS){
        throw("The given layer object is not of type 'OpenLayers.Layer.WMS'. But: "+olLayerObject);
    }
    OpenLayersLayer.call(this,olLayerObject,id);
    this.getFeatureInfoControl=null;
}
OpenLayersWMSLayer.prototype = new OpenLayersLayer();
OpenLayersWMSLayer.prototype.constructor= OpenLayersWMSLayer;

/**
 *Gets the last wms request-url of this layer
 *@returns the WMS getMap Reqeust.
 */
OpenLayersWMSLayer.prototype.getURL = function(){
    return this.getFrameworkLayer().getURL(this.getFrameworkLayer().map.getExtent());
}

OpenLayersWMSLayer.prototype.setGetFeatureInfoControl = function(controller){
    this.getFeatureInfoControl=controller;
}
OpenLayersWMSLayer.prototype.getGetFeatureInfoControl = function(){
    return this.getFeatureInfoControl;
}

function OpenLayersVectorLayer(olLayerObject,id){
    if (!olLayerObject instanceof OpenLayers.Layer.Vector){
        throw("The given layer object is not of type 'OpenLayers.Layer.Vector'. But: "+olLayerObject);
    }
    OpenLayersLayer.call(this,olLayerObject,id);
}

OpenLayersVectorLayer.prototype = new OpenLayersLayer();
OpenLayersVectorLayer.prototype.constructor= OpenLayersVectorLayer;

OpenLayersVectorLayer.prototype.removeAllFeatures = function(){
    this.getFrameworkLayer().removeAllFeatures();
}

OpenLayersVectorLayer.prototype.getActiveFeature = function(){
    var index = this.getFrameworkLayer().features.length - 1;
    var olFeature = this.getFrameworkLayer().features[index];
    var feature = Feature.fromOpenLayersFeature(olFeature);

    return feature;
}

OpenLayersVectorLayer.prototype.getFeature = function(id){
    return this.getFrameworkLayer().features[id];
}

OpenLayersVectorLayer.prototype.getAllFeatures = function(){
    var olFeatures = this.getFrameworkLayer().features;
    var features = new Array();
    for(var i = 0 ; i < olFeatures.length;i++){
        var olFeature = olFeatures[i];
        var feature = Feature.fromOpenLayersFeature(olFeature);
        features.push(feature);
    }
    return features;
}

OpenLayersVectorLayer.prototype.addFeature = function(feature){
    var features = new Array();
    features.push(feature);
    this.addFeatures(features);
}


OpenLayersVectorLayer.prototype.addFeatures = function(features){
    var olFeatures = new Array();
    for(var i = 0 ; i < features.length ; i++){
        var feature = features[i];
        var olFeature = feature.toOpenLayersFeature();
        olFeatures.push(olFeature);
    }
    return this.getFrameworkLayer().addFeatures(olFeatures);
}


function OpenLayersTool(id,olControlObject,type){    
    this.controls = new Array();
    Tool.call(this,id,olControlObject,type);
}
OpenLayersTool.prototype = new Tool();
OpenLayersTool.prototype.constructor= OpenLayersTool;

OpenLayersTool.prototype.register = function (event,handler){
    if(this.type == Tool.BUTTON){
        this.getFrameworkTool().trigger= handler;
    }else if (this.type== Tool.CLICK){
        this.getFrameworkTool().handler.callbacks[event]= function (evt){
            var lonlat= this.map.getLonLatFromViewPortPx(evt.xy);
            handler.call(this,new Extent(lonlat.lat,lonlat.lon,lonlat.lat,lonlat.lon))
        };
    }else{
        this.getFrameworkTool().events.register(event,this.getFrameworkTool(),handler);
    }
}

OpenLayersTool.prototype.addControl = function(control){
    if (!(this.type == Tool.GET_FEATURE_INFO)){
        throw("The given Control object is not of type get feature info. But: "+this.type);
    }
    this.controls.push(control);
}

OpenLayersTool.prototype.getId = function(){
    return this.id;
}

OpenLayersTool.prototype.setVisible = function(visibility){
    if (visibility){
        this.getFrameworkTool().panel_div.style.display="block";
    }else{
        this.getFrameworkTool().panel_div.style.display="none";
    }
}

OpenLayersTool.prototype.isActive = function (){
    return this.getFrameworkTool().active;
}
/**
 *A identify tool
 */
function OpenLayersIdentifyTool(id,olControlObject,type){
    if (type!=Tool.GET_FEATURE_INFO){
        throw("OpenLayersIdentifyTool.constructor(): A OpenLayersIdentifyTool needs to be of type: Tool.GET_FEATURE_INFO");
    }
    this.getFeatureInfoHandler = new Object();
    this.beforeGetFeatureInfoHandler = new Object();
    OpenLayersTool.call(this,id,olControlObject,type);
}
OpenLayersIdentifyTool.prototype = new OpenLayersTool();
OpenLayersIdentifyTool.prototype.constructor= OpenLayersIdentifyTool;
/**
 *Set the getFeatureInfo handler
 **/
OpenLayersIdentifyTool.prototype.setGetFeatureInfoHandler = function(handler){    
    this.getFeatureInfoHandler = handler;
}
/**
 *Set the setBeforeGetFeatureInfoHandler handler
 **/
OpenLayersIdentifyTool.prototype.setBeforeGetFeatureInfoHandler = function(handler){    
    this.beforeGetFeatureInfoHandler = handler;
}



function Utils(){
}
Utils.createBounds=function(extent){
    return new OpenLayers.Bounds(extent.minx,extent.miny,extent.maxx,extent.maxy);
}
Utils.createExtent=function(bounds){
    return new Extent(bounds.left,bounds.bottom,bounds.right,bounds.top);
}




OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {
    button: null,

    defaultHandlerOptions: {
        'single': true,
        'double': true,
        'pixelTolerance': 0,
        'stopSingle': false,
        'stopDouble': false
    },
    initialize: function(options) {
        this.handlerOptions = OpenLayers.Util.extend(
        {}, this.defaultHandlerOptions
            );
        OpenLayers.Control.prototype.initialize.apply(
            this, arguments
            );
        this.handler = new OpenLayers.Handler.Click(
            this, {
                'click': this.onClick,
                'dblclick': this.onDblclick
            }, this.handlerOptions
            );
        var buttonOptions= {
            displayClass: this.displayClass + "Button",
            type: OpenLayers.Control.TYPE_TOOL
        };
        this.button= new OpenLayers.Control(buttonOptions);
        this.button.events.register("activate",this,this.activate);
        this.button.events.register("deactivate",this,this.deactivate);        
    },
    onClick: function(evt) {
    },

    onDblclick: function(evt) {
    }
});

/* Copyright (c) 2006-2008 MetaCarta, Inc., published under the Clear BSD
 * license.  See http://svn.openlayers.org/trunk/openlayers/license.txt for the
 * full text of the license. */

/**
 * @requires OpenLayers/Control.js
 *
 * Class: OpenLayers.Control.LoadingPanel
 * In some applications, it makes sense to alert the user that something is
 * happening while tiles are loading. This control displays a div across the
 * map when this is going on.
 * SRC: http://svn.openlayers.org/addins/loadingPanel/trunk/
 *
 * Inherits from:
 *  - <OpenLayers.Control>
 */
OpenLayers.Control.LoadingPanel = OpenLayers.Class(OpenLayers.Control, {

    /**
     * Property: counter
     * {Integer} A counter for the number of layers loading
     */
    counter: 0,

    /**
     * Property: maximized
     * {Boolean} A boolean indicating whether or not the control is maximized
    */
    maximized: false,

    /**
     * Property: visible
     * {Boolean} A boolean indicating whether or not the control is visible
    */
    visible: true,

    /**
     * Constructor: OpenLayers.Control.LoadingPanel
     * Display a panel across the map that says 'loading'.
     *
     * Parameters:
     * options - {Object} additional options.
     */
    initialize: function(options) {
        OpenLayers.Control.prototype.initialize.apply(this, [options]);
    },

    /**
     * Function: setVisible
     * Set the visibility of this control
     *
     * Parameters:
     * visible - {Boolean} should the control be visible or not?
    */
    setVisible: function(visible) {
        this.visible = visible;
        if (visible) {
            OpenLayers.Element.show(this.div);
        } else {
            OpenLayers.Element.hide(this.div);
        }
    },

    /**
     * Function: getVisible
     * Get the visibility of this control
     *
     * Returns:
     * {Boolean} the current visibility of this control
    */
    getVisible: function() {
        return this.visible;
    },

    /**
     * APIMethod: hide
     * Hide the loading panel control
    */
    hide: function() {
        this.setVisible(false);
    },

    /**
     * APIMethod: show
     * Show the loading panel control
    */
    show: function() {
        this.setVisible(true);
    },

    /**
     * APIMethod: toggle
     * Toggle the visibility of the loading panel control
    */
    toggle: function() {
        this.setVisible(!this.getVisible());
    },

    /**
     * Method: addLayer
     * Attach event handlers when new layer gets added to the map
     *
     * Parameters:
     * evt - {Event}
    */
    addLayer: function(evt) {
        if (evt.layer) {
            evt.layer.events.register('loadstart', this, this.increaseCounter);
            evt.layer.events.register('loadend', this, this.decreaseCounter);
        }
    },

    /**
     * Method: setMap
     * Set the map property for the control and all handlers.
     *
     * Parameters:
     * map - {<OpenLayers.Map>} The control's map.
     */
    setMap: function(map) {
        OpenLayers.Control.prototype.setMap.apply(this, arguments);
        this.map.events.register('preaddlayer', this, this.addLayer);
        for (var i = 0; i < this.map.layers.length; i++) {
            var layer = this.map.layers[i];
            layer.events.register('loadstart', this, this.increaseCounter);
            layer.events.register('loadend', this, this.decreaseCounter);
        }
    },

    /**
     * Method: increaseCounter
     * Increase the counter and show control
    */
    increaseCounter: function() {
        this.counter++;
        if (this.counter > 0) {
            if (!this.maximized && this.visible) {
                this.maximizeControl();
            }
        }
    },

    /**
     * Method: decreaseCounter
     * Decrease the counter and hide the control if finished
    */
    decreaseCounter: function() {
        if (this.counter > 0) {
            this.counter--;
        }
        if (this.counter == 0) {
            if (this.maximized && this.visible) {
                this.minimizeControl();
            }
        }
    },

    /**
     * Method: draw
     * Create and return the element to be splashed over the map.
     */
    draw: function () {
        OpenLayers.Control.prototype.draw.apply(this, arguments);
        return this.div;
    },

    /**
     * Method: minimizeControl
     * Set the display properties of the control to make it disappear.
     *
     * Parameters:
     * evt - {Event}
     */
    minimizeControl: function(evt) {
        this.div.style.display = "none";
        this.maximized = false;

        if (evt != null) {
            OpenLayers.Event.stop(evt);
        }
    },

    /**
     * Method: maximizeControl
     * Make the control visible.
     *
     * Parameters:
     * evt - {Event}
     */
    maximizeControl: function(evt) {
        this.div.style.display = "block";
        this.maximized = true;

        if (evt != null) {
            OpenLayers.Event.stop(evt);
        }
    },

    /**
     * Method: destroy
     * Destroy control.
     */
    destroy: function() {
        if (this.map) {
            this.map.events.unregister('preaddlayer', this, this.addLayer);
            if (this.map.layers) {
                for (var i = 0; i < this.map.layers.length; i++) {
                    var layer = this.map.layers[i];
                    layer.events.unregister('loadstart', this,
                        this.increaseCounter);
                    layer.events.unregister('loadend', this,
                        this.decreaseCounter);
                }
            }
        }
        OpenLayers.Control.prototype.destroy.apply(this, arguments);
    },

    CLASS_NAME: "OpenLayers.Control.LoadingPanel"

});

/**
 * The request function for WMSGetFeatureInfo redone, so that querylayers are properly set
 */
function doGetFeatureRequest(clickPosition, options) {
    var layers = this.findLayers();
    if(layers.length == 0) {
        this.events.triggerEvent("nogetfeatureinfo");
        // Reset the cursor.
        OpenLayers.Element.removeClass(this.map.viewPortDiv, "olCursorWait");
        return;
    }

    options = options || {};
    if(this.drillDown === false) {
        var wmsOptions = this.buildWMSOptions(this.url, layers, clickPosition, layers[0].params.FORMAT);
        (wmsOptions["params"])["STYLES"] = "";
        (wmsOptions["params"])["QUERY_LAYERS"] = this.queryLayers.split(",");
        var request = OpenLayers.Request.GET(wmsOptions);

        if (options.hover === true) {
            this.hoverRequest = request;
        }
    } else {
        this._requestCount = 0;
        this._numRequests = 0;
        this.features = [];
        // group according to service url to combine requests
        var services = {}, url;
        for(var i=0, len=layers.length; i<len; i++) {
            var layer = layers[i];
            var service, found = false;
            url = layer.url instanceof Array ? layer.url[0] : layer.url;
            if(url in services) {
                services[url].push(layer);
            } else {
                this._numRequests++;
                services[url] = [layer];
            }
        }
        var layers;
        for (var url in services) {
            layers = services[url];
            var wmsOptions = this.buildWMSOptions(url, layers,
                clickPosition, layers[0].params.FORMAT);
            OpenLayers.Request.GET(wmsOptions);
        }
    }
}