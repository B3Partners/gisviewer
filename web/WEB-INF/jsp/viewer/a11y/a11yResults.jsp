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
        <h1>Accessibility Viewer | Resultaten voor ${searchName}</h1>

        <c:set var="total" value="${startIndex + limit}" />

        <c:if test="${total > count}">
            <c:set var="total" value="${count}" />
        </c:if>

        <c:if test="${count < 1}" >
            <p>Er zijn geen resultaten gevonden.</p>
        </c:if>

        <c:if test="${count == 1}" >
            <p>Er is 1 resultaat gevonden.</p>
        </c:if>

        <c:if test="${count > 1}" >
            <p>Er zijn ${count} resultaten gevonden. Resultaten ${startIndex+1} tot ${total} worden getoond.</p>
        </c:if>

        <p>
            <%-- Pagination --%>
            <c:set var="pageNr" value="${count / limit +(1-(count / limit %1))%1}" />

            <c:if test="${pageNr > 1}">
                <c:set var="countPrev" value="${startIndex - limit}" />
                <c:set var="countNext" value="${startIndex + limit}" />

                <c:forEach var="entry" items="${params}">
                    <c:set var="resultParams" value="${stat.first ? '' : resultParams}&${entry.key}=${entry.value}" />
                </c:forEach> 

                <c:if test="${countPrev >= 0}">
                    <html:link page="/a11yViewer.do?results=t&appCode=${appCode}&searchConfigId=${searchConfigId}${resultParams}&startIndex=${countPrev}&limit=${limit}" styleClass="searchLink" module="">
                        Vorige
                    </html:link>
                </c:if>

                <c:forEach var="i" begin="1" end="${pageNr}" step="1" varStatus="status">
                    <c:set var="startIndex" value="${(i-1) * limit}" />

                    <html:link page="/a11yViewer.do?results=t&appCode=${appCode}&searchConfigId=${searchConfigId}${resultParams}&startIndex=${startIndex}&limit=${limit}" styleClass="searchLink" module="">
                        ${i}
                    </html:link>
                </c:forEach>

                <c:if test="${countNext < count}">
                    <html:link page="/a11yViewer.do?results=t&appCode=${appCode}&searchConfigId=${searchConfigId}${resultParams}&startIndex=${countNext}&limit=${limit}" styleClass="searchLink" module="">
                        Volgende
                    </html:link>
                </c:if>
            </c:if>
        </p>

        <table>
            <tr>
                <c:forEach var="result" items="${results}" begin="0" end="0">  
                    <c:forEach var="attr" items="${result.attributen}">
                        <c:if test="${attr.type == 2 || attr.type == 120}" >
                            <th align="left">${attr.label}</th>
                        </c:if>
                    </c:forEach>
                </c:forEach>

                <c:if test="${nextStep == true && count > 0}">
                    <th align="left">Actie</th>
                </c:if>
            </tr>

            <c:forEach var="result" items="${results}">  
                <form action="a11yViewer.do" method="POST">
                    <input type="hidden" name="search" value="t" />
                    <input type="hidden" name="appCode" value="${appCode}" />

                    <c:if test="${nextStep == true}">
                        <input type="hidden" name="searchConfigId" value="${nextSearchConfigId}" />
                    </c:if>

                    <c:if test="${nextStep == false}">
                        <input type="hidden" name="searchConfigId" value="${searchConfigId}" />
                    </c:if>                    

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