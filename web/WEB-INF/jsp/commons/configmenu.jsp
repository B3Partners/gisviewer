<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  
                    
Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
<c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />

<c:set var="links" value='<a class="*" href="configConnectie.do">&#155; Connectie</a>%<a class="*" href="configThemaData.do">&#155; Thema Data</a>%<a class="*" href="configCluster.do">&#155; Cluster</a>%<a class="*" href="configThema.do">&#155; Thema</a>%<a class="*" href="index.do">&#155; Home</a>' />

<div class="topmenu">
    <c:set var="lnkArray" value="${fn:split(links, '%')}" />
    
    <c:if test="${requestJSP eq 'index.do'}">
        <c:set var="activelink" value="5" />
    </c:if>
    <c:if test="${requestJSP eq 'configThema.do'}">
        <c:set var="activelink" value="4" />
    </c:if>
    <c:if test="${requestJSP eq 'configCluster.do'}">
        <c:set var="activelink" value="3" />
    </c:if>
    <c:if test="${requestJSP eq 'configThemaData.do'}">
        <c:set var="activelink" value="2" />
    </c:if>
    <c:if test="${requestJSP eq 'configConnectie.do'}">
        <c:set var="activelink" value="1" />
    </c:if>
    
    <c:forEach items="${lnkArray}" var="link" varStatus="counter">
        <c:choose>
            <c:when test="${counter.count == activelink}">
                <c:out value="${fn:replace(link, '*', 'activemenulink')}" escapeXml="false" />    
            </c:when>
            <c:otherwise>
                <c:out value="${fn:replace(link, '*', 'menulink')}" escapeXml="false" />
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
<div class="menu_boven_logo"></div>