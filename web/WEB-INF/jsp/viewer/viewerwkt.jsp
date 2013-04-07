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
        U kunt voor zelf getekende of geselecteerde kaartobjecten, indien er een 
        polygoon op het scherm staat, de WKT ophalen. Nadat u op de knop heeft
        geklikt kunt u met CTRL+C de tekst naar het klembord kopieeren.

        <p><input type="button" value="WKT ophalen" onclick="getActiveWkt()"/></p>        

        <p>
            <textarea id="activeWkt" style="width: 90%; height:400px;"></textarea>
        </p>
    </div>

    <script type="text/javascript">
        function getParent() {
            if (window.opener){
                return window.opener;
            }else if (window.parent){
                return window.parent;
            }else{
                messagePopup("", "No parent found", "error");
                return null;
            }
        }
        
        function getActiveWkt(){
            var ouder = getParent();

            if(ouder) {
                var wkt = ouder.getWktActiveFeature(0);
                
                $j("#activeWkt").val(wkt);            
                $j('#activeWkt').focus();
                $j('#activeWkt').select();
            }
        }
    </script>
</div>
