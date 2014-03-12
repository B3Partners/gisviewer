/*
De zoekconfiguratie wordt op 2 manieren gebruikt. Als echte zoekactie,
maar ook om opzoeklijstjes te vormen. In beide gevallen worden zoveel mogelijk
zoekvelden vooringevuld op basis van resultaatvelden van vorige zoekacties.

Zoekvelden die geen waarde hebben worden bij een normale zoekactie opgevraagd
bij de gebruiker middels een geschikte control die bij het zoekveld gedefinieerd
is.

Bij het maken van opzoeklijstjes worden de onbekende zoekvelden gevuld met een
wildkaart(*), waarmee alle mogelijkheden worden opgehaald (het opzoeklijstje).
Het is vooralsnog niet mogelijk te filteren op unieke records via het
daadwerkelijke datastore request, dus de zoeker filtert bij opzoeklijstjes
achteraf de unieke velden (klopt het we dit dus altijd gaan bij wildcard
zoekacties???). In de toekomst wordt aan de zoekconfiguratie een caching
mechanisme toegevoegd, waardoor de traagheid van WFS bij grote datasets
omzeild kan worden.

Na het uitvoeren van een zoekconfiguratie (plus eventuele extra zoekacties
voor de opzoeklijstjes) wordt gecontroleerd of de zoekactie een parent-
zoekactie heeft (dus niet child zoals nu). Hierna begint het weer van voor
af aan.
 */

/*
    document.write('<div id="searchConfigurationsContainer">&nbsp;</div>')
    document.write('<div id="searchInputFieldsContainer">&nbsp;</div>')
*/

//var B3PGissuite.config.zoekconfiguraties = [{"id":1,"zoekVelden":[{"id":1,"attribuutnaam":"fid","label":"Plannen","type":0,"naam":""}],"featureType":"app:Plangebied","resultaatVelden":[{"id":1,"attribuutnaam":"naam","label":"plan naam","type":2,"naam":"plannaam"},{"id":2,"attribuutnaam":"identificatie","label":"plan id","type":1,"naam":"planid"},{"id":3,"attribuutnaam":"verwijzingNaarTekst","label":"documenten","type":0,"naam":"documenten"},{"id":4,"attribuutnaam":"typePlan","label":"plantype","type":0,"naam":"plantype"},{"id":5,"attribuutnaam":"planstatus","label":"planstatus","type":0,"naam":"planstatus"},{"id":6,"attribuutnaam":"geometrie","label":"geometry","type":3,"naam":"geometry"}],"bron":{"id":1,"naam":"nlrpp","volgorde":1,"url":"http://afnemers.ruimtelijkeplannen.nl/afnemers/services?Version=1.0.0"},"naam":"iets"}];

var inputSearchDropdown = null;

function createSearchConfigurations(){
    var container=$j("#searchConfigurationsContainer");
    if (B3PGissuite.config.zoekconfiguraties!=null) {

        var selectbox = $j('<select></select>');
        selectbox.attr("id", "searchSelect");
        selectbox.change(function() {
            searchConfigurationsSelectChanged($j(this));
        });

        selectbox.append($j('<option></option>').html("Maak uw keuze ...").val(""));

        for (var i=0; i < B3PGissuite.config.zoekconfiguraties.length; i++){
            if(showZoekConfiguratie(B3PGissuite.config.zoekconfiguraties[i])){
                selectbox.append($j('<option></option>').html(B3PGissuite.config.zoekconfiguraties[i].naam).val(i));
            }
        }

        container.append("<strong>Zoek op</strong><br />");
        container.append(selectbox);
    } else {
        container.html("Geen zoekingangen geconfigureerd.");
    }

    inputSearchDropdown = selectbox;
}

