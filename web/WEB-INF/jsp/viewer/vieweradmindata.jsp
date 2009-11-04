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
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/table.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>
<script type="text/javascript">
    var doClose=true;
    function toggleList(nr) {
        var obj = document.getElementById('fullTable' + nr);
        var plusmin = document.getElementById('plusMin' + nr);
        if(obj.style.display == 'block') {
            plusmin.innerHTML = '+';
            plusmin.style.marginLeft = '2px';
            plusmin.style.marginTop = '-2px';
            obj.style.display = 'none';
        } else {
            plusmin.innerHTML = '-';
            obj.style.display = 'block';
            plusmin.style.marginLeft = '4px';
            plusmin.style.marginTop = '-4px';
        }
    }
    var usePopup = true;
    var maxExtraInfo=100;
    var styleObjects = new Array();
</script>
<html:messages id="error" message="true">
    <div class="messages"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15"/>&nbsp;<c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
</html:messages>
<c:choose>
    <c:when test="${not empty thema_items_list and not empty regels_list}">
        <c:set value="0" var="nuOfTables" />
        <c:forEach var="thema_items" items="${thema_items_list}" varStatus="tStatus">

            <c:set var="themanaam" value="" />
            <c:forEach var="ThemaItem" items="${thema_items}" varStatus="topRowStatus">
                <c:if test="${ThemaItem.thema.naam != themanaam}">
                    <c:set var="themanaam" value="${ThemaItem.thema.naam}" />
                    <c:set var="themaId" value="${ThemaItem.thema.id}"/>
                    <c:set var="adminPk" value="${ThemaItem.thema.admin_pk}"/>
                </c:if>
            </c:forEach>

            <div class="topRow" style="margin-bottom: 0px; cursor: pointer; width: 100%; height: 20px; clear: both; font-weight: bold; background-repeat: repeat;" onclick="toggleList(${tStatus.count})" id="topRow${tStatus.count}">
                <div style="margin-left: 5px; margin-top: 3px;">
                    <div style="background-color: white; padding: 0px; margin-top: 1px; height: 10px; width: 10px; border: 1px solid black; margin-right: 5px; float: left;">
                        <c:set var="plusmin" value="+" />
                        <c:set var="margins" value="2" />
                        <c:if test="${tStatus.count == 1}">
                            <c:set var="plusmin" value="-" />
                            <c:set var="margins" value="4" />
                        </c:if>
                        <div id="plusMin${tStatus.count}" style="margin-left: ${margins}px; margin-top: -${margins}px;">
                            ${plusmin}
                        </div>
                    </div>
                    ${themanaam}
                    <a id="ahref_data2csv${tStatus.count}" style="color: #000000; margin-left: 10px; visibility: hidden;" href="#" onclick="data2csv${tStatus.count}.submit()"><html:image src="./images/icons/page_white_csv.png" alt="Exporteer naar csv" /></a> 
                    <a id="ahref_data2info${tStatus.count}" style="color: #000000; margin-left: 10px; visibility: hidden;" href="#" onclick="data2info${tStatus.count}.submit()"><html:image src="./images/icons/page_white_info.png" alt="Exporteer naar infobox" /></a>
                    <form action="services/Data2CSV" name="data2csv${tStatus.count}" id="data2csv${tStatus.count}" target="_blank" method="post">
                        <input name="themaId" type="hidden" value="${themaId}"/>
                        <input name="objectIds" type="hidden" value=""/>
                    </form>
                    <form action="viewerdata.do?aanvullendeinfo=t&pkFieldName=primaryKeys" name="data2info${tStatus.count}" id="data2info${tStatus.count}" target="_blank" method="post">
                        <input name="themaid" type="hidden" value="${themaId}"/>
                        <input name="primaryKeys" type="hidden" value=""/>
                        <input name="addKaart" type="hidden" value="j"/>
                    </form>
                </div>
            </div>

            <c:set var="display" value="none" />
            <c:if test="${tStatus.count == 1}">
                <c:set var="display" value="block" />
            </c:if>

            <div class="topRow" style="width: 100%; clear: both; margin-bottom: 5px; border-bottom: 1px solid #EAEEF2; background-repeat: repeat-x; display: ${display};" id="fullTable${tStatus.count}">
                <table id="admindata_table${tStatus.count}" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                    <thead>
                        <tr class="topRow" style="height: 20px;">
                            <th style="width: 50px;" class="table-sortable:numeric" id="volgnr_th" onclick="Table.sort(document.getElementById('data_table${tStatus.count}'), {sorttype:Sort['numeric'], col:0});">
                                Volgnr
                            </th>
                            <c:set var="totale_breedte" value="50" />
                            <c:set var="last_id" value="" />
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
                                <c:set var="kol_id" value=" id=\"header_kolom_item${topRowStatus.count}\"" />
                                <c:set var="noOfKolommen" value="${topRowStatus.count}" />
                                <th style="width: ${breedte}px;"${kol_id} class="table-sortable:default" onclick="Table.sort(document.getElementById('data_table${tStatus.count}'), {sorttype:Sort['default'], col:${topRowStatus.count}});">
                                    ${ThemaItem.label}
                                </th>
                                <c:if test="${ThemaItem.thema.naam != themanaam}">
                                    <c:set var="themanaam" value="${ThemaItem.thema.naam}" />
                                </c:if>
                            </c:forEach>
                        </tr>
                    </thead>
                </table>
                <c:set var="regels" value="${regels_list[tStatus.count-1]}"/>
                <div id="admin_data_content_div${tStatus.count}">
                    <table id="data_table${tStatus.count}" class="table-autosort table-stripeclass:admin_data_alternate_tr" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
                        <tbody>
                            <c:set var="refreshURL" value="" />
                            <c:set value="0" var="nuOfRegels" />
                            <c:forEach var="regel" items="${regels}" varStatus="counter">
                                <script>
                                    if (document.data2csv${tStatus.count}.objectIds.value.length > 0){
                                        document.data2csv${tStatus.count}.objectIds.value+=",";
                                    }
                                    document.data2csv${tStatus.count}.objectIds.value+="${regel.primairyKey}";
                                    if (${counter.count} < maxExtraInfo+1){
                                        if (document.data2info${tStatus.count}.primaryKeys.value.length > 0){
                                            document.data2info${tStatus.count}.primaryKeys.value+=",";
                                        }
                                        document.data2info${tStatus.count}.primaryKeys.value+="${regel.primairyKey}";
                                    }
                                </script>
                                <c:if test="${counter.count < 501}">
                                    <tr class="row" onclick="colorRow(this);">
                                        <td style="width: 50px;" valign="top">
                                            &nbsp;${counter.count}
                                        </td>
                                        <c:set var="totale_breedte_onder" value="50" />
                                    	<c:set value="0" var="nuOfColumns" />
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
                                                <c:choose>
                                                    <c:when test="${kolom.last}">
                                                        <c:set var="last_id" value=" class=\"lastThClass${tStatus.count}\" id=\"footer_last_item${counter.count}\"" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="last_id" value=" style=\"width: ${breedte}px;\"" />
                                                        <c:set var="totale_breedte_onder" value="${totale_breedte_onder + breedte}" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:set var="noOfRegels" value="${counter.count}" />
                                                <td${last_id} valign="top">
                                                    <c:choose>
                                                        <c:when test="${waarde eq '' or  waarde eq null}">
                                                            &nbsp;
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                                                		<c:set var="refreshURL" value="${waarde}" />
                                                                    <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm', 600, 500);" style="cursor: pointer;" />
                                                                </c:when>
                                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                                                		<c:set var="refreshURL" value="${waarde}" />
                                                                    <html:image src="./images/icons/world_link.png" onclick="popUp('${waarde}', 'externe_link', 600, 500);" style="cursor: pointer;" />
                                                                </c:when>
                                                                <c:when test="${thema_items[kolom.count - 1].dataType.id == 4}">
                                                                	<c:choose>
                                                                    <c:when test="${fn:length(fn:split(waarde, '###')) > 1}">
                                                                        <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="${fn:split(waarde, '###')[1]}">${fn:split(waarde, '###')[0]}</a>
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
                                            <c:set value="${kolom.count}" var="nuOfColumns" />
                                        </c:forEach>
                                    </tr>
                                    <c:set value="${counter.count}" var="nuOfRegels" />
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <c:set value="${tStatus.count}" var="nuOfTables" />
            <script>
                document.getElementById('ahref_data2csv${tStatus.count}').style.visibility="visible";
                document.getElementById('ahref_data2info${tStatus.count}').style.visibility="visible";
                var tempStyleObject = new Array(3);
                tempStyleObject[0] = ${totale_breedte_onder};
                tempStyleObject[1] = ${tStatus.count};
                styleObjects[styleObjects.length] = tempStyleObject;
            </script>
        </c:forEach>

        <!-- Wordt vervangen door stylesheet dmv Javascript. Wordt gebruikt om de laatste kolom uit te vullen -->
        <div id="styleReplace"></div>
        <script language="javascript" type="text/javascript">
            for(i = 1; i < (${nuOfTables} + 1); i++) {
                Table.stripe(document.getElementById('data_table' + i), 'admin_data_alternate_tr');
                Table.sort(document.getElementById('data_table' + i), {sorttype:Sort['numeric'], col:0});
            }

            if(opener && opener.usePopup) {
                for(i = 2; i < (${nuOfTables} + 1); i++) {
                    toggleList(i);
                }
            }

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

            fixAdmindataWidths = function() {
                var styletext = '';
                var totale_breedte_tabel = document.getElementById('topRow1').offsetWidth;
                for(i in styleObjects) {
                    styletext += '.lastThClass' + styleObjects[i][1] + ' { width: ' + (totale_breedte_tabel - styleObjects[i][0]) + 'px; } ';
                }
                var style = document.createElement('style');
                style.type = 'text/css';
                if (style.styleSheet) {
                    style.styleSheet.cssText = styletext;
                } else {
                    style.appendChild(document.createTextNode(styletext));
                }
                document.body.appendChild(style);
            }
            fixAdmindataWidths();
            attachOnresize(fixAdmindataWidths);
            
             <c:if test="${nuOfTables == 1 && nuOfRegels == 1 && nuOfColumns == 3 && (not empty refreshURL)}">
                // creeer popup als nog niet in popup
                if((parent && parent.useDivPopup) || (opener && opener.usePopup)) {
                    // Doe een window.location als er maar 1 cel en 1 kolom is en dit is een URL
                    window.location = '${refreshURL}';
                } else {
                    popUp('${refreshURL}', 'externe_link', 600, 500);
                }
            </c:if>
        </script>

        <!-- Wordt gebruikt om eventuele opmerkingen te bewerken -->
        <div id="opmerkingenedit" style="display: none; position: absolute; text-align: right;">
            <textarea id="opmText" cols="60" rows="3"></textarea><br />
            <input type="button" value="Ok" id="opmOkButton" />
            <input type="button" value="Cancel" id="opmCancelButton" />
        </div>
    </c:when>
    <c:otherwise>
        <div id="content_style">
            <table class="kolomtabel">
                <tr>
                    <td valign="top">
                        <div class="inleiding">
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
<script type="text/javascript">
    //writes the obj data from flamingo to a table
    function writeFeatureInfoData(obj){
        doClose=false;
        if (document.getElementById("content_style")!=undefined){
            document.getElementById("content_style").style.display="none";
        }
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
        document.getElementById('getFeatureInfo').innerHTML=tableData;
        //document.write(tableData);
    }
</script>
