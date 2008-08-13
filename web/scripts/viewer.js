var allActiveLayers="";
var layerUrl=null;
var cookieArray = readCookie('checkedLayers');
var activeThemaId = '';
var activeAnalyseThemaId = '';
var layersAan= new Array();    
var activeAnalyseThemaTitle = '';
var checkboxArray = new Array();
var timeouts=0;
function doAjaxRequest(point_x, point_y) {
    if (adresThemaId!=undefined){
        var infoArray = new Array();
        infoArray[0] = "gm_naam";
        infoArray[1] = "bu_naam";
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
    if(activeThemaId == null || activeThemaId == '') {
        alert('Er is geen laag geselecteerd, selecteer eerst een laag om de administratieve data te tonen');
        return;
    }        
    document.forms[0].admindata.value = 't';
    document.forms[0].metadata.value = '';
    document.forms[0].objectdata.value = '';
    document.forms[0].analysedata.value = '';
    document.forms[0].themaid.value = activeThemaId;
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
    document.forms[0].target = 'dataframe';
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
    eval("page" + naam + " = window.open(URL, '" + naam + "', properties);");
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
    if(!multipleActiveThemas){
        var atlabel;
        if (activeThemaId==null || activeThemaId.length == 0 || overrule){
            activeThemaId = id;
            atlabel = document.getElementById('actief_thema');
            if (atlabel!=null && label!=null)
                atlabel.innerHTML = 'Actieve thema: ' + label;
            /*if (document.forms[0] && document.forms[0].xcoord && document.forms[0].ycoord && document.forms[0].xcoord.value.length > 0 && document.forms[0].ycoord.value.length > 0){                    
                    flamingo_map1_onIdentify('',{minx:parseFloat(document.forms[0].xcoord.value), miny:parseFloat(document.forms[0].ycoord.value), maxx:parseFloat(document.forms[0].xcoord.value), maxy:parseFloat(document.forms[0].ycoord.value)})
                }*/
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
    } else {
        atlabel = document.getElementById('actief_thema');
        if (atlabel!=null && label!=null) {
            if(activeThemaId != null && activeThemaId.length > 0) {
                atlabel.innerHTML = 'Actieve thema: Meerdere';
            } else {
                atlabel.innerHTML = 'Actieve thema: Geen';
            }
        }
    }
    return activeThemaId;
}
function addActiveThema(id){
    if(activeThemaId==null ||activeThemaId.length==0){
        activeThemaId=id;
    }else{
        activeThemaId+=","+id
    }
}
function removeActiveThema(id){
    if (activeThemaId){
        if (activeThemaId.indexOf(","+id) >= 0){
            activeThemaId=activeThemaId.replace(","+id,"");
        }else if (activeThemaId.indexOf(id)>= 0){
            activeThemaId=activeThemaId.replace(id,"");
        }
    }        
}

function setActiveAnalyseThema(id) {
    activeAnalyseThemaId = id;
    return activeAnalyseThemaId;
}
    
function setAnalyseData(id, title) {
    eraseCookie('activeanalyselayer');
    createCookie('activeanalyselayer', id, '7');
    setActiveAnalyseThema(id)
    document.getElementById('actief_thema').innerHTML = 'Actieve thema: ' + title;
}

function createLabel(container, item) {
    if(item.cluster) {
        container.appendChild(document.createTextNode((item.title ? item.title : item.id)));
    } else {        
        var analyseRadioChecked = false;
        if(item.analyse=="on"){
            setActiveThema(item.id, item.title);
        } else if(item.analyse=="active"){
            setActiveThema(item.id, item.title, true);
            setActiveAnalyseThema(item.id);
        }
            
        var layerPos = getLayerPosition(item);
        var el;
        var analyseRadio;
        var el2;
        if (navigator.appName=="Microsoft Internet Explorer") {
            var radioControleString = '<input type="radio" name="selkaartlaag" value="' + item.id + '"';
            if (activeThemaId == item.id)
                radioControleString += ' checked="checked"';
            radioControleString += ' onclick="eraseCookie(\'activelayer\');' + 
                ' createCookie(\'activelayer\', \'' + item.id + '##' + item.title + '\', \'7\');' + 
                ' setActiveThema(\'' + item.id + '\', \'' + item.title + '\', true); setAnalyseData(\'' + item.id + '\'); activateCheckbox(\'' + item.id + '\');"';
            radioControleString += '>';
            el = document.createElement(radioControleString);
                
            //  Added
            var analyseRadioControleString = '<input type="radio" name="selanalysekaartlaag" value="' + item.id + '"';
            if (activeAnalyseThemaId == item.id) {
                analyseRadioControleString += ' checked="checked"';
                activeAnalyseThemaTitle = item.title;
                analyseRadioChecked = true;
            }
            analyseRadioControleString += ' onclick="setAnalyseData(\'' + item.id + '\', \'' + item.title + '\'); activateCheckbox(\'' + item.id + '\');"';
            analyseRadioControleString += '>';
            analyseRadio = document.createElement(analyseRadioControleString);
            //  /Added                
                
            var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
            if(layerPos!=0 || analyseRadioChecked)
                checkboxControleString += ' checked="checked"';
            checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false, \'' + item.title + '\')"'; 
            checkboxControleString += '>';
            el2 = document.createElement(checkboxControleString);
                
        } else {
            el = document.createElement('input');
            el.type = 'radio';
            el.name = 'selkaartlaag';
            el.value = item.id;
            el.onclick = function(){eraseCookie('activelayer'); createCookie('activelayer', item.id + '##' + item.title, '7'); setActiveThema(item.id, item.title,true); setAnalyseData(item.id); activateCheckbox(item.id); }
            if (activeThemaId == item.id)
                el.checked = true;
                    
            //  Added
            analyseRadio = document.createElement('input');
            analyseRadio.type = 'radio';
            analyseRadio.name = 'selanalysekaartlaag';
            analyseRadio.value = item.id;
            analyseRadio.onclick = function(){ setAnalyseData(item.id, item.title); activateCheckbox(item.id); }
            if (activeAnalyseThemaId == item.id) {
                analyseRadio.checked = true;
                activeAnalyseThemaTitle = item.title;
                analyseRadioChecked = true;
            }
            //  /Added 

            el2 = document.createElement('input');
            el2.id = item.id;
            el2.type = 'checkbox';
            el2.value = item.id;
            el2.onclick = function(){checkboxClick(this, false, item.title);}
            if(layerPos!=0 || analyseRadioChecked)
                el2.checked = true;
        }
            
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
            
        if(item.analyse=="on" || item.analyse=="active"){
            if (!multipleActiveThemas){
                container.appendChild(el);
            } else {
                container.appendChild(analyseRadio);
            }
        }
            
        if(item.wmslayers){
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

function checkboxClick(obj, dontRefresh, obj_name) {
    if(obj.checked) {
        if (multipleActiveThemas && (obj.theItem.analyse=="on" || obj.theItem.analyse=="active")){
            addActiveThema(obj.value);
        }
        if(!isInCheckboxArray(obj.value)) checkboxArray[checkboxArray.length] = obj.value;
        var legendURL=""+kburl;
        if(legendURL.indexOf('?')> 0)
            legendURL+='&';
        else
            legendURL+='?';
        legendURL +='SERVICE=WMS&STYLE=&REQUEST=GetLegendGraphic&VERSION=1.1.1&FORMAT=image/png&LAYER=' + obj.theItem.wmslegendlayer;            
        addLayerToVolgorde(obj_name, obj.value + '##' + obj.theItem.wmslayers, legendURL);
            
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
        if (multipleActiveThemas){
            removeActiveThema(obj.value);
        }
        deleteFromArray(obj);
        removeLayerFromVolgorde(obj_name, obj.value + '##' + obj.theItem.wmslayers);
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
    document.forms[0].objectdata.value = 't';
    document.forms[0].analysedata.value = '';
    document.forms[0].themaid.value = activeThemaId;
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

function createCookie(name,value,days) {
    if(useCookies){
        if (days) {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            var expires = "; expires="+date.toGMTString();
        }
        else var expires = "";
        document.cookie = name+"="+value+expires+"; path=/";
    }
}

function readCookie(name) {
    if(useCookies){
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
    }
    return null;

}

function eraseCookie(name) {
    if(useCookies){
        createCookie(name,"",-1);
    }
}

function getCoords() {
    var waarde = document.getElementById("locatieveld").value;
    document.getElementById("searchResults").innerHTML="Een ogenblik geduld, de zoek opdracht wordt uitgevoerd.....";
        
    var infoArray = new Array();
    infoArray[0] = "gm_naam";
    infoArray[1] = "bu_naam";
    JMapData.getMapCoords(waarde, infoArray, "wijk_2006_cbs", 1000, 28992, getCoordsCallbackFunction);
}

function getCoordsCallbackFunction(values){
    var searchResults=document.getElementById("searchResults");
    var sResult = "<br><b>Er zijn geen resultaten gevonden!<b>";
    if (values!=null && values.length > 0) {
        if (values.length > 1){
            var displayLength = values.length;
            if (displayLength<6) {
                sResult = "<br><b>Meerdere resultaten gevonden:<b><ol>";
            } else {
                displayLength = 6;
                sResult = "<br><b>Er worden slechts 6 resultaten weergegeven:<b><ol>";
            }
            for (var i =0; i < displayLength; i++){
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
    myImage.src = legendURL;   
     
}
function imageOnerror(){
    this.style.height='0'; 
    this.style.width='0';
    this.height=0;
    this.width=0;
    var spanEl = document.createElement("span");
    spanEl.innerHTML = ' ' + this.name + '<br />';
    spanEl.style.color = 'Black';
    spanEl.style.fontWeight = 'bold';

    var div = document.createElement("div");
    div.name=this.id;
    div.id=this.id;
    div.title = this.name;
    div.className="orderLayerClass";
    div.onclick=function(){selectLayer(this);};
    div.appendChild(spanEl);    
    if(!orderLayerBox.hasChildNodes()) {
        orderLayerBox.appendChild(div);
    } else {
        orderLayerBox.insertBefore(div, orderLayerBox.firstChild);
    }
}
function imageOnload(){
    var legendimg = document.createElement("img");
    legendimg.src = this.src;
    legendimg.onerror=this.onerror;        
    legendimg.style.border = '0px none White';
    
    if(parseInt(this.height) > 5){
        legendimg.alt = this.name;  
    } 
    if(parseInt(this.height) > 5){
        legendimg.title = this.name;  
    }        

    var spanEl = document.createElement("span");
    spanEl.innerHTML = ' ' + this.name + '<br />';
    spanEl.style.color = 'Black';
    spanEl.style.fontWeight = 'bold';

    var div = document.createElement("div");
    div.name=this.id;
    div.id=this.id;
    div.title = this.name;
    div.className="orderLayerClass";
    div.onclick=function(){selectLayer(this);};
    if (parseInt(this.height) <= 5){
        div.appendChild(spanEl);
    }else{
        div.appendChild(legendimg);
    }
    if(!orderLayerBox.hasChildNodes()) {
        orderLayerBox.appendChild(div);
    } else {
        orderLayerBox.insertBefore(div, orderLayerBox.firstChild);
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
    var firstTime = true;
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

function resizeTabVak(resized) {
    var plusValue = 0;
    if(!resized) plusValue = 3;
    document.getElementById('tabcontainervakscroll').style.height = (document.getElementById('tab_container_td').offsetHeight + plusValue) + 'px';
    document.getElementById('tabcontainervakscroll').style.width = document.getElementById('tab_container_td').offsetWidth + 'px';
    var vakHeight = document.getElementById('tabcontainervakscroll').offsetHeight - 6;
    document.getElementById('volgordeForm').style.height = (vakHeight - 30) + 'px';
    document.getElementById('volgordevak').style.height = vakHeight + 'px';
    document.getElementById('infovak').style.height = vakHeight + 'px';
    document.getElementById('treevak').style.height = (vakHeight + 3) + 'px';
}
if(navigator.userAgent.indexOf("Firefox")!= -1) {
    document.getElementById('layermaindiv').style.overflow = 'visible';
    document.getElementById('treevak').style.overflow = 'visible';
    document.getElementById('volgordevak').style.overflow = 'visible';
    document.getElementById('tabcontainervakscroll').style.overflow = 'auto';
    document.getElementById('tabcontainervakscroll').style.backgroundColor = '#183C56';
    resizeTabVak(false);
       
    window.onresize = function() {  
        document.getElementById('tabcontainervakscroll').style.height = '1px';
        document.getElementById('tabcontainervakscroll').style.width = '1px';
        resizeTabVak(true);
    }
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
    
var activeAnalyseLayerIdFromCookie = readCookie('activeanalyselayer');     
setActiveAnalyseThema(activeAnalyseLayerIdFromCookie);
    
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
            checkboxClick(newLayersAan[i],true,newLayersAan[i].theItem.title);
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