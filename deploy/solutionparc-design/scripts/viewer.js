dwr.engine.setErrorHandler(handler);

/**
 * Array with the current visible layers in correct order.
 * The last is rendered on top.
*/ 
var enabledLayerItems = new Array();

/**
 * String that forms the request to the service. It contains the normal wms request
 * parameters appened with the kaartenbalie url and if available also PROJECT
 * or organization code parameters.
*/

var layerUrl = "" + kburl;

var cookieArray = readCookie('checkedLayers');
var cookieClusterArray = readCookie('checkedClusters');

var activeAnalyseThemaId = '';
var activeClusterId = '';

/**
 * Temporary list for init.
*/
var layersAan= new Array();
var clustersAan = new Array();

var featureInfoTimeOut = 30;
var webMapController;

/**
 * Index used when adding layers. So its possible to leave indexes not used.
*/
var startLayerIndex = 0;

/**
 * Ballon reference.
*/
var balloon;

var zoomBox;
var pan;
var prevExtent;
var identify;

var mapInitialized = false;
var searchExtent;
var sldSearchServlet;

var highlightThemaId;
var multiPolygonBufferWkt;
var alleLayers = new Array();

var gpsComponent = null;
var editComponent = null;

/* TODO: OL height work-around for first time getMaxBounds */
var firstTimeOLHeightAdjusted = false;
var wierdOLDiffHeight = 224;

var uploadCsvLayerOn = false;

/**
 * Start off with initMapComponent()
*/
initMapComponent();

/**
 * Shows a message in a popup window.
 * @param msg The message to display.
*/
function handler(msg) {
    var message = msg;
    
    if (message != '')
    {
        messagePopup("", message, "information");
    }
}

/**
 * Initialize the viewer. This sets the web map controller to either
 * Flamingo or OpenLayers. It also registers the events that can be fired.
*/
function initMapComponent(){
    mapviewer = viewerType;

    if (window.location.href.indexOf("flamingo")>0)
        mapviewer = "flamingo";
    if (mapviewer == "flamingo"){
        webMapController = new FlamingoController('mapcontent');
        
        var map = webMapController.createMap("map1");        
        webMapController.addMap(map);
        
    } else if (mapviewer == "openlayers") {
        webMapController = new OpenLayersController();
        
        var maxBounds = getMaxBounds();
        var olRes = getTilingResolutions(maxBounds, true);       
        
        Proj4js.defs["EPSG:28992"] = "+title=Amersfoort / RD New +proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"; 
        var opt = {
            projection: new OpenLayers.Projection("EPSG:28992"),
            maxExtent: maxBounds,
            resolutions: olRes,
            //numZoomLevels: olRes.length-1,
            allOverlays: true,
            units : 'meters',            
            controls : [
            new OpenLayers.Control.Navigation({
                zoomBoxEnabled: false
            }),
            new OpenLayers.Control.ArgParser()                
            ]
        };
        
        $j("#mapcontent").html(" ");
        var olmap = webMapController.createMap('mapcontent',opt);
        $j("#mapcontent").css("border","1px solid black");
        
        webMapController.addMap(olmap);
    }
    
    webMapController.initEvents();
    webMapController.registerEvent(Event.ON_GET_CAPABILITIES,webMapController.getMap(),onGetCapabilities);
    webMapController.registerEvent(Event.ON_CONFIG_COMPLETE,webMapController,onConfigComplete);
}

function getNLExtent() {
    return "12000,304000,280000,620000";
}

function getNLMaxBounds() {
    return Utils.createBounds(new Extent(getNLExtent()));
}

function getMaxBounds() {
    var maxBounds;        
    if (!bbox && fullbbox){
        maxBounds = Utils.createBounds(new Extent(fullbbox));
    } else if (bbox && appExtent) {
        maxBounds = Utils.createBounds(new Extent(appExtent));
    } else if (bbox && fullbbox) {
        maxBounds = Utils.createBounds(new Extent(fullbbox));
    } else if (bbox && !fullbbox) {
        maxBounds = Utils.createBounds(new Extent(bbox));    
    } else {
        var bounds = getNLMaxBounds();        
        maxBounds = new OpenLayers.Bounds(bounds.left, bounds.bottom, bounds.right, bounds.top);
    }

    /* Aanpassen maxBounds aan huidige beeldscherm verhoudingen */
    var oldMapWidth = maxBounds.right - maxBounds.left;
    var oldMapHeight = maxBounds.top - maxBounds.bottom;

    var screenWidth = $j("#mapcontent").width();
    var heightMapContent = $j("#mapcontent").height();
    
    var screenHeight = heightMapContent + defaultdataframehoogte + 75;

    var ratio = screenWidth / screenHeight;
    var mapRatio = oldMapWidth / oldMapHeight;

    // calc new map height
    if (ratio < mapRatio) { 
        var newHeight = oldMapWidth / ratio;
        maxBounds.bottom = maxBounds.bottom - ((newHeight-oldMapHeight) / 2);
        maxBounds.top = maxBounds.bottom + newHeight;
    // calc new map width
    } else { 
        var newWidth = oldMapHeight * ratio;
        maxBounds.left = maxBounds.left - ((newWidth - oldMapWidth) / 2);
        maxBounds.right = maxBounds.left + newWidth;
    }
    
    return maxBounds;
}

/* Methode herberekend ingevulde tiling resoluties o.b.v. max eetent. 
 * Geeft een array of string terug. */
function getTilingResolutions(maxBounds, returnArray) {    
    var newMapWidth = maxBounds.right - maxBounds.left;

    /* Alle tiling resoluties in een lijst zetten */
    var olRes;
    if (tilingResolutions) {
        var res = tilingResolutions; //.trim();

        var list;            
        if (res.indexOf(",") != -1) {
            list = res.split(",");
        } else {
            list = res.split(" ");
        }

        if (list && list.length > 0) {                
            olRes = new Array();
            for (var i in list) {
                list[i] = parseFloat(list[i]);        
                olRes[i] = list[i];
            }
        }
    } else {
        tilingResolutions = "680,512,256,128,64,32,16,8,4,2,1,0.5,0.25,0.125";
        olRes = [680,512,256,128,64,32,16,8,4,2,1,0.5,0.25,0.125];
    }

    /* Tiling resoluties die buiten aangepaste extent vallen weglaten */
    if (tilingResolutions) {            
        /* TODO: Kijken of deze berekeningen niet later kunnen. Bijvoorbeeld
         * na het maken van de map en het opbouwen van de layout. Ivm het ophalen
         * van de hoogte of als de gebruiker het scherm groter of kleiner maakt
        */       
        var screenWidth = $j("#mapcontent").width();
        //var screenHeight = $j("#mapcontent").height() + defaultdataframehoogte + 75;
    
        var resolution = newMapWidth / screenWidth;

        var dpm = 72 / 0.0254;
        var scale = (resolution * dpm) / 1000;

        var newList = new Array();
        var counter = 0;            
        for (var idx in olRes) {
            if (olRes[idx] <= scale) {
                newList[counter] = olRes[idx];
                counter++;
            }
        }

        olRes = newList;
    }
    
    if (returnArray) { // openlayers gebruikt een array
        return olRes;
    } else { // flamingo een string
        
        var str = "";
        for (var k in olRes) {
            str += parseFloat(olRes[k]) + " ";
        }
        
        return str.trim();
    }

    return olRes;
}

/* trim for IE8 */
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, '');
    }
}

/**
 * Hides the I-tool icon. (Flamingo only)
*/
function hideIdentifyIcon(){
    if(webMapController instanceof FlamingoController) {
        webMapController.getMap().getFrameworkMap().callMethod('map1_identifyicon','hide');
    }
}

/**
 * Shows the I-tool icon. (Flamingo only)
*/
function showIdentifyIcon(){
    if(webMapController instanceof FlamingoController) {
        webMapController.getMap().getFrameworkMap().callMethod('map1_identifyicon','show');
    }
}

/**
 * Initialize the tools used in the viewer. It registers the event and handler
 * for the tool.
*/
function initializeButtons() {
    /*ie bug fix*/
    if (ieVersion!=undefined && ieVersion <= 7){
        var mapId = webMapController.getMap().getFrameworkMap().id;
        var viewport= document.getElementById(mapId+ '_OpenLayers_ViewPort');
        if (viewport){
            viewport.style.position="absolute";
        }
    }

    webMapController.createPanel("toolGroup");    

    webMapController.addTool(webMapController.createTool("loading",Tool.LOADING_BAR));
    
    /* Zoom tool */
    zoomBox = webMapController.createTool("toolZoomin",Tool.ZOOM_BOX, {
        title: 'inzoomen via selectie'
    });
    webMapController.addTool(zoomBox);
    
    /* Pan tool */
    pan = webMapController.createTool("b_pan",Tool.PAN, {
        title: 'kaartbeeld slepem'
    });
    webMapController.addTool(pan);
    //set default tool pan so the cursor is ok.
    if (webMapController instanceof OpenLayersController) {
        webMapController.activateTool("b_pan");
    }
    
    /* Previous extent tool */
    prevExtent = webMapController.createTool("toolPrevExtent",Tool.NAVIGATION_HISTORY, {
        title: 'stap terug'
    });
    webMapController.addTool(prevExtent);

    /* Afstand meten tool */
    var bu_measure = webMapController.createTool("b_measure",Tool.MEASURE, {
        title: 'afstand meten'
    });
    //webMapController.registerEvent(Event.ON_MEASURE,bu_measure,measured);
    webMapController.addTool(bu_measure);
    
    /* I-tool */
    var options = new Object();
    options["handlerGetFeatureHandler"] = onIdentifyData;
    options["handlerBeforeGetFeatureHandler"] = onIdentify;
    options["title"] = "informatie opvragen";
    identify = webMapController.createTool("identify",Tool.GET_FEATURE_INFO,options);
    webMapController.addTool(identify);
    webMapController.registerEvent(Event.ON_SET_TOOL,identify,onChangeTool);
    
    var editLayer = webMapController.createVectorLayer("editMap");
    webMapController.getMap().addLayer(editLayer);
    webMapController.getMap().setLayerIndex(editLayer, webMapController.getMap().getLayers().length+startLayerIndex);
       
    /* Redlining tools */
    var edittingtb = webMapController.createTool("redLiningContainer",Tool.DRAW_FEATURE, {
        layer: editLayer
    });
    webMapController.addTool(edittingtb);
    
    /* Draw Polygon with measured surface area  */
    var bu_polyMeasure = webMapController.createTool("b_polyMeasure",Tool.MEASURED_POLYGON, {
        title: 'oppervlakte meten',
        displayClass: 'olControlb_polyMeasure'
    });
    webMapController.addTool(bu_polyMeasure);
    
    /* Buffer tool */
    var bu_buffer = webMapController.createTool("b_buffer",Tool.BUTTON, {
        layer: editLayer,
        title: 'buffer het tekenobject'
    });
    webMapController.addTool(bu_buffer);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_buffer,b_buffer);
    
    /* Selecteer kaartobject tool */
    var bu_highlight = webMapController.createTool("b_highlight",Tool.BUTTON, {
        layer: editLayer,
        title: 'selecteer een object in de kaart'
    });
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_highlight,b_highlight);
    webMapController.addTool(bu_highlight);
    
    /* Selecteer binnen kaartobject tool */
    var bu_getfeatures = webMapController.createTool("b_getfeatures",Tool.BUTTON, {
        layer: editLayer,
        title: 'selecteer binnen geselecteerd kaartobject'
    });
    webMapController.addTool(bu_getfeatures);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_getfeatures,b_getfeatures);
    
    /* Verwijder polygon tool */
    var bu_removePolygons = webMapController.createTool("b_removePolygons",Tool.BUTTON, {
        layer: editLayer,
        title: 'verwijder het tekenobject'
    });
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_removePolygons,b_removePolygons);
    webMapController.addTool(bu_removePolygons);

    /* Print tool */
    var bu_print = webMapController.createTool("b_printMap",Tool.BUTTON, {
        layer: editLayer,
        title: 'printvoorbeeld'
    });
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_print,b_print);
    webMapController.addTool(bu_print);

    /* Kaartselectie tool */
    var bu_layerSelection = webMapController.createTool("b_layerSelection",Tool.BUTTON, {
        layer: editLayer,
        title: 'kaartselectie'
    });
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_layerSelection,b_layerSelection);
    webMapController.addTool(bu_layerSelection);
    
    
    /* GPS tool */
    if (gpsBuffer < 1) {
        gpsBuffer = 500;
    }
    
    gpsComponent = new GPSComponent(gpsBuffer);
    
    var bu_gps = webMapController.createTool("b_gps",Tool.GPS, {
        layer: editLayer,
        title: 'zet GPS locatie aan/uit'
    });    
    
    webMapController.registerEvent(Event.ON_EVENT_UP, bu_gps, gpsComponent.stopPolling);
    webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_gps, gpsComponent.startPolling);
    
    /* off event voor weghalen marker */
    webMapController.registerEvent(Event.ON_EVENT_UP, bu_gps, b_gps_stop);
    
    webMapController.addTool(bu_gps);
    
    /* Overzichtskaart tool */
    var bu_overview = webMapController.createTool("b_showOverzicht",Tool.BUTTON, {
        layer: editLayer,
        title: 'overzichtskaart'
    });
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_overview,b_overview);
    webMapController.addTool(bu_overview);

    var scalebar = webMapController.createTool("scalebar",Tool.SCALEBAR);
    webMapController.addTool(scalebar);


    var zoombar= webMapController.createTool("zoombar",Tool.ZOOM_BAR);
    webMapController.addTool(zoombar);
    
    editComponent = new EditComponent();
    
    if (viewerTemplate == "embedded") {
        displayEmbeddedMenuIcons();
    }
}

function displayEmbeddedMenuIcons() {  
    $j("#embedded_icons").css('position', 'absolute');
    $j("#embedded_icons").css('width', '170px');
    $j("#embedded_icons").css('height', '36px');
    
    $j("#embedded_icons .embedded_icon").css('float', 'left');
    $j("#embedded_icons .embedded_icon").css('padding-top', '7px');
    $j("#embedded_icons .embedded_icon").css('padding-left', '15px');
    
    if (webMapController instanceof OpenLayersController) {        
        $j("#embedded_icons").css('left', '670px');
        $j("#embedded_icons").css('top', '6px');
        $j("#embedded_icons").css('border', 'solid 1px #808080');
        $j("#embedded_icons").css('background-color', '#eeeeee');
    } else {
        $j("#embedded_icons").css('left', '630px');
        $j("#embedded_icons").css('top', '2px');
    }
    
    $j("#embedded_icons").show();
}

function getBaseUrl() {
    var protocol = window.location.protocol + "//";
    var host = window.location.host;

    return protocol + host  + baseNameViewer;
}

/**
 * Uses a search configuration and search params in the url. Is done when searching via url
 * params and is called when the viewer (framework) is loaded.
*/
function doInitSearch() {
    if (searchConfigId.length > 0 && search.length > 0){
        showLoading();

        var termen = search.split(",");
        JZoeker.zoek(new Array(searchConfigId),termen,0,handleInitSearch);
    }
}

/**
 * Callback method used in doInitSearch() function. This function hides the loading
 * screen and calls the handleInitSearchResult() method for further handling.
 * @param list List with search results from back-end.
*/
function handleInitSearch(list){
    hideLoading();
    if (list.length > 0){
        handleInitSearchResult(list[0],searchAction, searchId,searchClusterId,searchSldVisibleValue);
    }
}

/**
 * Handles the search results from the back-end. It performs the given action.
 * @param result List with search results.
 * @param action The search action to perform (zoom, highlight or filter)
 * @param themaId Adds this value as themaId parameter for the SLD options.
 * @param clusterId Adds this value as clusterId parameter for the SLD options.
 * @param visibleValue Displays this value for the result. If none is provided
 * the result id is displayed instead.
*/
function handleInitSearchResult(result,action,themaId,clusterId,visibleValue) {    
    var doZoom= true;
    var doHighlight=false;
    var doFilter=false;
    if (searchAction){
        if (searchAction.toLowerCase().indexOf("zoom")==-1)
            doZoom=false;
        if (searchAction.toLowerCase().indexOf("highlight")>=0)
            doHighlight=true;
        else if (searchAction.toLowerCase().indexOf("filter")>=0)
            doFilter=true;
    }
    
    if (doHighlight || doFilter){
        var sldOptions="";
        var visval=null;
        if (visibleValue)
            visval=visibleValue;
        else if (result.id)
            visval=result.id;
        else
            visval=search;
        if (visval!=null){
            sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
            sldOptions+="visibleValue="+visval;
        }
        if(themaId){
            sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
            sldOptions+="themaId="+themaId;
        }
        if(clusterId){
            sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
            sldOptions+="clusterId="+clusterId;
        }
        sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
        if (doHighlight){
            sldOptions+="sldType=UserStyle";
        }
        if (doFilter){
            sldOptions+="sldType=NamedStyle";
        }
        var sldUrl=sldServletUrl+sldOptions;
        if(mapInitialized){
            setSldOnDefaultMap(sldUrl,true);
        }else{
            sldSearchServlet=sldUrl;
        }
    }
    
    /* Place marker */
    result = getBboxMinSize2(result);
    var x = (result.maxx - result.minx) / 2 + result.minx;
    var y = (result.maxy - result.miny) / 2 + result.miny;
        
    placeSearchResultMarker(x,y);    
    switchTab(document.getElementById("zoeken"));
    
    /* Lagen aanzetten na zoeken */
    JZoekconfiguratieThemaUtil.getThemas(searchConfigId, function(data) {
        zoekconfiguratieThemasCallBack(data);
        switchLayersOn();
        
        if (doZoom){
            result=getBboxMinSize2(result);
            var ext= new Object();
            ext.minx=result.minx;
            ext.miny=result.miny;
            ext.maxx=result.maxx;
            ext.maxy=result.maxy;
            if (mapInitialized) {
                moveToExtent(ext.minx, ext.miny, ext.maxx, ext.maxy);
            } else{
                searchExtent=ext;
            }
        }        
    });
}

function placeSearchResultMarker(x,y) {
    webMapController.getMap().setMarker("searchResultMarker", x, y);
}

function removeSearchResultMarker() {
    webMapController.getMap().removeMarker("searchResultMarker");
}

/**
 * Changes the bounding box of the feature to a minimal size when this is smaller
 * than the minimal vlue.
 * @param feature The feature.
 * @return Returns the feature with adjusted bbox.
*/
function getBboxMinSize2(feature){
    if ((Number(feature.maxx-feature.minx) < minBboxZoeken)){
        var addX=Number((minBboxZoeken-(feature.maxx-feature.minx))/2);
        var addY=Number((minBboxZoeken-(feature.maxy-feature.miny))/2);
        feature.minx=Number(feature.minx-addX);
        feature.maxx=Number(Number(feature.maxx)+Number(addX));
        feature.miny=Number(feature.miny-addY);
        feature.maxy=Number(Number(feature.maxy)+Number(addY));
    }
    return feature;
}

