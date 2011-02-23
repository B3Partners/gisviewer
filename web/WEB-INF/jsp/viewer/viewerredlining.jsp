<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${redliningForm}"/>
<c:set var="redliningID" value="${form.map.redliningID}"/>

<script type="text/javascript">
    function getParent() {
        if (window.opener){
            return window.opener;
        }else if (window.parent){
            return window.parent;
        }else{
            messagePopup("", "No parent found", "error");
            
            return null;
        }
    }

    function submitForm() {
        var ouder = getParent();
        if(ouder) {
            var wkt = ouder.getWktActiveFeature();
            if (wkt) {
                document.forms[0].wkt.value = wkt;
            } else {
                return false;
            }
        } else {
            document.forms[0].wkt.value = "";
        }
        document.forms[0].sendRedlining.value = 't';
        document.forms[0].submit();
    }

    function prepareForm() {
        document.forms[0].prepareRedlining.value = 't';
        document.forms[0].submit();
    }

    function tekenMelding(geomType) {
        getParent().webMapController.getMap().getLayer("editMap").removeAllFeatures();
        getParent().webMapController.getMap().getLayer("editMap").drawFeature(geomType);
    }
</script>

<div style="margin: 5px;">
    <div class="meldingencontainer">
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

        <html:form action="/viewerredlining">
            <input type="hidden" name="sendRedlining">
            <input type="hidden" name="prepareRedlining">

            <html:hidden property="gegevensbron"/>
            <html:hidden property="groepnaam"/>

            <c:choose>
                <c:when test="${fn:length(redliningID)==0}">
                    <p>
                        Teken een object op de kaart. Kies vervolgens een project
                        uit de lijst of vul een nieuwe projectnaam in.
                    </p>
                    <table>
                        <tr>
                            <td class="tab-row">Bestaand project</td>
                            <td>
                                <html:select property="projectnaam">
                                    <html:option value="Maak uw keuze..."/>
                                    <c:forEach var="project" items="${projecten}">
                                        <html:option value="${project}"/>
                                    </c:forEach>
                                </html:select>
                            </td>
                        </tr>
                        <tr>
                            <td class="tab-row">Project</td>
                            <td><html:text property="new_projectnaam" size="20" maxlength="10"/></td>
                        </tr>
						<%--
                        <tr>
                            <td class="tab-row">Kleurvulling</td>
                            <td><html:text property="fillcolor" size="20" maxlength="10"/></td>
                        </tr>
                        <tr>
                            <td class="tab-row">Opmerking</td>
                            <td><html:textarea property="opmerking" rows="4" cols="30" /></td>
                        </tr>
						--%>
                    </table>

                    <html:hidden property="wkt"/>
                    <html:hidden property="gegevensbron"/>

                    <p>
                        <input type="button" value="Opslaan" class="zoek_knop" onclick="submitForm();" />
                        <input type="button" value="Leegmaken" class="zoek_knop" onclick="prepareForm();" />
                    </p>

                </c:when>
                <c:otherwise>
                    <p>
                        <input type="button" value="Nieuw" class="zoek_knop" onclick="prepareForm();" />
                    </p>
                </c:otherwise>
            </c:choose>
        </html:form>

    </div>
</div>