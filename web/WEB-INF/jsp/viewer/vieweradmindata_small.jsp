<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
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
<html:messages id="error" message="true">
    <div class="messages"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15"/>&nbsp;<c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
    </html:messages>
    <c:choose>
        <c:when test="${not empty thema_items_list and not empty regels_list}">
            <c:set var="themanaam" value="" />
            <c:forEach var="thema_items" items="${thema_items_list}" varStatus="tStatus">
                <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                    <c:if test="${ThemaItem.thema.naam != themanaam}">
                        <c:set var="themanaam" value="${ThemaItem.thema.naam}" />
                        <strong>${themanaam}</strong>
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
                    <table id="data_table${tStatus.count}" cellpadding="0" cellspacing="0" style="table-layout: fixed; margin-left: 5px; width: ${totale_breedte}px;}">
                        <tbody>
                            <c:forEach var="regel" items="${regels}" varStatus="counter">
                                <tr>
                                    <c:set var="totale_breedte_onder" value="50" />
                                    <c:forEach var="waarde" items="${regel.values}" varStatus="kolom">
                                        <c:if test="${thema_items[kolom.count - 1] != null}">
                                            <c:choose>
                                                <c:when test="${thema_items[kolom.count - 1].kolombreedte != 0}">
                                                    <c:set var="breedte" value="${thema_items[kolom.count - 1].kolombreedte}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="breedte" value="150" />
                                                </c:otherwise>
                                            </c:choose>
                                            <c:set var="last_id" value=" style=\"width: ${breedte}px;\"" />
                                            <c:set var="totale_breedte_onder" value="${totale_breedte_onder + breedte}" />
                                            <td${last_id} valign="top">
                                                <c:choose>
                                                    <c:when test="${waarde eq '' or  waarde eq null}">
                                                        &nbsp;
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                                                <a href="#" onclick="popUp('${waarde}', 'aanvullende_info_scherm', 600, 500);">${thema_items[kolom.count - 1].label}</a>
                                                            </c:when>
                                                            <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                                                <a href="#" onclick="popUp('${waarde}', 'externe_link', 600, 500);">${thema_items[kolom.count - 1].label}</a>
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
                                            </td>
                                        </c:if>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:forEach>

        <script type="text/javascript">
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
                            <h2>Er is geen informatie gevonden.</h2>
                            <p>
                                Mogelijk is er op de door u gezochte plaats geen informatie beschikbaar.
                                Of uw selectie criteria leveren niks op.
                            </p>
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
</div>
