<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src="<html:rewrite page="/scripts/table.js"/>"></script>
<script type="text/javascript">
            function popUp(URL, naam) {
                var screenwidth = 600;
                var screenheight = 500;
                var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
                var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
                properties = "toolbar = 0, " + 
                             "scrollbars = 1, " + 
                             "location = 0, " + 
                             "statusbar = 1, " + 
                             "menubar = 0, " + 
                             "resizable = 1, " + 
                             "width = " + screenwidth + ", " + 
                             "height = " + screenheight + ", " + 
                             "top = " + popuptop + ", " + 
                             "left = " + popupleft;
                eval("page" + naam + " = window.open(URL, '" + naam + "', properties);");
            }
</script>
<c:choose>
    <c:when test="${not empty thema_items and not empty regels}">
        
        <table id="admindata_table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
            <thead>
                <tr class="topRow" style="height: 20px;">
                    <th style="width: 50px;" class="table-sortable:numeric" id="volgnr_th" onclick="Table.sort(data_table, {sorttype:Sort['numeric'], col:0});">
                        Volgnr
                    </th>
                    <c:set var="totale_breedte" value="50" />
                    <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                        <c:choose>
                            <c:when test="${ThemaItem.kolombreedte != 0}">
                                <c:set var="breedte" value="${ThemaItem.kolombreedte}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="breedte" value="150" />
                            </c:otherwise>            
                        </c:choose>
                        <c:set var="totale_breedte" value="${totale_breedte + breedte}" />
                        <c:if test="${topRowStatus.last && totale_breedte < 948}">
                            <c:set var="breedte" value="${breedte + (948 - totale_breedte)}" />
                        </c:if>
                        <th style="width: ${breedte}px;" class="table-sortable:default" onclick="Table.sort(data_table, {sorttype:Sort['default'], col:${topRowStatus.count}});">
                            ${ThemaItem.label}
                        </th>
                    </c:forEach>
                </tr>
            </thead>
        </table>
        <div class="admin_data_content_div">
            <table id="data_table" class="table-autosort table-stripeclass:admin_data_alternate_tr" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                <tbody>
                    <c:set var="totale_breedte_onder" value="50" />
                    <c:forEach var="regel" items="${regels}" varStatus="counter">
                        <tr class="row" onclick="colorRow(this);">
                            <td style="width: 50px;" valign="top">
                                ${counter.count}
                            </td>
                            <c:forEach var="waarde" items="${regel}" varStatus="kolom">
                                <c:if test="${thema_items[kolom.count - 1] != null}">
                                    <c:choose>
                                        <c:when test="${thema_items[kolom.count - 1].kolombreedte != 0}">
                                            <c:set var="breedte" value="${thema_items[kolom.count - 1].kolombreedte}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="breedte" value="150" />
                                        </c:otherwise>            
                                    </c:choose>
                                    <c:set var="totale_breedte_onder" value="${totale_breedte_onder + breedte}" />
                                    <c:if test="${kolom.last && totale_breedte_onder < 915}">
                                        <c:set var="breedte" value="${breedte + (915 - totale_breedte_onder)}" />
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                            <td style="width: ${breedte}px;" valign="top">
                                                <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm');" style="cursor: pointer; cursor: hand;" />
                                            </td>
                                        </c:when>
                                        <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                            <td style="width: ${breedte}px;" valign="top">
                                                <html:image src="./images/icons/world_link.png" onclick="popUp('${waarde}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${waarde eq '' or  waarde eq null}">
                                                <c:set var="waarde" value="&nbsp;" />
                                            </c:if>
                                            <td style="width: ${breedte}px;" valign="top">
                                                ${waarde}
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <script language="javascript" type="text/javascript">
                    var data_table = document.getElementById('data_table');
                    Table.stripe(data_table, 'admin_data_alternate_tr');
                    Table.sort(data_table, {sorttype:Sort['numeric'], col:0});
                    
                    var currentObj;
                    var currentObjOldStyle;
                    function colorRow(obj) {
                        if(currentObj) {
                            currentObj.className = currentObjOldStyle;
                        }
                        currentObj = obj;
                        currentObjOldStyle = obj.className;
                        obj.className = obj.className + ' admin_data_selected_tr';
                    }
        </script>
    </c:when>
    <c:otherwise>
        Er is geen admin data gevonden!
    </c:otherwise>
</c:choose>

