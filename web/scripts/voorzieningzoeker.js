var zoekconfiguraties = null;
var voorzieningConfigIds = null;
var inputSearchDropdown = null;
var maxResults = null;
var voorzieningConfigTypes = null;
var voorzieningConfigStraal = null;

var viewerDocument=null;
if (window.parent){
    viewerDocument=window.parent;
}else if (window.opener){
    viewerDocument=window.opener;
}

$j(document).ready(function(){
    if (window.parent){
        zoekconfiguraties = window.parent.getZoekconfiguraties();
        voorzieningConfigIds = window.parent.getVoorzieningConfigIds();
        maxResults = window.parent.getMaxResults();
        voorzieningConfigStraal = window.parent.getVoorzieningConfigStraal();
        voorzieningConfigTypes = window.parent.getVoorzieningConfigTypes();
    }

    var container=$j("#voorzieningConfigurationsContainer");
    if (zoekconfiguraties!=null) {

        var selectbox = $j('<select></select>');
        selectbox.attr("id", "voorzieningSelect");
        selectbox.change(function() {
            voorzieningConfigurationsSelectChanged($j(this));
        });

        selectbox.append($j('<option></option>').html("Maak uw keuze ...").val(""));

        for (var i=0; i < zoekconfiguraties.length; i++){
            if(showVoorzieningConfiguratie(zoekconfiguraties[i])){
                selectbox.append($j('<option></option>').html(zoekconfiguraties[i].naam).val(i));
            }
        }

        container.append("<strong>Zoek op</strong><br />");
        container.append(selectbox);
    } else {
        container.html("Geen zoekingangen geconfigureerd.");
    }

    inputSearchDropdown = selectbox;
});

function showVoorzieningConfiguratie(zoekconfiguratie){
    var visibleIds = voorzieningConfigIds.split(",");

    for (var i=0; i < visibleIds.length; i++){
        if (zoekconfiguratie.id == visibleIds[i]){
            return true;
        }
    }
    return false;
}

function showVoorzieningTypeConfiguratie(zoekconfiguratie){
    var visibleIds = voorzieningConfigTypes.split(",");

    for (var i=0; i < visibleIds.length; i++){
        if (zoekconfiguratie.id == visibleIds[i]){
            return true;
        }
    }
    return false;
}

var currentVoorzieningSelectId = "";
function voorzieningConfigurationsSelectChanged(element){
    var container=$j("#voorzieningInputFieldsContainer");

    if(!element ||element.val()==""){
        clearConfigurationsSelect(container);
        return;
    }
    currentVoorzieningSelectId=element.val();

    var zc = zoekconfiguraties[currentVoorzieningSelectId];
    var zoekVelden=zc.zoekVelden;
    fillSearchDiv(container, zoekVelden, null);
}

function clearConfigurationsSelect(container) {
    currentVoorzieningSelectId = "";
    container.html("");
}

