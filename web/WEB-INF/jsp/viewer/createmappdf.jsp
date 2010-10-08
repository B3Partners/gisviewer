<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="psettingsName" value="${imageId}"/>
<c:set var="psettings" value='${sessionScope[psettingsName]}'/>
<c:set var="firstUrl" value="${psettings.urls[0]}"/>

<script type="text/javascript">
    var setDefaultImageSizeFromMap=true;
    var firstUrl = "${firstUrl}";
</script>


<div class="createMapPDFBody">
    <h1><fmt:message key="createmappdf"/></h1><br />
    <form action="services/CreateMapPDF" name="createMapPdf" id="createMapPdf" target="_blank">
    <table>
        <tr>
            <td valign="top">
                <fmt:message key="createmappdf.preview"/>
            </td>
            <td>
                <div id="imageContainer">        
                    <img src="CreateImage?keepAlive=true&imageId=${imageId}" id="mapImage" alt="Preview" style="width: 474px; height: 1px;" />
                </div>
                <input type="hidden" name="imageId" id="imageId" value="${imageId}"/>
            </td>            
        </tr>
        <tr class="aanvullende_info_alternateTr">
            <td><fmt:message key="createmappdf.title"/></td>
            <td><input type="text" name="title" id="title"></td>
        </tr>
        <tr>
            <td valign="top"><fmt:message key="createmappdf.remark"/></td>
            <td><textarea name="remark" cols="40" rows="4"></textarea></td>
        </tr>
        <tr class="aanvullende_info_alternateTr">
            <td><fmt:message key="createmappdf.imageSize"/></td>
            <td>
                <div style="padding-top: 5px; margin-right: 12px; float: left; padding-bottom: 5px; margin-left: 5px;">laag</div>
                <div id="slider" style="width: 300px; float: left; margin-top: 8px; margin-bottom: 5px;"></div>
                <div style="padding-top: 5px; margin-left: 16px; float: left; padding-bottom: 5px;">hoog</div>
                <input type="hidden" name="imageSize" id="imageSize" value="2048"/>
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
                <input type="radio" name="landscape" value="false">Staand</input>
                <input type="radio" name="landscape" value="true" checked>Liggend</input>
            </td>
        </tr>
        <tr>
            <td><fmt:message key="createmappdf.pageformat"/></td>
            <td>
                <select name="pageSize">
                    <option value="A4">A4</option>                        
                    <option value="A3">A3</option>                        
                </select>
            </td>
        </tr>
        <tr class="aanvullende_info_alternateTr">
            <td><fmt:message key="createmappdf.outputtype"/></td>
            <td>
                <select name="outputType">
                    <option value="PDF_PRINT" selected>Print PDF</option>
                    <option value="PDF">PDF</option>                        
                    <option value="RTF">RTF</option>  
                </select>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" value='<fmt:message key="button.ok"/>'></input></td>
        </tr>
    </table>    
</form>
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
