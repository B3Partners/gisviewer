<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<form id="loginForm" action="j_security_check" method="POST">
    <div style="height: 50px"></div>
    <div style="width: 430px; margin: auto; border: 1px solid #dddddd;">
        <h2 align="center">Login</h2>
        <html:messages id="message" message="true">
            <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
        </html:messages>
        <table>
            <tr><td>E-mail adres:</td><td><input type="text" name="j_username" size="36"></td></tr>
            <tr><td>Wachtwoord:</td><td><input type="password" name="j_password" size="36"></td></tr>
            <tr><td><input type="Submit" value="Login"></td></tr>
        </table>
    </div>
</form>

<script language="JavaScript">
<!--
    document.forms.loginForm.j_username.focus();
// -->
</script>
