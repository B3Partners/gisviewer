<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>
<html>
    <head>
        <title>Viewer Data</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="<html:rewrite page="/scripts/table.js"/>"></script>
        <script type="text/javascript">
            function popUp(URL, naam) {
                var screenwidth = 1024;
                var screenheight = 768;
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
        <style type="text/css">
            .alternate {
                background-color: #DDDDDD;
            }
            .selected {
                background-color: #0094FF;
            }
        </style>
    </head>
    <body style="margin: 0px; padding: 0px;">
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
                                <th style="width: ${breedte};" class="table-sortable:default" onclick="Table.sort(data_table, {sorttype:Sort['default'], col:${topRowStatus.count}});">
                                    ${ThemaItem.label}
                                </th>
                            </c:forEach>
                        </tr>
                    </thead>
                </table>
                <div style="overflow: auto; height: 245px; width: 948px;">
                    <table id="data_table" class="table-autosort table-stripeclass:alternate" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                        <tbody>
                            <c:set var="totale_breedte" value="50" />
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
                                            <c:set var="totale_breedte" value="${totale_breedte + breedte}" />
                                            <c:if test="${kolom.last && totale_breedte < 931}">
                                                <c:set var="breedte" value="${breedte + (931 - totale_breedte)}" />
                                            </c:if>
                                            <c:choose>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                                    <td style="width: ${breedte};" valign="top">
                                                        <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm');" style="cursor: pointer; cursor: hand;" />
                                                    </td>
                                                </c:when>
                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                                    <td style="width: ${breedte};" valign="top">
                                                        <html:image src="./images/icons/world_link.png" onclick="popUp('${waarde}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                                                    </td>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${waarde eq '' or  waarde eq null}">
                                                        <c:set var="waarde" value="&nbsp;" />
                                                    </c:if>
                                                    <td style="width: ${breedte};" valign="top">
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
                    Table.stripe(data_table, 'alternate');
                    Table.sort(data_table, {sorttype:Sort['numeric'], col:0});
                    
                    var currentObj;
                    var currentObjOldStyle;
                    function colorRow(obj) {
                        if(currentObj) {
                            currentObj.className = currentObjOldStyle;
                        }
                        currentObj = obj;
                        currentObjOldStyle = obj.className;
                        obj.className = obj.className + ' selected';
                    }
                </script>
            </c:when>
            <c:otherwise>
                Er is geen admin data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>