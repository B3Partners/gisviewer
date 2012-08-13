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
<!-- Loop door tekstblokken heen -->

<div id="carouselcontainerblock"></div>

<c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
    <div class="content_block item">
        <div class="content">
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
    </div>
</c:forEach>

<!-- Als er geen tekstblokken zijn voor de homepagina toon dan de standaard
blokken -->
<c:if test="${empty tekstBlokken}">

    <div class="content_block item">
        <div class="content_title"><fmt:message key="algemeen.home.titel"/></div>

        <div class="inleiding_body">
            <p>
                De B3P GIS Suite maakt informatie van overheden integraal en snel via
                een standaard webbrowser toegankelijk. Interne medewerkers, burgers,
                ketenpartners en externe organisaties kunnen eenvoudig toegang
                verkrijgen tot informatie. De B3P GIS Suite is daarom bij uitstek
                inzetbaar als organisatiebreed webGIS.
            </p>

            <table>
                <tr>
                    <td>E-mail:</td>
                    <td><a href="mailto:info@b3partners.nl">info@b3partners.nl</a></td>
                </tr>
                <tr>
                    <td>Web:</td>
                    <td><a href="http://www.b3partners.nl" target="_new">www.b3partners.nl</a></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="content_block item">
        <div class="content_title">Luchtfoto Heuvelrug</div>

        <div class="inleiding_body">
            <html:img page="/images/examples/luchtfoto_heuvelrug.png" styleClass="example_image"/>
            <p>Luchtfoto van de Utrechtse heuvelrug</p>
        </div>
    </div>

    <div class="content_block item">
        <div class="content_title">Nieuwe Kaart Nederland</div>

        <div class="inleiding_body">
            <html:img page="/images/examples/nkn_utrecht.png" styleClass="example_image"/>
            <p>Nieuwe kaart van Nederland in de omgeving van Utrecht</p>
        </div>
    </div>

    <div class="content_block item">
        <div class="content_title">OpenStreetMap</div>

        <div class="inleiding_body">
            <html:img page="/images/examples/osm_wijken_utrecht.png" styleClass="example_image"/>
            <p>OpenStreetMap als achtergrondkaart met daarop de cbs wijkindeling in Utrecht</p>
        </div>
    </div>
            
    <div class="content_block item">
        <div class="content_title">Bestemmingsplannen</div>

        <div class="inleiding_body">
            <html:img page="/images/examples/roo_osm.png" styleClass="example_image"/>
            <p>Bestemmingsplannen van RO-Online op een achtergrond van OpenStreetMap</p>
        </div>
    </div>
</c:if>

<div class="content_block" id="loginblock">
    <c:choose>
        <c:when test="${not empty themalist || not empty clusterlist}">
            <div class="content_title"><fmt:message key="algemeen.home.themas.titel"/></div>

            <div class="content_body">

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
                    <li><fmt:message key="algemeen.home.themas.linknaarviewer"/> <html:link page="/viewer.do"><fmt:message key="algemeen.home.themas.viewer"/></html:link>.</li>
                </c:if>
            </ol>

            </div>
        </c:when>

        <c:when test="${pageContext.request.remoteUser == null}">

        <div class="content_title">Inloggen</div>

        <div class="content_body">
            
            <form id="loginForm" action="j_security_check" method="POST">
            <table>
                <tr>
                    <td><fmt:message key="algemeen.login.gebruikersnaam"/></td>
                    <td><input class="inputfield" type="text" name="j_username" size="36"></td>
                </tr>
                <tr>
                    <td><fmt:message key="algemeen.login.wachtwoord"/></td>
                    <td><input class="inputfield" type="password" name="j_password" size="36"></td>
                </tr>
                <tr>
                    <td colspan="2"><fmt:message key="algemeen.login.of"/></td>
                </tr>
                <tr>
                    <td><fmt:message key="algemeen.login.code"/></td>
                    <td><input class="inputfield" type="text" name="j_code" size="36"></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td><input class="inlogbutton" type="Submit" value="<fmt:message key="algemeen.login.login"/>"></td>
                </tr>
            </table>
            </form>

            <script type="text/javascript">
                <!--
                document.forms.loginForm.j_username.focus();
                // -->
            </script>
            
        </div>

        </c:when>
        <c:otherwise>
            <div class="content_title"><fmt:message key="algemeen.home.themas.titel"/></div>

            <div class="content_body">
                <p><fmt:message key="algemeen.home.themas.geengevondenvoorinlog"/></p>
                
                <html:link page="/indexlist.do" module="">
                    <fmt:message key="algemeen.home.themas.opnieuwophalen"/>
                </html:link>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<c:if test="${pageContext.request.remoteUser != null}">
    <div class="uitloggen">
        <p><tiles:insert name="loginblock"/></p>
    </div>
</c:if>

<div style="clear: both; padding-bottom: 25px;"></div>

<script type="text/javascript" src="<html:rewrite page='/scripts/homecarousel.js' module=''/>"></script>