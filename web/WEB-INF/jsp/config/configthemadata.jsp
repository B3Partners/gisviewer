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

<c:set var="form" value="${themaDataForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.themaDataID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="label"/>

<div class="infobalk">
    <div class="infobalk_description">DATA CONFIG</div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

    <html:form action="/configThemaData" focus="${focus}">
    <div style="display: none;">
        <html:hidden property="action"/>
        <html:hidden property="alt_action"/>
        <html:hidden property="themaDataID"/>
    </div>
    <div class="maintable" style="margin-bottom: 10px; margin-left: 15px; float: left; clear: left;">
        <table>
            <tr>
                <td style="color: #196299;">
                    Thema:
                </td>
                <td colspan="3">
                    <html:select property="themaID">
                        <c:forEach var="cuItem" items="${listThemas}">
                            <html:option value="${cuItem.id}">
                                <c:out value="${cuItem.naam}"/>
                            </html:option>
                        </c:forEach>
                    </html:select>&nbsp;
                    <html:submit property="change"  styleClass="knop">
                        <fmt:message key="button.change"/>
                    </html:submit>
                    <html:submit property="createAllThemaData" styleClass="knop">
                        Maak ontbrekende Themadata voor thema
                    </html:submit>
                    <%--<c:if test="${!save && !delete}">
                        <a href="#" class="datalink" onclick="javascript: document.getElementById('createAllThemaData').value='doe';submit()">Maak ontbrekende Themadata objecten voor thema</a>
                    </c:if>--%>
                </td>
            </tr>
        </table>
    </div>

    <c:if test="${!empty listThemaData}">
        <div style="float: left; clear: both; margin-left: 5px; height: 180px; overflow: hidden;">
                <table id="themadatatable" class="tablesorter">
                    <thead>
                        <tr>
                            <th style="width: 21%;" class="sorttype-int">Volgorde</th>
                            <th style="width: 23%;"><fmt:message key="configthemadata.label"/></th>
                            <th style="width: 23%;"><fmt:message key="configthemadata.${connectieType}.kolomnaam"/></th>
                            <th style="width: 33%;"><fmt:message key="configthemadata.basisregel"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ci" varStatus="status" items="${listThemaData}">
                            <c:set var="id_selected" value='' />
                            <c:if test="${ci.id == mainid}"><c:set var="id_selected" value='selected' /></c:if>
                            <c:url var="link" value="/configThemaData.do?edit=submit&themaDataID=${ci.id}"/>
                            <tr>
                                <td style="width: 21%;"><c:out value="${ci.dataorder}"/><input type="hidden" name="link" value="${link}" /><input type="hidden" name="selected" value="${id_selected}" /></td>
                                <td style="width: 23%;"><c:out value="${ci.label}"/></td>
                                <td style="width: 23%;"><c:out value="${ci.kolomnaam}"/></td>
                                <td style="width: 33%;">
                                    <c:if test="${ci.basisregel}">Ja</c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
        </div>
    </c:if>
    <div id="content_style" style="float: left; clear: left;">
        <div class="berichtenbalk" style="margin-top: 5px;">
            <html:messages id="error" message="true">
                <div class="messages">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
            </html:messages>
        </div>
        
        <div class="maintable" style="margin-top: 5px;">
            <table cellpadding="2" cellspacing="2" border="0">
                <tr><td><fmt:message key="configthemadata.label"/> <a href="#" onclick="return showHelpDialog('help_configthemadatalabel');">(?)</a><div id="help_configthemadatalabel" style="display: none;" title="<fmt:message key="configthemadata.label"/>"><p><fmt:message key="configthemadata.label.uitleg"/></p></div></td><td colspan="3"><html:text property="label" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.eenheid"/> <a href="#" onclick="return showHelpDialog('help_configthemadataeenheid');">(?)</a><div id="help_configthemadataeenheid" style="display: none;" title="<fmt:message key="configthemadata.eenheid"/>"><p><fmt:message key="configthemadata.eenheid.uitleg"/></p></div></td><td colspan="3"><html:text property="eenheid" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.omschrijving"/> <a href="#" onclick="return showHelpDialog('help_configthemadataomschrijving');">(?)</a><div id="help_configthemadataomschrijving" style="display: none;" title="<fmt:message key="configthemadata.omschrijving"/>"><p><fmt:message key="configthemadata.omschrijving.uitleg"/></p></div></td><td colspan="3"><html:text property="omschrijving" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.basisregel"/> <a href="#" onclick="return showHelpDialog('help_configthemadatabasisregel');">(?)</a><div id="help_configthemadatabasisregel" style="display: none;" title="<fmt:message key="configthemadata.basisregel"/>"><p><fmt:message key="configthemadata.basisregel.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="basisregel"/></td></tr>
                <!--
                <tr><td><fmt:message key="configthemadata.uitgebreid"/> <a href="#" onclick="return showHelpDialog('help_configthemadatauitgebreid');">(?)</a><div id="help_configthemadatauitgebreid" style="display: none;" title="<fmt:message key="configthemadata.uitgebreid"/>"><p><fmt:message key="configthemadata.uitgebreid.uitleg"/></p></div></td><td colspan="3"><html:checkbox property="uitgebreid"/></td></tr>
                -->
                <tr class="optionalConfigItems"><td><fmt:message key="configthemadata.voorbeelden"/> <a href="#" onclick="return showHelpDialog('help_configthemadatavoorbeelden');">(?)</a><div id="help_configthemadatavoorbeelden" style="display: none;" title="<fmt:message key="configthemadata.voorbeelden"/>"><p><fmt:message key="configthemadata.voorbeelden.uitleg"/></p></div></td><td colspan="3"><html:text property="voorbeelden" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.kolombreedte"/> <a href="#" onclick="return showHelpDialog('help_configthemadatakolombreedte');">(?)</a><div id="help_configthemadatakolombreedte" style="display: none;" title="<fmt:message key="configthemadata.kolombreedte"/>"><p><fmt:message key="configthemadata.kolombreedte.uitleg"/></p></div></td><td colspan="3"><html:text property="kolombreedte" size="140"/></td></tr>
                <!--
                <tr>
                    <td>
                        <fmt:message key="configthemadata.waardetype"/> <a href="#" onclick="return showHelpDialog('help_configthemadatawaardetype');">(?)</a><div id="help_configthemadatawaardetype" style="display: none;" title="<fmt:message key="configthemadata.waardetype"/>"><p><fmt:message key="configthemadata.waardetype.uitleg"/></p></div>
                    </td>
                    <td colspan="3">
                        <html:select property="waardeTypeID">
                            <c:forEach var="cuItem" items="${listWaardeTypen}">
                                <html:option value="${cuItem.id}">
                                    <c:out value="${cuItem.naam}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                -->
                <tr>
                    <td>
                        <fmt:message key="configthemadata.datatype"/> <a href="#" onclick="return showHelpDialog('help_configthemadatadatatype');">(?)</a><div id="help_configthemadatadatatype" style="display: none;" title="<fmt:message key="configthemadata.datatype"/>"><p><fmt:message key="configthemadata.datatype.uitleg"/></p></div>
                    </td>
                    <td colspan="3">
                        <html:select property="dataTypeID">
                            <c:forEach var="cuItem" items="${listDataTypen}">
                                <html:option value="${cuItem.id}">
                                    <c:out value="${cuItem.naam}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                <tr><td><fmt:message key="configthemadata.commando"/> <a href="#" onclick="return showHelpDialog('help_configthemadatacommando');">(?)</a><div id="help_configthemadatacommando" style="display: none;" title="<fmt:message key="configthemadata.commando"/>"><p><fmt:message key="configthemadata.commando.uitleg"/></p></div></td><td colspan="3"><html:text property="commando" size="140"/></td></tr>
                <c:choose>
                    <c:when test="${fn:length(listAdminTableColumns)>1}">
                        <tr>
                            <td><fmt:message key="configthemadata.${connectieType}.kolomnaam"/> <a href="#" onclick="return showHelpDialog('help_configthemadata${connectieType}kolomnaam');">(?)</a><div id="help_configthemadata${connectieType}kolomnaam" style="display: none;" title="<fmt:message key="configthemadata.${connectieType}.kolomnaam"/>"><p><fmt:message key="configthemadata.${connectieType}.kolomnaam.uitleg"/></p></div></td>
                            <td colspan="3">
                                <html:select property="kolomnaam">
                                    <html:option value=""/>
                                    <c:forEach var="cuItem" items="${listAdminTableColumns}">
                                        <html:option value="${cuItem}"/>
                                    </c:forEach>
                                </html:select>&nbsp;
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr><td><fmt:message key="configthemadata.kolomnaam"/> <a href="#" onclick="return showHelpDialog('help_configthemadatakolomnaam');">(?)</a><div id="help_configthemadatakolomnaam" style="display: none;" title="<fmt:message key="configthemadata.kolomnaam"/>"><p><fmt:message key="configthemadata.kolomnaam.uitleg"/></p></div></td><td colspan="3"><html:text property="kolomnaam" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                <tr><td><fmt:message key="configthemadata.dataorder"/> <a href="#" onclick="return showHelpDialog('help_configthemadatadataorder');">(?)</a><div id="help_configthemadatadataorder" style="display: none;" title="<fmt:message key="configthemadata.dataorder"/>"><p><fmt:message key="configthemadata.dataorder.uitleg"/></p></div></td><td colspan="3"><html:text property="dataorder" size="140"/></td></tr>
            </table>
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
                        <html:submit property="delete" accesskey="d" styleClass="knop" onclick="bCancel=true; return confirm('Weet u zeker dat u deze thema data wilt verwijderen?');" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.remove"/>
                        </html:submit>
                    </div>
                    <div class="knoppen">
                        <html:submit property="save" accesskey="s" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';" onclick="return confirm('Weet u zeker dat u deze thema data wilt opslaan?');">
                            <fmt:message key="button.save"/>
                        </html:submit>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
    </div> 
</html:form>
<iframe src="BLOCKED SCRIPT'&lt;html&gt;&lt;/html&gt;';" id="iframeBehindHelp" scrolling="no" frameborder="0" style="position:absolute; width:1px; height:0px; top:0px; left:0px; border:none; display:none; z-index:100"></iframe>
<script type="text/javascript">
    $j(document).ready(function() {
        tablesort(
            'themadatatable',
            '153',
            '900'
        );
        $j("#themadatatable > tbody > tr").each(function(){
            if($j(this).find("input[name=selected]").val() == "selected") {
                $j(this).addClass("ui-state-highlight");
                $j("#themadatatable").parent().parent().scrollTop(($j(this).position().top - $j(this).parent().position().top)-1);
            }
            $j(this).click(function() {
                window.location.href=$j(this).find("input[name=link]").val();
            });
        });
    });
</script>