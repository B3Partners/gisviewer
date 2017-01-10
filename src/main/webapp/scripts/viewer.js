B3PGissuite.vars = {
    // ltIE8 not used any more, since we support IE8+
    // ltIE8: document.getElementsByTagName("html")[0].className.match(/lt-ie8/),
    /**
     * Array with the current visible layers in correct order.
     * The last is rendered on top.
     */
    enabledLayerItems: [],
    dataframepopupHandle: null,

    /**
     *
     * Array with layers who shouldn't be removed when updating the layers after a click in the tree.
     */
    unremovableLayers: [],
    /**
     * String that forms the request to the service. It contains the normal wms request
     * parameters appened with the kaartenbalie url and if available also PROJECT
     * or organization code parameters.
     */
    layerUrl: "" + B3PGissuite.config.kburl,
    /**
     * Cookie arrays with checked layers and clusters (csv string)
     */
    cookieArray: (B3PGissuite.config.useCookies ? B3PGissuite.commons.readCookie('checkedLayers') : null),
    cookieClusterArray: (B3PGissuite.config.useCookies ? B3PGissuite.commons.readCookie('checkedClusters') : null),
    /**
     * The web map controller
     */
    webMapController: null,
    /**
     * Index used when adding layers. So its possible to leave indexes not used.
     */
    startLayerIndex: 0,
    /**
     * Ballon reference.
     */
    balloon: null,
    mapInitialized: false,
    searchExtent: null,
    multiPolygonBufferWkt: null,
    editComponent: null,
    prevRadioButton: null,
    originalLayerUrl: "" + B3PGissuite.config.kburl,
    refresh_timeout_handle: 0,
    teller: 0,
    frameWorkInitialized: false,
    nextIdentifyExtent: null,
    exportMapWindow: null,
    btn_highLightSelected: false,
    highLightGeom: null,
    //do only once.
    initialized: false,
    /* build popup functions */
    currentpopupleft: null,
    currentpopuptop: null,
    editingRedlining: false,
    redLineGegevensbronId: -1,
    popupCreated: false
};
B3PGissuite.labels = {
    searchintro: "Kies uit de lijst de objecten waar u op wilt zoeken en vul daarna de zoekvelden in."
};
B3PGissuite.viewercommons = {
    configuredTabString: null,
    init: function () {
        var me = this;
        jQuery('.getBookmark').bind('click', function () {
            me.getBookMark();
        });
        jQuery('.getLatLonForGoogleMaps').bind('click', function () {
            me.getLatLonForGoogleMaps();
        });

        /* Alleen tabs vullen als ze ook echt aanstaan */
        var vergunningTabOn = (jQuery.inArray("vergunningen", B3PGissuite.config.enabledtabs) !== -1 || jQuery.inArray("vergunningen", B3PGissuite.config.enabledtabsLeft) !== -1);
        var zoekenTabOn = (jQuery.inArray("zoeken", B3PGissuite.config.enabledtabs) !== -1 || jQuery.inArray("zoeken", B3PGissuite.config.enabledtabsLeft) !== -1);
        if (zoekenTabOn || vergunningTabOn) {
            /* Indien 1 zoeker dan deze gelijk tonen */
            var arr = B3PGissuite.config.zoekConfigIds.split(",");
            var c = $j("#searchInputFieldsContainer");
            var searchComponent = B3PGissuite.get('Search');
            if (arr !== null && arr.length > 1) {
                searchComponent.createSearchConfigurations();
            } else if (arr !== null && arr.length === 1 && arr[0] !== '') {
                //var zc = B3PGissuite.config.zoekconfiguraties[0];
                var zc = searchComponent.setZoekconfiguratieWithId(Number(arr[0]));
                JZoekconfiguratieThemaUtil.getThemas(zc.id, function (themaIds) {
                    searchComponent.zoekconfiguratieThemasCallBack(themaIds);
                });
                var zoekVelden = zc.zoekVelden;
                searchComponent.fillSearchDiv(c, zoekVelden, null);
            }
        }

        var pwCreated = false;
        var parent = B3PGissuite.commons.getParent({parentOnly: true, supressError: true});
        if (document.getElementById('popupWindow')) {
            pwCreated = true;
        }
        // Try-catch because embedded in an iframe accessing document gives cross-domain error
        try {
            if (!pwCreated && parent && parent.document && parent.document.getElementById('popupWindow')) {
                pwCreated = true;
            }
        } catch (e) {
        }
        if (!pwCreated) {
            this.buildPopup();
        }

        $j("#dialog-wmsservice-url").dialog({
            resizable: false,
            disabled: true,
            autoOpen: false,
            modal: false,
            width: 750,
            height: 150
        });

        $j("#dialog-download-metadata").dialog({
            resizable: false,
            disabled: true,
            autoOpen: false,
            modal: false
        });
    },
    /**
     * Controleert of een tab is geconfigureerd (en dus beschikbaar is)
     * @param string tab
     * @returns boolean
     */
    isTabConfigured: function (tab) {
        if (this.configuredTabString === null) {
            this.configuredTabString = B3PGissuite.config.enabledtabs.toString() + ',' + B3PGissuite.config.enabledtabsLeft.toString();
        }
        return this.configuredTabString.indexOf(tab) !== -1;
    },
    /**
     * Controleert of een item in de huidige schaal past.
     * Voor een enkele layer wordt gekeken of die er in past
     * Voor een cluster wordt gekeken of er 1 van de layers in de schaal past.
     * @param item json thema of cluster
     * @param scale de scale waarvoor gekeken moet worden of de layer daar zichtbaar is.
     * @return boolean wel of niet zichtbaar in scale.
     */
    isItemInScale: function (item, scale) {
        if (scale == 'NaN' || scale < 0 || !item) {
            return false;
        }

        var itemVisible = true;

        if (item.children) {
            itemVisible = false;
            for (var i = 0; i < item.children.length; i++) {
                if (this.isItemInScale(item.children[i], scale)) {
                    itemVisible = true;
                }
            }
        } else {
            if (item.scalehintmin) {
                var minscale = Number(item.scalehintmin.replace(",", "."));
                if (scale < minscale) {
                    itemVisible = false;
                }
            }
            if (item.scalehintmax) {
                var maxscale = Number(item.scalehintmax.replace(",", "."));
                if (scale > maxscale) {
                    itemVisible = false;
                }
            }
        }

        /* Schaal check voor Tiling lagen */
        if (item.resolutions || item.PRINTRESOLUTIONS) {
            var list;
            var res;

            if (item.PRINTRESOLUTIONS) {
                res = item.PRINTRESOLUTIONS;
            } else {
                res = item.resolutions;
            }

            var listType = (typeof res);

            if (listType == "string") {
                list = res.split(" ");

                if (list && list.length < 1) {
                    list = res.split(",");
                }
            }

            if (list && list.length > 0) {
                var size = list.length;
                var max = list[0];
                var min = list[size - 1];

                if (min === "") {
                    min = list[size - 2];
                }

                // doe W(res(kw) * 2) scalehint
                var scaleMax = Math.sqrt((max * max) * 2);
                var scaleMin = Math.sqrt((min * min) * 2);

                var epsilon = 0.00000001;
                var adjustedScale = scale + epsilon;

                /* Scale check with % margin between scales */
                var percent = 5;
                scaleMax *= (100 + percent) / 100;
                scaleMin *= (100 - percent) / 100;

                if (adjustedScale <= scaleMax && adjustedScale >= scaleMin) {
                    itemVisible = true;
                } else {
                    itemVisible = false;
                }
            }
        }

        return itemVisible;
    },
    convertStringToArray: function (waarde) {
        var lijst = [];
        var arr = [];

        waarde = $j.trim(waarde);

        if (waarde.indexOf(",") !== -1) {
            lijst = waarde.split(",");
        } else {
            lijst = waarde.split(" ");
        }

        if (lijst && lijst.length > 0) {
            arr = [];
            for (var i in lijst) {
                lijst[i] = parseFloat(lijst[i]);
                arr[i] = lijst[i];
            }
        }

        return arr;
    },
    getNLExtent: function () {
        return "12000,304000,280000,620000";
    },
    getNLMaxBounds: function () {
        return Utils.createBounds(new Extent(this.getNLExtent()));
    },
    getNLTilingRes: function () {
        return "512,256,128,64,32,16,8,4,2,1,0.5,0.125";
    },
    getBaseUrl: function () {
        var protocol = window.location.protocol + "//";
        var host = window.location.host;

        return protocol + host + B3PGissuite.config.baseNameViewer;
    },
    /**
     * Changes the bounding box of the feature to a minimal size when this is smaller
     * than the minimal vlue.
     * @param feature The feature.
     * @return Returns the feature with adjusted bbox.
     */
    getBboxMinSize2: function (feature) {
        if ((Number(feature.maxx - feature.minx) < B3PGissuite.config.minBboxZoeken)) {
            var addX = Number((B3PGissuite.config.minBboxZoeken - (feature.maxx - feature.minx)) / 2);
            var addY = Number((B3PGissuite.config.minBboxZoeken - (feature.maxy - feature.miny)) / 2);
            feature.minx = Number(feature.minx - addX);
            feature.maxx = Number(Number(feature.maxx) + Number(addX));
            feature.miny = Number(feature.miny - addY);
            feature.maxy = Number(Number(feature.maxy) + Number(addY));
        }
        return feature;
    },
    /**
     * Shows a busy with loading page.
     * cached the last request.
     * @param handle Handle to the window to display page content in.
     * @param type Type of display used (div, panel or window).
     */
    loadBusyJSP: function (handle, type) {
        var $iframebody = null;
        if (type == 'div')
            $iframebody = $j(handle).contents().find("body");
        if (type == 'panel')
            $iframebody = $j('#' + handle).contents().find("body");
        if (type == 'window')
            $iframebody = $j(handle.document.body);

        // "Gewoon" popup window (dus geen DIV) geeft nog niet helemaal het gewenste resultaat
        if ($iframebody !== null) {
            $iframebody.html('<div id="content_style">' +
                '<table class="kolomtabel">' +
                '<tr>' +
                '<td valign="top">' +
                '<div class="loadingMessage">' +
                '<table>' +
                '<tr>' +
                '<td style="width:20px;"><img style="border: 0px;" src="/gisviewer/images/waiting.gif" alt="Bezig met laden..." /></td>' +
                '<td>' +
                '<h2>Bezig met laden ...</h2>' +
                '<p>Bezig met zoeken naar administratieve gegevens.</p>' +
                '</td>' +
                '</tr>' +
                '</table>' +
                '</div>' +
                '</td>' +
                '</tr>' +
                '</table>' +
                '</div>');
        }
    },
    isStringEmpty: function (str) {
        return (!str || 0 === str.length);
    },
    /*
     * Calculates and returns the ??? from 1:??? for the current extent and 
     * current mapwidth in pixels. Average ppi value assumed. The 0.00028
     * could be made into a config setting in gisviewerconfig.
     */
    calcScaleForCurrentExtent: function () {
        var extent = B3PGissuite.vars.webMapController.getMap().getExtent();
        var newMapWidth = extent.maxx - extent.minx;

        var screenWidth = $j("#mapcontent").width();
        var scale = newMapWidth / (screenWidth * 0.00028);

        return Math.round(Number(scale));
    },
    /* Kan gebruikt worden om wat debug info onderin de kaartboom weer te geven zoals
     * specifieke timings of huidig omgerekende schaal */
    setDebugContent: function () {
        var scale = calcScaleForCurrentExtent();
        var html = "<p><b>Schaal 1 : " + scale + "</b></p>";

        $j("#debug-content").html(html);
    },
    /**
     * Get alle enabled layer items
     * @param onlyWithinScale Only get the visible, within currentScale items.
     */
    getLayerIdsAsString: function (onlyWithinScale) {
        var ret = "";
        var firstTime = true;
        var treeComponent = B3PGissuite.get('TreeTabComponent');

        for (var i = 0; i < B3PGissuite.vars.enabledLayerItems.length; i++) {

            if (B3PGissuite.config.useInheritCheckbox) {
                var object = document.getElementById(B3PGissuite.vars.enabledLayerItems[i].id);
                /* Item alleen toevoegen aan de layers indien
                 * parent cluster(s) allemaal aangevinkt staan of
                 * geen cluster heeft */
                if (treeComponent !== null && !treeComponent.itemHasAllParentsEnabled(object))
                    continue;
            }
            if (onlyWithinScale) {
                var currentscale;
                if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
                    currentscale = B3PGissuite.vars.webMapController.getMap().getResolution();
                } else {
                    currentscale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
                }

                if (!this.isItemInScale(B3PGissuite.vars.enabledLayerItems[i], currentscale)) {
                    continue;
                }
            }
            if (firstTime) {
                ret += B3PGissuite.vars.enabledLayerItems[i].id;
                firstTime = false;
            } else {
                ret += "," + B3PGissuite.vars.enabledLayerItems[i].id;
            }
        }

        return ret;
    },
    getWMSRequests: function () {
        var requests = [];
        var background;

        var bgLayers = [];
        var fgLayers = [];

        var layers = B3PGissuite.vars.webMapController.getMap("map1").getAllWMSLayers();
        var request;

        /* eerst layers verdelen in achtergrond en voorgrond */
        for (var i = 0; i < layers.length; i++) {
            if (layers[i].getURL() !== null) {
                background = layers[i].getOption("background");

                if (background) {
                    bgLayers.push(layers[i]);
                } else {
                    fgLayers.push(layers[i]);
                }
            }
        }

        /* eerst achtergrond url's toevoegen */
        for (var j = 0; j < bgLayers.length; j++) {
            if (bgLayers[j].getURL() !== null) {
                request =
                    {
                        protocol: "WMS",
                        url: bgLayers[j].getURL()
                    };
                if (bgLayers[j].getAlpha && bgLayers[j].getAlpha() !== null) {
                    request.alpha = bgLayers[j].getAlpha();
                }
                requests.push(request);
            }
        }

        /* dan voorgrond url's toevoegen */
        for (var k = 0; k < fgLayers.length; k++) {
            /* Niet in print als voorgrond niet binnen schaal valt. Anders ontstaan er
             * vreemde printvoorbeelden als je daarvoor al een keer een print hebt gemaakt
             * waarbij de voorgrond nog wel binnen schaal viel. Fix voor ticket #618 Limburg */
            var item = this.getItemFromWmsLayer(fgLayers[k]);

            var currentscale;
            if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
                currentscale = B3PGissuite.vars.webMapController.getMap().getResolution();
            } else {
                currentscale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
            }

            var inScale = this.isItemInScale(item, currentscale);

            /* Also add tem points url in print */
            var testUrl = fgLayers[k].getURL();
            var isTempPointsLayer = false;
            if (testUrl.indexOf("tempPointsLayer") !== -1) {
                isTempPointsLayer = true;
            }

            if (fgLayers[k].getURL() !== null && inScale || isTempPointsLayer) {
                request = {
                    protocol: "WMS",
                    url: fgLayers[k].getURL()
                };

                if (fgLayers[k].getAlpha && fgLayers[k].getAlpha() !== null) {
                    request.alpha = fgLayers[k].getAlpha();
                }
                requests.push(request);
            }
        }

        return requests;
    },
    getItemFromWmsLayer: function (layer) {
        var item;
        if (layer.options) {
            item = this.getItemByLayer(B3PGissuite.config.themaTree, layer.options.layers);
        } else {
            item = layer.getFrameworkLayer();
        }

        return item;
    },
    getWktStringForPrint: function () {
        var geoms = [];
        var vectorLayers = B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();

        for (var c = 0; c < vectorLayers.length; c++) {
            var vectorLayer = vectorLayers[c];
            var features = vectorLayer.getAllFeatures();
            for (var b = 0; b < features.length; b++) {
                var geom = {
                    wktgeom: features[b].getWkt(),
                    color: "#ff0000"
                };
                if (features[b].label) {
                    geom.label = features[b].label;
                }
                geoms.push(geom);
            }
        }

        return geoms;
    },
    getLegendUrls: function () {
        var layerItems = [];
        var urlString = "";
        var firstURL = true;

        if (B3PGissuite.vars.enabledLayerItems instanceof Array) {
            for (var i = 0; i < B3PGissuite.vars.enabledLayerItems.length; i++) {
                layerItems.push(B3PGissuite.vars.enabledLayerItems[i]);
            }
        }

        for (var k = 0; k < layerItems.length; k++) {
            var layer = layerItems[k];

            if (layer.legendurl) {
                if (!firstURL) {
                    urlString += ";";
                } else {
                    firstURL = false;
                }

                urlString += layer.title + "#" + layer.legendurl;
            }
        }

        return urlString;
    },
    exportObjectData: function (URL, target) {
        var submitForm = document.createElement("FORM");
        document.body.appendChild(submitForm);
        submitForm.method = "POST";
        submitForm.target = target;
        submitForm.action = URL;
        return submitForm;
    },
    createExportInput: function (name, value) {
        var input = document.createElement('input');
        input.id = name;
        input.name = name;
        input.type = 'hidden';
        input.value = value;
        return input;
    },
    getMapJsonSettings: function (geometries) {
        var wmsRequests = this.getWMSRequests();
        var tilingRequests = this.getTilingRequests();
        /* als eerst tiling url's daarna gewone wms meegeven */
        for (var i = 0; i < wmsRequests.length; i++) {
            tilingRequests.push(wmsRequests[i]);
        }
        var mapWidth = B3PGissuite.vars.webMapController.getMap("map1").getScreenWidth();
        var mapHeight = B3PGissuite.vars.webMapController.getMap("map1").getScreenHeight();
        var minX = B3PGissuite.vars.webMapController.getMap("map1").getExtent().minx;
        var minY = B3PGissuite.vars.webMapController.getMap("map1").getExtent().miny;
        var maxX = B3PGissuite.vars.webMapController.getMap("map1").getExtent().maxx;
        var maxY = B3PGissuite.vars.webMapController.getMap("map1").getExtent().maxy;
        var mapBbox = minX + "," + minY + "," + maxX + "," + maxY;

        return JSON.stringify({
            requests: tilingRequests,
            geometries: geometries,
            bbox: mapBbox,
            width: mapWidth,
            height: mapHeight
        });
    },
    exportObjectData2PDF: function (htmlId, gegevensbron, index, idcounter) {
        var submitForm = this.exportObjectData("services/Data2PDF", "pdfIframe");
        submitForm.appendChild(this.createExportInput('gbId', gegevensbron.id));
        submitForm.appendChild(this.createExportInput('objectIds', gegevensbron.csvPks));
        submitForm.appendChild(this.createExportInput('orientation', 'staand'));
        submitForm.appendChild(this.createExportInput('jsonSettings', this.getMapJsonSettings([])));
        submitForm.appendChild(this.createExportInput('appCode', B3PGissuite.config.bookmarkAppcode));
        submitForm.submit();
    },
    exportObjectData2HTML: function (htmlId, gegevensbron, index, idcounter) {
        var submitForm = this.exportObjectData("services/Data2PDF", "info_export");
        submitForm.appendChild(this.createExportInput('gbId', gegevensbron.id));
        submitForm.appendChild(this.createExportInput('objectIds', gegevensbron.csvPks));
        submitForm.appendChild(this.createExportInput('orientation', 'staand'));
        submitForm.appendChild(this.createExportInput('format', 'html'));
        submitForm.appendChild(this.createExportInput('jsonSettings', this.getMapJsonSettings([])));
        submitForm.appendChild(this.createExportInput('appCode', B3PGissuite.config.bookmarkAppcode));
        submitForm.submit();
    },
    exportObjectData2CSV: function (htmlId, gegevensbron, index, idcounter) {
        var submitForm = this.exportObjectData("services/Data2CSV", "csv_export");
        submitForm.appendChild(this.createExportInput('themaId', gegevensbron.id));
        submitForm.appendChild(this.createExportInput('objectIds', gegevensbron.csvPks));
        submitForm.appendChild(this.createExportInput('appCode', B3PGissuite.config.bookmarkAppcode));
        submitForm.submit();
    },
    exportObjectdata2Report: function (recordId, commando, gegevensbron) {
        var submitForm = this.exportObjectData(commando, "pdfIframe");
        submitForm.appendChild(this.createExportInput('gbId', gegevensbron.id));
        submitForm.appendChild(this.createExportInput('recordId', recordId));
        submitForm.appendChild(this.createExportInput('jsonSettings', this.getMapJsonSettings([])));
        submitForm.submit();
    },
    exportMap: function () {
        var submitForm = this.exportObjectData("printmap.do", "exportMapWindowNaam");
        submitForm.appendChild(this.createExportInput('legendUrls', this.getLegendUrls()));
        /* TODO: Width en height meegeven voor tiling berekeningen als er geen gewone
         * wms url in de print zit waar dit uit gehaald kan worden */
        submitForm.appendChild(this.createExportInput('jsonSettings', this.getMapJsonSettings(this.getWktStringForPrint())));
        submitForm.submit();
        if (B3PGissuite.vars.exportMapWindow === undefined || B3PGissuite.vars.exportMapWindow === null || B3PGissuite.vars.exportMapWindow.closed) {
            B3PGissuite.vars.exportMapWindow = window.open("", "exportMapWindowNaam");
            B3PGissuite.vars.exportMapWindow.focus();
        }
    },
    getTilingRequests: function () {
        var tilingRequests = [];
        var layers = B3PGissuite.vars.webMapController.getMap("map1").getAllTilingLayers();

        /* tiling layers toevoegen */
        for (var j = 0; j < layers.length; j++) {
            var currentscale = B3PGissuite.vars.webMapController.getMap().getResolution();

            var item;
            if (layers[j].options) {
                item = this.getItemByLayer(B3PGissuite.config.themaTree, layers[j].options.LAYERS);
            } else {
                item = layers[j].getFrameworkLayer();
            }

            var inScale = this.isItemInScale(item, currentscale);

            if (!inScale) {
                continue;
            }

            var bbox = layers[j].getOption("BBOX");
            var resolutions = layers[j].getOption("RESOLUTIONS");
            var tileWidth = layers[j].getOption("TILEWIDTH");
            var tileHeight = layers[j].getOption("TILEHEIGHT");
            var url = this.buildTilingServiceUrl(layers[j]);

            var rezz;
            if (typeof resolutions !== 'string') {
                rezz = resolutions.join(","); // array openlayers
            } else {
                rezz = resolutions; // string flamingo
            }

            var request = {
                protocol: "WMSC",
                extent: bbox, //if extent is other then the given bbox.
                url: url,
                resolutions: rezz,
                tileWidth: tileWidth, //default 256, for tiling
                tileHeight: tileHeight, //default 256, for tiling
                serverExtent: bbox //server extent, for tiling
            };

            tilingRequests.push(request);
        }

        return tilingRequests;
    },
    checkParam: function (url, name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");

        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);

        var results = regex.exec(url);
        if (results === null) {
            return false;
        }

        return true;
    },
    buildTilingServiceUrl: function (tilingLayer) {
        var serviceUrl = tilingLayer.getOption("url");

        if (!this.checkParam(serviceUrl, "service") && !this.checkParam(serviceUrl, "SERVICE")) {
            serviceUrl += "&SERVICE=" + tilingLayer.getOption("SERVICE");
        }
        if (!this.checkParam(serviceUrl, "version") && !this.checkParam(serviceUrl, "VERSION")) {
            serviceUrl += "&VERSION=" + tilingLayer.getOption("VERSION");
        }
        if (!this.checkParam(serviceUrl, "layer") && !this.checkParam(serviceUrl, "LAYER")) {
            serviceUrl += "&LAYERS=" + tilingLayer.getOption("LAYERS");
        }
        if (!this.checkParam(serviceUrl, "styles") && !this.checkParam(serviceUrl, "STYLES")) {
            serviceUrl += "&STYLES=" + tilingLayer.getOption("STYLES");
        }
        if (!this.checkParam(serviceUrl, "format") && !this.checkParam(serviceUrl, "FORMAT")) {
            serviceUrl += "&FORMAT=" + tilingLayer.getOption("FORMAT");
        }
        if (!this.checkParam(serviceUrl, "srs") && !this.checkParam(serviceUrl, "SRS")) {
            serviceUrl += "&SRS=" + tilingLayer.getOption("SRS");
        }
        if (!this.checkParam(serviceUrl, "request") && !this.checkParam(serviceUrl, "REQUEST")) {
            serviceUrl += "&REQUEST=" + tilingLayer.getOption("REQUEST");
        }

        return serviceUrl;
    },
    /* Voor openlayers wil je soms de hele polygon op het scherm hebben niet alleen
     * de laatst actieve. Als je bijvoorbeeld in OL een polygon edit krijg je anders 
     * van getActiveFeature alleen de laatste feature (een Point) terug. In
     * this.getFrameworkLayer().features[0] zit het hele polygon.
     */
    getWktActiveFeature: function (index) {
        var object;
        object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature(index);

        if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
            var arr = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getAllFeatures();

            if (arr && arr.length == 1) {
                object = arr[0];
            }
        }

        if (object === null || object === undefined) {
            B3PGissuite.commons.messagePopup("Melding", "Er is nog geen tekenobject op het scherm.", "pencil");
            return null;
        }

        return object.getWkt();
    },
    getWktForDownload: function () {
        var object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature();

        if (object === null || object === undefined) {
            return "";
        }

        return object.getWkt();
    },
    getWkt: function () {
        var object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature(-1);

        if (object === null || object === undefined) {
            return null;
        }

        if (!object.wktgeom) {
            return object.getWkt();
        }

        return object.wktgeom;
    },
    drawFeature: function (ggbId, attrName, attrVal) {
        var me = this;
        JMapData.getWkt(ggbId, attrName, attrVal, function (wkt) {
            me.drawWkt(wkt);
        });
    },
    returnBuffer: function (wkt) {
        this.drawWkt(wkt);
    },
    drawWkt: function (wkt) {
        if (wkt.length > 0) {
            var polyObject = new Feature(61502, wkt);
            this.drawObject(polyObject);
        }
    },
    drawObject: function (feature) {
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").addFeature(feature);
    },
    getBookMark: function () {
        this.addToFavorites(this.createPermaLink());
    },
    getFullExtent: function () {
        var fullExtent = B3PGissuite.vars.webMapController.getMap().getExtent();

        return fullExtent;
    },
    getCenterWkt: function () {
        var fullExtent = this.getFullExtent();

        var minx = Math.round(Number(fullExtent.minx) + 1);
        var miny = Math.round(Number(fullExtent.miny) + 1);
        var maxx = Math.round(Number(fullExtent.maxx) - 1);
        var maxy = Math.round(Number(fullExtent.maxy) - 1);

        var x = (minx + maxx) / 2;
        var y = (miny + maxy) / 2;

        return "POINT(" + x + " " + y + ");";
    },
    getMinWkt: function () {
        var fullExtent = this.getFullExtent();

        var minx = Math.round(Number(fullExtent.minx) + 1);
        var miny = Math.round(Number(fullExtent.miny) + 1);

        return "POINT(" + minx + " " + miny + ");";
    },
    getMaxWkt: function () {
        var fullExtent = this.getFullExtent();

        var maxx = Math.round(Number(fullExtent.maxx) - 1);
        var maxy = Math.round(Number(fullExtent.maxy) - 1);

        return "POINT(" + maxx + " " + maxy + ");";
    },
    /* Berekenen lattitude en longitude waardes voor gebruik in Google
     * maps aanroep */
    getLatLonForGoogleMaps: function () {
        var me = this;
        var centerWkt = this.getCenterWkt();
        var minWkt = this.getMinWkt();
        var maxWkt = this.getMaxWkt();

        JMapData.getLatLonForRDPoint(centerWkt, minWkt, maxWkt, function (values) {
            me.openGoogleMaps(values);
        });
    },
    /* Uses classic Google Maps parameters ll and spn 
     * https://moz.com/ugc/everything-you-never-wanted-to-know-about-google-maps-parameters
     * values[] = lat, lon, span Lat, span lon.
     * */
    openGoogleMaps: function (values) {
        var myVariableOrder = googlemapsVariableOrder();

        var ll = "&ll=" + values[myVariableOrder.first] + "," + values[myVariableOrder.second];
        var spn = "&spn=" + values[myVariableOrder.third] + "," + values[myVariableOrder.fourth];
        var options = "&hl=nl&om=0";
        var url = "https://maps.google.com/maps?ie=UTF8" + ll + spn + options;
        window.open(url);
    },
    getDestinationWkt: function (gbId, pk, val) {
        var me = this;
        JMapData.getWkt(gbId, pk, val, function (destWkt) {
            me.getLatLonForGoogleMapDirections(destWkt);
        });
    },
    getLatLonForGoogleMapDirections: function (destWkt) {
        var me = this;
        JMapData.getLatLonForGoogleDirections(destWkt, function (values) {
            me.openGoogleMapsDirections(values);
        });
    },
    openGoogleMapsDirections: function (values) {

        /* Check of er een gps locatie is gezet. */
        var gps = B3PGissuite.get('GPS');
        if (gps !== null && gps.getGpsLat() !== null && gps.getGpsLon() !== null) {
            values[0] = gps.getGpsLat();
            values[1] = gps.getGpsLon();
        }

        if (values[0] === "" || values[1] === "") {
            B3PGissuite.commons.messagePopup("Info", "Er is nog geen gps- of startlocatie bekend.", "information");
            return;
        }

        var saddr = "?saddr=" + values[0] + "," + values[1];
        var daddr = "&daddr=" + values[2] + "," + values[3];

        var url = "https://maps.google.com/maps" + saddr + daddr;

        window.open(url);
    },
    createPermaLink: function () {
        var protocol = window.location.protocol + "//";
        var host = window.location.host;

        var urlBase = protocol + host + B3PGissuite.config.baseNameViewer + "/viewer.do?";

        /* applicatie code */
        var appCode = "";
        if (B3PGissuite.config.bookmarkAppcode !== undefined && B3PGissuite.config.bookmarkAppcode !== "") {
            appCode = "appCode=" + B3PGissuite.config.bookmarkAppcode;
        }

        /* kaartlagen ophalen */
        var id = "";
        var layerIds = this.getLayerIdsAsString();
        if (layerIds !== undefined && layerIds !== "") {
            id = "&id=" + layerIds;
        }

        /* kaartgroepen ophalen */
        var clusterIds = "";
        var treeComponent = B3PGissuite.get('TreeTabComponent');
        if (treeComponent !== null) {
            var clustersAan = treeComponent.getClustersAan();
            if (clustersAan.length > 0) {
                clusterIds += "&clusterId=";
                for (var i = 0; i < clustersAan.length; i++) {
                    if (clusterIds.length > 0) {
                        clusterIds += ",";
                    }
                    clusterIds += clustersAan[i].theItem.id.substring(1);
                }
            }
        }

        /* kaart extent ophalen */
        var extent = "";
        var fullExtent = B3PGissuite.vars.webMapController.getMap().getExtent();
        if (fullExtent !== undefined && fullExtent !== "") {
            var minx = Math.round(Number(fullExtent.minx) + 1);
            var miny = Math.round(Number(fullExtent.miny) + 1);
            var maxx = Math.round(Number(fullExtent.maxx) - 1);
            var maxy = Math.round(Number(fullExtent.maxy) - 1);

            extent = "&extent=" + minx + "," + miny + "," + maxx + "," + maxy;
        }

        /* kaart resolutie ophalen */
        var reso = "";

        var controllerRes;
        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
            controllerRes = B3PGissuite.vars.webMapController.getMap().getResolution();
        } else {
            controllerRes = B3PGissuite.vars.webMapController.getMap().getScaleHint();
        }

        if (controllerRes !== undefined && controllerRes !== "") {
            reso = "&resolution=" + controllerRes;
        }

        var force = "&forceViewer=true";
        var pageId = "&cmsPageId=" + B3PGissuite.config.cmsPageId;
        var url = urlBase + appCode + id + clusterIds + extent + force + pageId;

        return url;
    },
    addToFavorites: function (url) {
        var title = "B3P Gisviewer bookmark";

        if (Boolean(window.chrome)) { // chrome
            this.chromeBookMarkPopup(url, title);
        } else if (window.sidebar) { // Firefox
            this.chromeBookMarkPopup(url, title);
            /*window.sidebar.addPanel(title, url, "");
             window.external.AddFavorite(url, title); */
        } else if (window.external) { // IE 6,7 not 8?
            /* Moet gekoppeld zijn aan userevent of iets met runat server ? */
            window.external.AddFavorite(url, title);
        } else if (window.opera && window.print) { // Opera 
            return true;
        }

        return null;
    },
    chromeBookMarkPopup: function (url, title) {
        var chromePopup = window.open(url, title, "height=300, width=850,toolbar=no,scrollbars=no,menubar=no");
        var html = "<p>Voeg deze link toe aan uw favorieten:</p>" + url;
        chromePopup.document.write(html);
    },
    popUp: function (URL, naam, width, height, useDiv) {

        var screenwidth = 600;
        var screenheight = 500;
        var useDivPopup = false;

        if (width) {
            screenwidth = width;
        }

        if (height) {
            screenheight = height;
        }

        if (useDiv) {
            useDivPopup = useDiv;
        }

        var popupleft = (screen.width) ? (screen.width - screenwidth) / 2 : 100;

        if (B3PGissuite.vars.currentpopupleft !== null) {
            popupleft = B3PGissuite.vars.currentpopupleft;
        }

        var popuptop = (screen.height) ? (screen.height - screenheight) / 2 : 100;

        if (B3PGissuite.vars.currentpopuptop !== null) {
            B3PGissuite.vars.currentpopuptop = popuptop;
        }

        if (useDivPopup) {
            document.getElementById("dataframedivpopup").src = URL;
            document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';

            $j("#popupWindow").width(width);
            $j("#popupWindow").height(height);

            $j("#popupWindow").show();
        } else {

            properties = "toolbar = 0, " +
                "scrollbars = 1, " +
                "location = 0, " +
                "statusbar = 1, " +
                "menubar = 0, " +
                "resizable = 1, " +
                "width = " + screenwidth + ", " +
                "height = " + screenheight + ", " +
                "top = " + popuptop + ", " +
                "left = " + popupleft;

            return window.open(URL, naam, properties);
        }

        return null;
    },
    popUpData: function (naam, width, height, useDiv) {
        var screenwidth = 600;
        var screenheight = 500;
        var useDivPopup = false;

        if (width) {
            screenwidth = width;
        }
        if (height) {
            screenheight = height;
        }

        if (useDiv) {
            useDivPopup = useDiv;
        }

        var popupleft = (screen.width) ? (screen.width - screenwidth) / 2 : 100;

        if (B3PGissuite.vars.currentpopupleft !== null) {
            popupleft = B3PGissuite.vars.currentpopupleft;
        }

        var popuptop = (screen.height) ? (screen.height - screenheight) / 2 : 100;

        if (B3PGissuite.vars.currentpopuptop !== null) {
            B3PGissuite.vars.currentpopuptop = popuptop;
        }

        if (useDivPopup) {
            document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';
            $j("#popupWindow").show();

            return document.getElementById("dataframedivpopup");
        } else {

            properties = "toolbar = 0, " +
                "scrollbars = 1, " +
                "location = 0, " +
                "statusbar = 1, " +
                "menubar = 0, " +
                "resizable = 1, " +
                "width = " + screenwidth + ", " +
                "height = " + screenheight + ", " +
                "top = " + popuptop + ", " +
                "left = " + popupleft;

            return window.open('admindatabusy.do?theme=' + B3PGissuite.config.theme, naam, properties);
        }
    },
    buildPopup: function () {
        var popupDiv = document.createElement('div');
        popupDiv.styleClass = 'popup_Window';
        popupDiv.id = 'popupWindow';
        var popupHandle = document.createElement('div');
        popupHandle.styleClass = 'popup_Handle';
        popupHandle.id = 'popupWindow_Handle';
        var popupTitle = document.createElement('div');
        popupTitle.className = 'popup_Title';
        popupTitle.id = 'popupWindow_Title';
        var popupClose = document.createElement('a');
        popupClose.className = 'popup_Close';
        popupClose.id = 'popupWindow_Close';
        popupClose.href = '#';
        popupClose.innerHTML = '[ x ]';
        var popupResize = document.createElement('a');
        popupResize.className = 'popup_Resize';
        popupResize.id = 'popupWindow_Resize';
        popupResize.href = '#';
        popupResize.innerHTML = '[ + ]';
        popupHandle.appendChild(popupTitle);
        popupHandle.appendChild(popupClose);
        popupHandle.appendChild(popupResize);
        popupDiv.appendChild(popupHandle);
        var popupContent = document.createElement('div');
        popupContent.styleClass = 'popup_Content';
        popupContent.id = 'popupWindow_Content';
        var popupIframe = null;
        if (B3PGissuite.commons.getIEVersion() <= 7 && B3PGissuite.commons.getIEVersion() != -1) {
            popupIframe = document.createElement('<iframe name="dataframedivpopup">');
        } else {
            popupIframe = document.createElement('iframe');
            popupIframe.name = 'dataframedivpopup';
        }
        popupIframe.styleClass = 'popup_Iframe';
        popupIframe.id = 'dataframedivpopup';
        popupIframe.src = 'admindatabusy.do?theme=' + B3PGissuite.config.theme;
        var popupResizediv = document.createElement('div');
        popupResizediv.id = 'popupWindow_Resizediv';
        popupContent.appendChild(popupIframe);
        popupContent.appendChild(popupResizediv);
        popupDiv.appendChild(popupContent);

        var popupWindowBackground = document.createElement('div');
        popupWindowBackground.styleClass = 'popupWindow_Windowbackground';
        popupWindowBackground.id = 'popupWindow_Windowbackground';

        $j(popupDiv).css({
            "height": B3PGissuite.config.popupHeight,
            "width": B3PGissuite.config.popupWidth,
            "left": B3PGissuite.config.popupLeft,
            "top": B3PGissuite.config.popupTop,
            "display": "none"
        });

        document.body.appendChild(popupDiv);
        document.body.appendChild(popupWindowBackground);

        $j('#popupWindow').draggable({
            handle: '#popupWindow_Handle',
            iframeFix: true,
            zIndex: 200,
            containment: 'document',
            start: function (event, ui) {
                B3PGissuite.commons.startDrag();
            },
            stop: function (event, ui) {
                B3PGissuite.commons.stopDrag();
            }
        }).resizable({
            handles: 'se',
            start: function (event, ui) {
                B3PGissuite.commons.startResize();
            },
            stop: function (event, ui) {
                B3PGissuite.commons.stopResize();
            }
        });

        $j('#popupWindow_Close').click(function () {
            if (B3PGissuite.vars.dataframepopupHandle)
                B3PGissuite.vars.dataframepopupHandle.closed = true;

            $j("#popupWindow").hide();
        });
        // Resizing popup
        (function () {
            var resized = false,
                defaultCss = {
                    "height": B3PGissuite.config.popupHeight,
                    "width": B3PGissuite.config.popupWidth,
                    "left": B3PGissuite.config.popupLeft,
                    "top": B3PGissuite.config.popupTop
                },
                resizeCss = {
                    "height": '70%',
                    "width": '70%',
                    "left": "15%",
                    "top": "15%"
                };
            $j('#popupWindow_Resize').click(function () {
                $j("#popupWindow").css(resized ? defaultCss : resizeCss);
                $j('#popupWindow_Resize').text(resized ? '[ + ]' : ' [ - ]');
                resized = !resized;
            });
        })();

        B3PGissuite.vars.popupCreated = true;
    },
    /**
     * get the item that has the configuration of this wmslayer string
     * @param item the item to begin the search
     * @param layers the layers string of a layer object
     * @return the item
     */
    getItemByLayer: function (item, layers) {
        if (item.children) {
            for (var i = 0; i < item.children.length; i++) {
                var child = item.children[i];

                if (child.wmslayers && child.wmslayers == layers) {
                    return child;
                } else if (child.wmslayers && child.wmslayers != layers) {
                    var mLayers = layers.split(",");

                    for (var j in mLayers) {
                        if (child.wmslayers == mLayers[j]) {
                            return child;
                        }
                    }
                } else if (child.children) {
                    var foundItem = this.getItemByLayer(child, layers);
                    if (foundItem !== null) {
                        return foundItem;
                    }
                }
            }
        }

        return null;
    },

    /**
     * Adds a parameter to the query string of an URL
     * @param {string} url
     * @param {string} key
     * @param {string} value
     * @returns {string}
     */
    addToQueryString: function (url, key, value) {
        var query = url.indexOf('?');
        if (query === url.length - 1) {
            // Strip any ? on the end of the URL
            url = url.substring(0, query);
            query = -1;
        }
        var anchor = url.indexOf('#');
        return (anchor > 0 ? url.substring(0, anchor) : url)
            + (query > 0 ? "&" + key + "=" + value : "?" + key + "=" + value)
            + (anchor > 0 ? url.substring(anchor) : "");
    }

};

$j(document).ready(function () {
    B3PGissuite.viewercommons.init();
});