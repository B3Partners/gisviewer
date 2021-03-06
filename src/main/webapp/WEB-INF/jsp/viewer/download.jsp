<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript">
    function validateEmail()
    {
        var emailAdres = document.forms["downloadForm"]["email"].value;
        var atpos = emailAdres.indexOf("@");
        var dotpos = emailAdres.lastIndexOf(".");

        if (atpos < 1 || dotpos < atpos+2 || dotpos+2 >= emailAdres.length) {
            alert("E-mailadres niet ingevuld of ongeldig.");
            return false;
        }
        
        var ouder = B3PGissuite.commons.getParent({ parentOnly: true });
        if (ouder) {
            var wkt = ouder.B3PGissuite.viewercommons.getWktForDownload();
            if (wkt) {
                document.forms[0].wkt.value = wkt;
            }
        }
        
        return true;
    }
</script>

<div class="downloadBody">
    <c:choose>
        <c:when test="${emailScheduled}">
            <fmt:message key="download.confirm"/>
        </c:when>
        <c:otherwise>
            <div class="messages">
                <html:messages id="message" message="true" >
                    <div id="error">
                        <c:out value="${message}" escapeXml="false"/>
                    </div>
                </html:messages>
                <html:messages id="message" name="acknowledgeMessages">
                    <div id="acknowledge">
                        <c:out value="${message}"/>
                    </div>
                </html:messages>
            </div>

            <p>
                U kunt de gehele dataset downloaden of alleen een selectie als u een polygoon op
                de kaart hebt getekend. Vul een geldig e-mailadres in en kies een download
                formaat. Het ophalen van de dataset kan enige tijd duren. Als de download
                klaar is gezet ontvangt u hierover een e-mail met daarin een download link.
                Na het klikken op 'Start download' kunt u dit scherm afsluiten.
            </p>    

            <html:form styleId="downloadForm" action="/download" onsubmit="return validateEmail();">
                <html:hidden property="uuids" />
                <html:hidden property="wkt" />

                <table>
                    <tr>
                        <td>E-mail</td>
                        <td><html:text property="email" maxlength="60" size="40" /></td>
                    </tr>
                    <tr>
                        <td>Formaat</td>
                        <td>
                            <html:select property="formaat">
                                <html:option value="SHP" />
                                <html:option value="GML" />
                            </html:select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><html:submit property="save" styleClass="rightButton submitbutton">Start download</html:submit></td>
                    </tr>
                </table>

                <p>

                </p>
            </html:form>
        </c:otherwise>
    </c:choose>
</div>