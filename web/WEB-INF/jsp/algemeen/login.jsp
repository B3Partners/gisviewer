<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  
                    
Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="onderbalk">LOGIN<span><tiles:insert name="loginblock"/></span></div>
<form id="loginForm" action="j_security_check" method="POST">
    <div style="height: 430px">
        <div style="width: 430px; padding: 10px; border: 1px solid #dddddd;">
            <html:messages id="message" message="true">
                <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
            </html:messages><br />
            <table>
                <tr><td>Gebruikersnaam:</td><td><input type="text" name="j_username" size="36"></td></tr>
                <tr><td>Wachtwoord:</td><td><input type="password" name="j_password" size="36"></td></tr>
                <tr><td colspan="2">Of</td></tr>
                <tr><td>Code:</td><td><input type="text" name="j_code" size="36"></td></tr>
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
