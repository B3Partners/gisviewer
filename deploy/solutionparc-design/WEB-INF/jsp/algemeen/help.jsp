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

<div id="content_style">

    <!-- Loop door tekstblokken heen -->
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="content_block">
            <div class="content_title"><c:out value="${tb.titel}"/></div>

            <!-- Indien toonUrl aangevinkt is dan inhoud van url in iFrame tonen -->
            <c:if test="${tb.toonUrl}">
                <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
            </c:if>

            <!-- Anders gewoon de tekst tonen van tekstblok -->
            <c:if test="${!tb.toonUrl}">
            <div class="inleiding_body helppagina_cms_blok">
                ${tb.tekst}

                <c:if test="${!empty tb.url}">
                Meer informatie: <a href="${tb.url}" target="_new">${tb.url}</a>
                </c:if>

                <c:if test="${tb.toonUrl}">
                    <iframe id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                </c:if>
            </div>
            </c:if>
        </div>
    </c:forEach>

    <!-- Gewone help pagina tonen als er geen tekstblokken zijn -->
    <c:if test="${empty tekstBlokken}">
        <table class="kolomtabel">
            <tr>
                <td valign="top">
                    <tiles:insert definition="actionMessages"/>
                    <h1><fmt:message key="algemeen.help.titel"/></h1>

                    <div class="inleiding">
                        <h2><fmt:message key="algemeen.help.part1.title"/></h2>
                        <fmt:message key="algemeen.help.part1.content"/>
                    </div>

                    <h2><fmt:message key="algemeen.help.part2.title"/></h2>
                    <fmt:message key="algemeen.help.part2.content"/>

                    <a name="thema"></a><h2><fmt:message key="algemeen.help.part3.title"/></h2>
                    <fmt:message key="algemeen.help.part3.content"/>

                    <a name="legenda"></a><h2><fmt:message key="algemeen.help.part4.title"/></h2>
                    <fmt:message key="algemeen.help.part4.content"/>

                </td>
                <td valign="top">
                    <a name="zoeker"></a><h2><fmt:message key="algemeen.help.part5.title"/></h2>
                    <fmt:message key="algemeen.help.part5.content"/>

                    <a name="gebieden"></a><h2><fmt:message key="algemeen.help.part6.title"/></h2>
                    <fmt:message key="algemeen.help.part6.content"/>

                    <a name="analyse"></a><h2><fmt:message key="algemeen.help.part7.title"/></h2>
                    <fmt:message key="algemeen.help.part7.content"/>

                    <h2><fmt:message key="algemeen.help.part8.title"/></h2>
                    <fmt:message key="algemeen.help.part8.content"/>

                </td>
            </tr>
        </table>
    </c:if>
</div>
<hr>
<div>
    <div style="float: right;">
        <address>B3Partners: Zonnebaan 12C, 3542 EC, Utrecht</address>
    </div>
</div>