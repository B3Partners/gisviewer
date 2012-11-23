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
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page isELIgnored="false"%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html:html>
    <head>
        <%@include file="/WEB-INF/jsp/metatags.jsp" %>
        
        <title>Print voorbeeld - B3P GIS Viewer</title>
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="scripts/jquery-1.3.2.min.js"></script>
        <script type="text/javascript" src="scripts/jquery-ui-1.8.10.custom.min.js"></script>
        <script type="text/javascript" src="<html:rewrite page='/scripts/commonfunctions.js' module=''/>"></script>
        <!--[if lte IE 7]>
            <link href="styles/gisviewer_ie7.css" rel="stylesheet" type="text/css" />
        <![endif]-->
        <script type="text/javascript">
             attachOnload(checkLocation);
        </script>

    </head>
    <body class="pdfExportClass" id="printBodyId">
        <tiles:insert attribute="content" />
        <tiles:insert definition="googleAnalytics"/>
    </body>
</html:html>