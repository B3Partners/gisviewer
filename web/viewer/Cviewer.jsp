<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>
    <script src='dwr/interface/JMapData.js'></script>
    <script src='dwr/engine.js'></script>
    <script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
    <script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
    <script>
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
    }
    
    function setAnalyseValue(x,y) {
        document.forms[2].xcoord.value=x;
        document.forms[2].ycoord.value=y;
        document.forms[2].themaid.value = activeThemaId;
        document.forms[2].submit();
    }
    var layersAan= new Array();
    var doLayerClick= new Boolean(false);
    var activeLayerFromCookie = readCookie('activelayer');
    setActiveThema(activeLayerFromCookie);
    function createLabel(container, item) {
        doLayerClick=false;
        if(item.cluster)
            container.appendChild(document.createTextNode(item.title ? item.title : item.id));
        else {
            if (navigator.appName=="Microsoft Internet Explorer") {
                if(activeLayerFromCookie != null && activeLayerFromCookie == item.id) var el = document.createElement('<input type="radio" name="selkaartlaag" value="' + item.id + '" checked="checked" onclick="eraseCookie(\'activelayer\'); createCookie(\'activelayer\', \'' + item.id + '\', \'7\'); setActiveThema(\'' + item.id + '\');">');
                else var el = document.createElement('<input type="radio" name="selkaartlaag" value="' + item.id + '" onclick="eraseCookie(\'activelayer\'); createCookie(\'activelayer\', \'' + item.id + '\', \'7\'); setActiveThema(\'' + item.id + '\');">');
            }
            else {
                var el = document.createElement('input');
                el.type = 'radio';
                el.name = 'selkaartlaag';
                el.value = item.id;
                el.onclick = function(){eraseCookie('activelayer'); createCookie('activelayer', item.id, '7'); setActiveThema(item.id)}
                if(activeLayerFromCookie != null && activeLayerFromCookie == item.id) el.checked = true;
            }
            if (navigator.appName=="Microsoft Internet Explorer") {
                if(isInCookieArray(item.id)){
                    var el2 = document.createElement('<input type="checkbox" checked="checked" value="' + item.id + '" onclick="checkboxClick(this)">');
                    doLayerClick=true;
                }
                else var el2 = document.createElement('<input type="checkbox" value="' + item.id + '" onclick="checkboxClick(this)">');
            }
            else {
                var el2 = document.createElement('input');
                el2.type = 'checkbox';
                el2.value = item.id;
                el2.onclick = function(){checkboxClick(this);}
                if(isInCookieArray(item.id)){
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
            container.appendChild(el);
            if(item.wmsurl){
                container.appendChild(el2);
            }
            container.appendChild(document.createTextNode('  '));
            container.appendChild(lnk);
            
            
        }
    }
    
    function switchTab(obj) {
        obj.style.background = '#FF0000';
        obj.style.color = 'White';
        obj.onmouseover = function(){}
        obj.onmouseout = function(){}
        obj.onclick = function(){}
        if(obj.id == "tab0") {
            document.getElementById('treevak').style.display = 'block';
            document.getElementById('layermaindiv').style.display = 'block';
            document.getElementById('infovak').style.display = 'none';
            document.getElementById('objectvak').style.display = 'none';
            document.getElementById('analysevak').style.display = 'none';
            document.getElementById('tab1').style.backgroundColor = 'White';
            document.getElementById('tab1').style.color = 'Black';
            document.getElementById('tab1').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab1').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab1').onclick = function(){switchTab(this);}
            document.getElementById('tab2').style.backgroundColor = 'White';
            document.getElementById('tab2').style.color = 'Black';
            document.getElementById('tab2').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab2').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab2').onclick = function(){switchTab(this);}
            document.getElementById('tab3').style.backgroundColor = 'White';
            document.getElementById('tab3').style.color = 'Black';
            document.getElementById('tab3').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab3').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab3').onclick = function(){switchTab(this);}
        }
        if(obj.id == "tab1") {
            document.getElementById('treevak').style.display = 'none';
            document.getElementById('layermaindiv').style.display = 'none';
            document.getElementById('infovak').style.display = 'block';
            document.getElementById('objectvak').style.display = 'none';
            document.getElementById('analysevak').style.display = 'none';
            document.getElementById('tab0').style.backgroundColor = 'White';
            document.getElementById('tab0').style.color = 'Black';
            document.getElementById('tab0').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab0').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab0').onclick = function(){switchTab(this);}
            document.getElementById('tab2').style.backgroundColor = 'White';
            document.getElementById('tab2').style.color = 'Black';
            document.getElementById('tab2').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab2').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab2').onclick = function(){switchTab(this);}
            document.getElementById('tab3').style.backgroundColor = 'White';
            document.getElementById('tab3').style.color = 'Black';
            document.getElementById('tab3').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab3').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab3').onclick = function(){switchTab(this);}
        } else if(obj.id == "tab2") {
            document.getElementById('treevak').style.display = 'none';
            document.getElementById('layermaindiv').style.display = 'none';
            document.getElementById('infovak').style.display = 'none';
            document.getElementById('objectvak').style.display = 'block';
            document.getElementById('analysevak').style.display = 'none';
            document.getElementById('tab0').style.backgroundColor = 'White';
            document.getElementById('tab0').style.color = 'Black';
            document.getElementById('tab0').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab0').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab0').onclick = function(){switchTab(this);}
            document.getElementById('tab1').style.backgroundColor = 'White';
            document.getElementById('tab1').style.color = 'Black';
            document.getElementById('tab1').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab1').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab1').onclick = function(){switchTab(this);}
            document.getElementById('tab3').style.backgroundColor = 'White';
            document.getElementById('tab3').style.color = 'Black';
            document.getElementById('tab3').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab3').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab3').onclick = function(){switchTab(this);}
        } else if(obj.id == "tab3") {
            document.getElementById('treevak').style.display = 'none';
            document.getElementById('layermaindiv').style.display = 'none';
            document.getElementById('infovak').style.display = 'none';
            document.getElementById('objectvak').style.display = 'none';
            document.getElementById('analysevak').style.display = 'block';
            document.getElementById('tab0').style.backgroundColor = 'White';
            document.getElementById('tab0').style.color = 'Black';
            document.getElementById('tab0').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab0').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab0').onclick = function(){switchTab(this);}            
            document.getElementById('tab1').style.backgroundColor = 'White';
            document.getElementById('tab1').style.color = 'Black';
            document.getElementById('tab1').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab1').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab1').onclick = function(){switchTab(this);}
            document.getElementById('tab2').style.backgroundColor = 'White';
            document.getElementById('tab2').style.color = 'Black';
            document.getElementById('tab2').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab2').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab2').onclick = function(){switchTab(this);}
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
    
    function checkboxClick(obj, dontRefresh) {
        if(obj.checked) {
            //var standardParam="SERVICE=WMS&VERSION=1.1.1&SRS=EPSG:28992&WRAPDATELINE=true&BGCOLOR=0xF0F0F0";
            var standardParam="SERVICE=WMS&VERSION=1.1.1";
            if(!isInCheckboxArray(obj.value)) checkboxArray[checkboxArray.length] = obj.value;
            
            if(checkboxArray.length > 0) {
                var arrayString = getArrayAsString();
                eraseCookie('checkedLayers');
                createCookie('checkedLayers', arrayString, '7');
            } else {
                eraseCookie('checkedLayers');
            }
            
            if (obj.theItem.wmsurl){
                if (obj.theItem.wmsurl.indexOf("?")>0){
                    standardParam="&"+standardParam;
                }else{
                    standardParam="?"+standardParam;
                }
                if (layerUrl==null){
                    layerUrl=obj.theItem.wmsurl+standardParam;
                }
                allActiveLayers+= ","+obj.theItem.wmslayers;
                if (!dontRefresh){
                    refreshLayer();
                }
            }            
        } else {
            //alert("layer uit");
            deleteFromArray(obj);
            if (obj.theItem.wmsurl){
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
        var newLayer= "<fmc:LayerOGWMS xmlns:fmc='fmc' id='OG2' timeout='30' retryonerror='10' format='image/png' transparent='true' url='"+layerUrl+"' layers='achtergrond"+allActiveLayers+"' query_layers='"+layersToAdd+"' srs='EPSG:28992'/>";
        if (flamingo){
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
        JMapData.getMapCoords(postcode, plaatsnaam, n_nr, hm, getCoordsCallbackFunction);
    }
    
    function getCoordsCallbackFunction(value){
        var coords_array = value.split("*");
        var minx = coords_array[0];
        var miny = coords_array[1];
        var maxx = coords_array[2];
        var maxy = coords_array[3];
        if (minx != 0 && miny != 0 && maxx != 0 && maxy != 0) {
            moveToExtent(minx, miny, maxx, maxy);
        }
        document.getElementById('coordsResponseMinx').innerHTML = coords_array[0];
        document.getElementById('coordsResponseMiny').innerHTML = coords_array[1];
        document.getElementById('coordsResponseMaxx').innerHTML = coords_array[2];
        document.getElementById('coordsResponseMaxy').innerHTML = coords_array[3];
    }
    
    function showHide(nr, el) {
        if(el.value == "") {
            document.getElementById('show1').disabled = false;
            document.getElementById('show2').disabled = false;
            document.getElementById('show3').disabled = false;
            document.getElementById('show4').disabled = false;
        } else {
            if(nr == 3 || nr == 4) {
                document.getElementById('show1').disabled = true;
                document.getElementById('show2').disabled = true;
            } else if(nr == 2) {
                document.getElementById('show1').disabled = true;
                document.getElementById('show3').disabled = true;
                document.getElementById('show4').disabled = true;
            } else if(nr == 1) {
                document.getElementById('show2').disabled = true;
                document.getElementById('show3').disabled = true;
                document.getElementById('show4').disabled = true;
            }
        }
    }    
    </script>    
    <div id="map"><div id="flashcontent">
            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
        </div>
            <script type="text/javascript">
            var so = new SWFObject("flamingo/flamingo.swf?config=config.xml", "flamingo", "659", "493", "8", "#FFFFFF");
            </script>
            <!--[if lte IE 6]>
            <script type="text/javascript">
            var so = new SWFObject("flamingo/flamingo.swf?config=flamingo/config.xml", "flamingo", "651", "488", "8", "#FFFFFF");
            </script>
            <![endif]-->
            <script type="text/javascript">
            so.write("flashcontent");
            </script>
        </div>
    
    <div id="rightdiv">
        <div id="tabjes">
            <div id="tab0">
                Thema&lsquo;s
            </div>
            <div id="tab1">
                Lokatie
            </div>
            <div id="tab2">
                Gebieden
            </div>
            <div id="tab3">
                Analyse
            </div>
        </div>
        <div id="tab_container">
            <div id="treevak" style="display: none;">
                <div id="layermaindiv" style="display: none;"></div>
            </div>
            <div id="infovak" style="display: none;">
                <div id="start_message">
                    Klik op een punt op de kaart voor aanvullende informatie.
                </div>
                
                <div id="algdatavak" style="margin: 0px; padding: 0px; display: none;">
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
                <h3>Zoek naar locatie:</h3>
                <p>
                    <table>
                    <tr>
                        <td>Postcode:</td>
                        <td><input type="text" id="show1" name="show1" onchange="showHide(1, this);" size="5"/></td>
                    </tr>
                    <tr>
                        <td>Plaatsnaam:</td>
                        <td><input type="text" id="show2" name="show2" onchange="showHide(2, this);" size="20"/></td>
                    </tr>
                    <tr>
                        <td>Weg nr:</td>
                        <td><input type="text" id="show3" name="show3" onchange="showHide(3, this);" size="5"/></td>
                    </tr>
                    <tr>
                        <td>Hectometer:</td>
                        <td><input type="text" id="show4" name="show4" onchange="showHide(4, this);" size="5"/></td>
                    </tr>
                    </table> 

                    <button onclick="getCoords();">
                        Ga naar locatie
                    </button><br>
                    
                    Locatie: 
                    <span id="coordsResponseMinx" class="response">minx:</span>,&nbsp;
                    <span id="coordsResponseMiny" class="response">miny:</span>,&nbsp;
                    <span id="coordsResponseMaxx" class="response">maxx:</span>,&nbsp;
                    <span id="coordsResponseMaxy" class="response">maxy:</span>
                    
                </p> 
                </div>
                <!-- end of search -->
            </div>

               
            
            <div id="objectvak" style="display: none;">
                <iframe id="objectframe" name="objectframe" frameborder="0"></iframe>
            </div>
            <div id="analysevak" style="display: none;">
                <iframe id="analyseframe" name="analyseframe" frameborder="0"></iframe>
            </div>
        </div>
    </div>
    
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
    
    <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>

    <br /><br /><br />
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
    switchTab(document.getElementById('tab0'));
        
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
    function map1_OG2_onUpdateResponse(){
        if(doOnInit){
            doOnInit=false;
            for (var i=0; i < layersAan.length; i++){
                checkboxClick(layersAan[i],true);
            }
            refreshLayer();
        }
    }
    function moveToExtent(minx,miny,maxx,maxy){
        flamingo.callMethod("map1", "moveToExtent", {minx:minx, miny:miny, maxx:maxx, maxy:maxy}, 0);
    }
    </script>
    
    
    <%-- script tag niet afgesloten zodat flamingo ook in 1 keer goed werkt in IE--%>
    <script language="JavaScript" type="text/javascript" src="<html:rewrite page='/js/enableJsFlamingo.js' module='' />">

