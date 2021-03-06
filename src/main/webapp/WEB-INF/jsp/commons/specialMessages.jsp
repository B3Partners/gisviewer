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

<div class="messages"> 
    <html:messages id="error" message="true">
        <div id="error" title="<c:out value="${error}" escapeXml="true"/>">&nbsp;Niet alle informatie kon worden opgehaald&#160;&#160;</div>
        </html:messages>
        <html:messages id="message" name="acknowledgeMessages">
        <div id="acknowledge">
            <c:out value="${message}"/>
        </div>
    </html:messages>
</div> 

