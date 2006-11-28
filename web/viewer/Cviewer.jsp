<%@ page language="java" %>
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
--%>
<html>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAC343cGgZnunaZD9990Oi4xRrxo-vqJF2j9YSroPtu9HNqgCyPBSK2SK7GD_OHE1DHrZG_qN2bkXe_w"
      type="text/javascript"></script>
    <%--script language="JavaScript" type="text/JavaScript" src="googlemap.js"></script--%>
    <script type="text/javascript">
    //<![CDATA[
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
            xhair.setPoint(map.getCenter());
            xhair.redraw(true);
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
            xhair.setPoint(minimap.getCenter());
            xhair.redraw(true);
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
        map.addControl(new GMapTypeControl());
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
        xhair = new GMarker(minimap.getCenter(), Icon);            
        minimap.addOverlay(xhair);
        
        //set listeners
        GEvent.addListener(map, 'move', Move);
        GEvent.addListener(minimap, 'moveend', MMove);        
      }      
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
    
    //]]>
    </script>
      <div id="map"></div>
      <div id="layermaindiv">
          <h1>Layers</h1>
      </div>
      <div id="minimap"></div>
      <div id="admindatamaindiv"><a href="javascript: window.resizeTo(1024,786)">Resize</a><br>Hier komt administratieve data</div>
  </body>
</html>
