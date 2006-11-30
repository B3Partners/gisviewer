<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>

<script src='dwr/interface/JAdminData.js'></script>
<script src='dwr/engine.js'></script>
<!-- ABQIAAAA3xrBHK8vrZa1xEjMbWh1hRRgOA7BOC0lK-MBYIwOJn5aQEzC1hS8NHo_hRAJNp2RbPdwhSHW7kfKCA -->
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAC343cGgZnunaZD9990Oi4xRrxo-vqJF2j9YSroPtu9HNqgCyPBSK2SK7GD_OHE1DHrZG_qN2bkXe_w" type="text/javascript"></script>
<script type="text/javascript">
    //<![CDATA[
    /*google maps code*/
    var map;
    var bounds;
    var southWest;
    var northEast;
    var lngSpan;
    var latSpan;
    var objects= [];
    // the load done after the body is loaded
    function load(){
      if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("kaartvak"));
        //set center
        map.setCenter(new GLatLng(51.6991361, 5.3198311), 13);
        //add some controles
        map.addControl(new GLargeMapControl());
        map.addControl(new GMapTypeControl());
        bounds = map.getBounds();
        southWest = bounds.getSouthWest();
        northEast = bounds.getNorthEast();
        lngSpan = northEast.lng() - southWest.lng();
        latSpan = northEast.lat() - southWest.lat();
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
    /*Einde google maps code*/
    
    /*Schoon de map op*/   
    function clearMap(){
        if (map){
            map.clearOverlays();
        }
    }
    function drawObject(){
        clearMap();
        //map.addOverlay(objects[index]); 
        //map.addOverlay(new GPolyline(createRandomPoints(4)));
        var point = new GLatLng(southWest.lat() + latSpan * Math.random(),
                          southWest.lng() + lngSpan * Math.random());
        map.addOverlay(new GMarker(point));
    }
    
    //]]>  
</script>
<div style="width: 1000px; margin-top: 20px;">
    <div class="hoofdvak">
        <strong>Kaart met algemene achtergrond</strong>
        <div id="kaartvak">
            
        </div>
    </div>
    <div class="hoofdvak">
        <strong>Preview administratieve data</strong>
        <div id="adminvak">
            
        </div>
    </div>
    
    <div class="hoofdvak">
        <strong>Geo-afwijking</strong>
        <div id="geoafwijking">
            <c:if test="${not empty geoafwijking}">
                <form name="geoafwijking">
                    <select size="2" name="geoa" id="geoa" onchange="selecteerGekoppelde(this);if(drawObject()){}">
                        <c:forEach var="geoa" items="${geoafwijking}">
                            <option id="<c:out value="${geoa.id}" />" class="<c:out value="${geoa.afwijking}"  />" value="<c:out value="${geoa.id}" />" ><c:out value="${geoa.naam}" /></option>
                        </c:forEach>
                    </select>
                    
                </form>
            </c:if>
        </div>
    </div>
    <div class="hoofdvak" style="width: 100px; text-align: center;">
        <div style="height: 130px;">&nbsp;</div>
        <div style="clear: left;">        
            <button onclick="koppel()">Koppelen</button><br /><br />
            <button onclick="ontkoppel()">Ontkoppelen</button>
        </div>
    </div>
    <div class="hoofdvak">
        <strong>Administratieve-afwijking</strong>
        <div id="adminafwijking">
            <c:if test="${not empty adminafwijking}">
                <form name="adminafwijking">
                    <select size="2" name="admina" id="admina" onchange="selecteerGekoppelde(this); doAjaxRequest(this);">
                        <c:forEach var="admina" items="${adminafwijking}" varStatus="status">
                            <option id="<c:out value="${admina.id}" />" value="<c:out value="${admina.id}" />" class="<c:out value="${admina.afwijking}" />"><c:out value="${admina.naam}" /></option>
                        </c:forEach>
                    </select>
                </form>
            </c:if>
        </div>
    </div>
    
    <div style="clear: both;" class="hoofdvak">
        <strong>Leganda</strong><br />
        <nobr>
            <span class="oud">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Oud &nbsp;
            <span class="nieuw">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Nieuw &nbsp;
            <span class="ontkoppeld">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Ontkoppeld &nbsp;
            <span class="parkeren">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Parkeren &nbsp;
            <span class="definitief_ontkoppeld">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Definitief ontkoppeld &nbsp;
            <span style="background-color: #33CCFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Gekoppeld &nbsp;
        </nobr>
    </div>
</div>

<script type="text/javascript">
    function handleGetData(str) {
      document.getElementById('adminvak').innerHTML = str;
    }
    
    function doAjaxRequest(obj) {
        var selObj = obj[obj.selectedIndex];
        var id = selObj.value;
        JAdminData.getData(id, handleGetData);
    }
</script>