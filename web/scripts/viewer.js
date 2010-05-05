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

var activeAnalyseThemaId = '';
var activeClusterId='';

var featureInfoData=null;

// temp lists for init
var layersAan= new Array();
var clustersAan = new Array();

var timeouts=0;
var featureInfoTimeOut=30;

var flamingoController= new FlamingoController(flamingo,'flamingoController');
flamingoController.createMap("map1");
flamingoController.createEditMap("editMap");
//flamingoController.setRequestListener("requestIsDone");
//flamingoController.getMap().enableLayerRequestListener();

var mapInitialized=false;
var searchExtent=null;
var sldSearchServlet=null;
//if searchConfigId is set do a search

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
            flamingoController.getMap("map1").moveToExtent(ext);
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
        }if(themaId){
            sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
            sldOptions+="themaId="+themaId;
        }if(clusterId){
            sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
            sldOptions+="clusterId="+clusterId;
        }
        sldOptions += sldOptions.indexOf("?")>=0 ? "&" : "?";
        if (doHighlight){
            sldOptions+="sldType=UserStyle";
        }if (doFilter){
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
    var kbLayer=flamingoController.getMap("map1").getLayer("fmcLayer");
    kbLayer.setSld(escape(sldUrl));
    if (reload){
        flamingoController.getMap("map1").removeLayerById(kbLayer.getId(), false);
        flamingoController.getMap("map1").addLayer(kbLayer, true, true);
    }
}

function doAjaxRequest(point_x, point_y) {
    if (adresThemaId!=undefined){
        JMapData.getData(point_x, point_y, infoArray, adresThemaId, 100, 28992, handleGetData);
    }
}

function handleGetData(str) {
    var rd = "X: " + str[0] + "<br />" + "Y: " + str[1];
    var adres;
    if (str[3]!=null && str[4]!=null){
        adres = str[3] + ", " + str[4]; // + " (afstand: " + str[2] + " m.)"
    }
    document.getElementById('rdcoords').innerHTML = rd;
    if (adres!=undefined){
        document.getElementById('kadastraledata').innerHTML = adres;
    }else{
        document.getElementById('kadastraledata').innerHTML = "Geen adres gevonden";
    }
}


