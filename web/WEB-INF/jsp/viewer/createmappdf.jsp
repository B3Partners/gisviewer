<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<script type="text/javascript">
    var setDefaultImageSizeFromMap=true;
</script>
<script type="text/javascript" src="scripts/yahoo-dom-event.js"></script>
<script type="text/javascript" src="scripts/dragdrop-min.js"></script>
<script type="text/javascript" src="scripts/slider-min.js"></script>

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
                    <img id="mapImage" alt="Preview"></img>
                </div>
                <input type="hidden" name="mapUrl" id="mapUrl"/>
            </td>            
        </tr>
        <tr>
            <td><fmt:message key="createmappdf.title"/></td>
            <td><input type="text" name="title" id="title"></td>
        </tr>
        <tr>
            <td valign="top"><fmt:message key="createmappdf.remark"/></td>
            <td><textarea name="remark" cols="40" rows="4"></textarea></td>
        </tr>
        <tr>
            <td><fmt:message key="createmappdf.imageSize"/></td>
            <td>
                <div style="padding-top: 5px; margin-right: 4px;">laag</div>
                <div id="sliderbg" style="background-image: url(images/bg-h.gif); cursor: pointer; width: 309px;">
                    <div id="sliderthumb"><img src="images/thumb-n.gif" alt="sliderhandle"></div>
                </div>
                <div style="padding-top: 5px; margin-left: 12px;">hoog</div>
                <input type="hidden" size="4" style="border: 0px none;" name="imageSize" id="imageSize" value="2048" onchange="changeVal(this);" />
                <script type="text/javascript" src="scripts/slider.js"></script>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                Als u de kwaliteit van de kaart veranderd kan het uiterlijk van de kaart veranderen.
            </td>
        </tr>
        <tr>
            <td><fmt:message key="createmappdf.landscape"/></td>
            <td>
                <input type="radio" name="landscape" value="false" checked>Staand</input>
                <input type="radio" name="landscape" value="true">Liggend</input>
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
        <tr>
            <td><fmt:message key="createmappdf.outputtype"/></td>
            <td>
                <select name="outputType">
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
<script type="text/javascript" src="scripts/createmappdf.js"></script>