/**
 * Because a simple reload won't change the url in flamingo. Remove the layer
 * and add it again. Maybe a getCap is done but with a little luck the browser
 * cached the last request.
 * @param sldUrl The SLD url for the layer.
 * @param reAddLayer If true the layer will be removed and added again.
*/
function setSldOnDefaultMap(sldUrl, reAddLayer){
    var kbLayer = webMapController.getMap("map1").getLayer("fmcLayer");
    kbLayer.setSld(escape(sldUrl));

    if (reAddLayer){
        webMapController.getMap("map1").removeLayerById(kbLayer.getId(), false);
        webMapController.getMap("map1").addLayer(kbLayer);
    }
}

/**
 * Shows a busy with loading page.
 * cached the last request.
 * @param handle Handle to the window to display page content in.
 * @param type Type of display used (div, panel or window).
*/
function loadBusyJSP(handle, type) {
    var $iframebody = null;
    if(type == 'div') $iframebody = $j(handle).contents().find("body");
    if(type == 'panel') $iframebody = $j('#'+handle).contents().find("body");
    if(type == 'window') $iframebody = $j(handle.document.body);
    
    // "Gewoon" popup window (dus geen DIV) geeft nog niet helemaal het gewenste resultaat
    if($iframebody != null) {
        $iframebody.html('<div id="content_style">'+
            '<table class="kolomtabel">'+
            '<tr>'+
            '<td valign="top">'+
            '<div class="loadingMessage">'+
            '<table>'+
            '<tr>'+
            '<td style="width:20px;"><img style="border: 0px;" src="/gisviewer/images/waiting.gif" alt="Bezig met laden..." /></td>'+
            '<td>'+
            '<h2>Bezig met laden ...</h2>'+
            '<p>Bezig met zoeken naar administratieve gegevens.</p>'+
            '</td>'+
            '</tr>'+
            '</table>'+
            '</div>'+
            '</td>'+
            '</tr>'+
            '</table>'+
            '</div>');
    }
}

/**
 * Handles onIdentify by the user to retrieve object information. This function
 * submits the data via form to the back-end.
 * @param geom The (buffered) geometry of the click location.
 * @param highlightThemaId Is used to also highlight the clicked object.
 * @param selectionWithinObject Boolean indicates if it should retrieve objectdata
 * for all objects within the current selection (polygon). When false it retrives only
 * data directly under the (buffered) click location.
 * @param themaIds the thema ids where this request must be done. If ommited the 
 * selected thema's are used. It doesn't change the checkboxes.
 * @param extraCriteria JavaScript object with CQL criteria that is used as filter for getting the features.
*/
function handleGetAdminData(geom, highlightThemaId, selectionWithinObject, themaIds, extraCriteria) {
    if (!usePopup && !usePanel && !useBalloonPopup) {
        return;
    }
    if (themaIds==undefined){
        if (!multipleActiveThemas){
            themaIds = activeAnalyseThemaId;
        } else {
            themaIds = getLayerIdsAsString(true);
        }

        if (themaIds == null || themaIds == '') {
            hideLoading();
            return;
        }
    }
    //set the extra criteria.
    document.forms[0].extraCriteria.value="";
    if(extraCriteria){
        document.forms[0].extraCriteria.value=extraCriteria;
    }
    //set the correct action
    document.forms[0].admindata.value = 't';
    document.forms[0].metadata.value = '';
    document.forms[0].objectdata.value = '';
    
    document.forms[0].themaid.value = themaIds;
    
    document.forms[0].lagen.value='';

    //als er een init search is meegegeven (dus ook een sld is gemaakt)
    if (searchAction.toLowerCase().indexOf("filter")>=0){
        
        document.forms[0].search.value=search;
        document.forms[0].searchId.value=searchId;
        document.forms[0].searchClusterId.value=searchClusterId;
    }

    document.forms[0].geom.value=geom;
    
    document.forms[0].scale.value=webMapController.getMap().getResolution();
    document.forms[0].tolerance.value=tolerance;

    if (selectionWithinObject) {
        document.forms[0].withinObject.value = "1";
        document.forms[0].onlyFeaturesInGeom.value="true";
    }else {
        document.forms[0].withinObject.value = "-1";
        document.forms[0].onlyFeaturesInGeom.value="false";
    }
    
    if (bookmarkAppcode != null) {
        document.forms[0].bookmarkAppcode.value=bookmarkAppcode;
    }

    if (highlightThemaId != null) {
        document.forms[0].themaid.value = highlightThemaId;
    }

    if (usePopup) {
        // open popup when not opened en submit form to popup
        if(dataframepopupHandle == null || dataframepopupHandle.closed) {
            if(useDivPopup) {
                dataframepopupHandle = popUpData('dataframedivpopup', 680, 225, true);
            } else {
                dataframepopupHandle = popUpData('dataframepopup', 680, 225, false);
            }
        }

        if(useDivPopup) {
            //$j("#popupWindow").show();
            document.forms[0].target = 'dataframedivpopup';
            loadBusyJSP(dataframepopupHandle, 'div');
        } else {
            document.forms[0].target = 'dataframepopup';
            loadBusyJSP(dataframepopupHandle, 'window');
        }

    } else if(useBalloonPopup){
        if(!balloon){
            var offsetX = 0;
            var offsetY = 0;

            /* offsetY nodig voor de flamingo toolbalk boven de kaart */
            if (webMapController instanceof FlamingoController){
                offsetY=36;
            }
            
            balloon= new Balloon($j("#mapcontent"),webMapController,'infoBalloon',300,300,offsetX,offsetY);
        }
        document.forms[0].target = 'dataframeballoonpopup';
        /*Bepaal midden van vraag geometry*/      
        //maak coord string
        var coordString =geom.replace(/POLYGON/g,'').replace(/POINT/,'').replace(/\(/g,'').replace(/\)/g,'');
        var xyPairs=coordString.split(",");
        var minx;
        var maxx;
        var miny;
        var maxy;
        for (var i=0; i < xyPairs.length; i++){
            var xy=xyPairs[i].split(" ");
            var x=Number(xy[0]);
            var y=Number(xy[1])
            if (minx==undefined){
                minx=x;
                maxx=x;
            }
            if(miny==undefined){
                miny=y;
                maxy=y;
            }
            if (x > maxx){
                maxx=x;
            }
            if (x < minx){
                minx=x;
            }
            if (y > maxy){
                maxy=y;
            }
            if (y < miny){
                miny=y;
            }
        }
        var centerX=(minx+maxx)/2;
        var centerY=(miny+maxy)/2;

        //balloon.resetPositionOfBalloon(centerX,centerY);
        balloon.setPosition(centerX,centerY,true);

        var iframeElement=$j('<iframe id="dataframeballoonpopup" name="dataframeballoonpopup" class="popup_Iframe" src="admindatabusy.do" frameborder="0">')
        balloon.getContentElement().html(iframeElement);
    } else {
        document.forms[0].target = 'dataframe';
        loadBusyJSP('dataframe', 'panel');
    }
    
    document.forms[0].submit();
}

/**
 * Opens an url in an iFrame.
 * @param url url to open.
*/
function openUrlInIframe(url){
    var iframe=document.getElementById("dataframe");
    iframe.src=url;
}

/**
 * Returns current state of layer item. When item analyse is "active" then it
 * always returns -1 so it will be visible.
 * @param item The layer item.
 * @return 0 = Not in cookie or visible, -1 = No cookie but visible, 1 = In cookie.
*/
function getLayerPosition(item) {

    if((cookieArray == null) || !useCookies) {
        if (item.visible=="on" || item.analyse=="active")
            return -1;
        else
            return 0;
    }

    var arr = cookieArray.split(',');

    for(i = 0; i < arr.length; i++) {
        if(arr[i] == item.id) {
            return i+1;
        }
    }

    if (item.analyse=="active")
        return -1;
    
    return 0;
}

/**
 * Returns current state of cluster item. When item is active then it always
 * returns -1 so it will be visible.
 * @param item The cluster item.
 * @return 0 = Not in cookie or visible, -1 = No cookie but visible, 1 = In cookie.
*/
function getClusterPosition(item) {
    if ((cookieClusterArray == null) || !useCookies) {
        if (item.visible || item.active)
            return -1;
        else
            return 0;
    }
    var arr = cookieClusterArray.split(',');
    for(i = 0; i < arr.length; i++) {
        if(arr[i] == item.id) {
            return i+1;
        }
    }
    if (item.active)
        return -1;

    return 0;
}

/**
 * Set the active cluster to be able to display metadata for this cluster..
 * @param item Cluster item to be activated
 * @param overrule When true overrule the current active item.
*/
function setActiveCluster(item,overrule){
    if(((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) && (activeClusterId==null || activeClusterId.length==0)) || overrule){
        if(item != undefined & item != null) {
            var activeClusterTitle = item.title;
            var atlabel = document.getElementById('actief_thema');
            if (atlabel && activeClusterTitle && atlabel!=null && activeClusterTitle!=null){
                activeClusterId = item.id;
                atlabel.innerHTML = '' + activeClusterTitle;
            }
            if(item.metadatalink && item.metadatalink.length > 1){
                if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
            }
        }
    }
}

/**
 * Set the active thema to be able to fetch object info.
 * @param id The id of the thema.
 * @param label Label to display above the viewer.
 * @param overrule When true overrule the current active thema.
 * @return The active analyse thema.
*/
function setActiveThema(id, label, overrule) {
    if (!(id && id!=null && label && label!=null && overrule)) {
        return activeAnalyseThemaId;
    }

    if (((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) &&
        (activeClusterId==null || activeClusterId.length==0)) || overrule){

        activeAnalyseThemaId = id;

        var atlabel = document.getElementById('actief_thema');
        if (atlabel && label && atlabel!=null && label!=null) {
            atlabel.innerHTML = '' + label;
        }

        if (document.forms[0] && document.forms[0].coords && document.forms[0].coords.value.length > 0){
            var tokens= document.forms[0].coords.value.split(",");
            var minx = parseFloat(tokens[0]);
            var miny = parseFloat(tokens[1]);
            var maxx;
            var maxy
            if (tokens.length ==4){
                maxx = parseFloat(tokens[2]);
                maxy = parseFloat(tokens[3]);
            }else{
                maxx=minx;
                maxy=miny;
            }
            onIdentify('',{
                minx:minx,
                miny:miny,
                maxx:maxx,
                maxy:maxy
            })
        }
    }
    return activeAnalyseThemaId;
}

/**
 * Called when a user selects a radio element in the tree. Activates the selected
 * thema. When the thema has a metadata link it will display the info in the info tab.
 * @param obj The selected raio element.
*/
function radioClick(obj) {
    var oldActiveThemaId = activeAnalyseThemaId;
    if (obj && obj!=null && obj.theItem && obj.theItem!=null && obj.theItem.id && obj.theItem.title) {
        activeAnalyseThemaId = setActiveThema(obj.theItem.id, obj.theItem.title, true);
        activateCheckbox(obj.theItem.id);
        deActivateCheckbox(oldActiveThemaId);

        if (obj.theItem.metadatalink && obj.theItem.metadatalink.length > 1) {
            if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=obj.theItem.metadatalink;
        }
    }
}

var prevRadioButton = null;

/**
 * Check if the item is the current active thema.
 * @param item The item to check.
 * @return boolean
*/
function isActiveItem(item) {
    if (!item) {
        return false;
    }
    if(item.analyse=="on"){
        setActiveThema(item.id, item.title);
    } else if(item.analyse=="active"){
        setActiveThema(item.id, item.title, true);
    }

    if (activeAnalyseThemaId != item.id) {
        return false;
    }
    
    if(item.analyse=="active" && prevRadioButton != null){
        var rc = document.getElementById(prevRadioButton);
        if (rc!=undefined && rc!=null) {
            rc.checked = false;
        }
    }

    if (item.metadatalink && item.metadatalink.length > 1) {
        if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
    }
    prevRadioButton = 'radio' + item.id;

    return true;
}

/**
 * Create a radio cluster element
 * @param item the cluster item (json)
 * @param checked set to true if this radio must be checked?
 * @param groupName the groupname of this radio group (the parent cluster id in most cases)
 * @return The radio element.
 */
function createRadioCluster(item,checked,groupName){
    var checkbox;
    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input type="radio" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="clusterCheckboxClick(this,false)"';
        checkboxControleString += ' name="'+groupName+'">';
        checkbox = document.createElement(checkboxControleString);
    }else{
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'radio';
        checkbox.value = item.id;
        checkbox.name= groupName;
        checkbox.onclick = function(){
            clusterCheckboxClick(this, false);
        }
        if(checked) {
            checkbox.checked = true;
        }
    }

    return checkbox;
}


/**
 * Create a checkbox cluster element
 * @param item Item the cluster item (json)
 * @param checked Checked set to true if this radio must be checked?
 * @return The checkbox element.
 */
function createCheckboxCluster(item, checked){

    var checkbox;
    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="clusterCheckboxClick(this,false)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);
    }else{
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.value = item.id;
        checkbox.onclick = function(){
            clusterCheckboxClick(this, false);
        }
        if(checked) {
            checkbox.checked = true;
        }
    }
    
    return checkbox;
}

/**
 * Create a radio element for active thema.
 * @param item The thema item (json)
 * @return The radio element.
 */
function createRadioSingleActiveThema(item){
    var radio;
    if (ieVersion <= 8 && ieVersion != -1) {
        var radioControleString = '<input type="radio" id="radio' + item.id + '" name="selkaartlaag" value="' + item.id + '"';
        if (isActiveItem(item)) {
            radioControleString += ' checked="checked"';
        }
        radioControleString += ' onclick="radioClick(this);"';
        radioControleString += '>';
        radio = document.createElement(radioControleString);
    } else {
        radio = document.createElement('input');
        radio.type = 'radio';
        radio.name = 'selkaartlaag';
        radio.value = item.id;
        radio.id = 'radio' + item.id;
        radio.onclick = function(){
            radioClick(this);
        }
        if (isActiveItem(item)) {
            radio.checked = true;
        }
    }
    radio.theItem=item;
    return radio;
}

/**
 * Create a radio thema
 * @param item the thema item (json)
 * @param checked set to true if this radio must be checked?
 * @param groupName the groupname of this radio group (the parent cluster id in most cases)
 * @return The radio element.
*/
function createRadioThema(item,checked,groupName){
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input type="radio" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false)"';
        checkboxControleString += ' name="'+groupName+'">';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'radio';
        checkbox.value = item.id;
        checkbox.name = groupName;
        checkbox.onclick = function() {
            checkboxClick(this, false);
        }

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}

/**
 * Create a checkbox thema
 * @param item the thema item (json)
 * @param checked set to true if this radio must be checked?
 * @return The checkbox element.
*/
function createCheckboxThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.value = item.id;

        checkbox.onclick = function() {
            checkboxClick(this, false);
        }

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}

/**
 * Creates a non visible thema div
 * @param item The id for the div element
 * @return createInvisibleDiv()
*/
function createInvisibleThemaDiv(item) {
    return createInvisibleDiv(item.id);
}

/**
 * Creates a non visible div
 * @param id The id for the div element.
 * @return The div element.
*/
function createInvisibleDiv(id) {
    var div = document.createElement("div");
    div.name=id;
    div.id=id;
    div.style.height='0';
    div.style.width='0';
    div.height=0;
    div.width=0;
    div.style.display="none";
    return div;
}

/**
 * Creates a link element to a new iFrame with the metadata from the item.
 * @param item The item with the metadata.
 * @return The link element.
*/
var widthMetadataPopup = 800;
var heightMetadataPopup = 600;
var widthDownloadPopup = 425;
var heightDownloadPopup = 250;
var downloadPopupBlocksViewer = true;
var metadataPopupBlocksViewer = true;

function createMetadataLink(item){
    var lnk = document.createElement('a');
    lnk.innerHTML = item.title ? item.title : item.id;
    lnk.href = '#';

    var downloadTitle = 'Download dataset van ' + item.title;
    var infoTitle = 'Informatie over ' + item.title; 

    /* Metadata tonen, WMS Service url en Annuleren */
    if (item.metadatalink && item.metadatalink.length > 1 && (item.gegevensbronid == undefined || item.gegevensbronid < 1)) {
        lnk.onclick = function() {
            $j("#dialog-download-metadata").dialog("option", "buttons", {                
                "Metadata": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                        $j(this).dialog("close");
                    }
                },
                "Url": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                        $j(this).dialog("close");                        
                        
                        var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                        $j("#input_wmsserviceurl").val(url);
                        
                        unblockViewerUI();
                        $j("#dialog-wmsservice-url").dialog('open');
                    }
                },
                "Annuleren": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        $j(this).dialog("close");
                        unblockViewerUI();
                    }
                }
            });

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });

            //blockViewerUI();
            $j("#dialog-download-metadata").dialog('open');
        }
        
        return lnk;
    }

    /* Download tonen, WMS Service url en Annuleren */
    if ( (item.metadatalink == undefined || item.metadatalink == '#') && item.gegevensbronid && item.gegevensbronid > 0) {
        lnk.onclick = function() {
            
            /* Wel download en url button tonen */
            if (datasetDownload && showServiceUrl) {
                $j("#dialog-download-metadata").dialog("option", "buttons", {
                    "Download": function() {                    
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            /* Kijken of er een polygoon is getekend voor subselectie in download */
                            var wkt = getWktForDownload();            
                            if (wkt == "") {
                                alert("Let op: Er is nog geen selectie ingetekend. U gaat de gehele dataset downloaden.")
                            }

                            iFramePopup('download.do?id=' + item.gegevensbronid, false, downloadTitle, widthDownloadPopup, heightDownloadPopup, downloadPopupBlocksViewer, false);
                            $j(this).dialog("close");
                        }
                    },
                    "Url": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                            $j(this).dialog("close");                        

                            var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            $j("#input_wmsserviceurl").val(url);

                            unblockViewerUI();
                            $j("#dialog-wmsservice-url").dialog('open');
                        }
                    },                
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            } else if (!datasetDownload && showServiceUrl) {
                $j("#dialog-download-metadata").dialog("option", "buttons", {                    
                    "Url": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                            $j(this).dialog("close");                        

                            var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            $j("#input_wmsserviceurl").val(url);

                            unblockViewerUI();
                            $j("#dialog-wmsservice-url").dialog('open');
                        }
                    },
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            } else {
                $j("#dialog-download-metadata").dialog("option", "buttons", { 
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            }

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });
            
            $j("#dialog-download-metadata").dialog('open');
        }
        
        return lnk;
    }

    /* Download tonen, Metadata, WMS Service url en Annuleren */
    if (item.metadatalink && item.metadatalink.length > 1 && item.gegevensbronid && item.gegevensbronid > 0) {
        lnk.onclick = function() {
            
            /* Wel download button tonen */
            if (datasetDownload && showServiceUrl) {
                $j("#dialog-download-metadata").dialog("option", "buttons", {
                    "Download": function() {            
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            /* Kijken of er een polygoon is getekend voor subselectie in download */
                            var wkt = getWktForDownload();            
                            if (wkt == "") {
                                alert("Let op: Er is nog geen selectie ingetekend. U gaat de gehele dataset downloaden.")
                            }

                            iFramePopup('download.do?id=' + item.gegevensbronid, false, downloadTitle, widthDownloadPopup, heightDownloadPopup, downloadPopupBlocksViewer, false);
                            $j(this).dialog("close");
                        }
                    },
                    "Metadata": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                            $j(this).dialog("close");
                        }
                    },
                    "Url": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                            $j(this).dialog("close");                        

                            var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            $j("#input_wmsserviceurl").val(url);

                            unblockViewerUI();
                            $j("#dialog-wmsservice-url").dialog('open');
                        }
                    },
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            } else if (!datasetDownload && showServiceUrl) {
                $j("#dialog-download-metadata").dialog("option", "buttons", {                    
                    "Metadata": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                            $j(this).dialog("close");
                        }
                    },
                    "Url": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                            $j(this).dialog("close");                        

                            var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            $j("#input_wmsserviceurl").val(url);

                            unblockViewerUI();
                            $j("#dialog-wmsservice-url").dialog('open');
                        }
                    },
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            } else {
                $j("#dialog-download-metadata").dialog("option", "buttons", {                    
                    "Metadata": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                            $j(this).dialog("close");
                        }
                    },
                    "Annuleren": function() {
                        if ($j("#dialog-download-metadata").dialog("isOpen")) {
                            $j(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });
            }            

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });

            //blockViewerUI();
            $j("#dialog-download-metadata").dialog('open');
        }
        
        return lnk;
    }
    
    /* Alleen url en Annuleren */
    if ( (item.metadatalink == undefined || item.metadatalink == '#') && (item.gegevensbronid == undefined || item.gegevensbronid < 1) && (showServiceUrl) ) {
        lnk.onclick = function() {
            $j("#dialog-download-metadata").dialog("option", "buttons", {                
                "Url": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                        $j(this).dialog("close");                        
                        
                        var url = kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                        $j("#input_wmsserviceurl").val(url);
                        
                        unblockViewerUI();
                        $j("#dialog-wmsservice-url").dialog('open');
                    }
                },
                "Annuleren": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        $j(this).dialog("close");
                        unblockViewerUI();
                    }
                }
            });

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });

            //blockViewerUI();
            $j("#dialog-download-metadata").dialog('open');
        }
        
        return lnk;
    }

    return lnk;
}

