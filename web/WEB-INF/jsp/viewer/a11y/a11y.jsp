<%-- 
    Document   : a11y.jsp
    Created on : 23-okt-2012, 16:55:02
    Author     : Boy de Wit
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <link href="styles/gisviewer_a11y.css" rel="stylesheet" type="text/css">

        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Accessibility Viewer</title>
    </head>
    <body>
        <h1>Accessibility Viewer</h1>

        <p>Appcode = ${appCode}</p>

        <p>Zoekers</p>
        <c:forEach var="zc" items="${zoekConfigs}">
            <p>
                <html:link page="/a11yViewer.do?search=t&appCode=${appCode}&searchConfigId=${zc.id}" styleClass="searchLink" module="">
                    <c:out value="${zc.naam}" />
                </html:link>
            </p>
        </c:forEach>
    </body>
</html>
