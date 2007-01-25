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
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA3xrBHK8vrZa1xEjMbWh1hRTiqeKY4ZeLrXajftGmPAD6z7xzhhRm4kzxh9Sq8bz4hJZ6KaJOHrYXew" type="text/javascript"></script>
    <script language="JavaScript" type="text/JavaScript" src="scripts/rectangle.js"></script>
    <script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
    <%--script language="JavaScript" type="text/JavaScript" src="googlemap.js"></script--%>
    <script type="text/javascript">
    //<![CDATA[
    /*Google maps code*/
    var map;
    var map_moving = 0;
    var minimap_moving = 0;
    var minimap;
    var xhair;
    // This function handles what happens when the main map moves
    // If we arent moving it (i.e. if the user is moving it) move the minimap to match
    // and reposition the crosshair back to the centre
    function Move(){
        minimap_moving = true;
        if (map_moving == false) {
            minimap.setCenter(map.getCenter());
            minimap.clearOverlays();
            xhair= new Rectangle(map.getBounds(),2,"#0000ff");
            minimap.addOverlay(xhair);
        }
        minimap_moving = false;
    }
    // This function handles what happens when the mini map moves
    // If we arent moving it (i.e. if the user is moving it) move the main map to match
    // and reposition the crosshair back to the centre
    function MMove(){
        map_moving = true;
        if (minimap_moving == false) {
            map.setCenter(minimap.getCenter());
            minimap.clearOverlays();
            xhair= new Rectangle(map.getBounds(),2,"#0000ff");
            minimap.addOverlay(xhair);
        }
        map_moving = false;
    }
    // the load done after the body is loaded
    function load() {
      if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map"));
        //set center
        map.setCenter(new GLatLng(51.6991361, 5.3198311), 13);
        //add some controles
        map.addControl(new GLargeMapControl());
        //add a map overview to the map
               
        // create the crosshair icon, which will indicate where we are on the minimap
        // Lets not bother with a shadow
        var Icon = new GIcon();
        Icon.image = "images/xhair.png";
        Icon.iconSize = new GSize(21, 21);
        Icon.shadowSize = new GSize(0,0);
        Icon.iconAnchor = new GPoint(11, 11);
        Icon.infoWindowAnchor = new GPoint(11, 11);
        Icon.infoShadowAnchor = new GPoint(11, 11);

        // Create the minimap
        minimap = new GMap2(document.getElementById("minimap"));
        minimap.setCenter(new GLatLng(51.6991361, 5.3198311),8);

        // Add the crosshair marker at the centre of teh minimap and keep a reference to it
        xhair = new Rectangle(map.getBounds(),2,"#0000ff");        
        minimap.addOverlay(xhair);
        
        //set listeners
        GEvent.addListener(map, 'move', Move);
        GEvent.addListener(minimap, 'moveend', MMove);
        GEvent.addListener(map, "click", addMarker);
      }      
    }
    
    function addMarker(marker, point) {
        map.clearOverlays()
        map.addOverlay(new GMarker(point));
        doAjaxRequest(point.x, point.y);
        
        handleGetAdminData();
    }
    
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
    
    function handleUnLoad() { 
        if (GBrowserIsCompatible()) { 
            GUnload(); 
        } 
    } 

    //voeg load en unload to aan body element
    if (window.addEventListener) {
      window.addEventListener("load", load, false);
      //window.addEventListener("unload", handleUnLoad(),false);
    }
    else if (window.attachEvent) {
      window.attachEvent("onload", load);
      //window.attachEvent("onunload",handleUnLoad());
    }
    else {
      window.onload = load;
      window.onunload= GUnload;
    }
    /*Einde google maps code*/
    
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
            var el = document.createElement('input');
            el.type = 'radio';
            el.name = 'selkaartlaag';
            el.value = item.id;
            var el2 = document.createElement('input');
            el2.type = 'checkbox';
            var lnk = document.createElement('a');
            lnk.innerHTML = item.title ? item.title : item.id;
            lnk.href = '#';
            lnk.onclick = function(){ getMetaData(item.id) };
            container.appendChild(el);
            container.appendChild(el2);
            container.appendChild(lnk);
        }
    }
    //]]>
    </script>
    <div id="map"></div>
    <div id="layermaindiv"></div>
    <div id="minimap"></div>
    <div id="infovak">
        Klik op de kaart voor informatie over het desbetreffende punt
    </div>
    
    <form target="dataframe" method="post" action="viewerdata.do">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="laagid" />
    </form>
    
    <iframe id="dataframe" name="dataframe"></iframe>
    
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
    </body>
</html>
