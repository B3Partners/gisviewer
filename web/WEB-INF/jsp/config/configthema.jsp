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
        <div style="float: left; clear: both; margin-left: 5px;">
            <div class="scroll">
                <table id="themalisttable" class="tablesorter">
                    <thead>
                        <tr>
                            <th style="width: 7%;" id="sort_col1">Nr</th>
                            <th style="width: 35%;" id="sort_col2">Naam</th>
                            <th style="width: 10%;" id="sort_col3">Code</th>
                            <th style="width: 19%;" id="sort_col4">Admin Table</th>
                            <th style="width: 19%;" id="sort_col5">Spatial Tabel</th>
                            <th style="width: 10%;" id="sort_col6">Data</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ci" varStatus="status" items="${allThemas}">
                            <c:url var="link" value="/configThema.do?edit=submit&themaID=${ci.id}" />
                            <c:set var="id_selected" value='' />
                            <c:if test="${ci.id == mainid}"><c:set var="id_selected" value=' id="regel_selected"' /></c:if>
                            <tr onclick="javascript: window.location.href='${link}';"${id_selected}>
                                <td style="width: 7%;"><c:out value="${ci.belangnr}"/>&nbsp;</td>
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
        </div>
    </c:if>
    <div id="content_style" style="float: left; clear: left;">
        <div class="berichtenbalk">
            <html:messages id="error" message="true">
                <div class="messages">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
            </html:messages>
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

        <div id="config_tab_header_container">
            <div class="config_tab_header" id="tab-algemeen-header">Algemeen</div>
            <div class="config_tab_header" id="tab-themaopties-header">Thema opties</div>
            <div class="config_tab_header" id="tab-gegevensbron-header">Gegevensbron</div>
            <div class="config_tab_header" id="tab-kaart-header">Kaart</div>
            <div class="config_tab_header" id="tab-geavanceerd-header">Geavanceerd</div>
        </div>

        <div class="maintable">

            <div class="config_tab" id="tab-algemeen-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr><td>
                            <fmt:message key="configthema.naam"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.naam"/>"><p><fmt:message key="configthema.naam.uitleg"/></p></div>
                    </td><td colspan="3"><html:text property="naam" size="140"/></td></tr>
                    <tr><td><fmt:message key="configthema.metadatalink"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.metadatalink"/>"><p><fmt:message key="configthema.metadatalink.uitleg"/></p></div></td><td colspan="3"><html:text property="metadatalink" size="140"/></td></tr>
                    <tr class="optionalConfigItems">
                        <td>
                            <fmt:message key="configthema.code"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.code"/>"><p><fmt:message key="configthema.code.uitleg"/></p></div>
                        </td>
                        <td colspan="3">
                            <html:select property="themaCode" styleClass="configSelect">
                                <html:option value="1">Oorspronkelijk Thema (1)</html:option>
                                <html:option value="2">Nieuw Thema (2)</html:option>
                                <html:option value="3">Thema niet meer in gebruik (3)</html:option>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr><td><fmt:message key="configthema.belangnr"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.belangnr"/>"><p><fmt:message key="configthema.belangnr.uitleg"/></p></div></td><td colspan="3"><html:text property="belangnr" size="140"/></td></tr>
                    <tr>
                        <td>
                            <fmt:message key="configthema.cluser"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.cluser"/>"><p><fmt:message key="configthema.cluser.uitleg"/></p></div>
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
                    <tr><td><fmt:message key="configthema.opmerkingen"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.opmerkingen"/>"><p><fmt:message key="configthema.opmerkingen.uitleg"/></p></div></td><td colspan="3"><html:text property="opmerkingen" size="140"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-themaopties-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr><td><fmt:message key="configthema.locatiethema"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.locatiethema"/>"><p><fmt:message key="configthema.locatiethema.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="locatie_thema"/></td></tr>
                    <tr><td><fmt:message key="configthema.analysethema"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.analysethema"/>"><p><fmt:message key="configthema.analysethema.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="analyse_thema"/></td></tr>
                    <tr><td><fmt:message key="configthema.defaultvisible"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.defaultvisible"/>"><p><fmt:message key="configthema.defaultvisible.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="visible"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-gegevensbron-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr>
                        <td>
                            <fmt:message key="configthema.connectie"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.connectie"/>"><p><fmt:message key="configthema.connectie.uitleg"/></p></div>
                        </td>
                        <td colspan="3">
                            <html:select property="connectie" onchange="refreshFeatureList(this);" styleId='connectie_select' styleClass="configSelect">
                                <html:option value="kb">Kaartenbalie Wfs</html:option>
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
                    <tr><td><fmt:message key="configthema.${connectieType}.admintabelopmerkingen"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.admintabelopmerkingen"/>"><fmt:message key="configthema.${connectieType}.admintabelopmerkingen.uitleg"/></div></td><td colspan="3"><html:text property="admin_tabel_opmerkingen" size="140"/></td></tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.admintabel"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.admintabel"/>"><fmt:message key="configthema.${connectieType}.admintabel.uitleg"/></div></td>
                        <td colspan="3">
                            <html:select property="admin_tabel" onchange="refreshAdminAttributeList(this);" styleId="admin_tabel_select" styleClass="configSelect">
                                <c:forEach var="cuItem" items="${listTables}">
                                    <html:option value="${cuItem[0]}">${cuItem[1]}</html:option>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.adminpk"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.adminpk"/>"><fmt:message key="configthema.${connectieType}.adminpk.uitleg"/></div></td>
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
                    <tr><td><span id="adminqueryrow"><fmt:message key="configthema.${connectieType}.adminquery"/> <a href="#" onclick="$j(this).parent().next().dialog();">(?)</a></span><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.adminquery"/>"><fmt:message key="configthema.${connectieType}.adminquery.uitleg"/></div></td><td colspan="3"><html:text property="admin_query" size="140" styleId="admin_query_text"/></td></tr>
                </table>
            </div>

            <div class="config_tab" id="tab-geavanceerd-content">
                <table cellpadding="2" cellspacing="2" border="0">
                    <tr><td><fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen"/>"><fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen.uitleg"/></div></td><td colspan="3"><html:text property="spatial_tabel_opmerkingen" size="140"/></td></tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.spatialtabel"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialtabel"/>"><fmt:message key="configthema.${connectieType}.spatialtabel.uitleg"/></div></td>
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
                        <td><fmt:message key="configthema.${connectieType}.spatialpk"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialpk"/>"><fmt:message key="configthema.${connectieType}.spatialpk.uitleg"/></div></td>
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
                        <td><fmt:message key="configthema.${connectieType}.spatialadminref"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.${connectieType}.spatialadminref"/>"><fmt:message key="configthema.${connectieType}.spatialadminref.uitleg"/></div></td>
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
                        <td><fmt:message key="configthema.viewgeomtype"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.viewgeomtype"/>"><p><fmt:message key="configthema.viewgeomtype.uitleg"/></p></div></td>
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
                                <td><fmt:message key="configthema.wmslayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmslayers"/>"><p><fmt:message key="configthema.wmslayers.uitleg"/></p></div></td>
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
                            <tr><td><fmt:message key="configthema.wmslayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmslayers"/>"><p><fmt:message key="configthema.wmslayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_layers_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <tr><td><fmt:message key="configthema.sldattribuut"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.sldattribuut"/>"><p><fmt:message key="configthema.sldattribuut.uitleg"/></p></div></td><td colspan="3"><html:text property="sldattribuut" size="50"/></td></tr>
                    <c:choose>
                        <c:when test="${fn:length(listLayers)>1}">
                            <tr>
                                <td><fmt:message key="configthema.wmsquerylayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmsquerylayers"/>"><p><fmt:message key="configthema.wmsquerylayers.uitleg"/></p></div></td>
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
                            <tr><td><fmt:message key="configthema.wmsquerylayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmsquerylayers"/>"><p><fmt:message key="configthema.wmsquerylayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_querylayers_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${fn:length(listLegendLayers)>1}">
                            <tr>
                                <td><fmt:message key="configthema.wmslegendlayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmslegendlayers"/>"><p><fmt:message key="configthema.wmslegendlayers.uitleg"/></p></div></td>
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
                            <tr><td><fmt:message key="configthema.wmslegendlayers"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.wmslegendlayers"/>"><p><fmt:message key="configthema.wmslegendlayers.uitleg"/></p></div></td><td colspan="3"><html:text property="wms_legendlayer_real" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
					
					<tr>
                        <td><fmt:message key="configthema.maptip"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.maptip"/>"><p><fmt:message key="configthema.maptip.uitleg"/></p></div></td>
                        <td colspan="3">
                            <html:text property="thema_maptip" size="140"/>
                        </td>
                    </tr

                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr class="optionalConfigItems"><td><fmt:message key="configthema.updatefreqindagen"/> <a href="#" onclick="$j(this).next().dialog();">(?)</a><div style="display: none;" title="<fmt:message key="configthema.updatefreqindagen"/>"><p><fmt:message key="configthema.updatefreqindagen.uitleg"/></p></div></td><td colspan="3"><html:text property="update_frequentie_in_dagen" size="140"/></td></tr>

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
        <script type="text/javascript">
            // Tabs
            createTabs('config_tab_header_container');
            firstTab('tab-algemeen-header');
        </script>
    </div>
</html:form>

<script type="text/javascript">
    if(document.getElementById('regel_selected')) {
        $j("#regel_selected").addClass('selected');
        $j(".scroll").scrollTop(($j("#regel_selected").position().top - $j("#regel_selected").parent().position().top));
    }
    $j("#themalisttable").tablesorter({
        widgets: ['zebra', 'hoverRows', 'fixedHeaders'],
        sortList: [[0,0]]
    });
    var pageConnectionType="${connectieType}";
    var currentConnectionType="${connectieType}";
    var connectionTypes=new Array();
    connectionTypes["kb"]="wfs";
    <c:forEach var="cuItem" items="${listConnecties}">
        connectionTypes["${cuItem.id}"]="${cuItem.type}";
    </c:forEach>
    showHideJDBC();
</script>
