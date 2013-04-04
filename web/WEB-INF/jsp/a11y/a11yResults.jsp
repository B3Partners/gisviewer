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
    <h1>Resultaten voor ${searchName}</h1>

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

    <c:set var="resultNr" value="${startIndex}" />

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
            <c:if test="${countPrev >= 0}"><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countPrev}&amp;limit=${limit}" styleClass="searchLink">Vorige</html:link> | </c:if><c:forEach var="i" begin="1" end="${pageNr}" step="1" varStatus="status"><c:set var="startIndex" value="${(i-1) * limit}" /><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${startIndex}&amp;limit=${limit}" styleClass="searchLink">${i}</html:link> | </c:forEach><c:if test="${countNext < count}"><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countNext}&amp;limit=${limit}" styleClass="searchLink">Volgende</html:link></c:if>
        </c:if>
    </p>

    <div class="div-table-header cf">
        <c:forEach var="result" items="${results}" begin="0" end="0">
            <div class="small">Nr.</div>
            <c:forEach var="attr" items="${result.attributen}">
                <c:if test="${attr.type == 2 || attr.type == 120}" >
                    <div>
                        ${attr.label}
                    </div>
                </c:if>
            </c:forEach>
        </c:forEach>
        <c:if test="${nextStep == true && count > 0}">
            <div>Actie</div>
        </c:if>
    </div>

    <c:forEach var="result" items="${results}" varStatus="status">  
        <div class="div-table-row cf">
            <form action="a11yViewer.do" method="POST">
                <c:if test="${startLocation == true}">
                    <input type="hidden" name="startLocation" value="t">
                </c:if>
                <c:if test="${startLocation == false}">
                    <input type="hidden" name="search" value="t">
                </c:if>                        

                <input type="hidden" name="appCode" value="${appCode}">

                <c:if test="${nextStep == true}">
                    <input type="hidden" name="searchConfigId" value="${nextSearchConfigId}">
                </c:if>

                <c:if test="${nextStep == false}">
                    <input type="hidden" name="searchConfigId" value="${searchConfigId}">
                </c:if>

                <div class="small">${status.count + resultNr}</div>

                <c:forEach var="attr" items="${result.attributen}">
                    <c:if test="${attr.type == 2 || attr.type == 120}">
                        <div>${attr.waarde}</div>
                    </c:if>
                    <c:if test="${attr.type == 33}">
                        <input type="hidden" name="startGeom" value="${attr.waarde}">
                    </c:if>
                    <c:if test="${attr.type != 33}">
                        <input type="hidden" name="${attr.label}" value="${attr.waarde}">
                    </c:if>
                </c:forEach>

                <c:if test="${nextStep == true and startLocation == false}">
                    <div>
                        <input type="hidden" name="nextStep" value="t">
                        <input type="submit" value="Verder zoeken">
                    </div>
                </c:if>  

                <c:if test="${nextStep == false and startLocation == true}">
                    <div>
                        <input type="submit" value="Als startlocatie instellen">
                    </div>
                </c:if>
            </form>
        </div>
    </c:forEach>

    <!-- Alleen uitleg tonen als er een omschrijving in een van de velden is -->
    <c:set var="resultaatUitleg" value="false" />
    <c:forEach var="veld" items="${results}">
        <c:forEach var="attr" items="${result.attributen}">
            <c:if test="${(attr.type == 2 || attr.type == 120) && !empty attr.omschrijving}" >
                <c:set var="resultaatUitleg" value="true" />
            </c:if>
        </c:forEach>
    </c:forEach>

    <c:if test="${fn:length(results) > 0 and resultaatUitleg == true}">
        <h2>Uitleg resultaatvelden</h2>
        <p>
            <c:forEach var="result" items="${results}" begin="0" end="0">  
                <c:forEach var="attr" items="${result.attributen}">
                    <c:if test="${(attr.type == 2 || attr.type == 120) && !empty attr.omschrijving}" >
                        <c:out value="${attr.label}" />: <c:out value="${attr.omschrijving}" /><br>
                    </c:if>
                </c:forEach>
            </c:forEach>
        </p>
    </c:if>

</div>
