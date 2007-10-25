<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/selectbox.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/moveLayers.js"/>"></script>

<script>

    var nr = 0;
    function getNr() {
        return nr++;
    }

    var allActiveLayers="";
    var layerUrl=null;
    function doAjaxRequest(point_x, point_y) {
        JMapData.getData(point_x, point_y, handleGetData);
        JMapData.getKadastraleData(point_x, point_y, handleGetKadastraleData);
    }

    function handleGetData(str) {
        var rd = "X: " + str[0] + "<br />" + "Y: " + str[1];
        document.getElementById('rdcoords').innerHTML = rd;
        document.getElementById('hm_aanduiding').innerHTML = str[2] + " (afstand: " + str[3] + " m.)";
        document.getElementById('wegnaam').innerHTML = str[4];
        document.getElementById('rdcoords').innerHTML = rd;
    }

    function handleGetKadastraleData(str) {
        document.getElementById('kadastraledata').innerHTML = str;
    }

    function handleGetAdminData(x,y) {
        var childs = document.getElementsByName('selkaartlaag');
        var selkaart = null;
        for(i = 0; i < childs.length; i++) {
            if(childs[i].checked) {
                selkaart = childs[i];
            }
        }
        if(selkaart == null) {
            alert('Er is geen laag geselecteerd, selecteer eerst een laag om de administratieve data te tonen');
            return;
        }
        document.forms[0].scale.value=flamingo.call("map1", "getCurrentScale");
        document.forms[0].xcoord.value=x;
        document.forms[0].ycoord.value=y;
        document.forms[0].metadata.value = '';
        document.forms[0].admindata.value = 't';
        document.forms[0].themaid.value = selkaart.value;
        document.forms[0].submit();
    }

    function getMetaData(id) {
        document.forms[0].metadata.value = 't';
        document.forms[0].admindata.value = '';
        document.forms[0].themaid.value = id;
        document.forms[0].submit();
    }

    var cookieArray = readCookie('checkedLayers');
    function isInCookieArray(id) {
        if(cookieArray == null) return false;
        var arr = cookieArray.split(',');
        for(i = 0; i < arr.length; i++) {
            if(arr[i] == id) {
                return true;
            }
        }
        return false;
    }

    var activeThemaId = '';
    function setActiveThema(val) {
        activeThemaId = val;
        if (document.forms[0] && document.forms[0].xcoord && document.forms[0].ycoord && document.forms[0].xcoord.value.length > 0 && document.forms[0].ycoord.value.length > 0){
            map1_onIdentify('',{minx:document.forms[0].xcoord.value, miny:document.forms[0].ycoord.value, maxx:document.forms[0].xcoord.value, maxy:document.forms[0].ycoord.value})
        }
    }

    function setAnalyseValue(x,y) {
        document.forms[2].xcoord.value=x;
        document.forms[2].ycoord.value=y;
        document.forms[2].themaid.value = activeThemaId;
        document.forms[2].submit();
    }


    var layersAan= new Array();
    var doLayerClick= new Boolean(false);
    var activeLayerFromCookie = getActiveLayerId(readCookie('activelayer'));
    setActiveThema(activeLayerFromCookie);
    function createLabel(container, item) {

        doLayerClick=false;
        if(item.cluster)
            container.appendChild(document.createTextNode((item.title ? item.title : item.id)));
        else {
            if(item.analyse && item.analyse=="on"){
                if (navigator.appName=="Microsoft Internet Explorer") {
                    if(activeLayerFromCookie != null && activeLayerFromCookie == item.id) var el = document.createElement('<input type="radio" name="selkaartlaag" value="' + item.id + '" checked="checked" onclick="eraseCookie(\'activelayer\'); createCookie(\'activelayer\', \'' + item.id + '##' + item.title + '\', \'7\'); setActiveThema(\'' + item.id + '\'); setActiveThemaLabel(\'' + item.title + '\');">');
                    else var el = document.createElement('<input type="radio" name="selkaartlaag" value="' + item.id + '" onclick="eraseCookie(\'activelayer\'); createCookie(\'activelayer\', \'' + item.id + '##' + item.title + '\', \'7\'); setActiveThema(\'' + item.id + '\'); setActiveThemaLabel(\'' + item.title + '\');">');
                }
                else {
                    var el = document.createElement('input');
                    el.type = 'radio';
                    el.name = 'selkaartlaag';
                    el.value = item.id;
                    el.onclick = function(){eraseCookie('activelayer'); createCookie('activelayer', item.id + '##' + item.title, '7'); setActiveThema(item.id); setActiveThemaLabel(item.title) }
                    if(activeLayerFromCookie != null && activeLayerFromCookie == item.id) el.checked = true;
                }
            }
            if (navigator.appName=="Microsoft Internet Explorer") {
                if(isInCookieArray(item.id) || (cookieArray==null && item.visible=="on")){
                    var el2 = document.createElement('<input type="checkbox" id="' + item.id + '" checked="checked" value="' + item.id + '" onclick="checkboxClick(this, false, \'' + item.title + '\')">');
                    doLayerClick=true;
                }
                else var el2 = document.createElement('<input type="checkbox" id="' + item.id + '" value="' + item.id + '" onclick="checkboxClick(this, false, \'' + item.title + '\')">');
            }
            else {
                var el2 = document.createElement('input');
                el2.id = item.id;
                el2.type = 'checkbox';
                el2.value = item.id;
                el2.onclick = function(){checkboxClick(this, false, item.title);}
                if(isInCookieArray(item.id) || (cookieArray==null && item.visible=="on")){
                    el2.checked = true;
                    doLayerClick=true;
                }
            }
            el2.theItem=item;
            if (doLayerClick){
                layersAan[layersAan.length]=el2;
            }
            var lnk = document.createElement('a');
            lnk.innerHTML = item.title ? item.title : item.id;
            lnk.href = '#';
            lnk.onclick = function(){ getMetaData(item.id) };
            if(item.wmsquerylayers) {
                container.appendChild(el);
            }
            if(item.wmslayers){
                container.appendChild(el2);
            }
            container.appendChild(document.createTextNode('  '));
            container.appendChild(lnk);


        }
    }

    function getActiveLayerId(cookiestring) {
        if(!cookiestring) return null;
        var items = cookiestring.split('##');
        return items[0];
    }

    function getActiveThemaLabel(cookiestring) {
        if(!cookiestring) return "Geen";
        var items = cookiestring.split('##');
        return items[1];
    }

    function setActiveThemaLabel(activeThemaLabel) {
        document.getElementById('actief_thema').innerHTML = 'Actieve thema: ' + activeThemaLabel;
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
        document.getElementById('objectvak').style.display = 'none';
        document.getElementById('analysevak').style.display = 'none';
        document.getElementById('volgordevak').style.display = 'none';
        if(obj.id == "tab0") {
            document.getElementById('treevak').style.display = 'block';
            document.getElementById('layermaindiv').style.display = 'block';
        } else if(obj.id == "tab1") {
            document.getElementById('infovak').style.display = 'block';
        } else if(obj.id == "tab2") {
            document.getElementById('objectvak').style.display = 'block';
        } else if(obj.id == "tab3") {
            document.getElementById('analysevak').style.display = 'block';
        } else if(obj.id == "tab4") {
            document.getElementById('volgordevak').style.display = 'block';
        }
    }

    var checkboxArray = new Array();
    function readCookieArrayIntoCheckboxArray() {
        if(cookieArray != null) {
            var tempArr = cookieArray.split(',');
            for(i = 0; i < tempArr.length; i++) {
                checkboxArray[i] = tempArr[i];
            }
            if(checkboxArray.length > 0) {
                var arrayString = getArrayAsString();
                document.forms[1].lagen.value = arrayString;
                document.forms[2].lagen.value = arrayString;
            } else {
                document.forms[1].lagen.value = 'ALL';
                document.forms[2].lagen.value = 'ALL';
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
            if(!isInCheckboxArray(obj.value)) checkboxArray[checkboxArray.length] = obj.value;
            var legendURL="${kburl}";
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
                    layerUrl="${kburl}";
                    if(layerUrl.indexOf('?')> 0)
                        layerUrl+='&';
                    else
                        layerUrl+='?';
                    layerUrl+="filter=status_etl%3D'UO'%20or%20status_etl%3D'OO'%20or%20status_etl%3D'NO'";
                }
                allActiveLayers+= ","+obj.theItem.wmslayers;
                if (!dontRefresh){
                    refreshLayer();
                }
            }
        } else {
            //alert("layer uit");
            deleteFromArray(obj);
            removeLayerFromVolgorde(obj_name, obj.value + '##' + obj.theItem.wmslayers);
            if (obj.theItem.wmslayers){
                allActiveLayers=allActiveLayers.replace(","+obj.theItem.wmslayers,"");
                refreshLayer();
            }
        }
    }

    function refreshLayer(){
        var layersToAdd;
        if (allActiveLayers.length>0){
            layersToAdd= allActiveLayers.substring(1);
        }else{
            layersToAdd="";
        }        
        var newLayer= "<fmc:LayerOGWMS xmlns:fmc=\"fmc\" id=\"OG2\" timeout=\"30\"" +
            "retryonerror=\"10\" format=\"image/png\" transparent=\"true\" url=\""+layerUrl +
            "\" getcapabilitiesurl=\""+layerUrl + "&SERVICE=WMS" +
            "\" layers=\""+layersToAdd+"\" query_layers=\""+layersToAdd +
            "\" srs=\"EPSG:28992\" version=\"1.1.1\"/>";
        if (flamingo && layerUrl!=null){
            flamingo.call("map1","removeLayer","fmcLayer");
            flamingo.call("map1","addLayer",newLayer);
        }
    }
    function loadObjectInfo(x,y) {
        if(checkboxArray.length > 0) {
            var arrayString = getArrayAsString();
            document.forms[1].lagen.value = arrayString;
            document.forms[2].lagen.value = arrayString;
            eraseCookie('checkedLayers');
            createCookie('checkedLayers', arrayString, '7');
        } else {
            eraseCookie('checkedLayers');
            document.forms[1].lagen.value = 'ALL';
            document.forms[2].lagen.value = 'ALL';
        }
        document.forms[1].xcoord.value=x;
        document.forms[1].ycoord.value=y;
        document.forms[1].submit();
        setAnalyseValue(x,y);
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
            if (days) {
                    var date = new Date();
                    date.setTime(date.getTime()+(days*24*60*60*1000));
                    var expires = "; expires="+date.toGMTString();
            }
            else var expires = "";
            document.cookie = name+"="+value+expires+"; path=/";
    }

    function readCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for(var i=0;i < ca.length;i++) {
                    var c = ca[i];
                    while (c.charAt(0)==' ') c = c.substring(1,c.length);
                    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
            }
            return null;

    }

    function eraseCookie(name) {
            createCookie(name,"",-1);
    }

    function HideOrShow(controlToHide)
    {
        if (document.getElementById)
        {
            // Hide all regions
            document.getElementById('show1').disabled = true;
            document.getElementById('show2').disabled = true;
            document.getElementById('show3').disabled = true;
            document.getElementById('show1').value = 'search';
            document.getElementById('show2').value = 'search';
            document.getElementById('show3').value = 'search';

            // Display the requested region
            document.getElementById('show' + controlToHide).disabled = false;
            document.getElementById('show' + controlToHide).value = '';
        }
    }

    function getCoords() {
        var postcode = document.getElementById("show1").value;
        var plaatsnaam = document.getElementById("show2").value;
        var n_nr = document.getElementById("show3").value;
        var hm = document.getElementById("show4").value;
        document.getElementById("searchResults").innerHTML="Een ogenblik geduld, de zoek opdracht wordt uitgevoerd.....";
        JMapData.getMapCoords(postcode, plaatsnaam, n_nr, hm, getCoordsCallbackFunction);
    }

    function getCoordsCallbackFunction(values){
        var searchResults=document.getElementById("searchResults");
        searchResults.innerHTML="";
        if (values==null){
            searchResults.innerHTML="Er zijn geen resultaten gevonden";
        }else{
            if (values.length > 1){
                var linkList="Meerdere resultaten gevonden: <br>";
                for (var i =0; i < values.length; i++){
                    linkList+="<a href='#' onclick='javascript: moveToExtent("+values[i].minx+", "+values[i].miny+", "+values[i].maxx+", "+values[i].maxy+")'>"+values[i].naam+"</a><br>";
                }
                searchResults.innerHTML=linkList;
            }
            else{
                moveToExtent(values[0].minx, values[0].miny, values[0].maxx, values[0].maxy);
            }
        }
    }

    function showHide(nr, el) {
        if(nr == 3 || nr == 4) {
            document.getElementById('show1').className= 'inputDisabled';
            document.getElementById('show1').value = '';
            document.getElementById('show2').className= 'inputDisabled'
            document.getElementById('show2').value = '';
            document.getElementById('show3').className = 'inputEnabled';
            document.getElementById('show4').className = 'inputEnabled';
        } else if(nr == 2) {
            document.getElementById('show1').className= 'inputDisabled'
            document.getElementById('show1').value = '';
            document.getElementById('show2').className = 'inputEnabled';
            document.getElementById('show3').className= 'inputDisabled'
            document.getElementById('show3').value = '';
            document.getElementById('show4').className= 'inputDisabled'
            document.getElementById('show4').value = '';
        } else if(nr == 1) {
            document.getElementById('show1').className = 'inputEnabled';
            document.getElementById('show2').className= 'inputDisabled'
            document.getElementById('show2').value = '';
            document.getElementById('show3').className= 'inputDisabled'
            document.getElementById('show3').value = '';
            document.getElementById('show4').className= 'inputDisabled'
            document.getElementById('show4').value = '';
        }
    }

    function eraseSubmit() {
        document.getElementById('show1').value = "";
        document.getElementById('show2').value = "";
        document.getElementById('show3').value = "";
        document.getElementById('show4').value = "";

        document.getElementById('show1').className = 'inputEnabled';
        document.getElementById('show2').className = 'inputEnabled';
        document.getElementById('show3').className = 'inputEnabled';
        document.getElementById('show4').className = 'inputEnabled';

        document.getElementById('show1').disabled = false;
        document.getElementById('show2').disabled = false;
        document.getElementById('show3').disabled = false;
        document.getElementById('show4').disabled = false;
    }

    function addLayerToVolgorde(name, id, legendURL) {      
        var myImage = new Image();
        myImage.name = name;
        myImage.onerror=new Function("this.style.height='0'; this.style.width='0';");        
        myImage.src = legendURL;
        
        var legendimg = document.createElement("img");
        legendimg.src = myImage.src;
        legendimg.onerror=myImage.onerror;        
        legendimg.style.border = '0px none White';
        if(myImage.height != '0') legendimg.alt = name;
        if(myImage.height != '0') legendimg.title = name;
        

        var spanEl = document.createElement("span");
        spanEl.innerHTML = ' ' + name + '<br />';
        spanEl.style.color = 'Black';
        spanEl.style.fontWeight = 'bold';
        
        var div = document.createElement("div");
        div.name=id;
        div.id=id;
        div.title = name;
        div.className="orderLayerClass";
        div.onclick=function(){selectLayer(this);};
        //TODO: Werkt niet omdat de hoogte van een image pas bekend is als hij geladen is.
        //if(myImage.height != '23'){
            div.appendChild(spanEl);
        //}        
        div.appendChild(legendimg);

        if(!orderLayerBox.hasChildNodes()) {
            orderLayerBox.appendChild(div);
        } else {
            orderLayerBox.insertBefore(div, orderLayerBox.firstChild);
        }
    }

    function removeLayerFromVolgorde(name, id) {
        var orderLayers=orderLayerBox.childNodes;
        orderLayerBox.removeChild(document.getElementById(id));
        // for (var i=0; i < orderLayers.length; i++){
        //     if (orderLayers[i].id==id){
        //         orderLayerBox.removeChild(orderLayers[i]);
        //     }
        // }
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
</script>

<script type="text/javascript" src="<html:rewrite page="/scripts/niftycube.js"/>"></script>

<div style="display: none;">
    <form target="dataframe" method="post" action="viewerdata.do">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="themaid" />
        <input type="hidden" name="xcoord" />
        <input type="hidden" name="ycoord" />
        <input type="hidden" name="scale" />
    </form>
    
    <form id="objectdataForm" name="objectdataForm" target="objectframe" method="post" action="viewerdata.do">
        <input type="hidden" name="objectdata" value="t" />
        <input type="hidden" name="lagen" />
        <input type="hidden" name="xcoord" />
        <input type="hidden" name="ycoord" />
    </form>
    
    <form id="analysedataForm" name="analysedataForm" target="analyseframe" method="post" action="viewerdata.do">
        <input type="hidden" name="analysedata" value="t" />
        <input type="hidden" name="themaid" />
        <input type="hidden" name="lagen" />
        <input type="hidden" name="xcoord" />
        <input type="hidden" name="ycoord" />
    </form>
</div>
<div class="onderbalk">VIEWER<span><tiles:insert name="loginblock"/></span></div>
<div id="bovenkant">
    <div id="map">
        <div id="flashcontent">
            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
        </div>
        <script type="text/javascript">
                var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "653", "493", "8", "#FFFFFF");
        </script>
        <!--[if lte IE 6]>
            <script type="text/javascript">
            var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "652", "493", "8", "#FFFFFF");
            </script>
        <![endif]-->
        <script type="text/javascript">
                so.write("flashcontent");
        </script>
    </div>
    
    <div id="rightdiv">
        <div id="tabjes">
            <ul id="nav">
                <li id="tab0" onmouseover="switchTab(this);"><a href="#">Thema's</a></li>
                <li id="tab4" onmouseover="switchTab(this);"><a href="#">Legenda</a></li>
                <li id="tab1" onmouseover="switchTab(this);"><a href="#">Zoeker</a></li>
                <li id="tab2" onmouseover="switchTab(this);"><a href="#">Gebieden</a></li>
                <li id="tab3" onmouseover="switchTab(this);"><a href="#">Analyse</a></li>
            </ul>
        </div>
        <div id="tab_container">
            <div id="treevak" style="display: none;" class="tabvak">
                <div id="layermaindiv" style="display: none;"></div>
            </div>
            
            <div id="volgordevak" style="display: none;" class="tabvak">
                Bepaal de volgorde waarin de kaartlagen getoond worden
                <form>
                    <div id="orderLayerBox" class="orderLayerBox"></div>
                    <input type="button" value="Omhoog" onclick="javascript: moveSelectedUp()" class="knop" />
                    <input type="button" value="Omlaag" onclick="javascript: moveSelectedDown()" class="knop" />
                    <input type="button" value="Kaart herladen" onclick="refreshMapVolgorde();" class="knop" />
                    <input type="button" value="Verwijder alle lagen" onclick="deleteAllLayers();" class="knop" />
                </form>
            </div>
            
            <div id="infovak" style="display: none;" class="tabvak">
                <div id="start_message">
                    Klik op een punt op de kaart voor aanvullende informatie.
                </div>
                
                <div id="algdatavak" style="display: none;">
                    <b>RD Co&ouml;rdinaten</b><br />
                    <span id="rdcoords"></span><br /><br />
                    <b>Hectometer aanduiding</b><br />
                    <span id="hm_aanduiding"></span><br /><br />
                    <b>Wegnaam</b><br />
                    <span id="wegnaam"></span><br /><br />
                    <b>Adres</b><br />
                    <span id="kadastraledata"></span>
                </div>
                
                <!-- input fields for search -->
                <div>
                    <br>
                    <b>Zoek naar locatie:</b>
                    <table>
                        <tr>
                            <td>Postcode:</td>
                            <td><input type="text" id="show1" name="show1" onfocus="showHide(1, this);" size="5"/></td>
                        </tr>
                        <tr>
                            <td>Plaatsnaam:</td>
                            <td><input type="text" id="show2" name="show2" onfocus="showHide(2, this);" size="20"/></td>
                        </tr>
                        <tr>
                            <td>Weg nr / hm:</td>
                            <td>
                                <input type="text" id="show3" name="show3" onfocus="showHide(3, this);" size="5"/> /
                                <input type="text" id="show4" name="show4" onfocus="showHide(4, this);" size="5"/>
                            </td>
                        </tr>
                    </table>
                    
                    <input type="button" value="Ga naar locatie" onclick="getCoords();" class="knop" />&nbsp;
                    <input type="button" value="Wis invoer" onclick="eraseSubmit();" class="knop" /><br />
                    <div class="searchResultsClass" id="searchResults"></div>
                    
                </div>
                <!-- end of search -->
            </div>
            
            <div id="objectvak" style="display: none;" class="tabvak_with_iframe">
                <iframe id="objectframe" name="objectframe" frameborder="0" src="empty_iframe.jsp"></iframe>
            </div>
            <div id="analysevak" style="display: none;" class="tabvak_with_iframe">
                <iframe id="analyseframe" name="analyseframe" frameborder="0" src="empty_iframe.jsp"></iframe>
            </div>
        </div>
    </div>