function fillSearchDiv(container, zoekVelden, zoekStrings) {
    if (!zoekVelden){
            container.html("Geen zoekvelden");
            return container;
    }
    if (zoekStrings && zoekStrings.length!=zoekVelden.length){
            container.html("lengte van zoekvelden en te zoeken strings komt niet overeen");
            return container;
    }

    container.empty();
    for (var i=0; i < zoekVelden.length; i++){
        var zoekVeld=zoekVelden[i];
        if (zoekVeld.type==3){
            // Bepaalde typen moeten niet getoond worden zoals: Geometry (3)
            continue;
        }

        var zoekString = "*";
        if (zoekStrings) {
            zoekString = zoekStrings[i];
        }

        container.append('<strong>'+zoekVelden[i].label+':</strong><br />');
        var inputfield;

        if (zoekVeld.inputType == 1 && zoekVeld.inputZoekConfiguratie) {

            inputfield = $j('<select></select>').attr({
                id: zoekVeld.attribuutnaam, //'searchField_ ' + zoekVeld.id,
                name: zoekVeld.attribuutnaam,
                size: zoekVeld.inputSize,
                disabled: "disabled"
            });
            inputfield.append($j('<option></option>').html("Bezig met laden..."));
            container.append(inputfield).append('<br /><br />');

            //option lijst ophalen
            var optionZcId = zoekVeld.inputZoekConfiguratie;
            var optionListZc;
            for (k=0; k < zoekconfiguraties.length; k++){
                if(zoekconfiguraties[k].id == optionZcId) optionListZc = zoekconfiguraties[k];
            }
            var optionListStrings = createZoekStringsFromZoekVelden(optionListZc, zoekVelden, zoekStrings);
            var ida = new Array(1);
            ida[0] = optionListZc.id;
            JZoeker.zoek(ida, optionListStrings, maxResults, handleZoekVeldinputList);

        } else {

            inputfield = $j('<input type="text" />');
            inputfield.attr({
                id: zoekVeld.attribuutnaam, //'searchField_' + zoekVeld.id,
                name: zoekVeld.attribuutnaam,
                size: 40,
                maxlength: zoekVeld.inputSize
            }).keyup(function(ev) {
                performSearchOnEnterKey(ev);
            });
            container.append(inputfield).append('<br /><br />');

         }

        if (zoekString != "*") {
            inputfield.val(zoekString);
        }
    }

    var straalInput;
    if(voorzieningConfigStraal != ""){
        container.append('<strong>Afstand tot adres:</strong><br />');
        straalInput = $j('<select></select>');
        straalInput.attr("id", "straalSelect");

        var straalWaardes = voorzieningConfigStraal.split(",");
        for (var i=0; i < straalWaardes.length; i++){
            straalInput.append($j('<option></option>').html(straalWaardes[i]).val(straalWaardes[i]));
        }
        container.append(straalInput).append('<br /><br />');
    }

    var typeInput;
    if(voorzieningConfigTypes != ""){
        container.append('<strong>Soort voorziening:</strong><br />');
        typeInput = $j('<select></select>');
        typeInput.attr("id", "typeSelect");
        
        for (var i=0; i < zoekconfiguraties.length; i++){
            if(showVoorzieningTypeConfiguratie(zoekconfiguraties[i])){
                typeInput.append($j('<option></option>').html(zoekconfiguraties[i].naam).val(zoekconfiguraties[i].id));
            }
        }

        container.append(typeInput).append('<br /><br />');
    }

    if (zoekVelden.length > 0) {
        container.append($j('<input type="button" />').attr("value", " Zoek ").addClass("knop").click(function() {
            zoek();
        }));

        container.append($j('<input type="button" />').attr("value", " Opnieuw zoeken").addClass("knop").click(function() {
            searchConfigurationsSelectChanged(inputSearchDropdown);
        }));
    }

    $j("#voorzieningResults").empty();

    return container;
}

var currentSearchSelectId = "";
function searchConfigurationsSelectChanged(element){
    var container=$j("#voorzieningInputFieldsContainer");

    if(!element ||element.val()==""){
        clearConfigurationsSelect(container);
        return;
    }
    currentSearchSelectId=element.val();

    var zc = zoekconfiguraties[currentSearchSelectId];
    var zoekVelden=zc.zoekVelden;
    fillSearchDiv(container, zoekVelden, null);
}

function zoek(){
    document.getElementById("locatieBlok").style.display="none";
    var zoekVelden=zoekconfiguraties[currentVoorzieningSelectId].zoekVelden;
    var waarde=new Array();

    for(var i=0; i<zoekVelden.length; i++){
        var veld = $j("#"+zoekVelden[i].attribuutnaam).val();
        if (zoekVelden[i].type==0) {
            waarde[i]="*" + veld.replace(/^\s*/, "").replace(/\s*$/, "") + "*";
        } else {
            waarde[i]=veld;
        }
    }

    //showLoading();
    $j("#voorzieningResults").html("Een ogenblik geduld, de zoek opdracht wordt uitgevoerd...");

    JZoeker.zoek(zoekconfiguraties[currentVoorzieningSelectId].id,waarde,maxResults,handleLocatieSearch);
}

var gevondenLocaties=null;
function handleLocatieSearch(values){
    gevondenLocaties=values;

    document.getElementById("voorzieningBlok").style.display="none";
    document.getElementById("geenResultaatBlok").style.display="none";

    if(values.length<1){
        document.getElementById("geenLocatieBlok").style.display="block";
    }else if (values.length>1){
        document.getElementById("geenLocatieBlok").style.display="none";
        document.getElementById("locatieBlok").style.display="block";
        var locatieResultElement = document.getElementById("locatieResults");
        var sResult="<ol>";
        for (var i =0; i < values.length; i++){
            sResult += "<li><a href='#' onclick='javascript: doZoekOpdracht("+i+")'>"+values[i].label+"</a></li>";
        }
        sResult+="</ol>";
        document.getElementById("locatieResults").innerHTML=sResult;
    }else{
        doZoekOpdracht(0);
    }
}

