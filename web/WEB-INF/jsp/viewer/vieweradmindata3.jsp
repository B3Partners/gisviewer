<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false" %>

<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>
<script type="text/javascript">
    var autoPopupRedirect = false;

    function editFeature(value) {
        getParent().drawWkt(value);
    };
    function popUp(link, title, width, heigth) {
        getParent().popUp(link, title, width, heigth);
    }
</script>

<style type="text/css">
    .topRowThemaData {
        margin: 5px;
    }

    .topRowThemaData td {
        padding: 3px;
    }    
</style>

<tiles:insert definition="specialMessages"/>

<c:choose>
    <c:when test="${not empty thema_items_list and not empty regels_list}">

        <c:set var="themanaam" value="" />
        <c:forEach var="thema_items" items="${thema_items_list}" varStatus="tStatus">

            <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                <c:if test="${ThemaItem.gegevensbron.naam != themanaam}">
                    <c:set var="themanaam" value="${ThemaItem.gegevensbron.naam}" />

                    <strong class="admindata3_header">${themanaam}</strong>
                </c:if>
            </c:forEach>

            <div class="topRowThemaData" id="fullTable${tStatus.count}">
                <c:set var="regels" value="${regels_list[tStatus.count-1]}"/>
                <div id="admin_data_content_div${tStatus.count}">
                    <c:forEach var="regel" items="${regels}" varStatus="counter">
                        <c:if test="${counter.count == 1}">
                            <c:set var="totale_breedte" value="0" />
                            <c:forEach var="waarde" items="${regel.values}" varStatus="kolom">
                                <c:choose>
                                    <c:when test="${thema_items[kolom.count - 1].kolombreedte != 0}">
                                        <c:set var="totale_breedte" value="${totale_breedte + thema_items[kolom.count - 1].kolombreedte}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="totale_breedte" value="${totale_breedte + 150}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:if>
                    </c:forEach>

                    <c:forEach var="regel" items="${regels}" varStatus="counter">
                        <c:set var="totale_breedte_onder" value="50" />
                        <c:forEach var="waarde" items="${regel.values}" varStatus="kolom">
                            <c:if test="${thema_items[kolom.count - 1] != null}">
                                <div class="admindata3Cell">
                                    <strong>${thema_items[kolom.count - 1].label}</strong>
                                    <c:choose>
                                        <c:when test="${waarde eq '' or  waarde eq null}">
                                            &nbsp;
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                                    <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm', 600, 500);" styleClass="cursorpointer" />
                                                </c:when>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                                    <c:forEach var="listWaarde" items="${waarde}">
                                                        <a href="#" onclick="popUp('${listWaarde}', 'externe_link', 600, 500);">${thema_items[kolom.count - 1].label}</a>
                                                    </c:forEach>
                                                </c:when>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 4}">
                                                    <c:choose>
                                                        <c:when test="${fn:length(fn:split(waarde, '###')) > 1}">
                                                            <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="${fn:split(waarde, '###')[1]}" title="${fn:split(waarde, '###')[0]}">
                                                                <img src="./images/icons/flag_blue.png" alt="Flag" class="imagenoborder" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    ${waarde}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>                           
                        </c:forEach>

                        <br/>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </c:when>

    <c:otherwise>
        <!-- nog een keer loading melden, omdat via GetFeatureInfo nog data
        binnen kan komen, later beter oplossen -->
        <div id="content_style">
            <table class="kolomtabel">
                <tr>
                    <td valign="top">
                        <div class="inleiding">
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
        <script type="text/javascript">
            var timeout = 3000;
            window.setTimeout("writeNoResults();", timeout);
        </script>
    </c:otherwise>
</c:choose>

<div id="getFeatureInfo"></div>

<script type="text/javascript">
    //writes the obj data from flamingo to a table
    function writeFeatureInfoData(obj){
        doClose=false;
        var tableData="";
        for (layer in obj){
            tableData+="<table class=\"aanvullende_info_table\" >";
            for (feature in obj[layer]){
                tableData+="    <tr class=\"topRow\">";
                tableData+="        <th colspan=\"2\" class=\"aanvullende_info_td\">&nbsp;";
                tableData+=layer;
                tableData+="        </th>";
                tableData+="    </tr>";
                var tellerAtt=0;
                for (attribute in obj[layer][feature]){
                    if (tellerAtt%2==0){
                        tableData+="    <tr>"
                    }else{
                        tableData+="    <tr class=\"aanvullende_info_alternateTr\">"
                    }
                    tellerAtt++;
                    tableData+="        <td>"+attribute+"</td>"
                    tableData+="        <td>"+obj[layer][feature][attribute]+"</td>"
                    tableData+="    </tr>";
                }
                tableData+="    <tr><td> </td><td> </td></tr>";
            }
            tableData+="</table>";
        }
        if (document.getElementById("content_style")!=undefined && tableData.length>0){
            document.getElementById("content_style").style.display="none";
        }
        document.getElementById('getFeatureInfo').innerHTML=tableData;
    }

    function writeNoResults() {
        var tableData="";
        tableData+="<table class=\"kolomtabel\">";
        tableData+="<tr>";
        tableData+="<td valign=\"top\">";
        tableData+="<div id=\"inleiding\" class=\"inleiding\">";
        tableData+="<h2><fmt:message key="admindata.geeninfo.header"/></h2>";
        tableData+="<p><fmt:message key="admindata.geeninfo.tekst"/></p>";
        tableData+="</div>";
        tableData+="</td>";
        tableData+="</tr>";
        tableData+="</table>";
        if (document.getElementById("content_style")!=undefined){
            document.getElementById('content_style').innerHTML=tableData;
        }
    }

</script>

<script type="text/javascript">
    if (opener)
        opener.hideLoading();
    else if (parent)
        parent.window.hideLoading();

    if(!(opener && opener.usePopup) && !(parent && parent.useDivPopup) && !autoPopupRedirect) {
        if(parent) {
            if(parent.panelBelowCollapsed) {
                parent.panelResize('below');
            }
        }
    }
</script>
