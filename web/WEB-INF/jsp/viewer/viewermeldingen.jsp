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

<c:set var="form" value="${meldingForm}"/>
<c:set var="kenmerk" value="${form.map.kenmerk}"/>

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
        document.forms[0].sendMelding.value = 't';
        document.forms[0].submit();
    }

    function prepareForm() {
        document.forms[0].prepareMelding.value = 't';
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

        <html:form action="/viewermeldingen">
            <input type="hidden" name="sendMelding">
            <input type="hidden" name="prepareMelding">
            <c:choose>
                <c:when test="${fn:length(kenmerk)==0}">
                    <c:if test="${!empty form.map.wkt}">
                        <script type="text/javascript">
                            var ouder = getParent();
                            if(ouder) {
                                //ouder.webMapController.getMap().getLayer("editMap").removeAllFeatures();
                            }
                        </script>
                    </c:if>
                    <h3><c:out value="${form.map.welkomTekst}"/></h3>
                    <p>
                        <fmt:message key="melding.teken.help"/>
                        <input type="button" value="Klik hier om tekenen te starten" class="zoek_knop" onclick="tekenMelding('${form.map.objectSoort}');" />
                    </p>
                    <p>
                        <fmt:message key="melding.verzenden.help"/>
                    </p>

                    <div class="meldinglabel"><fmt:message key="melding.naammelder"/></div>
                    <div class="meldingwaarde">
                        <html:text property="naamMelder" size="40" maxlength="250"/>
                    </div>
                    <div class="meldinglabel"><fmt:message key="melding.adresmelder"/></div>
                    <div class="meldingwaarde">
                        <html:text property="adresMelder" size="40" maxlength="250"/>
                    </div>
                    <div class="meldinglabel"><fmt:message key="melding.emailmelder"/></div>
                    <div class="meldingwaarde">
                        <html:text property="emailMelder" size="40" maxlength="250"/>
                    </div>
                    <div class="meldinglabel"><fmt:message key="melding.type"/></div>
                    <div class="meldingwaarde">
                        <html:select property="meldingType">
                            <c:forEach var="opt" items="${meldingTypes}">
                                <html:option value="${opt}"/>
                            </c:forEach>
                        </html:select>
                    </div>
                    <div class="meldinglabel"><fmt:message key="melding.tekst"/></div>
                    <div class="meldingwaarde">
                        <html:textarea property="meldingTekst" cols="40" rows="10"/>
                    </div>
                    <html:hidden property="meldingStatus"/>
                    <html:hidden property="meldingCommentaar"/>
                    <html:hidden property="zendEmailMelder"/>
                    <html:hidden property="layoutStylesheetMelder"/>
                    <html:hidden property="naamBehandelaar"/>
                    <html:hidden property="emailBehandelaar"/>
                    <html:hidden property="zendEmailBehandelaar"/>
                    <html:hidden property="layoutStylesheetBehandelaar"/>
                    <html:hidden property="gegevensbron"/>
                    <html:hidden property="objectSoort"/>
                    <html:hidden property="icoonTekentool"/>
                    <html:hidden property="wkt"/>
                    <html:hidden property="kenmerk"/>
                    <html:hidden property="welkomTekst"/>
                    <html:hidden property="prefixKenmerk"/>
                    <p>
                        <input type="button" value="Verzenden" class="zoek_knop" onclick="submitForm();" />
                        <input type="button" value="Formulier wissen" class="zoek_knop" onclick="prepareForm();" />
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
                                    ouder.webMapController.getMap().setMarker("${kenmerk}", Number(coords[0]),Number(coords[1]), "");
                                    ouder.webMapController.getMap().getLayer("editMap").removeAllFeatures();
                                }
                            }
                        }
                    </script>
                    <p>
                        <input type="button" value="Nieuwe Melding" class="zoek_knop" onclick="prepareForm();" />
                    </p>
                </c:otherwise>
            </c:choose>
        </html:form>

    </div>
</div>
