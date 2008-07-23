<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${themaDataForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.themaDataID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="label"/>

<div class="onderbalk">DATA CONFIG<span><tiles:insert name="loginblock"/></span></div>

<script type="text/javascript">
    function showHelp(obj) {
        var helpDiv = obj.nextSibling;
        showHideDiv(helpDiv);
        return false;
    }
    
    function showHideDiv(obj) {
        if(obj.style.display != 'block') {
            obj.style.display = 'block';
        } else {
            obj.style.display = 'none';
        }
    }
</script>

<style type="text/css">
    .helptekstDiv {
        position: absolute;
        margin-left: 40px;
        margin-top: 4px;
        display: none;
        padding: 5px;
        background-color: #eeeeee;
        z-index: 99999;
        color: #19619b;
        border: 1px solid #19619b;
    }
</style>

<html:form action="/configThemaData" focus="${focus}">
    <html:hidden property="action"/>
    <html:hidden property="alt_action"/>
    <html:hidden property="themaDataID"/>    
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
    
    <div style="float: left; clear: both; margin-left: 15px;">
        <c:if test="${!empty listThemaData}">
            <div class="topbar">
                <div class="bar_regel"> 
                    <div class="bar_item" style="width: 180px">Volgorde</div>
                    <div class="bar_item" style="width: 200px"><fmt:message key="configthemadata.label"/></div>
                    <div class="bar_item" style="width: 200px"><fmt:message key="configthemadata.${connectieType}.kolomnaam"/></div>
                    <div class="bar_item" style="width: 290px"><fmt:message key="configthemadata.basisregel"/></div>
                </div>
            </div>
            <div class="scroll">
                <c:forEach var="ci" varStatus="status" items="${listThemaData}">
                    <c:choose>
                        <c:when test="${ci.id != mainid}">
                            <c:set var="class" value="regel_odd"/>
                            <c:if test="${status.index % 2 == 0}">
                                <c:set var="class" value="regel_even"/>
                                <c:set var="classover" value="regel_over"/>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:set var="class" value="regel_selected"/>
                            <c:set var="classover" value="regel_over"/>
                        </c:otherwise>
                    </c:choose>								
                    <c:url var="link" value="/configThemaData.do?edit=submit&themaDataID=${ci.id}"/>
                    <div class="${class}" onmouseover="this.className='${classover}';" onmouseout="this.className='${class}';" onclick="javascript: window.location.href='${link}';">
                        <div class="c_item" style="width: 180px;"><c:out value="${ci.dataorder}"/></div>
                        <div class="c_item" style="width: 200px;"><c:out value="${ci.label}"/></div>
                        <div class="c_item" style="width: 200px;"><c:out value="${ci.kolomnaam}"/></div>
                        <div class="c_item" style="width: 273px; border: 0px none White;">
                            <c:if test="${ci.basisregel}">Ja</c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    <div id="content_style" style="float: left; clear: left;">
        <div class="berichtenbalk" style="margin-top: 5px;">
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
        <div class="maintable" style="margin-top: 5px;">
            <table cellpadding="2" cellspacing="2" border="0">
                <tr><td><fmt:message key="configthemadata.label"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.label.uitleg"/></div></td><td colspan="3"><html:text property="label" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.eenheid"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.eenheid.uitleg"/></div></td><td colspan="3"><html:text property="eenheid" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.omschrijving"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.omschrijving.uitleg"/></div></td><td colspan="3"><html:text property="omschrijving" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.basisregel"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.basisregel.uitleg"/></div></td><td colspan="3"><html:checkbox property="basisregel"/></td></tr>
                <tr class="optionalConfigItems"><td><fmt:message key="configthemadata.voorbeelden"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.voorbeelden.uitleg"/></div></td><td colspan="3"><html:text property="voorbeelden" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.kolombreedte"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.kolombreedte.uitleg"/></div></td><td colspan="3"><html:text property="kolombreedte" size="140"/></td></tr>
                <tr class="optionalConfigItems">
                    <td>
                        <fmt:message key="configthemadata.moscow"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.moscow.uitleg"/></div>
                    </td>
                    <td colspan="3">
                        <html:select property="moscowID">
                            <c:forEach var="cuItem" items="${listMoscow}">
                                <html:option value="${cuItem.id}">
                                    <c:out value="${cuItem.naam}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <fmt:message key="configthemadata.waardetype"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.waardetype.uitleg"/></div>
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
                <tr>
                    <td>
                        <fmt:message key="configthemadata.datatype"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.datatype.uitleg"/></div>
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
                <tr><td><fmt:message key="configthemadata.commando"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.commando.uitleg"/></div></td><td colspan="3"><html:text property="commando" size="140"/></td></tr>
                <c:choose>
                    <c:when test="${fn:length(listAdminTableColumns)>1}">
                        <tr>
                            <td><fmt:message key="configthemadata.${connectieType}.kolomnaam"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.${connectieType}.kolomnaam.uitleg"/></div></td>
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
                        <tr><td><fmt:message key="configthemadata.kolomnaam"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.kolomnaam.uitleg"/></div></td><td colspan="3"><html:text property="kolomnaam" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                <tr><td><fmt:message key="configthemadata.dataorder"/> <a href="#" onclick="return showHelp(this);">(?)</a><div class="helptekstDiv" onclick="showHideDiv(this);"><fmt:message key="configthemadata.dataorder.uitleg"/></div></td><td colspan="3"><html:text property="dataorder" size="140"/></td></tr>
            </table>
        </div>        
         
    </div> 
</html:form>
<script language="javascript">
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