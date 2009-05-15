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

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html:html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <META HTTP-EQUIV="Cache-Control" CONTENT="max-age=0, no-store">
        
        <title>B3P GIS Viewer</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link href="styles/etl.css" rel="stylesheet" type="text/css">
        <link href="styles/etltransform.css" rel="stylesheet" type="text/css">
        <link href="styles/config.css" rel="stylesheet" type="text/css">
        <link href="styles/config-tab.css" rel="stylesheet" type="text/css">
        
        <link rel="stylesheet" type="text/css" href="styles/niftyCorners.css">
        <link rel="stylesheet" type="text/css" href="styles/ARC.css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p.css">
        <!-- <link rel="stylesheet" type="text/css" href="styles/custom/viewer_ev.css"> -->
        
        <!--[if lte IE 6]>
            <link href="styles/viewer-ie6.css" rel="stylesheet" type="text/css">
            <script type="text/javascript" src="scripts/resizewindow-ie6.js"></script>
        <![endif]-->
        <!--[if gte IE 7]>
        <script type="text/javascript" src="scripts/resizewindow.js"></script>
        <![endif]-->
        <!--[if !IE]>--><script type="text/javascript" src="scripts/resizewindow.js"></script><!--<![endif]-->
        <script language="JavaScript" type="text/JavaScript" src="<html:rewrite page='/scripts/validation.jsp' module=''/>"></script>
        <script type="text/javascript" src="scripts/etltransform.js"></script>
        <script type="text/javascript" src="scripts/config-tab.js"></script>
        <script type="text/javascript">  
            function checkLocation() {
                if (top.location != self.location)
                    top.location = self.location;
            };
        </script>
        
    </head>
    <body onload="checkLocation()">
        <div id="menu_div"><tiles:insert attribute="menu" /></div>
        <div id="maindiv"><div id="content_div"><tiles:insert attribute="content" /></div></div>
        <div id="onder_div"><div id="copyright"></div><div id="initiatief"></div></div>
        <tiles:insert definition="googleAnalytics"/>        
    </body>
</html:html>
