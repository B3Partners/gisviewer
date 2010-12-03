dwr.engine.setErrorHandler(handler);

function handler(msg) {
    var message = msg;

    if (message != '')
    {
        alert(message);
    }
}
// // main list that holds current visible layers
// in correct order, last is top
var enabledLayerItems= new Array();

var layerUrl=""+kburl;
var cookieArray = readCookie('checkedLayers');
var cookieClusterArray = readCookie('checkedClusters');

var activeAnalyseThemaId = '';
var activeClusterId='';

// temp lists for init
var layersAan= new Array();
var clustersAan = new Array();

var featureInfoTimeOut=30;
var webMapController= null;

var b_buffer,zoomBox,pan,prevExtent,identify;
function initMapComponent(){

    mapviewer="openlayers";
    if (window.location.href.indexOf("flamingo")>0)
        mapviewer="flamingo";
    if (mapviewer== "flamingo"){
        webMapController=new FlamingoController('mapcontent');
        var map=webMapController.createMap("map1");
        webMapController.addMap(map);
    //TODO: WebMapController
    //webMapController.createEditMap("editMap");
    //webMapController.setRequestListener("requestIsDone");
    //webMapController.getMap().enableLayerRequestListener();
    }else if (mapviewer=="openlayers"){
        webMapController= new OpenLayersController();
        var opt={
            projection:"EPSG:28992",
            maxExtent: new OpenLayers.Bounds(0, 304000, 280000, 628000),
            allOverlays: true,
            units :'m',
            resolutions: [512,256,128,64,32,16,8,4,2,1,0.5,0.25,0.125]
        };
        $j("#mapcontent").html(" ");
        var olmap=webMapController.createMap('mapcontent',opt);
        $j("#mapcontent").css("border","1px solid black");
        webMapController.addMap(olmap);
        //webMapController.getMap().setMaxExtent(new Extent(0, 292000, 304000, 628000));
     
   //webMapController.getMap().zoomToExtent(new Extent(12000, 304000, 280000, 620000));

    }
    //
    webMapController.initEvents();
    webMapController.registerEvent(Event.ON_GET_CAPABILITIES,webMapController.getMap(),onGetCapabilities);
    webMapController.registerEvent(Event.ON_CONFIG_COMPLETE,webMapController,onConfigComplete);
}

function initializeButtons(){
    webMapController.createPanel("toolGroup");

    webMapController.addTool(webMapController.createTool("loading",Tool.LOADING_BAR));

    zoomBox = webMapController.createTool("toolZoomin",Tool.ZOOM_BOX);
    webMapController.addTool(zoomBox);

    pan = webMapController.createTool("b_pan",Tool.PAN);
    webMapController.addTool(pan);

    b_buffer = webMapController.createTool("b_buffer",Tool.TOGGLE);
    webMapController.addTool(b_buffer);

    prevExtent = webMapController.createTool("toolPrevExtent",Tool.NAVIGATION_HISTORY);
    webMapController.addTool(prevExtent);

    var options = new Object();
    options["handlerGetFeatureHandler"] = onIdentifyData;
    options["handlerBeforeGetFeatureHandler"] = onIdentify;

    identify = webMapController.createTool("identify",Tool.GET_FEATURE_INFO,null, options);
    webMapController.addTool(identify);
    webMapController.registerEvent(Event.ON_SET_TOOL,identify,onChangeTool);
    //webMapController.registerEvent(Event.ON_CLICK,identify,flamingo_map1_onIdentify);
    
    var editLayer = webMapController.createVectorLayer("editMap");
    webMapController.getMap().addLayer(editLayer);
    webMapController.getMap().setLayerIndex(editLayer, webMapController.getMap().getLayers().length);
    webMapController.registerEvent(Event.ON_FEATURE_ADDED, editLayer, onGeometryDrawFinished);
    
    var edittingtb = webMapController.createTool("redLiningContainer",Tool.DRAW_FEATURE, editLayer);
    webMapController.addTool(edittingtb);

    var bu_buffer = webMapController.createTool("b_buffer",Tool.BUTTON, editLayer);
    webMapController.addTool(bu_buffer);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_buffer,b_buffer);

    var bu_getfeatures = webMapController.createTool("b_getfeatures",Tool.BUTTON, editLayer);
    webMapController.addTool(bu_getfeatures);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_getfeatures,b_getfeatures);

    var bu_highlight = webMapController.createTool("b_highlight",Tool.BUTTON, editLayer);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_highlight,b_highlight);
    webMapController.addTool(bu_highlight);

    var bu_removePolygons = webMapController.createTool("b_removePolygons",Tool.BUTTON, editLayer);
    webMapController.registerEvent(Event.ON_EVENT_DOWN,bu_removePolygons,b_removePolygons);
    webMapController.addTool(bu_removePolygons);
}

