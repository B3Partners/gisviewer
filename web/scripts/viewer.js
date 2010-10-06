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

var flamingoController= new FlamingoController(flamingo,'flamingoController');
flamingoController.createMap("map1");
flamingoController.createEditMap("editMap");
//flamingoController.setRequestListener("requestIsDone");
flamingoController.getMap().enableLayerRequestListener();

var mapInitialized=false;
var searchExtent=null;
var sldSearchServlet=null;
//if searchConfigId is set do a search

var highlightThemaId = null;

var multiPolygonBufferWkt = null;

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
    var kbLayer=flamingoController.getMap("map1").getLayer("fmcLayer");
    kbLayer.setSld(escape(sldUrl));
    if (reload){
        flamingoController.getMap("map1").removeLayerById(kbLayer.getId(), false);
        flamingoController.getMap("map1").addLayer(kbLayer, true, true);
    }
}

function loadBusyJSP() {
    document.getElementById("popupWindow_Title").innerHTML = 'Bezig...';

    dataframepopupHandle.src='admindatabusy.do';

    alert("alert");
}

function handleGetAdminData(/*coords,*/ geom, highlightThemaId) {

    alert("handleGetAdminData");

    //dataframepopupHandle.src='admindatabusy.do';

    if (!usePopup && !useDivPopup && !usePanelControls)
        return;

    showLoading();

    var checkedThemaIds;
    if (!multipleActiveThemas){
        checkedThemaIds = activeAnalyseThemaId;
    } else {
        checkedThemaIds = getLayerIdsAsString();
    }
    if(checkedThemaIds == null || checkedThemaIds == '') {
        
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
    document.forms[0].scale.value=flamingo.call("map1", "getCurrentScale");
    document.forms[0].tolerance.value=tolerance;

    if (highlightThemaId != null)
        document.forms[0].themaid.value = highlightThemaId;

    if (usePopup) {

        // open popup when not opened en submit form to popup
        if(dataframepopupHandle == null || dataframepopupHandle.closed) {

            alert("dataframepopupHandle null or closed");

            if(useDivPopup) {
                dataframepopupHandle = popUpData('dataframedivpopup', 680, 225, true);
            } else {
                dataframepopupHandle = popUpData('dataframepopup', 680, 225, false);
            }
        }

        if(useDivPopup) {
            //$j("#popupWindow").show();
            document.forms[0].target = 'dataframedivpopup';

            loadBusyJSP();
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
            var checkbox = createCheckboxCluster(item, checkboxChecked );

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

// var legendimg = null;
function createTreeLegendIcon() {
    var legendicon = document.createElement("img");
    legendicon.src = imageBaseUrl + "icons/application_view_list.png";
    legendicon.style.border = '0px none White';
    legendicon.alt = "Legenda tonen";
    legendicon.title = "Legenda tonen";
    legendicon.className = 'treeLegendIcon';
    $j(legendicon).click(function(){
        loadTreeLegendImage($j(this).siblings("div").attr("id"));
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
        legendloading.style.border = '0px none White';
        legendloading.alt = "Loading";
        legendloading.title = "Loading";
        legendloading.className = 'legendLoading';

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
    } 
    refresh_timeout_handle = setTimeout("refreshLayer();", refreshDelay);
} 

function refreshLayer() {
	
    var local_refresh_handle = refresh_timeout_handle;

    refreshLegendBox();

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
    for (var i=0; i<enabledLayerItems.length; i++){
        var item = enabledLayerItems[i];
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

    // Lagen opsplitsen in alleen alle achtergrondlagen en alle voorgrondlagen
    // in 2 addlayers of alles apart adden
    if (seperateIntoBackgroundAndNormalLayers) {

        flamingoController.getMap().removeAllLayers(false);
        addLayerToFlamingo("fmctop", layerUrl, backgroundLayerItems);
        addLayerToFlamingo("fmcback", layerUrl, topLayerItems);

    } else {

        // verwijderen ontbrekende layers
        var shownLayers=flamingoController.getMap().getLayers();
        var removedLayers = new Array();
        for (var j=0; j < shownLayers.length; j++){
            var lid = shownLayers[j].getId();
            var found = false;
            for (i=0; i<enabledLayerItems.length; i++){
                item = enabledLayerItems[i];
                if (lid == "fmc" + item.id) {
                    found = true;
                }
            }
            if (!found) {
                removedLayers.push(lid);
            }
        }
        for (var k=0; k < removedLayers.length; k++){
            flamingoController.getMap().removeLayerById(removedLayers[k], false);
        }

        // toevoegen achtergrond layers
        var localLayerItems;
        for (i=0; i<backgroundLayerItems.length; i++){
            item = backgroundLayerItems[i];
            localLayerItems = new Array();
            localLayerItems.push(item);
            addLayerToFlamingo("fmc" + item.id, layerUrl, localLayerItems);
        }
        // toevoegen voorgrond layers
        for (i=0; i<topLayerItems.length; i++){
            item = topLayerItems[i];
            localLayerItems = new Array();
            localLayerItems.push(item);
            addLayerToFlamingo("fmc" + item.id, layerUrl, localLayerItems);
        }
    }

    if (local_refresh_handle != refresh_timeout_handle) {
        // check of dit een goed idee is
        // alleen refresh als er intussen geen nieuwe timeout gezet is
        hideLoading();
        return;
    }
    
    flamingoController.getMap().refreshLayerOrder();
    hideLoading();
// flamingoController.getMap().update();
}

function addLayerToFlamingo(lname, layerUrl, layerItems) {
    //        alert("addLayerToFlamingo: " + lname);
    var capLayerUrl=layerUrl;

    var newLayer= new FlamingoWMSLayer(lname);
    newLayer.setTimeOut("30");
    newLayer.setRetryOnError("10");
    newLayer.setFormat("image/png")
    newLayer.setTransparent(true);
    newLayer.setUrl(layerUrl);
    newLayer.setExceptions("application/vnd.ogc.se_inimage");
    newLayer.setGetcapabilitiesUrl(capLayerUrl);
    newLayer.setSrs("EPSG:28992");
    newLayer.setVersion("1.1.1");
    newLayer.setShowerros(true);

    var theLayers="";
    var queryLayers="";
    var maptipLayers="";
    // last in list will be on top in map
    for (var i=0; i<layerItems.length; i++){
        var item = layerItems[i];
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
            newLayer.addLayerProperty(new LayerProperty(layerItems[i].wmslayers, layerItems[i].maptipfield, aka));
        }
    }

    newLayer.setLayers(theLayers);
    newLayer.setQuerylayers(queryLayers);
    newLayer.setMaptiplayers(maptipLayers);
    flamingoController.getMap().addLayer(newLayer, false, true, false);
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
    refreshLayer();
    syncLayerCookieAndForm();
}

function refreshLegendBox() {
    var totalLength = orderLayerBox.childNodes.length;
    for(var i = (totalLength - 1); i > -1; i--) {
        orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
    }

    for (var i=0; i<enabledLayerItems.length; i++){
        var item = enabledLayerItems[i];
        if (useInheritCheckbox) {
            var object = document.getElementById(item.id);
            /* Item alleen toevoegen aan de layers indien
                 * parent cluster(s) allemaal aangevinkt staan of
                 * geen cluster heeft */
            if (!itemHasAllParentsEnabled(object))
                continue;
        }
        addLayerToLegendBox(item, false);
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

function flamingo_toolGroup_onSetTool(toolgroupId, toolId) {
    if (toolId == 'identify') {
        btn_highLightSelected = false;
    }   
}

//always call this script after the SWF object script has called the flamingo viewer.
//function wordt aangeroepen als er een identify wordt gedaan met de tool op deze map.
function flamingo_map1_onIdentify(movie,extend){

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

    flamingo.callMethod("editMap", 'removeAllFeatures');
    
    if (btn_highLightSelected) {
        flamingo.call("toolGroup", "setTool", "breinaald");

        highLightThemaObject(geom);
    } else {
        btn_highLightSelected = false;
        flamingo.call("toolGroup", "setTool", "identify");

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
function flamingo_map1_onIdentifyData(mapId,layerId,data,extent,nrIdentifiedLayers,totalLayers){
    teller=0;
    updateGetFeatureInfo(data);
}
var firstTimeOninit = true;

function flamingo_map1_onInit(){
    //    showLoading();
    
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
var lastGetMapRequest="";
//function flamingo_map1_fmcLayer_onRequest(mc, type, requestObject){
//    if(requestObject && requestObject.url){
//        if (requestObject.requesttype=="GetMap"){
//            //if (requestObject.url.toLowerCase().indexOf("getmap")){
//            lastGetMapRequest=requestObject.url;
//        //}
//        }
//    }
//}
function exportMap(){
    // ipv flamingo_map1_fmcLayer_onRequest(mc, type, requestObject)
    var layers=flamingoController.getMap().getLayers();
    for (var i=0; i < layers.length; i++){
        alert(layers[i].getLastGetMapRequest());
    }

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

function getWktActiveFeature() {
    var object = flamingoController.getEditMap().getActiveFeature();

    if (object == null)
    {
        handler("Er is nog geen tekenobject op het scherm.");
        return null;
    }

    return object.wktgeom;
}

function getWkt() {
    var object = flamingoController.getEditMap().getActiveFeature();

    if (object == null)
        return null;

    return object.wktgeom;
}

function flamingo_b_getfeatures_onEvent(id,event) {
    if (event["down"]) {
        var wkt = getWktActiveFeature();

        if (wkt) {          
            if (btn_highLightSelected)
                highLightThemaObject(wkt);
            else
                handleGetAdminData(wkt, null);
        }
    }
}

/* Buffer functies voor aanroep back-end en tekenen buffer op het scherm */
function flamingo_b_buffer_onEvent(id, event) {
    if (event["down"])
    {
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

function drawFeature(themaId, attrName, attrVal) {
    alert(themaId+" , "+attrName+" , "+attrVal);
    JMapData.getWkt(themaId, attrName, attrVal, drawWkt);
}

function returnBuffer(wkt) {
    drawWkt(wkt);
}

function drawWkt(wkt) {
    if (wkt.length > 0)
    {
        var polyObject = new Object();

        polyObject["id"]=61502;
        polyObject["wktgeom"]=wkt;

        drawObject(polyObject);
    }
}

function drawObject(geom) {
    flamingo.call("editMap", 'removeAllFeatures');
    flamingo.callMethod("editMap", "addFeature", "layer1", geom);
}

function flamingo_b_removePolygons_onEvent(id, event) {
    if (event["down"])
    {
        flamingo.call("editMap", 'removeAllFeatures');
    }
}

var btn_highLightSelected = false;

/* er is net op de highlight knop gedrukt */
function flamingo_b_highlight_onEvent(id, event) {
    if (event["down"])
    {
        btn_highLightSelected = true;
        flamingo.call("toolGroup", "setTool", "breinaald");

    /*
        if (!event["selected"]) {
            flamingo.callMethod("editMap", 'removeAllFeatures');
            btn_highLightSelected = false;
            flamingo.call("toolGroup", "setTool", "identify");
        } else {
            
        }*/
    }
}

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

        if (item.analyse == 'on' || item.analyse=="active")
            analyseThemas.push(item);
    }

    if (analyseThemas.length > 1) {
        // popupWindowRef = popUp('viewerhighlight.do', 'popupHighlight', 680, 225, true);
        iFramePopup('viewerhighlight.do', false, 'Breinaald popup', 400, 300);
    }

    if (analyseThemas.length == 1) {
        EditUtil.getHighlightWktForThema(analyseThemas[0].id, geom, returnHighlight);
        
        handleGetAdminData(geom, analyseThemas[0].id);
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

    if (showRedliningTools)
        flamingo.callMethod("redLiningContainer", "setVisible", true);

    if (showBufferTool)       
        flamingo.callMethod("b_buffer", "setVisible", true);

    if (showSelectBulkTool)
        flamingo.callMethod("b_getfeatures", "setVisible", true);

    if (showNeedleTool)
        flamingo.callMethod("b_highlight", "setVisible", true);

    /* verwijder polygoon alleen tonen als er een tool is die polygoon
    op het scherm mogelijk maakt */
    if (showRedliningTools || showNeedleTool)
        flamingo.callMethod("b_removePolygons", "setVisible", true);
}

function dispatchEventJS(event, comp) {
    
    if (event=="onGetCapabilities") {
        hideLoading();
    }

    if (event=="onConfigComplete") {
        checkDisplayButtons();
    }
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

        return window.open('', naam, properties);
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
    popupIframe.src = '';
    var popupResizediv = document.createElement('div');
    popupResizediv.id = 'popupWindow_Resizediv';
    popupContent.appendChild(popupIframe);
    popupContent.appendChild(popupResizediv);
    popupDiv.appendChild(popupContent);

    var popupWindowBackground = document.createElement('div');
    popupWindowBackground.styleClass = 'popupWindow_Windowbackground';
    popupWindowBackground.id = 'popupWindow_Windowbackground';

    document.body.appendChild(popupDiv);
    document.body.appendChild(popupWindowBackground);
}

var popupCreated = false;

$j(document).ready(function(){

    /* vullen inhoud analyse tab */
    if(document.getElementById('analyseframeViewer')) {
        document.getElementById('analyseframeViewer').src='/gisviewer/vieweranalysedata.do';
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