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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<div class="contentstyle">
    <h1><fmt:message key="a11y.search.title"/> ${searchName}</h1>

    <p>
        <c:forEach var="entry" items="${a11yResultMap}" varStatus="status">
            <c:if test="${status.count <= 1}">
                <fmt:message key="a11y.search.lastresult"/>
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
            <input type="hidden" name="cmsPageId" value="${cmsPageId}">            
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

            <%-- dropdown met vooringevulde waardes of gebruikt opzoeklijst --%>
            <c:if test="${veld.inputtype == 1}">
                <c:if test="${!empty veld.dropDownValues}">
                    <label for="${veld.label}">
                        <c:out value="${veld.label}" />
                    </label>

                    <%-- vooringevuld waardes --%>
                    <c:set var="dropdownParts" value="${fn:split(veld.dropDownValues, ',')}" />
                    <select id="${veld.label}" name="${veld.label}">
                        <c:forEach var="part" items="${dropdownParts}">                            
                            <option value="${part}">${part}</option>
                        </c:forEach>  
                    </select>
                </c:if>

                <%-- Controleren of er een id veld in result zit, zo ja dan deze id 
                gebruiken voor value in option en de andere tonen en doorgeef
                velden als waarde achter elkaar in dropdown plakken. Opzoeklijsten zonder 
                id veld gewoon op oude manier tonen.
                --%>
                <c:set var="hasIdAttr" value="0" />
                <c:forEach var="entry" items="${dropdownResults}">
                    <c:forEach var="results" items="${entry.value}">
                        <c:forEach var="attr" items="${results.attributen}">
                            <c:if test="${attr.type == 1}">
                                <c:set var="hasIdAttr" value="1" />
                            </c:if>   
                        </c:forEach>
                    </c:forEach>
                </c:forEach>

                <%-- opzoeklijst --%>
                <c:if test="${empty veld.dropDownValues}">
                    <c:forEach var="entry" items="${dropdownResults}">
                        <c:if test="${entry.key == veld.label}">
                            <p class="cf">
                                <label for="${veld.label}">
                                    <c:out value="${veld.label}" />
                                </label>

                                <%-- opzoeklijst met ook alleen tonen resultaatvelden--%>
                                <c:if test="${hasIdAttr == '1'}">
                                    <select id="${veld.label}" name="${veld.label}">
                                        <c:forEach var="results" items="${entry.value}">
                                            <c:forEach var="attr" items="${results.attributen}">
                                                <c:if test="${attr.type == 1}">
                                                    <c:set var="idParams" value="${stat.first ? '' : idParams}${attr.waarde}" />
                                                </c:if>                                        
                                                <c:if test="${attr.type == -1 || attr.type == 2}">
                                                    <c:set var="fieldParams" value="${stat.first ? '' : fieldParams} ${attr.waarde}" />
                                                </c:if>                                        
                                            </c:forEach>

                                            <option value="${idParams}">${fieldParams}</option>

                                            <c:set var="idParams" value="" />
                                            <c:set var="fieldParams" value="" />
                                        </c:forEach>
                                    </select> 
                                </c:if>    

                                <%-- opzoeklijst met alleen tonen en doorgeven resultaatvelden --%>
                                <c:if test="${hasIdAttr == '0'}">                                    
                                    <select id="${veld.label}" name="${veld.label}">
                                        <c:forEach var="results" items="${entry.value}">                        
                                            <c:forEach var="attr" items="${results.attributen}">
                                                <option value="${attr.waarde}">${attr.waarde}</option>
                                            </c:forEach>
                                        </c:forEach>
                                    </select> 
                                </c:if>
                            </p>
                        </c:if>
                    </c:forEach>
                </c:if>   
            </c:if>
        </c:forEach>

        <p class="cf"><input type="submit" value="<fmt:message key="a11y.search.label"/>" /></p>

        <!-- Alleen uitleg tonen als er een omschrijving in een van de velden is -->
        <c:set var="zoekUitleg" value="false" />
        <c:forEach var="veld" items="${zoekVelden}">
            <c:if test="${!empty veld.omschrijving}" >
                <c:set var="zoekUitleg" value="true" />
            </c:if>
        </c:forEach>

        <c:if test="${fn:length(zoekVelden) > 0 and zoekUitleg == true}">
            <h2><fmt:message key="a11y.search.explain"/></h2>
            <p>
                <c:forEach var="veld" items="${zoekVelden}">
                    <c:if test="${!empty veld.omschrijving}" >
                        <c:out value="${veld.label}" />: <c:out value="${veld.omschrijving}" /><br>
                    </c:if>                        
                </c:forEach>
            </p>
        </c:if>


    </form>

    <p>
        <html:link page="/a11yViewer.do?appCode=${appCode}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink" module="">
            <fmt:message key="a11y.results.othersearch"/>
        </html:link>
    </p>

</div>
