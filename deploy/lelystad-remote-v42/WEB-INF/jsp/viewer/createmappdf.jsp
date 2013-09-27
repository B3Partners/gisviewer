<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="imageId" value="${printForm.map.imageId}"/>
<c:set var="psettingsName" value="${imageId}"/>
<c:set var="psettings" value='${sessionScope[psettingsName]}'/>
<c:set var="firstUrl" value="${psettings.urls[0]}"/>

<script type="text/javascript">
    var setDefaultImageSizeFromMap = true;
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
                    op de afbeelding te klikken. Kies voor 'kopi�ren' om het plaatje op het
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

			<html:hidden property="ppi" value="150" />   
			
			<%--
            <tr>
                <td>Resolutie</td>
                <td>
                    <html:select property="ppi">    
						<html:option value="300">300 ppi</html:option>
						<html:option value="150">150 ppi</html:option>                  
                        <html:option value="72">72 ppi</html:option>
                    </html:select>
                </td>
            </tr>
            --%>

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

            <html:hidden property="ppi" value="72"/>

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
            change: function(event, ui) {
                $j("#imageSize").val(ui.value);
            }
        });
    });
</script>
<script type="text/javascript" src="scripts/createmappdf.js"></script>
