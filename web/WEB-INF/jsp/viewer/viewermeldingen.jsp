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

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

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

    function doAjaxRequest() {
        var ouder = getParent();
        if(ouder) {
            var inputArray = new Array();
            var alertRequired = false;
            var alertTekst = "<p>Er kan geen melding verzonden worden, omdat: <ul>";
            
            var wkt = ouder.getWktActiveFeature();
            inputArray[0] = wkt;
            if (!wkt) {
                alertTekst +="<li>geen stip getekend is in de kaart</li>";
                alertRequired = true;
            }
            var meldingtekst = document.getElementById('melding_tekst').value;
            inputArray[1] = meldingtekst;
            if (!meldingtekst){
                alertTekst +="<li>geen tekst is ingegeven.</li>";
                alertRequired = true;
            }
            var naamZender = document.getElementById('naam_zender').value;
            inputArray[2] = naamZender;
            if (!naamZender){
                alertTekst +="<li>geen naam is ingegeven.</li>";
                alertRequired = true;
            }
            var adresZender = document.getElementById('adres_zender').value;
            inputArray[3] = adresZender;
            if (!adresZender){
                alertTekst +="<li>geen adres is ingegeven.</li>";
                alertRequired = true;
            }
            var emailZender = document.getElementById('email_zender').value;
            inputArray[4] = emailZender;
            if (!emailZender){
                alertTekst +="<li>geen emailadres is ingegeven.</li>";
                alertRequired = true;
            }
            var meldingType = document.getElementById('melding_type').value;
            inputArray[5] = meldingType;
            if (!meldingType){
                alertTekst +="<li>geen type is ingegeven.</li>";
                alertRequired = true;
            }
            var meldingStatus = document.getElementById('melding_status').value;
            inputArray[6] = meldingStatus;
            var meldingCommentaar = document.getElementById('melding_commentaar').value;
            inputArray[7] = meldingCommentaar;
            var naamOntvanger = document.getElementById('naam_ontvanger').value;
            inputArray[8] = naamOntvanger;
            
            alertTekst +="</ul>";
            if (alertRequired){
                document.getElementById('meldingresult').innerHTML =alertTekst;
            }else{
                document.getElementById('meldingresult').innerHTML = "<p>Informatie verzenden, een ogenblik aub ...</p>";
                JMapData.zendMelding(inputArray, handleVerzending);
            }
        } else {
            document.getElementById('meldingresult').innerHTML = "werkt alleen binnen gisviewer";
        }
    }

    function handleVerzending(message) {
        if (message!=undefined){
            document.getElementById('meldingresult').innerHTML = message;
        }else{
            document.getElementById('meldingresult').innerHTML =
                "Er is iets mis gegaan met de verzending, neem contact op met B3Partners BV";
        }
    }

    function zetPuntMelding() {
        getParent().flamingo.call("editMap", 'removeAllFeatures');
        getParent().flamingo.callMethod("editMap","editMapDrawNewGeometry","layer1","Point");
    }

</script>

<div style="margin: 5px;">
    <div class="meldingencontainer">
        <p>
            Navigeer in de kaart naar de plaats waarop uw melding betrekking heeft en<br>
            zet daarna een stip door op "Teken"-knop te klikken.
            <input type="button" value="Teken" class="zoek_knop" id="puntMelding" name="puntMelding" onclick="zetPuntMelding();" />
        </p>
        <p>
            Voer daarna de tekst van uw melding hieronder in en
            klik op "Verzenden".
        </p>
        <p>
            <input type="text" id="naam_zender" name="naam_zender" size="20" maxlength="250">
            <br/>
            <input type="text" id="adres_zender" name="adres_zender" size="20" maxlength="250">
            <br/>
            <input type="text" id="email_zender" name="email_zender" size="20" maxlength="250">
            <br/>
            <select id="melding_type" name="melding_type">
                <option value="klacht"></option>
                <option value="suggestie"></option>
            </select>
            <input type="hidden" id="melding_status" name="melding_status" value="in behandeling">
            <input type="hidden" id="melding_commentaar" name="melding_commentaar" value="">
            <input type="hidden" id="naam_ontvanger" name="naam_ontvanger" value="balie">
            <br/>
            <textarea id="melding_tekst" name="melding_tekst" rows="10" cols="45"></textarea>
        </p>
        <p>
            <input type="button" value="Verzenden" class="zoek_knop" id="meldingen" name="meldingen" onclick="doAjaxRequest();" />
        </p>

        <div class="meldingresult" id="meldingresult" style="height: 10px;">
            <p>Nog geen melding verzonden</p>
        </div>
    </div>
</div>

