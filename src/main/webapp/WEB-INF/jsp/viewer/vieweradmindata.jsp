<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/engine.js?v=${JS_VERSION}'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js?v=${JS_VERSION}'></script>
<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js?v=${JS_VERSION}'></script>

<script type="text/javascript" src="<html:rewrite page='/scripts/components/Admindata.js?v=${JS_VERSION}'/>"></script>
<script type="text/javascript">

    var myparent = B3PGissuite.commons.getParent({ parentOnly: true });
    if(myparent) {
        myparent.B3PGissuite.commons.hideLoading();
        if(myparent.panelBelowCollapsed) {
            myparent.B3PGissuite.get('Layout').panelResize('below');
        }
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
    (function() {
        var adminData = B3PGissuite.createComponent('Admindata', {
            onlyFeaturesInGeom: ${onlyFeaturesInGeom},
            bookmarkAppcode: "${bookmarkAppcode}",
            plusicon: '<html:rewrite href="./images/icons/plus_icon.gif" />',
            minusicon: '<html:rewrite href="./images/icons/minus_icon.gif" />',
            infoicon: '<html:rewrite href="./images/icons/information.png" />',
            urlicon: '<html:rewrite href="./images/icons/world_link.png" />',
            flagicon: '<html:rewrite href="./images/icons/flag_blue.png" />',
            wandicon: '<html:rewrite href="./images/icons/wand.png" />',
            loadingicon: '<html:rewrite href="./images/icons/loading.gif" />',
            pencil: '<html:rewrite href="./images/icons/pencil.png" />',
            pdficon: '<html:rewrite href="./images/icons/pdf.png" />',
            docicon: '<html:rewrite href="./images/icons/document.png" />',
            csvexporticon: '<html:rewrite href="./images/icons/page_white_csv.png" />',
            infoexporticon: '<html:rewrite href="./images/icons/page_white_info.png" />',
            googleIcon: '<html:rewrite href="./images/icons/google-maps.png" />',
            noResultsHeader: '<fmt:message key="admindata.geeninfo.header"/>',
            noResultsTekst: '<fmt:message key="admindata.geeninfo.tekst"/>'
        });
        <c:choose>
            <c:when test="${not empty beans}">
                <%-- er komt reguliere admindata binnen. de wachtmelding wordt in de handleGetGegevensBron op onzichtbaar gezet. --%>
                    $j(document).ready(function() {
                        <c:forEach items="${beans}" var="bean">
                            adminData.addGegevensbron({
                                'bean': {
                                    'id': ${bean.id},
                                    'themaId': ${bean.themaId},
                                    'wkt': '${bean.wkt}',
                                    'cql': JSON.stringify(${bean.cql})
                                },
                                'htmlId': 'adminDataWrapper'
                            });
                        </c:forEach>
                    });
            </c:when>
            <c:otherwise>
                <%-- er komt geen reguliere admindata binnen, we schrijven vertraagd
                dat er geen data beschikbaar is. Als via getFeatureInfo data binnenkomt
                dan wordt deze melding op onzichtbaar gezet. --%>
                adminData.writeNoResults();
            </c:otherwise>
        </c:choose>
    }());
</script>

<div style="display: none;">
    <iframe id="csvIframe" name="csvIframe"></iframe>
</div>