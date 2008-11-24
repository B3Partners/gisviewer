<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<div class="createMapPDFBody">
    <h1><fmt:message key="createmappdf"/></h1>
<form action="services/CreateMapPDF" name="createMapPdf" id="createMapPdf" target="_blank">
    <table>
        <tr>
            <td>
                <fmt:message key="createmappdf.preview"/>
            </td>
            <td>
                <div id="imageContainer">        
                    <img id="mapImage" alt="Preview">                        
                    </img>
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
            <td><input type="text" name="imageSize" id="imageSize" value="2048"/>(een waarde tussen de 1 en 2048)</td>
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
