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

<script>
    function printpage() {
        window.print(); 
    }
</script>

<c:if test="${pageContext.request.remoteUser != null}">
    <c:if test="${f:isUserInRole(pageContext.request, 'beheerder')}">
        <c:set var="beheerder" value="true"/>
    </c:if>
</c:if>

<table width="100%" height="100%;" cellpadding="0" cellspacing="0">
    <tr>
        <td width="40%" id="menubalklogoboven"></td>
        <td width="60%" align="right" id="menubalkmenucontent">
            <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
            <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
            
            <c:set var="stijlklasse" value="menulink" />
            <c:if test="${requestJSP eq 'help.do'}">
                <c:set var="stijlklasse" value="activemenulink" />
            </c:if>
            <html:link page="/help.do" styleClass="${stijlklasse}" module="">&#155; Help</html:link>
            
            <c:choose>
                <c:when test="${beheerder == true}">
                    <c:set var="stijlklasse" value="menulink" />
                    <c:if test="${requestJSP eq 'configThema.do'}">
                        <c:set var="stijlklasse" value="activemenulink" />
                    </c:if>
                    <html:link page="/configThema.do" styleClass="${stijlklasse}" module="">&#155; Configuratie</html:link>
                </c:when>
                <c:otherwise>
                    <%--
                <c:set var="stijlklasse" value="menulink" />
                <c:if test="${requestJSP eq 'contact.do'}">
                    <c:set var="stijlklasse" value="activemenulink" />
                </c:if>
                <html:link page="/index.do" styleClass="${stijlklasse}" module="">&#155; Contact</html:link>
                --%>
                </c:otherwise>
            </c:choose>
            
            <html:link href="javascript: printpage();" styleClass="menulink" module="">&#155; Print kaart</html:link>
            
            <c:set var="stijlklasse" value="menulink" />
            <c:if test="${requestJSP eq 'viewer.do'}">
                <c:set var="stijlklasse" value="activemenulink" />
            </c:if>
            <html:link page="/viewer.do" styleClass="${stijlklasse}" module="">&#155; Viewer</html:link>
            
            <c:set var="stijlklasse" value="menulink" />
            <c:if test="${requestJSP eq 'index.do'}">
                <c:set var="stijlklasse" value="activemenulink" />
            </c:if>
            <html:link page="/indexlist.do" styleClass="${stijlklasse}" module="">&#155; Home</html:link>
        </td>
    </tr>
</table>