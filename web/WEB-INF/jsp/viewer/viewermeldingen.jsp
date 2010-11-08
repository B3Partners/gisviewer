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
            var wkt = ouder.getWktActiveFeature();
            var meldingtekst = document.getElementById('meldingtekst').value;
            if (wkt && meldingtekst){
                document.getElementById('meldingresult').innerHTML = "<p>Informatie verzenden, een ogenblik aub ...</p>";
                JMapData.zendMelding(wkt, meldingtekst, handleVerzending);
            }else{
                if (wkt){
                    document.getElementById('meldingresult').innerHTML =
                        "<p>Er kan geen melding verzonden worden, omdat er \n"+
                        "geen tekst is ingegeven.</p>";
                } else {
                    document.getElementById('meldingresult').innerHTML =
                        "<p>Er kan geen melding verzonden worden, omdat er \n"+
                        "geen stip getekend is in de kaart.</p>";
                }
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
        <div class="meldingenoptie">
            <textarea id="meldingtekst" name="meldingtekst" rows="10" cols="45"></textarea>
        </div>
        <div class="meldingenoptie">
            <input type="button" value="Verzenden" class="zoek_knop" id="meldingen" name="meldingen" onclick="doAjaxRequest();" />
        </div>

        <div class="meldingresult" id="meldingresult" style="height: 10px;">
            <p>Nog geen melding verzonden</p>
        </div>
    </div>
</div>

