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

<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

<script type="text/javascript">
    function doAjaxRequest() {
        var ouder = getParent({ parentOnly: true });
        if(ouder) {
            var wkt = ouder.B3PGissuite.viewercommons.getWktActiveFeature(-1);
            var themaIdArray =  ouder.B3PGissuite.vars.enabledLayerItems;
            var themaIds = "";
            for (var i=0; i < themaIdArray.length; i++){
                if (themaIdArray[i].analyse=="on") {
                    if (themaIds.length > 0) {
                        themaIds += ",";
                    }
                    themaIds += themaIdArray[i].id;
                }
            }
            if (wkt && themaIds.length>0){
                document.getElementById('analyseresult').innerHTML = "<p>Informatie ophalen, een ogenblik aub ...</p>";
                JMapData.getAnalyseData(wkt, themaIds, null, handleAnalyseMap);
            }else{
                
                document.getElementById('analyseresult').innerHTML =
                    "<p>Er kan geen informatie opgehaald worden, omdat er \n"+
                    "ofwel geen vlak getekend is in de kaart \n" +
                    "ofwel er geen analyseerde kaartlagen aanstaan.</p>";
            }

        } else {
            document.getElementById('analyseresult').innerHTML = "werkt alleen binnen gisviewer";
        }
    }

    function handleAnalyseMap(map) {
        if (map!=undefined){
            var result = "";
            for (var layer in map ) {
                var lresult = map [layer];
                result += "<br>";
                 for (var item in lresult) {
                    var litem = lresult [item];
                     result += litem + "<br>";
                }
            }
            document.getElementById('analyseresult').innerHTML = result;
        }else{
            document.getElementById('analyseresult').innerHTML = "Geen resultaten gevonden";
        }
    }
</script>

<div style="margin: 5px;">
<div class="analysecontainer">
    <p>
        Kies de redlining-tool en teken een vlak op de kaart. De objecten van de
    actieve kaartlagen worden geanalyseerd nadat u op de analyse knop hebt geklikt.
    </p>
    <div class="analyseoptie">
        <input type="button" value="Analyse" class="zoek_knop" id="analysedata" name="analysedata" onclick="doAjaxRequest();" />
    </div>

    <div class="analyseresult" id="analyseresult" style="height: 10px;">
        <p>Klik op knop voor analyse</p>
    </div>
</div>
</div>