// Roept dmv ajax een java functie aan die de coordinaten zoekt met de ingevulde zoekwaarden.
function performSearch() {
    var zoekConfig;

    var arr = B3PGissuite.config.zoekConfigIds.split(",");
    if (arr !== null && arr.length === 1) {
        currentSearchSelectId = arr[0];
    }

    zoekConfig = B3PGissuite.config.zoekconfiguraties[currentSearchSelectId];
    
    var zoekVelden=zoekConfig.zoekVelden;
    var bron = zoekConfig.bron.url;
    var searchOp = "%";
    if(bron.indexOf("http") != -1) searchOp = "*";
    var waarde=new Array();
    for(var i=0; i<zoekVelden.length; i++){
        var veld = $j("#"+zoekVelden[i].attribuutnaam).val();
        
        if(veld == undefined || veld == '') {
            waarde[i] = "";
        } else {
            if (zoekVelden[i].type==0) {
                waarde[i]=searchOp + veld.replace(/^\s*/, "").replace(/\s*$/, "") + searchOp;
            } else if (zoekVelden[i].type==80) { // XY coord

                var x = $j("#"+zoekVelden[i].id + '_x').val();
                var y = $j("#"+zoekVelden[i].id + '_y').val();

                if (x == undefined || y == undefined || x == "" || y == "") {
                    B3PGissuite.commons.messagePopup("Zoeken", "Ongeldige coordinaten opgegeven.", "error");

                    return;
                }

                x = x.replace(",", ".");
                y = y.replace(",", ".");

                waarde[i]= x+','+y;

            } else if (zoekVelden[i].type== 90) { // Schaal zoekveld
                var invoer = $j("#"+zoekVelden[i].id + '_schaal').val();
                
                if (invoer == undefined || invoer == "" || invoer <= 0) {
                    B3PGissuite.commons.messagePopup("Zoeken", "Ongeldige schaal opgegeven.", "error");

                    return;
                }

                /* reken ingevoerde schaal om naar resolutie */
                var screenWidthPx = $j("#mapcontent").width();
    
                var newMapWidth = invoer * (screenWidthPx * 0.00028);
                var res = newMapWidth / screenWidthPx;
                
                B3PGissuite.vars.webMapController.getMap().zoomToScale(res);                
            } else {
                waarde[i]=veld;
            }
        }
    }

    showTabvakLoading('Bezig met zoeken');
    $j("#searchResults").html("Een ogenblik geduld, de zoek opdracht wordt uitgevoerd...");
    
    B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
    
    JZoeker.zoek(B3PGissuite.config.zoekconfiguraties[currentSearchSelectId].id,waarde,B3PGissuite.config.maxResults,searchCallBack);
}

function handleZoekResultaat(searchResultId){
    var searchResult = foundValues[searchResultId];
    
    // Zet alle lagen aan die geconfigureerd staan bij deze zoekingang.
    switchLayersOn();
    
    var minX = searchResult.minx;
    var minY = searchResult.miny;
    var maxX = searchResult.maxx;
    var maxY = searchResult.maxy;
    
    //zoom naar het gevonden object.(als er een bbox is)
    if (minX != 0 && minY != 0 && maxX != 0 && maxY) {
        moveToExtent(minX, minY, maxX, maxY);
        
        var x = (maxX + minX) / 2;        
        var y = (maxY + minY) / 2;        
        
        B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
        B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", x,y);
    
        doIdentifyAfterSearch(x, y);
    }
    
    //kijk of de zoekconfiguratie waarmee de zoekopdracht is gedaan een ouder heeft.
    var zoekConfiguratie=searchResult.zoekConfiguratie;
    var parentZc = zoekConfiguratie.parentZoekConfiguratie;
    if (parentZc == null){
        return false;
    }

    if (parentZc.zoekVelden==undefined || parentZc.zoekVelden.length==0){

        var msg = "Geen zoekvelden geconfigureerd voor zoekconfiguratie parent met id: "+parentZc.id;
        B3PGissuite.commons.messagePopup("Zoeken", msg, "error");

        return false;
    }

    for (var i=0; i < B3PGissuite.config.zoekconfiguraties.length; i++){
        if(B3PGissuite.config.zoekconfiguraties[i].id == parentZc.id) {
            currentSearchSelectId = i;
        }
    }
    parentZc = B3PGissuite.config.zoekconfiguraties[currentSearchSelectId];

    // Doe de volgende zoekopdracht
    var zoekStrings = createZoekStringsFromZoekResultaten(parentZc, searchResult);
    //
    // toon de gevonden invoervelden en creeer inputboxen voor de strings met
    // een * want die moeten nog ingevuld worden.
    fillSearchDiv($j("#searchInputFieldsContainer"), parentZc.zoekVelden, zoekStrings);

    return false;
}

