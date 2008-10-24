var allActiveLayers="";
var layerUrl=null;
var cookieArray = readCookie('checkedLayers');

var activeAnalyseThemaId = '';
var activeAnalyseThemaTitle = '';

var layersAan= new Array();    
var checkboxArray = new Array();
var timeouts=0;

function doAjaxRequest(point_x, point_y) {
    if (adresThemaId!=undefined){        
        JMapData.getData(point_x, point_y, infoArray, adresThemaId, 100, 28992, handleGetData);
    }
}

function handleGetData(str) {
    var rd = "X: " + str[0] + "<br />" + "Y: " + str[1];
    var adres = str[3] + ", " + str[4]; // + " (afstand: " + str[2] + " m.)"
    document.getElementById('rdcoords').innerHTML = rd;
    document.getElementById('kadastraledata').innerHTML = adres;
}

function handleGetAdminData(coords) {
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
    var coordsVal='';
    for (var i=0; i < coords.length; i++){
        if (i!=0){
            coordsVal+=","
        }
        coordsVal+=coords[i];
    }
    document.forms[0].coords.value=coordsVal;
    document.forms[0].scale.value=flamingo.call("map1", "getCurrentScale");
    if(usePopup) {
        // open popup when not opened en submit form to popup
        if(dataframepopupHandle == null || dataframepopupHandle.closed) dataframepopupHandle = popUpData('dataframepopup', '900', '500');
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
        
function popUp(URL, naam) {
    var screenwidth = 600;
    var screenheight = 500;
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

function setActiveThema(id, label, overrule) {
    var atlabel;
    if (activeAnalyseThemaId==null || activeAnalyseThemaId.length == 0 || overrule){
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
            flamingo_map1_onIdentify('',{minx:minx, miny:miny, maxx:maxx, maxy:maxy})
        }
    } 
    return activeAnalyseThemaId;
}
    
function radioClick(obj) {
    eraseCookie('activelayer'); 
    createCookie('activelayer', obj.theItem.id + '##' + obj.theItem.title, '7'); 
    setActiveThema(obj.theItem.id, obj.theItem.title, true); 
    activateCheckbox(obj.theItem.id);
}

function isActiveItem(item) {
    if(item.analyse=="on"){
        setActiveThema(item.id, item.title);
    } else if(item.analyse=="active"){
        setActiveThema(item.id, item.title, true);
    }
    return (activeAnalyseThemaId == item.id);
}

function createLabel(container, item) {
    if(item.cluster) {
        container.appendChild(document.createTextNode((item.title ? item.title : item.id)));
    } else {        
        var analyseRadioChecked = false;
            
        var layerPos = getLayerPosition(item);
        var el;
        var el2;
        if (navigator.appName=="Microsoft Internet Explorer") {
            var radioControleString = '<input type="radio" name="selkaartlaag" value="' + item.id + '"';
            if (isActiveItem(item)) {
                radioControleString += ' checked="checked"';
                analyseRadioChecked = true;
            }
            radioControleString += ' onclick="radioClick(this);"';
            radioControleString += '>';
            el = document.createElement(radioControleString);
                
            var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
            if(layerPos!=0 || analyseRadioChecked)
                checkboxControleString += ' checked="checked"';
            checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false)"'; 
            checkboxControleString += '>';
            el2 = document.createElement(checkboxControleString);
                
        } else {
            el = document.createElement('input');
            el.type = 'radio';
            el.name = 'selkaartlaag';
            el.value = item.id;
            el.onclick = function(){radioClick(this);  }
            if (isActiveItem(item)) {
                el.checked = true;
                analyseRadioChecked = true;
            }

            el2 = document.createElement('input');
            el2.id = item.id;
            el2.type = 'checkbox';
            el2.value = item.id;
            el2.onclick = function(){checkboxClick(this, false);}
            if(layerPos!=0 || analyseRadioChecked)
                el2.checked = true;
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
            lnk.onclick = function(){popUp(item.metadatalink, "metadata")}; 
            
            
        if(item.wmslayers){
            if(item.analyse=="on" || item.analyse=="active"){
                container.appendChild(el);
            }
            container.appendChild(el2);
        }
        container.appendChild(document.createTextNode('  '));
        container.appendChild(lnk);
    }
}
    
function activateCheckbox(id) {
    var obj = document.getElementById(id);
    if(!obj.checked)
        document.getElementById(id).click();
}

function switchTab(obj) {
    eraseCookie('activetab');
    createCookie('activetab', obj.id, '7');
    document.getElementById('tab0').className = '';
    document.getElementById('tab1').className = '';
    document.getElementById('tab2').className = '';
    document.getElementById('tab3').className = '';
    document.getElementById('tab4').className = '';
    obj.className="activelink";
    document.getElementById('treevak').style.display = 'none';
    document.getElementById('layermaindiv').style.display = 'none';
    document.getElementById('infovak').style.display = 'none';
    document.getElementById('objectvakViewer').style.display = 'none';
    document.getElementById('analysevakViewer').style.display = 'none';
    document.getElementById('volgordevak').style.display = 'none';
    if(obj.id == "tab0") {
        document.getElementById('treevak').style.display = 'block';
        document.getElementById('layermaindiv').style.display = 'block';
    } else if(obj.id == "tab1") {
        document.getElementById('infovak').style.display = 'block';
    } else if(obj.id == "tab2") {
        document.getElementById('objectvakViewer').style.display = 'block';
    } else if(obj.id == "tab3") {
        document.getElementById('analysevakViewer').style.display = 'block';
    } else if(obj.id == "tab4") {
        document.getElementById('volgordevak').style.display = 'block';
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
    if(checkboxArray == null) return false;
    for(i = 0; i < checkboxArray.length; i++) {
        if(checkboxArray[i] == id) {
            return true;
        }
    }
    return false;
}

function checkboxClick(obj, dontRefresh) {
    if(obj.checked) {
        if(!isInCheckboxArray(obj.value)) checkboxArray[checkboxArray.length] = obj.value;
        var legendURL="";
        if (obj.theItem.wmslegendlayer!=undefined){
            legendURL+=kburl;
            if(legendURL.indexOf('?')> 0)
                legendURL+='&';
            else
                legendURL+='?';
            legendURL +='SERVICE=WMS&STYLE=&REQUEST=GetLegendGraphic&VERSION=1.1.1&FORMAT=image/png&LAYER=' + obj.theItem.wmslegendlayer;            
        }else{
            legendURL=undefined;
        }
        addLayerToVolgorde(obj.theItem.title, obj.value + '##' + obj.theItem.wmslayers, legendURL);
            
        if(checkboxArray.length > 0) {
            var arrayString = getArrayAsString();
            eraseCookie('checkedLayers');
            createCookie('checkedLayers', arrayString, '7');
        } else {
            eraseCookie('checkedLayers');
        }
            
        if (obj.theItem.wmslayers){
            if (layerUrl==null){
                layerUrl=""+kburl; 
                    
            }
            var organizationCodeKey = obj.theItem.organizationcodekey;   
            if(organizationcode!=undefined && organizationcode != null && organizationcode != '' && organizationCodeKey!=undefined && organizationCodeKey != '') {
                if(layerUrl.indexOf(organizationCodeKey)<=0){
                    if(layerUrl.indexOf('?')> 0)
                        layerUrl+='&';
                    else
                        layerUrl+='?';
                    layerUrl = layerUrl + organizationCodeKey + "="+organizationcode;			
                }
            }
            allActiveLayers+= ","+obj.theItem.wmslayers;
            if (!dontRefresh){
                refreshLayerWithDelay();
            }
        }
    } else {
        deleteFromArray(obj);
        removeLayerFromVolgorde(obj.theItem.title, obj.value + '##' + obj.theItem.wmslayers);
        if (obj.theItem.wmslayers){
            allActiveLayers=allActiveLayers.replace(","+obj.theItem.wmslayers,"");
            refreshLayerWithDelay();
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
    var layersToAdd;
    if (allActiveLayers.length>0){
        layersToAdd= allActiveLayers.substring(1);
    }else{
        layersToAdd="";
    }        
    if(layerUrl.toLowerCase().indexOf("?service=")==-1 && layerUrl.toLowerCase().indexOf("&service=" )==-1){
        if(layerUrl.indexOf('?')> 0)
            layerUrl+='&';
        else
            layerUrl+='?';
        layerUrl+="SERVICE=WMS";
    }
    var capLayerUrl=layerUrl;
    var newLayer= "<fmc:LayerOGWMS xmlns:fmc=\"fmc\" id=\"fmcLayer\" timeout=\"30\"" +
        "retryonerror=\"10\" format=\"image/png\" transparent=\"true\" url=\""+layerUrl +
        "\"exceptions=\"application/vnd.ogc.se_inimage\" getcapabilitiesurl=\""+capLayerUrl + 
        "\"styles=\""+
        "\" layers=\""+layersToAdd+
        "\" color_layers=\""+layersToAdd+
        "\" srs=\"EPSG:28992\" version=\"1.1.1\">";
    /* add the highlight layer properties.       
     */
    var layersArray= layersToAdd.split(",");
    for (var i=0; i < layersArray.length; i++){
        if (layersArray[i].length> 0){
            newLayer+='<layer id="'+layersArray[i]+'">';
            newLayer+='<visualisationselected id="';
            newLayer+=layersArray[i]+'" ';
            newLayer+='colorkey="id" fill="#0000ff" fill-opacity="0.5" stroke="#0000ff"/>'
            newLayer+='</layer>';
        }
    }
    newLayer+= "</fmc:LayerOGWMS>";        
    if (flamingo && layerUrl!=null){            
        flamingo.call('map1','removeLayer','fmcLayer');
        flamingo.call('map1','addLayer',newLayer);
    }
}
function loadObjectInfo(coords) {
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
    var coordsVal='';
    for (var i=0; i < coords.length; i++){
        if (i!=0){
            coordsVal+=","
        }
        coordsVal+=coords[i];
    }
    document.forms[0].coords.value=coordsVal;
    document.forms[0].scale.value = '';
    
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

function deleteFromArray(obj) {
    if(checkboxArray.length == 1 && checkboxArray[0] == obj) checkboxArray = new Array();
    var tempArray = new Array();
    var j = 0;
    for(i = 0; i < checkboxArray.length; i++) {
        if(checkboxArray[i] != obj.value) {
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
function getCoords(zoekveldId) {
    if (zoekThemaIds.length>0){
        document.getElementById("searchResults").innerHTML="Een ogenblik geduld, de zoek opdracht wordt uitgevoerd.....";
        var waarde=null;
        var zoekK=null;
        var zoekT=null;
        if (zoekveldId!=undefined){
            waarde = document.getElementById("locatieveld_"+zoekveldId).value;
            zoekK=zoekKolommen[zoekveldId];
            zoekT=zoekThemaIds[zoekveldId];
        }else{
            waarde = document.getElementById("locatieveld").value;
            zoekK=zoekKolommen;
            zoekT=zoekThemaIds;
        }
        JMapData.getMapCoords(waarde, zoekK, zoekT, 1000, 28992, getCoordsCallbackFunction);    
    }
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
            if (displayLength<25) {
                sResult = "<br><b>Meerdere resultaten gevonden:<b><ol>";
            } else {
                displayLenght=25;
                sResult = "<br><b>Meer dan 25 resultaten gevonden. Er worden slechts 25 resultaten weergegeven:<b><ol>";
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

function addLayerToVolgorde(name, id, legendURL) {        
    var myImage = new Image();
    myImage.name = name;
    myImage.id=id;    
    myImage.onerror=imageOnerror;   
    myImage.onload=imageOnload;
    
    var spanEl = document.createElement("span");
    spanEl.innerHTML = ' ' + name + '<br />';
    spanEl.style.color = 'Black';
    spanEl.style.fontWeight = 'bold';

    var div = document.createElement("div");
    div.name=id;
    div.id=id;
    div.title =name;
    div.className="orderLayerClass";    
    div.appendChild(spanEl);    
    if(!orderLayerBox.hasChildNodes()) {
        orderLayerBox.appendChild(div);
    } else {
        orderLayerBox.insertBefore(div, orderLayerBox.firstChild);
    }
    if (legendURL==undefined){
        myImage.onerror();
    }else{
        myImage.src = legendURL;   
    }     
    div.onclick=function(){selectLayer(this);};
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
    var orderLayers=orderLayerBox.childNodes;
    orderLayerBox.removeChild(document.getElementById(id));
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
    allActiveLayers = "";
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
    allActiveLayers = layersString;
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
    var coords = new Array();
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
    }
    handleGetAdminData(coords);
    doAjaxRequest(xp,yp);
    loadObjectInfo(coords);
}
readCookieArrayIntoCheckboxArray();
var doOnInit= new Boolean("true");
function flamingo_map1_onInit(){
    if(doOnInit){
        doOnInit=false;
        var newLayersAan = new Array();
        if(checkboxArray.length == layersAan.length) {            
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
function moveToExtent(minx,miny,maxx,maxy){
    flamingo.callMethod("map1", "moveToExtent", {minx:minx, miny:miny, maxx:maxx, maxy:maxy}, 0);
}
function setFullExtent(minx,miny,maxx,maxy){
    flamingo.callMethod("map1","setFullExtent", {minx:minx, miny:miny, maxx:maxx, maxy:maxy});
}
function doIdentify(minx,miny,maxx,maxy){
    flamingo.callMethod("map1","identify", {minx:minx, miny:miny, maxx:maxx, maxy:maxy});
    // TODO: Ook nog graag tool op Identify zetten, maar hoe?
}
function moveAndIdentify(minx,miny,maxx,maxy){
    moveToExtent(minx,miny,maxx,maxy);
    doIdentify(minx,miny,maxx,maxy);
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