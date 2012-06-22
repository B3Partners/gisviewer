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
    
<div style="padding: 5px;">
    <div class="messages">
        <html:messages id="message" message="true" >
            <div id="error_tab">
                <c:out value="${message}" escapeXml="false"/>
            </div>
        </html:messages>
        <html:messages id="message" name="acknowledgeMessages">
            <div class="acknowledge_tab">
                <c:out value="${message}"/>
            </div>
        </html:messages>
    </div>
    <div>
        Teken een object met de redliningtool. Met onderstaande knop wordt de actieve geometrie in het onderstaande veld gezet. <br/>
        <input type="button" value="Haal geometrie op" onclick="getActiveWkt()"/> <br/>
        WKT:
        <textarea id="activeWkt" style="width: 90%; height:400px;"></textarea>
    </div>
    <script type="text/javascript">
        function getActiveWkt(){
            var wmc = parent.webMapController;
            var vectorLayer = wmc.getMap().getAllVectorLayers()[0];
            var feature = vectorLayer.getActiveFeature();
            var activeWktArea = $j("#activeWkt");
            activeWktArea.val(feature.wkt);
        }
    </script>
</div>
