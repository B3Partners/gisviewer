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
        
        <!--[if lte IE 6]>
            <link rel="stylesheet" type="text/css" href="styles/edamvolendam/viewer_ev_clean_ie6.css">   
        <![endif]-->
        
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
                <td width="100%" style="height: 75px;" id="mainTopmenuTd"><tiles:insert attribute="menu" /></td>
            </tr>
            <tr>
                <td width="100%" height="100%" id="mainContentTd"><tiles:insert attribute="content" /></td>
            </tr>
        </table>
        <tiles:insert definition="googleAnalytics"/>        
    </body>
</html:html>