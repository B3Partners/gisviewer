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
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/admindataFunctions.js"/>"></script>
<script type="text/javascript">
    function popUp(URL, naam) {
        var screenwidth = 1024;
        var screenheight = 768;
        var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
        var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
        properties = "toolbar = 0, " + 
            "scrollbars = 1, " + 
            "location = 0, " + 
            "statusbar = 1, " + 
            "menubar = 0, " + 
            "resizable = 1, " + 
            "width = " + screenwidth + ", " + 
            "height = " + screenheight + ", " + 
            "top = " + popuptop + ", " + 
            "left = " + popupleft;
        eval("page" + naam + " = window.open(URL, '" + naam + "', properties);");
    }   
</script>

<c:choose>
    <c:when test="${not empty thema_items and not empty regels}">
        <table id="aanvullende_info_table">
            <tr class="topRow">
                <th colspan="2" class="aanvullende_info_td">
                    Aanvullende informatie
                </th>
            </tr>
            <c:forEach var="ThemaItem" items="${thema_items}" varStatus="counter">
                <c:choose>
                    <c:when test="${counter.count % 2 == 0}">
                        <c:set var="altTr" value=""/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="altTr" value="aanvullende_info_alternateTr"/>
                    </c:otherwise>
                </c:choose>
                <tr class="${altTr}">
                    <th class="aanvullende_info_th">${ThemaItem.label}</th>
                    <td class="aanvullende_info_td">
                        <c:choose>
                            <c:when test="${ThemaItem.dataType.id == 2}">
                                -
                            </c:when>
                            <c:when test="${ThemaItem.dataType.id == 3}">
                                <html:image src="./images/icons/world_link.png" onclick="popUp('${regels[0][counter.count - 1]}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                            </c:when>
                            <c:when test="${regels[0][counter.count - 1] eq ''}">
                                -
                            </c:when>
                            <c:when test="${ThemaItem.dataType.id == 4}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(fn:split(regels[0][counter.count - 1], '###')[1],'setAttributeValue')}">
                                        <c:out value="${fn:split(regels[0][counter.count - 1], '###')[0]}"/> 
                                    </c:when>
                                    <c:otherwise>
                                        <a class="datalink" id="href${counter.count-1}" href="#" onclick="${fn:split(regels[0][counter.count - 1], '###')[1]}">${fn:split(regels[0][counter.count - 1], '###')[0]}</a>                                
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                ${regels[0][counter.count - 1]}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        Er is geen admin data gevonden!
    </c:otherwise>
</c:choose>
