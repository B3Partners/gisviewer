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

<html:html>
    <head>
        
        <title>B3P GIS Viewer</title>
        
        <link rel="stylesheet" type="text/css" href="styles/niftyCorners.css">
        
        <!--
        <link rel="stylesheet" type="text/css" href="styles/edamvolendam/viewer_ev_clean.css">
        <link rel="stylesheet" type="text/css" href="styles/edamvolendam/viewer_ev_clean_overlay.css">
        -->
        
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p_clean.css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p_clean_overlay.css">
        
        
         <!-- Onderstaande stylesheet vervangen door styles/viewer_b3p_clean_ie6.css bij gebruik van B3Partners design -->
        <!-- Onderstaande stylesheet vervangen door styles/edamvolendam/viewer_ev_clean_ie6.css bij gebruik van Edam-Volendam design -->
        <!--[if lte IE 6]>
            <link rel="stylesheet" type="text/css" href="styles/viewer_b3p_clean_ie6.css">   
        <![endif]-->
        
        <script type="text/javascript" src="scripts/etltransform.js"></script>
        <script type="text/javascript">  
            function checkLocation() {
                if (top.location != self.location)
                    top.location = self.location;
            };
        </script>
        
    </head>
    <body onload="checkLocation()">
        <table width="100%" height="100%" style="max-height: 100%" cellpadding="0" cellspacing="0">
            <tr id="menuTr">
                <td width="100%" style="height: 50px;" id="mainTopmenuTd"><tiles:insert attribute="menu" /></td>
            </tr>
            <tr>
                <td width="100%" height="100%" id="mainContentTd"><tiles:insert attribute="content" /></td>
            </tr>
        </table>
        <tiles:insert definition="googleAnalytics"/>        
    </body>
</html:html>