<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>WIS Noord-Brabant</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link href="styles/etl.css" rel="stylesheet" type="text/css">
        <link href="styles/etltransform.css" rel="stylesheet" type="text/css">
        
        <link rel="stylesheet" type="text/css" href="styles/niftyCorners.css">
        <link rel="stylesheet" type="text/css" href="styles/ARC.css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p.css">
        
        <!--[if lte IE 6]>
            <link href="styles/viewer-ie6.css" rel="stylesheet" type="text/css">
        <![endif]-->
        
        <script type="text/javascript" src="scripts/etltransform.js"></script>
    </head>
    <body>
        <!-- !!! TEN BEHOEVE VAN NBR DESIGN COMMENTAAR ROND ONDERSTAANDE DIVS WEGHALEN !!! -->
        <!-- <div id="boven_div"> --><div id="menu_div"><!-- <div id="menubg"> --><tiles:insert attribute="menu" /></div><!-- </div></div> -->
        <div id="maindiv"><div id="content_div"><tiles:insert attribute="content" /></div></div>
        <div id="onder_div"><div id="copyright"></div><div id="initiatief"></div></div></body>
</html>
