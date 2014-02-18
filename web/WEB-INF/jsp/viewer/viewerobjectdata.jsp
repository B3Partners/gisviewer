<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  

Copyright 2014 B3Partners BV

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

<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js'></script>

<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>

<script type="text/javascript">
    var appCode = "${appCode}";
    
    var urlicon = '<html:rewrite href="./images/icons/world_link.png" />';    
    var pencil = '<html:rewrite href="./images/icons/pencil.png" />';
    var pdficon = '<html:rewrite href="./images/icons/pdf.png" />';
    var docicon = '<html:rewrite href="./images/icons/document.png" />';
    var googleIcon = '<html:rewrite href="./images/icons/google-maps.png" />';
</script>

<div style="margin: 5px;">
    <tiles:insert definition="actionMessages"/>

    <c:choose>
        <c:when test="${not empty ggbBeans}">
            <p style="color: #000;">
                In dit gebied zijn de volgende locaties van belang:
            </p>

            <div id="gebiedenDataContainer">
                <div id="gebiedenWrapper"></div>
                <div style="clear: both;"></div>
            </div>

            <div id="gebiedenInfo"></div>
            
            <script type="text/javascript" src="<html:rewrite page='/scripts/json2.js'/>"></script>

            <script type="text/javascript">
                <c:forEach var="bean" items="${ggbBeans}" varStatus="status">                    
                    JCollectAdmindata.fillGegevensBronBean(${bean.id}, ${bean.themaId}, '${bean.wkt}', JSON.stringify(${bean.cql}), false, 'gebiedenWrapper', appCode, handleGebiedenBron);
                </c:forEach>
            </script>

        </c:when>

        <c:otherwise>
            <p>Er zijn geen gebieden beschikbaar.</p>
        </c:otherwise>
    </c:choose>
</div>


