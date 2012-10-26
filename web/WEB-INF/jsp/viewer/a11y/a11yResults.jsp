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

        <c:if test="${count < 1}" >
            <p>Er zijn geen resultaten gevonden.</p>
        </c:if>

        <c:if test="${count == 1}" >
            <p>Er is 1 resultaat gevonden.</p>
        </c:if>

        <c:if test="${count > 1}" >
            <p>Er zijn ${count} resultaten gevonden.</p>
        </c:if>

        <table>
            <tr>
                <c:forEach var="result" items="${results}" begin="0" end="0">  
                    <c:forEach var="attr" items="${result.attributen}">
                        <c:if test="${attr.type == 2}" >
                            <th align="left">${attr.label}</th>
                        </c:if>
                    </c:forEach>
                </c:forEach>

                <c:if test="${nextStep == true}">
                    <th align="left">Actie</th>
                </c:if>
            </tr>

            <c:forEach var="result" items="${results}">  
                <form action="a11yViewer.do" method="POST">
                    <input type="hidden" name="search" value="t" />
                    <input type="hidden" name="appCode" value="${appCode}" />
                    <input type="hidden" name="searchConfigId" value="${searchConfigId}" />

                    <tr>
                        <c:forEach var="attr" items="${result.attributen}">
                            <c:if test="${attr.type == 2 || attr.type == 120}" >
                                <%-- <c:out value="${attr.label}" /> = <c:out value="${attr.waarde}" /> --%>
                                <td>${attr.waarde}</td>
                            </c:if>

                        <input type="hidden" name="${attr.label}" value="${attr.waarde}" />
                    </c:forEach>

                    <c:if test="${nextStep == true}">
                        <td><input type="submit" value="Verder zoeken" /></td>
                        </c:if>   
                    </tr>
                </form>
            </c:forEach>

            <table>
</body>
</html>