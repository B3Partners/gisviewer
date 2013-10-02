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
    <h1><fmt:message key="a11y.results.title"/> ${searchName}</h1>

    <p>
        <c:forEach var="entry" items="${a11yResultMap}" varStatus="status">
            <c:if test="${status.count <= 1}">
                Uw huidige startlocatie is:
            </c:if>

            <c:if test="${entry.value != ''}">
                ${entry.key} "${entry.value}"                                 
            </c:if>
        </c:forEach>
    </p>
    
    <p>
        <c:forEach var="entry" items="${searchparams}" varStatus="status">
            <c:if test="${status.count <= 1}">
                <fmt:message key="a11y.results.searchtext"/>
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
        <p><fmt:message key="a11y.results.noresults"/></p>
    </c:if>

    <c:if test="${count == 1}" >
        <p><fmt:message key="a11y.results.oneresult"/></p>
    </c:if>

    <c:set var="resultNr" value="${startIndex}" />

    <c:if test="${count > 1}" >
        <p><fmt:message key="a11y.results.numresults1"/> ${count} <fmt:message key="a11y.results.numresults2"/> ${startIndex+1} <fmt:message key="a11y.results.numresults3"/> ${total} <fmt:message key="a11y.results.numresults4"/></p>
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
            <c:if test="${countPrev >= 0}"><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countPrev}&amp;limit=${limit}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink"><fmt:message key="a11y.results.prev"/></html:link> | </c:if><c:forEach var="i" begin="1" end="${pageNr}" step="1" varStatus="status"><c:set var="startIndex" value="${(i-1) * limit}" /><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${startIndex}&amp;limit=${limit}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink">${i}</html:link> | </c:forEach><c:if test="${countNext < count}"><html:link page="/a11yViewer.do?results=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}${resultParams}&amp;startIndex=${countNext}&amp;limit=${limit}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink"><fmt:message key="a11y.results.next"/></html:link></c:if>
        </c:if>
    </p>
    
    <table class="result-table">
        <thead>
            <tr>
                <c:forEach var="result" items="${results}" begin="0" end="0">
                    <th class="small">Nr.</th>
                    <c:forEach var="attr" items="${result.attributen}">
                        <c:if test="${attr.type == -1 || attr.type == 2 || attr.type == 120}" >
                            <th>
                                ${attr.label}
                            </th>
                        </c:if>
                    </c:forEach>
                </c:forEach>
                <c:if test="${nextStep == true && count > 0}">
                    <th><fmt:message key="a11y.results.action"/></th>
                </c:if>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="result" items="${results}" varStatus="status">  
                <tr>
                    <td class="small">${status.count + resultNr}</td>
                    <c:forEach var="attr" items="${result.attributen}">
                        <td>                                
                            ${attr.waarde}
                        </td>
                    </c:forEach>

                    <c:if test="${nextStep == true and startLocation == false}">
                        <td>
                            <%-- TODO: create link to continue search, ie: a11ysearch.do?searchResult=2&searchConfig=4 --%>
                            <a href="/a11ysearch.do?searchResult=${attr.id}&searchConfig=${nextSearchConfigId}"><fmt:message key="a11y.results.continue"/></a>
                        </td>
                    </c:if>  

                    <c:if test="${nextStep == false and startLocation == true}">
                        <td>
                            <%-- TODO: create link to startlocation, ie: a11ystartlocation.do?searchResult=2&searchConfig=4 --%>
                            <a href="#"><fmt:message key="a11y.results.startlocation"/></a>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Alleen uitleg tonen als er een omschrijving in een van de velden is -->
    <c:set var="resultaatUitleg" value="false" />
    <c:forEach var="veld" items="${results}">
        <c:forEach var="attr" items="${result.attributen}">
            <c:if test="${(attr.type == -1 || attr.type == 2 || attr.type == 120) && !empty attr.omschrijving}" >
                <c:set var="resultaatUitleg" value="true" />
            </c:if>
        </c:forEach>
    </c:forEach>

    <c:if test="${fn:length(results) > 0 and resultaatUitleg == true}">
        <h2><fmt:message key="a11y.results.explain"/></h2>
        <p>
            <c:forEach var="result" items="${results}" begin="0" end="0">  
                <c:forEach var="attr" items="${result.attributen}">
                    <c:if test="${(attr.type == -1 || attr.type == 2 || attr.type == 120) && !empty attr.omschrijving}" >
                        <c:out value="${attr.label}" />: <c:out value="${attr.omschrijving}" /><br>
                    </c:if>
                </c:forEach>
            </c:forEach>
        </p>
    </c:if>

    <p>
        <html:link page="/a11yViewer.do?search=t&amp;appCode=${appCode}&amp;searchConfigId=${searchConfigId}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink" module="">
            <fmt:message key="a11y.results.searchagain"/>
        </html:link> |
        
        <html:link page="/a11yViewer.do?appCode=${appCode}&amp;cmsPageId=${cmsPageId}" styleClass="searchLink" module="">
            <fmt:message key="a11y.results.othersearch"/>
        </html:link>
    </p>

</div>