// Maak een volgende zoekopdracht voor de ouder.
// vergelijk de gevondenAttributen met de zoekvelden van het kind.
// Als het type gelijk is van beide vul dan de gevonden waarde in voor het zoekveld.
function createZoekStringsFromZoekResultaten(zc, zoekResultaten) {
    var newZoekStrings= new Array();
    if(typeof zc === 'undefined' || !zc) return newZoekStrings;
    for (var i=0; i < zc.zoekVelden.length; i++){
        // * wordt evt later dmv van inputvelden ingevuld.
        newZoekStrings[i] = "*";
        for (var b=0; b < zoekResultaten.attributen.length;  b++){
            var searchedAttribuut=zoekResultaten.attributen[b];
            if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.attribuutnaam) {
                newZoekStrings[i]=searchedAttribuut.waarde;
                break;
            }
            if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.label) {
                newZoekStrings[i]=searchedAttribuut.waarde;
                break;
            }
        }
    }
    return newZoekStrings;
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

// De callback functie van het zoeken
// @param values = de gevonden lijst met waarden.
var foundValues=null;
function searchCallBack(values){
    hideTabvakLoading();

    foundValues=values;
    var searchResults=$j("#searchResults");

    if (values==null || values.length == 0) {
        searchResults.html("<br /><strong>Er zijn geen resultaten gevonden!</strong>");
        return;
    }

    // Controleer of de bbox groter is dan de minimale bbox van de zoeker
    for (var i=0; i < values.length; i++){
        if (values[i].minx != 0 && values[i].miny != 0 && values[i].maxx != 0 && values[i].maxy) {
            values[i]=B3PGissuite.viewercommons.getBboxMinSize2(values[i]);
        }
    }

    var ollist = $j("<ol></ol>");
    for (var j = 0; j < values.length; j++){
        (function(tmp){
            var li = $j('<li></li>');
            var link = $j('<a></a>').attr("href", "#").html(values[tmp].label).click(function() {
                handleZoekResultaat(tmp);
            });
            ollist.append(li.append(link));
        })(j);
    }
    searchResults.empty().append(ollist);
    
    if (values.length==1) {
        handleZoekResultaat(0);
        return;
    }

}
var zoekconfiguratieThemas = null;
function zoekconfiguratieThemasCallBack(themaIds){
    zoekconfiguratieThemas = new Array();
    for ( var i = 0 ; i < themaIds.length ;i++ ){
        var themaId = themaIds[i];
        zoekconfiguratieThemas.push(themaId);
    }
}

function switchLayersOn(){
    var treeComponent = B3PGissuite.get('TreeComponent');
    if(zoekconfiguratieThemas && treeComponent !== null){
        for ( var i = 0 ; i < zoekconfiguratieThemas.length ;i++ ){
            var themaId = zoekconfiguratieThemas[i];
            treeComponent.enableCheckBoxById(themaId);
        }
    }
}

var currentSearchSelectId = "";
function searchConfigurationsSelectChanged(element){
    var container = $j("#searchInputFieldsContainer");
    
    if(!element ||element.val() == "") {
        clearConfigurationsSelect(container);
        var resultsContainer=$j("#searchResults");
        clearConfigurationsSelect(resultsContainer);
        return;
    }
    
    currentSearchSelectId = element.val();
    
    var zc = B3PGissuite.config.zoekconfiguraties[currentSearchSelectId];
    JZoekconfiguratieThemaUtil.getThemas(zc.id,zoekconfiguratieThemasCallBack);
    var zoekVelden=zc.zoekVelden;
    fillSearchDiv(container, zoekVelden, null);
}