</div>
<div class="onderbalk">DETAILS<span id="actief_thema">Actieve thema: </span></div>
<div id="dataframediv">
    <iframe id="dataframe" name="dataframe" frameborder="0" scrolling="no"></iframe>
</div>

<script type="text/javascript">
        treeview_create({
            "id": "layermaindiv",
            "root": ${tree},
            "rootChildrenAsRoots": true,
            "itemLabelCreatorFunction": createLabel,
            "toggleImages": {
                "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
                "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
                "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
            },
            "saveExpandedState": true,
            "saveScrollState": true,
            "expandAll": false
        });
</script>

<script type="text/javascript">
    var activeTab = readCookie('activetab');
    if(activeTab != null) {
        switchTab(document.getElementById(activeTab));
    } else {
        switchTab(document.getElementById('tab0'));
    }
    Nifty("ul#nav a","medium transparent top");
    setActiveThemaLabel(getActiveThemaLabel(readCookie('activelayer')));
    var orderLayerBox= document.getElementById("orderLayerBox");

    //always call this script after the SWF object script has called the flamingo viewer.
    //function wordt aangeroepen als er een identifie wordt gedaan met de tool op deze map.
    function map1_onIdentify(movie,extend){
        //alert(extend.maxx+","+extend.maxy+"\n"+extend.minx+" "+extend.miny);
        document.getElementById('start_message').style.display = 'none';
        document.getElementById('algdatavak').style.display = 'block';

        var loadingStr = "Bezig met laden...";
        // document.getElementById('rdcoords').innerHTML = loadingStr;
        // document.getElementById('hm_aanduiding').innerHTML = loadingStr;
        // document.getElementById('wegnaam').innerHTML = loadingStr;
        document.getElementById('kadastraledata').innerHTML = loadingStr;
        handleGetAdminData(extend.maxx,extend.maxy);
        doAjaxRequest(extend.maxx,extend.maxy);
        loadObjectInfo(extend.maxx,extend.maxy);
    }
    readCookieArrayIntoCheckboxArray();
    var doOnInit= new Boolean("true");
    function map1_onInit(){
        if(doOnInit){
            doOnInit=false;
            if(checkboxArray.length == layersAan.length) {
                var newLayersAan = new Array();
                for(var j=0; j < checkboxArray.length; j++) {
                    for (var k=0; k < layersAan.length; k++) {
                        if(layersAan[k].theItem.id == checkboxArray[j]) {
                            newLayersAan[newLayersAan.length] = layersAan[k];
                        }
                    }
                }
            } else {
                var newLayersAan = layersAan;
            }
            for (var i=0; i < newLayersAan.length; i++){
                checkboxClick(newLayersAan[i],true,newLayersAan[i].theItem.title);
            }
            refreshLayer();
        }
    }
    function moveToExtent(minx,miny,maxx,maxy){
        flamingo.callMethod("map1", "moveToExtent", {minx:minx, miny:miny, maxx:maxx, maxy:maxy}, 0);
    }

</script>

<script language="JavaScript" type="text/javascript" src="<html:rewrite page="/scripts/enableJsFlamingo.js"/>"></script>