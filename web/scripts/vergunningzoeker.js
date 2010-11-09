var zoekconfiguraties = null;
var vergunningConfigIds = null;
var inputSearchDropdown = null;
var maxResults = null;
var vergunningConfigTypes = null;
var vergunningConfigStraal = null;

var viewerDocument=null;
if (window.parent){
    viewerDocument=window.parent;
}else if (window.opener){
    viewerDocument=window.opener;
}

$j(document).ready(function(){
    if (window.parent){
        zoekconfiguraties = window.parent.getZoekconfiguraties();
        vergunningConfigIds = window.parent.getVergunningConfigIds();
        maxResults = window.parent.getMaxResults();
        vergunningConfigStraal = window.parent.getVergunningConfigStraal();
        vergunningConfigTypes = window.parent.getVergunningConfigTypes();
    }

    var container=$j("#vergunningConfigurationsContainer");
    if (zoekconfiguraties!=null) {

        var selectbox = $j('<select></select>');
        selectbox.attr("id", "vergunningSelect");
        selectbox.change(function() {
            vergunningConfigurationsSelectChanged($j(this));
        });

        selectbox.append($j('<option></option>').html("Maak uw keuze ...").val(""));

        for (var i=0; i < zoekconfiguraties.length; i++){
            if(showVergunningConfiguratie(zoekconfiguraties[i])){
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

function showVergunningConfiguratie(zoekconfiguratie){
    var visibleIds = vergunningConfigIds.split(",");

    for (var i=0; i < visibleIds.length; i++){
        if (zoekconfiguratie.id == visibleIds[i]){
            return true;
        }
    }
    return false;
}

function showVergunningTypeConfiguratie(zoekconfiguratie){
    var visibleIds = vergunningConfigTypes.split(",");

    for (var i=0; i < visibleIds.length; i++){
        if (zoekconfiguratie.id == visibleIds[i]){
            return true;
        }
    }
    return false;
}

var currentVergunningSelectId = "";
function vergunningConfigurationsSelectChanged(element){
    var container=$j("#vergunningInputFieldsContainer");
    var container2=$j("#buttonContainer");
    container2.html("");

    if(!element ||element.val()==""){
        clearConfigurationsSelect(container);
        return;
    }
    currentVergunningSelectId=element.val();

    var zc = zoekconfiguraties[currentVergunningSelectId];
    var zoekVelden=zc.zoekVelden;
    fillSearchDiv(container, zoekVelden, null);
}

var currentVergunningSelectType = "";
function vergunningTypeConfigurationsSelectChanged(element){
    var container=$j("#typeInputFieldsContainer");

    if(!element ||element.val()==""){
        clearConfigurationsTypeSelect(container);
        return;
    }
    currentVergunningSelectType=element.val();

    var zc = zoekconfiguraties[currentVergunningSelectType];
    var zoekVelden=zc.zoekVelden;
    fillSearchTypeDiv(container, zoekVelden, null);
}

function clearConfigurationsSelect(container) {
    currentVergunningSelectType = "";
    container.html("");
}

function clearConfigurationsTypeSelect(container) {
    currentVergunningSelectId = "";
    container.html("");
}

function fillSearchTypeDiv(container, zoekVelden, zoekStrings) {
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

        if (zoekVeld.type==100){
            // Bepaalde typen moeten niet getoond worden zoals: Straal (100)
            continue;
        }

        var zoekString = "*";
        if (zoekStrings) {
            zoekString = zoekStrings[i];
        }

        container.append('<strong>'+zoekVelden[i].label+':</strong><br />');
        var inputfield;

        if (zoekVeld.inputType == 1 && zoekVeld.inputType == 100) {

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
                id: zoekVeld.label, //.attribuutnaam, //'searchField_' + zoekVeld.id,
                name: zoekVeld.label, //.attribuutnaam,
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
    if(vergunningConfigStraal != ""){
        container.append('<strong>Straal:</strong><br />');
        straalInput = $j('<select></select>');
        straalInput.attr("id", "Straal");

        var straalWaardes = vergunningConfigStraal.split(",");
        for (var i=0; i < straalWaardes.length; i++){
            straalInput.append($j('<option></option>').html(straalWaardes[i]).val(straalWaardes[i]));
        }
        container.append(straalInput).append('<br /><br />');
    }

    var typeInput;
    if(vergunningConfigTypes != ""){
        container.append('<strong>Type:</strong><br />');
        typeInput = $j('<select></select>');
        typeInput.attr("id", "typeSelect");

        typeInput.change(function() {
            vergunningTypeConfigurationsSelectChanged($j(this));
        });

        for (var i=0; i < zoekconfiguraties.length; i++){
            if(showVergunningTypeConfiguratie(zoekconfiguraties[i])){
                typeInput.append($j('<option></option>').html(zoekconfiguraties[i].naam).val(i));
            }
        }

        container.append(typeInput).append('<br /><br />');
    }
    vergunningTypeConfigurationsSelectChanged(typeInput);

    var container2=$j("#buttonContainer");
    if (zoekVelden.length > 0) {
        container2.append($j('<input type="button" />').attr("value", " Zoek ").addClass("knop").click(function() {
            zoek();
        }));

        container2.append($j('<input type="button" />').attr("value", " Opnieuw zoeken").addClass("knop").click(function() {
            vergunningConfigurationsSelectChanged(inputSearchDropdown);
        }));
    }

    $j("#vergunningResults").empty();

    return container;
}

function zoek(){
    document.getElementById("locatieBlok").style.display="none";
    var zoekVelden=zoekconfiguraties[currentVergunningSelectId].zoekVelden;
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
    $j("#vergunningResults").html("Een ogenblik geduld, de zoek opdracht wordt uitgevoerd...");

    JZoeker.zoek(zoekconfiguraties[currentVergunningSelectId].id,waarde,maxResults,handleLocatieSearch);
}

var gevondenLocaties=null;
function handleLocatieSearch(values){
    gevondenLocaties=values;

    document.getElementById("vergunningBlok").style.display="none";
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
        var straal=document.getElementById("Straal").value;
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

    var zoekerConfigIds=new Array();
    var vergunningsType=document.getElementById("typeSelect").value;

    var typeId = getSearchCinfigId(vergunningsType);

    var zoekconfig = zoekconfiguraties[vergunningsType];

    var waarden = new Array();
    
    waarden[0]="";
    waarden[1]="";
    waarden[2]="";
    waarden[3]="";
    waarden[4]="";
    waarden[5]="";
    waarden[6]="";
    waarden[7]="";
    waarden[8]="";
    waarden[9]="";
    waarden[10]="";

    var zoekvelden = zoekconfig.zoekVelden;
    for(var i = 0; i < zoekvelden.length; i++ ){
        var label = zoekvelden[i].label;
        if(label != "Geometry"){
            if(zoekvelden[i].type == 0){
                waarden[i] = "*"+document.getElementById(label).value+"*";
            }else{
                waarden[i] = document.getElementById(label).value;
            }
        }else{
            waarden[i]=geom;
        }
    }
    
    if (typeId==""){
        zoekerConfigIds[0]=1;
        zoekerConfigIds[0]=2;
        waarden[10]="";
    }else{
        zoekerConfigIds[0]=typeId;
        if(typeId == 1){
            waarden[10]="*Milieu*";
        }else if(typeId == 2){
            waarden[10]="*Bouwen*";
        }
    }
    JZoeker.zoek(zoekerConfigIds,waarden,1000,handleSearchResults);
}

function getSearchCinfigId(pos){
    var ids = vergunningConfigTypes.split(",");

    return zoekconfiguraties[pos].id;
}

function handleSearchResults(results){
    document.getElementById("geenLocatieBlok").style.display="none";
    document.getElementById("geenResultaatBlok").style.display="none";

    if (results.length>0){
        document.getElementById("vergunningBlok").style.display="block";
        var vergunningResultElement = document.getElementById("vergunningBlok");
        var sResult="<ol>";
        for (var i =0; i < results.length; i++){
            sResult += "<li><a href='#' onclick='javascript: moveAndIdentify("+results[i].minx+","+results[i].miny+")'>"+results[i].label+"</a></li>";
        }
        sResult+="</ol>";
        document.getElementById("vergunningResults").innerHTML=sResult;
    }else{
        document.getElementById("vergunningBlok").style.display="none";
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