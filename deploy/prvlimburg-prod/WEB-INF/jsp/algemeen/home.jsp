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

<%-- Vast blok plim --%>
<div class="content_block item">
    <div class="content">
        <div class="content_title">Atlas Limburg</div>
        <div class="inleiding_body">
            <p>Toegangspoort tot de publiek beschikbare geo-informatie van de provincie Limburg. Net zoals in een papieren atlas zijn de kaarten thematisch ingedeeld, maar er zijn ook algemene geo-portalen beschikbaar. Voor vragen hierover, email het Geoloket: geoloket@prvlimburg.nl of bel: 043-3898939</p>
        </div>
    </div>
</div>

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
                    <li><fmt:message key="algemeen.home.themas.linknaarviewer"/><html:link page="/viewer.do"><fmt:message key="algemeen.home.themas.viewer"/></html:link>.</li>
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
                    <td><input class="inputfield" type="text" name="j_username" size="36" tabindex="1" /></td>
                    <td rowspan="4" style="padding-left: 15px;"><input class="inlogbutton" type="Submit" value="<fmt:message key="algemeen.login.login"/>" tabindex="3" /></td>
                </tr>
                <tr>
                    <td><fmt:message key="algemeen.login.wachtwoord"/></td>
                    <td><input class="inputfield" type="password" name="j_password" size="36" tabindex="2" /></td>
                </tr>
                <tr>
                    <td colspan="2"><fmt:message key="algemeen.login.of"/></td>
                </tr>
                <tr>
                    <td><fmt:message key="algemeen.login.code"/></td>
                    <td><input class="inputfield" type="text" name="j_code" size="36" tabindex="4" /></td>
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

<c:if test="${pageContext.request.remoteUser != null}">
    <div class="uitloggen">
        <p><tiles:insert name="loginblock"/></p>
    </div>
</c:if>

<div style="clear: both; padding-bottom: 25px;"></div>