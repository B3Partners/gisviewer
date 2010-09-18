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
    <div class="content_title"><fmt:message key="algemeen.home.titel"/></div>

    <div class="inleiding_body">
        <p>
            <fmt:message key="algemeen.home.introductie.content1"/>
        </p>
        <p>
            <fmt:message key="algemeen.home.introductie.content2"/>
        </p>
    </div>
</div>

<div class="content_block">
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