function handleGeometryResult(adresIndex){
    if (adresIndex!=null && gevondenLocaties.length > 0){
        var straal=document.getElementById("straalSelect").value;
        var searchResult=gevondenLocaties[adresIndex];
        viewerDocument.moveToExtent(Number(searchResult.minx)-straal, Number(searchResult.miny)-straal, Number(searchResult.maxx)+straal, Number(searchResult.maxy)+straal,true);
        for (var b=0; b  < searchResult.attributen.length;  b++){
            var searchedAttribuut=searchResult.attributen[b];
            if (searchedAttribuut.type==3){
                return searchedAttribuut.waarde;
            }
        }
    }
    return "";
}

function doZoekOpdracht(adresIndex){
    document.getElementById("locatieBlok").style.display="none";
    //pak de geom
    var geom=handleGeometryResult(adresIndex);
    var waarden = new Array();
    waarden[0]=geom;
    waarden[1]=document.getElementById("straalSelect").value;

    //bepaal op welke voorziening gezocht moet worden.
    var zoekerConfigIds=document.getElementById("typeSelect").value;
    JZoeker.zoek(zoekerConfigIds,waarden,1000,handleSearchResults);
}

function handleSearchResults(results){
    document.getElementById("geenLocatieBlok").style.display="none";
    document.getElementById("geenResultaatBlok").style.display="none";

    if (results.length>0){
        document.getElementById("voorzieningBlok").style.display="block";
        var voorzieningResultElement = document.getElementById("voorzieningBlok");
        var sResult="<ol>";
        for (var i =0; i < results.length; i++){
            sResult += "<li><a href='#' onclick='javascript: moveAndIdentify("+results[i].minx+","+results[i].miny+")'>"+results[i].label+"</a></li>";
        }
        sResult+="</ol>";
        document.getElementById("voorzieningResults").innerHTML=sResult;
    }else{
        document.getElementById("voorzieningBlok").style.display="none";
        document.getElementById("geenResultaatBlok").style.display="block";
    }
}

function moveAndIdentify(x, y){
    var straal=100;
    viewerDocument.moveToExtent(Number(x)-straal, Number(y)-straal, Number(x)+straal, Number(y)+straal,true);
    viewerDocument.doIdentify(x,y,x,y);
}

function performSearchOnEnterKey(ev){
    var sourceEvent;
    if(ev)			//Moz
    {
        sourceEvent= ev.target;
    }

    if(window.event)	//IE
    {
        sourceEvent=window.event.srcElement;
    }
    var keycode;
    if(ev)			//Moz
    {
        keycode= ev.keyCode;
    }
    if(window.event)	//IE
    {
        keycode = window.event.keyCode;
    }
    if (keycode==13){
        zoek();
    }
}

function createZoekStringsFromZoekVelden(zc, zoekVelden, zoekStrings) {
    var newZoekStrings= new Array();
    if(typeof zc === 'undefined' || !zc) return newZoekStrings;

    for (var i=0; i < zc.zoekVelden.length; i++){
        // * wordt evt later dmv van inputvelden ingevuld.
        newZoekStrings[i] = "*";
        if(zoekStrings) {
            for (var b=0; b < zoekVelden.length;  b++){
                var searchedAttribuut=zoekVelden[b];
                if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.attribuutnaam && zoekStrings[b]) {
                    newZoekStrings[i]=zoekStrings[b];
                    break;
                }
                if (zc.zoekVelden[i].label == searchedAttribuut.attribuutnaam && zoekStrings[b]) {
                    newZoekStrings[i]=zoekStrings[b];
                    break;
                }
            }
        }
    }
    return newZoekStrings;
}

function handleZoekVeldinputList(list){
    if (list!=null && list.length > 0){
        var controlElementName;
        var zc = zoekconfiguraties[currentSearchSelectId];
        var optionListZc = list[0].zoekConfiguratie;
        for (var i=0; i < zc.zoekVelden.length; i++) {
            var zoekVeld=zc.zoekVelden[i];
            if (zoekVeld.inputZoekConfiguratie == optionListZc.id) {
                // controlElementName="searchField_"+zoekVeld.id;
                controlElementName = zoekVeld.attribuutnaam;
            }
        }

        // hier lijst nog filteren, zodat alleen unieke waarden erin staan
        var controlElement=document.getElementById(controlElementName);
        $j(controlElement).removeAttr("disabled");
        dwr.util.removeAllOptions(controlElementName);
        /*maak een leeg object en voeg die toe*/
        var kiesObj=new Array();
        kiesObj.push({id:" ", label: "Maak uw keuze ..."});
        dwr.util.addOptions(controlElementName,kiesObj,'id','label');

        dwr.util.addOptions(controlElementName,list,"id","label");
        //als er maar 1 zoekveld is gelijk zoeken bij selecteren dropdown.
        if (zc.zoekVelden.length==1){
            $j(controlElement).change(function(){
                $j("#searchButton").click();
            });
        }
    }
}