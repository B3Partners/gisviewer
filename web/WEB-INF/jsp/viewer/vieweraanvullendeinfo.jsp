<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>

<script type="text/javascript" src="<html:rewrite page='/scripts/components/Admindata.js'/>"></script>
<script type="text/javascript">

    function catchEmpty(defval){
        return defval
    }
    
    var mapRequest = null;
    if (window.opener){
        if (window.opener.lastGetMapRequest){
            mapRequest=window.opener.lastGetMapRequest;
        }else if(window.opener.opener && window.opener.opener.lastGetMapRequest){
            mapRequest=window.opener.opener.lastGetMapRequest;
        }else if(window.opener.parent && window.opener.parent.lastGetMapRequest){
            mapRequest=window.opener.parent.lastGetMapRequest;
        }

    }else{
        mapRequest=window.parent.lastGetMapRequest;
    }
    mapRequest=removeParam(mapRequest,"bbox");
    mapRequest=removeParam(mapRequest,"width");
    mapRequest=removeParam(mapRequest,"height");

    if (typeof mapRequest === 'undefined' || !url) {
        mapRequest = "";
    }

    if (mapRequest.lastIndexOf("?")!=mapRequest.length-1 && mapRequest.lastIndexOf("&")!=mapRequest.length-1){
        if (mapRequest.indexOf("?")>0){
            mapRequest+="&";
        }else{
            mapRequest+="?";
        }
    }
    //max map image height
    var maxMapImageWidth=300;
    //max map image width
    var maxMapImageHeight=300;
    //De ruimte om het object heen dat ook moet worden getoond in het kaartje.
    var mapSpaceAround=10;

    function removeParam(url,param){

        if (typeof url === 'undefined' || !url) {
            return;
        }
        
        var newUrl;
        var paramBeginIndex=url.toLowerCase().indexOf(param+"=", 0);
        if (paramBeginIndex == -1)
            return url;
        var paramEndIndex=url.toLowerCase().indexOf('?',paramBeginIndex);
        if (paramEndIndex==-1){
            paramEndIndex=url.length-1;
        }        
        newUrl=url.substring(0,paramBeginIndex);
        newUrl+=url.substring(paramEndIndex);
        return newUrl;
    }

    // Create the admindata component
    B3PGissuite.createComponent('Admindata');
    // Added some proxy functions to support JS functions from JSTL below
    function setAttributeValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').setAttributeValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function setAttributeStringValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').setAttributeStringValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function setStatusValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').setStatusValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function setStatusValueDigitree(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').setStatusValueDigitree(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function setAttributeText(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').setAttributeText(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function doDummy(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').doDummy(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function berekenOppervlakte(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid) {
        B3PGissuite.get('Admindata').berekenOppervlakte(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid);
    }
    function showMaatregel(deze, gegevensbronId, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom) {
        B3PGissuite.get('Admindata').showMaatregel(deze, gegevensbronId, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom);
    }
    function highlightFeature(deze, themaid, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom) {
        B3PGissuite.get('Admindata').highlightFeature(deze, themaid, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom);
    }
</script>

<c:choose>
    <c:when test="${not empty thema_items and not empty regels}">
        <table id="aanvullende_info_master_table">
            <c:forEach var="regel" items="${regels}" varStatus="regelCounter">
                    <tr style="page-break-after: always;">
                        <td valign="top">
                            <table class="aanvullende_info_table">
                                <tr class="topRow">
                                    <th colspan="2" class="aanvullende_info_td">
                                        Aanvullende informatie
                                    </th>
                                </tr>
                                <c:forEach var="ThemaItem" items="${thema_items}" varStatus="counter">
                                    <c:choose>
                                        <c:when test="${counter.count % 2 == 0}">
                                            <c:set var="altTr" value=""/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="altTr" value="aanvullende_info_alternateTr"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <tr class="${altTr}">
                                        <th class="aanvullende_info_th">${ThemaItem.label}</th>
                                        <td class="aanvullende_info_td">
                                            <c:choose>
                                                <c:when test="${ThemaItem.dataType.id == 2}">
                                                    -
                                                </c:when>
                                                <c:when test="${regel.values[counter.count - 1] eq ''}">
                                                    -
                                                </c:when>
                                                <c:when test="${ThemaItem.dataType.id == 3}">
                                                    <c:forEach var="listWaarde" items="${regel.values[counter.count - 1]}">
                                                        <html:image src="./images/icons/world_link.png" onclick="var pu = B3PGissuite.viewercommons.popUp('${listWaarde}', 'externe_link', 1024, 768); if(window.focus) pu.focus();" styleClass="cursorpointer" />
                                                    </c:forEach>
                                                </c:when>
                                                <c:when test="${ThemaItem.dataType.id == 4}">
                                                    <c:set var="valar" value="${fn:split(regel.values[counter.count - 1], '###')}" />
                                                    <c:set var="funct" value="${valar[0]}" />
                                                    <c:if test="${fn:length(valar) > 1}">
                                                        <c:set var="funct" value="${valar[1]}" />
                                                    </c:if>
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(funct,'setAttributeValue')}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(valar) > 1}">
                                                                    <c:out value="${valar[0]}"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    -
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${fn:startsWith(funct,'setAttributeText')}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(valar) > 1}">
                                                                    <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="return ${valar[1]}">${valar[0]}</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="return ${valar[0]}"><em>leeg</em></a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${fn:length(valar) > 1}">
                                                            <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="${valar[1]}">${valar[0]}</a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    ${regel.values[counter.count - 1]}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </td>
                       <td valign="top">
                             <!-- Wordt een plaatje getoond van het object -->
                            <c:if test="${envelops[0].minX!=null and not empty envelops[0].minX}">
                                <div class="aanvullendeInfoKaartContainer">
                                    <script>
                                        var minx,maxx,miny,maxy,ax,ay;
                                        minx=<c:out value="${envelops[regelCounter.count-1].minX}"/>;
                                        miny=<c:out value="${envelops[regelCounter.count-1].minY}"/>;
                                        maxx=<c:out value="${envelops[regelCounter.count-1].maxX}"/>;
                                        maxy=<c:out value="${envelops[regelCounter.count-1].maxY}"/>;

                                        minx=Number(minx)-mapSpaceAround;
                                        miny=Number(miny)-mapSpaceAround;
                                        maxx=Number(maxx)+mapSpaceAround;
                                        maxy=Number(maxy)+mapSpaceAround;
                                        var ax=maxx-minx;
                                        var ay=maxy-miny;

                                        var xfactor=ax/maxMapImageWidth;
                                        var yfactor=ay/maxMapImageHeight;
                                        var width;
                                        var height;
                                        if (xfactor > yfactor){
                                            width=Math.floor(ax/xfactor);
                                            height=Math.floor(ay/xfactor);
                                        }else{
                                            width=Math.floor(ax/yfactor);
                                            height=Math.floor(ay/yfactor);
                                        }
                                        var newMapRequest=""+mapRequest;
                                        newMapRequest+="bbox="+minx+","+miny+","+maxx+","+maxy+"&";
                                        newMapRequest+="height="+height+"&";
                                        newMapRequest+="width="+width+"&";
                                        var imagetag="<img src='"+newMapRequest+"'";
                                        if (xfactor > yfactor){
                                            imagetag+=" width='"+width;
                                        }else{
                                            imagetag+=" height='"+height;
                                        }
                                        imagetag+="' alt='"+newMapRequest+"'/>";
                                        if (mapRequest!="") {
                                            document.write(imagetag);
                                        }
                                    </script>
                                </div>
                            </c:if>
                       </td>
                   </tr>
            </c:forEach>
        </table>
        <!-- Wordt gebruikt om eventuele opmerkingen te bewerken -->
        <div id="opmerkingenedit" style="display: none; position: absolute; text-align: right;">
            <textarea id="opmText" cols="60" rows="3"></textarea><br />
            <input type="button" value="Ok" id="opmOkButton" />
            <input type="button" value="Cancel" id="opmCancelButton" />
        </div>
    </c:when>
    <c:otherwise>
        Er is geen admin data gevonden!
    </c:otherwise>
</c:choose>
        
<script type="text/javascript">
     if (opener) {
        opener.B3PGissuite.commons.hideLoading();
    } else if (parent) {
        parent.B3PGissuite.commons.hideLoading();
    } else {
        B3PGissuite.commons.messagePopup("Fout", "Er is een fout opgetreden bij het sluiten van de laadbalk.", "error");
    }

</script>


