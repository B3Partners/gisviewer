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

<c:choose>
    <c:when test="${not empty object_data}">
        <c:forEach var="thema_object_data" items="${object_data}">
            <strong>
                ${thema_object_data[1]}
            </strong>
            <table>
                <c:forEach var="regel" items="${thema_object_data[2]}">
                    <tr>
                        <c:forEach var="item" items="${regel}" end="1">
                            <td>
                                ${item}
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </table>
        </c:forEach>
    </c:when>
    <c:otherwise>
        Er zijn geen gebieden gevonden!
    </c:otherwise>
</c:choose>
