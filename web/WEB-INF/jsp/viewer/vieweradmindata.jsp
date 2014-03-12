<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js'></script>

<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>
<script type="text/javascript">

    var plusicon = '<html:rewrite href="./images/icons/plus_icon.gif" />';
    var minusicon = '<html:rewrite href="./images/icons/minus_icon.gif" />';
    var infoicon = '<html:rewrite href="./images/icons/information.png" />';
    var urlicon = '<html:rewrite href="./images/icons/world_link.png" />';
    var flagicon = '<html:rewrite href="./images/icons/flag_blue.png" />';
    var wandicon = '<html:rewrite href="./images/icons/wand.png" />';
    var loadingicon = '<html:rewrite href="./images/icons/loading.gif" />';
    
    var pencil = '<html:rewrite href="./images/icons/pencil.png" />';

    var pdficon = '<html:rewrite href="./images/icons/pdf.png" />';
    var docicon = '<html:rewrite href="./images/icons/document.png" />';

    var csvexporticon = '<html:rewrite href="./images/icons/page_white_csv.png" />';
    var infoexporticon = '<html:rewrite href="./images/icons/page_white_info.png" />';

    var googleIcon = '<html:rewrite href="./images/icons/google-maps.png" />';
    
    var noResultsHeader = '<fmt:message key="admindata.geeninfo.header"/>';
    var noResultsTekst = '<fmt:message key="admindata.geeninfo.tekst"/>';

    var timeout = 3000;
    var loop = 0;

    B3PGissuite.commons.getParent({ parentOnly: true }).B3PGissuite.commons.hideLoading();
    if(B3PGissuite.commons.getParent({ parentOnly: true }).panelBelowCollapsed) {
        parent.panelResize('below');
    }

</script>

<tiles:insert definition="specialMessages"/>
<%-- nog een keer loading melden en pas wissen als er data binnenkomt via ofwel
reguliere admindata of GetFeatureInfo --%>
<div id="content_style">
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <div class="loadingMessage">
                    <table>
                        <tr>
                            <td style="width:20px;"><img style="border: 0px;" src="/gisviewer/images/waiting.gif" alt="Bezig met laden..." /></td>
                            <td>
                                <h2>Bezig met laden ...</h2>
                                <p>Bezig met zoeken naar administratieve gegevens.</p>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</div>

<div id="adminDataContainer">
    <div id="adminDataWrapper"></div>
    <div style="clear: both;"></div>
</div>
<%-- div id="childLoadingadminDataContainer" class="childLoading"><img src="images/icons/loading.gif" alt="Loading" title="Loading" /></div --%>
<div id="getFeatureInfo"></div>
<script type="text/javascript" src="<html:rewrite page='/scripts/lib/json2.js'/>"></script>
<script type="text/javascript">
    /*True als er alleen features mogen worden getoond die binnen de originele vraag geometry liggen (klik punt(met kleine buffer)
     of getekend object(polygon))
    false als childs altijd moeten worden getoond als het een child is. 
     */    
    var onlyFeaturesInGeom=${onlyFeaturesInGeom};
    var bookmarkAppcode="${bookmarkAppcode}";
    
    <c:choose>
        <c:when test="${not empty beans}">
            <%-- er komt reguliere admindata binnen. de wachtmelding wordt in de
            handleGetGegevensBron op onzichtbaar gezet. --%>
                $j(document).ready(function() {
            <c:forEach items="${beans}" var="bean">
                    // optellen aantal gegevensbronnen
                    loop++;
                    // haal gegevens op van gegevensbron                    
                    JCollectAdmindata.fillGegevensBronBean(${bean.id}, ${bean.themaId}, '${bean.wkt}', JSON.stringify(${bean.cql}), false, 'adminDataWrapper', bookmarkAppcode, handleGetGegevensBron);
            </c:forEach>
                });
        </c:when>
        <c:otherwise>
            <%-- er komt geen reguliere admindata binnen, we schrijven vertraagd
            dat er geen data beschikbaar is. Als via getFeatureInfo data binnenkomt
            dan wordt deze melding op onzichtbaar gezet. --%>
            window.setTimeout("writeNoResults();", timeout);
        </c:otherwise>
    </c:choose>
</script>

<div style="display: none;">
    <iframe id="csvIframe" name="csvIframe"></iframe>
</div>