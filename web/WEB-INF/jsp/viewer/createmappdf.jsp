<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="imageId" value="${printForm.map.imageId}"/>
<c:set var="psettingsName" value="${imageId}"/>
<c:set var="psettings" value='${sessionScope[psettingsName]}'/>
<c:set var="firstUrl" value="${psettings.urls[0]}"/>

<script type="text/javascript">
    var setDefaultImageSizeFromMap=true;
    var firstUrl = "${firstUrl}";
</script>

<div class="createMapPDFBody">
    <h1>Printvoorbeeld</h1>

    <html:form action="/printmap" focus="title">
        <table>
            <tr>
                <td colspan="2" class="createmappdftd">
                    <div id="imageContainer">
                        <html:img page="/printmap.do?image=t&keepAlive=true&imageId=${imageId}" styleId="mapImage" alt="Preview" border="1"/>
                    </div>
                    <html:hidden property="imageId" styleId="imageId"/>
                </td>
            </tr>

            <tr>
                <td colspan="2" class="printvoorbeeld_help">
                    U kunt dit printvoorbeeld ook direct gebruiken door met de rechtermuisknop
                    op de afbeelding te klikken. Kies voor 'kopiëren' om het plaatje op het
                    klembord te plaatsen of kies voor 'opslaan als...' om het plaatje op de
                    harde schijf te plaatsen.
                </td>
            </tr>

            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.title"/></td>
            <td><html:text property="title"/></td>
            </tr>
            <tr>
                <td valign="top"><fmt:message key="createmappdf.remark"/></td>
            <td><html:textarea property="remark" cols="60" rows="4"/></td>
            </tr>
            <tr>
                <td colspan="2" class="printvoorbeeld_help">
                    De startwaarde van de kwaliteitsbalk is afhankelijk van uw beeldscherm.
                    Als u deze kwaliteit aanpast kan het kaartbeeld veranderen t.o.v. het
                    orgineel.
                </td>
            </tr>            
            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.imageSize"/></td>
            <td>

                <!-- Slider div -->
                <div id="kwaliteitsbalk" style="width: 600px">
                    <div id="kwaliteitsbalk_labels" style="margin-left: 0px; padding-top: 0px;">
                        <span style="padding-top: 2px; margin-right: 90px; margin-left: 5px; padding-bottom: 10px;">Laag</span>
                        <span style="padding-top: 2px; padding-bottom: 10px;">Medium</span>
                        <span style="padding-top: 2px; margin-left: 90px; padding-bottom: 10px;">Hoog</span>
                    </div>

                    <div id="kwaliteitsbalk_slider" style="margin-left: 15px; padding-top: 10px;">
                        <div id="slider" style="width: 250px; float: left;"></div>

                        <div id="orgineelKnop" style="float: left; margin-left: 10px;">
                            <input type="button" onclick="resetImageSize();" value="Orginele kwaliteit"/>
                        </div>
                    </div>    

                </div>

                <html:hidden property="imageSize" styleId="imageSize"/>
                <input type="hidden" name="startImageSize" id="startImageSize" value="2048"/> 
            </td>
            </tr>         
            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.landscape"/></td>
            <td>
                <html:radio property="landscape" value="false">Staand</html:radio>
                <html:radio property="landscape" value="true">Liggend</html:radio>
            </td>
            </tr>
            <tr>
                <td><fmt:message key="createmappdf.pageformat"/></td>
            <td>
                <html:select property="pageSize">
                    <html:option value="A4">A4</html:option>
                    <html:option value="A3">A3</html:option>
                    <html:option value="A0">A0</html:option>
                </html:select>
            </td>
            </tr>
            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.outputtype"/></td>
            <td>
                <html:select property="outputType">                        
                    <html:option value="PDF">Toon PDF</html:option>
                    <html:option value="PDF_PRINT">Printen</html:option>
                    <%-- <html:option value="RTF">Toon RTF</html:option> --%>
                </html:select>
            </td>
            </tr>

            <tr>
                <td colspan="2" class="printvoorbeeld_help">
                    Hier kunt u de kaartlagen aanvinken waarvan u de legenda wil 
                    laten afdrukken. De legenda wordt op een losse pagina afgedrukt.
                </td>
            </tr>

            <tr>
                <td>Legenda</td>
                <td>
            <c:forEach var="entry" items="${legendItems}">
                <html:checkbox property="legendItems" value="${entry.key}" />${entry.key}<BR>
            </c:forEach>
            </td>
            </tr>

            <tr>
                <td colspan="2" class="printvoorbeeld_help">
                    De berekende waarde van de schaal is afhankelijk van uw beeldscherm.
                    Als u deze schaal aanpast kan het kaartbeeld veranderen t.o.v. het
                    orgineel.
                </td>
            </tr>   

            <tr>
                <td>Schaal</td>
                <td><b>1 : <html:text property="scale"/></b></td>
            </tr>
            <tr>
                <td>PPI</td>
                <td><html:text property="ppi" value="300"/></td>
            </tr>

            <tr>
                <td></td>
                <td><html:submit property="print"><fmt:message key="button.ok"/></html:submit></td>
                </tr>
            </table>
    </html:form>
    <br />
</div>
<script type="text/javascript">
    $j(function() {
        $j("#slider").slider({
            min: 0,
            max: 2048,
            value: 2048,
            animate: true,
            change: function(event, ui) { $j("#imageSize").val(ui.value); }
        });
    });
</script>
<script type="text/javascript" src="scripts/createmappdf.js"></script>