function createWMSServiceUrlDialog() {
    $j("#dialog-wmsservice-url").dialog({
        resizable: false,
        disabled: true,
        autoOpen: false,        
        modal: false,
        width: 750,
        height: 150
    });
}

function createDownloadMetadataDialog(){
    $j("#dialog-download-metadata").dialog({
        resizable: false,
        disabled: true,
        autoOpen: false,        
        modal: false
    });
}

/**
 * Creates a leaf in the tree. Is called for each item when creating the tree.
 * @param container The tree container
 * @param item The item with the leaf info.
 * @return useless boolean ?
*/
function createLabel(container, item) {

    if (item.cluster) {
        //if callable
        if (item.callable) {
            var checkboxChecked = false;
            var clusterPos = getClusterPosition(item);
            if(clusterPos!=0) {
                checkboxChecked = true;
            }
            var checkbox = null;
            var parentItem=getParentItem(themaTree,item);
            if (parentItem.exclusive_childs){
                checkbox=createRadioCluster(item,checkboxChecked,parentItem.id);
            }else{
                checkbox=createCheckboxCluster(item, checkboxChecked);
            }

            checkbox.theItem=item;
            container.appendChild(checkbox);

            if (checkboxChecked){
                clustersAan.push(checkbox);
            }

            // alleen een callable item kan active zijn
            if (item.active){
                setActiveCluster(item, true);
            }
        }
        var hasChildsWithLegend=false;
        if (item.hide_tree && item.callable){
            // hack om toggle plaatje uit te zetten als
            // cluster onzichtbare onderliggende kaartlagen heeft
            var img = document.createElement("img");
            img.setAttribute("border", "0");
            img.src = globalTreeOptions["layermaindiv"].toggleImages["leaf"]
            img.theItem=item;
            container.togglea = img;

            // als een cluster childs heeft en legend moet in tree worden getoond.
            if (showLegendInTree && item.children){
                //controleer of er een NIET cluster child een legend heeft.
                hasChildsWithLegend=false;
                for (var i=0; i < item.children.length && !hasChildsWithLegend; i++){
                    var child=item.children[i];
                    if (!child.cluster && child.legendurl!=undefined){
                        hasChildsWithLegend=true;
                    }
                }
                if (hasChildsWithLegend){
                    container.appendChild(document.createTextNode('  '));
                    container.appendChild(createTreeLegendIcon());                    
                }
            }
        }
        if (!item.hide_tree || item.callable){
            container.appendChild(document.createTextNode('  '));
            container.appendChild(createMetadataLink(item));
        }
        container.appendChild(createTreeLegendDiv(item));
        if (item.hide_tree && !item.callable){
            return true; //hide
        }

    } else if (!item.hide_tree) {
        if(item.wmslayers){

            alleLayers.push(item);

            checkboxChecked = false;
            var layerPos = getLayerPosition(item);
            if(layerPos!=0) {
                checkboxChecked = true;
            }

            var themaCheckbox = null;
            parentItem=getParentItem(themaTree,item);
            if (parentItem.exclusive_childs){
                themaCheckbox=createRadioThema(item,checkboxChecked,parentItem.id);
            }else{
                themaCheckbox=createCheckboxThema(item, checkboxChecked);
            }
            themaCheckbox.theItem=item;

            if (checkboxChecked) {
                if (layerPos<0) {
                    layersAan.unshift(themaCheckbox);
                } else {
                    layersAan.push(themaCheckbox);
                }
            }

            if(item.analyse=="on" || item.analyse=="active"){
                if (!multipleActiveThemas){
                    var labelRadio = createRadioSingleActiveThema(item);
                    container.appendChild(labelRadio);
                } else {
                    isActiveItem(item);
                }
            }
            container.appendChild(themaCheckbox);
        }

        if (item.legendurl != undefined && showLegendInTree) {
            container.appendChild(document.createTextNode('  '));
            container.appendChild(createTreeLegendIcon());
        }

        container.appendChild(document.createTextNode('  '));
        container.appendChild(createMetadataLink(item));

        if (item.legendurl != undefined && showLegendInTree) {
            container.appendChild(createTreeLegendDiv(item));
        }
        
    } else {
        var divje = createInvisibleThemaDiv(item);
        divje.theItem=item;
        container.appendChild(divje);
        if(item.visible=="on" && item.wmslayers){
            addItemAsLayer(item);
        }
        return true;//hide
    }

    return false;
}

/**
 * Disable (gray out) a layer in the tree. Function uses jQuery to edit element.
 * @param itemid Item id to disable.
*/
function disableLayer(itemid) {
    var $item = $j("#layermaindiv_item_" + itemid+"_label");
    $item.addClass("layerdisabled");
    //$item.find("input").attr("disabled", "disabled");
    $item.find(".treeLegendIcon").addClass("disabledLegendIcon");
}

/**
 * Enable a layer in the tree. Function uses jQuery to edit element.
 * @param itemid Item id to enable.
*/
function enableLayer(itemid) {
    var $item = $j("#layermaindiv_item_" + itemid+"_label");
    $item.removeClass("layerdisabled");
    //$item.find("input").removeAttr("disabled");
    $item.find(".treeLegendIcon").removeClass("disabledLegendIcon");
}

/**
 * Creates a new legend icon element for use in tree.
 * @return The icon element.
*/
function createTreeLegendIcon() {
    var legendicon = document.createElement("img");
    legendicon.src = imageBaseUrl + "icons/application_view_list.png";
    legendicon.alt = "Legenda tonen";
    legendicon.title = "Legenda tonen";
    legendicon.width="15";
    legendicon.height="13";
    legendicon.className = 'treeLegendIcon imagenoborder';
    $j(legendicon).click(function(){
        if(!$j(this).hasClass("disabledLegendIcon")) loadTreeLegendImage($j(this).siblings("div").attr("id"));
    });
    return legendicon;
}

/**
 * Loads the legend image when the user clicked on a legend icon.
*/
function loadTreeLegendImage(divid) {
    var divobj = document.getElementById(divid);
    var $divobj = $j(divobj);
    var item = divobj.theItem;

    var found = $divobj.find("img.legendLoading");
    if(found.length == 0) {
        var legendloading = document.createElement("img");
        legendloading.src = imageBaseUrl + "icons/loadingsmall.gif";
        legendloading.alt = "Loading";
        legendloading.title = "Loading";
        legendloading.className = 'legendLoading imagenoborder';

        divobj.appendChild(legendloading);
    }

    var foundlegend = $divobj.find("img.treeLegendImage");
    if(foundlegend.length == 0) {
        if (item.cluster){
            var addedImages=0;
            for (var i=0; i < item.children.length; i++){
                var child=item.children[i];
                if (child.legendurl!=undefined){
                    if (addedImages>0)
                        divobj.appendChild(document.createElement("br"));
                    var legendimg=createTreeLegendImage(child);
                    divobj.appendChild(legendimg);
                    legendimg.src = child.legendurl;
                    addedImages++;
                }
            }
        }else{
            legendimg=createTreeLegendImage(item);
            divobj.appendChild(legendimg);
            legendimg.src = item.legendurl;
        }
    }
    $j(divobj).toggle();
}

/**
 * Creates the image element for the legend
 * @param item Item used for the image name and title
 * @return Image element.
*/
function createTreeLegendImage(item){
    var legendimg = document.createElement("img");
    legendimg.name = item.title;
    legendimg.alt = "Legenda " + item.title;
    legendimg.onerror=treeImageError;
    legendimg.onload=treeImageOnload;
    legendimg.className = 'treeLegendImage';
    // Set src after the img element is appended to make sure onload gets called, even when image is in cache
    // legendimg.src = item.legendurl;
    return legendimg;
}

/**
 * Creates the tree legend div.
 * @param item Item used for the image name and title
 * @return Div element.
*/
function createTreeLegendDiv(item) {
    var id=item.id + '#tree#' + item.wmslayers;

    var div = document.createElement("div");
    div.name=id;
    div.id=id;
    div.title =item.title;
    div.className="treeLegendClass";
    div.theItem=item;
    div.style.display = 'none';

    return div;
}

/**
 * Displays an error when the legend image can not be fetched.
*/
function treeImageError(){
    var divobj = $j(this).parent();
    divobj.find("img.legendLoading").hide();
    divobj.html('<span style="color: Black;">Legenda kan niet worden opgehaald</span>');
}

/**
 * Hides the legend loading message when the legend image is loaded.
*/
function treeImageOnload(){
    // TODO: Hoogte check wegehaald, ging niet altijd goed in IE7 waardoor laadicoontje niet werd weggehaald
    // if (parseInt(this.height) > 5){
    $j(this).parent().find("img.legendLoading").hide();
// }
}

function activateCheckbox(id) {
    var obj = document.getElementById(id);
    if(obj!=undefined && obj!=null && !obj.checked)
        document.getElementById(id).click();
}

function deActivateCheckbox(id) {
    if (id==undefined || id==null)
        return;
    var obj = document.getElementById(id);
    if(obj!=undefined && obj!=null && obj.checked)
        document.getElementById(id).click();
}

function switchTab(obj) {
    if (obj==undefined || obj==null)
        return;
    
    // Check if user is allowed for the tab, if not select first tab
    var allowed = false;
    for(i in enabledtabs) {
        var tabid = enabledtabs[i];
        if(tabid == obj.id) allowed = true;
    }
    if(!allowed) {
        obj = document.getElementById(enabledtabs[0]);
    }
    if(typeof obj === 'undefined' || !obj) {
        return;
    }

    eraseCookie('activetab');
    createCookie('activetab', obj.id, '7');
    currentActiveTab = obj.id;
    $j(obj).addClass("activelink");
    for(i in tabbladen) {
        var tabobj = tabbladen[i];
        if(tabobj.id != obj.id) {
            $j("#" + tabobj.id).removeClass("activelink");
            if(cloneTabContentId == null || cloneTabContentId != tabobj.contentid) {
                document.getElementById(tabobj.contentid).style.display = 'none';
                if(tabobj.extracontent != undefined) {
                    for(j in tabobj.extracontent) {
                        if(document.getElementById(tabobj.extracontent[j])){
                            document.getElementById(tabobj.extracontent[j]).style.display = 'none';
                        }
                    }
                }
            }
        } else {
            document.getElementById(tabobj.contentid).style.display = 'block';
            if(tabobj.extracontent != undefined) {
                for(j in tabobj.extracontent) {
                    if(document.getElementById(tabobj.extracontent[j])){
                        document.getElementById(tabobj.extracontent[j]).style.display = 'block';
                    }
                }
            }
        }
    }
}

function syncLayerCookieAndForm() {
    var layerString = getLayerIdsAsString();
    if (layerString == "") {
        layerString = 'ALL';
    }
    if (useCookies) {
        eraseCookie('checkedLayers');
        if (layerString!=null) {
            createCookie('checkedLayers', layerString, '7');
        }
    }
    document.forms[0].lagen.value = layerString;
}

//called when a checkbox is clicked.
function checkboxClick(obj, dontRefresh) {
    var item = obj.theItem;
    if(obj.checked) {        
        addItemAsLayer(item);
        if (useInheritCheckbox) {
            //zet bovenliggende cluster vinkjes aan
            var object = document.getElementById(item.id);
            enableParentClusters(object);
        }
    } else {
        removeItemAsLayer(item);
    }

    if (obj.type=='radio'){
        if (obj.checked){
            var radiogroup=$j("input[name='"+obj.name+"']");
            $j.each(radiogroup,function(key, value){
                if (obj.id!=value.id){
                    checkboxClick(value,true);
                }
            })
        }
    }

    if (!dontRefresh){
        if(obj.checked) {
            refreshLayerWithDelay();
        }else{
            doRefreshLayer();
        }
    }
}
//called when a clustercheckbox is clicked
function clusterCheckboxClick(element,dontRefresh){
    if (element==undefined || element==null)
        return;
    if (layerUrl==null){
        layerUrl=""+kburl;
    }
    var status=element.checked;
    if (status){
        var found=false;
        for (var i=0; i < clustersAan.length; i++){
            if (clustersAan[i].id==element.id){
                found=true;
            }
        }
        if (!found)
            clustersAan.push(element);
    }else{
        var newClustersAan = new Array();
        for (var j=0; j < clustersAan.length; j++){
            if (clustersAan[j].id!=element.id){
                newClustersAan.push(clustersAan[j]);
            }
        }
        clustersAan=newClustersAan;
    }
    /* indien cookies aan dan cluster id in cookie stoppen */
    var cluster=element.theItem;
    if (useCookies) {      
        if (element.checked) {
            addClusterIdToCookie(cluster.id);
        }else {
            removeClusterIdFromCookie(cluster.id);
        }
    }
    // Als er niet naar de useInheritCheckbox wordt gekeken (dus het vinkje bij 'Kaartgroep overerving' is uit)
    // of
    // als een tree gehide is (gebruiker kan de layers niet aan/uit vinken)
    if (!useInheritCheckbox || cluster.hide_tree) {
        if (element.checked) {

            /* Cluster is net aangevinkt. Children omgekeerd aanzetten zodat
             * bovenste layer in boom ook bovenop wordt getekend. */
            for (var k = cluster.children.length; k > 0; k--){
                var child = cluster.children[k-1];

                if (!child.cluster){
                    addItemAsLayer(child);
                    if (!cluster.hide_tree){
                        document.getElementById(child.id).checked=true;
                    }
                } else {
                    //if cluster is callable AND not 'kaartgroep overerving'
                    if (child.callable && !useInheritCheckbox){
                        var elemin = document.getElementById(child.id);
                        elemin.checked=true;
                        clusterCheckboxClick(elemin,dontRefresh);
                    }
                }
            }
        } else if (cluster.children){
            for (var d=0; d < cluster.children.length;d++) {
                var child1=cluster.children[d];
                if (!child1.cluster){
                    removeItemAsLayer(child1);
                    if (!cluster.hide_tree){
                        document.getElementById(child1.id).checked=false;
                    }
                } else {
                    //if cluster is callable AND not 'kaartgroep overerving'
                    if (child1.callable && !useInheritCheckbox){
                        var elemout = document.getElementById(child1.id);
                        elemout.checked=false;
                        clusterCheckboxClick(elemout,dontRefresh);
                    }
                }
            }
        }     
    }
    /*Als useInheritCheckbox dan grafisch in de tree aangegeven dat onderliggende layers niet zichtbaar zijn.*/
    if (useInheritCheckbox){        
        for (var m=0; m < cluster.children.length;m++){
            child=cluster.children[m];
            if (element.checked) {
                enableLayer(child.id);
            }else{
                disableLayer(child.id);
            }
        }
    }
    /*if its a radio and checked,then disable the other radio's*/
    if (element.type=='radio' && cluster.children){
        var childDiv=$j("#layermaindiv_item_" + element.id+"_children");
        if (element.checked){
            //als er child elementen zijn dan die aanzetten en tree expanden.
            if (childDiv){
                childDiv.removeClass("disabledRadioChilds");
                $j("#layermaindiv_item_" + element.id+"_children input").removeAttr("disabled");
                treeview_expandItemChildren("layermaindiv",element.id);
            }
            //andere radio's uitzetten.
            var jqueryElementString="input[name='"+element.name+"']";
            var radiogroup=$j(jqueryElementString);
            $j.each(radiogroup,function(key, value){
                if (element.id!=value.id){
                    clusterCheckboxClick(value,dontRefresh);
                }
            })
        }else{
            //als een andere van de group aan is dan deze disablen, mits er childs zijn.
            if (childDiv){
                childDiv.addClass("disabledRadioChilds");
                treeview_collapseItemChildren("layermaindiv",element.id);
                $j("#layermaindiv_item_" + element.id+"_children input").attr('disabled',true);
            }
        }
    }

    if (!dontRefresh){
        refreshLayerWithDelay();
    }
}

function addClusterIdToCookie(id) {
    var str = readCookie('checkedClusters');
    var arr = new Array();
    if (str != null)
        arr = str.split(',');
    
    var newValues = "";
    var found = false;
    for (var x=arr.length-1; x >=0 ; x--) {
        if (arr[x] == id) {
            found = true;
        }
        if (newValues.length==0) {
            newValues += arr[x];
        } else {
            newValues += ","+arr[x];
        }
    }
    if (!found) {
        if (newValues.length==0) {
            newValues += id;
        } else {
            newValues += ","+ id;
        }
    }
    createCookie('checkedClusters', newValues, '7');
}

