<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${clusterForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.clusterID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="naam"/>

<div class="onderbalk">CLUSTER CONFIG<span><tiles:insert name="loginblock"/></span></div>
<html:form action="/configCluster" focus="${focus}">
    <html:hidden property="action"/>
    <html:hidden property="alt_action"/>
    <html:hidden property="clusterID"/>
    
    <c:if test="${!empty allClusters}">
        <div class="topbar">
            <div class="bar_regel"> 
                <div class="bar_item" style="width: 160px">Naam</div>
                <div class="bar_item" style="width: 120px">Ouder</div>
            </div>
        </div>
        <div class="scroll">
            <c:forEach var="ci" varStatus="status" items="${allClusters}">
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
                <c:url var="link" value="/configCluster.do?edit=submit&clusterID=${ci.id}"/>
                <div class="${class}" onmouseover="this.className='${classover}';" onmouseout="this.className='${class}';" onclick="javascript: window.location.href='${link}';">
                    <div class="c_item" style="width: 160px"><c:out value="${ci.naam}"/></div>
                    <div class="c_item" style="width: 120px"><c:out value="${ci.parent.naam}"/></div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    
    <div class="berichtenbalk">
        <html:messages id="error" message="true">
            <div class="messages">&#8594; <c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
        </html:messages>
    </div> 
    
    <div class="maintable">
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
                    Ouder Cluster:
                </td>
                <td colspan="3">
                    <html:select property="parentID">
                        <html:option value=""/>
                        <c:forEach var="cuItem" items="${allClusters}">
                            <html:option value="${cuItem.id}">
                                <c:out value="${cuItem.naam}"/>
                            </html:option>
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
    
</html:form>
