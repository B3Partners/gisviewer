<%--
B3P Gisviewer is an extension to Flamingo MapComponents making
it a complete webbased GIS viewer and configuration tool that
works in cooperation with B3P Kaartenbalie.

Copyright 2012-2013 B3Partners BV

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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<div class="contentstyle">
    <h1><fmt:message key="a11y.home.title"/></h1>
    
    <c:if test="${fn:length(zoekConfigs) < 1}">
        <p><fmt:message key="a11y.home.nofinder"/></p>
    </c:if>    

    <c:if test="${fn:length(zoekConfigs) > 0}">
        <ul class="searchEntries">
            <c:forEach var="zc" items="${zoekConfigs}">
                <li>
                    <p>
                        <html:link page="/a11yViewer.do?search=t&amp;appCode=${appCode}&amp;searchConfigId=${zc.id}" styleClass="searchLink" module="">
                            <c:out value="${zc.naam}" />
                        </html:link>
                    </p>
                    <p>
                        <c:out value="${zc.omschrijving}" />
                    </p>
                </li>
            </c:forEach>
        </ul>
    </c:if>
</div>