function removeAllFeatures() {
    webMapController.getMap().getLayer("editMap").removeAllFeatures();
}

function stopDrawPolygon() {
    webMapController.getMap().getLayer("editMap").removeAllFeatures();
    webMapController.getMap().getLayer("editMap").stopDrawDrawFeature();
}

function startDrawPolygon(geomType) {
    webMapController.getMap().getLayer("editMap").removeAllFeatures();
    webMapController.getMap().getLayer("editMap").drawFeature(geomType);
}

function removeClusterIdFromCookie(id) {
    var str = readCookie('checkedClusters');
    var arr = new Array();
    if (str != null)
        arr = str.split(',');

    var newValues = "";
    for (var x=arr.length-1; x >=0 ; x--) {
        /* als id niet diegene is die verwijderd moet worden
         * dan toevoegen aan nieuwe cookie value */
        if (arr[x] != id) {
            if (x == arr.length-1)
                newValues += arr[x];
            else
                newValues += ","+arr[x];
        }
    }

    createCookie('checkedClusters', newValues, '7');
}

function addItemAsLayer(theItem){
    addLayerToEnabledLayerItems(theItem);
    syncLayerCookieAndForm();
    
    //If there is a orgainization code key then add this to the service url.
    if (theItem.wmslayers){
        var organizationCodeKey = theItem.organizationcodekey;
        if(organizationcode!=undefined && organizationcode != null && organizationcode != '' && organizationCodeKey!=undefined && organizationCodeKey != '') {
            if(layerUrl.indexOf(organizationCodeKey)<=0){
                if(layerUrl.indexOf('?')> 0)
                    layerUrl+='&';
                else
                    layerUrl+='?';
                layerUrl = layerUrl + organizationCodeKey + "="+organizationcode;
            }
        }
    }    
}

function isStringEmpty(str) {
    return (!str || 0 === str.length);
}

var originalLayerUrl = layerUrl;

function reloadRedliningLayer(themaId, projectnaam, removeFeatures) {
    var groepParam = "GROEPNAAM";
    var projectParam = "PROJECTNAAM";

    if (!isStringEmpty(organizationcode)) {
        layerUrl = originalLayerUrl + groepParam + "=" + organizationcode;
    }

    if (!isStringEmpty(projectnaam)) {
        layerUrl = originalLayerUrl + projectParam + "=" + projectnaam;
    }

    if (!isStringEmpty(organizationcode) && !isStringEmpty(projectnaam)) {
        layerUrl = originalLayerUrl + groepParam + "=" + organizationcode + "&"
        + projectParam + "=" + projectnaam;
    }

    /* tekenobject van kaart afhalen */
    if (removeFeatures) {
        removeAllFeatures();
    }

    /* TODO: Beetje lelijk gewoon vinkje aan uitzetten om redlining laag te refreshen
     * wellicht een keer methode schrijven voor de webmapcontroller die
     * iets dergelijks kan doen */
    deActivateCheckbox(themaId);
    activateCheckbox(themaId);
}

/* als order niet aangepast mag worden dan moet hier een sort komen */
function addLayerToEnabledLayerItems(theItem){
    var foundLayerItem = null;
    for (var i=0; i < enabledLayerItems.length; i++){
        if (enabledLayerItems[i].id==theItem.id){
            foundLayerItem = enabledLayerItems[i];
            break;
        }
    }
    if (foundLayerItem == null) {
        enabledLayerItems.push(theItem);
    }
}

function removeItemAsLayer(theItem){
    if (removeLayerFromEnabledLayerItems(theItem.id)!=null) {
        syncLayerCookieAndForm();
        return;
    }
}

function removeLayerFromEnabledLayerItems(itemId){
    for (var i=0; i < enabledLayerItems.length; i++){
        if (enabledLayerItems[i].id==itemId){
            var foundLayerItem = enabledLayerItems[i];
            enabledLayerItems.splice(i,1);
            return foundLayerItem;
        }
    }
    return null;
}

var refresh_timeout_handle;    
function refreshLayerWithDelay() {
    showLoading();

    if(refresh_timeout_handle) { 
        clearTimeout(refresh_timeout_handle);
        hideLoading();
    } 
    refresh_timeout_handle = setTimeout("doRefreshLayer();", refreshDelay);
}     

function doRefreshLayer() {    
    //register after loading
    webMapController.registerEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE,webMapController.getMap(), refreshLegendBox);
    refreshLayer();

    refreshLegendBox();
}

/*Check scale for all layers*/
function checkScaleForLayers() {
    var currentscale = webMapController.getMap().getScaleHint();
    
    setScaleForTree(themaTree,currentscale);
}


/*Controleert of een item in de huidige schaal past.
 * Voor een enkele layer wordt gekeken of die er in past
 * Voor een cluster wordt gekeken of er 1 van de layers in de schaal past.
 * @param item json thema of cluster
 * @param scale de scale waarvoor gekeken moet worden of de layer daar zichtbaar is.
 * @return boolean wel of niet zichtbaar in scale.
 **/
function isItemInScale(item, scale) {
    if (scale == 'NaN' || scale < 0 || !item) {
        return false;
    }
    
    var itemVisible = true;
    
    if (item.children) {
        itemVisible = false;
        for (var i=0; i < item.children.length; i++){
            if(isItemInScale(item.children[i],scale)){
                itemVisible=true;
            }
        }
    } else {
        if (item.scalehintmin != null) {
            var minscale = Number(item.scalehintmin.replace(",", "."));
            if (scale<minscale){
                itemVisible=false;
            }
        }
        if (item.scalehintmax != null) {
            var maxscale = Number(item.scalehintmax.replace(",", "."));
            if (scale>maxscale){
                itemVisible=false;
            }
        }       
    }
    
    /* Schaal check voor Tiling lagen */
    if (item.resolutions || item.PRINTRESOLUTIONS) {
        var list;
        var res;
        
        if (item.PRINTRESOLUTIONS) {
            res = item.PRINTRESOLUTIONS;
        } else {
            res = item.resolutions;
        }        
        
        if (!res instanceof Array) {
            list = res.split(" ");

            if (list && list.length < 1) {
                list = res.split(",");
            }
        }
        
        if (list && list.length > 0) {
            var size = list.length;
            var max = list[0];
            var min = list[size-1];
            
            if (min == "") {
                min = list[size-2];
            }

            // doe W(res(kw) * 2) scalehint
            var scaleMax = Math.sqrt((max*max) * 2);   
            var scaleMin = Math.sqrt((min*min) * 2);

            var adjustedScale = scale + 0.00000000000001;
            
            if (adjustedScale <= scaleMax && adjustedScale >= scaleMin) {
                itemVisible = true;
            } else {
                itemVisible = false;
            }
        }
    }    
    
    return itemVisible;
}
/**
 *Sets een tree item enabled or disabled (visually)
 */
function setScaleForTree(item,scale){
    var disabledRadio = false;
    
    //if disabled radioinput dan zijn de layers al gedisabled.
    var inputElement = document.getElementById(item.id);
    
    disabledRadio = inputElement && inputElement.type=='radio' && !inputElement.checked;
    
    if (!disabledRadio){
        if (item.children){
            for (var i=0; i < item.children.length; i++){
                setScaleForTree(item.children[i],scale);
            }
        }
        var itemVisible = isItemInScale(item,scale);

        /* Als item een cluster is en aangevinkt kan worden of het item is
         * geen cluster, dus een kaartlaag dan mag dit wel of
         * niet uitgegrijst worden */
        if ((item.cluster && item.callable) || !item.cluster) {
            if (itemVisible){
                enableLayer(item.id);
            }else{
                disableLayer(item.id);
            }
        }
        
        return itemVisible;
        
    } else {
        return false;
    }
}

function refreshLayer(doRefreshOrder) {    
    var local_refresh_handle = refresh_timeout_handle;

    if (doRefreshOrder == undefined) {
        doRefreshOrder = false;
    }

    if (layerUrl==undefined || layerUrl==null) {
        hideLoading();
        return;
    }

    if(layerUrl.toLowerCase().indexOf("?service=")==-1 && layerUrl.toLowerCase().indexOf("&service=" )==-1) {
        if (layerUrl.indexOf('?')> 0) {
            layerUrl+='&';
        } else {
            layerUrl+='?';
        }
        layerUrl+="SERVICE=WMS";
    }

    var topLayerItems = new Array();
    var backgroundLayerItems = new Array();
    var item;

    for (var i=0; i<enabledLayerItems.length; i++){
        item = enabledLayerItems[i];

        if (useInheritCheckbox) {
            var object = document.getElementById(item.id);
            
            /* Indien object nog niet gevonden dan is het item
             * waarschijnlijk een user layer. Object opzoeken via jQuery */
            if (object == undefined || object == null) {
                object = $j("#input").find('l_' + item.id);                
            }
            
            if (object == undefined || object == null) {
                object = $j("#input").find('lOn_' + item.id);                
            }
            
            // Item alleen toevoegen aan de layers indien
            // parent cluster(s) allemaal aangevinkt staan of
            // geen cluster heeft
            if (!itemHasAllParentsEnabled(object)) {
                continue;
            }  
        }
        if (item.wmslayers){
            if (item.background){
                backgroundLayerItems.push(item)
            }else{
                topLayerItems.push(item);
            }
        }
    }

    var orderedLayerItems = new Array();
    orderedLayerItems = orderedLayerItems.concat(backgroundLayerItems);
    orderedLayerItems = orderedLayerItems.concat(topLayerItems);
    var layerGroups = new Array();
    var layerGroup;
    var lastGroupName = "";
    var localGroupName = "";
    for (var j=0; j<orderedLayerItems.length; j++){
        item = orderedLayerItems[j];
        //als layergrouping afzonderlijke layers is of als de layer een tiling layer is
        //maak dan een afzonderlijke layer.
        if (layerGrouping == "lg_layer" || item.tiled) {
            localGroupName = "fmc" + item.id;
        } else if (layerGrouping == "lg_cluster") {
            localGroupName = "fmc" + item.clusterid;
        }else if (layerGrouping == "lg_forebackground") {
            if (item.background){
                localGroupName = "fmcback";
            }else{
                localGroupName = "fmctop";
            }
        } else {
            localGroupName = "fmcall";
        }
        if (lastGroupName == "" || localGroupName != lastGroupName) {
            layerGroup = new Array();
            if (layerGrouping == "lg_cluster") {
                layerGroup.push(localGroupName + "_" + item.id);
            } else {
                layerGroup.push(localGroupName);
            }
            layerGroups.push(layerGroup);

        }
        layerGroup.push(item);
        lastGroupName = localGroupName;
    }

    // verwijderen ontbrekende layers
    var allLayers=webMapController.getMap().getLayers();
    var shownLayers= new Array();
    for (var a=0; a < allLayers.length; a++){
        if (allLayers[a].getType()==Layer.RASTER_TYPE){
            shownLayers.push(allLayers[a]);
        }
    }
    var removedLayers = new Array();
    for (var k=0; k < shownLayers.length; k++){
        var lid = shownLayers[k].getId();
        var ls = shownLayers[k].getOption("layers");
        var found = false;
        for (i=0; i<layerGroups.length && found==false; i++){
            layerGroup = layerGroups[i];
            if (lid == layerGroup[0]) {
                // controleren of laagvolgorde hetzelfde is
                var lsreq = "";
                for (var m=1; m < layerGroup.length; m++){
                    item = layerGroup[m];
                    if (lsreq.length>0) {
                        lsreq+=",";
                    }
                    lsreq+=item.wmslayers;
                }
                if (ls == lsreq) {
                    found = true;
                    break;
                }
            }
        }
        if (!found) {
            removedLayers.push(lid);
        }
    }
    for (var n=0; n < removedLayers.length; n++){
        webMapController.getMap().removeLayerById(removedLayers[n]);//false
    }

    // toevoegen lagen
    for (i=0; i<layerGroups.length; i++){
        layerGroup = layerGroups[i];
        var layerId = layerGroup[0];
        
        if (webMapController.getMap().getLayer(layerId)==null){
            layerGroup.splice(0,1); // verwijder eerste element
            
            for (k=0; k < layerGroup.length; k++) {                
                /* eigen wms layer */
                if (layerGroup[k].serviceid != undefined) {
                    var lName = layerGroup[k].name;                    
                    var lUrl = layerGroup[k].service_url;
                    var layers = new Array();
                    layers[0] = layerGroup[k];

                    /* Sld url aan service url toevoegen
                    var sldUrl = layerGroup[k].service_sld;                    
                    if (sldUrl != undefined && sldUrl != "" && sldUrl.length > 0) {
                        lUrl += "&sld=" + sldUrl;
                    } */
                    
                    addLayerToViewer(lName, lUrl, layers);
                    layerId = getValidLayerId(lName);
                } else {                    
                    addLayerToViewer(layerId, layerUrl, layerGroup);                  
                }
            }
        }

        var layer=webMapController.getMap().getLayer(layerId);
        if (layer!=null){
            var oldOrderIndex=webMapController.getMap().setLayerIndex(layer,i+startLayerIndex);
            if (i+startLayerIndex != oldOrderIndex){
                doRefreshOrder=true;
            }
        }
    }

    hideLoading();

    if (local_refresh_handle != refresh_timeout_handle) {
        // check of dit een goed idee is
        // alleen refresh als er intussen geen nieuwe timeout gezet is
        return;
    }else {
        refresh_timeout_handle = 0;
    }
    if (doRefreshOrder) {
    //TODO: WebMapController
    //webMapController.getMap().refreshLayerOrder();
    }
    
    // flamingoController.getMap().update();

    var lagen = webMapController.getMap().getAllVectorLayers();
    var tilingLayers = webMapController.getMap().getAllTilingLayers();
    
    if (tilingLayers) {
        lagen.concat(tilingLayers);
    }
    
    var totalLayers = webMapController.getMap().getLayers().length;
    for(var p = 0 ; p < lagen.length;p++){
        var laag = lagen[p];
        webMapController.getMap().setLayerIndex(laag,totalLayers+startLayerIndex);
    }
    
    /* Tijdelijke punten ook tonen */
    checkTempUploadedPointsWms(uploadCsvLayerOn);
}

function getLayerById(id) {
    var layer = webMapController.getMap().getLayer(id);

    if (layer != null) {
        return layer;
    }

    return null;
}

function layersOnlyHaveDefaultStyles(layerItems) {
    if (layerItems == undefined || layerItems == "")
        return true;

    for (var i=0; i < layerItems.length; i++) {
        var item = layerItems[i];

        if (item.use_style && item.use_style != "default")
            return false;
    }

    return true;
}

function addLayerToViewer(lname, layerUrl, layerItems) {       
    //tiling layer
    if (layerItems.length==1 && layerItems[0].tiled){
        var options=new Object();
        var tileItem=layerItems[0];
        options["VERSION"]=tileItem.tileVersion;
        options["LAYERS"]=tileItem.tileLayers;        
        options["STYLES"]=tileItem.tileStyles;
        options["FORMAT"]=tileItem.tileFormat;
        options["SRS"]=tileItem.tileSrs;
        options["BBOX"]=tileItem.tileBoundingBox;
        
        /* voor transparantie slider */
        options["background"]= tileItem.background;  
        
        var maxBounds = getMaxBounds();
        var olRes = getTilingResolutions(maxBounds, false); 
            
        if (webMapController instanceof OpenLayersController && tilingResolutions) {
            options["serverResolutions"] = olRes; // tilingResolutions
        }
        
        options["RESOLUTIONS"] = olRes; //tileItem.resolutions;
        
        options["TILEHEIGHT"]=tileItem.tileHeight;
        options["TILEWIDTH"]=tileItem.tileWidth;
        
        /* Min/max scale zetten voor tiling layers */
        if (tileItem.resolutions) {      
            var res = tileItem.resolutions;
            ; //.trim();

            var list;
            list = res.split(" ");

            if (list && list.length < 1) {
                list = res.split(",");
            }

            if (list && list.length > 0) {
                var size = list.length;
                var max = list[0];
                var min = list[size-1];

                options["minscale"] = min;
                options["maxscale"] = max;
            }
        }
        
        var tileLayer=webMapController.createWMScLayer(lname, layerUrl,options);        
        webMapController.getMap().addLayer(tileLayer);
        
    } else {
        //wms layer    
        var capLayerUrl=layerUrl;

        var validId = getValidLayerId(lname);

        var options={
            id: validId,
            timeout: 30,
            retryonerror: 10,
            getcapabilitiesurl: capLayerUrl,
            ratio: 1,
            showerrors: true,
            initService: false
        };

        var ogcOptions={
            format: "image/png",
            transparent: true,
            exceptions: "application/vnd.ogc.se_inimage",
            srs: "EPSG:28992",
            version: "1.1.1",
            noCache: true // TODO: Voor achtergrond kaartlagen wel cache gebruiken
        };

        var theLayers="";
        var queryLayers="";
        var maptipLayers="";
        var smallestMinscale = -1;
        var largestMaxscale = -1;

        var allStyles = "";

        /* Kijken of layers alleen maar default styles bevatten? Zo ja
         * dan hoeven er geen styles meegegeven te worden */
        var onlyDefaultStyles = layersOnlyHaveDefaultStyles(layerItems);
    
        /* 
     * TODO: Sld parts opbouwen via sld servlet. Servlet aan layerUrl plakken
     * Als er een hele sld in de layerUrl is meegegeven dan geen style gebruiken 
    */
        if (layerUrl.indexOf("&sld=") != -1) {
            onlyDefaultStyles = true;
        }

        var sldIds = "";
    
        var maptips=new Array();
        // last in list will be on top in map
        for (var i=0; i<layerItems.length; i++){
            var item = layerItems[i];
        
            var usingSldPart = false;
            if (item.sld_part != undefined && item.sld_part != "") {            
                if (sldIds.length < 1) {
                    sldIds += item.id;
                } else {
                    sldIds += "," + item.id;
                }
            
                usingSldPart = true;
            }
        
            /* styles komma seperated aan ogc options toevoegen. style niet gebruiken
         * als er een sld_part is voor het item. */
            if (item.use_style && !onlyDefaultStyles && !usingSldPart) {
                if (i == layerItems.length-1) {
                    allStyles += item.use_style;
                } else {
                    allStyles += item.use_style + ",";
                }
            }

            var minscale;
            if (smallestMinscale!=0){
                if (item.scalehintmin != null) {
                    minscale = Number(item.scalehintmin.replace(",", "."));
                    if (!isNaN(minscale)){
                        if (smallestMinscale == -1 || minscale < smallestMinscale) {
                            smallestMinscale = minscale;
                        }
                    }
                }else{
                    //geen minscale dan moet er geen minscale worden ingesteld.
                    smallestMinscale=0;
                }            
            }

            var maxscale;
            if (largestMaxscale!=0){
                if (item.scalehintmax != null) {
                    maxscale = Number(item.scalehintmax.replace(",", "."));
                    if (!isNaN(maxscale)) {
                        if (largestMaxscale == -1 || maxscale > largestMaxscale) {
                            largestMaxscale = maxscale;
                        }
                    }
                }else{
                    //geen maxscale dan moet er geen maxscale worden ingesteld.
                    largestMaxscale=0;
                }
            }

            if (item.wmslayers){
                if (theLayers.length>0) {
                    theLayers+=",";
                }
                theLayers+=item.wmslayers;

                /* 
                 * Achtergrond optie toevoegen voor gebruik bij Print. Anders
                 * komt de laatst aangevinkte laag bovenop ook als dit een 
                 * achtergrond laag is.
                */
                if (item.background) {
                    options["background"] = true;
                } else {
                    options["background"] = false;
                }

            }
            if (item.wmsquerylayers){
                if (queryLayers.length > 0) {
                    queryLayers+=",";
                }
                queryLayers+=item.wmsquerylayers
            }
            if (layerItems[i].maptipfield){
                if (maptipLayers.length!=0)
                    maptipLayers+=",";
                maptipLayers+=layerItems[i].wmslayers;
                var aka=layerItems[i].wmslayers;
                //Als de gebruiker ingelogd is dan zal het waarschijnlijk een kaartenbalie service zijn
                //Daarom moet er een andere aka worden gemaakt voor de map tip.
                if (ingelogdeGebruiker && ingelogdeGebruiker.length > 0){
                    aka=aka.substring(aka.indexOf("_")+1);
                }
                var maptip=new MapTip(layerItems[i].wmslayers,layerItems[i].maptipfield,aka);
                maptips.push(maptip);
            //newLayer.addLayerProperty(new LayerProperty(layerItems[i].wmslayers, layerItems[i].maptipfield, aka));
            }
        }

        if (smallestMinscale != null && smallestMinscale > 0) {
            options["minscale"]=smallestMinscale;
        }

        if (largestMaxscale != null && largestMaxscale > 0) {
            options["maxscale"]=largestMaxscale;
        }

        if (webMapController instanceof FlamingoController){
            if(options["maxResolution"]){
                options["maxscale"]=options["maxResolution"];
            }
            if(options["minResolution"]){
                options["minscale"]=options["minResolution"];
            }
            delete options["maxResolution"];
            delete options["minResolution"];
        }else if (webMapController instanceof OpenLayersController){
            if (options["maxResolution"]!=undefined && options["minResolution"]==undefined){
                options["minResolution"]="auto";
            }
            if (options["minResolution"]!=undefined && options["maxResolution"]==undefined){
                options["maxResolution"]="auto";
            }
        }

        ogcOptions["styles"] = allStyles;

        ogcOptions["layers"]=theLayers;
        ogcOptions["query_layers"]=queryLayers;
        //ogcOptions["sld"] = "http://localhost/rpbadam/rpbadam.xml";

        options["maptip_layers"]=maptipLayers;

        /* sld servlet gebruiken ? */
        if (sldIds.length > 0) {
            var protocol = window.location.protocol + "//";
            var host = window.location.host;

            var baseUrl = protocol + host  + baseNameViewer;
            var sldUrl = "sld=" + baseUrl + "/services/createUserSld?layerids=" + sldIds;

            layerUrl += sldUrl;
        }

        var newLayer=webMapController.createWMSLayer(lname, layerUrl, ogcOptions, options);

        newLayer.setMapTips(maptips);
        
        webMapController.getMap().addLayer(newLayer);//false, true, false
    }
}