function handleGetAdminData(/*coords,*/ geom) {
    showLoading();

    var checkedThemaIds;
    if (!multipleActiveThemas){
        checkedThemaIds = activeAnalyseThemaId;
    } else {
        checkedThemaIds = getLayerIdsAsString();
    }
    if(checkedThemaIds == null || checkedThemaIds == '') {
        //alert('Er is geen laag geselecteerd, selecteer eerst een laag om de administratieve data te tonen');
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
        //alert("search: "+search);
        document.forms[0].search.value=search;
        document.forms[0].searchId.value=searchId;
        document.forms[0].searchClusterId.value=searchClusterId;
    }

    document.forms[0].geom.value=geom;
    document.forms[0].scale.value=flamingo.call("map1", "getCurrentScale");
    document.forms[0].tolerance.value=tolerance;
    if(usePopup) {
        // open popup when not opened en submit form to popup
        if(dataframepopupHandle == null || dataframepopupHandle.closed) {
            if(useDivPopup) {
                dataframepopupHandle = popUpData('dataframedivpopup', 680, 225, true);
            } else {
                dataframepopupHandle = popUpData('dataframepopup', 680, 225);
            }
        }
        if(useDivPopup) {
            document.forms[0].target = 'dataframedivpopup';
        } else {
            document.forms[0].target = 'dataframepopup';
        }
    } else {
        document.forms[0].target = 'dataframe';
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
    if(cookieArray == null) {
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
function setActiveCluster(item,overrule){
    if(((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) && (activeClusterId==null || activeClusterId.length==0)) || overrule){
        if(item != undefined & item != null) {
            var activeClusterTitle = item.title;
            var atlabel = document.getElementById('actief_thema');
            if (atlabel && activeClusterTitle && atlabel!=null && activeClusterTitle!=null){
                activeClusterId = item.id;
                atlabel.innerHTML = 'Actief thema: ' + activeClusterTitle;
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
            atlabel.innerHTML = 'Actief thema: ' + label;
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
            flamingo_map1_onIdentify('',{
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
    eraseCookie('activelayer');
    var oldActiveThemaId = activeAnalyseThemaId;
    if (obj && obj!=null && obj.theItem && obj.theItem!=null && obj.theItem.id && obj.theItem.title) {
        createCookie('activelayer', obj.theItem.id + '##' + obj.theItem.title, '7');
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
function filterInvisibleItems(cluster){
    var hasClusters=false;
    if(cluster.children) {
        for(var i = 0; i < cluster.children.length; i++) {
            var item=cluster.children[i];
            if (item.cluster){
                filterInvisibleItems(item);
                if (item.hide_tree && !item.callable){
                    hasCluster=true;
                }
            }
        }
    }        
    if (cluster.hide_tree && !hasClusters){
        cluster.children=null;
    }
}
function createCheckboxCluster(item){
    var checkbox;
    if (navigator.appName=="Microsoft Internet Explorer") {
        var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
        if(item.visible)
            checkboxControleString += ' checked="checked"';
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
        if(item.visible)
            checkbox.checked = true;
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

function createCheckboxThema(item, checked){
    var checkbox;
    if (navigator.appName=="Microsoft Internet Explorer") {

        var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
        if(checked) {
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
        checkbox.onclick = function(){
            checkboxClick(this, false);
        }
        if(checked){
            checkbox.checked = true;
        }
    }
    checkbox.theItem=item;
    return checkbox;
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
        if (item.callable){
            var checkbox= createCheckboxCluster(item);
            //add the real(not filtered) item to the checkbox.
            checkbox.theItem=treeview_findItem(themaTree,item.id);
            container.appendChild(checkbox);

            if (item.visible){
                clustersAan.push(checkbox);
            }
        }
        if (!item.hide_tree || item.callable){
            container.appendChild(document.createTextNode('  '));
            container.appendChild(createMetadatLink(item));
        }
        if (item.active){
            setActiveCluster(item, true);
            if(item.metadatalink && item.metadatalink.length > 1){
                if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
            }
        }
    } else if (!item.hide_tree) {
        
        if(item.wmslayers){
            var analyseRadioChecked = false;
            if (item.analyse=="active") {
                analyseRadioChecked = true;
            }
            var layerPos = getLayerPosition(item);
            var checkboxChecked = false;
            if(layerPos!=0 || analyseRadioChecked ){
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
        container.appendChild(document.createTextNode('  '));
        container.appendChild(createMetadatLink(item));
        
    } else if(item.hide_tree && item.visible && item.wmslayers){
        addItemAsLayer(item,true);
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
    if(!allowed) obj = document.getElementById(enabledtabs[0]);

    eraseCookie('activetab');
    createCookie('activetab', obj.id, '7');
    currentActiveTab = obj.id;
    obj.className="activelink";
    for(i in tabbladen) {
        var tabobj = tabbladen[i];
        if(tabobj.id != obj.id) {
            document.getElementById(tabobj.id).className = '';
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

function syncLayerCookieAndForm(layerString) {
    eraseCookie('checkedLayers');
    if (layerString!=null) {
        createCookie('checkedLayers', layerString, '7');
    }
    document.forms[0].lagen.value = layerString;
}

//called when a checkbox is clicked.
function checkboxClick(obj, dontRefresh) {    
    if(obj.checked) {        
        //add legend
        //add wms layer part
        addItemAsLayer(obj.theItem);        
        
    } else {
        removeItemAsLayer(obj.theItem);
    }
    if (!dontRefresh){        
        refreshLayerWithDelay();
    }
}
//called when a clustercheckbox is clicked
function clusterCheckboxClick(element,dontRefresh){
    if (element==undefined || element==null)
        return;
    if (layerUrl==null){
        layerUrl=""+kburl;
    }
    var cluster=element.theItem;
    if (element.checked){
        for (var i=0; i < cluster.children.length;i++){
            var child=cluster.children[i];
            if (!child.cluster){
                addItemAsLayer(child);
                if (!cluster.hide_tree){
                    document.getElementById(child.id).checked=true;
                }
            }
        }
    }else{
        for (var c=0; c < cluster.children.length;c++){
            var child=cluster.children[c];
            if (!child.cluster){
                removeItemAsLayer(child);
                if (!cluster.hide_tree){
                    document.getElementById(child.id).checked=false;
                }
            }
        }
    }
    if (!dontRefresh){
        refreshLayerWithDelay();
    }
}
//adds a item as a layer (Wmslayer, legend and querylayer) and a cookie if needed.
//if atBottomOfType is set to true the layer will be added at the bottom of its type (background or top type)
function addItemAsLayer(theItem,atBottomOfType){
    addLayerToEnabledLayerItems(theItem);
    var arrayString = getLayerIdsAsString();
    if (arrayString == "") {
        arrayString = 'ALL';
    }
    syncLayerCookieAndForm(arrayString)
    
    //add legend part
    if (!theItem.hide_legend)
        addLayerToLegendBox(theItem,atBottomOfType);
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
    enabledLayerItems.push(theItem);
}

function removeItemAsLayer(theItem){
    if (!theItem.hide_legend)
        removeLayerFromLegendBox(theItem.id + '##' + theItem.wmslayers);
    if (removeLayerFromEnabledLayerItems(theItem.id)!=null) {
        var arrayString = getLayerIdsAsString();
        if (arrayString == "") {
            arrayString = 'ALL';
        }
        syncLayerCookieAndForm(arrayString)
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

function refreshLayerWithDelay(){
    timeouts++;
    setTimeout("doRefreshLayer();",refreshDelay);

}
function doRefreshLayer(){
    timeouts--;
    if (timeouts<0){
        timeouts=0;
    }
    if (timeouts==0){
        refreshLayer();
    }

}
function refreshLayer(){
    getLayerIdsAsString();
    if (layerUrl!=undefined && layerUrl!=null) {
        var backgroundLayers="";
        var topLayers="";
        var queryLayers="";
        // last in list will be on top in map
        for (var i=0; i<enabledLayerItems.length; i++){
            var item=enabledLayerItems[i];
            if (item.visible){
                if (item.wmslayers){
                    if (item.background){
                        if (backgroundLayers.length>0)
                            backgroundLayers+=",";
                        backgroundLayers+=item.wmslayers;
                    }else{
                        if(topLayers.length > 0)
                            topLayers+=",";
                        topLayers+=item.wmslayers;
                    }
                }
                if (item.wmsquerylayers){
                    if (queryLayers.length > 0)
                        queryLayers+=",";
                    queryLayers+=item.wmsquerylayers
                }
            }
        }
        var layersToAdd=backgroundLayers;
        if (layersToAdd.length>0)
            layersToAdd+=",";
        layersToAdd+=topLayers;
        if(layerUrl.toLowerCase().indexOf("?service=")==-1 && layerUrl.toLowerCase().indexOf("&service=" )==-1){
            if(layerUrl.indexOf('?')> 0)
                layerUrl+='&';
            else
                layerUrl+='?';
            layerUrl+="SERVICE=WMS";
        }
        var capLayerUrl=layerUrl;
        //maak layer
        var newLayer= new FlamingoWMSLayer("fmcLayer");
        newLayer.setTimeOut("30");
        newLayer.setRetryOnError("10");
        newLayer.setFormat("image/png")
        newLayer.setTransparent(true);
        newLayer.setUrl(layerUrl);
        newLayer.setExceptions("application/vnd.ogc.se_inimage");
        newLayer.setGetcapabilitiesUrl(capLayerUrl);
        newLayer.setLayers(layersToAdd);
        newLayer.setQuerylayers(queryLayers);
        newLayer.setSrs("EPSG:28992");
        newLayer.setVersion("1.1.1");
        newLayer.setShowerros(true);

        var maptipLayers="";
        for (var i=0; i < enabledLayerItems.length; i++){
            if (enabledLayerItems[i].maptipfield){
                if (maptipLayers.length!=0)
                    maptipLayers+=",";
                maptipLayers+=enabledLayerItems[i].wmslayers;
                var aka=enabledLayerItems[i].wmslayers;
                /*Als de gebruiker ingelogd is dan zal het waarschijnlijk een kaartenbalie service zijn
                 *Daarom moet er een andere aka worden gemaakt voor de map tip.
                */
                if (ingelogdeGebruiker && ingelogdeGebruiker.length > 0){
                    aka=aka.substring(aka.indexOf("_")+1);
                }
                newLayer.addLayerProperty(new LayerProperty(enabledLayerItems[i].wmslayers, enabledLayerItems[i].maptipfield, aka));
            }
        }
        newLayer.setMaptiplayers(maptipLayers);
        flamingoController.getMap().addLayer(newLayer, true,true);
        
    }
}

function loadObjectInfo(/*coords,*/ geom) {
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

    // vul analyse frame
    document.forms[0].objectdata.value = '';
    document.forms[0].analysedata.value = 't';
    document.forms[0].target = 'analyseframeViewer';
    document.forms[0].submit();
}

function getLayerIdsAsString() {
    var ret = "";
    var firstTime = true;

    for (var i=0; i < enabledLayerItems.length; i++){
        if(firstTime) {
            ret += enabledLayerItems[i].id;
            firstTime = false;
        } else {
            ret += "," + enabledLayerItems[i].id;
        }
    }
    //    alert ("layerasstring: " + ret);
    return ret;
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
    spanEl.style.color = 'Black';
    spanEl.style.fontWeight = 'bold';

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

    if (item.hide_legend && demogebruiker){
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
        legendimg.style.border = '0px none White';
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
    if(orderLayerBox.hasChildNodes() && !theItem.hide_legend) {
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

function removeLayerFromLegendBox(id) {
    var remel = document.getElementById(id);
    if (remel!=undefined && remel!=null) {
        orderLayerBox.removeChild(remel);
    }
}

function refreshMapVolgorde() {
    parseLegendBox();
    refreshLayer();
}

function parseLegendBox() {
    // by removing and adding, order is sync'd.
    // order in legend box is reverse of order layer list
    for(var i = orderLayerBox.childNodes.length -1; i>=0; i--) {
        var itemId = splitValue(orderLayerBox.childNodes[i].id)[0];
        var removedLayerItem = removeLayerFromEnabledLayerItems(itemId);
        addLayerToEnabledLayerItems(removedLayerItem);
    }
    var arrayString = getLayerIdsAsString();
    if (arrayString == "") {
        arrayString = 'ALL';
    }
    syncLayerCookieAndForm(arrayString);
}

function deleteAllLayers() {
    var totalLength = orderLayerBox.childNodes.length;
    for(var i = (totalLength - 1); i > -1; i--) {
        document.getElementById(splitValue(orderLayerBox.childNodes[i].id)[0]).checked = false;
        orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
    }
    enabledLayerItems=new Array();
    syncLayerCookieAndForm("");
    refreshLayer();
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

//always call this script after the SWF object script has called the flamingo viewer.
//function wordt aangeroepen als er een identify wordt gedaan met de tool op deze map.
function flamingo_map1_onIdentify(movie,extend){
    //alert("extend: "+extend.maxx+","+extend.maxy+"\n"+extend.minx+" "+extend.miny);
    document.getElementById('start_message').style.display = 'none';
    document.getElementById('algdatavak').style.display = 'block';

    var loadingStr = "Bezig met laden...";
    document.getElementById('kadastraledata').innerHTML = loadingStr;
    var xp = (extend.minx + extend.maxx)/2;
    var yp = (extend.miny + extend.maxy)/2;

    var geom = "";
    if (extend.minx!=extend.maxx && extend.miny!=extend.maxy){
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

    /*var coords = new Array();
    coords.push(extend.minx);
    coords.push(extend.miny);
    if (extend.minx!=extend.maxx && extend.miny!=extend.maxy){
        coords.push(extend.maxx);
        coords.push(extend.miny);
        coords.push(extend.maxx);
        coords.push(extend.maxy);
        coords.push(extend.minx);
        coords.push(extend.maxy);
        coords.push(extend.minx);
        coords.push(extend.miny);
    }*/
    handleGetAdminData(/*coords,*/ geom);

    doAjaxRequest(xp,yp);
    loadObjectInfo(/*coords,*/ geom);
}
var teller=0;
//update the getFeatureInfo in the feature window.
function updateGetFeatureInfo(){
    teller++
    //if times out return;
    if (teller==featureInfoTimeOut){
        teller=0;
        return;
    }
    //if the admindata window is loaded then update the page (add the featureinfo thats given by the getFeatureInfo request.
    if (usePopup && dataframepopupHandle.contentWindow.writeFeatureInfoData){
        dataframepopupHandle.contentWindow.writeFeatureInfoData(featureInfoData);
        featureInfoData=null;
    }else if (window.frames.dataframe.writeFeatureInfoData){
        window.frames.dataframe.writeFeatureInfoData(featureInfoData);
        featureInfoData=null;
    }else{
        //if the admindata window is not loaded yet then retry after 1sec
        setTimeout("updateGetFeatureInfo()",1000);
    }
}
function flamingo_map1_onIdentifyData(mapId,layerId,data,extent,nrIdentifiedLayers,totalLayers){
    featureInfoData=data;
    teller=0;
    updateGetFeatureInfo();
}
var firstTimeOninit=true;
function flamingo_map1_onInit(){
    showLoading();
    
    if (document.getElementById("treeForm") && navigator.appName=="Microsoft Internet Explorer"){
        document.getElementById("treeForm").reset();
    }
    if(firstTimeOninit){
        firstTimeOninit=false;
        //check / activate the themas that have init status visible
        var newLayersAan = new Array();
        var cookieLayers = new Array();
        if (cookieArray != null) {
            cookieLayers = cookieArray.split(',');
        }
        if(cookieLayers.length == layersAan.length) {
            for(var j=0; j < cookieLayers.length; j++) {
                for (var k=0; k < layersAan.length; k++) {
                    if(layersAan[k].theItem.id == cookieLayers[j]) {
                        newLayersAan[newLayersAan.length] = layersAan[k];
                    }
                }
            }
        } else {
            newLayersAan = layersAan;
        }
        // layer added in reverse order
        // layer with lowest order number should be on top
        // so added last
        for (var i=newLayersAan.length-1; i >=0 ; i--){
            checkboxClick(newLayersAan[i],true);
        }
        for (var i=clustersAan.length-1; i >=0 ; i--){
            clusterCheckboxClick(clustersAan[i], true);
        }

        // activelayer niet meer via cookie zetten!
        //        var activeLayerIdFromCookie = getActiveLayerId(readCookie('activelayer'));
        //        var activeLayerLabelFromCookie = getActiveLayerLabel(readCookie('activelayer'));
        //        activeAnalyseThemaId = setActiveThema(activeLayerIdFromCookie, activeLayerLabelFromCookie, true);
        //if searchExtent is already found (search is faster then Flamingo Init) then use the search extent.
        if (searchExtent!=null){
            flamingoController.getMap("map1").moveToExtent(searchExtent);
        }else{
            //if searchExtent is already found (search is faster then Flamingo Init) then use the search extent.
            if (searchExtent!=null){
                flamingoController.getMap("map1").moveToExtent(searchExtent);
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
            refreshLayer();
        }
    }
    mapInitialized=true;
    doInitSearch();
}
function ie6_hack_onInit(){
    if (navigator.appVersion.indexOf("MSIE") != -1) {
        version = parseFloat(navigator.appVersion.split("MSIE")[1]);
        //alert("version IE: " + version);
        if (version == 6) {
            setTimeout("doOnInit=true; flamingo_map1_onInit();",5000);
        }
    }
}
function moveToExtent(minx,miny,maxx,maxy){
    flamingoController.getMap().moveToExtent({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    }, 0);
}
function setFullExtent(minx,miny,maxx,maxy){
    flamingoController.getMap().setFullExtent({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    });
}
function doIdentify(minx,miny,maxx,maxy){
    flamingoController.getMap().doIdentify({
        minx:minx,
        miny:miny,
        maxx:maxx,
        maxy:maxy
    });
    flamingoController.getFlamingo().callMethod("toolGroup","setTool","identify");
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
function flamingo_map1_onUpdateComplete(mapId){
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

/*Functies voor het zoeken*/

/*Roept dmv ajax een java functie aan die de coordinaten zoekt met de ingevulde zoekwaarden.
**/
function getCoords() {
    document.getElementById("searchResults").innerHTML="Een ogenblik geduld, de zoek opdracht wordt uitgevoerd.....";
    var waarde=null;
    var zoekK=null;
    var zoekT=null;
    var searchFieldFound=true;
    waarde=new Array();
    var zoekVelden=zoekconfiguraties[currentSearchSelectId].zoekVelden;
    for(var i=0; i<zoekVelden.length; i++){
        var searchField=document.getElementById("searchField_"+zoekVelden[i].id);
        waarde[i]=searchField.value;        
    }
    showLoading();

    JZoeker.zoek(zoekconfiguraties[currentSearchSelectId].id,waarde,maxResults,getCoordsCallbackFunction);
//JMapData.getMapCoords(waarde, zoekK, zoekT, minBboxZoeken, maxResults, getCoordsCallbackFunction);
}
/**
 *De callback functie van het zoeken
 *@param values = de gevonden lijst met waarden.
 */
var foundValues=null;
function getCoordsCallbackFunction(values){
    hideLoading();

    foundValues=values;
    var searchResults=document.getElementById("searchResults");
    var sResult = "<br><b>Er zijn geen resultaten gevonden!<b>";
    if (values==null || values.length == 0) {
        searchResults.innerHTML=sResult;
        return;
    }
    /*Controleer of de bbox groter is dan de minimale bbox van de zoeker*/
    for (var i=0; i < values.length; i++){
        values[i]=getBboxMinSize(values[i]);
    }
    if (values.length > 1){
        if (values.length<maxResults) {
            sResult = "<br><b>Meerdere resultaten gevonden:<b><ol>";
        } else {
            sResult = "<br><b>Meer dan "+maxResults+" resultaten gevonden. Er worden slechts "+maxResults+" resultaten weergegeven:<b><ol>";
        }
        for (var i =0; i < values.length; i++){
            sResult += "<li><a href='#' onclick='javascript: handleSearchResult("+i+")'>"+values[i].label+"</a></li>";
        }
        sResult += "</ol>";
    } else {
        sResult = "<br><b>Locatie gevonden:<br>" + values[0].label + "<b>";
    }
    searchResults.innerHTML=sResult;
    if (values.length==1)
        handleSearchResult(0);
}

function getBboxMinSize(feature){
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
/*Handel het resultaat af*/
function handleSearchResult(searchResultId){
    var searchResult=foundValues[searchResultId];
    //zoom naar het gevonden object.(als er een bbox is)
    if (searchResult.minx)
        moveToExtent(searchResult.minx, searchResult.miny, searchResult.maxx, searchResult.maxy);
    var zoekConfiguratie=searchResult.zoekConfiguratie;
    //kijk of de zoekconfiguratie waarmee de zoekopdracht is gedaan nog kinderen heeft.
    var childs=getChildzoekConfiguraties(zoekConfiguratie);
    if (childs.length==0){
        return;
    }else if (childs.length > 1){
        alert("Zoekconfiguratie heeft meerdere kinderen. Dit is momenteel niet mogelijk. De eerste wordt gebruikt voor het verder zoeken");
    }
    var child=childs[0];
    document.getElementById("searchResults").innerHTML+="<br><b>Bezig met "+child.naam +" voor "+searchResult.label+"</b>";
    if (child.zoekVelden==undefined || child.zoekVelden.length==0){
        alert("Geen zoekvelden geconfigureerd voor zoekconfiguratie child met id: "+child.id);
    }
    
    /*Maak een nieuwe zoekopdracht voor het kind.
     *Haal eerst de door de gebruiker ingevulde zoekvelden op.
     *Als er niks is ingevuld (of er is geen zoekveld geplaatst), 
     *vergelijk dan de gevondenAttributen met de zoekvelden van het kind.
     *Als het type gelijk is van beide vul dan de gevonden waarde in voor het zoekveld.
     */
    var zoekStrings= new Array();
    var gevondenResultIds=new Array();
    for (var i=0; i < child.zoekVelden.length; i++){
        //haal de waarde van het ingevulde zoekveld op dat bij dit zoekveld hoort
        zoekStrings[i]="";
        var zoekVeld=child.zoekVelden[i];
        if(document.getElementById("searchField_"+zoekVeld.id)){
            zoekStrings[i]=document.getElementById("searchField_"+zoekVeld.id).value;
        }
        //als het zoekveld leeg was probeer dan een waarde uit de vorige zoekopdracht te halen.
        if (zoekStrings[i].length==0){
            for (var b=0; b  < searchResult.attributen.length;  b++){
                var searchedAttribuut=searchResult.attributen[b];
                //als een resultaat al gebruikt is niet nogmaals gebruiken. Controleer tevens op type.
                if (!arrayContains(gevondenResultIds,searchedAttribuut.id) && zoekVeld.type == searchedAttribuut.type){
                    gevondenResultIds.push(searchedAttribuut.id);
                    zoekStrings[i]=searchedAttribuut.waarde;
                }
            }
        }
    }
    JZoeker.zoek(child.id,zoekStrings,maxResults,getCoordsCallbackFunction);
}
/*Geeft de kinderen van deze zoekconfiguratie terug (als die er zijn)*/
function getChildzoekConfiguraties(zoekconfiguratie){
    var childs= new Array();
    for (var i=0; i < zoekconfiguraties.length; i++){
        if (zoekconfiguraties[i].parentZoekConfiguratieId && zoekconfiguratie.id==zoekconfiguraties[i].parentZoekConfiguratieId){
            childs.push(zoekconfiguraties[i]);
        }
    }

    return childs;
}
/**
 *Maak voor de meegegeven zoekconfiguratie een string met daarin html voor de zoekvelden.
 *Bepaalde typen moeten niet getoond worden zoals: Geometry (3)
 */
function createZoekConfiguratieVelden(zc){
    var zoekVelden=zc.zoekVelden;
    var s="";
    for (var i=0; i < zoekVelden.length; i++){
        if (zoekVelden[i].type!=3){
            s+='<b>'+zoekVelden[i].label+':</b><br/>';
            s+='<input type="text" id="searchField_'+zoekVelden[i].id+'" name="'+zoekVelden[i].attribuutnaam+'" size="40"/><br/>'
        }
    }
    return s;
}
var currentSearchSelectId;
function searchSelectChanged(element){
    var container=document.getElementById("searchInputFieldsContainer");
    if (currentSearchSelectId == element.value){
        return;
    }else if(element.value==""){
        currentSearchSelectId="";
        container.innerHTML="";
        return;
    }
    currentSearchSelectId=element.value;
    var s="";
    s+=createZoekConfiguratieVelden(zoekconfiguraties[currentSearchSelectId]);
    var childs=getChildzoekConfiguraties(zoekconfiguraties[currentSearchSelectId]);
    for (var i=0; i < childs.length; i++){
        s+=createZoekConfiguratieVelden(childs[i])
    }
    s+='<input type="button" value=" Zoek " onclick="getCoords();" class="knop" />';
    container.innerHTML=s;
    var searchFieldFound=true;
    //add a onkeyup event to the created input fields
    var zoekVelden=zoekconfiguraties[currentSearchSelectId].zoekVelden;
    for(i=0; i<zoekVelden.length; i++){
        var searchField=document.getElementById("searchField_"+zoekVelden[i].id);
        if (searchField){
            searchField.onkeyup=function(ev){
                getCoordsOnEnterKey(ev);
            };
        }
    }
}

function getCoordsOnEnterKey(ev){
    var sourceEvent;
    if(ev)			//Moz
    {
        sourceEvent= ev.target;
    }

    if(window.event)	//IE
    {
        sourceEvent=window.event.srcElement;
    }
    var keycode;
    if(ev)			//Moz
    {
        keycode= ev.keyCode;
    }
    if(window.event)	//IE
    {
        keycode = window.event.keyCode;
    }
    if (keycode==13){
        getCoords();
    }
}
/*Einde zoek functies*/

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
        //alert(" key: "+i + " value: "+themaList[i]);
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
var lastGetMapRequest="";
function flamingo_map1_fmcLayer_onRequest(mc, type, requestObject){
    if(requestObject && requestObject.url){
        if (requestObject.requesttype=="GetMap"){
            //if (requestObject.url.toLowerCase().indexOf("getmap")){
            lastGetMapRequest=requestObject.url;
        //}
        }
    }
}
function exportMap(){
    if (lastGetMapRequest.length==0){
        alert("Nog geen kaart geladen, wacht tot de kaart geladen is.");
        return;
    }
    if(exportMapWindow==undefined || exportMapWindow==null || exportMapWindow.closed){
        // exportMapWindow=popUp("createmappdf.do", "exportMapWindow", 620, 620, false);
        exportMapWindow=window.open("createmappdf.do", "exportMapWindow");
        exportMapWindow.focus();
    }else{
        exportMapWindow.setMapImageSrc(lastGetMapRequest);
    }
}

function checkboxClickById(id){
    var el2=document.getElementById(id);
    if (el2) {
        el2.checked=!el2.checked;
        checkboxClick(el2,false);
    }
}

function flamingo_b_getfeatures_onEvent(id,event) {
    if (event["down"]) {
        var object = flamingoController.getEditMap().getActiveFeature();

        if (object == null)
        {
            handler("U heeft geen polygoon geselecteerd.");
            return;
        }

        wkt = object.wktgeom;

        if (wkt) {
            document.getElementById('start_message').style.display = 'none';
            document.getElementById('algdatavak').style.display = 'block';

            var loadingStr = "Bezig met laden...";
            document.getElementById('kadastraledata').innerHTML = loadingStr;
            handleGetAdminData(wkt);
        }
    }
}

/* Buffer functies voor aanroep back-end en tekenen buffer op het scherm */
function flamingo_b_buffer_onEvent(id, event) {
    if (event["down"])
    {
        var wkt = "";

        var object = flamingoController.getEditMap().getActiveFeature();

        if (object == null)
        {
            handler("U heeft geen polygoon geselecteerd.");
            return;
        }

        wkt = object.wktgeom;

        var str = prompt('Geef de bufferafstand in meters');
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
}

function returnBuffer(wkt) {

    if (wkt.length > 0)
    {
        var polyObject = new Object();

        polyObject["id"]=61501;
        polyObject["wktgeom"]=wkt;

        drawBufferPolygon(polyObject);
    }
}

function drawBufferPolygon(poly) {
    flamingo.call("editMap", 'removeAllFeatures');
    flamingo.callMethod("editMap", "addFeature", "layer1", poly);
}

function flamingo_b_removePolygons_onEvent(id, event) {
    if (event["down"])
    {
        flamingo.call("editMap", 'removeAllFeatures');
    }
}

function dispatchEventJS(event, comp) {

    if (event=="onGetCapabilities")
        hideLoading();
}