initMapComponent();
function onGeometryDrawFinished(objectid,wkt){
    alert("wkt");
}

function test(a,b,c,d){
   // alert("Test");
}

function testIdentify(evt){
    alert(evt);
}
/*webMapController.getMap().setMaxExtent(new Extent(0, 292000, 304000, 628000));
webMapController.getMap().zoomToMaxExtent();*/

var mapInitialized=false;
var searchExtent=null;
var sldSearchServlet=null;
//if searchConfigId is set do a search

var highlightThemaId = null;

var multiPolygonBufferWkt = null;

var alleLayers = new Array();

function doInitSearch(){
    if (searchConfigId.length>0 && search.length>0){
        showLoading();
        JZoeker.zoek(new Array(searchConfigId),search,0,handleInitSearch);
    }
}
function handleInitSearch(list){
    hideLoading();
    if (list.length > 0){
        handleInitSearchResult(list[0],searchAction, searchId,searchClusterId,searchSldVisibleValue);
    }
}
/*Handles the searchresult.
 **/
function handleInitSearchResult(result,action,themaId,clusterId,visibleValue){
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
    if (doZoom){
        result=getBboxMinSize(result);
        var ext= new Object();
        ext.minx=result.minx;
        ext.miny=result.miny;
        ext.maxx=result.maxx;
        ext.maxy=result.maxy;
        if(mapInitialized){
            webMapController.getMap("map1").moveToExtent(ext);
        }else{
            searchExtent=ext;
        }
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
}
/*because a simple reload won't change the url in flamingo. Remove the layer and add it again.
 *Maybe a getCap is done but with a little luck the browser cached the last request.*/
function setSldOnDefaultMap(sldUrl,reload){
    var kbLayer=webMapController.getMap("map1").getLayer("fmcLayer");
    kbLayer.setSld(escape(sldUrl));
    if (reload){
        webMapController.getMap("map1").removeLayerById(kbLayer.getId(), false);
        webMapController.getMap("map1").addLayer(kbLayer);//, true, true
    }
}

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
            '<div class="inleiding">'+
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

function handleGetAdminData(/*coords,*/ geom, highlightThemaId) {
    
    if (!usePopup && !useDivPopup && !usePanelControls) {
        return;
    }

    var checkedThemaIds;
    if (!multipleActiveThemas){
        checkedThemaIds = activeAnalyseThemaId;
    } else {
        checkedThemaIds = getLayerIdsAsString();
    }

    if (checkedThemaIds == null || checkedThemaIds == '') {
        hideLoading();
        return;
    }

    document.forms[0].admindata.value = 't';
    document.forms[0].metadata.value = '';
    document.forms[0].objectdata.value = '';
    document.forms[0].analysedata.value = '';

    if (!multipleActiveThemas){
        document.forms[0].themaid.value = activeAnalyseThemaId;
    } else {
        document.forms[0].themaid.value = getLayerIdsAsString();
    }

    document.forms[0].lagen.value='';

    //als er een init search is meegegeven (dus ook een sld is gemaakt)
    if (searchAction.toLowerCase().indexOf("filter")>=0){
        
        document.forms[0].search.value=search;
        document.forms[0].searchId.value=searchId;
        document.forms[0].searchClusterId.value=searchClusterId;
    }

    document.forms[0].geom.value=geom;
    
    document.forms[0].scale.value=webMapController.getMap().getScale();
    document.forms[0].tolerance.value=tolerance;

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

    } else {
        document.forms[0].target = 'dataframe';
        loadBusyJSP('dataframe', 'panel');
    }

    
    document.forms[0].submit();
}

function openUrlInIframe(url){
    var iframe=document.getElementById("dataframe");
    iframe.src=url;
}

// 0 = niet in cookie en niet visible,
// >0 = in cookie, <0 = geen cookie maar wel visible
// alse item.analyse=="active" dan altijd visible
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

