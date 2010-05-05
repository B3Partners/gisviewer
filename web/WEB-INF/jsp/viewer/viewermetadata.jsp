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
<div class="meta_data_scroll">
    <c:choose>
        <c:when test="${not empty themas}">
            <c:set var="klasse" value="meta_data_alternate" />
            <div class="${klasse}">
                <h1>A. Algemene informatie over ${themas.naam}</h1>
                <table>
                    <tr>
                        <th>
                            <c:out value="Moscow"/>
                        </th>
                        <td>
                            <c:out value="${themas.moscow.naam}"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <c:out value="Belangnr"/>
                        </th>
                        <td>
                            <c:out value="${themas.belangnr}"/>
                        </td>
                    </tr>
                    <c:if test="${not empty themas.opmerkingen}">
                        <tr>
                            <th>
                                <c:out value="Opmerkingen"/>
                            </th>
                            <td>
                                <c:out value="${themas.opmerkingen}"/>
                            </td>
                        </tr>
                    </c:if>
                </table>
            </div>
            <c:if test="${not empty themas.themaApplicaties}">
                <c:choose>
                    <c:when test="${klasse eq 'meta_data_normal'}">
                        <c:set var="klasse" value="meta_data_alternate" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="klasse" value="meta_data_normal" />
                    </c:otherwise>
                </c:choose>
                <c:set var="finalFound" value="false"/>
                <c:forEach var="item" items="${themas.themaApplicaties}">
                    <c:if test="${item.definitief}">
                        <c:set var="finalFound" value="true"/>
                    </c:if>
                </c:forEach>
                <c:set var="voorkeurFound" value="false"/>
                <c:forEach var="item" items="${themas.themaApplicaties}">
                    <c:if test="${item.voorkeur and not finalFound}">
                        <c:set var="voorkeurFound" value="true"/>
                    </c:if>
                </c:forEach>
                <div class="${klasse}">
                    <h1>B. Bronapplicaties voor ${themas.naam}</h1>
                    <table>
                        <tr>
                            <th>
                                <c:out value="Applicatie"/>
                            </th>
                            
                            <th>
                                <c:out value="In Gebruik"/>
                            </th>
                            
                            <th>
                                <c:out value="Spatial"/>
                            </th>
                            
                            <th>
                                <c:out value="Adminstratief"/>
                            </th>
                            
                            <th>
                                <c:out value="Voorkeur"/>
                            </th>
                            
                            <th>
                                <c:out value="Definitief"/>
                            </th>
                            
                            <th>
                                <c:out value="Standaard"/>
                            </th>
                        </tr>
                        <c:forEach var="item" items="${themas.themaApplicaties}">
                            <c:if test="${(item.definitief and finalFound) or (voorkeurFound and item.voorkeur) or (not voorkeurFound and not finalFound)}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.applicatie}">
                                                <c:out value="${item.applicatie.pakket}"/>
                                                <c:out value="${item.applicatie.module}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="-"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.ingebruik}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.geodata}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.administratief}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.voorkeur}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.definitief}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.standaard}">
                                                <c:out value="Ja"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="Nee"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </table>
                </div>
            </c:if>
            <c:if test="${not empty themas.themaData}">
                <c:choose>
                    <c:when test="${klasse eq 'meta_data_normal'}">
                        <c:set var="klasse" value="meta_data_alternate" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="klasse" value="meta_data_normal" />
                    </c:otherwise>
                </c:choose>
                <div class="${klasse}">
                    <h1>C. Administratieve gegevens van ${themas.naam}</h1>
                    <table>
                        <tr>
                            <th>
                                <c:out value="Label"/>
                            </th>
                            <th>
                                <c:out value="Eenheid"/>
                            </th>
                            <th>
                                <c:out value="Breedte"/>
                            </th>
                            <th>
                                <c:out value="Moscow"/>
                            </th>
                            <th>
                                <c:out value="Kolomnaam"/>
                            </th>
                            <th>
                                <c:out value="Datatype"/>
                            </th>
                            <th>
                                <c:out value="Basisregel"/>
                            </th>
                            <th>
                                <c:out value="Volgorde"/>
                            </th>
                        </tr>
                        <c:forEach var="item" items="${themas.themaData}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.omschrijving}">
                                            <a href="#" title="${item.omschrijving}">
                                                <c:out value="${item.label}"/>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.label}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:out value="${item.eenheid}"/>
                                </td>
                                <td>
                                    <c:out value="${item.kolombreedte}"/>
                                </td>
                                <td>
                                    <c:out value="${item.moscow.naam}"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.waardeType.naam}">
                                            <a href="#" title="${item.waardeType.naam}">
                                                <c:out value="${item.kolomnaam}"/>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.kolomnaam}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.commando}">
                                            <a href="#" title="${item.commando}">
                                                <c:out value="${item.dataType.naam}"/>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.dataType.naam}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.basisregel}">
                                            <c:out value="Ja"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="Nee"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:out value="${item.dataorder}"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${not empty themas.themaVerantwoordelijkheden}">
                <c:choose>
                    <c:when test="${klasse eq 'meta_data_normal'}">
                        <c:set var="klasse" value="meta_data_alternate" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="klasse" value="meta_data_normal" />
                    </c:otherwise>
                </c:choose>
                <div class="${klasse}">
                    <h1>D. Verantwoordelijken voor ${themas.naam}</h1>
                    <table>
                        <tr>
                            <th>
                                <c:out value="Medewerker"/>
                            </th>
                            <th>
                                <c:out value="Onderdeel"/>
                            </th>
                            <th>
                                <c:out value="Rol"/>
                            </th>
                            
                            <th>
                                <c:out value="Opmerkingen"/>
                            </th>
                            <th>
                                <c:out value="Huidig"/>
                            </th>
                            
                            <th>
                                <c:out value="Gewenst"/>
                            </th>
                            
                        </tr>
                        <c:forEach var="item" items="${themas.themaVerantwoordelijkheden}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.medewerker}">
                                            <c:out value="${item.medewerker.achternaam}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="-"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.onderdeel}">
                                            <c:out value="${item.onderdeel.naam}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="-"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:out value="${item.rol.naam}"/>
                                </td>
                                
                                <td>
                                    <c:out value="${item.opmerkingen}"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.huidige_situatie}">
                                            <c:out value="Ja"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="Nee"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${item.gewenste_situatie}">
                                            <c:out value="Ja"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="Nee"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${not empty themas}">
                <c:choose>
                    <c:when test="${klasse eq 'meta_data_normal'}">
                        <c:set var="klasse" value="meta_data_alternate" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="klasse" value="meta_data_normal" />
                    </c:otherwise>
                </c:choose>
                <div class="${klasse}">
                    <h1>E. Update frequentie voor ${themas.naam}</h1>
                    <table>
                        <tr>
                            <th>
                                <c:out value="Frequentie in dagen"/>
                            </th>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty themas.update_frequentie_in_dagen}">
                                        <c:choose>
                                            <c:when test="${themas.update_frequentie_in_dagen == 1}">
                                                een keer per dag.
                                            </c:when>
                                            <c:otherwise>
                                                een keer per <c:out value="${themas.update_frequentie_in_dagen}"/> dagen.
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        Frequentie (nog) onbekend.
                                    </c:otherwise>
                                </c:choose> 
                            </td>
                        </tr>
                    </table>
                </div>
            </c:if>
            
        </c:when>
        <c:otherwise>
            Er is geen informatie gevonden!
        </c:otherwise>
    </c:choose>
</div>