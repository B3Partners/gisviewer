<%-- 
    Document   : a11y.jsp
    Created on : 14-dec-2012
    Author     : Boy de Wit
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="NL">
    <head>
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_a11y.css" rel="stylesheet" type="text/css">

        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Accessibility Viewer | Startlocatie</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="header"><div id="header_content"></div></div>
            <div id="content_normal">
                <div id="content">
                    <div class="contentstyle">
                        <h1>Accessibility Viewer | Startlocatie</h1>

                        <p>Uw startlocatie is ingesteld.</p>

                        <hr>
                        <div>
                            <html:link page="/viewer.do?appCode=${appCode}&amp;accessibility=1" styleClass="searchLink" module="">
                                Startpagina
                            </html:link> |
                            <html:link page="/viewer.do?appCode=${appCode}" styleClass="searchLink" module="">
                                Ga naar de kaartviewer
                            </html:link>
                            <div style="float: right;">
                                <address>B3Partners: Zonnebaan 12C, 3542 EC, Utrecht</address>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>