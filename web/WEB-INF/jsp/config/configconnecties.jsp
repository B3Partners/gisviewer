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

<c:set var="form" value="${connectiesForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.id}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="naam"/>

<div class="infobalk">
    <div class="infobalk_description">CONNECTIE CONFIG</div>
    <div class="infobalk_actions"><tiles:insert name="loginblock"/></div>
</div>

<html:javascript formName="connectieForm" staticJavascript="false"/>
<html:form action="/configConnectie" onsubmit="return validateConnectieForm(this)" focus="${focus}">
    <div style="display: none;">
        <html:hidden property="action"/>
        <html:hidden property="alt_action"/>
        <html:hidden property="id"/>
    </div>
    <c:if test="${!empty allConnecties}">
        <div style="float: left; clear: both; margin-left: 5px; height: 180px; overflow: hidden;">
            <table id="connectietable" class="tablesorter">
                <thead>
                    <tr>
                        <th style="width: 30%;"><fmt:message key="configconnectie.naam"/></th>
                        <th style="width: 70%;"><fmt:message key="configconnectie.url"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ci" varStatus="status" items="${allConnecties}">
                        <c:set var="id_selected" value="" />
                        <c:if test="${ci.id == mainid}"><c:set var="id_selected" value='selected' /></c:if>
                        <c:url var="link" value="/configConnectie.do?edit=submit&id=${ci.id}"/>
                        <tr>
                            <td style="width: 30%;"><c:out value="${ci.naam}"/><input type="hidden" name="link" value="${link}" /><input type="hidden" name="selected" value="${id_selected}" /></td>
                            <td style="width: 70%;"><c:out value="${ci.connectie_url}"/></td>
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
                <tr>
                    <td>
                        <fmt:message key="configconnectie.naam"/>:
                    </td>
                    <td colspan="3">
                        <html:text property="naam" size="140"/>                   
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configconnectie.url"/>:

                        <a href="#" onclick="return showHelpDialog('help_configconnectie');">(?)</a>
                        <div id="help_configconnectie" style="display: none;" title="<fmt:message key="configconnectie.url"/>">
                            <p><fmt:message key="configconnectie.url.uitleg"/></p>
                        </div>
                    </td>
                    <td colspan="3">
                        <html:text property="url"  size="140"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configconnectie.gebruikersnaam"/>:
                    </td>
                    <td colspan="3">
                        <html:text property="gebruikersnaam"  size="140"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configconnectie.wachtwoord"/>:
                    </td>
                    <td colspan="3">
                        <html:password property="wachtwoord"  size="140"/>
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
                        <html:submit property="delete" accesskey="d" styleClass="knop" onclick="bCancel=true; return confirm('Weet u zeker dat u deze connectie wilt verwijderen?');" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.remove"/>
                        </html:submit>
                    </div> 
                    <div class="knoppen">
                        <html:submit property="save" accesskey="s" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';" onclick="return confirm('Weet u zeker dat u deze connectie wilt opslaan?');">
                            <fmt:message key="button.save"/>
                        </html:submit>
                    </div>
                </c:otherwise>
            </c:choose>
        </div> 
    </div>
</html:form>
<script type="text/javascript">
    $j(document).ready(function() {
        tablesort(
            'connectietable',
            '153',
            '900'
        );
        $j("#connectietable > tbody > tr").each(function(){
            if($j(this).find("input[name=selected]").val() == "selected") {
                $j(this).addClass("ui-state-highlight");
                $j("#connectietable").parent().parent().scrollTop(($j(this).position().top - $j(this).parent().position().top)-1);
            }
            $j(this).click(function() {
                window.location.href=$j(this).find("input[name=link]").val();
            });
        });
    });
</script>