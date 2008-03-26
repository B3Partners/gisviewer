<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${themaForm}"/>
<c:set var="action" value="${form.map.action}"/>
<c:set var="mainid" value="${form.map.themaID}"/>

<c:set var="save" value="${action == 'save'}"/>
<c:set var="delete" value="${action == 'delete'}"/>

<c:set var="focus" value="naam"/>

<div class="onderbalk">THEMA CONFIG<span><tiles:insert name="loginblock"/></span></div>
<html:form action="/configThema" focus="${focus}">
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
    
    
    <div style="float: left; clear: both; margin-left: 15px;">
        <c:if test="${!empty allThemas}">
            <div class="topbar">
                <div class="bar_regel"> 
                    <div class="bar_item" style="width: 40px;">Nr</div>
                    <div class="bar_item" style="width: 358px;">Naam</div>
                    <div class="bar_item" style="width: 30px;">Code</div>
                    <div class="bar_item" style="width: 180px;">Admin Tabel</div>
                    <div class="bar_item" style="width: 180px;">Spatial Tabel</div>
                    <div class="bar_item" style="width: 68px;">Data</div>
                </div>
            </div>
            <div class="scroll">
                <c:forEach var="ci" varStatus="status" items="${allThemas}">
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
                    <c:url var="link" value="/configThema.do?edit=submit&themaID=${ci.id}"/>
                    <div class="${class}" onmouseover="this.className='${classover}';" onmouseout="this.className='${class}';" onclick="javascript: window.location.href='${link}';">                            
                        <div class="c_item" style="width: 40px;"><c:out value="${ci.belangnr}"/>&nbsp;</div>
                        <div class="c_item" style="width: 358px;"><c:out value="${ci.naam}"/>&nbsp;</div>
                        <div class="c_item" style="width: 30px;"><c:out value="${ci.code}"/>&nbsp;</div>
                        <div class="c_item" style="width: 180px;"><c:out value="${ci.admin_tabel}"/>&nbsp;</div>
                        <div class="c_item" style="width: 180px;"><c:out value="${ci.spatial_tabel}"/>&nbsp;</div>
                        <div class="c_item" style="width: 51px; border-right: 0px none White;">
                            <c:if test="${ci.code!='3'}">
                                &nbsp;<html:link page="/configThemaData.do?edit=submit&themaID=${ci.id}">TD</html:link>&nbsp;
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
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
        
        <div class="maintable">
            <table cellpadding="2" cellspacing="2" border="0">
                <tr><td><fmt:message key="configthema.naam"/></td><td colspan="3"><html:text property="naam" size="140"/></td></tr>
                <tr><td><fmt:message key="configthema.metadatalink"/></td><td colspan="3"><html:text property="metadatalink" size="140"/></td></tr>
                <tr class="optionalConfigItems">
                    <td>
                        <fmt:message key="configthema.code"/>
                    </td>
                    <td colspan="3">
                        <html:select property="code">
                            <html:option value="1">Oorspronkelijk Thema (1)</html:option>
                            <html:option value="2">Nieuw Thema (2)</html:option>
                            <html:option value="3">Thema niet meer in gebruik (3)</html:option>
                        </html:select>&nbsp;
                    </td>
                </tr>
                <tr class="optionalConfigItems">
                    <td>
                        <fmt:message key="configthema.moscow"/>
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
                <tr><td><fmt:message key="configthema.belangnr"/></td><td colspan="3"><html:text property="belangnr" size="140"/></td></tr>
                <tr>
                    <td>
                        <fmt:message key="configthema.cluser"/>
                    </td>
                    <td colspan="3">
                        <html:select property="clusterID">
                            <c:forEach var="cuItem" items="${allClusters}">
                                <html:option value="${cuItem.id}">
                                    <c:out value="${cuItem.naam}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                <tr><td><fmt:message key="configthema.opmerkingen"/></td><td colspan="3"><html:text property="opmerkingen" size="140"/></td></tr>
                <tr><td><fmt:message key="configthema.locatiethema"/></td><td colspan="3"><html:checkbox property="locatie_thema"/></td></tr>
                <tr><td><fmt:message key="configthema.analysethema"/></td><td colspan="3"><html:checkbox property="analyse_thema"/></td></tr>
                <tr><td><fmt:message key="configthema.defaultvisible"/></td><td colspan="3"><html:checkbox property="visible"/></td></tr>
                
                <tr><td colspan="4">&nbsp;</td></tr>
                <tr>
                    <td>
                        <fmt:message key="configthema.connectie"/>
                    </td>
                    <td colspan="3">
                        <html:select property="connectie">
                            <html:option value=""/>
                            <c:forEach var="cuItem" items="${listConnecties}">
                                <html:option value="${cuItem.id}">
                                    <c:out value="${cuItem.naam}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                <c:set var="connectieType" value="jdbc"/>
                <c:if test="${form.map.connectie!=null}">                    
                    <c:forEach var="i" items="${listConnecties}">
                       <c:if test="${i.id==form.map.connectie && i.type=='wfs'}">
                            <c:set var="connectieType" value="wfs"/>
                        </c:if>
                    </c:forEach>                            
                </c:if>
                <tr><td colspan="4">&nbsp;</td></tr>
                <tr><td><fmt:message key="configthema.${connectieType}.admintabelopmerkingen"/></td><td colspan="3"><html:text property="admin_tabel_opmerkingen" size="140"/></td></tr>
                <tr>
                    <td><fmt:message key="configthema.${connectieType}.admintabel"/></td>
                    <td colspan="3">
                        <html:select property="admin_tabel">
                            <html:option value=""/>
                            <c:forEach var="cuItem" items="${listTables}">
                                <html:option value="${cuItem}"/>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>                
                <c:choose>
                    <c:when test="${fn:length(listAdminTableColumns)>1}">
                        <tr>
                            <td><fmt:message key="configthema.${connectieType}.adminpk"/></td>
                            <td colspan="3">
                                <html:select property="admin_pk">
                                    <html:option value=""/>
                                    <c:forEach var="cuItem" items="${listAdminTableColumns}">
                                        <html:option value="${cuItem}"/>
                                    </c:forEach>
                                </html:select>&nbsp;
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr><td><fmt:message key="configthema.${connectieType}.adminpk"/></td><td colspan="3"><html:text property="admin_pk" size="140"/></td></tr>

                    </c:otherwise>
                </c:choose>
                <c:if test="${connectieType=='jdbc'}">
                    <tr><td><fmt:message key="configthema.${connectieType}.adminquery"/></td><td colspan="3"><html:text property="admin_query" size="140"/></td></tr>
                    
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr><td><fmt:message key="configthema.${connectieType}.spatialtabelopmerkingen"/></td><td colspan="3"><html:text property="spatial_tabel_opmerkingen" size="140"/></td></tr>
                    <tr>
                        <td><fmt:message key="configthema.${connectieType}.spatialtabel"/></td>
                        <td colspan="3">
                            <html:select property="spatial_tabel">
                                <html:option value=""/>
                                <c:forEach var="cuItem" items="${listTables}">
                                    <html:option value="${cuItem}"/>
                                </c:forEach>
                            </html:select>&nbsp;
                        </td>
                    </tr>
                    <c:choose>
                        <c:when test="${fn:length(listSpatialTableColumns)>1}">
                            <tr>
                                <td><fmt:message key="configthema.${connectieType}.spatialpk"/></td>
                                <td colspan="3">
                                    <html:select property="spatial_pk">
                                        <html:option value=""/>
                                        <c:forEach var="cuItem" items="${listSpatialTableColumns}">
                                            <html:option value="${cuItem}"/>
                                        </c:forEach>
                                    </html:select>&nbsp;
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr><td><fmt:message key="configthema.${connectieType}.spatialpk"/></td><td colspan="3"><html:text property="spatial_pk" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${fn:length(listSpatialTableColumns)>1}">
                            <tr>
                                <td><fmt:message key="configthema.${connectieType}.spatialadminref"/></td>
                                <td colspan="3">
                                    <html:select property="spatial_admin_ref">
                                        <html:option value=""/>
                                        <c:forEach var="cuItem" items="${listSpatialTableColumns}">
                                            <html:option value="${cuItem}"/>
                                        </c:forEach>
                                    </html:select>&nbsp;
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr><td><fmt:message key="configthema.${connectieType}.spatialadminref"/></td><td colspan="3"><html:text property="spatial_admin_ref" size="140"/></td></tr>
                        </c:otherwise>
                    </c:choose>                
                <tr>
                    <td><fmt:message key="configthema.viewgeomtype"/></td>
                    <td colspan="3">
                        <html:select property="view_geomtype">
                            <html:option value=""/>
                            <c:forEach var="cuItem" items="${listValidGeoms}">
                                <html:option value="${cuItem}"/>
                            </c:forEach>
                        </html:select>&nbsp;
                    </td>
                </tr>
                </c:if>
                <tr><td colspan="4">&nbsp;</td></tr>
                <c:choose>
                    <c:when test="${fn:length(listLayers)>1}">
                        <tr>
                            <td><fmt:message key="configthema.wmslayers"/></td>
                            <td colspan="3">
                                <html:select property="wms_layers_real">
                                    <html:option value=""/>
                                    <c:forEach var="cuItem" items="${listLayers}">
                                        <html:option value="${cuItem}"/>
                                    </c:forEach>
                                </html:select>&nbsp;
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr><td><fmt:message key="configthema.wmslayers"/></td><td colspan="3"><html:text property="wms_layers_real" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${fn:length(listLayers)>1}">
                        <tr>
                            <td><fmt:message key="configthema.wmsquerylayers"/></td>
                            <td colspan="3">
                                <html:select property="wms_querylayers_real">
                                    <html:option value=""/>
                                    <c:forEach var="cuItem" items="${listLayers}">
                                        <html:option value="${cuItem}"/>
                                    </c:forEach>
                                </html:select>&nbsp;
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr><td><fmt:message key="configthema.wmsquerylayers"/></td><td colspan="3"><html:text property="wms_querylayers_real" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${fn:length(listLegendLayers)>1}">
                        <tr>
                            <td><fmt:message key="configthema.wmslegendlayers"/></td>
                            <td colspan="3">
                                <html:select property="wms_legendlayer_real">
                                    <html:option value=""/>
                                    <c:forEach var="cuItem" items="${listLegendLayers}">
                                        <html:option value="${cuItem}"/>
                                    </c:forEach>
                                </html:select>&nbsp;
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr><td><fmt:message key="configthema.wmslegendlayers"/></td><td colspan="3"><html:text property="wms_legendlayer_real" size="140"/></td></tr>
                    </c:otherwise>
                </c:choose>
                
                <tr><td colspan="4">&nbsp;</td></tr>
                <tr class="optionalConfigItems"><td><fmt:message key="configthema.updatefreqindagen"/></td><td colspan="3"><html:text property="update_frequentie_in_dagen" size="140"/></td></tr>
                
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
</html:form>
