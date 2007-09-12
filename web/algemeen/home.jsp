<%@taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script language="JavaScript">
    <!--
    function reloadOpener() {
    window.opener.document.forms[0].submit();
    }

    function reloadAndClose() {
    //reloadOpener();
    window.close();
    }
    
    // Instelling voor Kerio mailinglists
    var mailinglist = "wis-communicatie";
    var mailingdomain = "b3partners.nl";
    function sendSubscription(action) {
    var form = document.forms[0];
    form.to.value = mailinglist + "-" + action + "@" + mailingdomain;
    form.send.value = "t";
    form.submit();
    return true;
    }
    // -->
</script>
<div id="content_style">
    <hr size="1" style="color: Black;" width="100%" />
    <table width="100%">
        <tr>
            <td width="295">
                <img src="images/logo.gif" border="0" alt="Logo Noord Brabant" class="nbr" />
            </td>
            <td valign="top">
                <br /><br />
                <h1>WIS Demo voor de provincie Noord Brabant</h1>
                <br /><br />
            </td>
        </tr>
        <tr>
        <tr>
            <td colspan="2" valign="bottom" align="center">
                <a style="font-size: 13px; text-decoration: underline;" href="viewer.do">KLIK HIER OM DOOR TE GAAN NAAR DE WIS DEMO</a>
            </td>
        </tr>       
        <tr>
            <td colspan="2" valign="bottom" align="center">
                <br /><br /><h2>Aanmelden voor de communicatie mailinglijst</h2>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
                    Hier kunt u zich aanmelden voor het communicatie mailinglijst van het WIS project van de provincie Noord-Brabant.
                    Alleen medewerkers van de provincie met een betrokkenheid bij het project kunnen zich aanmelden.
                </p>
                <p>U vult uw emailadres hieronder in en klikt op de aanmelden link. U ontvangt vervolgens een email of
                    uw aanmelding is geaccepteerd. Zodra u lid bent van de mailinglijst ontvangt u emails van het projectteam of
                    andere leden van deze lijst.
                </p>
                <p>
                    U kunt zich hier ook altijd weer afmelden.
                </p>
                <p>Via deze lijst wordt u op de hoogte gehouden van aanpassingen aan het prototype.
                    U kunt uw opmerkingen op het prototype via deze lijst kenbaar maken. En u kunt reageren op opmerkingen
                    van anderen.
                </p>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
                <html:messages id="error" message="true">
                    <div class="messages" style="padding-top: 5px">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
                </html:messages>
            </td>
        </tr>
        <tr>
            <td align="right" valign="top">
                emailadres
            </td>
            <td>
                <html:form action="/listManager" focus="from">
                    <html:hidden property="xsl" value=""/>
                    <html:hidden property="to" value=""/>
                    <html:hidden property="cc" value="wis@b3partners.nl"/>
                    <html:hidden property="subject" value="aan- en afmelden Communicatieplatform WIS N-Br"/>
                    <html:hidden property="body" value=""/>
                    
                    <input type="hidden" name="send"/>
                    <html:text property="from" size="25" maxlength="100"/>
                    &nbsp;
                    <a href="javascript: sendSubscription('subscribe');">
                    aanmelden</a>
                    &nbsp;
                    <a href="javascript: sendSubscription('unsubscribe');">
                    afmelden</a>
                </html:form>
            </td>
        </tr>
    </table>
    <hr size="1" style="color: Black;" width="100%" />
</div>