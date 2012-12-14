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
        <link href="styles/gisviewer_a11y.css" rel="stylesheet" type="text/css">

        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Accessibility Viewer | Startlocatie</title>
    </head>
    <body>
        <h1>Accessibility Viewer | Startlocatie</h1>

        <p>Uw startlocatie is ingesteld.</p>

        <p>
            <html:link page="/index.do" styleClass="searchLink" module="">
                Ga terug naar de home pagina
            </html:link>
        </p>

        <div id="footer">
            <address>Zonnebaan 12C</address>
        </div>
    </body>
</html>