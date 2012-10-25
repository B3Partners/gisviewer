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
        <title>Accessibility Viewer | Resultaten</title>
    </head>
    <body>
        <h1>Accessibility Viewer | Resultaten</h1>

        <c:forEach var="result" items="${results}">            
            <c:forEach var="attr" items="${result.attributen}">
                <p><c:out value="${attr.label}" /> = <c:out value="${attr.waarde}" /></p>
            </c:forEach>
        </c:forEach>
    </body>
</html>
