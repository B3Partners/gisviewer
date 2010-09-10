<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>
<script type="text/javascript">
    var doClose=true;
    var usePopup = true;
</script>
<style type="text/css">
    .topRowThemaData {
        margin: 5px;
    }

    .topRowThemaData td {
        padding: 3px;
    }
</style>
<tiles:insert definition="actionMessages"/>
    <c:choose>
        <c:when test="${not empty thema_items_list and not empty regels_list}">
            <c:set var="themanaam" value="" />
            <c:forEach var="thema_items" items="${thema_items_list}" varStatus="tStatus">
                <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                    <c:if test="${ThemaItem.thema.naam != themanaam}">
                        <c:set var="themanaam" value="${ThemaItem.thema.naam}" />
                    <strong class="admindata2_header">${themanaam}</strong>
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
                                <div class="admindataSmallCell">
                                    <strong>${thema_items[kolom.count - 1].label}</strong> 
                                    <c:choose>
                                        <c:when test="${waarde eq '' or  waarde eq null}">
                                            &nbsp;
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                                    <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm', 600, 500);" style="cursor: pointer;" />
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
                                                                <img src="./images/icons/flag_blue.png" alt="Flag" style="border: 0px none;" />
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

        <script type="text/javascript">
            var autoPopupRedirect = false;
            
            if(!(opener && opener.usePopup) && !(parent && parent.useDivPopup) && !autoPopupRedirect) {
                if(parent) {
                    if(parent.panelBelowCollapsed) {
                        parent.panelResize('below');
                    }
                }
            }
        </script>
    </c:when>
    <c:otherwise>
        <div id="content_style">
            <table class="kolomtabel" style="width: 230px;">
                <tr>
                    <td valign="top">
                        <div class="inleiding" style="width: 242px;">

                            <h2><fmt:message key="admindata.geeninfo.header"/></h2>
                            <p><fmt:message key="admindata.geeninfo.tekst"/></p>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">            
            function closeWindow() {
                if (doClose)
                    window.close();
            }

            // Timeout in milliseconden
            var timeout = 5000;
            window.setTimeout(closeWindow, timeout);

        </script>
    </c:otherwise>
</c:choose>
<div id="getFeatureInfo">

<script type="text/javascript">
    if (opener)
        opener.hideLoading();
    else if (parent)
        parent.hideLoading();
    else 
        alert("Er is een fout opgetreden bij het sluiten van de laadbalk.");
</script>
</div>
