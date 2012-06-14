<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript">
    <!--
    function reloadOpener() {
        window.opener.document.forms[0].submit();
    }

    function reloadAndClose() {
        //reloadOpener();
        window.close();
    }
    // -->
</script>

<tiles:insert definition="actionMessages"/>

<div class="content_block">
	<div class="content_title"><c:out value="Demo"/></div>
	<div class="inleiding_body">
		<p>Welkom bij de Demo versie van de KWR GIS Viewer. Deze demo versie is gerealiseerd in het kader van de Pilot KWR GIS Viewer.
		Voornaamste doel van deze pilot is het laagdrempelig ontsluiten van KWR GIS projecten en geodata voor niet GIS-specialisten.</p>

		<p>De getoonde kaarten zijn alleen ten bate van deze demo beschikbaar en worden gedurende de pilot niet bijgewerkt.</p>

		<p>Gedurende de pilot vind de dienstverlening via een testserver plaats. Deze kan tijdelijk onderbroken worden en de performance
		is niet altijd optimaal. Als er even geen contact is verzoeken we u het later nog een te proberen.</p>
	</div>
</div>

<div class="content_block">
    <c:choose>
        <c:when test="${not empty themalist || not empty clusterlist}">
            <div class="content_title"><fmt:message key="algemeen.home.themas.titel"/></div>

            <div class="inleiding_body">

            <ol>
                <c:if test="${not empty clusterlist}">
                    <c:forEach var="cluster" items="${clusterlist}">
                        <c:set var="found" value="true"/>
                        <li>
                            <html:link page="/viewer.do?clusterId=${cluster.id}&code=${kbcode}">${cluster.naam}</html:link>
                        </li>
                    </c:forEach>
                </c:if>
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
                <c:if test="${not found}">
                    <li><fmt:message key="algemeen.home.themas.geengevonden"/></li>
                    <li><fmt:message key="algemeen.home.themas.linknaarviewer"/><html:link page="/viewer.do"><fmt:message key="algemeen.home.themas.viewer"/></html:link>.</li>
                </c:if>
            </ol>

            </div>
        </c:when>

        <c:when test="${pageContext.request.remoteUser == null}">

        <div class="content_title">Inloggen</div>

        <div class="inleiding_body">
            <p>
            <form id="loginForm" action="j_security_check" method="POST">
            <table>
                <tr>
                    <td style="width: 145px;"><fmt:message key="algemeen.login.gebruikersnaam"/></td>
                    <td><input class="inputfield" type="text" name="j_username" size="36"></td>
                </tr>
                <tr>
                    <td><fmt:message key="algemeen.login.wachtwoord"/></td>
                    <td><input class="inputfield" type="password" name="j_password" size="36"></td>
                </tr>
                <tr>
                    <td>Code</td>
                    <td><input class="inputfield" type="text" name="j_code" size="36"></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td><input class="inlogbutton" type="Submit" id="loginsubmit" value="<fmt:message key="algemeen.login.login"/>"></td>
                </tr>
            </table>
            </form>
			</p>
            <script type="text/javascript">
                document.forms.loginForm.j_username.focus();
                (function($) {
                    var $link = $('<a href="#" class="menulink" style="float: left;">Inloggen</a>').click(function(event) {
                        $('#loginForm').submit();
                        event.preventDefault();
                    });
                    $('#loginsubmit').hide().parent().append($link);
                })(jQuery);
            </script>
            
        </div>

        </c:when>
        <c:otherwise>
            <div class="content_title"><fmt:message key="algemeen.home.themas.titel"/></div>

            <div class="inleiding_body">
                <p><fmt:message key="algemeen.home.themas.geengevondenvoorinlog"/></p>
                
                <html:link page="/indexlist.do" module="">
                    <fmt:message key="algemeen.home.themas.opnieuwophalen"/>
                </html:link>
            </div>
        </c:otherwise>
    </c:choose>
</div>

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
        <div class="inleiding_body">
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

<c:if test="${pageContext.request.remoteUser != null}">
    <div class="uitloggen">
        <p><tiles:insert name="loginblock"/></p>
    </div>
</c:if>
