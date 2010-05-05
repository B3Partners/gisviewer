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

<c:set var="form" value="${themaForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.themaID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="naam"/>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src='dwr/util.js'></script>
<script type="text/javascript" src='dwr/interface/JConfigListsUtil.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/configthema.js"/>"></script>

<div class="infobalk">
    <div class="infobalk_description">THEMA CONFIG</div>
    <div class="infobalk_actions"> <tiles:insert name="loginblock"/> </div>
</div>
<html:form action="/configThema" focus="${focus}">
    <div style="display: none;">
        <html:hidden property="action"/>
        <html:hidden property="alt_action"/>
        <html:hidden property="themaID"/>
        <html:hidden property="wms_url"/>
        <html:hidden property="wms_layers"/>
        <html:hidden property="wms_legendlayer"/>
        <html:hidden property="wms_querylayers"/>
        <html:hidden property="admin_pk_complex"/>
        <html:hidden property="spatial_pk_complex"/>
        <html:hidden property="admin_spatial_ref"/>
        <input type="hidden" name="refreshLists">
    </div>

    <c:if test="${!empty allThemas}">
        <div style="float: left; clear: both; margin-left: 5px; height: 180px; overflow: hidden;">
            <table id="themalisttable" class="tablesorter">
                <thead>
                    <tr>
                        <th style="width: 7%;" class="sorttype-int">Nr</th>
                        <th style="width: 35%;">Naam</th>
                        <th style="width: 10%;" class="sorttype-int">Code</th>
                        <th style="width: 19%;">Admin Table</th>
                        <th style="width: 19%;">Spatial Tabel</th>
                        <th style="width: 10%;">Data</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ci" varStatus="status" items="${allThemas}">
                        <c:url var="link" value="/configThema.do?edit=submit&themaID=${ci.id}" />
                        <c:set var="id_selected" value='' />
                        <c:if test="${ci.id == mainid}"><c:set var="id_selected" value='selected' /></c:if>
                        <tr>
                            <td style="width: 7%;"><c:out value="${ci.belangnr}"/>&nbsp;<input type="hidden" name="link" value="${link}" /><input type="hidden" name="selected" value="${id_selected}" /></td>
                            <td style="width: 35%;"><c:out value="${ci.naam}"/>&nbsp;</td>
                            <td style="width: 10%;"><c:out value="${ci.code}"/>&nbsp;</td>
                            <td style="width: 19%;"><c:out value="${ci.admin_tabel}"/>&nbsp;</td>
                            <td style="width: 19%;"><c:out value="${ci.spatial_tabel}"/>&nbsp;</td>
                            <td style="width: 10%;">
                                <c:if test="${ci.code!='3'}">
                                    &nbsp;<html:link page="/configThemaData.do?edit=submit&themaID=${ci.id}">TD</html:link>&nbsp;
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    <div id="content_style" style="float: left; clear: left;">
        <div class="berichtenbalk">
            <html:messages id="error" message="true">
                <div class="messages">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
            </html:messages>
        </div>

        <div id="config_tab_header_container">
            <div class="config_tab_header" id="tab-algemeen-header">Algemeen</div>
            <div class="config_tab_header" id="tab-kaart-header">Kaart</div>
            <div class="config_tab_header" id="tab-gegevensbron-header">Gegevensbron</div>
            <div class="config_tab_header" id="tab-themaopties-header">Opties</div>
            <div class="config_tab_header" id="tab-geavanceerd-header">Geavanceerd</div>
        </div>

        <div class="maintable">

            <div class="config_tab" id="tab-algemeen-content">
                <table cellpadding="2" cellspacing="2" border="0">

                    <c:if test="${!empty form.map.themaID}">
                    <tr>
                        <td>
                        <fmt:message key="config.label.copypastelink"/>
                        <a href="#" onclick="return showHelpDialog('help_copypastelink');">(?)</a>
                        <div id="help_copypastelink" style="display: none;" title="<fmt:message key="config.label.copypastelink"/>">
                            <p><fmt:message key="config.copypastelink.uitleg"/></p>
                        </div>
                        </td>
                        <td><html:link page="/viewer.do?id=${form.map.themaID}"><fmt:message key="config.linknaam.copypastelink"/></html:link></td>
                    </tr>
                    </c:if>

                    <tr><td>
                            <fmt:message key="configthema.naam"/> <a href="#" onclick="return showHelpDialog('help_configthemanaam');">(?)</a><div id="help_configthemanaam" style="display: none;" title="<fmt:message key="configthema.naam"/>"><p><fmt:message key="configthema.naam.uitleg"/></p></div>
                    </td><td colspan="3"><html:text property="naam" size="140"/></td></tr>
                    <tr><td><fmt:message key="configthema.metadatalink"/> <a href="#" onclick="return showHelpDialog('help_configthemametadatalink');">(?)</a><div id="help_configthemametadatalink" style="display: none;" title="<fmt:message key="configthema.metadatalink"/>"><p><fmt:message key="configthema.metadatalink.uitleg"/></p></div></td><td colspan="3"><html:text property="metadatalink" size="140"/></td></tr>
                    <tr class="optionalConfigItems">
                        <td>
                            <fmt:message key="configthema.code"/> <a href="#" onclick="return showHelpDialog('help_configthemacode');">(?)</a><div id="help_configthemacode" style="display: none;" title="<fmt:message key="configthema.code"/>"><p><fmt:message key="configthema.code.uitleg"/></p></div>
                        </td>
                        <td colspan="3">
                            <html:select property="themaCode" styleClass="configSelect">
                                <html:option value="1">Oorspronkelijk Thema (1)</html:option>
                                <html:option value="2">Nieuw Thema (2)</html:option>
                                <html:option value="3">Thema niet meer in gebruik (3)</html:option>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr><td><fmt:message key="configthema.belangnr"/> <a href="#" onclick="return showHelpDialog('help_configthemabelangnr');">(?)</a><div id="help_configthemabelangnr" style="display: none;" title="<fmt:message key="configthema.belangnr"/>"><p><fmt:message key="configthema.belangnr.uitleg"/></p></div></td><td colspan="3"><html:text property="belangnr" size="140"/></td></tr>
                    <tr>
                        <td>
                            <fmt:message key="configthema.cluser"/> <a href="#" onclick="return showHelpDialog('help_configthemacluser');">(?)</a><div id="help_configthemacluser" style="display: none;" title="<fmt:message key="configthema.cluser"/>"><p><fmt:message key="configthema.cluser.uitleg"/></p></div>
                        </td>
                        <td colspan="3">
                            <html:select property="clusterID" styleClass="configSelect">
                                <c:forEach var="cuItem" items="${allClusters}">
                                    <html:option value="${cuItem.id}">
                                        <c:out value="${cuItem.naam}"/>
                                    </html:option>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr><td><fmt:message key="configthema.opmerkingen"/> <a href="#" onclick="return showHelpDialog('help_configthemaopmerkingen');">(?)</a><div id="help_configthemaopmerkingen" style="display: none;" title="<fmt:message key="configthema.opmerkingen"/>"><p><fmt:message key="configthema.opmerkingen.uitleg"/></p></div></td><td colspan="3"><html:text property="opmerkingen" size="140"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-themaopties-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr><td><fmt:message key="configthema.locatiethema"/> <a href="#" onclick="return showHelpDialog('help_configthemalocatiethema');">(?)</a><div id="help_configthemalocatiethema" style="display: none;" title="<fmt:message key="configthema.locatiethema"/>"><p><fmt:message key="configthema.locatiethema.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="locatie_thema"/></td></tr>
                    <tr><td><fmt:message key="configthema.analysethema"/> <a href="#" onclick="return showHelpDialog('help_configthemaanalysethema');">(?)</a><div id="help_configthemaanalysethema" style="display: none;" title="<fmt:message key="configthema.analysethema"/>"><p><fmt:message key="configthema.analysethema.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="analyse_thema"/></td></tr>
                    <tr><td><fmt:message key="configthema.defaultvisible"/> <a href="#" onclick="return showHelpDialog('help_configthemadefaultvisible');">(?)</a><div id="help_configthemadefaultvisible" style="display: none;" title="<fmt:message key="configthema.defaultvisible"/>"><p><fmt:message key="configthema.defaultvisible.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="visible"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-gegevensbron-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td>
                            <fmt:message key="configthema.connectie"/> <a href="#" onclick="return showHelpDialog('help_configthemaconnectie');">(?)</a><div id="help_configthemaconnectie" style="display: none;" title="<fmt:message key="configthema.connectie"/>"><p><fmt:message key="configthema.connectie.uitleg"/></p></div>
                        </td>
                        <td colspan="3">
                            <html:select property="connectie" onchange="refreshFeatureList(this);" styleId='connectie_select' styleClass="configSelect">
                                <html:option value="-1">Geen Connectie</html:option>
                                <html:option value="0">Kaartenbalie Wfs</html:option>
                                <c:forEach var="cuItem" items="${listConnecties}">
                                    <html:option value="${cuItem.id}">
                                        <c:out value="${cuItem.naam}"/>
                                    </html:option>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <c:set var="connectieType" value="wfs"/>
                    <c:if test="${form.map.connectie!=null}">
                        <c:forEach var="i" items="${listConnecties}">
                            <c:if test="${i.id==form.map.connectie && i.type=='jdbc'}">
                                <c:set var="connectieType" value="jdbc"/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr><td><fmt:message key="configthema.${connectieType}.admintabelopmerkingen"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}admintabelopmerkingen');">(?)</a><div id="help_configthema${connectieType}admintabelopmerkingen" style="display: none;" title="<fmt:message key="configthema.${connectieType}.admintabelopmerkingen"/>"><fmt:message key="configthema.${connectieType}.admintabelopmerkingen.uitleg"/></div></td><td colspan="3"><html:text property="admin_tabel_opmerkingen" size="140"/></td></tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.admintabel"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}admintabel');">(?)</a><div id="help_configthema${connectieType}admintabel" style="display: none;" title="<fmt:message key="configthema.${connectieType}.admintabel"/>"><fmt:message key="configthema.${connectieType}.admintabel.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="admin_tabel" onchange="refreshAdminAttributeList(this);" styleId="admin_tabel_select" styleClass="configSelect">
                                <html:option value=""/>
                                <c:forEach var="cuItem" items="${listTables}">
                                    <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.adminpk"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}adminpk');">(?)</a><div id="help_configthema${connectieType}adminpk" style="display: none;" title="<fmt:message key="configthema.${connectieType}.adminpk"/>"><fmt:message key="configthema.${connectieType}.adminpk.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="admin_pk" onchange="createAdminQ();" styleId="admin_pk_select" styleClass="configSelect">
                                <html:option value=""/>
                                <c:choose>
                                    <c:when test="${fn:length(listAdminTableColumns)>1}">
                                        <c:forEach var="cuItem" items="${listAdminTableColumns}">
                                            <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <html:option value="Kies eerst tabel of feature..." />
                                    </c:otherwise>
                                </c:choose>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr><td><span id="adminqueryrow"><fmt:message key="configthema.${connectieType}.adminquery"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}adminquery');">(?)</a></span><div id="help_configthema${connectieType}adminquery" style="display: none;" title="<fmt:message key="configthema.${connectieType}.adminquery"/>"><fmt:message key="configthema.${connectieType}.adminquery.uitleg"/></div></td><td colspan="3"><html:text property="admin_query" size="140" styleId="admin_query_text"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-geavanceerd-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr><td><fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}spatialtabelopmerkingen');">(?)</a><div id="help_configthema${connectieType}spatialtabelopmerkingen" style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen"/>"><fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen.uitleg"/></div></td><td colspan="3"><html:text property="spatial_tabel_opmerkingen" size="140"/></td></tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.spatialtabel"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}spatialtabel');">(?)</a><div id="help_configthema${connectieType}spatialtabel" style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialtabel"/>"><fmt:message key="configthema.${connectieType}.spatialtabel.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="spatial_tabel" onchange="refreshSpatialAttributeList(this);" styleId="spatial_tabel_select" styleClass="configSelect">
                                <html:option value=""/>
                                <c:forEach var="cuItem" items="${listTables}">
                                    <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.spatialpk"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}spatialpk');">(?)</a><div id="help_configthema${connectieType}spatialpk" style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialpk"/>"><fmt:message key="configthema.${connectieType}.spatialpk.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="spatial_pk" styleId="spatial_pk_select" styleClass="configSelect">
                                <html:option value=""/>
                                <c:choose>
                                    <c:when test="${fn:length(listSpatialTableColumns)>1}">
                                        <c:forEach var="cuItem" items="${listSpatialTableColumns}">
                                            <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <html:option value="Kies eerst een spatialtabel"/>
                                    </c:otherwise>
                                </c:choose>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.spatialadminref"/> <a href="#" onclick="return showHelpDialog('help_configthema${connectieType}spatialadminref');">(?)</a><div id="help_configthema${connectieType}spatialadminref" style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialadminref"/>"><fmt:message key="configthema.${connectieType}.spatialadminref.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="spatial_admin_ref" styleId="spatial_adminref_select" styleClass="configSelect">
                                <html:option value=""/>
                                <c:choose>
                                    <c:when test="${fn:length(listSpatialTableColumns)>1}">
                                        <c:forEach var="cuItem" items="${listSpatialTableColumns}">
                                            <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <html:option value="Kies eerst een spatialtabel"/>
                                    </c:otherwise>
                                </c:choose>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="configthema.viewgeomtype"/> <a href="#" onclick="return showHelpDialog('help_configthemaviewgeomtype');">(?)</a><div id="help_configthemaviewgeomtype" style="display: none;" title="<fmt:message key="configthema.viewgeomtype"/>"><p><fmt:message key="configthema.viewgeomtype.uitleg"/></p></div></td>
                        <td colspan="3">
                            <html:select property="view_geomtype" styleClass="configSelect">
                                <html:option value=""/>
                                <c:forEach var="cuItem" items="${listValidGeoms}">
                                    <html:option value="${cuItem}"/>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                </table>
            </div>

            <div class="config_tab" id="tab-kaart-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <c:choose>
                        <c:when test="${fn:length(listLayers)>1}">
                            <tr>
                                <td><fmt:message key="configthema.wmslayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmslayers');">(?)</a><div id="help_configthemawmslayers" style="display: none;" title="<fmt:message key="configthema.wmslayers"/>"><p><fmt:message key="configthema.wmslayers.uitleg"/></p></div></td>
                                <td colspan="3">
                                    <html:select property="wms_layers_real" styleClass="configSelect">
                                        <html:option value=""/>
                                        <c:forEach var="cuItem" items="${listLayers}">
                                            <html:option value="${cuItem.name}">${cuItem}</html:option>
                                        </c:forEach>
                                    </html:select>&nbsp;
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr><td><fmt:message key="configthema.wmslayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmslayers');">(?)</a><div id="help_configthemawmslayers" style="display: none;" title="<fmt:message key="configthema.wmslayers"/>"><p><fmt:message key="configthema.wmslayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_layers_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <tr><td><fmt:message key="configthema.sldattribuut"/> <a href="#" onclick="return showHelpDialog('help_configthemasldattribuut');">(?)</a><div id="help_configthemasldattribuut" style="display: none;" title="<fmt:message key="configthema.sldattribuut"/>"><p><fmt:message key="configthema.sldattribuut.uitleg"/></p></div></td><td colspan="3"><html:text property="sldattribuut" size="50"/></td></tr>
                    <c:choose>
                        <c:when test="${fn:length(listLayers)>1}">
                            <tr>
                                <td><fmt:message key="configthema.wmsquerylayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmsquerylayers');">(?)</a><div id="help_configthemawmsquerylayers" style="display: none;" title="<fmt:message key="configthema.wmsquerylayers"/>"><p><fmt:message key="configthema.wmsquerylayers.uitleg"/></p></div></td>
                                <td colspan="3">
                                    <c:set var="queryDisabled" value="true"/>
                                    <c:if test="${fn:length(form.map.admin_tabel) <= 0}">
                                        <c:set var="queryDisabled" value="false"/>
                                    </c:if>
                                    <html:select property="wms_querylayers_real" styleId="wms_querylayers_real" disabled="${queryDisabled}" styleClass="configSelect">
                                        <html:option value=""/>
                                        <c:forEach var="cuItem" items="${listLayers}">
                                            <html:option value="${cuItem.name}">${cuItem}</html:option>
                                        </c:forEach>
                                    </html:select>&nbsp;
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr><td><fmt:message key="configthema.wmsquerylayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmsquerylayers');">(?)</a><div id="help_configthemawmsquerylayers" style="display: none;" title="<fmt:message key="configthema.wmsquerylayers"/>"><p><fmt:message key="configthema.wmsquerylayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_querylayers_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${fn:length(listLegendLayers)>1}">
                            <tr>
                                <td><fmt:message key="configthema.wmslegendlayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmslegendlayers');">(?)</a><div id="help_configthemawmslegendlayers" style="display: none;" title="<fmt:message key="configthema.wmslegendlayers"/>"><p><fmt:message key="configthema.wmslegendlayers.uitleg"/></p></div></td>
                                <td colspan="3">
                                    <html:select property="wms_legendlayer_real" styleClass="configSelect">
                                        <html:option value=""/>
                                        <c:forEach var="cuItem" items="${listLegendLayers}">
                                            <html:option value="${cuItem.name}">${cuItem}</html:option>
                                        </c:forEach>
                                    </html:select>&nbsp;
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr><td><fmt:message key="configthema.wmslegendlayers"/> <a href="#" onclick="return showHelpDialog('help_configthemawmslegendlayers');">(?)</a><div id="help_configthemawmslegendlayers" style="display: none;" title="<fmt:message key="configthema.wmslegendlayers"/>"><p><fmt:message key="configthema.wmslegendlayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_legendlayer_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
					
					<tr>
                        <td><fmt:message key="configthema.maptip"/> <a href="#" onclick="return showHelpDialog('help_configthemamaptip');">(?)</a><div id="help_configthemamaptip" style="display: none;" title="<fmt:message key="configthema.maptip"/>"><p><fmt:message key="configthema.maptip.uitleg"/></p></div></td>
                        <td colspan="3">
                            <html:text property="thema_maptip" size="140"/>
                        </td>
                    </tr

                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr class="optionalConfigItems"><td><fmt:message key="configthema.updatefreqindagen"/> <a href="#" onclick="return showHelpDialog('help_configthemaupdatefreqindagen');">(?)</a><div id="help_configthemaupdatefreqindagen" style="display: none;" title="<fmt:message key="configthema.updatefreqindagen"/>"><p><fmt:message key="configthema.updatefreqindagen.uitleg"/></p></div></td><td colspan="3"><html:text property="update_frequentie_in_dagen" size="140"/></td></tr>

                    <%-- <tr>
                    <td><fmt:message key="configthema.themadata"/>(Verwijderen van Themadata objecten kan alleen via het scherm 'Themadata')</td>
                    <td>

                        <c:forEach var="cuItem" items="${listAdminTableColumns}">
                            <c:set var="tdExists" value="false"/>
                            <c:forEach var="tdItem" items="${form.map.themadataobjecten}">
                                <c:if test="${cuItem == tdItem}">
                                    <c:set var="tdExists" value="true"/>
                                </c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${tdExists}">
                                    <html:multibox property="themadataobjecten" value="${cuItem}"/><c:out  value="${cuItem}"/><br/>
                                </c:when>
                                <c:otherwise>
                                    <html:multibox property="themadataobjecten"  value="${cuItem}"/><c:out  value="${cuItem}"/><br/>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </td>
                </tr>--%>
                <%--
            <tr><td>analyse_thema</td><td colspan="3"><html:checkbox property="analyse_thema"/></td></tr>
            <tr><td>admin_spatial_ref</td><td colspan="3"><html:text property="admin_spatial_ref" size="140"/></td></tr>
            <tr><td>admin_pk_complex</td><td colspan="3"><html:checkbox property="admin_pk_complex"/></td></tr>
            <tr><td>spatial_pk_complex</td><td colspan="3"><html:checkbox property="spatial_pk_complex"/></td></tr>
            <tr><td>wms_url</td><td colspan="3"><html:text property="wms_url" size="140"/></td></tr>
            <tr><td>wms_layers</td><td colspan="3"><html:text property="wms_layers" size="140"/></td></tr>
            <tr><td>wms_legendlayer</td><td colspan="3"><html:text property="wms_legendlayer" size="140"/></td></tr>
            <tr><td>wms_querylayers</td><td colspan="3"><html:text property="wms_querylayers" size="140"/></td></tr>
                    --%>
                    
                </table>
            </div>
        </div>

        <div class="knoppenbalk">
            <c:choose>
                <c:when test="${save || delete}">
                    <div class="knoppen">
                        <html:submit property="confirm" accesskey="o" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.ok"/>
                        </html:submit>
                    </div>
                    <div class="knoppen">
                        <html:cancel accesskey="c" styleClass="knop" onclick="bCancel=true" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.cancel"/>
                        </html:cancel>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="knoppen">
                        <html:submit property="create" accesskey="n" styleClass="knop" onclick="bCancel=true" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.new"/>
                        </html:submit>
                    </div>
                    <div class="knoppen">
                        <html:submit property="delete" accesskey="d" styleClass="knop" onclick="bCancel=true; return confirm('Weet u zeker dat u dit thema wilt verwijderen?');" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.remove"/>
                        </html:submit>
                    </div>
                    <div class="knoppen">
                        <html:submit property="save" accesskey="s" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';" onclick="return confirm('Weet u zeker dat u dit thema wilt opslaan?');">
                            <fmt:message key="button.save"/>
                        </html:submit>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script type="text/javascript">
            // Tabs
            createTabs('config_tab_header_container');
            firstTab('tab-algemeen-header');
        </script>
    </div>
</html:form>

<script type="text/javascript">
    $j(document).ready(function() {
        tablesort(
            'themalisttable',
            '153',
            '900'
        );
        $j("#themalisttable > tbody > tr").each(function(){
            if($j(this).find("input[name=selected]").val() == "selected") {
                $j(this).addClass("ui-state-highlight");
                $j("#themalisttable").parent().parent().scrollTop(($j(this).position().top - $j(this).parent().position().top)-1);
            }
            $j(this).click(function() {
                window.location.href=$j(this).find("input[name=link]").val();
            });
        });
    });
    var pageConnectionType="${connectieType}";
    var currentConnectionType="${connectieType}";
    var connectionTypes=new Array();
    connectionTypes["-1"]="";
    connectionTypes["0"]="wfs";
    <c:forEach var="cuItem" items="${listConnecties}">
        connectionTypes["${cuItem.id}"]="${cuItem.type}";
    </c:forEach>
    showHideJDBC();
</script>