function loadObjectInfo(geom) {
    for(i in enabledtabs) {
        if (enabledtabs[i] == "gebieden") {
            // vul object frame
            document.forms[0].admindata.value = '';
            document.forms[0].metadata.value = '';
            if (!multipleActiveThemas){
                document.forms[0].themaid.value = activeAnalyseThemaId;
            } else {
                document.forms[0].themaid.value = getLayerIdsAsString();
            }

            document.forms[0].analysethemaid.value = activeAnalyseThemaId;

            document.forms[0].geom.value=geom;
            document.forms[0].scale.value ='';

            // vul adressen/locatie
            document.forms[0].objectdata.value = 't';
            document.forms[0].target = 'objectframeViewer';

            document.forms[0].submit();
            break;
        }
    }
}
/**
 * Get alle enabled layer items
 * @param onlyWithinScale Only get the visible, within currentScale items.
 */
function getLayerIdsAsString(onlyWithinScale) {
    var ret = "";
    var firstTime = true;

    for (var i=0; i < enabledLayerItems.length; i++) {

        if (useInheritCheckbox) {
            var object = document.getElementById(enabledLayerItems[i].id);
            /* Item alleen toevoegen aan de layers indien
             * parent cluster(s) allemaal aangevinkt staan of
             * geen cluster heeft */
            if (!itemHasAllParentsEnabled(object))
                continue;
        }
        if (onlyWithinScale){
            var currentscale = webMapController.getMap().getScaleHint();
            if (!isItemInScale(enabledLayerItems[i],currentscale)){
                continue;
            }
        }
        if(firstTime) {
            ret += enabledLayerItems[i].id;
            firstTime = false;
        } else {
            ret += "," + enabledLayerItems[i].id;
        }
    }
  
    return ret;
}

/* uitleg zie itemHasAllParentsEnabled */
function enableParentClusters(object) {
    if (object == null) {
        return;
    }
    var parentChildrenDiv = getParentDivContainingChilds(object, 'div');
    if (!parentChildrenDiv) {
        return;
    }
    var parentDiv = getParentByTagName(parentChildrenDiv, 'div');
    var name = getItemName(parentDiv);
    var checkbox = document.getElementById(name);
    checkbox.checked = true;

    enableParentClusters(parentDiv);

}


function itemHasAllParentsEnabled(object) {

    if (object == null) {
        return false;
    }

    /* zoek eerste div element met _children erin */
    var parentChildrenDiv = getParentDivContainingChilds(object, 'div');

    /* als er geen parent div is met eventuele children (cluster)
     * dan top bereikt dus alles aangevinkt */
    if (!parentChildrenDiv) {
        return true;
    }

    /* neem hiervan eerste div erboven, dit is dan de div
     * met input vinkje voor het cluster */
    var parentDiv = getParentByTagName(parentChildrenDiv, 'div');

    /* opzoeken of checkbox element checked is */
    var name = getItemName(parentDiv);
    var checkbox = document.getElementById(name);
    if (!checkbox.checked) {
        /* niet aangevinkt dus false */
        return false;
    }
    return itemHasAllParentsEnabled(parentDiv);

}

/* zoekt omhoog naar het eerste element met _children erin
 * tagname van element meegeven */
function getParentDivContainingChilds(obj, tag)
{
    var obj_parent = obj.parentNode;

    if ( !obj_parent || (obj_parent.id == null)  )
        return false;

    /* alleen parent teruggeven als het ook aangevinkt kan worden */
    if ( (obj_parent.id.indexOf("_children") != -1) && (parentHasCheckBox(obj_parent)) )
        return obj_parent;
    else
        return getParentDivContainingChilds(obj_parent, tag);
}

function getParentByTagName(obj, tag)
{
    var obj_parent = obj.parentNode;
    if (!obj_parent)
        return false;

    if (obj_parent.tagName.toLowerCase() == tag)
        return obj_parent;
    else
        return getParentByTagName(obj_parent, tag);
}

/* geeft het laatste stukje van de naam terug */
function getItemName(item) {
    var str = item.id.split("_");
    var l = str.length;

    var name = str[l-1];

    return name;
}

/* gebruik om te bepalen of ouder cluster aangevinkt kan worden of niet.
 * Indien dit niet kan dan moet deze niet meegeteld worden in de
 * berekening of alle clusters wel aangevinkt staan bij de methode
 * itemHasAllParentsEnabled()
 */
function parentHasCheckBox(parent) {
    /* neem hiervan eerste div erboven, dit is dan de div
     * met eventueel input vinkje voor het cluster */
    var parentDiv = getParentByTagName(parent, 'div');
    var name = getItemName(parentDiv);
    var checkbox = document.getElementById(name);
    if (checkbox) {
        return true;
    }
    return false;
}
//the loading legend images (needed to abort loading)
var loadingLegendImages= new Object();
function createLegendDiv(item) {
    var id=item.id + '##' + item.wmslayers;
    var myImage = new Image();
    myImage.name = item.title;
    myImage.id=id;
    myImage.onerror=imageOnerror;
    myImage.onload=imageOnload;

    var spanEl = document.createElement("span");
    spanEl.innerHTML = ' ' + item.title + '<br />';
    spanEl.className = 'orderLayerSpanClass';

    var div = document.createElement("div");
    div.name=id;
    div.id=id;
    div.title =item.title;
    div.className="orderLayerClass";
    div.appendChild(spanEl);
    div.theItem=item;
	
    /* nieuw */
    div.onclick=function(){
        selectLayer(this);
    };
    if (item.hide_legend){
        div.style.display="none";
    } // end

    if (item.legendurl != undefined) {        
        myImage.src = item.legendurl;
        loadingLegendImages[id]=myImage;        
    } else {
        myImage.onerror();
    }

    div.onclick=function(){
        selectLayer(this);
    };

    if (item.hide_legend){
        div.style.display="none";
    }
    return div;
}
function imageOnerror(){
    this.style.height='0';
    this.style.width='0';
    this.height=0;
    this.width=0;
    //release 1 loading space
    legendImageLoadingSpace++;
    loadNextInLegendImageQueue();
}
function imageOnload(){
    //if not is a loading image then don't add to the DOM
    if (loadingLegendImages[this.id]!=undefined){
        if (parseInt(this.height) > 5){
            var legendimg = document.createElement("img"); 
            legendimg.src = this.src;
            legendimg.onerror=this.onerror;
            legendimg.className = "imagenoborder";
            legendimg.alt = this.name;
            legendimg.title = this.name;
            var legendImage = document.getElementById(this.id);
            if (legendImage) {
                legendImage.appendChild(legendimg);
            }
        }
        //done loading remove
        delete loadingLegendImages[this.id];
        //release 1 loading space
        legendImageLoadingSpace++;
        loadNextInLegendImageQueue();
    }
}

//adds a layer to the legenda
//if atBottomOfType is set to true the layer will be added at the bottom of its type (background or top type)
function addLayerToLegendBox(theItem,atBottomOfType) {
    //check if already exists in legend
    var layerDiv = findLayerDivInLegendBox(theItem);
    if (layerDiv!=null) {
        if($j(layerDiv).css("display")=="none"){
            var beforeChild=findBeforeDivInLegendBox(theItem,atBottomOfType);
            if (beforeChild==null){
                $j(orderLayerBox).append($j(layerDiv));
            }else{
                /* TODO: Nagaan of bovenin toevoegen kan. */
                if(beforeChild.id == layerDiv.id) {
                    $j(orderLayerBox).prepend($j(layerDiv));
                } else {
                    $j(beforeChild).before($j(layerDiv));
                }
            //$j(orderLayerBox).insertBefore($j(layerDiv),beforeChild);
            }
        }
        $j(layerDiv).css("display","block");
        return;
    }
    
    legendImageQueue.push({
        theItem: theItem, 
        atBottomOfType: atBottomOfType
    });
    loadNextInLegendImageQueue();
}
//queue of the legend objects that needs to be loaded
var legendImageQueue = new Array();
//slots that can be used to load the legend objects
var legendImageLoadingSpace=1;
/**
Load the next image object.
*/
function loadNextInLegendImageQueue(){
    if (legendImageLoadingSpace>0 && legendImageQueue.length > 0){
        //consume 1 loading place
        legendImageLoadingSpace--;
        var nextLegend=legendImageQueue.shift();
        var theItem=nextLegend.theItem;
        var atBottomOfType=nextLegend.nextLegend;

        var div = createLegendDiv(theItem);

        var beforeChild=null;
        if(orderLayerBox.hasChildNodes()) {
            beforeChild = findBeforeDivInLegendBox(theItem, atBottomOfType)
        }
        if (beforeChild==null){
            orderLayerBox.appendChild(div);
        }else{
            orderLayerBox.insertBefore(div,beforeChild);
        }
    }
}
function resetLegendImageQueue(){
    //loadingLegendImages= new Object();
    legendImageQueue = new Array();
    legendImageLoadingSpace=2;
}
function findLayerDivInLegendBox(theItem) {
    var id=theItem.id + '##' + theItem.wmslayers;
    for(var i=0; i < orderLayerBox.childNodes.length; i++){
        var child = orderLayerBox.childNodes.item(i);
        if(child.id==id){
            return child;
        }
    }
    return null;
}

function findBeforeDivInLegendBox(theItem, atBottomOfType) {
    var beforeChild=null;
    //place layer before the background layers.
    if (theItem.background){
        if (atBottomOfType){
            beforeChild=null;
        }else{
            for(var i=0; i < orderLayerBox.childNodes.length; i++){
                var orderLayerItem=orderLayerBox.childNodes.item(i).theItem;
                if (orderLayerItem){
                    if (orderLayerItem.background){
                        beforeChild=orderLayerBox.childNodes.item(i);
                        break;
                    }
                }
            }
        }
    }else{
        if (atBottomOfType){
            var previousChild=null;
            for(var j=0; j < orderLayerBox.childNodes.length; j++){
                orderLayerItem=orderLayerBox.childNodes.item(j).theItem;
                if (orderLayerItem){
                    if (orderLayerItem.background){
                        beforeChild=previousChild;
                        break;
                    }
                }
                previousChild=orderLayerBox.childNodes.item(j);
            }
        }else{
            beforeChild=orderLayerBox.firstChild;
        }
    }
    return beforeChild;
}

function refreshMapVolgorde() {
    refreshLegendBox();
    refreshLayer(true);
    syncLayerCookieAndForm();
}

function refreshLegendBox() {    
    resetLegendImageQueue();
    
    webMapController.unRegisterEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE,webMapController.getMap(), refreshLegendBox,this);
    var visibleLayerItems = new Array();
    var invisibleLayerItems = new Array();
    for (var k=0; k<enabledLayerItems.length; k++){
        var item = enabledLayerItems[k];
        var found = false;
        if (useInheritCheckbox) {
            var object = document.getElementById(item.id);
            //Item alleen toevoegen aan de layers indien
            //parent cluster(s) allemaal aangevinkt staan of
            //geen cluster heeft
            var res = webMapController.getMap().getResolution();
            
            if (!itemHasAllParentsEnabled(object) || (!isItemInScale(item, res))) {
                found = true;
                invisibleLayerItems.push(item);
            }
        }
        if (!found) {
            visibleLayerItems.push(item);
        }
    }
    enabledLayerItems = new Array();
    var totalLength = orderLayerBox.childNodes.length;
    //Kijk of ze al bestaan en in die volgorde staan.
    for(var i = (totalLength - 1); i > -1; i--) {
        var stillVisible=false;
        var itemId = splitValue(orderLayerBox.childNodes[i].id)[0];
        for (var m=0; m < visibleLayerItems.length; m++){
            if (visibleLayerItems[m].id==itemId){
                var foundLayerItem = visibleLayerItems[m];
                enabledLayerItems.push(foundLayerItem);
                visibleLayerItems.splice(m, 1);
                stillVisible=true;
            }
        }
        if (!stillVisible){
            //orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
            //$j(orderLayerBox.childNodes[i]).remove();
            $j(orderLayerBox.childNodes[i]).css("display","none");
        }
    }
    if (visibleLayerItems.length>0) {
        enabledLayerItems = enabledLayerItems.concat(visibleLayerItems);
    }
    
    resetLegendImageQueue();
    
    for (var j=0; j<enabledLayerItems.length; j++){
        item = enabledLayerItems[j];
        
        addLayerToLegendBox(item, false);
    }
    if (invisibleLayerItems.length>0) {
        enabledLayerItems = enabledLayerItems.concat(invisibleLayerItems);
    }
}

function deleteAllLayers() {
    var totalLength = orderLayerBox.childNodes.length;
    for(var i = (totalLength - 1); i > -1; i--) {
        document.getElementById(splitValue(orderLayerBox.childNodes[i].id)[0]).checked = false;
        orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
    }
    enabledLayerItems=new Array();
    syncLayerCookieAndForm();
    doRefreshLayer();
}

function splitValue(val) {
    return val.split('##');
}

function getActiveLayerId(cookiestring) {
    if(!cookiestring) return null;
    var items = cookiestring.split('##');
    return items[0];
}
function getActiveLayerLabel(cookiestring) {
    if(!cookiestring) return null;
    var items = cookiestring.split('##');
    return items[1];
}

var activeTab = readCookie('activetab');
if(activeTab != null) {
    switchTab(document.getElementById(activeTab));
} else if (demogebruiker) {
    switchTab(document.getElementById('themas'));
} else {
    switchTab(document.getElementById('themas'));
}

var orderLayerBox= document.getElementById("orderLayerBox");

function onChangeTool(id, event) {
    if (id == 'identify') {
        btn_highLightSelected = false;
        hideIdentifyIcon();
    }
}

//function wordt aangeroepen als er een identify wordt gedaan met de tool op deze map.
function onIdentify(movie,extend) {
    if(!usePopup && !usePanel && !useBalloonPopup) {
        return;
    }

    //todo: nog weghalen... Dit moet uniform werken.
    if (extend==undefined){
        extend=movie;
    }

    var geom = "";
    if (extend.minx!=extend.maxx && extend.miny!=extend.maxy) {
        // polygon
        geom += "POLYGON((";
        geom += extend.minx +" "+ extend.miny +",";
        geom += extend.maxx +" "+ extend.miny +",";
        geom += extend.maxx +" "+ extend.maxy +",";
        geom += extend.minx +" "+ extend.maxy +",";
        geom += extend.minx +" "+ extend.miny;
        geom += "))";
    }else{
        // point
        geom += "POINT(";
        geom += extend.minx +" "+ extend.miny;
        geom += ")";
    }

    webMapController.getMap().getLayer("editMap").removeAllFeatures();

    /* kijken of bezig met editen redline objecten */
    if (editingRedlining) {
        hideIdentifyIcon();
        selectRedlineObject(geom);
        return;
    }

    if (btn_highLightSelected) {        
        /* TODO: Vervangen voor generiek iets. Dit is nu nodig omdat
         * de flamingo config een breinaald
         * Mogelijke fix: nieuw soort tool maken (de highlight tool). Deze voeg je in OL niet aan
         * de panel toe, maar wel aan de tools array. Deze tool roep de highlightfunctionaliteit in
         * de gisviewer aan.*/
        if (webMapController instanceof FlamingoController) {
            webMapController.activateTool("breinaald");
        } else {
            webMapController.activateTool("identify");
        }

        hideIdentifyIcon();
        highLightThemaObject(geom);
    } else {
        btn_highLightSelected = false;
        
        webMapController.activateTool("identify");

        showIdentifyIcon();
        handleGetAdminData(geom, null, false);
    }
    
    loadObjectInfo(geom);
}

