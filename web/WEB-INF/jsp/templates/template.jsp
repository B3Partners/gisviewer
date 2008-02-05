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
        
        <title>POL 2006</title>
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
        
    </head>
    <body onload="checkLocation()">
        <div id="menu_div"><tiles:insert attribute="menu" /></div>
        <div id="maindiv"><div id="content_div"><tiles:insert attribute="content" /></div></div>
        <div id="onder_div"><div id="copyright"></div><div id="initiatief"></div></div>
        <tiles:insert definition="googleAnalytics"/>        
    </body>
</html:html>
