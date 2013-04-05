<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="infobalk">
    <div class="infobalk_description"><fmt:message key="algemeen.login.infobalk"/></div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

<tiles:insert definition="actionMessages"/>

<!-- Loop door tekstblokken heen -->
<div class="tegels">
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="blockwrapper" title="${tb.titel}">
            <c:set var="style" value="" />
            <c:if test="${!empty tb.kleur}">
                <c:set var="style" value="${style}background-color:${tb.kleur};" />
            </c:if>
            
            <c:if test="${!empty tb.hoogte && tb.hoogte != 0}">
                <c:set var="style" value="${style}height:${tb.hoogte}px;" />
            </c:if>
            
            <c:if test="${!empty style}">
                <c:set var="style" value=" style=\"${style}\"" />
            </c:if>
            <div class="tegel"${style}>
                <c:choose>
                    <c:when test="${tb.toonUrl}">
                        <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                    </c:when>
                    <c:otherwise>
                        ${tb.tekst}
                        <c:if test="${!empty tb.url}">
                            <a href="${tb.url}" target="_new">${tb.url}</a>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</div>

<div class="content_block">

<div class="content_title">Inloggen</div>

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
</div>

<div style="clear: both;"></div>

<script type="text/javascript">    
    document.forms.loginForm.j_username.focus();   
</script>

