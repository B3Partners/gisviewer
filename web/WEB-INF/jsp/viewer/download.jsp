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

    <c:if test="${!empty downloadLink}">
        <div id="downloadLink">
            <c:set var="dLink" value="/download.do?link=${downloadLink}"/>
            <html:link page="${dLink}" target="_top">Download</html:link> het bestand.
        </div>
    </c:if>

    <html:form styleId="downloadForm" action="/download">
            <html:hidden property="uuids" value="4" /> <!-- Meldingen gegevensbron -->

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
                <html:submit property="save" styleClass="rightButton submitbutton">Verzenden</html:submit>
            </p>
    </html:form>
</div>