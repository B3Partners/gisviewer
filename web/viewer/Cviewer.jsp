<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>
<html>
    <script src='dwr/interface/JMapData.js'></script>
    <script src='dwr/interface/JViewerAdminData.js'></script>
    <script src='dwr/engine.js'></script>
    <!-- ABQIAAAA3xrBHK8vrZa1xEjMbWh1hRQscSysVS1XSjcAv6lVG_Fcz1dG_hTUtfUaDWssiqZBu5tkG9-_hOOq3w -->
    <!-- ABQIAAAA3xrBHK8vrZa1xEjMbWh1hRRrxo-vqJF2j9YSroPtu9HNqgCyPBT3RKeL6MZXKFcLtQOV9A_keMkhYw -->
    <script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
    <script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
    <%--script language="JavaScript" type="text/JavaScript" src="googlemap.js"></script--%>
    <script>
       
    function doAjaxRequest(point_x, point_y) {
        JMapData.getData(point_x, point_y, handleGetData);
    }
    
    function handleGetData(str) {
        document.getElementById('infovak').innerHTML = str;
    }
    
    function handleGetAdminData() {
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
        
        document.forms[0].metadata.value = '';
        document.forms[0].admindata.value = 't';
        document.forms[0].laagid.value = selkaart.value;
        document.forms[0].submit();
    }
    
    function getMetaData(id) {
        document.forms[0].metadata.value = 't';
        document.forms[0].admindata.value = '';
        document.forms[0].laagid.value = id;
        document.forms[0].submit();
    }
    
    function getAdminData(id) {
        document.forms[0].metadata.value = 't';
        document.forms[0].admindata.value = '';
        document.forms[0].laagid.value = id;
        document.forms[0].submit();
    }
    function changeLayers(obj) {
        if(obj.checked == true) {
            map.setMapType(G_HYBRID_MAP);
        } else { 
            map.setMapType(G_NORMAL_MAP);
        }
    }
    
    function createLabel(container, item) {
        if(item.cluster)
            container.appendChild(document.createTextNode(item.title ? item.title : item.id));
        else {
            if (navigator.appName=="Microsoft Internet Explorer") {
                var el = document.createElement('<input type="radio" name="selkaartlaag" value="' + item.id + '">');
            }
            else {
                var el = document.createElement('input');
                el.type = 'radio';
                el.name = 'selkaartlaag';
                el.value = item.id;
            }
            if (navigator.appName=="Microsoft Internet Explorer") {
                var el2 = document.createElement('<input type="checkbox" value="' + item.id + '" onclick="loadObjectInfo(this)">');
            }
            else {
                var el2 = document.createElement('input');
                el2.type = 'checkbox';
                el2.value = item.id;
                el2.onclick = function(){loadObjectInfo(this);}
            }
            
            var lnk = document.createElement('a');
            lnk.innerHTML = item.title ? item.title : item.id;
            lnk.href = '#';
            lnk.onclick = function(){ getMetaData(item.id) };
            container.appendChild(el);
            container.appendChild(el2);
            container.appendChild(lnk);
        }
    }
    
    function switchTab(obj) {
        obj.style.background = '#FF0000';
        obj.style.color = 'White';
        obj.onmouseover = function(){}
        obj.onmouseout = function(){}
        obj.onclick = function(){}
        if(obj.id == "tab1") {
            document.getElementById('infovak').style.display = 'block';
            document.getElementById('objectvak').style.display = 'none';
            document.getElementById('tab2').style.backgroundColor = 'White';
            document.getElementById('tab2').style.color = 'Black';
            document.getElementById('tab2').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab2').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab2').onclick = function(){switchTab(this);}
        } else if(obj.id == "tab2") {
            document.getElementById('infovak').style.display = 'none';
            document.getElementById('objectvak').style.display = 'block';
            document.getElementById('tab1').style.backgroundColor = 'White';
            document.getElementById('tab1').style.color = 'Black';
            document.getElementById('tab1').onmouseover = function(){this.style.backgroundColor='#FF0000'; this.style.color = 'White';}
            document.getElementById('tab1').onmouseout = function(){this.style.backgroundColor='White'; this.style.color = 'Black';}
            document.getElementById('tab1').onclick = function(){switchTab(this);}
        }
    }
    
    var checkboxArray = new Array();
    function loadObjectInfo(obj) {
        if(obj == null) {
            // Laad alle data
            document.forms[1].lagen.value = 'ALL';
        } else {
            if(obj.checked) {
                checkboxArray[checkboxArray.length] = obj;
            } else {
                deleteFromArray(obj);
            }
            if(checkboxArray.length > 0) {
                document.forms[1].lagen.value = getArrayAsString();
            } else {
                document.forms[1].lagen.value = 'ALL';
            }
        }
        document.forms[1].submit();
    }
    
    function getArrayAsString() {
        var ret = "";
        var firstTime = true;
        for(var i = 0; i < checkboxArray.length; i++) {
            if(firstTime) {
                ret += checkboxArray[i].value;
                firstTime = false;
            } else {
                ret += "," + checkboxArray[i].value;
            }
        }
        return ret;
    }
    
    function deleteFromArray(obj) {
        if(checkboxArray.length == 1 && checkboxArray[0] == obj) checkboxArray = new Array();
        var tempArray = new Array();
        var j = 0;
        for(i = 0; i < checkboxArray.length; i++) {
            if(checkboxArray[i] != obj) {
                tempArray[j] = checkboxArray[i];
                j++;
            }
        }
        checkboxArray = tempArray;
    }
    </script>
    
    <div id="map"><div id="flashcontent">
            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
        </div>
        <script type="text/javascript">
   var so = new SWFObject("flamingo/flamingo.swf?config=flamingo/config.xml", "flamingo", "498", "400", "8", "#FFFFFF");
   so.write("flashcontent");
        </script>
    </div>
    <div id="layermaindiv"></div>
    <div id="rightdiv">
        <div id="tabjes">
            <div id="tab1" onmouseover=""  onmouseout="" onclick="switchTab(this);">
                Lokatie-Informatie
            </div>
            <div id="tab2">
                Object-Informatie
            </div>
        </div>
        <div id="infovak" style="display: none;">
            Klik op de kaart voor lokatie-informatie over het desbetreffende punt
        </div>
        <div id="objectvak" style="display: none;">
            <iframe id="objectframe" name="objectframe" frameborder="0"></iframe>
        </div>
    </div>
    
    <form target="dataframe" method="post" action="viewerdata.do">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="laagid" />
    </form>
    
    <form target="objectframe" method="post" action="viewerdata.do">
        <input type="hidden" name="objectdata" value="t" />
        <input type="hidden" name="lagen" />
    </form>
    
    <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>

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
    switchTab(document.getElementById('tab1'));
    loadObjectInfo(null);
        
    var flamingo;
    var lastextent;

    function init() {
       if (document.getElementById) {
          flamingo = document.getElementById("flamingo");
       }
    }
      
    window.onload = init;
    function flamingo_onInit() {
       //at this moment the flamingo.swf is up and running, so initialize the global flamingo var.
       //alert("set flamingo");
       flamingo =getMovie("flamingo");
    }

    function flamingo_onError(error) {
        alert("ERROR:"+error);
    }

    function flamingo_onLoadConfig() {
       //alert("config loaded ");
    }

    function EHSkaart_onInit(componentid) {
      //alert("onInit "+componentid);
      flamingo.call("EHSkaart", "moveToExtent", lastextent ,0 ,0)
    }
    function map1_onIdentify(layer, extent){
        doAjaxRequest(extent.minx, extent.miny);
        handleGetAdminData();        
    }
    </script>
    </body>
</html>
