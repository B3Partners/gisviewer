var enabledLayerItems= new Array();

var layerUrl=""+kburl;
var cookieArray = readCookie('checkedLayers');

var activeAnalyseThemaId = '';
var activeClusterId='';
var activeAnalyseThemaTitle = '';

var featureInfoData=null;

var layersAan= new Array();
var clustersAan = new Array();
var checkboxArray = new Array();
var clusterCheckboxArray = new Array();
var timeouts=0;
var featureInfoTimeOut=30;
//timestamp in days
var timestamp=(Math.floor(new Date().getTime()/86400000));


var flamingoController= new FlamingoController(flamingo,'flamingoController');
flamingoController.createMap("map1");
//flamingoController.createEditMap("editMap");
//flamingoController.setRequestListener("requestIsDone");
//flamingoController.getMap().enableLayerRequestListener();


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
    var checkedThemaIds;
    if (!multipleActiveThemas){
        checkedThemaIds = activeAnalyseThemaId;
    } else {
        checkedThemaIds = getArrayAsString();
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
        document.forms[0].themaid.value = getArrayAsString();
    }
    document.forms[0].lagen.value='';
    //document.forms[0].xcoord.value=x;
    //document.forms[0].ycoord.value=y;
    /*var coordsVal='';
    for (var i=0; i < coords.length; i++){
        if (i!=0){
            coordsVal+=","
        }
        coordsVal+=coords[i];
    }
    document.forms[0].coords.value=coordsVal;*/
    document.forms[0].geom.value=geom;
    document.forms[0].scale.value=flamingo.call("map1", "getCurrentScale");
    document.forms[0].tolerance.value=tolerance;
    if(usePopup) {
        // open popup when not opened en submit form to popup
        if(dataframepopupHandle == null || dataframepopupHandle.closed) dataframepopupHandle = popUpData('dataframepopup', '680', '225');
        document.forms[0].target = 'dataframepopup';
    } else {
        document.forms[0].target = 'dataframe';
    }
    document.forms[0].submit();
}

function openUrlInIframe(url){
    var iframe=document.getElementById("dataframe");
    iframe.src=url;
}

function popUp(URL, naam, width, height) {
    var screenwidth = 600;
    var screenheight = 500;
    if (width){
        screenwidth=width;
    }
    if (height){
        screenheight=height;
    }
    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
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
    return eval("page" + naam + " = window.open(URL, '" + naam + "', properties);");
}

