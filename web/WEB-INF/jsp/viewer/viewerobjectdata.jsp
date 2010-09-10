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

<div style="margin: 5px;">
    <html:messages id="error" message="true">
        <div id="error"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15" title="<c:out value="${error}" escapeXml="true"/>"/>&nbsp;Niet alle informatie kon worden opgehaald&#160;&#160;</div>
        </html:messages>
    <html:messages id="message" name="acknowledgeMessages">
        <div id="acknowledge">
          <c:out value="${message}"/>
        </div>
    </html:messages>
        <c:choose>
            <c:when test="${not empty thema_items_list and not empty regels_list}">

            <c:set var="themanaam" value="" />
            <c:forEach var="thema_items" items="${thema_items_list}" varStatus="tStatus">
                <p>
                <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                    <c:if test="${ThemaItem.thema.naam != themanaam}">
                        <c:set var="themanaam" value="${ThemaItem.thema.naam}" />
                        <strong>${themanaam}</strong>
                    </c:if>
                </c:forEach>
                <c:set var="regels" value="${regels_list[tStatus.count-1]}"/>
                <c:forEach var="regel" items="${regels}" varStatus="counter">
                    <c:forEach var="waarde" items="${regel.values}" varStatus="kolom">
                        <c:set var="item" value="${thema_items[kolom.count - 1]}"/>
                        <c:if test="${item != null and item.basisregel and item.dataType.id == 1}">
                            <br/>
                            <strong>${item.label}:</strong>
                            <c:choose>
                                <c:when test="${waarde eq '' or  waarde eq null}">
                                    &nbsp;
                                </c:when>
                                <c:otherwise>
                                    ${waarde}
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>

                </c:forEach>
                </p>
            </c:forEach>

        </c:when>
        <c:otherwise>
            <p>Er zijn geen gebieden beschikbaar.</p>
        </c:otherwise>
    </c:choose>
</div>


