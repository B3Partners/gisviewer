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

        <p>
            Teken een object op de kaart. Kies vervolgens een project
            uit de lijst of vul een nieuwe projectnaam in.
        </p>

        <html:form styleId="redliningForm" action="/viewerredlining">
            <input type="hidden" name="sendRedlining">
            <input type="hidden" name="prepareRedlining">

            <html:hidden property="wkt"/>
            <html:hidden property="gegevensbron"/>
            <html:hidden styleId="redliningID" property="redliningID"/>
                    
            <table>
                <tr>
                    <td class="tab-row">Bestaand project</td>
                    <td>
                        <html:select styleId="projectnaam" property="projectnaam">
                            <html:option value="Maak uw keuze..."/>
                            <c:forEach var="project" items="${projecten}">
                                <html:option value="${project}"/>
                            </c:forEach>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td class="tab-row">Project</td>
                    <td><html:text styleId="new_projectnaam" property="new_projectnaam" size="20" maxlength="10"/></td>
                </tr>
            </table>

            <p>
                <input type="button" value="Opslaan" class="zoek_knop" onclick="submitForm();" />
                <input type="button" value="Leegmaken" class="zoek_knop" onclick="emptyForm();" />
            </p>
        </html:form>

        <hr>
       
        <p>
            Om een bestaand redline object te bewerken klikt u op de knop bewerken. Selecteer
            een redline object in de kaart. Na de aanpassingen drukt u op Opslaan.
        </p>

        <p>
            <input type="button" value="Bewerken" class="zoek_knop" onclick="editRedline();" />
        </p>
    </div>
</div>

<script type="text/javascript" src="<html:rewrite page="/scripts/redlining.js"/>"></script>