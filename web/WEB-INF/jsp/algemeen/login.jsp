<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="infobalk">
    <div class="infobalk_description"><fmt:message key="algemeen.login.infobalk"/></div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

<div class="content_body">

<form id="loginForm" action="j_security_check" method="POST">
<html:messages id="message" message="true">
    <div class="message"><c:out value="${message}"/></div>
</html:messages>
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

<script type="text/javascript">
    <!--
    document.forms.loginForm.j_username.focus();
    // -->
</script>
