<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/selectbox.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/moveLayers.js"/>"></script>

<script>
    //Wel of niet cookies
    var useCookies=true;
    /*True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
    * False als je maximaal van 1 thema data kan ophalen. (radiobuttons)
    */
    var multipleActiveThemas=true;
        //de vertraging voor het refreshen van de kaart.
    var refreshDelay=1000;
    var nr = 0;
    function getNr() {
        return nr++;
    }

    var allActiveLayers="";
    var layerUrl=null;
    function doAjaxRequest(point_x, point_y) {
        var infoArray = new Array();
        infoArray[0] = "gm_naam";
        infoArray[1] = "bu_naam";
        JMapData.getData(point_x, point_y, infoArray, "wijk_2006_cbs", 100, 28992, handleGetData);
    }

    function handleGetData(str) {
        var rd = "X: " + str[0] + "<br />" + "Y: " + str[1];
        var adres = str[3] + ", " + str[4]; // + " (afstand: " + str[2] + " m.)"
        document.getElementById('rdcoords').innerHTML = rd;
        document.getElementById('kadastraledata').innerHTML = adres;
    }

    function handleGetAdminData(x,y) {
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
        document.forms[0].xcoord.value=x;
        document.forms[0].ycoord.value=y;
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

    var cookieArray = readCookie('checkedLayers');
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

    var activeThemaId = '';
    function setActiveThema(id, label, overrule) {
        if(!multipleActiveThemas){
            if (activeThemaId==null || activeThemaId.length == 0 || overrule){
                activeThemaId = id;
                var atlabel = document.getElementById('actief_thema');
                if (atlabel!=null && label!=null)
                    atlabel.innerHTML = 'Actieve thema: ' + label;
                if (document.forms[0] && document.forms[0].xcoord && document.forms[0].ycoord && document.forms[0].xcoord.value.length > 0 && document.forms[0].ycoord.value.length > 0){                    
                    flamingo_map1_onIdentify('',{minx:parseFloat(document.forms[0].xcoord.value), miny:parseFloat(document.forms[0].ycoord.value), maxx:parseFloat(document.forms[0].xcoord.value), maxy:parseFloat(document.forms[0].ycoord.value)})
                }
            } 
        } else {
            var atlabel = document.getElementById('actief_thema');
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
    
    var layersAan= new Array();
    
    function createLabel(container, item) {
        if(item.cluster) {
            container.appendChild(document.createTextNode((item.title ? item.title : item.id)));
        } else {        
            if(item.analyse=="on"){
                setActiveThema(item.id, item.title);
            } else if(item.analyse=="active"){
                setActiveThema(item.id, item.title, true);
            }
            
            var layerPos = getLayerPosition(item);

            if (navigator.appName=="Microsoft Internet Explorer") {
                var radioControleString = '<input type="radio" name="selkaartlaag" value="' + item.id + '"';
                if (activeThemaId == item.id)
                    radioControleString += ' checked="checked"';
                radioControleString += ' onclick="eraseCookie(\'activelayer\');' + 
                    ' createCookie(\'activelayer\', \'' + item.id + '##' + item.title + '\', \'7\');' + 
                    ' setActiveThema(\'' + item.id + '\', \'' + item.title + '\', true);"';
                radioControleString += '>';
                var el = document.createElement(radioControleString);
                
                var checkboxControleString = '<input type="checkbox" id="' + item.id + '"';
                if(layerPos!=0)
                    checkboxControleString += ' checked="checked"';
                checkboxControleString += ' value="' + item.id + '" onclick="checkboxClick(this, false, \'' + item.title + '\')"'; 
                checkboxControleString += '>';
                var el2 = document.createElement(checkboxControleString);
                
            } else {
                var el = document.createElement('input');
                el.type = 'radio';
                el.name = 'selkaartlaag';
                el.value = item.id;
                el.onclick = function(){eraseCookie('activelayer'); createCookie('activelayer', item.id + '##' + item.title, '7'); setActiveThema(item.id, item.title,true) }
                if (activeThemaId == item.id)
                    el.checked = true;

                var el2 = document.createElement('input');
                el2.id = item.id;
                el2.type = 'checkbox';
                el2.value = item.id;
                el2.onclick = function(){checkboxClick(this, false, item.title);}
                if(layerPos!=0)
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
                }                
            }
            
            if(item.wmslayers){
                container.appendChild(el2);
            }
            container.appendChild(document.createTextNode('  '));
            container.appendChild(lnk);
        }
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

    var checkboxArray = new Array();
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
                        
                    var organizationCodeKey = obj.theItem.organizationcodekey;   
                        
                    if('${organizationcode}' != null && '${organizationcode}' != '' && organizationCodeKey != '') {
                        layerUrl = layerUrl + organizationCodeKey + "=${organizationcode}";
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
    var timeouts=0;
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

        if(layerUrl.indexOf('?')> 0)
            layerUrl+='&';
        else
            layerUrl+='?';
        layerUrl+="SERVICE=WMS";
        var capLayerUrl=layerUrl;
        var newLayer= "<fmc:LayerOGWMS xmlns:fmc=\"fmc\" id=\"OG2\" timeout=\"30\"" +
            "retryonerror=\"10\" format=\"image/png\" transparent=\"true\" url=\""+layerUrl +
            "\"exceptions=\"application/vnd.ogc.se_inimage\" getcapabilitiesurl=\""+capLayerUrl + 
            "\"styles=\""+
            "\" layers=\""+layersToAdd+
            "\" srs=\"EPSG:28992\" version=\"1.1.1\"/>";
        if (flamingo && layerUrl!=null){            
            flamingo.call('map1','removeLayer','fmcLayer');
            flamingo.call('map1','addLayer',newLayer);
        }
    }
    function loadObjectInfo(x,y) {
        // vul object frame
        document.forms[0].admindata.value = '';
        document.forms[0].metadata.value = '';
        document.forms[0].objectdata.value = 't';
        document.forms[0].analysedata.value = '';
        document.forms[0].themaid.value = activeThemaId;
        
        if(checkboxArray.length > 0) {
            var arrayString = getArrayAsString();
            document.forms[0].lagen.value = arrayString;
            eraseCookie('checkedLayers');
            createCookie('checkedLayers', arrayString, '7');
        } else {
            eraseCookie('checkedLayers');
            document.forms[0].lagen.value = 'ALL';
        }
        document.forms[0].xcoord.value = x;
        document.forms[0].ycoord.value = y;
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
        if (parseInt(myImage.height) == 0){
            div.appendChild(spanEl);
        }
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
    <html:form action="/viewerdata">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="objectdata"/>
        <input type="hidden" name="analysedata"/>
        <html:hidden property="themaid" />
        <html:hidden property="lagen" />
        <html:hidden property="xcoord" />
        <html:hidden property="ycoord" />
        <html:hidden property="scale"/>
    </html:form>
</div>

<table width="100%" height="100%">
    <tr id="bovenbalkTr">
        <td width="100%">
            <table class="onderbalkTable" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="onderbalkTableLeft">
                        VIEWER
                    </td>
                    <td class="onderbalkTableRight">
                        <tiles:insert name="loginblock"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%" height="100%">
            <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="100%" height="100%">
                        <div id="flashcontent">
                            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
                        </div>
                        <script type="text/javascript">
                            var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "100%", "100%", "8", "#FFFFFF");
                            so.write("flashcontent");
                        </script>
                    </td>
                    <td>
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td id="tabjes">
                                    <ul id="nav">
                                        <script type="text/javascript">
                                            var beheerder = <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>;
                                            var organisatiebeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>;
                                            var themabeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>;
                                            var gebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>;
                                            var demogebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>;

                                            if(beheerder || themabeheerder || organisatiebeheerder || gebruiker) {
                                                document.write('<li id="tab0" onmouseover="switchTab(this);"><a href="#" id="tab0link" style="width: 57px;">Thema\'s</a></li>');
                                                document.write('<li id="tab4" onmouseover="switchTab(this);"><a href="#" id="tab4link" style="width: 58px;">Legenda</a></li>');
                                                document.write('<li id="tab1" onmouseover="switchTab(this);"><a href="#" id="tab1link" style="width: 57px;">Zoeker</a></li>');
                                                document.write('<li id="tab2" onmouseover="switchTab(this);"><a href="#" id="tab2link" style="width: 58px;">Gebieden</a></li>');
                                                document.write('<li id="tab3" onmouseover="switchTab(this);"><a href="#" id="tab3link" style="width: 57px;">Analyse</a></li>');
                                            } else if(demogebruiker) {                   
                                                document.write('<li id="tab1" onmouseover="switchTab(this);"><a href="#" id="tab1link" style="width: 97px;">Zoeker</a></li>');
                                                document.write('<li id="tab0" onmouseover="switchTab(this);"><a href="#" id="tab0link" style="width: 96px;">Thema\'s</a></li>');
                                                document.write('<li id="tab4" onmouseover="switchTab(this);"><a href="#" id="tab4link" style="width: 96px;">Legenda</a></li>');
                                                document.write('<li id="tab2" onmouseover="switchTab(this);"><a href="#" id="tab2link" style="display: none;">Gebieden</a></li>');
                                                document.write('<li id="tab3" onmouseover="switchTab(this);"><a href="#" id="tab3link" style="display: none;">Analyse</a></li>');
                                            } else {
                                                document.write('<li id="tab0" onmouseover="switchTab(this);"><a href="#" id="tab0link" style="display: none;">Thema\'s</a></li>');
                                                document.write('<li id="tab1" onmouseover="switchTab(this);"><a href="#" id="tab1link" style="width: 144px;">Zoeker</a></li>');
                                                document.write('<li id="tab4" onmouseover="switchTab(this);"><a href="#" id="tab4link" style="width: 143px;">Legenda</a></li>');
                                                document.write('<li id="tab2" onmouseover="switchTab(this);"><a href="#" id="tab2link" style="display: none;">Gebieden</a></li>');
                                                document.write('<li id="tab3" onmouseover="switchTab(this);"><a href="#" id="tab3link" style="display: none;">Analyse</a></li>');
                                            }
                                        </script>
                                        <!--[if lte IE 6]>
                                            <script type="text/javascript">
                                                if(beheerder || themabeheerder || organisatiebeheerder || gebruiker) {
                                                    document.getElementById('tab3link').style.width = '58px';
                                                } else if(demogebruiker) {
                                                    document.getElementById('tab1link').marginRight = '0px';
                                                }
                                            </script>
                                        <![endif]-->
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <td>
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
                                                <input type="button" value="Herladen" onclick="refreshMapVolgorde();" class="knop" />
                                                <input type="button" value="Verwijderen" onclick="deleteAllLayers();" class="knop" />
                                            </form>
                                        </div>
                                        
                                        <div id="infovak" style="display: none;" class="tabvak">
                                            <div id="start_message">
                                                Kies de Info-tool en klik vervolgens op een punt<br/>
                                                op de kaart voor administratieve informatie<br/>
                                                van het object.
                                            </div>
                                            
                                            <div id="algdatavak" style="display: none;">
                                                <b>RD Co&ouml;rdinaten</b><br />
                                                <span id="rdcoords"></span><br /><br />
                                                <b>Adres</b><br />
                                                <span id="kadastraledata"></span>
                                            </div>
                                            
                                            <!-- input fields for search -->
                                            <div>
                                                <br>
                                                <b>Zoek naar locatie:</b>
                                                <br>
                                                <input type="text" id="locatieveld" name="locatieveld" size="40"/>
                                                &nbsp;
                                                <input type="button" value=" Ga " onclick="getCoords();" class="knop" />
                                                <br>
                                                <div class="searchResultsClass" id="searchResults"></div>
                                            </div>
                                            <!-- end of search -->
                                        </div>
                                        
                                        <div id="objectvakViewer" style="display: none;" class="tabvak_with_iframe">
                                            <iframe id="objectframeViewer" name="objectframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe>
                                        </div>
                                        <div id="analysevakViewer" style="display: none;" class="tabvak_with_iframe">
                                            <iframe id="analyseframeViewer" name="analyseframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id="onderstukTr">
        <td width="100%">
            <table class="onderbalkTable" cellpadding="0" cellspacing="0" style="margin-bottom: 3px;">
                <tr>
                    <td class="onderbalkTableLeft">
                        DETAILS
                    </td>
                    <td class="onderbalkTableRight">
                        <span id="actief_thema">Actieve thema</span>
                    </td>
                </tr>
            </table>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="100%">
                        <div id="dataframediv" class="dataframediv">
                            <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script type="text/javascript">
   // Deze hoogtes aanpassen om het details vak qua hoogte te wijzigen
   var dataframehoogte = '70px';
   document.getElementById('dataframediv').style.height = dataframehoogte; 
   document.getElementById('dataframe').style.height = dataframehoogte; 
    
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

    var activeTab = readCookie('activetab');
    if(activeTab != null) {
        switchTab(document.getElementById(activeTab));
    } else {
        switchTab(document.getElementById('tab0'));
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
        handleGetAdminData(xp,yp);
        doAjaxRequest(xp,yp);
        loadObjectInfo(xp,yp);
    }
    readCookieArrayIntoCheckboxArray();
    var doOnInit= new Boolean("true");
    function flamingo_map1_onInit(){
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
            var fullbbox='${fullExtent}';
            var bbox='${extent}';
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
</script>

<script language="JavaScript" type="text/javascript" src="<html:rewrite page="/scripts/enableJsFlamingo.js"/>"></script>