var teller=0;
//update the getFeatureInfo in the feature window.
function updateGetFeatureInfo(data){
    
    /* TODO: Deze methode geeft geen GetFeatureInfo weer in Firefox.
     * Werkt wel in IE en Chrome
    */
    
    teller++;
	
    //if times out return;
    if (teller > featureInfoTimeOut){
        teller = 0;
        return;
    }
	
    //if the admindata window is loaded then update the page (add the featureinfo thats given by the getFeatureInfo request.
    if (usePopup && dataframepopupHandle.contentWindow.writeFeatureInfoData){
        dataframepopupHandle.contentWindow.writeFeatureInfoData(data);
        data=null;
    } else if (window.frames.dataframe.writeFeatureInfoData){
        window.frames.dataframe.writeFeatureInfoData(data);
        data=null;
    } else {
        //if the admindata window is not loaded yet then retry after 1sec
        setTimeout(function() {
            updateGetFeatureInfo(data)
        }, 1000);
    }
}

function onIdentifyData(id,data){
    teller=0;
    updateGetFeatureInfo(data);
}


function layerBoxSort(a, b) {
    return a.theItem.order - b.theItem.order;
}

var frameWorkInitialized = false;

function onFrameworkLoaded(){    
    if (document.getElementById("treeForm") && (ieVersion <= 8 && ieVersion != -1)){
        document.getElementById("treeForm").reset();
    }

    if (!frameWorkInitialized) {
        // layer added in reverse order
        // layer with lowest order number should be on top
        // so added last
        for (var i=clustersAan.length-1; i >=0 ; i--){
            clusterCheckboxClick(clustersAan[i], true);
        }
        // layers bij opstart sorteren op order(belangnr+alfabet)
        /* als order niet aangepast mag worden, dan kan dit weg */
        layersAan.sort(layerBoxSort)
        for (var m=layersAan.length-1; m >=0 ; m--){
            checkboxClick(layersAan[m],true);
        }

        setStartExtent();
        doRefreshLayer();
    }

    frameWorkInitialized = true;
    
    mapInitialized=true;
    webMapController.registerEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE,webMapController.getMap(), onAllLayersFinishedLoading);
    
    /* Tiling resoluties zetten zodat Flamingo navigatie de juiste zoomniveaus overneemt.
     * Let op: Bij OpenLayers gebeurt dit al bij maken Map */
    if (webMapController instanceof FlamingoController) {        
        var maxBounds = getMaxBounds();
        var olRes = getTilingResolutions(maxBounds, false);
        
        webMapController.getMap("map1").setTilingResolutions(olRes);
        
        /* Standaard pan tool activeren */
        webMapController.activateTool("toolPan");
    }
    
    doInitSearch();
    
    placeStartLocationMarker();
}

function placeStartLocationMarker() {    
    if (startLocationX != "" && startLocationY != "") {
        placeSearchResultMarker(startLocationX, startLocationY);
    }    
}

function initFullExtent() {
    /* Extent uit url */
    if (bbox!=null && bbox.length>0 && bbox.split(",").length==4) {        
        if (appExtent != null && appExtent.length > 0 && appExtent.split(",").length ==4 ) {
            setFullExtent(appExtent.split(",")[0],appExtent.split(",")[1],appExtent.split(",")[2],appExtent.split(",")[3]);
        } else {
            setFullExtent(bbox.split(",")[0],bbox.split(",")[1],bbox.split(",")[2],bbox.split(",")[3]);
        }
        
    /* Extent uit Flamingo */
    } else if (fullbbox!=null && fullbbox.length>0 && fullbbox.split(",").length==4) {
        setFullExtent(fullbbox.split(",")[0],fullbbox.split(",")[1],fullbbox.split(",")[2],fullbbox.split(",")[3]);        
    
    /* Als er geen van bovenstaande is ingesteld dan heel Nederland */
    } else {
        bbox = getNLExtent();
        fullbbox = getNLExtent();
        
        var bounds = getNLMaxBounds();        
        
        setFullExtent(bounds.left, bounds.bottom, bounds.right, bounds.top);
    }
}

function setStartExtent() {   
    initFullExtent();
    
    /* Bij zoeken via url de handleInitSearch callback laten zoomen */
    if (searchConfigId != null && searchConfigId > 0) {
        return;
    }
    
    /* Eerst kijken of er een zoekextent is */
    if (searchExtent != null) {
        webMapController.getMap("map1").moveToExtent(searchExtent);
        
    /* Extent uit url */
    } else if (bbox!=null && bbox.length>0 && bbox.split(",").length==4) {          
        setTimeout(function () {
            moveToExtent(bbox.split(",")[0],bbox.split(",")[1],bbox.split(",")[2],bbox.split(",")[3]);
        }, 1);
        
    /* Extent uit Flamingo */
    } else if (fullbbox!=null && fullbbox.length>0 && fullbbox.split(",").length==4) {        
        setTimeout(function () {
            moveToExtent(fullbbox.split(",")[0],fullbbox.split(",")[1],fullbbox.split(",")[2],fullbbox.split(",")[3]);
        }, 1);      
        
    } else if (resolution) {
        webMapController.getMap().zoomToResolution(resolution);    
    
    /* Als er geen van bovenstaande is ingesteld dan heel Nederland */
    } else {
        bbox = getNLExtent();
        fullbbox = getNLExtent();
        
        var bounds = getNLMaxBounds();
        
        setTimeout(function () {
            moveToExtent(bounds.left, bounds.bottom, bounds.right, bounds.top);
        }, 1);
    }
}

function ie6_hack_onInit(){
    if (navigator.appVersion.indexOf("MSIE") != -1) {
        version = parseFloat(navigator.appVersion.split("MSIE")[1]);
        
        if (version == 6) {
            setTimeout("doOnInit=true; onFrameworkLoaded();",5000);
        }
    }
}

function moveToExtent(minx,miny,maxx,maxy) { 
    webMapController.getMap().zoomToExtent({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    }, 0);
}

function setFullExtent(minx,miny,maxx,maxy) {  
    webMapController.getMap().setMaxExtent({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    });
}
function doIdentify(minx,miny,maxx,maxy){
    webMapController.getMap().doIdentify({
        minx:minx,
        miny:miny        
    });
    webMapController.activateTool("identify");
}
var nextIdentifyExtent=null;
function doIdentifyAfterUpdate(minx,miny,maxx,maxy){
    nextIdentifyExtent=new Object();
    nextIdentifyExtent.minx=minx;
    nextIdentifyExtent.miny=miny;
    nextIdentifyExtent.maxx=maxx;
    nextIdentifyExtent.maxy=maxy;
}

function moveAndIdentify(minx,miny,maxx,maxy) {    
    moveToExtent(minx,miny,maxx,maxy);
    var centerX=Number(Number(Number(minx)+Number(maxx))/2);
    var centerY=Number(Number(Number(miny)+Number(maxy))/2);
    //doIdentify(centerX,centerY,centerX,centerY);
    doIdentifyAfterUpdate(centerX,centerY,centerX,centerY);
}

function onAllLayersFinishedLoading(mapId){
    checkScaleForLayers();

    if(nextIdentifyExtent!=null){
        doIdentify(nextIdentifyExtent.minx,nextIdentifyExtent.miny,nextIdentifyExtent.maxx,nextIdentifyExtent.maxy);
        nextIdentifyExtent=null;
    }
    
    if (waitUntillFullyLoaded) {
        $j("#loadingscreen").hide();
    }
    
    /* Do again so that layers outside of scale dont show up in legend tab at startup */
    refreshLegendBox();
}

if(useSortableFunction) {
    document.getElementById("orderLayerBox").sortable({
        stop:function(){
            setTimerForReload();
        },
        start:function(){
            clearTimerForReload();
        }
    });
}
var reloadTimer;
function setTimerForReload() {
    reloadTimer = setTimeout("refreshMapVolgorde()", layerDelay);
}

function clearTimerForReload() {
    clearTimeout(reloadTimer);
}

/*Get de flash movie*/
function getMovie(movieName) {
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    }else {
        return document[movieName];
    }
}

/**
 *Functie zoekt een waarde op (val) van een thema met id themaId uit de thematree list die meegegeven is.
 **/
function searchThemaValue(themaList,themaId,val){
    for (var i in themaList){        
        if (i=="id" && themaList[i]==themaId){
            return themaList[val];
        }

        if (i=="children"){
            for (var ichild in themaList[i]){
                var returnValue=searchThemaValue(themaList[i][ichild],themaId,val);
                if (returnValue!=undefined && returnValue!=null){
                    return returnValue;
                }

            }
        }
    }

    return null;
}

/**
 * @param parentCandidate A parent candidate, maybe its the parent of the imte
 * @param item The item we want the parent of.
 */
function getParentItem(parentCandidate,item){
    if (parentCandidate.children){
        for (var i=0; i < parentCandidate.children.length;i++){
            if(parentCandidate.children[i]==item){
                return parentCandidate;
            }else if (parentCandidate.children[i].children){
                var theParent= getParentItem(parentCandidate.children[i],item);
                if (theParent!=null){
                    return theParent;
                }
            }
        }        
    }
    return null;
}

function getWMSLayersUrls() {
    var background;

    var bgLayers = new Array();
    var fgLayers = new Array();

    var urlString="";
    var firstURL = true;

    var layers = webMapController.getMap("map1").getAllWMSLayers();

    /* eerst layers verdelen in achtergrond en voorgrond */
    for (var i=0; i < layers.length; i++){
        if(layers[i].getURL() != null){
            background = layers[i].getOption("background");

            if (background) {
                bgLayers.push(layers[i]);
            } else {
                fgLayers.push(layers[i]);
            }
        }
    }

    /* eerst achtergrond url's toevoegen */
    for (var j=0; j < bgLayers.length; j++){
        if(bgLayers[j].getURL() != null){
            if(!firstURL){
                urlString+=";";
            }else{
                firstURL = false;
            }

            urlString+=bgLayers[j].getURL();
            if(bgLayers[j].getAlpha && bgLayers[j].getAlpha() != null){
                urlString+="#"+bgLayers[j].getAlpha();
            }
        }
    }

    /* dan voorgrond url's toevoegen */
    for (var k=0; k < fgLayers.length; k++){
        /* Niet in print als voorgrond niet binnen schaal valt. Anders ontstaan er
         * vreemde printvoorbeelden als je daarvoor al een keer een print hebt gemaakt
         * waarbij de voorgrond nog wel binnen schaal viel. Fix voor ticket #618 Limburg */
        var item = getItemFromWmsLayer(fgLayers[k]);        
        var currentscale = webMapController.getMap().getScaleHint();
        var inScale = isItemInScale(item, currentscale);
        
        /* Also add tem points url in print */
        var testUrl = fgLayers[k].getURL();  
        var isTempPointsLayer = false;
        if (testUrl.indexOf("tempPointsLayer") !== -1) {
            isTempPointsLayer = true;
        }  
        
        if(fgLayers[k].getURL() != null && inScale || isTempPointsLayer){
            if(!firstURL){
                urlString+=";";
            }else{
                firstURL = false;
            }

            urlString+=fgLayers[k].getURL();
            if(fgLayers[k].getAlpha && fgLayers[k].getAlpha() != null){
                urlString+="#"+fgLayers[k].getAlpha();
            }
        }
    }
    
    return urlString;
}

function getItemFromWmsLayer(layer) {
    var item;
    if (layer.options) {
        item = getItemByLayer(themaTree, layer.options.layers);
    } else {
        item = layer.getFrameworkLayer();
    }
    
    return item;
}

function getWktStringForPrint() {
    var vectorLayers=webMapController.getMap().getAllVectorLayers();
    var wktString="";

    for(var c = 0 ; c < vectorLayers.length ; c++){
        var vectorLayer = vectorLayers[c];
        var features = vectorLayer.getAllFeatures();
        for (var b=0; b < features.length; b++){
            wktString+=features[b].getWkt();
            wktString+="#ff0000";
            if (features[b].label) {
                wktString+="|"+features[b].label;
            }
            wktString+=";";
        }
    }

    return wktString;
}

function getLegendUrls() {
    var layerItems = new Array();
    var urlString = "";
    var firstURL = true;
    
    if (enabledLayerItems instanceof Array) {
        for (var i=0; i < enabledLayerItems.length; i++) {
            layerItems.push(enabledLayerItems[i]);    
        }
    }  
    
    for (var k=0; k < layerItems.length; k++) { 
        var layer = layerItems[k];
        
        if (layer.legendurl){
            if(!firstURL){
                urlString += ";";
            }else{
                firstURL = false;
            }

            urlString += layer.title + "#" + layer.legendurl;
        }
    }

    return urlString;
}

var exportMapWindow;
function exportMap(){    
    var submitForm = document.createElement("FORM");
    document.body.appendChild(submitForm);
    submitForm.method = "POST";

    var urlString = getWMSLayersUrls();

    var urlInput = document.createElement('input');
    urlInput.id = 'urls';
    urlInput.name = 'urls';
    urlInput.type = 'hidden';
    urlInput.value = urlString;
    submitForm.appendChild(urlInput);

    /* Legend urls */
    var legendUrlsString = getLegendUrls();

    var legendUrlInput = document.createElement('input');
    legendUrlInput.id = 'legendUrls';
    legendUrlInput.name = 'legendUrls';
    legendUrlInput.type = 'hidden';
    legendUrlInput.value = legendUrlsString;
    submitForm.appendChild(legendUrlInput);
    
    var wktString = getWktStringForPrint();

    var wktInput = document.createElement('input');
    wktInput.id = 'wkts';
    wktInput.name = 'wkts';
    wktInput.type = 'hidden';
    wktInput.value = wktString;
    submitForm.appendChild(wktInput);
    
    /* Tiling spullen meegeven voor CombineImageSettings */
    var tilingString = getTilingLayer();
    
    var tilingInput = document.createElement('input');
    tilingInput.id = 'tilings';
    tilingInput.name = 'tilings';
    tilingInput.type = 'hidden';
    tilingInput.value = tilingString;
    submitForm.appendChild(tilingInput);
    
    /* TODO: Width en height meegeven voor tiling berekeningen als er geen gewone
     * wms url in de print zit waar dit uit gehaald kan worden */
    
    var mapWidth = webMapController.getMap("map1").getScreenWidth();
    var mapHeight = webMapController.getMap("map1").getScreenHeight();
    
    var minX = webMapController.getMap("map1").getExtent().minx;
    var minY = webMapController.getMap("map1").getExtent().miny;
    var maxX = webMapController.getMap("map1").getExtent().maxx;
    var maxY = webMapController.getMap("map1").getExtent().maxy;
    
    var mapBbox = minX + "," + minY + "," + maxX + "," + maxY;
    
    var mapSizeInput = document.createElement('input');
    mapSizeInput.id = 'mapsizes';
    mapSizeInput.name = 'mapsizes';
    mapSizeInput.type = 'hidden';
    mapSizeInput.value = mapWidth + ";" + mapHeight + ";" + mapBbox;
    submitForm.appendChild(mapSizeInput);

    submitForm.target="exportMapWindowNaam";
    submitForm.action= "printmap.do";
    submitForm.submit();

    if(exportMapWindow==undefined || exportMapWindow==null || exportMapWindow.closed){
        exportMapWindow = window.open("", "exportMapWindowNaam");
        exportMapWindow.focus();
    }
}

function getTilingLayer() {
    var tilingString = "";
    var firstURL = true;

    var layers = webMapController.getMap("map1").getAllTilingLayers();

    /* tiling layers toevoegen */
    for (var j=0; j < layers.length; j++) {
        var currentscale = webMapController.getMap().getScaleHint();
        
        var item;
        if (layers[j].options) {
            item = getItemByLayer(themaTree,layers[j].options.LAYERS);
        } else {
            item = layers[j].getFrameworkLayer();
        }
    
        var inScale = isItemInScale(item, currentscale);
        
        if (!inScale) {
            continue;
        }
        
        var bbox = layers[j].getOption("BBOX");
        var resolutions = layers[j].getOption("RESOLUTIONS");
        var tileWidth = layers[j].getOption("TILEWIDTH");
        var tileHeight = layers[j].getOption("TILEHEIGHT");
        
        /* parameters aan service url plakken om in back-end nieuwe url 
         * te kunnen opbouwen. alleen als ze er nog niet instaan. */
        var url = buildTilingServiceUrl(layers[j]);
        
        tilingString += bbox + ";"+ resolutions + ";" + tileWidth + ";" + tileHeight + ";" + url;
    }

    return tilingString;
}

function checkParam(url, name) {
    name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
    
    var regexS = "[\\?&]"+name+"=([^&#]*)";
    var regex = new RegExp(regexS);
    
    var results = regex.exec(url);
    if (results == null) {
        return false;  
    }        
    
    return true;  
}

function buildTilingServiceUrl(tilingLayer) {    
    var serviceUrl = tilingLayer.getOption("url");
    
    if (!checkParam(serviceUrl, "service") && !checkParam(serviceUrl, "SERVICE")) {
        serviceUrl += "&SERVICE=" + tilingLayer.getOption("SERVICE");
    }    
    if (!checkParam(serviceUrl, "version") && !checkParam(serviceUrl, "VERSION")) {
        serviceUrl += "&VERSION=" + tilingLayer.getOption("VERSION");
    }
    if (!checkParam(serviceUrl, "layer") && !checkParam(serviceUrl, "LAYER")) {
        serviceUrl += "&LAYERS=" + tilingLayer.getOption("LAYERS");
    }
    if (!checkParam(serviceUrl, "styles") && !checkParam(serviceUrl, "STYLES")) {
        serviceUrl += "&STYLES=" + tilingLayer.getOption("STYLES");
    }
    if (!checkParam(serviceUrl, "format") && !checkParam(serviceUrl, "FORMAT")) {
        serviceUrl += "&FORMAT=" + tilingLayer.getOption("FORMAT");
    }
    if (!checkParam(serviceUrl, "srs") && !checkParam(serviceUrl, "SRS")) {
        serviceUrl += "&SRS=" + tilingLayer.getOption("SRS");
    }
    if (!checkParam(serviceUrl, "request") && !checkParam(serviceUrl, "REQUEST")) {
        serviceUrl += "&REQUEST=" + tilingLayer.getOption("REQUEST");
    }
        
    return serviceUrl;        
}

function checkboxClickById(id){
    var el2=document.getElementById(id);
    if (el2) {
        el2.checked=!el2.checked;
        checkboxClick(el2,false);
    }
}

function checkboxOnByid(id){
    var el=document.getElementById(id);
    if (el) {
        el.checked=true;
        checkboxClick(el,false);
    }
}

