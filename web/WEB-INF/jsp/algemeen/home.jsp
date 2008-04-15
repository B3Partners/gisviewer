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
                    <c:when test="${not empty themalist}">
                        <ol>
                            <c:forEach var="thema" items="${themalist}">
                                <c:if test="${thema.analyse_thema}">
                                    <li>
                                        <html:link page="/viewer.do?id=${thema.id}">${thema.naam}</html:link>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ol>
                    </c:when>
                    <c:when test="${pageContext.request.remoteUser == null}">
                        U dient nog in te loggen: <html:link page="/index.do?login=t" module="">inloggen</html:link>
                    </c:when>
                    <c:otherwise>
                        Er zijn geen thema's gevonden!
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    
    <hr size="1" width="100%" />
    <tiles:insert name="loginblock"/>
</div>
