<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

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
            <td><fmt:message key="createmappdf.remark"/></td>
            <td><input type="textarea" name="remark"/></td>
        </tr>
        <tr>
            <td><fmt:message key="createmappdf.imageSize"/></td>
            <td>
                <div id="sliderbg" style="background-image: url(images/bg-h.gif); cursor: pointer; width: 309px;">
                    <div id="sliderthumb"><img src="images/thumb-n.gif" alt="sliderhandle"></div>
                </div>
                <div style="margin-left: 10px;">
                    <input type="hidden" size="4" style="border: 0px none;" name="imageSize" id="imageSize" value="2048" onchange="changeVal(this);" />
                </div>
                <script type="text/javascript">
                    var slider;
                    slider = YAHOO.widget.Slider.getHorizSlider("sliderbg", "sliderthumb", 0, 300);
                    slider.setValue(300);
                    slider.getRealValue = function() {
                        return Math.round(this.getValue() * (2048/300));
                    }
                    slider.subscribe("change", function(offsetFromStart) {
                        var fld = document.getElementById("imageSize");
                        var actualValue = slider.getRealValue();
                        fld.value = actualValue;

                    });

                    function changeVal(obj) {
                        var strValue = obj.value;
                        var fValue = parseFloat(strValue);
                        if(!isNaN(fValue)) {
                            if(fValue >= 0 && fValue <= 2048) {
                                slider.setValue(Math.round(fValue / 10.24), false);
                            }
                        }
                    }
                </script>
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
<script type="text/javascript">            
    function setMapImageSrc(url){
        document.getElementById("mapImage").src=url;
        document.getElementById("mapUrl").value=url;        
    }
    //doe bij de eerste keer laden:
    if (window.opener){
        setMapImageSrc(window.opener.lastGetMapRequest);
    }
</script>
