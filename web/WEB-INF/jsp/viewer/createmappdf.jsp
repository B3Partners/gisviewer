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
    <h1><fmt:message key="createmappdf"/></h1>

    <html:form action="/printmap" focus="title">
    <table>
        <tr>
            <td colspan="2" class="createmappdftd">
                <div id="imageContainer">
                    <html:img page="/printmap.do?image=t&keepAlive=true&imageId=${imageId}" styleId="mapImage" alt="Preview" styleClass="width: 474px; height: 1px;" />
                </div>
                <html:hidden property="imageId" styleId="imageId"/>
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
                <td colspan="2">
                    De startwaarde van de kwaliteitsbalk is afhankelijk van uw beeldscherm. Als u<br/>
                    deze kwaliteit aanpast kan het kaartbeeld veranderen t.o.v. het orgineel.
                </td>
            </tr>
            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.imageSize"/></td>
                <td>
                    <div style="padding-top: 2px; margin-right: 90px; margin-left: 5px; float: left; padding-bottom: 10px;">Laag</div>
                    <div style="padding-top: 2px; float: left; padding-bottom: 10px;">Medium</div>
                    <div style="padding-top: 2px; margin-left: 90px; float: left; padding-bottom: 10px;">Hoog</div>

                    <div id="orgineelKnop" style="padding-top: 10px; margin-left: 10px; float: left; padding-bottom: 5px;">
                        <input type="button" onclick="resetImageSize();" value="Orginele kwaliteit"/>
                    </div>

                    <div id="slider" style="width: 250px; margin-left: 10px; margin-top: 20px;"></div>

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
                    </html:select>
                </td>
            </tr>
            <tr class="aanvullende_info_alternateTr">
                <td><fmt:message key="createmappdf.outputtype"/></td>
                <td>
                    <html:select property="outputType">
                        <html:option value="PDF_PRINT">Print</html:option>
                        <html:option value="PDF">Maak PDF</html:option>
                        <html:option value="RTF">Maak RTF</html:option>
                    </html:select>
                </td>
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
    $(function() {
        $("#slider").slider({
            min: 0,
            max: 2048,
            value: 2048,
            animate: true,
            change: function(event, ui) { $("#imageSize").val(ui.value); }
        });
    });
</script>
<script type="text/javascript" src="scripts/createmappdf.js"></script>
