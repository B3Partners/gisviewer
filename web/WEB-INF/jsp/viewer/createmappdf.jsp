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
    <h1><fmt:message key="createmappdf"/></h1><br />
    <html:form action="/printmap" focus="title">
        <table>
            <tr>
                <td valign="top">
                    <fmt:message key="createmappdf.preview"/>
                </td>
                <td>
                    <div id="imageContainer">
                        <html:img page="/printmap.do?image=t&keepAlive=true&imageId=${imageId}"
                                  styleId="mapImage" alt="Preview" styleClass="width: 474px; height: 1px;" />
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
                    <td><html:textarea property="remark" cols="40" rows="4"/></td>
                </tr>
                <tr class="aanvullende_info_alternateTr">
                    <td><fmt:message key="createmappdf.imageSize"/></td>
                    <td>
                        <div style="padding-top: 5px; margin-right: 12px; float: left; padding-bottom: 5px; margin-left: 5px;">laag</div>
                        <div id="slider" style="width: 300px; float: left; margin-top: 8px; margin-bottom: 5px;"></div>
                        <div style="padding-top: 5px; margin-left: 16px; float: left; padding-bottom: 5px;">hoog</div>
                        <html:hidden property="imageSize" styleId="imageSize"/>
                        <input type="hidden" name="startImageSize" id="startImageSize" value="2048"/>
                        <input type="button" style="float: right;" onclick="resetImageSize();" value="origineel"/>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        Als u de kwaliteit van de kaart verandert, kan het uiterlijk van de kaart veranderen.
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
                            <html:option value="PDF_PRINT">Print PDF</html:option>
                            <html:option value="PDF">PDF</html:option>
                            <html:option value="RTF">RTF</html:option>
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