function getWktActiveFeature() {
    var object = webMapController.getMap().getLayer("editMap").getActiveFeature();

    if (object == null)
    {
        handler("Er is nog geen tekenobject op het scherm.");
        return null;
    }

    return object.getWkt();
}

function getWktForDownload() {
    var object = webMapController.getMap().getLayer("editMap").getActiveFeature();

    if (object == null) {
        return "";
    }

    return object.getWkt();
}

function getWkt() {
    var object = webMapController.getMap().getLayer("editMap").getActiveFeature();

    if (object == null)
        return null;

    return object.wktgeom;
}

function b_getfeatures(id,event) {
    var wkt = getWktActiveFeature();

    if (wkt) {
        handleGetAdminData(wkt, null, true);
    }
}
/* Buffer functies voor aanroep back-end en tekenen buffer op het scherm */
function b_buffer(id, event) {    
    var wkt;

    /* Indien door highlight de global var is gevuld deze
     * dan gebruiken bij buffer als deze niet null is
     * De getWktActiveFeature geeft bij sommige multipolygons niet
     * een correcte wkt terug. er mist dan een , ( of ) waardoor bufferen
     * mis gaat. Deze is dus alleen gevuld na een highlight
     * voor anders getekende polygons wordt gewoon de active feature gebruikt. */
    if (multiPolygonBufferWkt != null)
        wkt = multiPolygonBufferWkt;
    else
        wkt = getWktActiveFeature();

    multiPolygonBufferWkt = null;
        
    if (wkt==null)
    {
        return;
    }

    var str = prompt('Geef de bufferafstand in meters', '100');
    var afstand = 0;

    if((str == '') || ( str == 'undefined') || ( str == null))
        return;

    if( !isNaN( str) ) {
        str = str.replace( ",", ".");
        afstand = str;
    } else {
        handler( "Geen getal" );
        return;
    }

    if (afstand == 0)
    {
        handler("Buffer mag niet 0 zijn");
        return;
    }

    EditUtil.buffer(wkt, afstand, returnBuffer);
}

function b_print(id, event) {    
    exportMap();
}

function b_layerSelection(id, event) {    
    iFramePopup('kaartselectie.do', false, 'Kaartselectie', 800, 600, true, true);
}

function b_overview(id,event) {
    if (webMapController instanceof FlamingoController) {
        webMapController.getMap().getFrameworkMap().callMethod('overviewwindow','show');
    }
}

function b_gps_stop(id, event) {
    removeSearchResultMarker();
}

function drawFeature(ggbId, attrName, attrVal) {

    JMapData.getWkt(ggbId, attrName, attrVal, drawWkt);
}

function returnBuffer(wkt) {
    drawWkt(wkt);
}

function drawWkt(wkt) {
    if (wkt.length > 0)
    {
        var polyObject = new Feature(61502,wkt);

        drawObject(polyObject);
    }
}

function drawObject(feature) {
    webMapController.getMap().getLayer("editMap").removeAllFeatures();
    webMapController.getMap().getLayer("editMap").addFeature(feature);
}

/**
 * Alle ge�mplementeerde eventhandling functies
 */
function b_removePolygons(id,params){
    webMapController.getMap().getLayer("editMap").removeAllFeatures();
    
    if (webMapController instanceof OpenLayersController) {
        var measureValueDiv=document.getElementById("olControlMeasurePolygonValue");
        if (measureValueDiv){                
            measureValueDiv.style.display="none";
        }
    }
}

/* er is net op de highlight knop gedrukt */
function b_highlight( id,params) {
    btn_highLightSelected = true;

    /* TODO: Vervangen voor generiek iets. Dit is nu nodig omdat
     * de flamingo config een breinaald
     * Mogelijke fix: nieuw soort tool maken (de highlight tool). Deze voeg je in OL niet aan
     * de panel toe, maar wel aan de tools array. Deze tool roep de highlightfunctionaliteit in
     * de gisviewer aan.*/
    if (webMapController instanceof FlamingoController) {
        webMapController.activateTool("breinaald");
    } else {
        webMapController.activateTool("identify");
    }
}

var btn_highLightSelected = false;

var popupWindowRef = null;
var highLightGeom = null;

var analyseThemas = new Array();

function highLightThemaObject(geom) {    
    highlightLayers = new Array();

    /* geom bewaren voor callbaack van popup */
    highLightGeom = geom;

    /* indien meerdere analyse themas dan popup voor keuze */
    for (var i=0; i < enabledLayerItems.length; i++) {
        var item = enabledLayerItems[i];

        var object = document.getElementById(item.id);

        /* alleen uitvoern als configuratie optie hiervan op true staat */
        if (useInheritCheckbox) {
            /* Item alleen toevoegen aan de layers indien
             * parent cluster(s) allemaal aangevinkt staan of
             * geen cluster heeft */
            if (!itemHasAllParentsEnabled(object))
                continue;
        }

        if (item.highlight == 'on') {
            highlightLayers.push(item);
        }
    }

    if (highlightLayers.length > 1) {
        // popupWindowRef = popUp('viewerhighlight.do', 'popupHighlight', 680, 225, true);
        iFramePopup('viewerhighlight.do', false, 'Kaartlaag selectie', 400, 300, true, false);
    }

    var scale = webMapController.getMap().getResolution();
    var tol = tolerance;

    if (highlightLayers.length == 1) {
        EditUtil.getHighlightWktForThema(highlightLayers[0].id, geom, scale, tol, returnHighlight);
    }
}

function selectRedlineObject(geom) {
    /* Params
     * geom: Klikpunt op de kaart. Een POINT wkt string.
     * redLineGegevensbronId: geconfigureerde gegevensbronId voor redlining
    */
    var scale = webMapController.getMap().getResolution();
    var tol = tolerance;

    EditUtil.getIdAndWktForRedliningObject(geom, redLineGegevensbronId, scale, tol, returnRedlineObject);
}

function returnRedlineObject(jsonString) {
    if (jsonString == "-1") {
        messagePopup("Redlining bewerken", "Geen object gevonden.", "error");

        return;
    }

    var redlineObj = eval('(' + jsonString + ')');
    var wkt = redlineObj.wkt;

    if (wkt.length > 0 && wkt != "-1")
    {
        var polyObject = new Feature(61502,wkt);
        drawObject(polyObject);
    }

    var id = redlineObj.id;
    var projectnaam = redlineObj.projectnaam;
    var ontwerp = redlineObj.ontwerp;
    var opmerking = redlineObj.opmerking;

    /* formulier op redline tabblad aanpassen */
    var iframe = document.getElementById('redliningframeViewer');
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;

    innerDoc.getElementById("redliningID").value = id;
    innerDoc.getElementById("projectnaam").value = projectnaam;
    innerDoc.getElementById("new_projectnaam").value = '';
    innerDoc.getElementById("ontwerp").value = ontwerp;

    if (opmerking != null && opmerking != "undefined") {
        innerDoc.getElementById("opmerking").value = opmerking;
    } else {
        innerDoc.getElementById("opmerking").value = "";
    }

    editingRedlining = false;
}

function handlePopupValue(value) {    
    //    $j("#popupWindow").hide();
    
    analyseThemas = new Array();

    var object = document.getElementById(value);
    setActiveThema(value, object.theItem.title, true);

    /*
     * TODO
     * uitzoeken of thema onzichtbaar is en dan bovenliggend cluster gebruiken.
     * setActiveCluster(item, true);
     */

    var scale = webMapController.getMap().getResolution();
    var tol = tolerance;
    EditUtil.getHighlightWktForThema(value, highLightGeom, scale, tol, returnHighlight);
//handleGetAdminData(highLightGeom, value);
}

/* backend heeft wkt teruggegeven */
function returnHighlight(wkt) {
    /* Fout in back-end of wkt is een POINT */
    if (wkt.length > 0 && wkt == "-1") {
        messagePopup("", "Geen object gevonden.", "information");
    }

    if (wkt.length > 0 && wkt != "-1")
    {        
        var polyObject = new Feature(61502,wkt);
        drawObject(polyObject);

        /* verkregen back-end polygon voor highlight even in global var opslaan
         * deze dan gebruiken bij buffer als deze niet null is
         * De getWktActiveFeature geeft bij sommige multipolygons niet
         * een correcte wkt terug. er mist dan een , ( of ) waardoor bufferen
         * mis gaat */
        multiPolygonBufferWkt = wkt;
    }
}

function checkDisplayButtons() {
    if (showRedliningTools) {
        if (webMapController.getTool("redLiningContainer")){
            webMapController.getTool("redLiningContainer").setVisible(true);
        }else{
            webMapController.getTool("redLiningContainer_point").setVisible(true);
            webMapController.getTool("redLiningContainer_line").setVisible(true);
            webMapController.getTool("redLiningContainer_polygon").setVisible(true);
        }
    } else {
        if (webMapController.getTool("redLiningContainer")){
            webMapController.getTool("redLiningContainer").setVisible(false);
        }else{
            webMapController.getTool("redLiningContainer_point").setVisible(false);
            webMapController.getTool("redLiningContainer_line").setVisible(false);
            webMapController.getTool("redLiningContainer_polygon").setVisible(false);
        }
    }

    if (showBufferTool) {
        webMapController.getTool("b_buffer").setVisible(true);
    } else {
        webMapController.getTool("b_buffer").setVisible(false);
    }
        
    if (showSelectBulkTool) {
        webMapController.getTool("b_getfeatures").setVisible(true);
    } else {
        webMapController.getTool("b_getfeatures").setVisible(false);
    }

    if (showNeedleTool) {
        webMapController.getTool("b_highlight").setVisible(true);
    } else {
        webMapController.getTool("b_highlight").setVisible(false);
    }

    if (showRedliningTools || showNeedleTool) {
        webMapController.getTool("b_removePolygons").setVisible(true);
    } else {
        webMapController.getTool("b_removePolygons").setVisible(false);
    }

    if (showPrintTool) {
        webMapController.getTool("b_printMap").setVisible(true);
    } else {
        webMapController.getTool("b_printMap").setVisible(false);
    }

    if (showLayerSelectionTool) {
        webMapController.getTool("b_layerSelection").setVisible(true);
    } else {
        webMapController.getTool("b_layerSelection").setVisible(false);
    }
    
    if (showGPSTool) {
        webMapController.getTool("b_gps").setVisible(true);
    } else {
        webMapController.getTool("b_gps").setVisible(false);
    }
}

function onGetCapabilities(id,params){    
    hideLoading();
}

//do only ones.
var initialized = false;
function onConfigComplete(id,params){    
    if (!initialized) {
        initialized = true;
    
        initializeButtons();
        checkDisplayButtons();

        // TODO: gaat dit goed? Dit word nu aangeroepen met document.ready(),
        // nu niet meer met flamingoevent
        onFrameworkLoaded();
    }
}

function getBookMark() {    
    /* url base */
    var url=createPermaLink();
    addToFavorites(url);
}

function getFullExtent() {
    var fullExtent = webMapController.getMap().getExtent();

    return fullExtent;
}

function getCenterWkt() {
    var fullExtent = getFullExtent();

    var minx = Math.round(Number(fullExtent.minx)+1);
    var miny = Math.round(Number(fullExtent.miny)+1);
    var maxx = Math.round(Number(fullExtent.maxx)-1);
    var maxy = Math.round(Number(fullExtent.maxy)-1);

    var x = (minx + maxx) / 2;
    var y = (miny + maxy) / 2;

    return "POINT(" + x + " " + y + ");";
}

function getMinWkt() {
    var fullExtent = getFullExtent();

    var minx = Math.round(Number(fullExtent.minx)+1);
    var miny = Math.round(Number(fullExtent.miny)+1);

    return "POINT(" + minx + " " + miny + ");";
}

function getMaxWkt() {
    var fullExtent = getFullExtent();

    var maxx = Math.round(Number(fullExtent.maxx)-1);
    var maxy = Math.round(Number(fullExtent.maxy)-1);

    return "POINT(" + maxx + " " + maxy + ");";
}

/* Berekenen lattitude en longitude waardes voor gebruik in Google
 * maps aanroep */
function getLatLonForGoogleMaps() {
    var centerWkt = getCenterWkt();
    var minWkt = getMinWkt();
    var maxWkt = getMaxWkt();

    JMapData.getLatLonForRDPoint(centerWkt, minWkt, maxWkt, openGoogleMaps);
}

/* Zie: http://mapki.com/wiki/Google_Map_Parameters */
function openGoogleMaps(values) {
    var ll = "&ll=" + values[0] + "," + values[1];
    var spn = "&spn=" + values[2] + "," + values[3];
    
    var options = "&hl=nl&om=0";

    var url = "http://www.google.nl/maps?ie=UTF8" + ll + spn + options;

    window.open(url);
}

function createPermaLink(){
    var protocol = window.location.protocol + "//";
    var host = window.location.host;

    var urlBase = protocol + host  + baseNameViewer + "/viewer.do?";

    /* applicatie code */
    var appCode = "";
    if (bookmarkAppcode != undefined && bookmarkAppcode != "") {
        appCode = "appCode=" + bookmarkAppcode;
    }

    /* kaartlagen ophalen */
    var id = "";
    var layerIds = getLayerIdsAsString();
    if (layerIds != undefined && layerIds != "") {
        id = "&id=" + layerIds;
    }

    /* kaartgroepen ophalen */
    var clusterIds = "";
    if (clustersAan != undefined && clustersAan.length > 0){
        clusterIds += "&clusterId=";

        for (var i=0; i < clustersAan.length; i++){
            if (clusterIds.length > 0){
                clusterIds+=",";
            }
            clusterIds+=clustersAan[i].theItem.id.substring(1);
        }
    }

    /* kaart extent ophalen */
    var extent = "";
    var fullExtent = webMapController.getMap().getExtent();
    if (fullExtent != undefined && fullExtent != "") {
        var minx = Math.round(Number(fullExtent.minx)+1);
        var miny = Math.round(Number(fullExtent.miny)+1);
        var maxx = Math.round(Number(fullExtent.maxx)-1);
        var maxy = Math.round(Number(fullExtent.maxy)-1);

        extent = "&extent="+minx+","+miny+","+maxx+","+maxy;
    }

    /* kaart resolutie ophalen */
    var reso = "";
    var controllerRes = webMapController.getMap().getResolution();
    if (controllerRes != undefined && controllerRes != "") {
        reso = "&resolution=" + controllerRes;
    }

    var url = urlBase + appCode + id + clusterIds + extent;
    ; // + reso;

    return url;
}

function addToFavorites(url) {
    
    var title = "B3P Gisviewer bookmark"

    if (window.sidebar) { // Firefox
        window.sidebar.addPanel(title, url,"");
    } else if( window.external ) { // IE 6,7 not 8?
        /* Moet gekoppeld zijn aan userevent of iets met runat server ? */
        window.external.AddFavorite(url, title);       
    }else if(window.opera && window.print) { // Opera 
        return true;
    }

    return null;
}

/* build popup functions */
var currentpopupleft = null;
var currentpopuptop = null;

