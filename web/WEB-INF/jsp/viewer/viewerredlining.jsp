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
            alert("No parent found");
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
                document.forms[0].wkt.value = "";
            }
        } else {
            document.forms[0].wkt.value = "";
        }
        document.forms[0].sendRedlining.value = 't';
        document.forms[0].submit();
    }

    function prepareForm() {
        document.forms[0].sendRedlining.value = 't';
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

            <c:choose>
                <c:when test="${fn:length(redliningID)==0}">
                    <c:if test="${empty form.map.wkt}">
                        <script type="text/javascript">
                            var ouder = getParent();
                            if(ouder) {
                                ouder.webMapController.getMap().getLayer("editMap").removeAllFeatures();
                            }
                        </script>
                    </c:if>
                    <h3>Redlining pagina</h3>

                    <p>Kies een bestaand project om de redline objecten te bekijken
                    of teken een nieuw object en sla deze op.</p>

                    <table>
                        <tr>
                            <td>Project</td>
                            <td>

                                <html:select property="projectid">
                                    <%--
                                    <c:forEach var="opt" items="${projecten}">
                                        <html:option value="${opt}"/>
                                    </c:forEach>
                                    --%>
                                    <html:option value="1"/>
                                </html:select>
                            </td>
                        </tr>
                        <tr>
                            <td>Kleur vulling</td>
                            <td><html:text property="fillcolor" size="20" maxlength="10"/></td>
                        </tr>
                        <tr>
                            <td>Opmerking</td>
                            <td><html:text property="opmerking" size="40" maxlength="80"/></td>
                        </tr>
                    </table>

                    <html:hidden property="wkt"/>
                    <html:hidden property="gegevensbron"/>

                    <p>
                        <input type="button" value="Opslaan" class="zoek_knop" onclick="submitForm();" />
                        <input type="button" value="Leegmaken" class="zoek_knop" onclick="prepareForm();" />
                    </p>

                </c:when>
                <c:otherwise>
                    <script type="text/javascript">
                        var ouder = getParent();
                        if(ouder) {
                            var point = "${form.map.wkt}".toLowerCase();
                            if (point.indexOf("point", 0)>=0) {
                                var xstart = point.indexOf("(", 0);
                                var yend = point.indexOf(")", xstart);
                                var coords = point.substring(xstart+1, yend).split(" ");
                                if (coords.length == 2) {
                                    //ouder.webMapController.getMap().setMarker("${kenmerk}", Number(coords[0]),Number(coords[1]), "");
                                    ouder.webMapController.getMap().getLayer("editMap").removeAllFeatures();
                                }
                            }
                        }
                    </script>
                    <p>
                        <input type="button" value="Nieuw" class="zoek_knop" onclick="prepareForm();" />
                    </p>
                </c:otherwise>
            </c:choose>
        </html:form>

    </div>
</div>