<%-- 
    Document   : viewereditboom
    Created on : 12-mei-2011, 10:31:04
    Author     : jytte
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${editboomForm}"/>

<div style="float: left; margin: 5px; width: 265px;">
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
        Wijzig een bestaande boom of voeg een boom toe.
    </p>

    <html:form styleId="editboomForm" action="/viewereditboom">
        <input type="hidden" name="sendEditBoom">
        <input type="hidden" name="removeBoom">

        <html:hidden property="wkt"/>
        <html:hidden property="gegevensbron"/>
        <html:hidden property="id" styleId="id"/>
        <html:hidden property="status" styleId="status"/>
        <html:hidden property="projectid" styleId="projectid"/>

        <p>
            <input type="button" value="Nieuw" class="zoek_knop" onclick="startDrawBoomObject();" />
            <input type="button" value="Bewerken" class="zoek_knop" onclick="startEditBoom();" />
            <input type="button" value="Herladen" class="zoek_knop" onclick="reloadMap();" />
        </p>

        <hr>
        <p>
            <input type="button" value="Opslaan" class="zoek_knop" onClick="if(confirm('U wilt het object opslaan?')) submitForm(); else return false;" />
            <input type="button" value="Verwijderen" class="zoek_knop" onClick="if(confirm('U wilt het object verwijderen?')) submitRemoveForm(); else return false;" />
            <input type="button" value="Annuleren" class="zoek_knop" onclick="annuleren();" />
        </p>

        <table border="0" width="100%">
            <tr>
                <td>BoomId*:</td>
                <td class="editinputcell"><html:text property="boomid" styleId="boomid" /></td>
            </tr>
            <tr>
                <td>Project*:</td>
                <td class="editinputcell"><html:text property="project" styleId="project" styleClass="readonlyfield" readonly="true"/></td>
            </tr>
            <tr>
                <td>Inspecteur*:</td>
                <td class="editinputcell"><html:text property="inspecteur" styleId="inspecteur" styleClass="readonlyfield" readonly="true"/></td>
            </tr>
            <tr>
                <td>Aktie*:</td>
                <td class="editinputcell"><html:text property="aktie" styleId="aktie" /></td>
            </tr>
            <tr>
                <td>Mutatiedatum:</td>
                <td class="editinputcell"><html:text property="mutatiedatum" styleId="mutatiedatum" styleClass="readonlyfield" readonly="true"/></td>
            </tr>
            <tr>
                <td>Mutatietijd:</td>
                <td class="editinputcell"><html:text property="mutatietijd" styleId="mutatietijd" styleClass="readonlyfield" readonly="true"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    Boomsoort*:<br />
                    <html:select property="boomsoort" styleId="boomsoort">
                        <html:option value="">Selecteer..</html:option>
                        <c:forEach var="soort" items="${boomsoort}">
                            <html:option value="${soort.naam}"><c:out value="${soort.omschrijving}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr>
                <td>Plantjaar*:</td>
                <td class="editinputcell"><html:text property="plantjaar" styleId="plantjaar" /></td>
            </tr>
            <tr>
                <td>Boomhoogte:</td>
                <td class="editinputcell">
                    <html:text property="boomhoogtevrij" styleId="boomhoogtevrij" />
                    <html:select property="boomhoogte" styleId="boomhoogte" onchange="clearBoomhoogte();">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="hoogte" items="${BOOMHOOGTE}">
                            <html:option value="${hoogte}"><c:out value="${hoogte}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr>
                <td>Eindbeeld:</td>
                <td class="editinputcell">
                    <html:text property="eindbeeldvrij" styleId="eindbeeldvrij" />
                    <html:select property="eindbeeld" styleId="eindbeeld" onchange="clearEindbeeld();">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="eindbeeld" items="${EINDBEELD}">
                            <html:option value="${eindbeeld}"><c:out value="${eindbeeld}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            
            <tr>
                <td>Opmerking:</td>
                <td class="editinputcell">
                    <html:textarea property="opmerking" styleId="opmerking" />
                </td>
            </tr>           
            
            <tr>
                <td colspan="2" style="width: auto; padding: 3px;">
                    <a href="#" id="checkboxtoggle">[+] boomveiligheidskenmerken</a>
                </td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Scheefstand:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="scheefstand"  styleId="scheefstand"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Scheuren:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="scheuren"  styleId="scheuren"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Holte/specht-gat:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="holten"  styleId="holten"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Stamvoetschade:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="stamvoetschade"  styleId="stamvoetschade"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Stamschade:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="stamschade"  styleId="stamschade"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Kroonschade:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="kroonschade"  styleId="kroonschade"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Inrot snoeiwond:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="inrot"  styleId="inrot"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Houtboorder:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="houtboorder"  styleId="houtboorder"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Zwam rondom:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="zwam"  styleId="zwam"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Zwam stamvoet:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="zwam_stamvoet"  styleId="zwam_stamvoet"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Zwam stam:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="zwam_stam"  styleId="zwam_stam"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Zwam kroon:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="zwam_kroon"  styleId="zwam_kroon"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Dood hout:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="dood_hout"  styleId="dood_hout"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Plakoksel:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="plakoksel"  styleId="plakoksel"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Stamschot:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="stamschot"  styleId="stamschot"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Wortelopslag:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="wortelopslag"  styleId="wortelopslag"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Takken in takvrije zone:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="takken"  styleId="takken"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Opdrukken verharding:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="opdruk"  styleId="opdruk"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA1:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta1" styleId="vta1"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA2:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta2" styleId="vta2"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA3:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta3" styleId="vta3"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA4:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta4" styleId="vta4"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA5:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta5" styleId="vta5"/></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>VTA6:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="vta6" styleId="vta6"/></td>
            </tr>            
            <tr class="checkboxtoggle">
                <td>Risicoklasse:</td>
                <td class="editinputcell">
                    <html:select property="risicoklasse" styleId="risicoklasse" onchange="setUitvoerdatum()">
                        <html:option value="">Selecteer..</html:option>
                        <c:forEach var="risicoklasse" items="${RISICOKLASSE}">
                            <html:option value="${risicoklasse}"><c:out value="${risicoklasse}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Volgende inspectie:</td>
                <td class="editinputcell"><html:text property="uitvoerdatum" styleId="uitvoerdatum" /></td>
            </tr>
            <tr class="checkboxtoggle">
                <td>Nader onderzoek:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="nader_onderzoek" styleId="nader_onderzoek"/></td>
            </tr>
            
            <!-- Ziekten en plagen -->
            <tr>
                <td colspan="2" style="width: auto; padding: 3px;">
                    <a href="#" id="ziektenToggle">[+] ziekten en plagen</a>
                </td>
            </tr>
            <tr class="ziektenToggle">
                <td>Aantastingen:</td>
                <td class="editinputcell">
                    <html:text property="aantastingenvrij" styleId="aantastingenvrij" />
                    <html:select property="aantastingen" styleId="aantastingen" onchange="changeAantating()">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="aantasting" items="${AANTASTINGEN}">
                            <html:option value="${aantasting}"><c:out value="${aantasting}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr class="ziektenToggle">
                <td>Status ziekten en plagen:</td>
                <td class="editinputcell">
                    <html:select property="status_zp" styleId="status_zp" onchange="changeStatusZP()">
                        <html:option value="">Selecteer..</html:option>
                    </html:select>
                </td>
            </tr>
            <tr class="ziektenToggle">
                <td>Classificatie:</td>
                <td class="editinputcell">
                    <html:select property="classificatie" styleId="classificatie">
                        <html:option value="">Selecteer..</html:option>
                    </html:select>
                </td>
            </tr>
            <!-- End ziekten en plagen -->
            
            <tr>
                <td colspan="2" style="width: auto; padding: 3px;">
                    <a href="#" id="onderhoudsfieldstoggle">[+] onderhoudskenmerken</a>
                </td>
            </tr>
            <tr class="onderhoudsfieldstoggle">
                <td>Maatregel kort termijn:</td>
                <td class="editinputcell">
                    <html:text property="maatregelen_kortvrij" styleId="maatregelen_kortvrij" />
                    <html:select property="maatregelen_kort" styleId="maatregelen_kort" onchange="clearMaatregelkort();">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="maatregelen_kort" items="${MAATREGELEN_KORT}">
                            <html:option value="${maatregelen_kort}"><c:out value="${maatregelen_kort}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr class="onderhoudsfieldstoggle">
                <td>Maatregel lange termijn:</td>
                <td class="editinputcell">
                    <html:text property="maatregelen_langvrij" styleId="maatregelen_langvrij" />
                    <html:select property="maatregelen_lang" styleId="maatregelen_lang" onchange="clearMaatregellang();">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="maatregelen_lang" items="${MAATREGELEN_LANG}">
                            <html:option value="${maatregelen_lang}"><c:out value="${maatregelen_lang}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr class="onderhoudsfieldstoggle">
                <td>Bereikbaarheid:</td>
                <td class="editinputcell"><html:checkbox styleClass="editcheckbox" property="bereikbaarheid" styleId="bereikbaarheid"/></td>
            </tr>
            <tr class="onderhoudsfieldstoggle">
                <td>Wegtype:</td>
                <td class="editinputcell">
                    <html:text property="wegtypevrij" styleId="wegtypevrij" />
                    <html:select property="wegtype" styleId="wegtype" onchange="clearWegtype();">
                        <html:option value="">Of selecteer..</html:option>
                        <c:forEach var="wegtype" items="${WEGTYPE}">
                            <html:option value="${wegtype}"><c:out value="${wegtype}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>            
            <tr>
                <td colspan="2" style="width: auto; padding: 3px;">
                    <a href="#" id="extrafieldstoggle">[+] extra kenmerken</a>
                </td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra1}"/>:</td>
                <td class="editinputcell"><html:text property="extra1" styleId="extra1" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra2}"/>:</td>
                <td class="editinputcell"><html:text property="extra2" styleId="extra2" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra3}"/>:</td>
                <td class="editinputcell"><html:text property="extra3" styleId="extra3" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra4}"/>:</td>
                <td class="editinputcell"><html:text property="extra4" styleId="extra4" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra5}"/>:</td>
                <td class="editinputcell"><html:text property="extra5" styleId="extra5" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra6}"/>:</td>
                <td class="editinputcell"><html:text property="extra6" styleId="extra6" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra7}"/>:</td>
                <td class="editinputcell"><html:text property="extra7" styleId="extra7" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra8}"/>:</td>
                <td class="editinputcell"><html:text property="extra8" styleId="extra8" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra9}"/>:</td>
                <td class="editinputcell"><html:text property="extra9" styleId="extra9" /></td>
            </tr>
            <tr class="extrafieldstoggle">
                <td><c:out value="${labels.extra10}"/>:</td>
                <td class="editinputcell"><html:text property="extra10" styleId="extra10" /></td>
            </tr>
        </table>

        <p>
            <input type="button" value="Opslaan" class="zoek_knop" onClick="if(confirm('U wilt het object opslaan?')) submitForm(); else return false;" />
            <input type="button" value="Verwijderen" class="zoek_knop" onClick="if(confirm('U wilt het object verwijderen?')) submitRemoveForm(); else return false;" />
            <input type="button" value="Annuleren" class="zoek_knop" onclick="annuleren();" />
        </p>

    </html:form>

        <c:if test="${boomWkt != null}">
            <script>
                var ouder = getParent();
                ouder.selectBoomObject("${boomWkt}");
            </script>
        </c:if>

