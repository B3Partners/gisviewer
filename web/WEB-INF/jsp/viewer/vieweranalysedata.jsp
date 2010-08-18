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

<c:choose>
    <c:when test="${not empty object_data}">
        <script type="text/javascript">
            function showDiv(id) {
                document.getElementById(id).style.display = 'block';
                if(id == 'object_opties') document.getElementById('waarde_opties').style.display = 'none';
                if(id == 'waarde_opties') document.getElementById('object_opties').style.display = 'none';
            }

            function submitdata() {
                if(parent.usePopup) {
                    if(parent.dataframepopupHandle == null || parent.dataframepopupHandle.closed) parent.dataframepopupHandle = parent.popUpData('dataframepopup', '800', '300');
                    document.forms[0].target = 'dataframepopup';
                }
                if(document.getElementById('objectoptie').checked) {
                    // Geef object
                    document.forms[0].analyseobject.value = "t";
                    document.forms[0].analysewaarde.value = "";
                    document.forms[0].submit();
                }
                if(document.getElementById('waardeoptie').checked) {
                    // Geef waarde
                    document.forms[0].analysewaarde.value = "t";
                    document.forms[0].analyseobject.value = "";
                    document.forms[0].submit();
                }
            }
        </script>
        <div class="analysecontainer">
            <html:form action="/viewerdata" target="dataframe">
                <input type="hidden" name="analysewaarde"/>
                <input type="hidden" name="analyseobject"/>
                <html:hidden property="themaid" />
                <html:hidden property="analysethemaid" />
                <html:hidden property="lagen" />
                <%--html:hidden property="xcoord" />
                <html:hidden property="ycoord" /--%>
                <html:hidden property="coords" />

                <strong> Extra criterium voor actief thema</strong><br/>
                <html:text property="extraCriteria" size="40"/><br/>

                <strong> Analysegebied</strong><br/>
                <html:select property="geselecteerd_object">
                    <html:option value="-1">-- Selecteer een gebied --</html:option>
                    <c:forEach var="thema_object_data" items="${object_data}" varStatus="status">
                        <c:if test="${not empty thema_object_data[2]}">
                            <optgroup label="${thema_object_data[1]}">
                                <c:forEach var="regel" items="${thema_object_data[2]}">
                                    <html:option  styleClass="thema_object" value="ThemaObject_${thema_object_data[0]}_${regel.primaryKey}">
                                        <c:forEach var="item" items="${regel.values}" end="1">
                                        ${item}
                                        </c:forEach>
                                    </html:option>
                                </c:forEach>
                            </optgroup>
                        </c:if>
                    </c:forEach>
                </html:select>

                <div class="analyseoptie">
                    <html:radio property="zoekopties" value="1" styleId="objectoptie" onclick="showDiv('object_opties')"/> Geef objecten
                </div>
                <div id="object_opties" style="display: none;">
                    <html:radio property="zoekopties_object" value="1"/> Zonder overlap, niet in gebied<br />
                    <html:radio property="zoekopties_object" value="2"/> Geheel in gebied<br />
                    <html:radio property="zoekopties_object" value="3"/> Met overlap, geheel of gedeeltelijk in gebied
                </div>
                <div class="analyseoptie">
                    <html:radio property="zoekopties" value="2" styleId="waardeoptie"  onclick="showDiv('waarde_opties')"/> Geef waarde
                </div>
                <div id="waarde_opties" style="display: none;">
                    <html:radio property="zoekopties_waarde" value="1"/> Maximale waarde<br />
                    <html:radio property="zoekopties_waarde" value="2"/> Minimale waarde<br />
                    <html:radio property="zoekopties_waarde" value="3"/> Gemiddelde waarde<br />
                    <html:radio property="zoekopties_waarde" value="4"/> Totale waarde<br />
                </div>
                <div class="analyseoptie">
                    <input type="button" value="Bereken" class="zoek_knop" id="analysedata" name="analysedata" onclick="submitdata();" />
                </div>
                <div class="analyseoptie" style="height: 10px;">&nbsp;</div>
            </html:form>
        </div>
    </c:when>
    <c:otherwise>
        <div class="analysecontainer">
            Er zijn geen gebieden ter analyse gevonden!
        </div>
    </c:otherwise>
</c:choose>
