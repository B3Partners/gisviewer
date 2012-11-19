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
        <title>Accessibility Viewer | ${searchName}</title>
    </head>
    <body>
        <h1>Accessibility Viewer | ${searchName}</h1>

        <form action="a11yViewer.do" method="GET">
            <input type="hidden" name="results" value="t" />            
            <input type="hidden" name="appCode" value="${appCode}" />
            <input type="hidden" name="searchConfigId" value="${searchConfigId}" />
            <input type="hidden" name="startIndex" value="0" />        
            <input type="hidden" name="limit" value="25" />        

            <c:forEach var="veld" items="${zoekVelden}">
                <c:if test="${veld.inputtype == 2}">
                    <c:set var="added" value="0" />

                    <c:forEach var="entry" items="${params}">
                        <c:if test="${entry.key == veld.label}">
                            <c:set var="added" value="1" />
                            <c:if test="${veld.type == 110 || veld.type == 3}">                                
                                <input type="hidden" name="${veld.label}" value="${entry.value}"/>
                            </c:if>
                            <c:if test="${veld.type == 0}">
                                <p><c:out value="${veld.label}" /> <input type="text" name="${veld.label}" value="${entry.value}"/></p>
                                </c:if>
                            </c:if>
                        </c:forEach>

                    <c:if test="${added == 0}">
                        <c:if test="${veld.type == 110 || veld.type == 3}">
                            <p><input type="hidden" name="${veld.label}" />
                            </c:if>
                            <c:if test="${veld.type == 0}">
                            <p><c:out value="${veld.label}" /> <input type="text" name="${veld.label}" /></p>
                            </c:if>
                        </c:if>
                    </c:if>

                <c:if test="${veld.inputtype == 1}">
                    <c:forEach var="entry" items="${dropdownResults}">
                        <c:if test="${entry.key == veld.label}">
                            <c:out value="${veld.label}" /> <select name="${veld.label}">
                                <c:forEach var="results" items="${entry.value}">                        
                                    <c:forEach var="attr" items="${results.attributen}">
                                        <option value="${attr.waarde}">${attr.waarde}</option>
                                    </c:forEach>
                                </c:forEach>
                            </select>  
                        </c:if>
                    </c:forEach>
                </c:if>   
            </c:forEach>
            
            <h2>Uitleg zoekvelden</h2>
            <p>
                <c:forEach var="veld" items="${zoekVelden}">
                    <c:out value="${veld.label}" />: <c:out value="${veld.omschrijving}" /><br>
                </c:forEach>
            </p>

            <p><input type="submit" value="Zoeken" /></p>
        </form>
    </body>
</html>
