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

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

<script type="text/javascript">
function doAjaxRequest() {
    /* haal wkt op
     * haal aangevinkte kaartlagen op
     *
        JMapData.getAnalyseData(String wkt, String activeThemaIds, String extraCriterium, handleAnalyseMap);
    */
}

function handleAnalyseMap(map) {
    if (map!=undefined){
        document.getElementById('wat').innerHTML = "todo";
    }else{
        document.getElementById('wat').innerHTML = "Geen adres gevonden";
    }
}
</script>

<c:choose>
    <c:when test="${not empty object_data}">
         <div class="analysecontainer">

                <div class="analyseoptie">
                    <input type="button" value="Bereken" class="zoek_knop" id="analysedata" name="analysedata" onclick="doAjaxRequest();" />
                </div>
                <div class="analyseoptie" style="height: 10px;">&nbsp;</div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="analysecontainer">
            Er zijn geen gebieden ter analyse gevonden!
        </div>
    </c:otherwise>
</c:choose>