function clearConfigurationsSelect(container) {
    currentSearchSelectId = "";
    container.html("");
    B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
    zoekconfiguratieThemas = null;
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

        var zoekString = "*";
        if (zoekStrings) {
            zoekString = zoekStrings[i];
        }

        if (zoekVeld.type==3){
            // Bepaalde typen moeten niet getoond worden zoals: Geometry (3)
            var inputfield = $j('<input type="hidden" />');
            inputfield.attr({
                id: zoekVeld.attribuutnaam, //'searchField_' + zoekVeld.id,
                name: zoekVeld.attribuutnaam
            });
            if (zoekString != "*") {
                inputfield.val(zoekString);
            }
            container.append(inputfield);
            continue;
        }

        if (zoekVeld.type != 110) {
            container.append('<strong>'+zoekVelden[i].label+':</strong><br />');
        }
        
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
            for (k=0; k < B3PGissuite.config.zoekconfiguraties.length; k++){
                if(B3PGissuite.config.zoekconfiguraties[k].id == optionZcId) optionListZc = B3PGissuite.config.zoekconfiguraties[k];
            }
            var optionListStrings = createZoekStringsFromZoekVelden(optionListZc, zoekVelden, zoekStrings);
            var ida = new Array(1);
            ida[0] = optionListZc.id;
            JZoeker.zoek(ida, optionListStrings, B3PGissuite.config.maxResults, handleZoekVeldinputList);

        }else if (zoekVeld.inputType == 3 && zoekVeld.inputZoekConfiguratie) {
            inputfield = $j('<input type="text" />');
            inputfield.attr({
                id: zoekVeld.attribuutnaam, //'searchField_' + zoekVeld.id,
                name: zoekVeld.attribuutnaam,
                size: 40,
                maxlength: zoekVeld.inputSize
            }).keyup(function(ev) {
                performSearchOnEnterKey(ev);
            });

            var zoekUrl="viewer/SearchAutocomplete.do?zoekConfiguratieId="+zoekVeld.inputZoekConfiguratie+"&maxResults=10";
            if (zoekVelden.length==1){
                inputfield.autocomplete({
                    minLength: 2,
                    source: zoekUrl,
                    select: function(event, ui){
                        this.value=ui.item.value;
                        $j("#zoekKnop").click();
                    }
                });
            }else{
                inputfield.autocomplete({
                    minLength: 2,
                    source: zoekUrl
                });
            }
            container.append(inputfield).append('<br /><br />');

        } else {

            /* XY coord type */
            if (zoekVeld.type == 80) {

                inputfield = $j('<input type="text" />');
                inputfield.attr({
                    id: zoekVeld.id + '_x',
                    name: zoekVeld.id + '_x',
                    size: '15',
                    maxlength: '10' //zoekVeld.inputSize
                }).keyup(function(ev) {
                    performSearchOnEnterKey(ev);
                });
                container.append(inputfield).append('<br/><br/>');

                inputfield = $j('<input type="text" />');
                inputfield.attr({
                    id: zoekVeld.id + '_y',
                    name: zoekVeld.id + '_y',
                    size: '15',
                    maxlength: '10' //zoekVeld.inputSize
                }).keyup(function(ev) {
                    performSearchOnEnterKey(ev);
                });
                container.append(inputfield).append('<br/><br/>');

            } else if (zoekVeld.type == 90) {
                
                inputfield = $j('<input type="text" />');
                inputfield.attr({
                    id: zoekVeld.id + '_schaal',
                    name: zoekVeld.id + '_schaal',
                    size: '15',
                    maxlength: '10' //zoekVeld.inputSize
                }).keyup(function(ev) {
                    performSearchOnEnterKey(ev);
                });
                container.append(inputfield).append('<br/><br/>');
                
            /* Invoer is geom voor afstand berekening */
            } else if (zoekVeld.type == 110) {                
                inputfield = $j('<input type="hidden" />');
                inputfield.attr({
                    id: zoekVeld.attribuutnaam,
                    name: zoekVeld.attribuutnaam,
                    size: 40,
                    maxlength: zoekVeld.inputSize
                }).keyup(function(ev) {
                    performSearchOnEnterKey(ev);
                });

                container.append(inputfield).append('<br /><br />');
                
            /* indien straal search veld met dropdown type dan met komma gescheiden 
             * waardes vullen */
            } else if (zoekVeld.inputZoekConfiguratie == null && zoekVeld.inputType == 1 && zoekVeld.dropDownValues) {                
                inputfield = $j('<select></select>').attr({
                    id: zoekVeld.attribuutnaam, //'searchField_ ' + zoekVeld.id,
                    name: zoekVeld.attribuutnaam,
                    size: 1
                });
                
                var straalValues = zoekVeld.dropDownValues;
                var straalArray = straalValues.split(",");
                
                for (var n = 0; n < straalArray.length; n++) {
                    inputfield.append($j('<option></option>').html(straalArray[n]));
                }
                
                container.append(inputfield).append('<br /><br />');
                
             } else if (zoekVeld.type == 100 && zoekVeld.inputType == 2) {                
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
            
        }

        if (zoekString != "*") {
            inputfield.val(zoekString);
        }
    }

    if (zoekVelden.length > 0) {
        container.append($j('<input type="button" />').attr("value", " Zoek ").attr("id","searchButton").addClass("knop").click(function() {
            performSearch();
        }));

        var arr = B3PGissuite.config.zoekConfigIds.split(",");
        if (arr !== null && arr.length > 1) {
            container.append($j('<input type="button" />').attr("value", " Reset").addClass("knop").click(function() {
                B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
                
                searchConfigurationsSelectChanged(inputSearchDropdown);
            }));
        } 
        
        if (!B3PGissuite.config.search && B3PGissuite.config.startLocationX == "" && B3PGissuite.config.startLocationY == "") {
            container.append($j('<input type="button" />').attr("value", " Verwijder marker").addClass("knop").click(function() {
                B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
            }));
        }
    }

    $j("#searchResults").empty();

    return container;
}