popUp = function(URL, naam, width, height, useDiv) {

    var screenwidth = 600;
    var screenheight = 500;
    var useDivPopup = false;

    if (width){
        screenwidth=width;
    }

    if (height){
        screenheight=height;
    }

    if(useDiv) {
        useDivPopup = useDiv;
    }

    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;

    if(currentpopupleft != null) {
        popupleft = currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;

    if(currentpopuptop != null) {
        currentpopuptop = popuptop
    }

    if(useDivPopup) {
        if (!popupCreated)
            initPopup();

        document.getElementById("dataframedivpopup").src = URL;
        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';

        $j("#popupWindow").width(width);
        $j("#popupWindow").height(height);

        $j("#popupWindow").show();

        if(ieVersion <= 6 && ieVersion != -1)
            fixPopup();

    } else {

        properties = "toolbar = 0, " +
        "scrollbars = 1, " +
        "location = 0, " +
        "statusbar = 1, " +
        "menubar = 0, " +
        "resizable = 1, " +
        "width = " + screenwidth + ", " +
        "height = " + screenheight + ", " +
        "top = " + popuptop + ", " +
        "left = " + popupleft;

        return eval("page" + naam + " = window.open('" + URL + "', '" + naam + "', properties);");
    }

    return null;
}

popUpData = function(naam, width, height, useDiv) {
    var screenwidth = 600;
    var screenheight = 500;
    var useDivPopup = false;

    if (width){
        screenwidth=width;
    }
    if (height){
        screenheight=height;
    }

    if(useDiv) {
        useDivPopup = useDiv;
    }

    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;

    if(currentpopupleft != null) {
        popupleft = currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;

    if(currentpopuptop != null) {
        currentpopuptop = popuptop
    }

    if(useDivPopup) {
        if (!popupCreated)
            initPopup();

        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';
        $j("#popupWindow").show();

        if(ieVersion <= 6 && ieVersion != -1)
            fixPopup();

        return document.getElementById("dataframedivpopup");

    } else {

        properties = "toolbar = 0, " +
        "scrollbars = 1, " +
        "location = 0, " +
        "statusbar = 1, " +
        "menubar = 0, " +
        "resizable = 1, " +
        "width = " + screenwidth + ", " +
        "height = " + screenheight + ", " +
        "top = " + popuptop + ", " +
        "left = " + popupleft;

        return window.open('admindatabusy.do', naam, properties);
    }
}

buildPopup = function() {
    var popupDiv = document.createElement('div');
    popupDiv.styleClass = 'popup_Window';
    popupDiv.id = 'popupWindow';
    var popupHandle = document.createElement('div');
    popupHandle.styleClass = 'popup_Handle';
    popupHandle.id = 'popupWindow_Handle';
    var popupTitle = document.createElement('div');
    popupTitle.className = 'popup_Title';
    popupTitle.id = 'popupWindow_Title';
    var popupClose = document.createElement('a');
    popupClose.className = 'popup_Close';
    popupClose.id = 'popupWindow_Close';
    popupClose.href = '#';
    popupClose.innerHTML = '[ x ]';
    popupHandle.appendChild(popupTitle);
    popupHandle.appendChild(popupClose);
    popupDiv.appendChild(popupHandle);
    var popupContent = document.createElement('div');
    popupContent.styleClass = 'popup_Content';
    popupContent.id = 'popupWindow_Content';
    var popupIframe = null;
    if(ieVersion <= 7 && ieVersion != -1) {
        popupIframe = document.createElement('<iframe name="dataframedivpopup">');
    } else {
        popupIframe = document.createElement('iframe');
        popupIframe.name = 'dataframedivpopup';
    }
    popupIframe.styleClass = 'popup_Iframe';
    popupIframe.id = 'dataframedivpopup';
    popupIframe.src = 'admindatabusy.do';
    var popupResizediv = document.createElement('div');
    popupResizediv.id = 'popupWindow_Resizediv';
    popupContent.appendChild(popupIframe);
    popupContent.appendChild(popupResizediv);
    popupDiv.appendChild(popupContent);

    var popupWindowBackground = document.createElement('div');
    popupWindowBackground.styleClass = 'popupWindow_Windowbackground';
    popupWindowBackground.id = 'popupWindow_Windowbackground';

    $j(popupDiv).css({
        "height": popupHeight,
        "width": popupWidth,
        "left": popupLeft,
        "top": popupTop,
        "display": "none"
    });

    document.body.appendChild(popupDiv);
    document.body.appendChild(popupWindowBackground);
}

/**
 * @param mapDiv The div element where the map is in.
 * @param webMapController the webMapController that controlles the map
 * @param balloonId the id of the DOM element that represents the balloon.
 * @param balloonWidth the width of the balloon (optional, default: 300);
 * @param balloonHeight the height of the balloon (optional, default: 300);
 * @param offsetX the offset x
 * @param offsetY the offset y
 * @param balloonCornerSize the size of the rounded balloon corners of the round.png image(optional, default: 20);
 * @param balloonArrowHeight the hight of the arrowImage (optional, default: 40);
 */
function Balloon(mapDiv,webMapController,balloonId, balloonWidth, balloonHeight, offsetX,offsetY, balloonCornerSize, balloonArrowHeight){
    this.mapDiv=mapDiv;
    this.webMapController=webMapController;
    this.balloonId=balloonId;
    this.balloonWidth=300;
    this.balloonHeight=300;
    this.balloonCornerSize=20;
    this.balloonArrowHeight=40;
    this.offsetX=0;
    this.offsetY=0;
    //this.leftOfPoint;
    //this.topOfPoint;
    
    //the balloon jquery dom element.
    //this.balloon;
    //this.xCoord;
    //this.yCoord;

    if (balloonWidth){
        this.balloonWidth=balloonWidth;
    }
    if (balloonHeight)
        this.balloonHeight=balloonHeight;
    if (balloonCornerSize){
        this.balloonCornerSize=balloonCornerSize;
    }
    if (balloonArrowHeight){
        this.balloonArrowHeight=balloonArrowHeight;
    }
    if (offsetX){
        this.offsetX=offsetX;
    }
    if (offsetY){
        this.offsetY=offsetY;
    }
    /**
     *Private function. Don't use.
     */
    this._createBalloon = function(x,y){
        //create balloon and styling.
        this.balloon=$j("<div class='infoBalloon' id='"+this.balloonId+"'></div>");
        this.balloon.css('position', 'absolute');
        this.balloon.css('width',""+this.balloonWidth+"px");
        this.balloon.css('height',""+this.balloonHeight+"px");
        this.balloon.css('z-index','13000');

        var maxCornerSize=this.balloonHeight-(this.balloonArrowHeight*2)+2-this.balloonCornerSize;
        this.balloon.append($j("<div class='balloonCornerTopLeft'><img style='position: absolute;' src='images/infoBalloon/round.png'/></div>")
            .css('width',this.balloonCornerSize+'px')
            .css('height',this.balloonCornerSize+'px')
            .css('left', '0px')
            .css('top', this.balloonArrowHeight-1+'px')
            .css('width', this.balloonWidth-this.balloonCornerSize+'px')
            .css('height',maxCornerSize+'px')
            );
        this.balloon.append($j("<div class='balloonCornerTopRight'><img style='position: absolute; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
            .css('width',this.balloonCornerSize+'px')
            .css('height',maxCornerSize+'px')
            .css('top', this.balloonArrowHeight-1+'px')
            .css('right','0px')
            );
        this.balloon.append($j("<div class='balloonCornerBottomLeft'><img style='position: absolute; top: -748px;' src='images/infoBalloon/round.png'/></div>")
            .css('height',this.balloonCornerSize+'px')
            .css('left', '0px')
            .css('bottom',this.balloonArrowHeight-1+'px')
            .css('width', this.balloonWidth-this.balloonCornerSize)
            );
        this.balloon.append($j("<div class='balloonCornerBottomRight'><img style='position: absolute; top: -748px; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
            .css('width',this.balloonCornerSize+'px')
            .css('height',this.balloonCornerSize+'px')
            .css('right','0px')
            .css('bottom',this.balloonArrowHeight-1+'px')

            );
        //arrows
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        //content
        this.balloon.append($j("<div class='balloonContent'></div>")
            .css('top',this.balloonArrowHeight+20+'px')
            .css('bottom',this.balloonArrowHeight+4+'px')
            );
        //closing button
        var thisObj=this;
        this.balloon.append($j("<div class='balloonCloseButton'></div>")
            .css('right','7px')
            .css('top',''+(this.balloonArrowHeight+3)+'px')
            .click(function(){
                thisObj.remove();
                return false;
            })

            );
        this.xCoord=x;
        this.yCoord=y;

        //calculate position
        this._resetPositionOfBalloon(x,y);
        
        //append the balloon.
        $j(this.mapDiv).append(this.balloon);

        this.webMapController.registerEvent(Event.ON_FINISHED_CHANGE_EXTENT,webMapController.getMap(), this.setPosition,this);
    }

    /**
     *Private function. Use setPosition(x,y,true) to reset the position
     *Reset the position to the point. And displays the right Arrow to the point
     *Sets the this.leftOfPoint and this.topOfPoint
     *@param x the x coord
     *@param y the y coord
     */
    this._resetPositionOfBalloon = function(x,y){
        //calculate position
        var centerCoord= this.webMapController.getMap().getCenter();
        var centerPixel= this.webMapController.getMap().coordinateToPixel(centerCoord.x,centerCoord.y);
        var infoPixel= this.webMapController.getMap().coordinateToPixel(x,y);

        //determine the left and top.
        if (infoPixel.x > centerPixel.x){
            this.leftOfPoint=true;
        }else{
            this.leftOfPoint=false;
        }
        if (infoPixel.y > centerPixel.y){
            this.topOfPoint=true;
        }else{
            this.topOfPoint=false;
        }
        //display the right arrow
        this.balloon.find(".balloonArrow").css('display','none');
        //$j("#infoBalloon > .balloonArrow").css('display', 'block');
        if (!this.leftOfPoint && !this.topOfPoint){
            //popup is bottom right of the point
            this.balloon.find(".balloonArrowTopLeft").css("display","block");
        }else if (this.leftOfPoint && !this.topOfPoint){
            //popup is bottom left of the point
            this.balloon.find(".balloonArrowTopRight").css("display","block");
        }else if (this.leftOfPoint && this.topOfPoint){
            //popup is top left of the point
            this.balloon.find(".balloonArrowBottomRight").css("display","block");
        }else{
            //pop up is top right of the point
            this.balloon.find(".balloonArrowBottomLeft").css("display","block");
        }
    }

    /**
     *Set the position of this balloon. Create it if not exists
     *@param x xcoord
     *@param y ycoord
     *@param resetPositionOfBalloon boolean if true the balloon arrow will be
     *redrawn (this.resetPositionOfBalloon is called)
     */
    this.setPosition = function (x,y,resetPositionOfBalloon){
        if (this.balloon==undefined){
            this._createBalloon(x,y);
        }else if(resetPositionOfBalloon){
            this._resetPositionOfBalloon(x,y);
        }
        if (x!=undefined && y != undefined){
            this.xCoord=x;
            this.yCoord=y;
        }else if (this.xCoord ==undefined || this.yCoord == undefined){
            throw "No coords found for this balloon";
        }else{
            x=this.xCoord;
            y=this.yCoord;
        }
        //if the point is out of the extent hide balloon
        var curExt=this.webMapController.getMap().getExtent();
        if (curExt.minx > x ||
            curExt.maxx < x ||
            curExt.miny > y ||
            curExt.maxy < y){
            /*TODO wat doen als hij er buiten valt.*/
            this.balloon.css('display','none');
            return;
        }else{
            /*TODO wat doen als hij er weer binnen valt*/
            this.balloon.css('display','block');
        }

        //calculate position
        var infoPixel= this.webMapController.getMap().coordinateToPixel(x,y);

        //determine the left and top.
        var left=infoPixel.x+this.offsetX;
        var top =infoPixel.y+this.offsetY;
        if (this.leftOfPoint){
            left=left-this.balloonWidth;
        }
        if (this.topOfPoint){
            top= top-this.balloonHeight;
        }
        //set position of balloon
        this.balloon.css('left', ""+left+"px");
        this.balloon.css('top', ""+top+"px");
    }
    /*Remove the balloon*/
    this.remove = function(){
        this.balloon.remove();
        this.webMapController.unRegisterEvent(Event.ON_FINISHED_CHANGE_EXTENT,webMapController.getMap(), this.setPosition,this);
        delete this.balloon;
    }
    /*Get the DOM element where the content can be placed.*/
    this.getContentElement = function(){
        return this.balloon.find('.balloonContent');
    }
    this.hide = function(){
        this.balloon.css("display",'none');
    }
    this.show = function(){
        this.balloon.css("display",'block');
    }
}

// Aanroepen voor een loading screen in de tabs.
function showTabvakLoading(message) {
    $j("#tab_container").append('<div class="tabvakloading"><div>'+message+'<br /><br /><img src="/gisviewer/images/icons/loadingsmall.gif" alt="Bezig met laden..." /></div></div>');
    $j("#tab_container").find(".tabvakloading").fadeTo(0, 0.8);
}

function hideTabvakLoading() {
    $j("#tab_container").find(".tabvakloading").remove();
}

var editingRedlining = false;
var redLineGegevensbronId = -1;

function enableEditRedlining(id) {
    editingRedlining = true;
    redLineGegevensbronId = id;

    webMapController.activateTool("breinaald");
}

function createServiceLeaf(container, item) {
    /* root item. alleen groepname tonen en geen vinkjes */
    if (item.id == 0) {
        container.appendChild(createServiceLayerLink(item));
        return;
    }

    var checkBox;
    if (item.default_on) {
        checkBox = createCheckboxUserLayer(item, true);
        container.appendChild(checkBox);
    } else {
        container.appendChild(createCheckboxUserLayer(item, false));
    }

    container.appendChild(document.createTextNode(' '));
    container.appendChild(createServiceLayerLink(item));

    if (item.default_on) {
        checkboxUserLayerClick(checkBox);
    }
}

function createCheckboxUserLayer(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="userLayers" type="checkbox" id="ul_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="checkboxUserLayerClick(this)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'ul_' +item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'userLayers'
        checkbox.value = item.id;

        checkbox.onclick = function() {
            checkboxUserLayerClick(this);
        }

        if (checked) {
            checkbox.checked = true;
        }
    }

    /* json item toevoegen aan element zodat later makkelijk
     * gebruikt kan worden */
    checkbox.theItem = item;

    return checkbox;
}

function checkboxUserLayerClick(checkbox) {
    var item = checkbox.theItem;
    var checked = checkbox.checked;

    /* laagnaam aan wmslayers toevoegen */
    var wmslayers = new Array();
    wmslayers[0] = item.name;
    item.wmslayers = wmslayers;

    /* laagnaam aan wmsquerylayers toevoegen */
    if (item.queryable) {
        var wmsquerylayers = new Array();
        wmsquerylayers[0] = item.name;

        item.wmsquerylayers = wmsquerylayers;
    }

    /* item als laag klaarzetten */
    var layers = new Array();
    layers[0] = item;

    /* laag toevoegen aan viewer */
    if (checked) {
        addItemAsLayer(item);        
    } else {
        removeItemAsLayer(item);
    }

    if (checked) {
        refreshLayerWithDelay();
    } else{
        doRefreshLayer();
    }
}

function createServiceLayerLink(item){
    var lnk = document.createElement('a');
    lnk.innerHTML = item.title ? item.title : item.id;
    lnk.href = '#';

    if (item.service_url != undefined) {
        lnk.onclick = function() {
            $j("#dialog-download-metadata").dialog("option", "buttons", {
                "Url": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {                        
                        $j(this).dialog("close");  
        
                        var url = item.service_url + "service=WMS&request=GetCapabilities&version=1.0.0";
                        $j("#input_wmsserviceurl").val(url);
                        
                        unblockViewerUI();
                        $j("#dialog-wmsservice-url").dialog('open');
                    }
                },
                "Annuleren": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        $j(this).dialog("close");
                        unblockViewerUI();
                    }
                }
            });

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });

            blockViewerUI();
            $j("#dialog-download-metadata").dialog('open');
        }
    }

    return lnk;
}

function getValidLayerId(lname) {
    /* Replace illegal chars for Flamingo xml in id */
    lname = lname.replace(":", "_");
    lname = lname.replace(".", "_");

    return lname;
}
/**
 * get the item that has the configuration of this wmslayer string
 * @param item the item to begin the search
 * @param layers the layers string of a layer object
 * @return the item
 */
function getItemByLayer(item,layers){
    if (item.children){
        for (var i=0; i < item.children.length; i++){
            var child = item.children[i];
            
            if (child.wmslayers && child.wmslayers==layers){
                return child;
            } else if (child.wmslayers && child.wmslayers != layers) {
                var mLayers = layers.split(",");
                
                for (var j in mLayers) {                    
                    if (child.wmslayers == mLayers[j]) {
                        return child;
                    }                    
                }                
            } else if (child.children){
                var foundItem=getItemByLayer(child,layers);
                if (foundItem!=null){
                    return foundItem;
                }
            }
        }
    }
    
    return null;        
}

function getBaseUrl() {
    var protocol = window.location.protocol + "//";
    var host = window.location.host;

    var urlBase = protocol + host  + baseNameViewer;
    
    return urlBase;    
}

function checkTempUploadedPointsWms(checked) { 
    uploadCsvLayerOn = checked;
    var layer = webMapController.getMap().getLayer("uploadedPoints");
    
    if (checked && layer == null) {
        addTempUploadedPointsWms();  
    } else if (checked && layer) {
        layer.setVisible(true);
    } else if (!checked && layer) {
        /* Removing layer otherwise it is visible in print */
        webMapController.getMap().removeLayer(layer);
    }
}

function addTempUploadedPointsWms() {     
    var lname = "uploadedPoints";
    var layerUrl = getBaseUrl() + "/UploadedPointsWmsServlet";
                
    var options={
        id: lname,
        timeout: 30,
        retryonerror: 10,
        ratio: 1,
        showerrors: true,
        initService: false,
        minscale: 0,
        maxscale: 500000        
    };
    
    var ogcOptions={
        format: "image/png",
        layers: "tempPointsLayer",
        transparent: true,
        exceptions: "application/vnd.ogc.se_inimage",
        srs: "EPSG:28992",
        version: "1.1.1",
        noCache: true
    };
    
    var newLayer = webMapController.createWMSLayer(lname, layerUrl, ogcOptions, options);
    webMapController.getMap().addLayer(newLayer);
}

var popupCreated = false;
$j(document).ready(function() {
    /* Alleen tabs vullen als ze ook echt aanstaan */
    var analyseTabOn = false;
    var meldingenTabOn = false;
    var vergunningTabOn = false;
    var zoekenTabOn = false;
    var redliningTabOn = false;
    var bagTabOn = false;
    var wktTabOn = false;
    var transparantieTabOn = false;
    var tekenTabOn = false;
    var uploadPointsTabOn = false;

    for (var i=0; i < enabledtabs.length; i++) {
        if (enabledtabs[i] == "analyse")
            analyseTabOn = true;

        if (enabledtabs[i] == "meldingen")
            meldingenTabOn = true;

        if (enabledtabs[i] == "vergunningen")
            vergunningTabOn = true;

        if (enabledtabs[i] == "redlining")
            redliningTabOn = true;

        if (enabledtabs[i] == "bag")
            bagTabOn = true;

        if (enabledtabs[i] == "zoeken")
            zoekenTabOn = true;
        
        if (enabledtabs[i] == "wkt")
            wktTabOn = true;
        
        if (enabledtabs[i] == "transparantie")
            transparantieTabOn = true;
        
        if (enabledtabs[i] == "tekenen")
            tekenTabOn = true;
        
        if (enabledtabs[i] == "uploadpoints")
            uploadPointsTabOn = true;
    }

    if (analyseTabOn) {
        if (document.getElementById('analyseframeViewer')) {
            document.getElementById('analyseframeViewer').src='/gisviewer/vieweranalysedata.do';
        }
    }

    if (meldingenTabOn) {
        if(document.getElementById('meldingenframeViewer')) {
            document.getElementById('meldingenframeViewer').src='/gisviewer/viewermeldingen.do?prepareMelding=t';
        }
    }

    if (redliningTabOn) {
        if(document.getElementById('redliningframeViewer')) {
            document.getElementById('redliningframeViewer').src='/gisviewer/viewerredlining.do?prepareRedlining=t';
        }
    }

    if (bagTabOn) {
        if(document.getElementById('bagframeViewer')) {
            document.getElementById('bagframeViewer').src='/gisviewer/viewerbag.do';
        }
    }
    
    if (wktTabOn) {
        if(document.getElementById('wktframeViewer')) {
            document.getElementById('wktframeViewer').src='/gisviewer/viewerwkt.do';
        }
    }
    
    if (transparantieTabOn) {
        if(document.getElementById('transparantieframeViewer')) {
            document.getElementById('transparantieframeViewer').src='/gisviewer/viewertransparantie.do';
        }
    }
    
    if (tekenTabOn) {
        if(document.getElementById('tekenenframeViewer')) {
            document.getElementById('tekenenframeViewer').src='/gisviewer/viewerteken.do';
        }
    }

    if (zoekenTabOn || vergunningTabOn) {
        createSearchConfigurations();
    }
    
    if (uploadPointsTabOn) {
        if(document.getElementById('uploadtemppointsframeViewer')) {
            document.getElementById('uploadtemppointsframeViewer').src='/gisviewer/uploadtemppoints.do';
        }
    }

    var pwCreated = false;
    if(document.getElementById('popupWindow')) {
        pwCreated = true;
    }

    try {
        if(getParent().document.getElementById('popupWindow')) {
            pwCreated = true;
        }
    } catch(err) {}

    if(!pwCreated) {
        buildPopup();

        $j('#popupWindow').draggable({
            handle:    '#popupWindow_Handle',
            iframeFix: true,
            zIndex: 200,
            containment: 'document',
            start: function(event, ui) {
                startDrag();
            },
            stop: function(event, ui) {
                stopDrag();
            }
        }).resizable({
            handles: 'se',
            start: function(event, ui) {
                startResize();
            },
            stop: function(event, ui) {
                stopResize();
            }
        });

        $j('#popupWindow_Close').click(function(){
            if (dataframepopupHandle)
                dataframepopupHandle.closed = true;

            $j("#popupWindow").hide();
        });

    /* $j("#popupWindow").mouseover(function(){
            startDrag();
        });
        $j("#popupWindow").mouseout(function(){
            stopDrag();
        }); */

    }

    popupCreated = true;
    createDownloadMetadataDialog();
    createWMSServiceUrlDialog();
});