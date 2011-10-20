<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="downloadBody">
    <h1>Download Shape of GML</h1>
    
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
        Vul een geldig e-mailadres in en kies een download formaat. Het ophalen
        van de dataset kan enige tijd duren. Als de download klaar is gezet ontvangt u
        hierover een e-mail met daarin een download link. Na het klikken op
        'Start download' kunt u dit scherm afsluiten.
    </p>

    <html:form styleId="downloadForm" action="/download">
            <html:hidden property="uuids" />

            <table>
                <tr>
                    <td>E-mail</td>
                    <td><html:text property="email" size="40" /></td>
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
            </table>
                    
            <p>
                <html:submit property="save" styleClass="rightButton submitbutton">Start download</html:submit>
            </p>
    </html:form>
</div>