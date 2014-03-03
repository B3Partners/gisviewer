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

<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    <c:set var="kaartid" value="${param['id']}"/>
    <c:set var="appCode" value="${param['appCode']}"/>
    <c:set var="cmsPageId" value="${param['cmsPageId']}"/>

    <c:set var="helpUrl" value="${configMap['helpUrl']}"/>
    <c:set var="showGoogleMapsIcon" value="${configMap['showGoogleMapsIcon']}"/>
    <c:set var="showBookmarkIcon" value="${configMap['showBookmarkIcon']}"/>
    <c:set var="contactUrl" value="${configMap['contactUrl']}"/>

    <c:if test="${pageContext.request.remoteUser != null}">
        <script type="text/javascript">            
            function logout() {
                var kburl = '${kburl}';
                var logoutLocation = '/kaartenbalie/logout.do'
                if (kburl != '') {
                    var pos = kburl.lastIndexOf("services");
                    if (pos >= 0) {
                        logoutLocation = kburl.substring(0, pos) + "logout.do";
                    }
                }
                lof = document.getElementById('logoutframe');
                lof.src = logoutLocation;
                location.href = '<html:rewrite page="/logout.do" module=""/>';
            }
            ;
        </script>
        <div id="logoutvak" style="display: none;">
            <iframe src="" id="logoutframe" name="logoutframe"></iframe>
        </div>
        <a href="#" class="menulink" onclick="javascript:logout();"><fmt:message key="commons.userandlogout.uitloggen"/></a>
    </c:if>

    <c:if test="${!empty contactUrl}">        
        <a href="mailto:${contactUrl}" class="menulink">
            <img src="<html:rewrite page="/images/email.png"/>" alt="${contactUrl}" title="${contactUrl}" />
        </a>
    </c:if>

    <c:if test="${showBookmarkIcon}">
        <a href="#" onclick="getBookMark();" class="menulink">
            <img src="<html:rewrite page="/images/bookmark.png"/>" alt="Bookmark de kaart" title="Bookmark de kaart" border="0" />
        </a>
    </c:if>

    <c:if test="${showGoogleMapsIcon}">
        <a href="#" onclick="getLatLonForGoogleMaps();" class="menulink">
            <img src="<html:rewrite page="/images/google_maps.png"/>" alt="Toon Google Map van de kaart" title="Toon Google Map van de kaart" border="0" />
        </a>
    </c:if>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'help.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>

    <c:if test="${! empty helpUrl}">        
        <html:link page="${helpUrl}" target="_blank" styleClass="${stijlklasse}" module="">
            <img src="<html:rewrite page="/images/help.png"/>" alt="Help" title="Help" border="0" />
        </html:link>
    </c:if>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/cms/${cmsPageId}/home.htm" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
</div>


