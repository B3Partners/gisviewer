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
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_design.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_a11y.css" rel="stylesheet" type="text/css">

        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Accessibility Viewer | ${searchName}</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="header"><div id="header_content"></div></div>
            <div id="content_normal">
                <div id="content">
                    <div class="contentstyle">
                        <h1>Accessibility Viewer | ${searchName}</h1>

                        <p>
                            <c:forEach var="entry" items="${a11yResultMap}" varStatus="status">
                                <c:if test="${status.count <= 1}">
                                    Uw vorige zoekresultaat was
                                </c:if>

                                <c:if test="${entry.value != ''}">
                                    ${entry.key} "${entry.value}"                                 
                                </c:if>
                            </c:forEach>
                        </p>

                        <form action="a11yViewer.do" method="GET">
                            <p>
                                <input type="hidden" name="results" value="t">         
                                <input type="hidden" name="appCode" value="${appCode}">
                                <input type="hidden" name="searchConfigId" value="${searchConfigId}">
                                <input type="hidden" name="startIndex" value="0">        
                                <input type="hidden" name="limit" value="25">        
                            </p>

                            <c:forEach var="veld" items="${zoekVelden}" varStatus="status">
                                <c:if test="${veld.inputtype == 2}">
                                    <c:set var="added" value="0" />

                                    <c:forEach var="entry" items="${params}">
                                        <c:if test="${entry.key == veld.label}">
                                            <c:set var="added" value="1" />
                                            <c:if test="${veld.type == 110 || veld.type == 3}">                                
                                                <p><input type="hidden" name="${veld.label}" value="${entry.value}"></p>
                                                </c:if>
                                                <c:if test="${veld.type == 0}">
                                                <p class="cf">
                                                    <label for="${veld.label}"><c:out value="${veld.label}" /></label><input type="text" name="${veld.label}" value="${entry.value}">
                                                </p>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>

                                    <c:if test="${added == 0}">
                                        <c:if test="${veld.type == 110 || veld.type == 3}">
                                            <p><input type="hidden" name="${veld.label}"></p>
                                            </c:if>
                                            <c:if test="${veld.type == 0 || veld.type == 6}">
                                            <p class="cf">
                                                <label for="${veld.label}"><c:out value="${veld.label}" /></label><input tabindex="${status.count}" id="${veld.label}" type="text" name="${veld.label}">
                                            </p>
                                        </c:if>
                                    </c:if>
                                </c:if>

                                <c:if test="${veld.inputtype == 1}">
                                    <c:forEach var="entry" items="${dropdownResults}">
                                        <c:if test="${entry.key == veld.label}">
                                            <p class="cf">
                                                <c:out value="${veld.label}" />
                                                <label for="${veld.label}">
                                                    <select id="${veld.label}" name="${veld.label}">
                                                        <c:forEach var="results" items="${entry.value}">                        
                                                            <c:forEach var="attr" items="${results.attributen}">
                                                                <option value="${attr.waarde}">${attr.waarde}</option>
                                                            </c:forEach>
                                                        </c:forEach>
                                                    </select>  
                                                </label>
                                            </p>
                                        </c:if>
                                    </c:forEach>
                                </c:if>   
                            </c:forEach>

                            <p class="cf"><input type="submit" value="Zoeken" /></p>

                            <!-- Alleen uitleg tonen als er een omschrijving in een van de velden is -->
                            <c:set var="zoekUitleg" value="false" />
                            <c:forEach var="veld" items="${zoekVelden}">
                                <c:if test="${!empty veld.omschrijving}" >
                                    <c:set var="zoekUitleg" value="true" />
                                </c:if>
                            </c:forEach>

                            <c:if test="${fn:length(zoekVelden) > 0 and zoekUitleg == true}">
                                <h2>Uitleg zoekvelden</h2>
                                <p>
                                    <c:forEach var="veld" items="${zoekVelden}">
                                        <c:if test="${!empty veld.omschrijving}" >
                                            <c:out value="${veld.label}" />: <c:out value="${veld.omschrijving}" /><br>
                                        </c:if>                        
                                    </c:forEach>
                                </p>
                            </c:if>


                        </form>
                            
                        <hr>
                        <div>
                            <html:link page="/viewer.do?appCode=${appCode}&amp;accessibility=1" styleClass="searchLink" module="">
                                Startpagina
                            </html:link> |
                            <html:link page="/viewer.do?appCode=${appCode}" styleClass="searchLink" module="">
                                Ga naar de kaartviewer
                            </html:link>
                            <div style="float: right;">
                                <address>Zonnebaan 12C</address>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