function popUpData(naam, width, height) {
    var screenwidth = width;
    var screenheight = height;
    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
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
    if (((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) && (activeClusterId==null || activeClusterId.length==0))|| overrule){
        var atlabel = document.getElementById('actief_thema');
        if (atlabel!=null && item.title!=null){
            activeClusterId=item.id;
            activeAnalyseThemaTitle = item.title;
            atlabel.innerHTML = 'Actieve thema: ' + item.title;
        }
    }
}
function setActiveThema(id, label, overrule) {
    var atlabel;
    if (((activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0) && (activeClusterId==null || activeClusterId.length==0)) || overrule){
        activeAnalyseThemaId = id;
        activeAnalyseThemaTitle = label;

        atlabel = document.getElementById('actief_thema');
        if (atlabel!=null && label!=null)
            atlabel.innerHTML = 'Actieve thema: ' + label;

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
    if (obj!=undefined && obj.theItem!=undefined) {
        createCookie('activelayer', obj.theItem.id + '##' + obj.theItem.title, '7');
        setActiveThema(obj.theItem.id, obj.theItem.title, true);
        activateCheckbox(obj.theItem.id);
        deActivateCheckbox(oldActiveThemaId);

        if (obj.theItem.metadatalink && obj.theItem.metadatalink.length > 1) {
            if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=obj.theItem.metadatalink;
        }
    }
}

function isActiveItem(item) {
    if (item==undefined) {
        return false;
    }
    if(item.analyse=="on"){
        setActiveThema(item.id, item.title);
    } else if(item.analyse=="active"){
        setActiveThema(item.id, item.title, true);
    }
    return (activeAnalyseThemaId == item.id);
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

var prevRadioButton = null;
function createLabel(container, item) {
    if(item.cluster) {
        //if callable
        if (item.callable){
            var checkbox= createCheckboxCluster(item);
            //add the real(not filtered) item to the checkbox.
            checkbox.theItem=treeview_findItem(themaTree,item.id);
            container.appendChild(checkbox);

            clusterCheckboxArray.push(item.id);
            if (item.visible){
                clustersAan.push(checkbox);
            }
        }
        if (!item.hide_tree || item.callable){
            var lnk = document.createElement('a');
            lnk.innerHTML = item.title ? item.title : item.id;
            lnk.href = '#';
            if (item.metadatalink && item.metadatalink.length > 1)
                lnk.onclick = function(){
                    popUp(item.metadatalink, "metadata")
                };
            container.appendChild(lnk);
//            container.appendChild(document.createTextNode((item.title ? item.title : item.id)));
        }
        if (item.active){
            setActiveCluster(item, true);
            if(item.metadatalink && item.metadatalink.length > 1){
                if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
            }
        }
    } else if (!item.hide_tree) {
        var analyseRadioChecked = false;

        var layerPos = getLayerPosition(item);
        var el;
        var el2;
        if (navigator.appName=="Microsoft Internet Explorer") {
            var radioControleString = '<input type="radio" id="radio' + item.id + '" name="selkaartlaag" value="' + item.id + '"';
            if (isActiveItem(item)) {
                if(item.analyse=="active" && prevRadioButton != null){
                    var rc = document.getElementById(prevRadioButton);
                    if (rc!=undefined && rc!=null) {
                        rc.checked = false;
                    }
                }
            
                radioControleString += ' checked="checked"';
                if (item.metadatalink && item.metadatalink.length > 1) {
                    if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
                }
                prevRadioButton = 'radio' + item.id;
                if (item.analyse=="active") {
                    analyseRadioChecked = true;
                }
            }
            radioControleString += ' onclick="radioClick(this);"';
            radioControleString += '>';
            el = document.createElement(radioControleString);

            var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
            if(layerPos!=0 || analyseRadioChecked )
                checkboxControleString += ' checked="checked"';
            checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false)"';
            checkboxControleString += '>';
            el2 = document.createElement(checkboxControleString);

        } else {
            el = document.createElement('input');
            el.type = 'radio';
            el.name = 'selkaartlaag';
            el.value = item.id;
            el.id = 'radio' + item.id;
            el.onclick = function(){
                radioClick(this);
            }
            if (isActiveItem(item)) {
                if(item.analyse=="active" && prevRadioButton != null){
                    var rc = document.getElementById(prevRadioButton);
                    if (rc!=undefined && rc!=null) {
                        rc.checked = false;
                    }
                }
                el.checked = true;
                prevRadioButton = 'radio' + item.id;
                if (item.metadatalink && item.metadatalink.length > 1) {
                    if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
                }
                if (item.analyse=="active") {
                    analyseRadioChecked = true;
                }
            }

            el2 = document.createElement('input');
            el2.id = item.id;
            el2.type = 'checkbox';
            el2.value = item.id;
            el2.onclick = function(){
                checkboxClick(this, false);
            }
            if(layerPos!=0 || analyseRadioChecked ){
                el2.checked = true;
            }
        }
        if(layerPos!=0 || analyseRadioChecked )
            addItemAsLayer(item);
        if (analyseRadioChecked && layerPos==0){
            layersAan.push(el2);
        }
        el.theItem=item;
        el2.theItem=item;

        if (layerPos<0)
            layersAan.unshift(el2);
        else if (layerPos>0)
            layersAan.push(el2);

        var lnk = document.createElement('a');
        lnk.innerHTML = item.title ? item.title : item.id;
        lnk.href = '#';
        if (item.metadatalink && item.metadatalink.length > 1)
            lnk.onclick = function(){
                popUp(item.metadatalink, "metadata")
            };


        if(item.wmslayers){
            if(item.analyse=="on" || item.analyse=="active"){
            	if (!multipleActiveThemas){
                	container.appendChild(el);
		}
            }
            container.appendChild(el2);
        }
        container.appendChild(document.createTextNode('  '));
        container.appendChild(lnk);
        
    }else if(item.hide_tree && item.visible && item.wmslayers){
        addItemAsLayer(item);
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
    obj.className="activelink";
    for(i in tabbladen) {
        var tabobj = tabbladen[i];
        if(tabobj.id != obj.id) {
            document.getElementById(tabobj.id).className = '';
            document.getElementById(tabobj.contentid).style.display = 'none';
            if(tabobj.extracontent != undefined) {
                for(j in tabobj.extracontent) {
                    document.getElementById(tabobj.extracontent[j]).style.display = 'none';
                }
            }
        } else {
            document.getElementById(tabobj.contentid).style.display = 'block';
            if(tabobj.extracontent != undefined) {
                for(j in tabobj.extracontent) {
                    document.getElementById(tabobj.extracontent[j]).style.display = 'block';
                }
            }
        }
    }
}

function readCookieArrayIntoCheckboxArray() {
    if(cookieArray != null) {
        var tempArr = cookieArray.split(',');
        for(i = 0; i < tempArr.length; i++) {
            checkboxArray[i] = tempArr[i];
        }
        if(checkboxArray.length > 0) {
            var arrayString = getArrayAsString();
            document.forms[0].lagen.value = arrayString;
        } else {
            document.forms[0].lagen.value = 'ALL';
        }
    }
}

function isInCheckboxArray(id) {
    if(checkboxArray == null)
        return false;
    for(i = 0; i < checkboxArray.length; i++) {
        if(checkboxArray[i] == id) {
            return true;
        }
    }
    return false;
}
//called when a checkbox is clicked.
function checkboxClick(obj, dontRefresh) {    
    if(obj.checked) {        
        //add legend
        //add wms layer part
        addItemAsLayer(obj.theItem);        
        //add querylayers
        
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
function addItemAsLayer(theItem){
    //part for cookie
    if(!isInCheckboxArray(theItem.id)) checkboxArray[checkboxArray.length] = theItem.id;
    if(checkboxArray.length > 0) {
        var arrayString = getArrayAsString();
        eraseCookie('checkedLayers');
        createCookie('checkedLayers', arrayString, '7');
    } else {
        eraseCookie('checkedLayers');
    }    
    enabledLayerItems.push(theItem);
    
    //add legend part
    if (!theItem.hide_legend)
        addLayerToVolgorde(theItem);
    //If ther is a orgainization code key then add this to the service url.
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

function removeItemAsLayer(theItem){
    deleteFromArray(theItem);
    if (!theItem.hide_legend)
        removeLayerFromVolgorde(theItem.title, theItem.id + '##' + theItem.wmslayers);
    for (var i=0; i < enabledLayerItems.length; i++){
        if (enabledLayerItems[i].id==theItem.id){
            enabledLayerItems.splice(i,1);
            return;
        }
    }
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
    if (layerUrl!=undefined && layerUrl!=null) {
        var backgroundLayers="";
        var topLayers="";
        var queryLayers="";
        for (var i=0; i < enabledLayerItems.length; i++){
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
        var layersToAdd=backgroundLayers+topLayers;
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
        newLayer.setGetCapabilitiesUrl(capLayerUrl);
        newLayer.setLayers(layersToAdd);
        newLayer.setQuerylayers(queryLayers);
        newLayer.setSrs("EPSG:28992");
        newLayer.setVersion("1.1.1");
        /*TODO: Jytte even controleren:*/
        /*for (var i=0; i < enabledLayerItems.length; i++){
            if (enabledLayerItems[i].maptipfield){
                newLayer.addLayerProperty(new LayerProperty(enabledLayerItems[i].wmslayers, enabledLayerItems[i].maptipfield));
            }
        }*/
        /*Einde TODO*/
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
        document.forms[0].themaid.value = getArrayAsString();
    }

    document.forms[0].analysethemaid.value = activeAnalyseThemaId;

    if(checkboxArray.length > 0) {
        var arrayString = getArrayAsString();
        document.forms[0].lagen.value = arrayString;
        eraseCookie('checkedLayers');
        createCookie('checkedLayers', arrayString, '7');
    } else {
        eraseCookie('checkedLayers');
        document.forms[0].lagen.value = 'ALL';
    }
    //document.forms[0].xcoord.value = x;
    //document.forms[0].ycoord.value = y;
    /*var coordsVal='';
    for (var i=0; i < coords.length; i++){
        if (i!=0){
            coordsVal+=","
        }
        coordsVal+=coords[i];
    }
    document.forms[0].coords.value=coordsVal;*/
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

function getArrayAsString() {
    var ret = "";
    var firstTime = true;
    for(var i = 0; i < checkboxArray.length; i++) {
        if(firstTime) {
            ret += checkboxArray[i];
            firstTime = false;
        } else {
            ret += "," + checkboxArray[i];
        }
    }
    return ret;
}

function deleteFromArray(theItem) {
    if(checkboxArray.length == 1 && checkboxArray[0] == theItem.id) checkboxArray = new Array();
    var tempArray = new Array();
    var j = 0;
    for(i = 0; i < checkboxArray.length; i++) {
        if(checkboxArray[i] != theItem.id) {
            tempArray[j] = checkboxArray[i];
            j++;
        }
    }
    checkboxArray = tempArray;
    var arrayString = getArrayAsString();
    eraseCookie('checkedLayers');
    createCookie('checkedLayers', arrayString, '7');
}

/*Roept dmv ajax een java functie aan die de coordinaten zoekt met de ingevulde zoekwaarden.
         **/
function getCoords() {
    if (zoekThemaIds.length <= 0){
        return;
    }
    document.getElementById("searchResults").innerHTML="Een ogenblik geduld, de zoek opdracht wordt uitgevoerd.....";
    var waarde=null;
    var zoekK=null;
    var zoekT=null;
    if (aparteZoekThemas){
        var searchFieldFound=true;
        waarde=new Array();
        for(var i=0; searchFieldFound; i++){
            var searchField=document.getElementById("searchField_"+i);
            if (searchField){
                waarde[i]=searchField.value;
                if (zoekK==null)
                    zoekK="";
                else
                    zoekK+=",";
                zoekK+=searchField.name;
            }else{
                searchFieldFound=false;
            }
        }
        zoekT=zoekThemaIds[currentSearchSelectId];
    }
    else{
        waarde = document.getElementById("searchField").value;
        zoekK=zoekKolommen;
        zoekT=zoekThemaIds;
    }
    JMapData.getMapCoords(waarde, zoekK, zoekT, minBboxZoeken, maxResults, getCoordsCallbackFunction);
}

function getCoordsCallbackFunction(values){
    var searchResults=document.getElementById("searchResults");
    var sResult = "<br><b>Er zijn geen resultaten gevonden!<b>";
    if (values!=null && values.length > 0) {
        for (var i=0; i < values.length; i++){
            if (Number(values[i].maxx-values[i].minx) < minBboxZoeken){
                var addX=Number((minBboxZoeken-(values[i].maxx-values[i].minx))/2);
                var addY=Number((minBboxZoeken-(values[i].maxy-values[i].miny))/2);
                values[i].minx=Number(values[i].minx-addX);
                values[i].maxx=Number(Number(values[i].maxx)+Number(addX));
                values[i].miny=Number(values[i].miny-addY);
                values[i].maxy=Number(Number(values[i].maxy)+Number(addY));
            }
        }
        if (values.length > 1){
            var displayLength = values.length;
            if (displayLength<5000) {
                sResult = "<br><b>Meerdere resultaten gevonden:<b><ol>";
            } else {
                displayLenght=5000;
                sResult = "<br><b>Meer dan 5000 resultaten gevonden. Er worden slechts 5000 resultaten weergegeven:<b><ol>";
            }
            for (i =0; i < displayLength; i++){
                sResult += "<li><a href='#' onclick='javascript: moveAndIdentify("+values[i].minx+", "+values[i].miny+", "+values[i].maxx+", "+values[i].maxy+")'>"+values[i].naam+"</a></li>";
            }
            sResult += "</ol>";
        } else {
            sResult = "<br><b>Locatie gevonden:<br>" + values[0].naam + "<b>";
            moveAndIdentify(values[0].minx, values[0].miny, values[0].maxx, values[0].maxy);
        }
    }
    searchResults.innerHTML=sResult;
}
//adds a layer to the legenda
function addLayerToVolgorde(theItem) {    
    var id=theItem.id + '##' + theItem.wmslayers;
    //check if already exists in legend
    for(var i=0; i < orderLayerBox.childNodes.length; i++){
        if(orderLayerBox.childNodes.item(i).id==id){
            return;
        }
    }    
    var legendURL="";
    if (theItem.legendurl!=undefined){
        legendURL=theItem.legendurl;
    }else{
        legendURL=undefined;
    }
    var myImage = new Image();
    myImage.name = theItem.title;
    myImage.id=id;
    myImage.onerror=imageOnerror;
    myImage.onload=imageOnload;

    var spanEl = document.createElement("span");
    spanEl.innerHTML = ' ' + theItem.title + '<br />';
    spanEl.style.color = 'Black';
    spanEl.style.fontWeight = 'bold';

    var div = document.createElement("div");
    div.name=id;
    div.id=id;
    div.title =theItem.title;
    div.className="orderLayerClass";
    div.appendChild(spanEl);
    div.theItem=theItem;
    if(!orderLayerBox.hasChildNodes() || theItem.hide_legend) {
        orderLayerBox.appendChild(div);
    } else {
        //place layer before the background layers.
        if (theItem.background){
            var beforeChild=null;
            for(var i=0; i < orderLayerBox.childNodes.length && beforeChild==null; i++){
                var orderLayerItem=orderLayerBox.childNodes.item(i).theItem;
                if (orderLayerItem){
                    if (orderLayerItem.background){
                        beforeChild=orderLayerBox.childNodes.item(i);
                    }
                }
            }
            if (beforeChild==null){
                orderLayerBox.appendChild(div);
            }else{
                orderLayerBox.insertBefore(div,beforeChild);
            }
        }else{
            orderLayerBox.insertBefore(div, orderLayerBox.firstChild);
        }
    }
    if (legendURL==undefined){
        myImage.onerror();
    }else{
        myImage.src = legendURL+"&timestamp="+timestamp;
    }
    div.onclick=function(){
        selectLayer(this);
    };
    if (theItem.hide_legend && demogebruiker){
        div.style.display="none";
    }
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
        document.getElementById(this.id).appendChild(legendimg);
    }
}
function removeLayerFromVolgorde(name, id) {
    var remel = document.getElementById(id);
    if (remel!=undefined && remel!=null) {
        orderLayerBox.removeChild(remel);
    }
}

function refreshMapVolgorde() {
    parseVolgordeBox();
    refreshLayer();
}

function deleteAllLayers() {
    var totalLength = orderLayerBox.childNodes.length;
    for(var i = (totalLength - 1); i > -1; i--) {
        document.getElementById(splitValue(orderLayerBox.childNodes[i].id)[0]).checked = false;
        orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
    }
    enabledLayerItems=new Array();
    cookieArray = "";
    eraseCookie('checkedLayers');
    createCookie('checkedLayers', cookieArray, '7');
    readCookieArrayIntoCheckboxArray();
    refreshLayer();
}

function parseVolgordeBox() {
    var cookieString = "";
    var layersString = "";
    for(var i = 0; i < orderLayerBox.childNodes.length; i++) {
        cookieString = "," + splitValue(orderLayerBox.childNodes[i].id)[0] + cookieString;
        layersString = "," + splitValue(orderLayerBox.childNodes[i].id)[1] + layersString;
    }
    cookieArray = cookieString.substring(1);
    eraseCookie('checkedLayers');
    createCookie('checkedLayers', cookieArray, '7');
    readCookieArrayIntoCheckboxArray();
}

function splitValue(val) {
    return val.split('##');
}

function resizeTabVak() {
    document.getElementById('tabcontainervakscroll').style.height = document.getElementById('tab_container_td').offsetHeight + 'px';
    document.getElementById('tabcontainervakscroll').style.width = document.getElementById('tab_container_td').offsetWidth + 'px';
    var vakHeight = document.getElementById('tabcontainervakscroll').offsetHeight - 6;
    document.getElementById('volgordeForm').style.height = (vakHeight - 30) + 'px';
    document.getElementById('volgordevak').style.height = vakHeight + 'px';
    document.getElementById('infovak').style.height = vakHeight + 'px';
    document.getElementById('treevak').style.height = (vakHeight + 3) + 'px';
}

function setFirefoxCSS() {
    document.getElementById('layermaindiv').style.overflow = 'visible';
    document.getElementById('treevak').style.overflow = 'visible';
    document.getElementById('volgordevak').style.overflow = 'visible';
    document.getElementById('tabcontainervakscroll').style.overflow = 'auto';
    document.getElementById('tabcontainervakscroll').style.backgroundColor = '#183C56';
}

function resizeVolgordeVakIE() {
    var tdHeight = document.getElementById('tab_container_td').offsetHeight;
    document.getElementById('volgordevak').style.height = (tdHeight-10) + 'px';
    document.getElementById('volgordeForm').style.height = (tdHeight-30) + 'px';
    document.getElementById('orderLayerBox').style.height = (tdHeight-80) + 'px';
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
var activeLayerIdFromCookie = getActiveLayerId(readCookie('activelayer'));
var activeLayerLabelFromCookie = getActiveLayerLabel(readCookie('activelayer'));
setActiveThema(activeLayerIdFromCookie, activeLayerLabelFromCookie);

var activeTab = readCookie('activetab');
if(activeTab != null) {
    switchTab(document.getElementById(activeTab));
} else if (demogebruiker) {
    switchTab(document.getElementById('tab5'));
} else {
    switchTab(document.getElementById('tab1'));
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
    if (usePopup && dataframepopupHandle.writeFeatureInfoData){
        dataframepopupHandle.writeFeatureInfoData(featureInfoData);
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
readCookieArrayIntoCheckboxArray();
var doOnInit= new Boolean("true");
function flamingo_map1_onInit(){
    if (document.getElementById("treeForm") && navigator.appName=="Microsoft Internet Explorer"){
        document.getElementById("treeForm").reset();
    }
    if(doOnInit){
        doOnInit=false;
        //check / activate the themas that have init status visible
        var newLayersAan = new Array();
        if(checkboxArray.length== layersAan.length) {
            for(var j=0; j < checkboxArray.length; j++) {
                for (var k=0; k < layersAan.length; k++) {
                    if(layersAan[k].theItem.id == checkboxArray[j]) {
                        newLayersAan[newLayersAan.length] = layersAan[k];
                    }
                }
            }
        } else {
            newLayersAan = layersAan;
        }
        for (var i=0; i < newLayersAan.length; i++){
            checkboxClick(newLayersAan[i],true);
        }
        for (i=0; i < clustersAan.length; i++){
            clusterCheckboxClick(clustersAan[i], true);
        }

        if (bbox!=null && bbox.length>0 && bbox.split(",").length==4){
            moveToExtent(bbox.split(",")[0],bbox.split(",")[1],bbox.split(",")[2],bbox.split(",")[3]);
        }else{
            if (fullbbox!=null && fullbbox.length>0 && fullbbox.split(",").length==4){
                moveToExtent(fullbbox.split(",")[0],fullbbox.split(",")[1],fullbbox.split(",")[2],fullbbox.split(",")[3]);
            }else{
                moveToExtent(12000,304000,280000,620000);
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
    $("#orderLayerBox").sortable({
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

if(activeAnalyseThemaTitle != '') {
    document.getElementById('actief_thema').innerHTML = 'Actieve thema: ' + activeAnalyseThemaTitle
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
    var i=0;
    if (aparteZoekVelden[currentSearchSelectId]){
        var zoekVelden=zoekKolommen[currentSearchSelectId].split(',');
        var naamVelden=new Array();
        if (naamZoekVelden)
            naamVelden=naamZoekVelden[currentSearchSelectId].split(',');
        for (i=0; i < zoekVelden.length; i++){
            var naamZoekVeld=zoekVelden[i];
            if (naamVelden[i]){
                naamZoekVeld=naamVelden[i];
            }
            s+='<b>'+naamZoekVeld+':</b><br/>';
            s+='<input type="text" id="searchField_'+i+'" name="'+zoekVelden[i]+'" size="40"/><br/>'
        }
    }else{
        s+='<input type="text" id="searchField_'+i+'" name="'+zoekKolommen[currentSearchSelectId]+'" size="40"/>';
    }
    s+='<input type="button" value=" Zoek " onclick="getCoords();" class="knop" />';
    container.innerHTML=s;
    var searchFieldFound=true;
    //add a onkeyup event to the created input fields
    for(i=0; searchFieldFound; i++){
        var searchField=document.getElementById("searchField_"+i);
        if (searchField){
            searchField.onkeyup=function(ev){
                getCoordsOnEnterKey(ev);
            };
        }else{
            searchFieldFound=false;
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
        exportMapWindow=window.open("createmappdf.do");
        exportMapWindow.focus();
    }else{
        exportMapWindow.setMapImageSrc(lastGetMapRequest);
    }
}

/*Instellingen voor barneveld
         **/
function barneveldSettings() {
    /*fmcController.callCommand(new FlamingoCall('containerLeft', 'setVisible', false));
    fmcController.callCommand(new FlamingoCall('containerMain', 'setLeft','0'));
    fmcController.callCommand(new FlamingoCall('containerMain', 'setWidth','100%'));
    fmcController.callCommand(new FlamingoCall('containerMain', 'resize'));

    if (demogebruiker){
        fmcController.callCommand(new FlamingoCall('coordinates', 'setVisible', false));
    }*/
}

function flamingo_EditMapGetFeature_onEditMapGetFeature(MovieClip,activeFeatureWKT){
    //alert(activeFeatureWKT);
    if(activeFeatureWKT != null){
        document.getElementById('start_message').style.display = 'none';
        document.getElementById('algdatavak').style.display = 'block';

        var loadingStr = "Bezig met laden...";
        document.getElementById('kadastraledata').innerHTML = loadingStr;

        var geom = activeFeatureWKT;

        handleGetAdminData(geom);
        loadObjectInfo(geom);
    }
}