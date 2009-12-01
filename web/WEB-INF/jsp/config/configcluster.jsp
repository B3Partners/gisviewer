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
    <div class="infobalk_description">CLUSTER CONFIG</div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

<html:form action="/configCluster" focus="${focus}">
    <div style="display: none;">
        <html:hidden property="action"/>
        <html:hidden property="alt_action"/>
        <html:hidden property="clusterID"/>
    </div>
    <c:if test="${!empty allClusters}">
        <div style="float: left; clear: both; margin-left: 5px;">
            <div class="scroll">
                <table id="clustertable" class="tablesorter">
                    <thead>
                        <tr>
                            <th style="width: 30%;" id="sort_col1">Naam</th>
                            <th style="width: 70%;" id="sort_col2">Ouder</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ci" varStatus="status" items="${allClusters}">
                            <c:set var="id_selected" value='' />
                            <c:if test="${ci.id == mainid}"><c:set var="id_selected" value=' id="regel_selected"' /></c:if>
                            <c:url var="link" value="/configCluster.do?edit=submit&clusterID=${ci.id}"/>
                            <tr onclick="javascript: window.location.href='${link}';"${id_selected}>
                                <td style="width: 30%;"><c:out value="${ci.naam}"/></td>
                                <td style="width: 70%;"><c:out value="${ci.parent.naam}"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
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
                <tr>
                    <td>
                        Naam:
                    </td>
                    <td colspan="3">
                        <html:text property="naam" size="140"/>                   
                    </td>
                </tr>
                <tr>
                    <td>
                        Omschrijving:
                    </td>
                    <td colspan="3">
                        <html:text property="omschrijving"  size="140"/>                   
                    </td>
                </tr>
                <tr>
                    <td>
                        Metadata link:
                    </td>
                    <td colspan="3">
                        <html:text property="metadatalink"  size="140"/>
                    </td>
                </tr>

                <tr>
                    <td>
                        Volgorde:
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
                        Cluster voor ongeconfigureerde kaartlagen
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="hide_legend"/>
                    </td>
                    <td colspan="3">
                        Cluster onzichtbaar in de legenda
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="hide_tree"/>
                    </td>
                    <td colspan="3">
                        Cluster onzichtbaar in de boomstructuur
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="background_cluster"/>
                    </td>
                    <td colspan="3">
                        Cluster met achtergrond kaartlagen
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="extra_level"/>
                    </td>
                    <td colspan="3">
                        Cluster voor uitgebreide toegang
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="callable"/>
                    </td>
                    <td colspan="3">
                        Cluster kan aan/uit worden gevinkt. 
                    </td>
                </tr>
                <tr>
                    <td>
                        <html:checkbox property="default_visible"/>
                    </td>
                    <td colspan="3">
                        Cluster is default aangevinkt.(Deze optie is alleen mogelijk als het cluster ook aangevinkt kan worden)
                    </td>
                </tr>
              <tr>
                    <td>
                        Ouder Cluster:
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
    </div>
</html:form>
<script type="text/javascript">
    if(document.getElementById('regel_selected')) {
        $j("#regel_selected").addClass('selected');
        $j(".scroll").scrollTop(($j("#regel_selected").position().top - $j("#regel_selected").parent().position().top));
    }
    $j("#clustertable").tablesorter({
        widgets: ['zebra', 'hoverRows', 'fixedHeaders'],
        sortList: [[0,0]]
    });
</script>