</div>

<script typ="text/javascript">
    $j(document).ready(function() {
        $j("#uitvoerdatum").datepicker({
            dateFormat: 'dd-mm-yy'
        });
        
        // Alle uitklapbare onderdelen. Key = class van rijen / id van de link, Value = text van de link
        var toggles = {
            'checkboxtoggle': 'boomveiligheidskenmerken',
            'ziektenToggle': 'ziekten en plagen',
            'onderhoudsfieldstoggle': 'onderhoudskenmerken',
            'extrafieldstoggle': 'extra kenmerken'
        };
        // Voor alle uitklapbare onderdelen de rijen verbergen en open/dichtklappen bij het klikken op de link
        jQuery.each(toggles, function(key, value) {
            var $classes = $j("." + key)
            $classes.hide();
            $j("#" + key).click(function(e) {
                // IE FIX: pak eerste element en bekijk daar de style van, bug in jQuery zorgt ervoor dat in
                // IE volgens jQuery de TR altijd zichtbaar is, dus bekijk de dom style
                var elem = $classes[0];
                if(elem.style.display == 'none') $classes.show();
                else $classes.hide();
                // /IE FIX
                if($j(this).text() == ("[+] " + value)) $j(this).text(("[-] " + value));
                else $j(this).text(("[+] " + value));
                zebra();
                e.preventDefault();
            });
        });

        function zebra() {
            var counter = 1;
            $j("#editboomForm").find("tr").filter(":visible").each(function() {
                if(counter%2==0) $j(this).addClass("editrowodd");
                else $j(this).removeClass("editrowodd");
                counter++;
            });
        }
        zebra();
    });
</script>
<script type="text/javascript"> 
    function clearBoomhoogte(){
        document.forms[0].boomhoogtevrij.value = "";
    }
    function clearEindbeeld(){
        document.forms[0].eindbeeldvrij.value = "";
    }
    function clearMaatregelkort(){
        document.forms[0].maatregelen_kortvrij.value = "";
    }
    function clearMaatregellang(){
        document.forms[0].maatregelen_langvrij.value = "";
    }
    function clearWegtype(){
        document.forms[0].wegtypevrij.value = "";
    }
</script>
<script type="text/javascript" src="<html:rewrite page="/scripts/editboom.js"/>"></script>