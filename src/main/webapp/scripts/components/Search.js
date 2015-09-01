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

B3PGissuite.defineComponent('Search', {

    singleton: true,

    inputSearchDropdown: null,
    foundValues: null,
    zoekconfiguratieThemas: null,
    currentSearchSelectId: "",

    constructor: function Search() {
        this.init();
    },

    init: function() {},

    /**
     * Uses a search configuration and search params in the url. Is done when searching via url
     * params and is called when the viewer (framework) is loaded.
     */
    doInitSearch: function() {
        var me = this;
        if (B3PGissuite.config.searchConfigId.length > 0 && B3PGissuite.config.search.length >= 0) {
            B3PGissuite.commons.showLoading();

            var termen = B3PGissuite.config.search.split(",");

            if (termen && termen.length > 0 && termen[0] !== "") {
                JZoeker.zoek( [ B3PGissuite.config.searchConfigId ], termen, 0, function(list) {
                    me.handleInitSearch(list);
                });
            } else {
                B3PGissuite.commons.hideLoading();
            }
        }
    },

    /**
     * Callback method used in doInitSearch() function. This function hides the loading
     * screen and calls the handleInitSearchResult() method for further handling.
     * @param list List with search results from back-end.
     */
    handleInitSearch: function(list) {
        B3PGissuite.commons.hideLoading();
        if (list && list.length > 0) {
            this.handleInitSearchResult(list[0], B3PGissuite.config.searchAction, B3PGissuite.config.searchId, B3PGissuite.config.searchClusterId, B3PGissuite.config.searchSldVisibleValue);
        }
    },

    /**
     * Handles the search results from the back-end. It performs the given action.
     * @param result List with search results.
     * @param action The search action to perform (zoom, highlight or filter)
     * @param themaId Adds this value as themaId parameter for the SLD options.
     * @param clusterId Adds this value as clusterId parameter for the SLD options.
     * @param visibleValue Displays this value for the result. If none is provided
     * the result id is displayed instead.
     */
    handleInitSearchResult: function(result, action, themaId, clusterId, visibleValue) {
        var doZoom = true;
        var doHighlight = false;
        var doFilter = false;
        var me = this;

        if (B3PGissuite.config.searchAction) {
            if (B3PGissuite.config.searchAction.toLowerCase().indexOf("zoom") == -1)
                doZoom = false;
            if (B3PGissuite.config.searchAction.toLowerCase().indexOf("highlight") >= 0)
                doHighlight = true;
            else if (B3PGissuite.config.searchAction.toLowerCase().indexOf("filter") >= 0)
                doFilter = true;
        }

        if (doHighlight || doFilter) {
            var sldOptions = "";
            var visval = null;
            if (visibleValue)
                visval = visibleValue;
            else if (result.id)
                visval = result.id;
            else
                visval = B3PGissuite.config.search;
            if (visval !== null) {
                sldOptions += sldOptions.indexOf("?") >= 0 ? "&" : "?";
                sldOptions += "visibleValue=" + visval;
            }
            if (themaId) {
                sldOptions += sldOptions.indexOf("?") >= 0 ? "&" : "?";
                sldOptions += "themaId=" + themaId;
            }
            if (clusterId) {
                sldOptions += sldOptions.indexOf("?") >= 0 ? "&" : "?";
                sldOptions += "clusterId=" + clusterId;
            }
            sldOptions += sldOptions.indexOf("?") >= 0 ? "&" : "?";
            if (doHighlight) {
                sldOptions += "sldType=UserStyle";
            }
            if (doFilter) {
                sldOptions += "sldType=NamedStyle";
            }
            var sldUrl = B3PGissuite.config.sldServletUrl + sldOptions;
            if (B3PGissuite.vars.mapInitialized) {
                B3PGissuite.viewerComponent.setSldOnDefaultMap(sldUrl, true);
            }
        }

        /* Place marker */
        result = B3PGissuite.viewercommons.getBboxMinSize2(result);
        var x = (result.maxx - result.minx) / 2 + result.minx;
        var y = (result.maxy - result.miny) / 2 + result.miny;

        this.placeSearchResultMarker(x, y);
        B3PGissuite.get('Layout').switchTab("zoeken");

        /* Lagen aanzetten na zoeken */
        JZoekconfiguratieThemaUtil.getThemas(B3PGissuite.config.searchConfigId, function(data) {
            me.zoekconfiguratieThemasCallBack(data);
            me.switchLayersOn();
            if (doZoom) {
                result = B3PGissuite.viewercommons.getBboxMinSize2(result);
                var ext = {};
                ext.minx = result.minx;
                ext.miny = result.miny;
                ext.maxx = result.maxx;
                ext.maxy = result.maxy;
                if (B3PGissuite.vars.mapInitialized) {
                    B3PGissuite.viewerComponent.moveToExtent(ext.minx, ext.miny, ext.maxx, ext.maxy);
                } else {
                    B3PGissuite.vars.searchExtent = ext;
                }
            }
        });
    },

    placeSearchResultMarker: function(x, y) {
        B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", x, y);
    },

    removeSearchResultMarker: function() {
        B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
    },

    createSearchConfigurations: function() {
        var me = this, container = $j("#searchConfigurationsContainer");
        if (B3PGissuite.config.zoekconfiguraties !== null) {

            var selectbox = $j('<select></select>');
            selectbox.attr("id", "searchSelect");
            selectbox.change(function() {
                me.searchConfigurationsSelectChanged($j(this));
            });

            selectbox.append($j('<option></option>').html("Maak uw keuze ...").val(""));

            for (var i = 0; i < B3PGissuite.config.zoekconfiguraties.length; i++) {
                if (this.showZoekConfiguratie(B3PGissuite.config.zoekconfiguraties[i])) {
                    selectbox.append($j('<option></option>').html(B3PGissuite.config.zoekconfiguraties[i].naam).val(i));
                }
            }

            container.append("<strong>Zoek op</strong><br />");
            container.append(selectbox);

            this.inputSearchDropdown = selectbox;
        } else {
            container.html("Geen zoekingangen geconfigureerd.");
        }
    },

    // Roept dmv ajax een java functie aan die de coordinaten zoekt met de ingevulde zoekwaarden.
    performSearch: function() {
        var me = this, zoekConfig;

        var arr = B3PGissuite.config.zoekConfigIds.split(",");
        if (arr !== null && arr.length === 1) {
            this.currentSearchSelectId = arr[0];

            /* Indien maar 1 zoekingang ingesteld zitten in zoekconfiguraties
             * nog steeds alle Objecten. currentSearchSelectId komt dan niet meer 
             * overeen met index waar het juiste Zoekingan Object zit.
             * TODO: Hoe gaat dit bij meertrapzoeker ?
            */
            var len = B3PGissuite.config.zoekconfiguraties.length;
            for (var j = 0; j < len; j++) {
                if (arr[0] == B3PGissuite.config.zoekconfiguraties[j].id) {
                    zoekConfig = B3PGissuite.config.zoekconfiguraties[j];
                    this.currentSearchSelectId = j;
                }
            }

        } else {
            zoekConfig = B3PGissuite.config.zoekconfiguraties[this.currentSearchSelectId];
        }

        var zoekVelden = zoekConfig.zoekVelden;
        var searchOp = "%";
        if (zoekConfig.bron) {
            var bron = zoekConfig.bron.url;
            if (bron.indexOf("http") != -1) {
                searchOp = "*";
            }
        }
        var waarde = [];
        for (var i = 0; i < zoekVelden.length; i++) {
            var veld = $j("#" + zoekVelden[i].attribuutnaam).val();

            if (zoekVelden[i].type == 80) { // XY coord

                var x = $j("#" + zoekVelden[i].id + '_x').val();
                var y = $j("#" + zoekVelden[i].id + '_y').val();

                if (x === undefined || y === undefined || x === "" || y === "") {
                    B3PGissuite.commons.messagePopup("Zoeken", "Ongeldige coordinaten opgegeven.", "error");

                    return;
                }

                x = x.replace(",", ".");
                y = y.replace(",", ".");

                waarde[i] = x + ',' + y;
                
            } else if (zoekVelden[i].type == 90) { // Schaal zoekveld
                var invoer = $j("#" + zoekVelden[i].id + '_schaal').val();

                if (invoer === undefined || invoer === "" || invoer <= 0) {
                    B3PGissuite.commons.messagePopup("Zoeken", "Ongeldige schaal opgegeven.", "error");
                    return;
                }

                /* reken ingevoerde schaal om naar resolutie */
                var screenWidthPx = $j("#mapcontent").width();

                var newMapWidth = invoer * (screenWidthPx * 0.00028);
                var res = newMapWidth / screenWidthPx;

                B3PGissuite.vars.webMapController.getMap().zoomToScale(res);

            } else if (veld === undefined || veld === '') {

                waarde[i] = "";

            } else {

                if (zoekVelden[i].type === 0) {
                    waarde[i] = searchOp + veld.replace(/^\s*/, "").replace(/\s*$/, "") + searchOp;
                } else {
                    waarde[i] = veld;
                }

            }
        }

        B3PGissuite.get('Layout').showTabvakLoading('Bezig met zoeken');
        $j("#searchResults").html("Een ogenblik geduld, de zoek opdracht wordt uitgevoerd...");

        B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");

        JZoeker.zoek(B3PGissuite.config.zoekconfiguraties[this.currentSearchSelectId].id, waarde, B3PGissuite.config.maxResults, function(values) {
            me.searchCallBack(values);
        });
    },

    handleZoekResultaat: function(searchResultId) {
        var searchResult = this.foundValues[searchResultId];

        // Zet alle lagen aan die geconfigureerd staan bij deze zoekingang.
        this.switchLayersOn();

        var minX = searchResult.minx;
        var minY = searchResult.miny;
        var maxX = searchResult.maxx;
        var maxY = searchResult.maxy;

        //zoom naar het gevonden object.(als er een bbox is)
        if (minX !== 0 && minY !== 0 && maxX !== 0 && maxY) {
            B3PGissuite.viewerComponent.moveToExtent(minX, minY, maxX, maxY);

            var x = (maxX + minX) / 2;
            var y = (maxY + minY) / 2;

            B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
            B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", x, y);

            B3PGissuite.viewerComponent.doIdentifyAfterSearch(x, y);
        }

        //kijk of de zoekconfiguratie waarmee de zoekopdracht is gedaan een ouder heeft.
        var zoekConfiguratie = searchResult.zoekConfiguratie;
        var parentZc = zoekConfiguratie.parentZoekConfiguratie;
        if (parentZc === null) {
            return false;
        }

        if ((parentZc.zoekVelden === undefined || parentZc.zoekVelden === null) || parentZc.zoekVelden.length === 0) {

            var msg = "Geen zoekvelden geconfigureerd voor zoekconfiguratie parent met id: " + parentZc.id;
            B3PGissuite.commons.messagePopup("Zoeken", msg, "error");

            return false;
        }

        for (var i = 0; i < B3PGissuite.config.zoekconfiguraties.length; i++) {
            if (B3PGissuite.config.zoekconfiguraties[i].id == parentZc.id) {
                this.currentSearchSelectId = i;
            }
        }
        parentZc = B3PGissuite.config.zoekconfiguraties[this.currentSearchSelectId];

        // Doe de volgende zoekopdracht
        var zoekStrings = this.createZoekStringsFromZoekResultaten(parentZc, searchResult);
        //
        // toon de gevonden invoervelden en creeer inputboxen voor de strings met
        // een * want die moeten nog ingevuld worden.
        this.fillSearchDiv($j("#searchInputFieldsContainer"), parentZc.zoekVelden, zoekStrings);

        return false;
    },

    // Maak een volgende zoekopdracht voor de ouder.
    // vergelijk de gevondenAttributen met de zoekvelden van het kind.
    // Als het type gelijk is van beide vul dan de gevonden waarde in voor het zoekveld.
    createZoekStringsFromZoekResultaten: function(zc, zoekResultaten) {
        var newZoekStrings = [];
        if (typeof zc === 'undefined' || !zc)
            return newZoekStrings;
        for (var i = 0; i < zc.zoekVelden.length; i++) {
            // * wordt evt later dmv van inputvelden ingevuld.
            newZoekStrings[i] = "*";
            for (var b = 0; b < zoekResultaten.attributen.length; b++) {
                var searchedAttribuut = zoekResultaten.attributen[b];
                if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.attribuutnaam) {
                    newZoekStrings[i] = searchedAttribuut.waarde;
                    break;
                }
                if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.label) {
                    newZoekStrings[i] = searchedAttribuut.waarde;
                    break;
                }
            }
        }
        return newZoekStrings;
    },

    createZoekStringsFromZoekVelden: function(zc, zoekVelden, zoekStrings) {
        var newZoekStrings = [];
        if (typeof zc === 'undefined' || !zc)
            return newZoekStrings;

        for (var i = 0; i < zc.zoekVelden.length; i++) {
            // * wordt evt later dmv van inputvelden ingevuld.
            newZoekStrings[i] = "*";
            if (zoekStrings) {
                for (var b = 0; b < zoekVelden.length; b++) {
                    var searchedAttribuut = zoekVelden[b];
                    if (zc.zoekVelden[i].attribuutnaam == searchedAttribuut.attribuutnaam && zoekStrings[b]) {
                        newZoekStrings[i] = zoekStrings[b];
                        break;
                    }
                    if (zc.zoekVelden[i].label == searchedAttribuut.attribuutnaam && zoekStrings[b]) {
                        newZoekStrings[i] = zoekStrings[b];
                        break;
                    }
                }
            }
        }
        return newZoekStrings;
    },

    // De callback functie van het zoeken
    // @param values = de gevonden lijst met waarden.
    searchCallBack: function(values) {
        var me = this;
        B3PGissuite.get('Layout').hideTabvakLoading();

        this.foundValues = values;
        var searchResults = $j("#searchResults");

        if (values === null || values.length === 0) {
            searchResults.html("<br /><strong>Er zijn geen resultaten gevonden!</strong>");
            return;
        }

        // Controleer of de bbox groter is dan de minimale bbox van de zoeker
        for (var i = 0; i < values.length; i++) {
            if (values[i].minx !== 0 && values[i].miny !== 0 && values[i].maxx !== 0 && values[i].maxy) {
                values[i] = B3PGissuite.viewercommons.getBboxMinSize2(values[i]);
            }
        }

        var ollist = $j("<ol></ol>");
        for (var j = 0; j < values.length; j++) {
            (function(tmp) {
                var li = $j('<li></li>');
                var link = $j('<a></a>').attr("href", "#").html(values[tmp].label).click(function() {
                    me.handleZoekResultaat(tmp);
                });
                ollist.append(li.append(link));
            })(j);
        }
        searchResults.empty().append(ollist);

        if (values.length == 1) {
            me.handleZoekResultaat(0);
            return;
        }

    },

    zoekconfiguratieThemasCallBack: function(themaIds) {
        this.zoekconfiguratieThemas = [];
        for (var i = 0; i < themaIds.length; i++) {
            var themaId = themaIds[i];
            this.zoekconfiguratieThemas.push(themaId);
        }
    },

    switchLayersOn: function() {
        var treeComponent = B3PGissuite.get('TreeTabComponent');
        if (this.zoekconfiguratieThemas && treeComponent !== null) {
            for (var i = 0; i < this.zoekconfiguratieThemas.length; i++) {
                var themaId = this.zoekconfiguratieThemas[i];
                treeComponent.enableCheckBoxById(themaId);
            }
        }
    },

    searchConfigurationsSelectChanged: function(element) {
        var me = this, container = $j("#searchInputFieldsContainer");

        if (!element || element.val() === "") {
            this.clearConfigurationsSelect(container);
            var resultsContainer = $j("#searchResults");
            this.clearConfigurationsSelect(resultsContainer);
            return;
        }

        this.currentSearchSelectId = element.val();

        var zc = B3PGissuite.config.zoekconfiguraties[this.currentSearchSelectId];
        JZoekconfiguratieThemaUtil.getThemas(zc.id, function(themaIds) {
            me.zoekconfiguratieThemasCallBack(themaIds);
        });
        var zoekVelden = zc.zoekVelden;
        this.fillSearchDiv(container, zoekVelden, null);
    },

    clearConfigurationsSelect: function(container) {
        this.currentSearchSelectId = "";
        container.html("");
        B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
        this.zoekconfiguratieThemas = null;
    },

    fillSearchDiv: function(container, zoekVelden, zoekStrings) {
        var me = this;
        if (!zoekVelden) {
            container.html("Geen zoekvelden");
            return container;
        }
        if (zoekStrings && zoekStrings.length != zoekVelden.length) {
            container.html("lengte van zoekvelden en te zoeken strings komt niet overeen");
            return container;
        }

        container.empty();
        for (var i = 0; i < zoekVelden.length; i++) {
            var zoekVeld = zoekVelden[i];

            var zoekString = "*";
            if (zoekStrings) {
                zoekString = zoekStrings[i];
            }

            var inputfield;
            if (zoekVeld.type == 3) {
                // Bepaalde typen moeten niet getoond worden zoals: Geometry (3)
                inputfield = $j('<input type="hidden" />');
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
                container.append('<strong>' + zoekVelden[i].label + ':</strong><br />');
            }

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
                for (k = 0; k < B3PGissuite.config.zoekconfiguraties.length; k++) {
                    if (B3PGissuite.config.zoekconfiguraties[k].id == optionZcId)
                        optionListZc = B3PGissuite.config.zoekconfiguraties[k];
                }
                var optionListStrings = this.createZoekStringsFromZoekVelden(optionListZc, zoekVelden, zoekStrings);
                var ida = new Array(1);
                ida[0] = optionListZc.id;
                JZoeker.zoek(ida, optionListStrings, B3PGissuite.config.maxResults, function(list) {
                    me.handleZoekVeldinputList(list);
                });

            } else if (zoekVeld.inputType == 3 && zoekVeld.inputZoekConfiguratie) {
                inputfield = $j('<input type="text" />');
                inputfield.attr({
                    id: zoekVeld.attribuutnaam, //'searchField_' + zoekVeld.id,
                    name: zoekVeld.attribuutnaam,
                    size: 40,
                    maxlength: zoekVeld.inputSize
                }).keyup(function(ev) {
                    me.performSearchOnEnterKey(ev);
                });

                var zoekUrl = "viewer/SearchAutocomplete.do?zoekConfiguratieId=" + zoekVeld.inputZoekConfiguratie + "&maxResults=10";
                if (zoekVelden.length == 1) {
                    inputfield.autocomplete({
                        minLength: 2,
                        source: zoekUrl,
                        select: function(event, ui) {
                            this.value = ui.item.value;
                            $j("#zoekKnop").click();
                        }
                    });
                } else {
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
                        me.performSearchOnEnterKey(ev);
                    });
                    container.append(inputfield).append('<br/><br/>');

                    inputfield = $j('<input type="text" />');
                    inputfield.attr({
                        id: zoekVeld.id + '_y',
                        name: zoekVeld.id + '_y',
                        size: '15',
                        maxlength: '10' //zoekVeld.inputSize
                    }).keyup(function(ev) {
                        me.performSearchOnEnterKey(ev);
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
                        me.performSearchOnEnterKey(ev);
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
                        me.performSearchOnEnterKey(ev);
                    });

                    container.append(inputfield).append('<br /><br />');

                    /* indien straal search veld met dropdown type dan met komma gescheiden 
                     * waardes vullen */
                } else if ((zoekVeld.inputZoekConfiguratie === undefined || zoekVeld.inputZoekConfiguratie === null) && zoekVeld.inputType === 1 && zoekVeld.dropDownValues) {
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
                        me.performSearchOnEnterKey(ev);
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
                        me.performSearchOnEnterKey(ev);
                    });

                    container.append(inputfield).append('<br /><br />');
                }

            }

            if (zoekString != "*") {
                inputfield.val(zoekString);
            }
        }

        if (zoekVelden.length > 0) {
            container.append($j('<input type="button" />').attr("value", " Zoek ").attr("id", "searchButton").addClass("knop").click(function() {
                me.performSearch();
            }));

            var arr = B3PGissuite.config.zoekConfigIds.split(",");
            if (arr !== null && arr.length > 1) {
                container.append($j('<input type="button" />').attr("value", " Reset").addClass("knop").click(function() {
                    B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
                    me.searchConfigurationsSelectChanged(this.inputSearchDropdown);
                }));
            }

            if (!B3PGissuite.config.search && B3PGissuite.config.startLocationX === "" && B3PGissuite.config.startLocationY === "") {
                container.append($j('<input type="button" />').attr("value", " Verwijder marker").addClass("knop").click(function() {
                    B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
                }));
            }
        }

        $j("#searchResults").empty();

        return container;
    },

    handleZoekVeldinputList: function(list) {
        if (list !== null && list.length > 0) {
            var controlElementName;
            var zc = B3PGissuite.config.zoekconfiguraties[this.currentSearchSelectId];
            var optionListZc = list[0].zoekConfiguratie;
            if (zc) {
                for (var i = 0; i < zc.zoekVelden.length; i++) {
                    var zoekVeld = zc.zoekVelden[i];
                    if (zoekVeld.inputZoekConfiguratie == optionListZc.id) {
                        // controlElementName="searchField_"+zoekVeld.id;
                        controlElementName = zoekVeld.attribuutnaam;
                    }
                }
            }

            // hier lijst nog filteren, zodat alleen unieke waarden erin staan
            var controlElement = document.getElementById(controlElementName);
            $j(controlElement).removeAttr("disabled");
            dwr.util.removeAllOptions(controlElementName);
            /*maak een leeg object en voeg die toe*/
            var kiesObj = [];
            kiesObj.push({
                id: " ",
                label: "Maak uw keuze ..."
            });
            dwr.util.addOptions(controlElementName, kiesObj, 'id', 'label');

            /* List label waarde afkappen op aantal tekens. Gedaan zodat dropdown
             * met lange waardes niet rechts buiten het scherm vallen */
            for (var j = 0; j < list.length; j++) {
                var waarde = list[j].label;

                if (waarde.length > 45) {
                    list[j].label = waarde.substring(0, 45) + '...';
                }
            }

            dwr.util.addOptions(controlElementName, list, "id", "label");
            //als er maar 1 zoekveld is gelijk zoeken bij selecteren dropdown.
            if (zc && zc.zoekVelden.length == 1) {
                $j(controlElement).change(function() {
                    $j("#searchButton").click();
                });
            }
        }
    },

    performSearchOnEnterKey: function(ev) {
        var sourceEvent;
        if (ev)         //Moz
        {
            sourceEvent = ev.target;
        }

        if (window.event)   //IE
        {
            sourceEvent = window.event.srcElement;
        }
        var keycode;
        if (ev)         //Moz
        {
            keycode = ev.keyCode;
        }
        if (window.event)   //IE
        {
            keycode = window.event.keyCode;
        }
        if (keycode == 13) {
            this.performSearch();
        }
    },

    showZoekConfiguratie: function(zoekconfiguratie) {
        var visibleIds = B3PGissuite.config.zoekConfigIds.split(",");
        for (var i = 0; i < visibleIds.length; i++) {
            if (zoekconfiguratie.id == visibleIds[i]) {
                return true;
            }
        }
        return false;
    },

    setZoekconfiguratieWithId: function(id) {
        for (var i = 0; i < B3PGissuite.config.zoekconfiguraties.length; i++) {
            if (B3PGissuite.config.zoekconfiguraties[i].id === id) {
                this.currentSearchSelectId = i;
                return B3PGissuite.config.zoekconfiguraties[i];
            }
        }
    }

});