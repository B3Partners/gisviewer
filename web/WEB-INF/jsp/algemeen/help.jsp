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

    <hr>

    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <html:messages id="message" message="true">
                    <div id="error"><c:out value="${message}"/></div>
                </html:messages><br>
                <html:messages id="message" name="acknowledgeMessages">
                    <div id="acknowledge">
                      <c:out value="${message}"/>
                    </div>
                </html:messages>
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

    <hr>
    <tiles:insert name="loginblock"/>
</div>