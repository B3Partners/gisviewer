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

<!-- tiles:insert definition="actionMessages"/ -->
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

    <h1>Welkom bij SolutionsParc</h1>

    <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis id sapien sapien. Quisque tincidunt elementum bibendum. Aliquam erat volutpat. Etiam facilisis commodo nulla id feugiat. Sed enim dui, lobortis non elementum eget, dictum facilisis diam. Aliquam velit urna, sollicitudin nec tempor vel, congue id velit. Curabitur id ligula nisi. Duis eget lacus et arcu blandit vestibulum facilisis nec quam. Proin tempor accumsan erat in posuere. In id velit urna. Donec ligula elit, pharetra sed consequat ac, feugiat ut mauris. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nam bibendum elit eu sem vehicula rhoncus. Duis pretium sem et dolor tempus molestie. Duis vulputate ligula mauris. 
    </p>

    <div class="solutionparc_homeblocks">

        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/maatschappelijk.png"/>" /></a>
        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/actuelezaken.png"/>" /></a>
        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/wijkgericht.png"/>" /></a>

    </div>
    
    <div class="solutionparc_homeblocks" style="margin-top: 15px;">

        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/natuur.png"/>" /></a>
        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/openbareruimte.png"/>" /></a>
        <a href="#"><img alt="" src="<html:rewrite page="/images/solutionparc-design/gemeente.png"/>" /></a>

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

<!--
<script type="text/javascript" src="<html:rewrite page='/scripts/homecarousel.js' module=''/>"></script>
-->