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
        <title>Accessibility Viewer | Zoeken</title>
    </head>
    <body>
        <h1>Accessibility Viewer | Zoeken</h1>

        <p>Welkom bij de Zoeker</p>

        <p>Appcode = ${appCode}</p>
        <p>Zoeker id = ${searchConfigId}</p>

        <p>Zoekvelden</p>

        <form action="a11yViewer.do" method="GET">
            <input type="hidden" name="results" value="t" />            
            <input type="hidden" name="appCode" value="${appCode}" />
            <input type="hidden" name="searchConfigId" value="${searchConfigId}" />

            <c:forEach var="veld" items="${zoekVelden}">
                <c:if test="${veld.inputtype == 2}">
                    <p><c:out value="${veld.label}" /> <input type="text" name="${veld.label}" /></p>
                    </c:if>  

                <c:if test="${veld.inputtype == 1}">
                    <c:set var="dropDownresults" value="dropdown_${veld.label}" />
                    
                    <c:out value="${veld.label}" />
                    
                    <select name="${veld.label}">
                        <%-- TODO: dropdown_naam vervangen voor variable in dropDownresults --%>
                        <c:forEach var="results" items="${dropdown_naam}">                        
                            <c:forEach var="attr" items="${results.attributen}">
                                <option value="${attr.waarde}">${attr.waarde}</option>
                            </c:forEach>
                        </c:forEach>
                    </select>                            
                </c:if>   
            </c:forEach>

            <p><input type="submit" value="Zoeken" /></p>
        </form>
    </body>
</html>
