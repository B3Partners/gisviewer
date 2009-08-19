/*A flamingoController. It only controlles the layers that are added with this script.
 *flamingoElement: (Mandatory) The html embeded flash object referencing to flamingo
 *thisVarName: (Mandatory) the var name of the reference where this object is stored.
 *
 *Example: var fc=FlamingoController(flamingo,'fc');
 **/
function FlamingoController(flamingoElement, thisVarName){
    if (flamingoElement==undefined || thisVarName==undefined){
        alert ("Error: FlamingoController is not created because both constructor param's need to be submitted.");
        return null;
    }
    this.flamingo=flamingoElement;
    this.thisName=thisVarName;
    this.map=null;
    this.editMap=null;
    this.namespacePrefix="fmc";
    this.methodController = new MethodController(this.flamingo,this.thisName);
       
    
    /*Help functions*/    

    this.createMap = function (mapid){
        this.map = new Map(mapid, this);
    }
    this.createEditMap = function (editMapId){
        this.editMap = new EditMap(editMapId, this);
    }
    /*Set a object visibility
     * id: the id of the object
     * visible: visibility of a object
     **/
    this.setVisible= function(id,visible){
        this.getFlamingo().callMethod(id,'setVisible',visible);
    }
    //setters and getters
    this.setFlamingo = function(flamingoElement){
        this.flamingo=flamingoElement;
    }
    this.getFlamingo = function(){
        return this.flamingo;
    }
    this.setMap=function(map){
        this.map=map;
    }
    this.getMap=function (){
        return this.map;
    }
    this.setEditMap=function(editMap){
        this.editMap=editMap;
    }
    this.getEditMap=function (){
        return this.editMap;
    }
    this.setNamespacePrefix= function(namespacePrefix){
        this.namespacePrefix=namespacePrefix;
    }
    this.getNamespacePrefix= function(){
        return this.namespacePrefix;
    }
    this.getThisName = function(){
        return this.thisName;
    }
    this.getMethodController= function(){
        return this.methodController;
    }
}
function Map(id,flamingoController){
    this.id=id;
    this.flamingoController=flamingoController;
    this.layers= new Array();
    this.requestListener=null;

    /**
     *Add a layer to flamingo
     *layer: a FlamingoWMSLayer object
     *refresh: if true the function will do a refresh after adding the layer
     *replaceifIdExists: Replaces the layer when it has a layer with the same id
     *      set true if you want to let the previous layer be visible until the new layer is loaded.
     */
    this.addLayer= function(layer,refresh,replaceIfIdExists){
        //this.removeLayer(layer);
        var flamingoLayers= this.getFlamingoController().getFlamingo().callMethod(this.getId(),'getLayers');
        if (layer.id.length==0){
            layer.id="layer";
        }
        if (!replaceIfIdExists){
            var newId=this.createUniqueLayerId(flamingoLayers,layer.id);
            if (newId==null){
                return;
            }
            layer.setId(newId);
        }else{
            for (var i=0; i < this.layers.length; i++){
                if (this.layers[i].getId()==layer.getId()){
                    this.layers.splice(i,1);
                }
            }
        }
        this.layers.push(layer);
        this.getFlamingoController().getFlamingo().callMethod(this.getId(),'addLayer',layer.toXml(this.getFlamingoController().getNamespacePrefix()));
        if (this.getRequestListener()!=null){
            this.createLayerListener(layer.getId(),'onRequest',this.getRequestListener());
        }
        if (refresh){
            this.update();
        }
    }
    /**
     *Get layer with flaming id
     **/
    this.getLayerWithFlamingoId=function (flamingoId){
        var lid=flamingoId.substring(this.getId().length+1);
        return this.getLayer(lid);
    }
    /**
    *Get layer by id.
    */
   this.getLayer= function(lid){
        for (var i=0; i < this.layers.length; i++){
            if (this.layers[i].getId()==lid){
                return this.layers[i];
            }
        }
        return null;
   }
    /**
     *Remove a specified layer
     **/
    this.removeLayer=function(layer,refresh){
        var layerId=layer.getId();
        this.removeLayerById(layerId,refresh);
    }
    /**
     *Remove a layer by id
     */
    this.removeLayerById=function(layerId,refresh){
        this.getFlamingoController().getFlamingo().call(this.getId(),'removeLayer',this.getId()+"_"+layerId);
        for (var i=0; i < this.layers.length; i++){
            if (this.layers[i].getId()==layerId){
                if (this.getRequestListener()!=null){
                    this.removeLayerListener(layerId,'onRequest');
                }
                this.layers.splice(i,1);
                if(refresh)
                    this.update();
                return;
            }
        }
    }
    /*Remove all layers
     **/
    this.removeAllLayers=function(){
        for (var i=0; i < this.layers.length; i++){
            this.removeLayer(this.layers[i]);
        }
        this.update();
    }
    /*Listener functions*/
    /**
     *Creates a listener for the layer.
     *layerId: The id of the layer
     *listenTo: the event that needs to be heard
     *TODO: Het stukje =function (.....) is listener specifiek.
     */
    this.createLayerListener=function(layerId,listento,method){
        var listener=""+this.getFlamingoController().getFlamingo().id+"_"+this.getId()+"_"+layerId+"_"+listento+"=function (layer,type,requestObject){"+method+"(layer,type,requestObject);};";
        eval(listener);
    }
    this.removeLayerListener=function(layerId,listento){
        eval(""+this.getFlamingoController().getFlamingo().id+this.getId()+layerId+"_"+listento+"=undefined;");
    }
    /*Listeners*/
    /**
     *Enables the request handler in this object. The default layerRequestHandler is used.
     */
    this.enableLayerRequestListener= function(){
        this.setRequestListener(this.getFlamingoController().getThisName()+".getMap().layerRequestHandler");
    }
    /**
     *Default layer request listener.
     */
    this.layerRequestHandler = function (layerId,type,requestObject){
        //type can be: init, update
        var layer=this.getLayerWithFlamingoId(layerId);
        if (layer==null){
            return;
        }
        if (type=='update'){
            layer.setLastGetMapRequest(requestObject.url);
        }
    }
    /*Helper functions*/
    /**
     *Check if the id is unique, not: Create a new layer id that is unique.
     *With a max of 1000 tries.
     *flamingoLayerlist the list with flamingoLayer ids
     *id: The id to check.
     **/
    this.createUniqueLayerId = function(flamingoLayerlist,lid){
        var newId=lid;
        for (var i=0; i < 1000; i++){
            if (!this.contains(flamingoLayerlist,this.id+"_"+newId)){
                return newId;
            }else{
                newId=""+lid+i;
            }
        }
        return null;
    }
    /**
     *check if the array contains the id.
     **/
    this.contains = function(list,id){
        for (var i=0; i < list.length; i++){
            if (list[i]==id){
                return true;
            }
        }
        return false;
    }
    //flamingo call methods:
    //move to a extent
    this.moveToExtent = function(ext,delay){
        if(delay==undefined){
            delay=0;
        }
        this.getFlamingoController().getFlamingo().callMethod(this.getId(), "moveToExtent", ext, delay);
    }
    this.moveToFullExtent = function(){
        this.moveToExtent(this.getFlamingoController().getFlamingo().callMethod(this.getId(), "getFullExtent"));
    }
    //set and get the maximum extent of this map
    this.setFullExtent=function(ext){
        this.getFlamingoController().getFlamingo().callMethod(this.getId(), "setFullExtent", ext);
    }
    this.getFullExtent=function(){
        return this.getFlamingoController().getFlamingo().callMethod(this.getId(), "getFullExtent");
    }
    this.doIdentify=function(ext){
        this.getFlamingoController().getFlamingo().callMethod(this.getId(), "identify", ext);        
    }
    //Get the current extent
    this.getExtent= function(){
        return this.getFlamingoController().getFlamingo().callMethod(this.getId(),'getExtent');
    }
    /**
     *Update the flamingo map
     */
    this.update=function(){
        this.getFlamingoController().getFlamingo().callMethod(this.getId(),'update', 100, true);
    }
    /*Setters en getters*/
    this.getId= function(){
        return id;
    }
    this.setId=function (id){
        this.id=id;
    }
    this.getFlamingoController = function(){
        return flamingoController;
    }
    this.setFlamingoController = function (flamingoController){
        this.flamingoController=flamingoController;
    }
    this.getLayers = function(){
        return this.layers;
    }
    this.setLayers = function(layers){
        this.layers=layers;
    }
    /*Sets the request listener. The given function name is called when a
     *layer does a request and the server responsed
     *requestListener: the function name dat is called
     **/
    this.setRequestListener= function(requestListener){
        this.requestListener=requestListener;
    }
    this.getRequestListener= function(){
        return this.requestListener;
    }
}
function FlamingoWMSLayer(id){
    if (id==undefined){
        alert("Error: Id must be defined");
        return;
    }
    this.id=null;
    this.url=null;
    this.layers=null;
    this.querylayers=null;
    this.srs=null;
    this.showerrors=null;
    this.nocache=false;
    this.transparent=true;
    this.lastGetMapRequest=null;
    this.version=null;
    this.timeOut=null;
    this.retryOnError=null;
    this.format=null;
    this.exceptions=null;
    this.getCapabilitiesUrl=null;
    this.layerProperties= new Array();

    //methods
    this.toXml = function(namespaceprefix){
        var xml="<";
        if (namespaceprefix!=null)
            xml+=namespaceprefix+":";
        xml+="LayerOGWMS";
        if (namespaceprefix!=null)
            xml+=" xmlns:fmc=\"fmc\"";
        xml+=" id=\""+this.getId()+"\"";
        xml+=" url=\""+this.getUrl()+"\"";
        if (this.getLayers()!=null)
            xml+=" layers=\""+this.getLayers()+"\"";
        if (this.getQuerylayers()!=null)
            xml+=" query_layers=\""+this.getQuerylayers()+"\"";
        if (this.getSrs()!=null)
            xml+=" srs=\""+this.getSrs()+"\"";
        if (this.getShowerrors()!=null)
            xml+=" showerrors=\""+this.getShowerrors()+"\"";
        if (this.getNocache())
            xml+=" nocache=\"true\"";
        if(!this.getTransparent())
            xml+=" transparent=\"false\"";
        if(this.getVersion()!=null)
            xml+=" version=\""+this.getVersion()+"\"";
        if(this.getTimeOut()!=null)
            xml+=" timeout=\""+this.getTimeOut()+"\"";
        if(this.getRetryOnError()!=null)
            xml+=" retryonerror=\""+this.getRetryOnError()+"\"";
        if (this.getFormat()!=null)
            xml+=" format=\""+this.getFormat()+"\"";
        if (this.getExceptions()!=null)
            xml+=" exceptions=\""+this.getExceptions()+"\"";
        if (this.getGetCapabilitiesUrl()!=null)
            xml+=" getcapabilitiesurl=\""+this.getGetCapabilitiesUrl()+"\"";
        xml+=">";
        for (var layerProperty in this.getLayerProperties()){
            xml+=layerProperty.toXml();
        }
        xml+="</";
        if (namespaceprefix!=null)
            xml+=namespaceprefix+":";
        xml+="LayerOGWMS>";
        return xml;
    }
    //getters and setters
    this.setId = function(id){
        this.id=id.split(' ').join('');
    }
    this.getId = function(){
        return this.id;
    }
    this.setUrl = function(url){
        this.url=url;
    }
    this.getUrl = function(){
        return this.url;
    }
    this.getSrs = function(){
        return this.srs;
    }
    this.setSrs = function(srs){
        this.srs=srs;
    }
    this.getLayers = function(){
        return this.layers;
    }
    this.setLayers = function(layers){
        this.layers=layers;
    }
    this.getQuerylayers = function(){
        return this.querylayers;
    }
    this.setQuerylayers = function(querylayers){
        this.querylayers=querylayers;
    }
    this.getShowerrors = function(){
        return this.showerrors;
    }
    this.setShowerros = function(showerrors){
        this.showerrors=showerrors;
    }
    this.getNocache = function (){
        return this.nocache;
    }
    this.setNocache = function (nocache){
        this.nocache=nocache;
    }
    this.setTransparent= function(transparent){
        this.transparent=transparent;
    }
    this.getTransparent= function(){
        return this.transparent;
    }
    this.setLastGetMapRequest = function(lastGetMapRequest){
        this.lastGetMapRequest=lastGetMapRequest;
    }
    this.getLastGetMapRequest= function (){
        return this.lastGetMapRequest;
    }
    this.setVersion = function(version){
        this.version=version;
    }
    this.getVersion= function(){
        return this.version;
    }
    this.getTimeOut= function(){
        return this.timeOut;
    }
    this.setTimeOut= function(timeOut){
        this.timeOut=timeOut;
    }
    this.setRetryOnError = function(retryOnError){
        this.retryOnError=retryOnError;
    }
    this.getRetryOnError= function(){
        return this.retryOnError;
    }
    this.setFormat= function (format){
        this.format=format;
    }
    this.getFormat= function(){
        return this.format;
    }
    this.setExceptions= function(exceptions){
        this.exceptions=exceptions;
    }
    this.getExceptions= function(){
        return this.exceptions;
    }
    this.setGetCapabilitiesUrl= function(getCapabilitiesUrl){
        this.getCapabilitiesUrl=getCapabilitiesUrl;
    }
    this.getGetCapabilitiesUrl= function(){
        return this.getCapabilitiesUrl;
    }
    this.setLayerProperties= function (layerProperties){
        this.layerProperties=layerProperties;
    }
    this.getLayerProperties= function(){
        return this.layerProperties;
    }
    this.addLayerProperty= function (layerPropertie){
        this.layerProperties.push(layerPropertie);
    }
    this.toString= function(){
        var s="";
        s+=this.getId()+": ";
        s+=this.getUrl()+" (";
        s+=this.getLayers()+")";
        return s;
    }

    /*Init*/

    this.setId(id);
}
function LayerProperty(id,maptipField){
    this.id=null;
    this.maptipField=null;
    if (id==undefined){
        alert("Error: Id must be defined");
        return;
    }
    this.setId= function(id){
        this.id=id;
    }
    this.getId= function(){
        return this.id;
    }
    this.setMaptipField= function(maptipField){
        this.maptipField=maptipField;
    }
    this.getMaptipField= function(){
        return this.maptipField;
    }
    this.toXml=function(){
        var xml="<layer";
        xml+=" id=\""+this.getId+"\"";
        if (this.getMaptipField!=null)
            xml+=" maptip=\""+this.getMaptipField+"\"";
        xml+="/>"
    }
    //init
    this.setId(id);
    this.setMaptipField(maptipField);
}
function EditMap(id,flamingoController){
    this.id=id;
    this.flamingoController=flamingoController;

    this.removeAllFeatures=function (){
        flamingoController.getFlamingo().callMethod(this.id,'removeAllFeatures');
    }

    this.removeActiveFeature=function(){
        flamingoController.getFlamingo().callMethod(this.id,'removeActiveFeature');
    }

    this.getActiveFeature = function(){
        return flamingoController.getFlamingo().callMethod(this.id,'getActiveFeature');
    }
}

