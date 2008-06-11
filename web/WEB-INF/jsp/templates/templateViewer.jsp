<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

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
        
        <link rel="stylesheet" type="text/css" href="styles/niftyCorners.css">
        <link rel="stylesheet" type="text/css" href="styles/ARC.css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p.css">
        
        <!--[if lte IE 6]>
            <link href="styles/viewer-ie6.css" rel="stylesheet" type="text/css">
        <![endif]-->
        
        <script type="text/javascript" src="scripts/etltransform.js"></script>
        <script type="text/javascript">  
            function checkLocation() {
                if (top.location != self.location)
                    top.location = self.location;
            };
        </script>
        
        <link rel="stylesheet" type="text/css" href="styles/viewer_tables.css">
        
    </head>
    <body onload="checkLocation()">
        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td width="100%" style="background-image: url(/gisviewer/images/bovenbalk.gif); background-repeat: repeat-x; height: 50px;"><tiles:insert attribute="menu" /></td>
            </tr>
            <tr>
                <td width="100%" height="100%" style="background-color: White;"><tiles:insert attribute="content" /></td>
            </tr>
        </table>
        <tiles:insert definition="googleAnalytics"/>        
    </body>
</html:html>
