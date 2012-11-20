<%-- 
    Document   : a11y.jsp
    Created on : 23-okt-2012, 16:55:02
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
        <title>Accessibility Viewer</title>
    </head>
    <body>
        <h1>Accessibility Viewer</h1>

        <p>Beschikbare zoekers</p>
        <c:forEach var="zc" items="${zoekConfigs}">
            <p>
                <c:out value="${zc.omschrijving}" />
            </p>
            <p>
                <html:link page="/a11yViewer.do?search=t&amp;appCode=${appCode}&amp;searchConfigId=${zc.id}" styleClass="searchLink" module="">
                    <c:out value="${zc.naam}" />
                </html:link>
            </p>
        </c:forEach>

        <div id="footer">
            <address>Zonnebaan 12C</address>
        </div>
    </body>
</html>