function setActiveCluster(item,overrule){
    if(((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) && (activeClusterId==null || activeClusterId.length==0)) || overrule){
        if(item != undefined & item != null) {
            var activeClusterTitle = item.title;
            var atlabel = document.getElementById('actief_thema');
            if (atlabel && activeClusterTitle && atlabel!=null && activeClusterTitle!=null){
                activeClusterId = item.id;
                atlabel.innerHTML = '' + activeClusterTitle; // Actief thema weggehaald
            }
            if(item.metadatalink && item.metadatalink.length > 1){
                if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
            }
        }
    }
}
function setActiveThema(id, label, overrule) {
    if (!(id && id!=null && label && label!=null && overrule)) {
        return activeAnalyseThemaId;
    }

    if (((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) &&
        (activeClusterId==null || activeClusterId.length==0)) || overrule){

        activeAnalyseThemaId = id;

        var atlabel = document.getElementById('actief_thema');
        if (atlabel && label && atlabel!=null && label!=null) {
            atlabel.innerHTML = '' + label; // Actief thema weggehaald
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
            /*TODO: WebMapController Renamen*/
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
function createCheckboxCluster(item, checked){

    var checkbox;
    if (navigator.appName=="Microsoft Internet Explorer") {
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

function createRadioThema(item){
    var radio;
    if (navigator.appName=="Microsoft Internet Explorer") {
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

function createCheckboxThema(item, checked) {
    var checkbox;

    if (navigator.appName=="Microsoft Internet Explorer") {

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

    checkbox.theItem=item;

    return checkbox;
}

function createInvisibleThemaDiv(item) {
    return createInvisibleDiv(item.id);
}
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
function createMetadatLink(item){
    var lnk = document.createElement('a');
    lnk.innerHTML = item.title ? item.title : item.id;
    lnk.href = '#';
    if (item.metadatalink && item.metadatalink.length > 1)
        lnk.onclick = function(){
            popUp(item.metadatalink, "metadata", 600, 500, useDivPopup)
        };
    return lnk;
}

function createLabel(container, item) {
    
    if(item.cluster) {
        //if callable
        if (item.callable) {
            var checkboxChecked = false;
            var clusterPos = getClusterPosition(item);
            if(clusterPos!=0) {
                checkboxChecked = true;
            }
            var checkbox = createCheckboxCluster(item, checkboxChecked);

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
        if (item.hide_tree && item.callable){
            // hack om toggle plaatje uit te zetten als
            // cluster onzichtbare onderliggende kaartlagen heeft
            var img = document.createElement("img");
            img.setAttribute("border", "0");
            img.src = globalTreeOptions["layermaindiv"].toggleImages["leaf"]
            img.theItem=item;
            container.togglea = img;
        }
        if (!item.hide_tree || item.callable){
            container.appendChild(document.createTextNode('  '));
            container.appendChild(createMetadatLink(item));
        } else {
            return true; //hide
        }

    } else if (!item.hide_tree) {
        if(item.wmslayers){

            alleLayers.push(item);

            var checkboxChecked = false;
            var layerPos = getLayerPosition(item);
            if(layerPos!=0) {
                checkboxChecked = true;
            }
            var labelCheckbox = createCheckboxThema(item, checkboxChecked);

            if (checkboxChecked) {
                if (layerPos<0) {
                    layersAan.unshift(labelCheckbox);
                } else {
                    layersAan.push(labelCheckbox);
                }
            }

            if(item.analyse=="on" || item.analyse=="active"){
                if (!multipleActiveThemas){
                    var labelRadio = createRadioThema(item);
                    container.appendChild(labelRadio);
                } else {
                    isActiveItem(item);
                }
            }
            container.appendChild(labelCheckbox);
        }

        if (item.legendurl != undefined && showLegendInTree) {
            container.appendChild(document.createTextNode('  '));
            container.appendChild(createTreeLegendIcon());
        }

        container.appendChild(document.createTextNode('  '));
        container.appendChild(createMetadatLink(item));

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
}

function disableLayer(itemid) {
    var $item = $j("#layermaindiv_item_" + itemid);
    $item.addClass("layerdisabled");
    $item.find("input").attr("disabled", "disabled");
    $item.find(".treeLegendIcon").addClass("disabledLegendIcon");
}

function enableLayer(itemid) {
    var $item = $j("#layermaindiv_item_" + itemid);
    $item.removeClass("layerdisabled");
    $item.find("input").removeAttr("disabled");
    $item.find(".treeLegendIcon").removeClass("disabledLegendIcon");
}

// var legendimg = null;
function createTreeLegendIcon() {
    var legendicon = document.createElement("img");
    legendicon.src = imageBaseUrl + "icons/application_view_list.png";
    legendicon.alt = "Legenda tonen";
    legendicon.title = "Legenda tonen";
    legendicon.className = 'treeLegendIcon imagenoborder';
    $j(legendicon).click(function(){
        if(!$j(this).hasClass("disabledLegendIcon")) loadTreeLegendImage($j(this).siblings("div").attr("id"));
    });
    return legendicon;
}

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
        var legendimg = document.createElement("img");
        legendimg.name = item.title;
        legendimg.alt = "Legenda " + item.title;
        legendimg.onerror=treeImageError;
        legendimg.onload=treeImageOnload;
        legendimg.className = 'treeLegendImage';
        var timestamp=(Math.floor(new Date().getTime()));
        legendimg.src = item.legendurl + "&timestamp=" + timestamp;

        divobj.appendChild(legendimg);
    }

    $j(divobj).toggle();
}

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

function treeImageError(){
    var divobj = $j(this).parent();
    divobj.find("img.legendLoading").hide();
    divobj.html('<span style="color: Black;">Legenda kan niet worden opgehaald</span>');
}

function treeImageOnload(){
    if (parseInt(this.height) > 5){
        $j(this).parent().find("img.legendLoading").hide();
    }
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

var currentActiveTab = null;
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

    /* indien cookies aan dan cluster id in cookie stoppen */
    var cluster=element.theItem;
    if (useCookies) {      
        if (element.checked) {
            addClusterIdToCookie(cluster.id);
        } else {
            removeClusterIdFromCookie(cluster.id);
        }
    }
    // als hide_tree dan altijd childs aan/uit zetten, want gebruiker kan daar niet bij
    if (!useInheritCheckbox || cluster.hide_tree) {
        if (element.checked) {
            
            for (var i=0; i < cluster.children.length;i++){
                var child=cluster.children[i];
                if (!child.cluster){
                    addItemAsLayer(child);
                    if (!cluster.hide_tree){
                        document.getElementById(child.id).checked=true;
                    }
                } else {
                    if (child.callable){
                        var elemin = document.getElementById(child.id);
                        elemin.checked=true;
                        clusterCheckboxClick(elemin,dontRefresh);
                    }
                }
            }
        } else {
            for (var d=0; d < cluster.children.length;d++) {
                var child1=cluster.children[d];
                if (!child1.cluster){
                    removeItemAsLayer(child1);
                    if (!cluster.hide_tree){
                        document.getElementById(child1.id).checked=false;
                    }
                } else {
                    if (child1.callable){
                        var elemout = document.getElementById(child1.id);
                        elemout.checked=false;
                        clusterCheckboxClick(elemout,dontRefresh);
                    }
                }
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

//if atBottomOfType is set to true the layer will be added at the bottom of its type (background or top type)
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
    refreshLayer();
    refreshLegendBox();
}

function checkScaleForLayers() {    
    var currentscale = webMapController.getMap().getScale();

    var minscale = 0;
    var maxscale = 0;
    
    for (var i=0; i < alleLayers.length; i++) {
        var item = alleLayers[i];
        var itemid = item.id;

        if (item.scalehintmin != null) {
            minscale = Number(item.scalehintmin.replace(",", "."));
        }

        if (item.scalehintmax != null) {
            maxscale = Number(item.scalehintmax.replace(",", "."));
        }

        /* als er min en maxscale is dan laag aanzetten indien currentscale binnen
         * min en max valt */
        if (minscale > 0 && maxscale > 0) {
            if (currentscale <= maxscale && currentscale >= minscale) {
                enableLayer(itemid);
            } else {
                disableLayer(itemid);
            }
        }
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

    var topLayerItems= new Array();
    var backgroundLayerItems= new Array();
    var item;

    for (var i=0; i<enabledLayerItems.length; i++){
        item = enabledLayerItems[i];

        if (useInheritCheckbox) {
            var object = document.getElementById(item.id);
            // Item alleen toevoegen aan de layers indien
            // parent cluster(s) allemaal aangevinkt staan of
            // geen cluster heeft
            if (!itemHasAllParentsEnabled(object))
                continue;
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
    for (var i=0; i<orderedLayerItems.length; i++){
        item = orderedLayerItems[i];
        if (layerGrouping == "lg_layer") {
            localGroupName = "fmc" + item.id;
        } else if (layerGrouping == "lg_cluster") {
            localGroupName = "fmc" + item.clusterid;
        } else if (layerGrouping == "lg_forebackground") {
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
    var shownLayers=webMapController.getMap().getAllWMSLayers();
    var removedLayers = new Array();
    for (var j=0; j < shownLayers.length; j++){
        var lid = shownLayers[j].getId();
        var ls = shownLayers[j].getOption("layers");
        var found = false;
        for (i=0; i<layerGroups.length && found==false; i++){
            layerGroup = layerGroups[i];
            if (lid == layerGroup[0]) {
                // controleren of laagvolgorde hetzelfde is
                var lsreq = "";
                for (var k=1; k < layerGroup.length; k++){
                    item = layerGroup[k];
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
    for (var k=0; k < removedLayers.length; k++){
        webMapController.getMap().removeLayerById(removedLayers[k]);//false
    }

    // toevoegen lagen
    for (i=0; i<layerGroups.length; i++){
        layerGroup = layerGroups[i];
        var layerId = layerGroup[0];
        if (webMapController.getMap().getLayer(layerId)==null){
            layerGroup.splice(0,1);
            addLayerToFlamingo(layerId, layerUrl, layerGroup);
        }
        var layer=webMapController.getMap().getLayer(layerId);
        if (layer!=null){
            var oldOrderIndex=webMapController.getMap().setLayerIndex(layer,i);
        if (i != oldOrderIndex){
            doRefreshOrder=true;
        }
    }
    }

    hideLoading();

    if (local_refresh_handle != refresh_timeout_handle) {
        // check of dit een goed idee is
        // alleen refresh als er intussen geen nieuwe timeout gezet is
        return;
    } else {
        refresh_timeout_handle = 0;
    }
    if (doRefreshOrder) {
    //TODO: WebMapController
    //webMapController.getMap().refreshLayerOrder();
    }

    var lagen = webMapController.getMap().getAllVectorLayers();
    var totalLayers = webMapController.getMap().getLayers().length;
    for(var i = 0 ; i < lagen.length;i++){
        var laag = lagen[i];
        webMapController.getMap().setLayerIndex(laag,totalLayers);
}
}

function addLayerToFlamingo(lname, layerUrl, layerItems) {
    
    var capLayerUrl=layerUrl;

    //var newLayer= new FlamingoWMSLayer(lname);
    var options={
        id: lname,
        timeout: 30,
        retryonerror: 10,
        getcapabilitiesurl: capLayerUrl,
        showerrors: true
    };
    var ogcOptions={
        format: "image/png",
        transparent: true,
        exceptions: "application/vnd.ogc.se_inimage",
        srs: "EPSG:28992",
        version: "1.1.1"
    };
    var theLayers="";
    var queryLayers="";
    var maptipLayers="";
    var smallestMinscale = -1;
    var largestMaxscale = -1;

    // last in list will be on top in map
    for (var i=0; i<layerItems.length; i++){
        var item = layerItems[i];
        
        if (item.scalehintmin != null) {
            var minscale = Number(item.scalehintmin.replace(",", "."));
        }

        if (!isNaN(minscale) && smallestMinscale != 0) {
            if (smallestMinscale == -1 || minscale < smallestMinscale) {
                    smallestMinscale = minscale;
            }
        } else {
            smallestMinscale = 0;
        }

        if (item.scalehintmax != null) {
            var maxscale = Number(item.scalehintmax.replace(",", "."));
        }
        
        if (!isNaN(maxscale) && largestMaxscale != 0) {
            if (largestMaxscale == -1 || maxscale > largestMaxscale) {
                    largestMaxscale = maxscale;
            }
        } else {
            largestMaxscale = 0;
        }

        if (item.wmslayers){
            if (theLayers.length>0) {
                theLayers+=",";
            }
            theLayers+=item.wmslayers;
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
        //TODO: WebMapController
        //newLayer.addLayerProperty(new LayerProperty(layerItems[i].wmslayers, layerItems[i].maptipfield, aka));
        }
    }

    if (smallestMinscale != null && smallestMinscale > 0) {
        options["minscale"]=smallestMinscale;
    }

    if (largestMaxscale != null && largestMaxscale > 0) {
        options["maxscale"]=largestMaxscale;
    }
    ogcOptions["layers"]=theLayers;
    ogcOptions["query_layers"]=queryLayers;
    var newLayer=webMapController.createWMSLayer(lname, layerUrl, ogcOptions, options);
    //TODO: WebMapController
    /*options["maptiplayers"]=maptiplayers;
    newLayer.setMaptiplayers(maptipLayers);*/
    webMapController.getMap().addLayer(newLayer);//false, true, false
}

function pipo(a,b,c,d){
    alert("pipo");
}

function loadObjectInfo(geom) {
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
    document.forms[0].analysedata.value = '';
    document.forms[0].target = 'objectframeViewer';

    document.forms[0].submit();
}

function getLayerIdsAsString() {
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

    if (item.legendurl != undefined){
        var timestamp=(Math.floor(new Date().getTime()));
        myImage.src = item.legendurl + "&timestamp=" + timestamp;
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

}
function imageOnload(){
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
}

//adds a layer to the legenda
//if atBottomOfType is set to true the layer will be added at the bottom of its type (background or top type)
function addLayerToLegendBox(theItem,atBottomOfType) {
    //check if already exists in legend
    var layerDiv = findLayerDivInLegendBox(theItem);
    if (layerDiv!=null)
        return;

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
            for(var i=0; i < orderLayerBox.childNodes.length; i++){
                var orderLayerItem=orderLayerBox.childNodes.item(i).theItem;
                if (orderLayerItem){
                    if (orderLayerItem.background){
                        beforeChild=previousChild;
                        break;
                    }
                }
                previousChild=orderLayerBox.childNodes.item(i);
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
            if (!itemHasAllParentsEnabled(object)) {
                found = true;
                invisibleLayerItems.push(item);
            }
        }
        if (!found) {
            visibleLayerItems.push(item);
        }
    }

    var reorderedLayerItems = new Array();
    var totalLength = orderLayerBox.childNodes.length;
    for(var i = (totalLength - 1); i > -1; i--) {
        var itemId = splitValue(orderLayerBox.childNodes[i].id)[0];
        orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
        for (var m=0; m < visibleLayerItems.length; m++){
            if (visibleLayerItems[m].id==itemId){
                var foundLayerItem = visibleLayerItems[m];
                reorderedLayerItems.push(foundLayerItem);
                visibleLayerItems.splice(m, 1);
                break;
            }
        }
    }
 
    enabledLayerItems = new Array();
    if (reorderedLayerItems.length>0) {
        enabledLayerItems = enabledLayerItems.concat(reorderedLayerItems);
    }
    if (visibleLayerItems.length>0) {
        enabledLayerItems = enabledLayerItems.concat(visibleLayerItems);
    }
    for (var j=0; j<enabledLayerItems.length; j++){
        var item = enabledLayerItems[j];
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
Nifty("ul#nav a","medium transparent top");
var orderLayerBox= document.getElementById("orderLayerBox");
/*TODO: WebMapController hoe gaan we dit oplossen?*/
function onChangeTool(id, event) {
    if (id == 'identify') {
        btn_highLightSelected = false;
    }
}

//function wordt aangeroepen als er een identify wordt gedaan met de tool op deze map.
function onIdentify(movie,extend){

    //todo: nog weghalen... Dit moet uniform werken.
    if (extend==undefined){
        extend=movie;
    }
    var xp = (extend.minx + extend.maxx)/2;
    var yp = (extend.miny + extend.maxy)/2;

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

    if (btn_highLightSelected) {
        webMapController.activateTool("breinaald");
        
        highLightThemaObject(geom);
    } else {
        btn_highLightSelected = false;
        webMapController.activateTool( "identify");

        handleGetAdminData(geom, null);
    }
    
    loadObjectInfo(geom);
}

var teller=0;
//update the getFeatureInfo in the feature window.
function updateGetFeatureInfo(data){
    teller++
    //if times out return;
    if (teller==featureInfoTimeOut){
        teller=0;
        return;
    }
    //if the admindata window is loaded then update the page (add the featureinfo thats given by the getFeatureInfo request.
    if (usePopup && dataframepopupHandle.contentWindow.writeFeatureInfoData){
        dataframepopupHandle.contentWindow.writeFeatureInfoData(data);
        data=null;
    }else if (window.frames.dataframe.writeFeatureInfoData){
        window.frames.dataframe.writeFeatureInfoData(data);
        data=null;
    }else{
        //if the admindata window is not loaded yet then retry after 1sec
        setTimeout(function(){
            updateGetFeatureInfo(data)
        },1000);
    }
}

function onIdentifyData(id,data){
    teller=0;
    updateGetFeatureInfo(data);
}
var firstTimeOninit = true;

function onFrameworkLoaded(){
    if (document.getElementById("treeForm") && navigator.appName=="Microsoft Internet Explorer"){
        document.getElementById("treeForm").reset();
    }

    if (firstTimeOninit) {

        firstTimeOninit=false;

        // layer added in reverse order
        // layer with lowest order number should be on top
        // so added last
        for (var i=clustersAan.length-1; i >=0 ; i--){
            clusterCheckboxClick(clustersAan[i], true);
        }
        for (var m=layersAan.length-1; m >=0 ; m--){
            checkboxClick(layersAan[m],true);
        }

        //if searchExtent is already found (search is faster then Flamingo Init) then use the search extent.
        if (searchExtent!=null){
            webMapController.getMap("map1").moveToExtent(searchExtent);
        }else{
            doRefreshLayer();
            //if searchExtent is already found (search is faster then Flamingo Init) then use the search extent.
            if (searchExtent!=null){
                webMapController.getMap("map1").moveToExtent(searchExtent);
            }else{
                if (bbox!=null && bbox.length>0 && bbox.split(",").length==4){
                    moveToExtent(bbox.split(",")[0],bbox.split(",")[1],bbox.split(",")[2],bbox.split(",")[3]);
                }else{
                    if (fullbbox!=null && fullbbox.length>0 && fullbbox.split(",").length==4){
                        moveToExtent(fullbbox.split(",")[0],fullbbox.split(",")[1],fullbbox.split(",")[2],fullbbox.split(",")[3]);
                    }else{
                        moveToExtent(12000,304000,280000,620000);
                    }
                }
            }
            if (fullbbox!=null && fullbbox.length>0 && fullbbox.split(",").length==4){
                setFullExtent(fullbbox.split(",")[0],fullbbox.split(",")[1],fullbbox.split(",")[2],fullbbox.split(",")[3]);
            }
            else {
                setFullExtent(12000,304000,280000,620000);
            }
        }
    }
    mapInitialized=true;
    doInitSearch();
}

function ie6_hack_onInit(){
    if (navigator.appVersion.indexOf("MSIE") != -1) {
        version = parseFloat(navigator.appVersion.split("MSIE")[1]);
        
        if (version == 6) {
            setTimeout("doOnInit=true; onFrameworkLoaded();",5000);
        }
    }
}
function moveToExtent(minx,miny,maxx,maxy){
    webMapController.getMap().zoomToExtent({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    }, 0);
}
function setFullExtent(minx,miny,maxx,maxy){
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
    //TODO: WebMapController
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

function moveAndIdentify(minx,miny,maxx,maxy){
    moveToExtent(minx,miny,maxx,maxy);
    var centerX=Number(Number(Number(minx)+Number(maxx))/2);
    var centerY=Number(Number(Number(miny)+Number(maxy))/2);
    //doIdentify(centerX,centerY,centerX,centerY);
    doIdentifyAfterUpdate(centerX,centerY,centerX,centerY);
}

/*TODO: WebMapController bij klaar zijn met laden event*/
function flamingo_map1_onUpdateComplete(mapId){
    checkScaleForLayers();

    if(nextIdentifyExtent!=null){
        doIdentify(nextIdentifyExtent.minx,nextIdentifyExtent.miny,nextIdentifyExtent.maxx,nextIdentifyExtent.maxy);
        nextIdentifyExtent=null;
    }   
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

/*functie controleerd of het component is geladen. Zo niet dan wordt het oninit event afgevangen en daarin
         *wordt de functie nogmaals aangeroepen. Nu bestaat het object wel en kan de functie wel worden aangeroepen.
         **/
function callFlamingoComponent(id,func,value){
    if (typeof flamingo.callMethod == 'function' && flamingo.callMethod('flamingo','exists',id)==true){
        eval("setTimeout(\"flamingo.callMethod('"+id+"','"+func+"',"+value+")\",10);");
    }
    else{
        eval("flamingo_"+id+"_onInit= function(){callFlamingoComponent('"+id+"','"+func+"','"+value+"');};");
    }
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
}

var exportMapWindow;
function exportMap(){
    if(exportMapWindow==undefined || exportMapWindow==null || exportMapWindow.closed){
        // exportMapWindow=popUp("createmappdf.do", "exportMapWindow", 620, 620, false);
        exportMapWindow=window.open("", "exportMapWindowNaam");
        exportMapWindow.focus();
    }
    var submitForm = document.createElement("FORM");
    document.body.appendChild(submitForm);
    submitForm.method = "POST";

    var urlString="";
    var firstURL = true;
    var layers=webMapController.getMap("map1").getLayers();
    for (var i=0; i < layers.length; i++){
        if(layers[i].getLastGetMapRequest() != null){
            if(!firstURL){
                urlString+=";";
            }else{
                firstURL = false;
            }
            urlString+=layers[i].getLastGetMapRequest();
            if(layers[i].getAlpha() != null){
                urlString+="#"+layers[i].getAlpha();
            }
        }
    }
    var newElement = document.createElement("<input name='urls' type='hidden'>");
    newElement.value = urlString;
    submitForm.appendChild(newElement);

    var features=webMapController.getMap().getLayer("editMap").getAllFeatures();
    var wktString="";
    for (var b=0; b < features.length; b++){
        wktString+=features[b].getWkt();
        wktString+="#ff0000";
        if (features[b].label) {
            wktString+="|"+features[b].label;
        }
        wktString+=";";
    }
    newElement = document.createElement("<input name='wkts' type='hidden'>");
    newElement.value = wktString;
    submitForm.appendChild(newElement);

    submitForm.target="exportMapWindowNaam";
    submitForm.action= "printmap.do";
    submitForm.submit();
}

function checkboxClickById(id){
    var el2=document.getElementById(id);
    if (el2) {
        el2.checked=!el2.checked;
        checkboxClick(el2,false);
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

function getWkt() {
    var object = webMapController.getMap().getLayer("editMap").getActiveFeature();

    if (object == null)
        return null;

    return object.wktgeom;
}

function b_getfeatures(id,event) {
    var wkt = getWktActiveFeature();

    if (wkt) {
        handleGetAdminData(wkt, null);
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
    webMapController.getMap().getLayer("editMap").addFeature( feature);
}

/**
 * Alle ge�mplementeerde eventhandling functies
 */
function b_removePolygons(id,params){
        webMapController.getMap().getLayer("editMap").removeAllFeatures();
}

/* er is net op de highlight knop gedrukt */
function b_highlight( id,params) {
        btn_highLightSelected = true;
        webMapController.activateTool( "breinaald");
}

var btn_highLightSelected = false;

var popupWindowRef = null;
var highLightGeom = null;

var analyseThemas = new Array();

function highLightThemaObject(geom) {    
    analyseThemas = new Array();

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

        if (item.analyse == 'on' || item.analyse=="active") {
            analyseThemas.push(item);
        }
    }

    if (analyseThemas.length > 1) {
        // popupWindowRef = popUp('viewerhighlight.do', 'popupHighlight', 680, 225, true);
        iFramePopup('viewerhighlight.do', false, 'Breinaald popup', 400, 300);
    }

    if (analyseThemas.length == 1) {
        EditUtil.getHighlightWktForThema(analyseThemas[0].id, geom, returnHighlight);
        
        //handleGetAdminData(geom, analyseThemas[0].id);
    }
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

    EditUtil.getHighlightWktForThema(value, highLightGeom, returnHighlight);
    handleGetAdminData(highLightGeom, value);   
}

/* backend heeft wkt teruggegeven */
function returnHighlight(wkt) {    
    if (wkt.length > 0)
    {        
        var polyObject = new Object();

        polyObject["id"]=61501;
        polyObject["wktgeom"]=wkt;

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

        webMapController.getTool("redLiningContainer").setVisible(true);
    } else {
        webMapController.getTool("redLiningContainer").setVisible(false);
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
}

function onGetCapabilities (id,params){
    hideLoading();
}
//do only ones.
var initialized=false;
function onConfigComplete(id,params){
    if (!initialized){
        initialized=true;
        initializeButtons();
        checkDisplayButtons();
        onFrameworkLoaded(); // TODO: gaat dit goed? Dit word nu aangeroepen met document.ready(), nu niet meer met flamingoevent
    }
}
/*
function tempDispatcher(event,comp){
    if (event=="onGetCapabilities") {
    }

    if (event=="onConfigComplete") {
    }
}*//*
function dispatchEventJS(event, comp) {
    //console.log(event + " | " + comp);
  
    
}*/

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
        "top": popupTop
    })

    document.body.appendChild(popupDiv);
    document.body.appendChild(popupWindowBackground);
}

var popupCreated = false;

$j(document).ready(function(){

    /* vullen inhoud analyse tab */
    if(document.getElementById('analyseframeViewer')) {
        document.getElementById('analyseframeViewer').src='/gisviewer/vieweranalysedata.do';
    }
    /* vullen inhoud meldingen tab */
    if(document.getElementById('meldingenframeViewer')) {
        document.getElementById('meldingenframeViewer').src='/gisviewer/viewermeldingen.do?prepareMelding=t';
    }

    if(!document.getElementById('popupWindow') && !getParent().document.getElementById('popupWindow')) {
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
        $j("#popupWindow").mouseover(function(){
            startDrag();
        });
        $j("#popupWindow").mouseout(function(){
            stopDrag();
        });
        $j("#popupWindow").hide();
    }
    popupCreated = true;

    createSearchConfigurations();
});