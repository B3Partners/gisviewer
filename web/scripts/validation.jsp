<%--
B3P Kaartenbalie is a OGC WMS/WFS proxy that adds functionality
for authentication/authorization, pricing and usage reporting.

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Kaartenbalie.

B3P Kaartenbalie is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Kaartenbalie is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Kaartenbalie.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@page pageEncoding="UTF-8"%>
<%@page contentType="text/javascript" %>
<%@page session="false"%>

<%@taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<%-- Zorg ervoor dat deze pagina wordt gecached door de browser door een expires 
     header te zetten voor 24 uur na de huidige tijd. 
--%>
<% response.setDateHeader("Expires", System.currentTimeMillis() + (1000 * 60 * 60 * 24));%>

<html:javascript dynamicJavascript="false" />