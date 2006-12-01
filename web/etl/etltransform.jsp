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
<!-- ABQIAAAAC343cGgZnunaZD9990Oi4xRrxo-vqJF2j9YSroPtu9HNqgCyPBSK2SK7GD_OHE1DHrZG_qN2bkXe_w -->
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA3xrBHK8vrZa1xEjMbWh1hRTMwU6-O5X12qXxYGpswjkv4joMBhStOEnKbOPDNjQkDSu7-_GUnoxJ9g" type="text/javascript"></script>
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
    <div id="kop" style="clear: both; width: 800px; margin-bottom: 20px;">
        <strong style="color: Red; font-size: 16px;">ETL-verwerking van GB PLANtsoen - Sloot</strong><br />
        Datum: 29-11-2006
    </div>
    
    <div class="hoofdvak">
        <strong>Kaart met algemene achtergrond</strong>
        <div id="kaartvak">
            
        </div>
    </div>
    <div class="hoofdvak">
        <strong>Preview administratieve data</strong>
        <div id="adminvak">
            Hier kunt u een deel van de geselecteerde administratieve data bekijken.<br />
            Klik hieronder op &eacute;&eacute;n van de afwijkende administratieve data om de data te bekijken.
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
    <div class="hoofdvak" style="width: 95px; text-align: center;">
        <div style="height: 50px;">&nbsp;</div>
        <div style="clear: left;">        
            <button onclick="koppel()">Koppelen</button>
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
    
    <div id="kop" style="clear: left; width: 540px; margin-bottom: 20px;">
        <button onclick="document.getElementById('geoa')[document.getElementById('geoa').selectedIndex].className = 'nieuw';">Nieuw</button> &nbsp; <button onclick="document.getElementById('geoa')[document.getElementById('geoa').selectedIndex].className = 'oud';">Oud</button> &nbsp; <button onclick="document.getElementById('geoa')[document.getElementById('geoa').selectedIndex].className = 'parkeren';">Parkeren</button> &nbsp; <button onclick="document.getElementById('geoa')[document.getElementById('geoa').selectedIndex].className = 'definitief_ontkoppeld';">Definitief ontkoppelen</button>
    </div>
    
    <div id="kop" style="float: left; width: 400px; margin-bottom: 20px;">
        <button onclick="document.getElementById('admina')[document.getElementById('admina').selectedIndex].className = 'nieuw';">Nieuw</button> &nbsp; <button onclick="document.getElementById('admina')[document.getElementById('admina').selectedIndex].className = 'oud';">Oud</button> &nbsp; <button onclick="document.getElementById('admina')[document.getElementById('admina').selectedIndex].className = 'parkeren';">Parkeren</button> &nbsp; <button onclick="document.getElementById('admina')[document.getElementById('admina').selectedIndex].className = 'definitief_ontkoppeld';">Definitief ontkoppelen</button>
    </div>
    
    <div class="hoofdvak">
        <strong>Gekoppelde Geo-afwijkingingen</strong>
        <div id="geoafwijking">
            <form name="Ggeoafwijking">
                <select size="2" name="Ggeoa" id="Ggeoa" onchange="selecteerGekoppelde(this);if(drawObject()){}"></select>
            </form>
        </div>
    </div>
    <div class="hoofdvak" style="width: 95px; text-align: center;">
        <div style="height: 50px;">&nbsp;</div>
        <div style="clear: left;">        
            <button onclick="ontkoppel()">Ontkoppelen</button>
        </div>
    </div>
    
    <div class="hoofdvak">
        <strong>Gekoppelde Administratieve-afwijkingingen</strong>
        <div id="adminafwijking">
            <form name="Gadminafwijking">
                <select size="2" name="Gadmina" id="Gadmina" onchange="selecteerGekoppelde(this); doAjaxRequest(this);"></select>
            </form>
        </div>
    </div>
    
    <div style="clear: left; width: 750px;" class="hoofdvak">
        <div style="margin-bottom: 5px;"><strong>Leganda</strong></div>
        <div style="clear: left;">
            <nobr>
                <span class="oud">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Oud &nbsp;
                <span class="nieuw">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Nieuw &nbsp;
                <span class="parkeren">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Parkeren &nbsp;
                <span class="definitief_ontkoppeld">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Definitief ontkoppeld &nbsp;
            </nobr>
        </div>
    </div>
    
    <div style="float: left;" class="hoofdvak">
        <br />
        <button onclick="window.location = 'etl.do';" style="width: 150px;">Klaar met verwerken</button>
    </div>
</div>