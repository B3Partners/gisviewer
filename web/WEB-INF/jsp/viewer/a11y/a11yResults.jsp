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
        <title>Accessibility Viewer | Resultaten voor ${searchName}</title>
    </head>
    <body>
        <h1>Accessibility Viewer | Resultaten voor ${searchName}</h1>

        <p>
            <c:forEach var="entry" items="${searchparams}" varStatus="status">
                <c:if test="${status.count <= 1}">
                    U heeft gezocht op
                </c:if>

                <c:if test="${entry.value != ''}">
                    ${entry.key} "${entry.value}"                                 
                </c:if>
            </c:forEach>
        </p>

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
                    <c:set var="resultParams" value="${stat.first ? '' : resultParams}&amp;${entry.key}=${entry.value}" />
                </c:forEach> 

                <c:if test="${countPrev >= 0}">
                    <html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countPrev}&amp;limit=${limit}" styleClass="searchLink">Vorige</html:link>
                </c:if>

                <c:forEach var="i" begin="1" end="${pageNr}" step="1" varStatus="status">
                    <c:set var="startIndex" value="${(i-1) * limit}" />

                    <html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${startIndex}&amp;limit=${limit}" styleClass="searchLink">${i}</html:link>
                </c:forEach>

                <c:if test="${countNext < count}">
                    <html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countNext}&amp;limit=${limit}" styleClass="searchLink">Volgende</html:link>
                </c:if>
            </c:if>
        </p>

        <c:forEach var="result" items="${results}" begin="0" end="0">  
            <c:forEach var="attr" items="${result.attributen}">
                <c:if test="${attr.type == 2 || attr.type == 120}" >
                    <div class="div-table-header">
                        ${attr.label}
                    </div>
                </c:if>
            </c:forEach>
        </c:forEach>

        <c:if test="${nextStep == true && count > 0}">
            <div class="div-table-header">Actie</div>
        </c:if>

        <div style="clear: both;"></div>

        <c:forEach var="result" items="${results}">  
            <form action="a11yViewer.do" method="POST">
                <p>
                    <input type="hidden" name="search" value="t">
                    <input type="hidden" name="appCode" value="${appCode}">

                    <c:if test="${nextStep == true}">
                        <input type="hidden" name="searchConfigId" value="${nextSearchConfigId}">
                    </c:if>

                    <c:if test="${nextStep == false}">
                        <input type="hidden" name="searchConfigId" value="${searchConfigId}">
                    </c:if>     
                </p>

                <c:forEach var="attr" items="${result.attributen}">
                    <c:if test="${attr.type == 2 || attr.type == 120}">
                        <div class="div-table-row">${attr.waarde}</div>
                    </c:if>

                    <p>
                        <input type="hidden" name="${attr.label}" value="${attr.waarde}">
                    </p>
                </c:forEach>

                <c:if test="${nextStep == true}">
                    <div class="div-table-row">
                        <input type="submit" value="Verder zoeken">
                    </div>
                </c:if>  
            </form>

            <div style="clear: both;"></div>
        </c:forEach>

        <h2>Uitleg resultaatvelden</h2>
        <p>
            <c:forEach var="result" items="${results}" begin="0" end="0">  
                <c:forEach var="attr" items="${result.attributen}">
                    <c:if test="${attr.type == 2 || attr.type == 120}" >
                        <c:out value="${attr.label}" />: <c:out value="${attr.omschrijving}" /><br>
                    </c:if>
                </c:forEach>
            </c:forEach>
        </p>

        <div id="footer">
            <address>Zonnebaan 12C</address>
        </div>
    </body>
</html>