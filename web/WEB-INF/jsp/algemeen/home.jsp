<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

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
<div id="content_style" style="text-align: center; width: 930px; margin-right: 15px;">
    <hr size="1" width="100%" />
    
    <br /><br />
    
    <img src="images/logo.gif" border="0" alt="Logo" class="nbr" />
    
    <h1>B3P GIS Suite Demo</h1>
    
    <br /><br />
    
    <a style="font-size: 13px; text-decoration: underline;" href="viewer.do">KLIK HIER OM DOOR TE GAAN NAAR DE DEMO</a>
    
    <br /><br />
    
    <h2>Aanmelden voor de b3partners mailinglijst</h2>
    
    <p>
        Hier kunt u zich aanmelden voor het b3partners mailinglijst.
    </p>
    <p>U vult uw emailadres hieronder in en klikt op de aanmelden link. U ontvangt vervolgens een email of
        uw aanmelding is geaccepteerd.
    </p>
    <p>
        U kunt zich hier ook altijd weer afmelden.
    </p>
    
    <p>
    <html:messages id="error" message="true">
        <div class="messages" style="padding-top: 5px">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
    </html:messages>
    <p>
    <table style="width: 360px; margin-left: 300px;">
        <tr>
            <td align="right" valign="top">
                emailadres
            </td>
            <td>
                <html:form action="/listManager" focus="from">
                    <html:hidden property="xsl" value=""/>
                    <html:hidden property="to" value=""/>
                    <html:hidden property="cc" value="nieuwsbrief@b3partners.nl"/>
                    <html:hidden property="subject" value="aan- en afmelden mailinglijst b3partners"/>
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
    <hr size="1" width="100%" />
</div>