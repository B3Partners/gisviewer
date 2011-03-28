<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${redliningForm}"/>
<c:set var="redliningID" value="${form.map.redliningID}"/>

<div style="margin: 5px;">
    <div id="redliningcontainer" class="redliningcontainer">
        <div class="messages">
            <html:messages id="message" message="true" >
                <div id="error_tab">
                    <c:out value="${message}" escapeXml="false"/>
                </div>
            </html:messages>
            <html:messages id="message" name="acknowledgeMessages">
                <div id="acknowledge_tab">
                    <c:out value="${message}"/>
                </div>
            </html:messages>
        </div>

        <html:form styleId="redliningForm" action="/viewerredlining">
            <input type="hidden" name="sendRedlining">
            <input type="hidden" name="removeRedlining">
            <input type="hidden" name="prepareRedlining">

            <html:hidden property="wkt"/>
            <html:hidden property="gegevensbron"/>
            <html:hidden property="kaartlaagId"/>
            <html:hidden styleId="redliningID" property="redliningID"/>

            <p>
                Kies een bestaand project uit de lijst om hiervan de redline
                objecten op de kaart te bekijken.
            </p>
            
            <table>
                <tr>
                    <td class="tab-row">Bestaand project</td>
                    <td>
                        <html:select styleId="projectnaam" property="projectnaam" onchange="projectChanged(this);" >
                            <html:option value="Maak uw keuze..."/>
                            <c:forEach var="project" items="${projecten}">
                                <html:option value="${project}"/>
                            </c:forEach>
                        </html:select>
                    </td>
                </tr>
            </table>

            <hr>
            <p>
                Nieuw object intekenen of een bestaande selecteren en bewerken.
            </p>

            <p>
                <input type="button" value="Nieuw" class="zoek_knop" onclick="startDrawRedlineObject();" />
                <input type="button" value="Bewerken" class="zoek_knop" onclick="startEditRedlining();" />
            </p>

            <hr>

            <p>Sla het object op of verwijder deze.

            <table>
                <tr>
                    <td class="tab-row">Project</td>
                    <td><html:text styleId="new_projectnaam" property="new_projectnaam" size="20" maxlength="10"/></td>
                </tr>
                <tr>
                    <td class="tab-row">Ontwerp</td>
                    <td>
                        <html:select styleId="ontwerp" property="ontwerp">
                            <html:option value="Ontwerp 1"/>
                            <html:option value="Ontwerp 2"/>
                            <html:option value="Ontwerp 3"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td class="tab-row">Opmerking</td>
                    <td>
                        <html:textarea cols="20" rows="7" styleId="opmerking" property="opmerking"></html:textarea>
                    </td>
                </tr>
            </table>

            <p>
                <input type="button" value="Opslaan" class="zoek_knop" onClick="if(confirm('U wilt het object opslaan?')) submitForm(); else return false;" />
                <input type="button" value="Verwijderen" class="zoek_knop" onClick="if(confirm('U wilt het object verwijderen?')) submitRemoveForm(); else return false;" />
            </p>
            
        </html:form>
        
    </div>
</div>

<script type="text/javascript" src="<html:rewrite page="/scripts/redlining.js"/>"></script>