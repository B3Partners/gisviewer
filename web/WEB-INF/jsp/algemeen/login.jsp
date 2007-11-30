<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="onderbalk">LOGIN<span><tiles:insert name="loginblock"/></span></div>
<form id="loginForm" action="j_security_check" method="POST">
    <div style="height: 600px">
        <div style="width: 430px; padding: 10px; border: 1px solid #dddddd;">
            <html:messages id="message" message="true">
                <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
            </html:messages><br />
            <table>
                <tr><td>Gebruikersnaam:</td><td><input type="text" name="j_username" size="36"></td></tr>
                <tr><td>Wachtwoord:</td><td><input type="password" name="j_password" size="36"></td></tr>
                <tr><td><input type="Submit" value="Login"></td></tr>
            </table>
        </div>
    </div>    
</form>

<script language="JavaScript">
<!--
    document.forms.loginForm.j_username.focus();
// -->
</script>
