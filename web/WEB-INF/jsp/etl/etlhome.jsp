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

<div class="onderbalk">ETL OVERZICHT<span><tiles:insert name="loginblock"/></span></div>
<table id="etl_overview_table" style="table-layout: fixed; clear: left;">
    <tr class="etlTopRow">
        <td style="width: 300px;"><b>&nbsp;Thema naam</b></td>
        <td><b>&nbsp;Aantal NO</b></td>
        <td><b>&nbsp;Aantal OAO</b></td>
        <td><b>&nbsp;Aantal OGO</b></td>
        <td><b>&nbsp;Aantal GO</b></td>
        <td><b>&nbsp;Aantal VO</b></td>
        <td><b>&nbsp;Aantal OO</b></td>
        <td><b>&nbsp;Totaal</b></td>
        <td><b>&nbsp;% incorrect</b></td>
    </tr>
    <c:forEach var="nItem" items="${overview}" varStatus="counter">
        <c:choose>
            <c:when test="${counter.count % 2 == 1}">
                <tr class="etlRow">
            </c:when>
            <c:otherwise>
                <tr class="etlRow" style="background-color: #DDDDDD;">
                </c:otherwise>
            </c:choose>
            <c:forEach var="item" items="${nItem}" varStatus="i">
                <c:choose>
                    <c:when test="${i.count == 1}">
                        <td style="width: 300px;"><a href="<html:rewrite page="/etltransform.do?showOptions=submit&themaid=${item}"/>">
                            </c:when>
                            <c:when test="${i.count == 2}">
                        &nbsp;${item}</a></td>
                    </c:when>
                    <c:when test="${i.count == 10}">
                        <td style="width: 300px;"><b>&nbsp;${item}&nbsp;%</b></td>
                    </c:when>
                    <c:otherwise>
                        <td>&nbsp;${item}</td>                        
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </tr>
    </c:forEach>
</table>
<ul>
    <li><b>NO</b>  - Nieuwe objecten</li>
    <li><b>OAO</b> - Onvolledig Administratieve Objecten</li>
    <li><b>OGO</b> - Onvolledig Geografische Objecten</li>
    <li><b>GO</b>  - Geupdate Objecten</li>
    <li><b>VO</b>  - Verwijderde Objecten</li>
    <li><b>OO</b>  - Ongewijzigde Objecten</li>
    <li>Totaal: alle objecten bij elkaar opgeteld</li>
    <li>% incorrect: ((OAO + OGO) / Totaal) * 100</li>
</ul>