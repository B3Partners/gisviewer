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

<script language="JavaScript">
    <!--
    function reloadOpener() {
        window.opener.document.forms[0].submit();
    }

    function reloadAndClose() {
        //reloadOpener();
        window.close();
    }
    
    // Instelling voor Kerio mailinglists
    var mailinglist = "b3partners";
    var mailingdomain = "b3partners.nl";
    function sendSubscription(action) {
        var form = document.forms[0];
        form.to.value = mailinglist + "-" + action + "@" + mailingdomain;
        form.send.value = "t";
        form.submit();
        return true;
    }
    // -->
</script>

<div id="content_style">
    
    <hr size="1" width="100%" />
    
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <html:messages id="message" message="true">
                    <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
                </html:messages><br/>
                <h1>B3P GIS Suite Demo</h1>
                
                <div class="inleiding">
                    <h2>Introductie</h2>
                    <p>
                        Deze B3P GIS Suite demo toont de mogelijkheden van de GIS viewer 
                        zoals deze binnen de GIS suite gebruikt wordt. De getoonde kaarten 
                        zijn alleen ten bate van deze demo beschikbaar. Later worden voor 
                        elk project specifieke kaarten aangeschaft en geconfigureerd.
                    </p>
                    <p>
                        Deze demo staat op een testserver, welke soms wordt herstart. 
                        Als er even geen contact mogelijk is, dan verzoeken wij u het 
                        later nog een keer te proberen. 
                    </p>
                </div>
                <%--
                <h2>Aanmelden voor de B3Partners mailinglijst</h2>
                <p>
                <html:messages id="error" message="true">
                    <div class="messages" style="padding-top: 5px">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
                </html:messages>
                <p>
                <html:form action="/listManager" focus="from">
                    <html:hidden property="xsl" value=""/>
                    <html:hidden property="to" value=""/>
                    <html:hidden property="cc" value="nieuwsbrief@b3partners.nl"/>
                    <html:hidden property="subject" value="aan- en afmelden mailinglijst b3partners"/>
                    <html:hidden property="body" value=""/>
                    <input type="hidden" name="send"/>
                    
                    <table>
                        <tr>
                            <td>
                                emailadres<br>
                                <html:text property="from" size="25" maxlength="100"/>
                            </td>
                            <td>
                                <a href="javascript: sendSubscription('subscribe');">
                                aanmelden</a>
                            </td>
                            <td>
                                <a href="javascript: sendSubscription('unsubscribe');">
                                afmelden</a>
                            </td>
                        </tr>
                    </table>
                </html:form>
                --%>
            </td>
            <td valign="top">               
                <h2>Beschikbare Thema's</h2>
                <c:choose>
                    <c:when test="${not empty themalist || not empty clusterlist}">
                        <ol>
                            <c:if test="${not empty themalist}">
                                <c:forEach var="thema" items="${themalist}">
                                    <c:if test="${thema.analyse_thema}">
                                        <c:set var="found" value="true"/>
                                        <li>
                                            <html:link page="/viewer.do?id=${thema.id}&code=${kbcode}">${thema.naam}</html:link>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <c:if test="${not empty clusterlist}">
                                <c:forEach var="cluster" items="${clusterlist}">
                                    <c:set var="found" value="true"/>
                                    <li>
                                        <html:link page="/viewer.do?clusterId=${cluster.id}&code=${kbcode}">${cluster.naam}</html:link>
                                    </li>
                                </c:forEach>
                            </c:if>
                            <c:if test="${not found}">
                                <li>Er zijn geen voorgeselecteerde thema's gevonden.</li>
                                <li>U kunt direct naar de <html:link page="/viewer.do">viewer</html:link>.</li>
                            </c:if>
                        </ol>
                    </c:when>
                    <c:when test="${pageContext.request.remoteUser == null}">
                        <p>
                            Klik hier om beschikbare thema's op te vragen:
                            <ul>
                                <li><html:link page="/indexlist.do" module="">zonder inloggen</html:link></li>
                                <li><html:link page="/viewerlist.do" module="">met inloggen</html:link></li>
                            </ul>
                        </p>
                    </c:when>
                    <c:otherwise>
                        <ol>
                            <li>Er zijn geen thema's gevonden voor uw inlog!</li>
                            <li>Haal <html:link page="/indexlist.do" module="">hier</html:link> opnieuw op.</li>
                        </ol>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    
    <hr size="1" width="100%" />
    <tiles:insert name="loginblock"/>
</div>
