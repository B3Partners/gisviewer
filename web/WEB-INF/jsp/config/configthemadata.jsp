<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${themaDataForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.themaDataID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="label"/>

<div class="onderbalk">DATA CONFIG<span><tiles:insert name="loginblock"/></span></div>

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
                        <html:submit property="deleteConfirm" accesskey="d" styleClass="knop" onclick="bCancel=true" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.remove"/>
                        </html:submit>
                    </div> 
                    <div class="knoppen">
                        <html:submit property="saveConfirm" accesskey="s" styleClass="knop" onmouseover="this.className='knopover';" onmouseout="this.className='knop';">
                            <fmt:message key="button.save"/>
                        </html:submit>
                    </div>                    
                </c:otherwise>
            </c:choose>
        </div>
        <div class="maintable" style="margin-top: 5px;">
            <table cellpadding="2" cellspacing="2" border="0">
                <tr><td><fmt:message key="configthemadata.label"/></td><td colspan="3"><html:text property="label" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.eenheid"/></td><td colspan="3"><html:text property="eenheid" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.omschrijving"/></td><td colspan="3"><html:text property="omschrijving" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.basisregel"/></td><td colspan="3"><html:checkbox property="basisregel"/></td></tr>
                <tr class="optionalConfigItems"><td><fmt:message key="configthemadata.voorbeelden"/></td><td colspan="3"><html:text property="voorbeelden" size="140"/></td></tr>
                <tr><td><fmt:message key="configthemadata.kolombreedte"/></td><td colspan="3"><html:text property="kolombreedte" size="140"/></td></tr>
                <tr class="optionalConfigItems">
                    <td>
                        <fmt:message key="configthemadata.moscow"/>
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
                        <fmt:message key="configthemadata.waardetype"/>
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
                        <fmt:message key="configthemadata.datatype"/>
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
                <tr><td><fmt:message key="configthemadata.commando"/></td><td colspan="3"><html:text property="commando" size="140"/></td></tr>
                <c:choose>
                    <c:when test="${fn:length(listAdminTableColumns)>1}">
                        <tr>
                            <td><fmt:message key="configthemadata.${connectieType}.kolomnaam"/></td>
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
                        <tr><td><fmt:message key="configthemadata.kolomnaam"/></td><td colspan="3"><html:text property="kolomnaam" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                <tr><td><fmt:message key="configthemadata.dataorder"/></td><td colspan="3"><html:text property="dataorder" size="140"/></td></tr>
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