/*Old javascript code that checks if a component is loaded and after that starts the method
 *that is called. Perhaps it can be removed.
 **/
function MethodController(fmcObject,name){
  this.queues = new Array();
  this.fmc=fmcObject;
  this.name=name;
  this.busy=false;

    /*Use this function to call a flamingo function with javascript.
     **/
    this.callCommand =function (fmcCall){
        if (typeof this.fmc.callMethod == 'function' && this.fmc.callMethod(this.fmc.id,'exists',fmcCall.id)==true){
            if (fmcCall.params.length==0){
                eval("setTimeout(\"flamingo.callMethod('"+fmcCall.id+"','"+fmcCall.method+"')\",10);");
            }else{
              var value=""
              for (var i=0; i < fmcCall.params.length; i++){
                  value+=",";
                  var valueType=typeof(fmcCall.params[i]);
                  if (valueType == 'boolean' || valueType == 'number' || valueType == 'array'){
                      value+=fmcCall.params[i];
                  }else{
                    value+="'"+fmcCall.params[i]+"'";
                  }
              }
              eval("setTimeout(\"flamingo.callMethod('"+fmcCall.id+"','"+fmcCall.method+"'"+value+")\",10);");
            }
        }else{
            this.addToQueue(fmcCall);
        }
    }
    /*This function adds a call to the queue. It is used when a component not (yet) is loaded
     **/
    this.addToQueue = function(fmcCall){
        if (this.queues[fmcCall.id]==undefined || this.queues[fmcCall.id]==null){
            this.queues[fmcCall.id]= new Array();
            eval(""+this.fmc.id+"_"+fmcCall.id+"_onInit = function(){"+this.name+".getMethodController.executeQueue('"+fmcCall.id+"');};");
        }
        this.queues[fmcCall.id].push(fmcCall);
    }
    /*Executes the queue of a given component id.
     **/
    this.executeQueue = function(id){
        if (this.queues[id]==undefined || this.queues[id]==null || this.queues[id].length==0){
            return;
        }
        while (this.queues[id].length!=0){
            var flamingoCall=this.queues[id].shift();
            this.callCommand(flamingoCall);
        }
    }
}
/*Class FlamingoCall
 *Used to store the method call
 **/
function FlamingoCall(id,method,params){
    this.id = id;
    this.method = method;
    if (params==undefined || params==null){
        this.params=new Array();
    }else if (typeOf(params) == 'array'){
        this.params=params;
    }else {
        this.params=new Array();
        this.params.push(params);
    }
}
/*Returns the type of a object.
 **/
function typeOf(value) {
    var s = typeof value;
    if (s === 'object') {
        if (value) {
            if (value instanceof Array) {
                s = 'array';
            }
        } else {
            s = 'null';
        }
    }
    return s;
}