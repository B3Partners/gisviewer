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
        <h2>Stel de transparantie in</h2>
        <div id="slider" style="width: 250px; float: left;"></div>
    </div>
    <script type="text/javascript">
        $j(function() {
            $j("#slider").slider({
                min: 0,
                max: 100,
                value: 100,
                animate: true,
                change: function(event, ui) { 
                    transparency(ui.value); 
                }
            });
        });
        function transparency(value){
            var opacity = 1.0 - value/100;
            var layers = parent.webMapController.getMap().getLayers();
            for( var i = 0 ; i < layers.length ; i++ ){
                var l = layers[i];
                if(!l.getOption("background")){
                    l.setOpacity (opacity);
                }
            }
            console.log(value);
        }
    </script>
</div>
