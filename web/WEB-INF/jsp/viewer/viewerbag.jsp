<%--
B3P Gisviewer is an extension to Flamingo MapComponents making
it a complete webbased GIS viewer and configuration tool that
works in cooperation with B3P Kaartenbalie.

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript">
    //TODO: deze waarden moeten nog configureerbaar gemaakt worden in de config.
    var configMaxBouwjaar=2011;
    var configMinBouwjaar=1570;
    var configMaxOpp=15200;
    var configMinOpp=1;
    //LETOP: Onderstaande waarden moeten worden veranderd.
    /*var bagThemaId=343;
    var pandenGegevensBronId=266;
    var verblijfsObjectenGegevensBronId=267;*/
    var bagThemaId='${bagThemaId}';
    var pandenGegevensBronId='${pandenGegevensBronId}';
    var verblijfsObjectenGegevensBronId='${verblijfsObjectenGegevensBronId}';
    
    var oppAttributeName="OPPERVLAKTE";
    var bouwjaarAttributeName="BOUWJAAR";
    var gebruiksfunctieAttributeName="GEBRUIKSFUNCTIE";
    var geomAttributeName="the_geom";
</script>
<script type="text/javascript" src="<html:rewrite page='/scripts/viewerbag.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/json2.js'/>"></script>
<div style="padding: 5px;">
    <div class="messages">
            <html:messages id="message" message="true" >
                <div id="error_tab">
                    <c:out value="${message}" escapeXml="false"/>
                </div>
            </html:messages>
            <html:messages id="message" name="acknowledgeMessages">
                <div id="acknowledge_tab">
                    <c:out value="${message}"/>
                </div>
            </html:messages>
        </div>
    Maak een selectie:
    <p>
        <strong>Bouwjaar</strong>
        <div id="bouwjaarHoeveelheid" class="slider">Alles</div>
    </p>
    <div id="bouwjaarSlider" class="slider"></div>   
    
    <%--Oppervlakte--%>
    <p>	
        <strong>Oppervlakte</strong>
	<div id="oppervlakteHoeveelheid" class="slider">Alles</div>
    </p>    
    <div id="oppervlakteSlider" class="slider"></div>
    <p>
        <table>
            <tr>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="winkelfunctie" checked="true"/>Winkel</td>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="woonfunctie" checked="true"/>Wonen</td>
            <tr>
            <tr>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="industriefunctie" checked="true"/>Industrie</td>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="kantoorfunctie" checked="true"/>Kantoor</td>
            <tr>
            <tr>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="logiesfunctie" checked="true"/>Logies</td>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="onderwijsfunctie" checked="true"/>Onderwijs</td>
            <tr>
            <tr>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="overige gebruiksfunctie" checked="true"/>Overige</td>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="sportfunctie" checked="true"/>Sport</td>
            <tr>
            <tr>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="bijeenkomstfunctie" checked="true"/>Bijeenkomst</td>
                <td class="bag_td"><input type="checkbox" name="gebruiksfunctie" value="gezondheidszorgfunctie" checked="true"/>Gezondheidszorg</td>
            <tr>
        </table>
        
    </p>
        
    <p>	
        <button onclick="getBagObjects()">Zoek</button>    
    </p>
</div>