function handleZoekVeldinputList(list){
    if (list!=null && list.length > 0){
        var controlElementName;
        var zc = B3PGissuite.config.zoekconfiguraties[currentSearchSelectId];        
        var optionListZc = list[0].zoekConfiguratie;
        if (zc){
            for (var i=0; i < zc.zoekVelden.length; i++) {
                var zoekVeld=zc.zoekVelden[i];
                if (zoekVeld.inputZoekConfiguratie == optionListZc.id) {
                    // controlElementName="searchField_"+zoekVeld.id;
                    controlElementName = zoekVeld.attribuutnaam;
                }
            }
        }

        // hier lijst nog filteren, zodat alleen unieke waarden erin staan
        var controlElement=document.getElementById(controlElementName);
        $j(controlElement).removeAttr("disabled");
        dwr.util.removeAllOptions(controlElementName);
        /*maak een leeg object en voeg die toe*/
        var kiesObj=new Array();
        kiesObj.push({
            id:" ", 
            label: "Maak uw keuze ..."
        });        
        dwr.util.addOptions(controlElementName,kiesObj,'id','label');

        /* List label waarde afkappen op aantal tekens. Gedaan zodat dropdown
         * met lange waardes niet rechts buiten het scherm vallen */
        for (var j=0; j < list.length; j++) {
            var waarde = list[j].label;
            
            if (waarde.length > 45) {
                list[j].label = waarde.substring(0, 45) + '...';
            }
        }        
        
        dwr.util.addOptions(controlElementName,list,"id","label");
        //als er maar 1 zoekveld is gelijk zoeken bij selecteren dropdown.
        if (zc && zc.zoekVelden.length==1){
            $j(controlElement).change(function(){
                $j("#searchButton").click();
            });
        }
    }
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
        performSearch();
    }
}

function showZoekConfiguratie(zoekconfiguratie){
    var visibleIds = B3PGissuite.config.zoekConfigIds.split(",");
    for (var i=0; i < visibleIds.length; i++){
        if (zoekconfiguratie.id == visibleIds[i]){
            return true;
        }
    }
    return false;
}

function setZoekconfiguratieWithId(id){
    for (var i=0; i < B3PGissuite.config.zoekconfiguraties.length; i++){
        if (B3PGissuite.config.zoekconfiguraties[i].id === id){
            currentSearchSelectId = i;
            return B3PGissuite.config.zoekconfiguraties[i];
        }
    }
}