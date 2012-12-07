<%-- 
    Document   : viewereditziekte
    Created on : 12-mei-2011, 10:31:04
    Author     : jytte
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${editboomForm}"/>

<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/interface/EditBoomUtil.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>

<div style="float: left; margin: 5px; width: 265px;">
    <img src="<html:rewrite page="/images/digidis_logo.gif"/>" title="Digidis"/>
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

    <html:form styleId="editboomForm" action="/viewereditziekte">
        <input type="hidden" name="sendEditBoom">
        <input type="hidden" name="removeBoom">

        <html:hidden property="wkt"/>
        <html:hidden property="gegevensbron"/>
        <html:hidden property="id" styleId="id"/>
        <html:hidden property="status" styleId="status"/>
        <html:hidden property="projectid" styleId="projectid"/>
        
        <html:hidden property="eindbeeldvrij" styleId="eindbeeldvrij" />
        <html:hidden property="eindbeeld" styleId="eindbeeld" />
        <html:hidden property="scheefstand"  styleId="scheefstand" />
        <html:hidden property="scheuren"  styleId="scheuren" />
        <html:hidden property="holten"  styleId="holten" />
        <html:hidden property="stamvoetschade"  styleId="stamvoetschade" />
        <html:hidden property="stamschade"  styleId="stamschade" />
        <html:hidden property="kroonschade"  styleId="kroonschade" />
        <html:hidden property="inrot"  styleId="inrot" />
        <html:hidden property="houtboorder"  styleId="houtboorder" />
        <html:hidden property="zwam"  styleId="zwam" />
        <html:hidden property="zwam_stamvoet"  styleId="zwam_stamvoet" />
        <html:hidden property="zwam_stam"  styleId="zwam_stam" />
        <html:hidden property="zwam_kroon"  styleId="zwam_kroon" />
        <html:hidden property="dood_hout"  styleId="dood_hout" />
        <html:hidden property="plakoksel"  styleId="plakoksel" />
        <html:hidden property="stamschot"  styleId="stamschot" />
        <html:hidden property="wortelopslag"  styleId="wortelopslag" />
        <html:hidden property="takken"  styleId="takken" />
        <html:hidden property="opdruk"  styleId="opdruk" />
        <html:hidden property="vta1" styleId="vta1" />
        <html:hidden property="vta2" styleId="vta2" />
        <html:hidden property="vta3" styleId="vta3" />
        <html:hidden property="vta4" styleId="vta4" />
        <html:hidden property="vta5" styleId="vta5" />
        <html:hidden property="vta6" styleId="vta6" />
        <html:hidden property="risicoklasse" styleId="risicoklasse" />
        <html:hidden property="uitvoerdatum" styleId="uitvoerdatum" />
        <html:hidden property="nader_onderzoek" styleId="nader_onderzoek" />
        <html:hidden property="maatregelen_kortvrij" styleId="maatregelen_kortvrij" />
        <html:hidden property="maatregelen_kort" styleId="maatregelen_kort" />
        <html:hidden property="maatregelen_langvrij" styleId="maatregelen_langvrij" />
        <html:hidden property="maatregelen_lang" styleId="maatregelen_lang" />
        <html:hidden property="bereikbaarheid" styleId="bereikbaarheid" />
        <html:hidden property="wegtypevrij" styleId="wegtypevrij" />
        <html:hidden property="wegtype" styleId="wegtype" />

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
                <td class="editinputcell"><html:text property="aktie" styleId="aktie" styleClass="readonlyfield" readonly="true"/></td>
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
                    <div class="ui-widget">
                     <html:text property="boomsoort" styleId="boomsoort" />
                    </div>
                    <%--<html:text property="boomsoort" styleId="boomsoort" onkeyup="getBoomsoort();" />
                    <html:select property="boomsoort" styleId="boomsoort">
                        <html:option value="">Selecteer..</html:option>
                        <c:forEach var="soort" items="${boomsoort}">
                            <html:option value="${soort.naam}"><c:out value="${soort.omschrijving}"/></html:option>
                        </c:forEach>
                    </html:select>--%>
                </td>
            </tr>
            <tr>
                <td>Plantjaar*:</td>
                <td class="editinputcell"><html:text property="plantjaar" styleId="plantjaar" value="0" /></td>
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
                <td>Opmerking:</td>
                <td class="editinputcell">
                    <html:textarea property="opmerking" styleId="opmerking" />
                </td>
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
                        <c:forEach var="aantasting" items="${AANTASTINGEN_DIGIDIS}">
                            <html:option value="${aantasting}"><c:out value="${aantasting}"/></html:option>
                        </c:forEach>
                    </html:select>
                </td>
            </tr>
            <tr class="ziektenToggle">
                <td>Status ziekten en plagen:</td>
                <td class="editinputcell">
                    <html:select property="status_zp" styleId="status_zp" onchange="setAktie()">
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
    function setAktie(){
        var status = document.forms[0].status_zp.value;
        document.forms[0].aktie.value = status;
        changeStatusZP();
    }
    
    $(function() {        
        function log( message ) {            
            $( "<div>" ).text( message ).prependTo( "#log" );            
            $( "#log" ).scrollTop( 0 );        
        }         
        $( "#boomsoort" ).autocomplete({            
            source: function( request, response ) {    
                var zoekterm = document.forms[0].boomsoort.value;
                EditBoomUtil.getAutoSuggestBoomSoorten(zoekterm, function(jsonstring) {
                   var soorten = eval('(' + jsonstring + ')');
                    response( $.map( soorten, function( item ) {                            
                        return {                                
                            label: item.label,
                            value: item.value                           
                        }
                    }));
                });           
            },            
            minLength: 4,            
            select: function( event, ui ) {                
            log( ui.item ?                    
                "Selected: " + ui.item.label :                    
                "Nothing selected, input was " + this.value);            
            },            
            open: function() {                
                $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );            
            },            
            close: function() {                
                $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );            
            }        
        });    
    });
</script>
<script type="text/javascript" src="<html:rewrite page="/scripts/editboom.js"/>"></script>