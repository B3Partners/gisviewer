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

<c:set var="form" value="${clusterForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.clusterID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="naam"/>

<div class="infobalk">
    <div class="infobalk_description"><fmt:message key="configcluster.infobalk"/></div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

<html:form action="/configCluster" focus="${focus}">
    <div style="display: none;">
        <html:hidden property="action"/>
        <html:hidden property="alt_action"/>
        <html:hidden property="clusterID"/>
    </div>

    <c:if test="${!empty allClusters}">
        <div style="float: left; clear: both; margin-left: 5px; height: 180px; overflow: hidden;">
            <table id="clustertable" class="tablesorter">
                <thead>
                    <tr>
                        <th style="width: 30%;"><fmt:message key="configcluster.naam"/></th>
                        <th style="width: 70%;"><fmt:message key="configcluster.ouder"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ci" varStatus="status" items="${allClusters}">
                        <c:set var="id_selected" value='' />
                        <c:if test="${ci.id == mainid}"><c:set var="id_selected" value='selected' /></c:if>
                        <c:url var="link" value="/configCluster.do?edit=submit&clusterID=${ci.id}"/>
                        <tr>
                            <td><c:out value="${ci.naam}"/><input type="hidden" name="link" value="${link}" /><input type="hidden" name="selected" value="${id_selected}" /></td>
                            <td><c:out value="${ci.parent.naam}"/></td>
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

                <c:if test="${!empty form.map.clusterID}">
                    <tr>
                        <td>
                        <fmt:message key="config.label.copypastelink"/>
                        <a href="#" onclick="return showHelpDialog('help_copypastelink');">(?)</a>
                        <div id="help_copypastelink" style="display: none;" title="<fmt:message key="config.label.copypastelink"/>">
                            <p><fmt:message key="config.copypastelink.uitleg"/></p>
                        </div>
                        </td>
                        <td><html:link page="/viewer.do?clusterId=${form.map.clusterID}"><fmt:message key="config.linknaam.copypastelink"/></html:link></td>
                    </tr>
                </c:if>

                <tr>
                    <td>
                        <fmt:message key="configcluster.naam"/>:
                    </td>
                    <td colspan="3">
                        <html:text property="naam" size="140"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configcluster.omschrijving"/>:

                        <a href="#" onclick="return showHelpDialog('help_cluster_omschr');">(?)</a>
                        <div id="help_cluster_omschr" style="display: none;" title="<fmt:message key="configcluster.omschrijving"/>">
                            <p><fmt:message key="configcluster.omschrijving.uitleg"/></p>
                        </div>

                    </td>
                    <td colspan="3">
                        <html:text property="omschrijving"  size="140"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configcluster.metadatalink"/>:

                        <a href="#" onclick="return showHelpDialog('help_cluster_meta');">(?)</a>
                        <div id="help_cluster_meta" style="display: none;" title="<fmt:message key="configcluster.metadatalink"/>">
                            <p><fmt:message key="configcluster.metadatalink.uitleg"/></p>
                        </div>
                    </td>
                    <td colspan="3">
                        <html:text property="metadatalink"  size="140"/>
                    </td>
                </tr>

                <tr>
                    <td>
                        <fmt:message key="configcluster.volgorde"/>:

                        <a href="#" onclick="return showHelpDialog('help_cluster_volgorde');">(?)</a>
                        <div id="help_cluster_volgorde" style="display: none;" title="<fmt:message key="configcluster.volgorde"/>">
                            <p><fmt:message key="configcluster.volgorde.uitleg"/></p>
                        </div>
                    </td>
                    <td colspan="3">
                        <html:text property="belangnr" size="10"/>
                    </td>
                </tr>


                <tr>
                    <td>
                        <html:checkbox property="default_cluster"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.geenconfiglagen"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_noconfig');">(?)</a>
                        <div id="help_cluster_noconfig" style="display: none;" title="<fmt:message key="configcluster.geenconfiglagen"/>">
                            <p><fmt:message key="configcluster.geenconfiglagen.uitleg"/></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="hide_legend"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.onzichtbaarinlegenda"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_onzichtbaar');">(?)</a>
                        <div id="help_cluster_onzichtbaar" style="display: none;" title="<fmt:message key="configcluster.onzichtbaarinlegenda"/>">
                            <p><fmt:message key="configcluster.onzichtbaarinlegenda.uitleg"/></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="hide_tree"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.onzichtbaarinboom"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_onzichtbaarinboom');">(?)</a>
                        <div id="help_cluster_onzichtbaarinboom" style="display: none;" title="<fmt:message key="configcluster.onzichtbaarinboom"/>">
                            <p><fmt:message key="configcluster.onzichtbaarinboom.uitleg"/></p>
                        </div>

                        &nbsp;

                        <a href="#" onclick="return showHelpDialog('help_cluster_combi');">(info over gebruik samen met aan/uit optie ?)</a>
                        <div id="help_cluster_combi" style="display: none;" title="<fmt:message key="configcluster.onzichtbaar.combinatie"/>">
                            <p><fmt:message key="configcluster.onzichtbaar.combinatie.uitleg"/></p>
                        </div>

                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="background_cluster"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.achtergrondlagen"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_achtergrond');">(?)</a>
                        <div id="help_cluster_achtergrond" style="display: none;" title="<fmt:message key="configcluster.achtergrondlagen"/>">
                            <p><fmt:message key="configcluster.achtergrondlagen.uitleg"/></p>
                        </div>
                    </td>
                </tr>
                <!--
                <tr>
                    <td>
                        <html:checkbox property="extra_level"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.uitgebreidetoegang"/>
                    </td>
                </tr>
                -->
                <tr>
                    <td>
                        <html:checkbox property="callable"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.aanuitvink"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_aanuitvink');">(?)</a>
                        <div id="help_cluster_aanuitvink" style="display: none;" title="<fmt:message key="configcluster.aanuitvink"/>">
                            <p><fmt:message key="configcluster.aanuitvink.uitleg"/></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="default_visible"/>
                    </td>
                    <td colspan="3">
                        <fmt:message key="configcluster.defaultaangevinkt"/>

                        <a href="#" onclick="return showHelpDialog('help_cluster_defaultaan');">(?)</a>
                        <div id="help_cluster_defaultaan" style="display: none;" title="<fmt:message key="configcluster.defaultaangevinkt"/>">
                            <p><fmt:message key="configcluster.defaultaangevinkt.uitleg"/></p>
                        </div>
                    </td>
                </tr>
              <tr>
                    <td>
                        <fmt:message key="configcluster.oudercluster"/>:
                    </td>
                    <td colspan="3">
                        <html:select property="parentID">
                            <html:option value=""/>
                            <c:forEach var="cuItem" items="${allClusters}">
                                <c:if test="${mainid != cuItem.id}">
                                    <html:option value="${cuItem.id}">
                                        <c:out value="${cuItem.naam}"/>
                                    </html:option>
                                </c:if>
                            </c:forEach>
                        </html:select>&nbsp;

                        <a href="#" onclick="return showHelpDialog('help_cluster_parent');">(?)</a>
                        <div id="help_cluster_parent" style="display: none;" title="<fmt:message key="configcluster.oudercluster"/>">
                            <p><fmt:message key="configcluster.oudercluster.uitleg"/></p>
                        </div>
                    </td>
                </tr>
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
                        <html:submit property="delete" accesskey="d" styleClass="knop" onclick="bCancel=true; return confirm('Weet u zeker dat u dit cluster wilt verwijderen?');" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.remove"/>
                        </html:submit>
                    </div>
                    <div class="knoppen">
                        <html:submit property="save" accesskey="s" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';" onclick="return confirm('Weet u zeker dat u dit cluster wilt opslaan?');">
                            <fmt:message key="button.save"/>
                        </html:submit>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <a href="#" onclick="$j('#clustertable').setSelection('20', true);">Click!</a>
    </div>
</html:form>

<script type="text/javascript">
    $j(document).ready(function() {
        tablesort(
            'clustertable',
            '153',
            '900'
        );
        $j("#clustertable > tbody > tr").each(function(){
            if($j(this).find("input[name=selected]").val() == "selected") {
                $j(this).addClass("ui-state-highlight");
                $j("#clustertable").parent().parent().scrollTop(($j(this).position().top - $j(this).parent().position().top)-1);
            }
            $j(this).click(function() {
                window.location.href=$j(this).find("input[name=link]").val();
            });
        });
    });
</script>