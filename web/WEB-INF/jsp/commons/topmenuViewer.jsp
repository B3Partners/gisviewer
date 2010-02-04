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
<%@ page isELIgnored="false"%>

<c:if test="${pageContext.request.remoteUser != null}">
    <c:if test="${f:isUserInRole(pageContext.request, 'beheerder')}">
        <c:set var="beheerder" value="true"/>
    </c:if>
</c:if>

<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    <c:set var="kaartid" value="${param['id']}"/>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'help.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/help.do?id=${kaartid}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.help"/></html:link>

    <c:choose>
        <c:when test="${beheerder == true}">
            <c:set var="stijlklasse" value="menulink" />
            <c:if test="${requestJSP eq 'configThema.do'}">
                <c:set var="stijlklasse" value="activemenulink" />
            </c:if>
            <html:link page="/configThema.do?id=${kaartid}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.configuratie"/></html:link>
        </c:when>
        <c:otherwise>
            <%--
            <c:set var="stijlklasse" value="menulink" />
            <c:if test="${requestJSP eq 'contact.do'}">
                <c:set var="stijlklasse" value="activemenulink" />
            </c:if>
            <html:link page="/index.do" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.contact"/></html:link>
            --%>
        </c:otherwise>
    </c:choose>

    <html:link href="javascript: exportMap();" styleClass="menulink" module=""><fmt:message key="commons.topmenuviewer.print"/></html:link>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/viewer.do?id=${kaartid}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.viewer"/></html:link>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/indexlist.do?id=${kaartid}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>


</div>