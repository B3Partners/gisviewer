B3PGissuite.defineComponent('ViewerComponent', {
    defaultOptions: {
        viewerType: 'flamingo'
    },
    options: {},
    mapviewer: null,
    uploadCsvLayerOn: false,
    constructor: function ViewerComponent(options) {
        this.options = jQuery.extend(this.defaultOptions, options);
        this.init();
    },
    init: function() {
        this.mapviewer = this.options.viewerType;
        if (window.location.href.indexOf("flamingo") > 0) {
            this.mapviewer = "flamingo";
        }
    },
    /**
     * Initialize the viewer. This sets the web map controller to either
     * Flamingo or OpenLayers. It also registers the events that can be fired.
     */
    initMapComponent: function() {
        if (this.mapviewer === "flamingo")
        {
            this.initFlamingo();
        }
        else if (this.mapviewer === "openlayers")
        {
            this.initOpenlayers();
        }
        B3PGissuite.vars.webMapController.initEvents();
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_GET_CAPABILITIES, B3PGissuite.vars.webMapController.getMap(), onGetCapabilities);
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_CONFIG_COMPLETE, B3PGissuite.vars.webMapController, onConfigComplete);
        this.fireEvent('initMapComplete');
    },
    /**
     * Init the Flamingo controller
     */
    initFlamingo: function() {
        B3PGissuite.vars.webMapController = new FlamingoController('mapcontent');
        var map = B3PGissuite.vars.webMapController.createMap("map1");
        B3PGissuite.vars.webMapController.addMap(map);
    },
    /**
     * Init the Openlayers controller
     */
    initOpenlayers: function() {
        B3PGissuite.vars.webMapController = new OpenLayersController();
        var maxBounds = this.getMaxBounds();
        var olRes = this.getTilingResolutions(maxBounds, true);
        Proj4js.defs["EPSG:28992"] = "+title=Amersfoort / RD New +proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs";
        var opt = {
            projection: new OpenLayers.Projection("EPSG:28992"),
            // set nl as max extent. Always show layers.            
            maxExtent: B3PGissuite.viewercommons.getNLMaxBounds(),
            resolutions: olRes,
            // numZoomLevels: olRes.length-1,
            allOverlays: true,
            units: 'meters',
            theme: 'styles/gisviewer_openlayers.css',
            controls: [
                new OpenLayers.Control.Navigation({
                    zoomBoxEnabled: false
                }),
                new OpenLayers.Control.ArgParser()
            ]
        };
        OpenLayers.ImgPath = 'styles/openlayers_img/';
        $j("#mapcontent").html(" ");
        var olmap = B3PGissuite.vars.webMapController.createMap('mapcontent', opt);
        $j("#mapcontent").css("border", "1px solid black");
        B3PGissuite.vars.webMapController.addMap(olmap);
    },
    /**
     * Add Layer to Viewer
     * @param lname
     * @param layerUrl
     * @param layerItems
     */
    addLayerToViewer: function(lname, layerUrl, layerItems) {
        //tiling layer
        if (layerItems.length == 1 && layerItems[0].tiled) {
            var options = {};
            var tileItem = layerItems[0];
            options["VERSION"] = tileItem.tileVersion;
            options["LAYERS"] = tileItem.tileLayers;
            options["STYLES"] = tileItem.tileStyles;
            options["FORMAT"] = tileItem.tileFormat;
            options["SRS"] = tileItem.tileSrs;
            options["BBOX"] = tileItem.tileBoundingBox;

            /* voor transparantie slider */
            options["background"] = tileItem.background;

            var maxBounds = this.getMaxBounds();
            var olRes;

            if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== '') {
                olRes = B3PGissuite.config.tilingResolutions;
            } else if (tileItem.resolutions) {
                olRes = tileItem.resolutions;
            } else {
                olRes = this.getTilingResolutions(maxBounds, false);
            }

            B3PGissuite.config.tilingResolutions = olRes;

            if (B3PGissuite.vars.webMapController instanceof OpenLayersController && B3PGissuite.config.tilingResolutions) {
                // vervang kommas voor spaties */
                olRes = olRes.replace(/\,/g, ' ');
                options["serverResolutions"] = olRes;
            }

            options["RESOLUTIONS"] = olRes;
            options["TILEHEIGHT"] = tileItem.tileHeight;
            options["TILEWIDTH"] = tileItem.tileWidth;

            /* Min/max scale zetten voor tiling layers */
            if (tileItem.resolutions) {
                var res = tileItem.resolutions;
                //; //.trim();

                var list = res.split(" ");

                if (list && list.length < 1) {
                    list = res.split(",");
                }

                if (list && list.length > 0) {
                    var size = list.length;
                    var max = list[0];
                    var min = list[size - 1];

                    options["minscale"] = min;
                    options["maxscale"] = max;
                }
            }

            var tileLayer = B3PGissuite.vars.webMapController.createWMScLayer(lname, layerUrl, options);
            B3PGissuite.vars.webMapController.getMap().addLayer(tileLayer);

        } else {
            //wms layer    
            var capLayerUrl = layerUrl;

            var validId = this.getValidLayerId(lname);

            var options = {
                id: validId,
                timeout: 30,
                retryonerror: 10,
                getcapabilitiesurl: capLayerUrl,
                ratio: 1,
                showerrors: true,
                initService: false
            };

            var ogcOptions = {
                format: "image/png",
                transparent: true,
                exceptions: "application/vnd.ogc.se_inimage",
                srs: "EPSG:28992",
                version: "1.1.1",
                noCache: true // TODO: Voor achtergrond kaartlagen wel cache gebruiken
            };

            var theLayers = "";
            var queryLayers = "";
            var maptipLayers = "";
            var smallestMinscale = -1;
            var largestMaxscale = -1;

            var allStyles = "";

            /* Kijken of layers alleen maar default styles bevatten? Zo ja
             * dan hoeven er geen styles meegegeven te worden */
            var onlyDefaultStyles = this.layersOnlyHaveDefaultStyles(layerItems);

            /* 
             * TODO: Sld parts opbouwen via sld servlet. Servlet aan layerUrl plakken
             * Als er een hele sld in de layerUrl is meegegeven dan geen style gebruiken 
             */
            if (layerUrl.indexOf("&sld=") != -1) {
                onlyDefaultStyles = true;
            }

            var sldIds = "";

            var maptips = [];
            // last in list will be on top in map
            for (var i = 0; i < layerItems.length; i++) {
                var item = layerItems[i];

                var usingSldPart = false;
                if (item.sld_part != undefined && item.sld_part != "") {
                    if (sldIds.length < 1) {
                        sldIds += item.id;
                    } else {
                        sldIds += "," + item.id;
                    }

                    usingSldPart = true;
                }

                /* styles komma seperated aan ogc options toevoegen. style niet gebruiken
                 * als er een sld_part is voor het item. */
                if (item.use_style && !onlyDefaultStyles && !usingSldPart) {
                    if (i == layerItems.length - 1) {
                        allStyles += item.use_style;
                    } else {
                        allStyles += item.use_style + ",";
                    }
                }

                var minscale;
                if (smallestMinscale != 0) {
                    if (item.scalehintmin != null) {
                        minscale = Number(item.scalehintmin.replace(",", "."));
                        if (!isNaN(minscale)) {
                            if (smallestMinscale == -1 || minscale < smallestMinscale) {
                                smallestMinscale = minscale;
                            }
                        }
                    } else {
                        //geen minscale dan moet er geen minscale worden ingesteld.
                        smallestMinscale = 0;
                    }
                }

                var maxscale;
                if (largestMaxscale != 0) {
                    if (item.scalehintmax != null) {
                        maxscale = Number(item.scalehintmax.replace(",", "."));
                        if (!isNaN(maxscale)) {
                            if (largestMaxscale == -1 || maxscale > largestMaxscale) {
                                largestMaxscale = maxscale;
                            }
                        }
                    } else {
                        //geen maxscale dan moet er geen maxscale worden ingesteld.
                        largestMaxscale = 0;
                    }
                }

                if (item.wmslayers) {
                    if (theLayers.length > 0) {
                        theLayers += ",";
                    }
                    theLayers += item.wmslayers;

                    /* 
                     * Achtergrond optie toevoegen voor gebruik bij Print. Anders
                     * komt de laatst aangevinkte laag bovenop ook als dit een 
                     * achtergrond laag is.
                     */
                    if (item.background) {
                        options["background"] = true;
                    } else {
                        options["background"] = false;
                    }

                }
                if (item.wmsquerylayers) {
                    if (queryLayers.length > 0) {
                        queryLayers += ",";
                    }
                    queryLayers += item.wmsquerylayers;
                }
                if (layerItems[i].maptipfield) {
                    if (maptipLayers.length != 0)
                        maptipLayers += ",";
                    maptipLayers += layerItems[i].wmslayers;
                    var aka = layerItems[i].wmslayers;
                    //Als de gebruiker ingelogd is dan zal het waarschijnlijk een kaartenbalie service zijn
                    //Daarom moet er een andere aka worden gemaakt voor de map tip.
                    if (B3PGissuite.config.user.ingelogdeGebruiker && B3PGissuite.config.user.ingelogdeGebruiker.length > 0) {
                        aka = aka.substring(aka.indexOf("_") + 1);
                    }
                    var maptip = new MapTip(layerItems[i].wmslayers, layerItems[i].maptipfield, aka);
                    maptips.push(maptip);
                    //newLayer.addLayerProperty(new LayerProperty(layerItems[i].wmslayers, layerItems[i].maptipfield, aka));
                }
            }

            if (smallestMinscale != null && smallestMinscale > 0) {
                options["minscale"] = smallestMinscale;
            }

            if (largestMaxscale != null && largestMaxscale > 0) {
                options["maxscale"] = largestMaxscale;
            }

            if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
                if (options["maxResolution"]) {
                    options["maxscale"] = options["maxResolution"];
                }
                if (options["minResolution"]) {
                    options["minscale"] = options["minResolution"];
                }
                delete options["maxResolution"];
                delete options["minResolution"];
            } else if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
                if (options["maxResolution"] != undefined && options["minResolution"] == undefined) {
                    options["minResolution"] = "auto";
                }
                if (options["minResolution"] != undefined && options["maxResolution"] == undefined) {
                    options["maxResolution"] = "auto";
                }
            }

            ogcOptions["styles"] = allStyles;

            ogcOptions["layers"] = theLayers;
            ogcOptions["query_layers"] = queryLayers;
            //ogcOptions["sld"] = "http://localhost/rpbadam/rpbadam.xml";

            options["maptip_layers"] = maptipLayers;

            /* sld servlet gebruiken ? */
            if (sldIds.length > 0) {
                var protocol = window.location.protocol + "//";
                var host = window.location.host;

                var baseUrl = protocol + host + B3PGissuite.config.baseNameViewer;
                var sldUrl = "sld=" + baseUrl + "/services/createUserSld?layerids=" + sldIds;

                layerUrl += sldUrl;
            }

            var newLayer = B3PGissuite.vars.webMapController.createWMSLayer(lname, layerUrl, ogcOptions, options);

            newLayer.setMapTips(maptips);

            B3PGissuite.vars.webMapController.getMap().addLayer(newLayer);//false, true, false
        }
    },
    /**
     * Refresh Layer
     * @param doRefreshOrder
     */
    refreshLayer: function(doRefreshOrder) {
        var local_refresh_handle = B3PGissuite.vars.refresh_timeout_handle;

        if (doRefreshOrder == undefined) {
            doRefreshOrder = false;
        }

        if (B3PGissuite.vars.layerUrl == undefined || B3PGissuite.vars.layerUrl == null) {
            B3PGissuite.commons.hideLoading();
            return;
        }

        if (B3PGissuite.vars.layerUrl.toLowerCase().indexOf("?service=") == -1 && B3PGissuite.vars.layerUrl.toLowerCase().indexOf("&service=") == -1) {
            if (B3PGissuite.vars.layerUrl.indexOf('?') > 0) {
                B3PGissuite.vars.layerUrl += '&';
            } else {
                B3PGissuite.vars.layerUrl += '?';
            }
            B3PGissuite.vars.layerUrl += "SERVICE=WMS";
        }

        var topLayerItems = [];
        var backgroundLayerItems = [];
        var item;
        var treeComponent = B3PGissuite.get('TreeComponent');

        for (var i = 0; i < B3PGissuite.vars.enabledLayerItems.length; i++) {
            item = B3PGissuite.vars.enabledLayerItems[i];

            if (B3PGissuite.config.useInheritCheckbox) {
                var object = document.getElementById(item.id);

                /* Indien object nog niet gevonden dan is het item
                 * waarschijnlijk een user layer. Object opzoeken via jQuery */
                if (object == undefined || object == null) {
                    object = $j("#input").find('l_' + item.id);
                }

                if (object == undefined || object == null) {
                    object = $j("#input").find('lOn_' + item.id);
                }

                // Item alleen toevoegen aan de layers indien
                // parent cluster(s) allemaal aangevinkt staan of
                // geen cluster heeft
                if (treeComponent !== null && !treeComponent.itemHasAllParentsEnabled(object)) {
                    continue;
                }
            }
            if (item.wmslayers) {
                if (item.background) {
                    backgroundLayerItems.push(item);
                } else {
                    topLayerItems.push(item);
                }
            }
        }

        var orderedLayerItems = [];
        orderedLayerItems = orderedLayerItems.concat(backgroundLayerItems);
        orderedLayerItems = orderedLayerItems.concat(topLayerItems);
        var layerGroups = [];
        var layerGroup;
        var lastGroupName = "";
        var localGroupName = "";
        for (var j = 0; j < orderedLayerItems.length; j++) {
            item = orderedLayerItems[j];
            //als layergrouping afzonderlijke layers is of als de layer een tiling layer is
            //maak dan een afzonderlijke layer.
            if (B3PGissuite.config.layerGrouping == "lg_layer" || item.tiled) {
                localGroupName = "fmc" + item.id;
            } else if (B3PGissuite.config.layerGrouping == "lg_cluster") {
                localGroupName = "fmc" + item.clusterid;
            } else if (B3PGissuite.config.layerGrouping == "lg_forebackground") {
                if (item.background) {
                    localGroupName = "fmcback";
                } else {
                    localGroupName = "fmctop";
                }
            } else {
                localGroupName = "fmcall";
            }
            if (lastGroupName == "" || localGroupName != lastGroupName) {
                layerGroup = [];
                if (B3PGissuite.config.layerGrouping == "lg_cluster") {
                    layerGroup.push(localGroupName + "_" + item.id);
                } else {
                    layerGroup.push(localGroupName);
                }
                layerGroups.push(layerGroup);

            }
            layerGroup.push(item);
            lastGroupName = localGroupName;
        }

        // verwijderen ontbrekende layers
        var allLayers = B3PGissuite.vars.webMapController.getMap().getLayers();
        var shownLayers = [];
        for (var a = 0; a < allLayers.length; a++) {
            if (allLayers[a].getType() == Layer.RASTER_TYPE) {
                shownLayers.push(allLayers[a]);
            }
        }
        var removedLayers = [];
        for (var k = 0; k < shownLayers.length; k++) {
            var lid = shownLayers[k].getId();
            var ls = shownLayers[k].getOption("layers");
            var found = false;
            for (i = 0; i < layerGroups.length && found == false; i++) {
                layerGroup = layerGroups[i];
                if (lid == layerGroup[0]) {
                    // controleren of laagvolgorde hetzelfde is
                    var lsreq = "";
                    for (var m = 1; m < layerGroup.length; m++) {
                        item = layerGroup[m];
                        if (lsreq.length > 0) {
                            lsreq += ",";
                        }
                        lsreq += item.wmslayers;
                    }
                    if (ls == lsreq) {
                        found = true;
                        break;
                    }
                }
            }
            if (!found) {
                removedLayers.push(lid);
            }
        }
        for (var n = 0; n < removedLayers.length; n++) {
            B3PGissuite.vars.webMapController.getMap().removeLayerById(removedLayers[n]);//false
        }

        // toevoegen lagen
        for (i = 0; i < layerGroups.length; i++) {
            layerGroup = layerGroups[i];
            var layerId = layerGroup[0];

            if (B3PGissuite.vars.webMapController.getMap().getLayer(layerId) == null) {
                layerGroup.splice(0, 1); // verwijder eerste element

                for (k = 0; k < layerGroup.length; k++) {
                    /* eigen wms layer */
                    if (layerGroup[k].serviceid != undefined) {
                        var lName = layerGroup[k].name;
                        var lUrl = layerGroup[k].service_url;
                        var layers = [];
                        layers[0] = layerGroup[k];

                        /* Sld url aan service url toevoegen
                         var sldUrl = layerGroup[k].service_sld;                    
                         if (sldUrl != undefined && sldUrl != "" && sldUrl.length > 0) {
                         lUrl += "&sld=" + sldUrl;
                         } */

                        this.addLayerToViewer(lName, lUrl, layers);
                        layerId = this.getValidLayerId(lName);
                    } else {
                        this.addLayerToViewer(layerId, B3PGissuite.vars.layerUrl, layerGroup);
                    }
                }
            }

            var layer = B3PGissuite.vars.webMapController.getMap().getLayer(layerId);
            if (layer != null) {
                var oldOrderIndex = B3PGissuite.vars.webMapController.getMap().setLayerIndex(layer, i + B3PGissuite.vars.startLayerIndex);
                if (i + B3PGissuite.vars.startLayerIndex != oldOrderIndex) {
                    doRefreshOrder = true;
                }
            }
        }

        B3PGissuite.commons.hideLoading();

        if (local_refresh_handle != B3PGissuite.vars.refresh_timeout_handle) {
            // check of dit een goed idee is
            // alleen refresh als er intussen geen nieuwe timeout gezet is
            return;
        } else {
            B3PGissuite.vars.refresh_timeout_handle = 0;
        }
        //if (doRefreshOrder) {
        //TODO: WebMapController
        //B3PGissuite.vars.webMapController.getMap().refreshLayerOrder();
        //}

        // flamingoController.getMap().update();

        var lagen = B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        var tilingLayers = B3PGissuite.vars.webMapController.getMap().getAllTilingLayers();

        if (tilingLayers) {
            lagen.concat(tilingLayers);
        }

        var totalLayers = B3PGissuite.vars.webMapController.getMap().getLayers().length;
        for (var p = 0; p < lagen.length; p++) {
            var laag = lagen[p];
            B3PGissuite.vars.webMapController.getMap().setLayerIndex(laag, totalLayers + B3PGissuite.vars.startLayerIndex);
        }

        /* Tijdelijke punten ook tonen */
        this.checkTempUploadedPointsWms(this.uploadCsvLayerOn);
    },
    /**
     * Get Max Bounds
     */
    getMaxBounds: function() {
        var maxBounds;
        if (!B3PGissuite.config.bbox && B3PGissuite.config.fullbbox) {
            maxBounds = Utils.createBounds(new Extent(B3PGissuite.config.fullbbox));
        } else if (B3PGissuite.config.bbox && B3PGissuite.config.appExtent) {
            maxBounds = Utils.createBounds(new Extent(B3PGissuite.config.appExtent));
        } else if (B3PGissuite.config.bbox && B3PGissuite.config.fullbbox) {
            maxBounds = Utils.createBounds(new Extent(B3PGissuite.config.fullbbox));
        } else if (B3PGissuite.config.bbox && !B3PGissuite.config.fullbbox) {
            maxBounds = Utils.createBounds(new Extent(B3PGissuite.config.bbox));
        } else {
            var bounds = B3PGissuite.viewercommons.getNLMaxBounds();
            maxBounds = new OpenLayers.Bounds(bounds.left, bounds.bottom, bounds.right, bounds.top);
        }

        /* Aanpassen maxBounds aan huidige beeldscherm verhoudingen */
        var oldMapWidth = maxBounds.right - maxBounds.left;
        var oldMapHeight = maxBounds.top - maxBounds.bottom;

        var screenWidth = $j("#mapcontent").width();
        var heightMapContent = $j("#mapcontent").height();
        var dataframehoogte = $j("#dataframediv").height();

        // TODO: Fix this, what is this 75?
        var screenHeight = heightMapContent + dataframehoogte + 75;

        var ratio = screenWidth / screenHeight;
        var mapRatio = oldMapWidth / oldMapHeight;

        // calc new map height
        if (ratio < mapRatio) {
            var newHeight = oldMapWidth / ratio;
            maxBounds.bottom = maxBounds.bottom - ((newHeight - oldMapHeight) / 2);
            maxBounds.top = maxBounds.bottom + newHeight;
            // calc new map width
        } else {
            var newWidth = oldMapHeight * ratio;
            maxBounds.left = maxBounds.left - ((newWidth - oldMapWidth) / 2);
            maxBounds.right = maxBounds.left + newWidth;
        }

        return maxBounds;
    },
    /* Methode herberekend ingevulde tiling resoluties o.b.v. max eetent. 
     * Geeft een array of string terug. */
    getTilingResolutions: function(maxBounds, returnArray) {
        var newMapWidth = maxBounds.right - maxBounds.left;

        /* Alle tiling resoluties in een lijst zetten */
        var olRes;
        if (B3PGissuite.config.tilingResolutions) {
            var res = B3PGissuite.config.tilingResolutions; //.trim();

            var list;
            if (res.indexOf(",") !== -1) {
                list = res.split(",");
            } else {
                list = res.split(" ");
            }

            if (list && list.length > 0) {
                olRes = [];
                for (var i in list) {
                    list[i] = parseFloat(list[i]);
                    olRes[i] = list[i];
                }
            }
        } else { // wordt nu gezet in ViewerComponent.addLayerToViewer
            B3PGissuite.config.tilingResolutions = B3PGissuite.viewercommons.getNLTilingRes();
            olRes = B3PGissuite.viewercommons.convertStringToArray(B3PGissuite.config.tilingResolutions);
        }

        /* Tiling resoluties die buiten aangepaste extent vallen weglaten */
        if (B3PGissuite.config.tilingResolutions && !B3PGissuite.config.fullExtent) {
            /* TODO: Kijken of deze berekeningen niet later kunnen. Bijvoorbeeld
             * na het maken van de map en het opbouwen van de layout. Ivm het ophalen
             * van de hoogte of als de gebruiker het scherm groter of kleiner maakt
             */
            var screenWidth = $j("#mapcontent").width();
            //var screenHeight = $j("#mapcontent").height() + defaultdataframehoogte + 75;

            var resolution = newMapWidth / screenWidth;

            var dpm = 72 / 0.0254;
            var scale = (resolution * dpm) / 1000;

            var newList = [];
            var counter = 0;
            for (var idx in olRes) {
                if (olRes[idx] <= scale) {
                    newList[counter] = olRes[idx];
                    counter++;
                }
            }

            olRes = newList;
        }

        if (!returnArray) { // openlayers gebruikt een array

            var str = "";
            for (var k in olRes) {
                str += parseFloat(olRes[k]) + " ";
            }

            var flRes = str.trim();

            return flRes;
        }

        return olRes;
    },
    /**
     * Replace illegal chars for Flamingo xml in id
     * @param lname
     */
    getValidLayerId: function(lname) {
        lname = lname.replace(":", "_");
        lname = lname.replace(".", "_");
        return lname;
    },
    /**
     * layersOnlyHaveDefaultStyles
     * @param layerItems
     */
    layersOnlyHaveDefaultStyles: function(layerItems) {
        if (layerItems == undefined || layerItems == "")
            return true;

        for (var i = 0; i < layerItems.length; i++) {
            var item = layerItems[i];

            if (item.use_style && item.use_style != "default")
                return false;
        }

        return true;
    },
    checkTempUploadedPointsWms: function(checked) {
        this.uploadCsvLayerOn = checked;
        var layer = B3PGissuite.vars.webMapController.getMap().getLayer("uploadedPoints");

        if (checked && layer == null) {
            this.addTempUploadedPointsWms();
        } else if (checked && layer) {
            layer.setVisible(true);
        } else if (!checked && layer) {
            /* Removing layer otherwise it is visible in print */
            B3PGissuite.vars.webMapController.getMap().removeLayer(layer);
        }
    },
    addTempUploadedPointsWms: function() {
        var lname = "uploadedPoints";
        var layerUrl = B3PGissuite.viewercommons.getBaseUrl() + "/UploadedPointsWmsServlet";

        var options = {
            id: lname,
            timeout: 30,
            retryonerror: 10,
            ratio: 1,
            showerrors: true,
            initService: false,
            minscale: 0,
            maxscale: 500000
        };

        var ogcOptions = {
            format: "image/png",
            layers: "tempPointsLayer",
            transparent: true,
            exceptions: "application/vnd.ogc.se_inimage",
            srs: "EPSG:28992",
            version: "1.1.1",
            noCache: true
        };

        var newLayer = B3PGissuite.vars.webMapController.createWMSLayer(lname, layerUrl, ogcOptions, options);
        B3PGissuite.vars.webMapController.getMap().addLayer(newLayer);
    },

    initFullExtent: function() {
        /* Extent uit url */
        if (B3PGissuite.config.bbox != null && B3PGissuite.config.bbox.length > 0 && B3PGissuite.config.bbox.split(",").length == 4) {
            if (B3PGissuite.config.fullExtent != null && B3PGissuite.config.fullExtent.length > 0 && B3PGissuite.config.fullExtent.split(",").length == 4) {
                setFullExtent(B3PGissuite.config.fullExtent.split(",")[0], B3PGissuite.config.fullExtent.split(",")[1], B3PGissuite.config.fullExtent.split(",")[2], B3PGissuite.config.fullExtent.split(",")[3]);
            } else {
                setFullExtent(B3PGissuite.config.bbox.split(",")[0], B3PGissuite.config.bbox.split(",")[1], B3PGissuite.config.bbox.split(",")[2], B3PGissuite.config.bbox.split(",")[3]);
            }

            /* Extent uit Flamingo */
        } else if (B3PGissuite.config.fullbbox != null && B3PGissuite.config.fullbbox.length > 0 && B3PGissuite.config.fullbbox.split(",").length == 4) {
            setFullExtent(B3PGissuite.config.fullbbox.split(",")[0], B3PGissuite.config.fullbbox.split(",")[1], B3PGissuite.config.fullbbox.split(",")[2], B3PGissuite.config.fullbbox.split(",")[3]);

            /* Als er geen van bovenstaande is ingesteld dan heel Nederland */
        } else {
            B3PGissuite.config.bbox = B3PGissuite.viewercommons.getNLExtent();
            B3PGissuite.config.fullbbox = B3PGissuite.viewercommons.getNLExtent();

            var bounds = B3PGissuite.viewercommons.getNLMaxBounds();

            setFullExtent(bounds.left, bounds.bottom, bounds.right, bounds.top);
        }
    },

    setStartExtent: function() {
        /* Eerst kijken of er een zoekextent is */
        if (B3PGissuite.vars.searchExtent != null) {
            B3PGissuite.vars.webMapController.getMap("map1").moveToExtent(B3PGissuite.vars.searchExtent);

            /* Extent uit url */
        } else if (B3PGissuite.config.bbox != null && B3PGissuite.config.bbox.length > 0 && B3PGissuite.config.bbox.split(",").length == 4) {
            setTimeout(function() {
                moveToExtent(B3PGissuite.config.bbox.split(",")[0], B3PGissuite.config.bbox.split(",")[1], B3PGissuite.config.bbox.split(",")[2], B3PGissuite.config.bbox.split(",")[3]);
            }, 1);

            /* Extent uit Flamingo */
        } else if (B3PGissuite.config.fullbbox != null && B3PGissuite.config.fullbbox.length > 0 && B3PGissuite.config.fullbbox.split(",").length == 4) {
            setTimeout(function() {
                moveToExtent(B3PGissuite.config.fullbbox.split(",")[0], B3PGissuite.config.fullbbox.split(",")[1], B3PGissuite.config.fullbbox.split(",")[2], B3PGissuite.config.fullbbox.split(",")[3]);
            }, 1);

        } else if (B3PGissuite.config.resolution) {
            B3PGissuite.vars.webMapController.getMap().zoomToResolution(B3PGissuite.config.resolution);

            /* Als er geen van bovenstaande is ingesteld dan heel Nederland */
        } else {
            B3PGissuite.config.bbox = B3PGissuite.viewercommons.getNLExtent();
            B3PGissuite.config.fullbbox = B3PGissuite.viewercommons.getNLExtent();

            var bounds = B3PGissuite.viewercommons.getNLMaxBounds();

            setTimeout(function() {
                moveToExtent(bounds.left, bounds.bottom, bounds.right, bounds.top);
            }, 1);
        }
    },

    /**
     * Initialize the tools used in the viewer. It registers the event and handler
     * for the tool.
     */
    initializeButtons: function() {
        /*ie bug fix*/
        if (B3PGissuite.vars.ltIE8) {
            var mapId = B3PGissuite.vars.webMapController.getMap().getFrameworkMap().id;
            var viewport = document.getElementById(mapId + '_OpenLayers_ViewPort');
            if (viewport) {
                viewport.style.position = "absolute";
            }
        }

        B3PGissuite.vars.webMapController.createPanel("toolGroup");

        B3PGissuite.vars.webMapController.addTool(B3PGissuite.vars.webMapController.createTool("loading", Tool.LOADING_BAR));

        /* Zoom tool */
        var zoomBox = B3PGissuite.vars.webMapController.createTool("toolZoomin", Tool.ZOOM_BOX, {
            title: 'inzoomen via selectie'
        });
        B3PGissuite.vars.webMapController.addTool(zoomBox);

        /* Pan tool */
        var pan = B3PGissuite.vars.webMapController.createTool("b_pan", Tool.PAN, {
            title: 'kaartbeeld slepem'
        });
        B3PGissuite.vars.webMapController.addTool(pan);
        //set default tool pan so the cursor is ok.
        if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
            B3PGissuite.vars.webMapController.activateTool("b_pan");
        }

        /* Previous extent tool */
        var prevExtent = B3PGissuite.vars.webMapController.createTool("toolPrevExtent", Tool.NAVIGATION_HISTORY, {
            title: 'stap terug'
        });
        B3PGissuite.vars.webMapController.addTool(prevExtent);

        /* Afstand meten tool */
        var bu_measure = B3PGissuite.vars.webMapController.createTool("b_measure", Tool.MEASURE, {
            title: 'afstand meten'
        });
        //B3PGissuite.vars.webMapController.registerEvent(Event.ON_MEASURE,bu_measure,measured);
        B3PGissuite.vars.webMapController.addTool(bu_measure);

        /* I-tool */
        var options = new Object();
        options["handlerGetFeatureHandler"] = onIdentifyData;
        options["handlerBeforeGetFeatureHandler"] = onIdentify;
        options["title"] = "informatie opvragen";
        var identify = B3PGissuite.vars.webMapController.createTool("identify", Tool.GET_FEATURE_INFO, options);
        B3PGissuite.vars.webMapController.addTool(identify);
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_SET_TOOL, identify, onChangeTool);

        var editLayer = B3PGissuite.vars.webMapController.createVectorLayer("editMap");
        B3PGissuite.vars.webMapController.getMap().addLayer(editLayer);
        B3PGissuite.vars.webMapController.getMap().setLayerIndex(editLayer, B3PGissuite.vars.webMapController.getMap().getLayers().length + B3PGissuite.vars.startLayerIndex);

        /* Redlining tools */
        var edittingtb = B3PGissuite.vars.webMapController.createTool("redLiningContainer", Tool.DRAW_FEATURE, {
            layer: editLayer
        });
        B3PGissuite.vars.webMapController.addTool(edittingtb);

        /* Draw Polygon with measured surface area  */
        var bu_polyMeasure = B3PGissuite.vars.webMapController.createTool("b_polyMeasure", Tool.MEASURED_POLYGON, {
            title: 'oppervlakte meten',
            displayClass: 'olControlb_polyMeasure'
        });
        B3PGissuite.vars.webMapController.addTool(bu_polyMeasure);

        /* Buffer tool */
        var bu_buffer = B3PGissuite.vars.webMapController.createTool("b_buffer", Tool.BUTTON, {
            layer: editLayer,
            title: 'buffer het tekenobject'
        });
        B3PGissuite.vars.webMapController.addTool(bu_buffer);
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_buffer, b_buffer);

        /* Selecteer kaartobject tool */
        var bu_highlight = B3PGissuite.vars.webMapController.createTool("b_highlight", Tool.BUTTON, {
            layer: editLayer,
            title: 'selecteer een object in de kaart'
        });
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_highlight, b_highlight);
        B3PGissuite.vars.webMapController.addTool(bu_highlight);

        /* Selecteer binnen kaartobject tool */
        var bu_getfeatures = B3PGissuite.vars.webMapController.createTool("b_getfeatures", Tool.BUTTON, {
            layer: editLayer,
            title: 'selecteer binnen geselecteerd kaartobject'
        });
        B3PGissuite.vars.webMapController.addTool(bu_getfeatures);
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_getfeatures, b_getfeatures);

        /* Verwijder polygon tool */
        var bu_removePolygons = B3PGissuite.vars.webMapController.createTool("b_removePolygons", Tool.BUTTON, {
            layer: editLayer,
            title: 'verwijder het tekenobject'
        });
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_removePolygons, b_removePolygons);
        B3PGissuite.vars.webMapController.addTool(bu_removePolygons);

        /* Print tool */
        var bu_print = B3PGissuite.vars.webMapController.createTool("b_printMap", Tool.BUTTON, {
            layer: editLayer,
            title: 'printvoorbeeld'
        });
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_print, b_print);
        B3PGissuite.vars.webMapController.addTool(bu_print);

        /* Kaartselectie tool */
        var bu_layerSelection = B3PGissuite.vars.webMapController.createTool("b_layerSelection", Tool.BUTTON, {
            layer: editLayer,
            title: 'kaartselectie'
        });
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_layerSelection, b_layerSelection);
        B3PGissuite.vars.webMapController.addTool(bu_layerSelection);

        var gpsComponent = new GPSComponent(B3PGissuite.config.gpsBuffer);

        var bu_gps = B3PGissuite.vars.webMapController.createTool("b_gps", Tool.GPS, {
            layer: editLayer,
            title: 'zet GPS locatie aan/uit'
        });

        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_UP, bu_gps, gpsComponent.stopPolling);
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_gps, gpsComponent.startPolling);

        /* off event voor weghalen marker */
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_UP, bu_gps, b_gps_stop);

        B3PGissuite.vars.webMapController.addTool(bu_gps);

        /* Overzichtskaart tool */
        var bu_overview = B3PGissuite.vars.webMapController.createTool("b_showOverzicht", Tool.BUTTON, {
            layer: editLayer,
            title: 'overzichtskaart'
        });
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_EVENT_DOWN, bu_overview, b_overview);
        B3PGissuite.vars.webMapController.addTool(bu_overview);

        var scalebar = B3PGissuite.vars.webMapController.createTool("scalebar", Tool.SCALEBAR);
        B3PGissuite.vars.webMapController.addTool(scalebar);


        var zoombar = B3PGissuite.vars.webMapController.createTool("zoombar", Tool.ZOOM_BAR);
        B3PGissuite.vars.webMapController.addTool(zoombar);

        B3PGissuite.vars.editComponent = new EditComponent();

        if (B3PGissuite.config.viewerTemplate == "embedded") {
            this.displayEmbeddedMenuIcons();
        }
    },

    displayEmbeddedMenuIcons: function() {
        $j("#embedded_icons").css('position', 'absolute');
        $j("#embedded_icons").css('width', '170px');
        $j("#embedded_icons").css('height', '36px');

        $j("#embedded_icons .embedded_icon").css('float', 'left');
        $j("#embedded_icons .embedded_icon").css('padding-top', '7px');
        $j("#embedded_icons .embedded_icon").css('padding-left', '15px');

        if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
            $j("#embedded_icons").css('left', '670px');
            $j("#embedded_icons").css('top', '6px');
            $j("#embedded_icons").css('border', 'solid 1px #808080');
            $j("#embedded_icons").css('background-color', '#eeeeee');
        } else {
            $j("#embedded_icons").css('left', '630px');
            $j("#embedded_icons").css('top', '2px');
        }

        $j("#embedded_icons").show();
    },

    checkDisplayButtons: function() {
        if (B3PGissuite.config.showRedliningTools) {
            if (B3PGissuite.vars.webMapController.getTool("redLiningContainer")) {
                B3PGissuite.vars.webMapController.getTool("redLiningContainer").setVisible(true);
            } else {
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_point").setVisible(true);
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_line").setVisible(true);
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_polygon").setVisible(true);
            }
        } else {
            if (B3PGissuite.vars.webMapController.getTool("redLiningContainer")) {
                B3PGissuite.vars.webMapController.getTool("redLiningContainer").setVisible(false);
            } else {
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_point").setVisible(false);
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_line").setVisible(false);
                B3PGissuite.vars.webMapController.getTool("redLiningContainer_polygon").setVisible(false);
            }
        }

        if (B3PGissuite.config.showBufferTool) {
            B3PGissuite.vars.webMapController.getTool("b_buffer").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_buffer").setVisible(false);
        }

        if (B3PGissuite.config.showSelectBulkTool) {
            B3PGissuite.vars.webMapController.getTool("b_getfeatures").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_getfeatures").setVisible(false);
        }

        if (B3PGissuite.config.showNeedleTool) {
            B3PGissuite.vars.webMapController.getTool("b_highlight").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_highlight").setVisible(false);
        }

        if (B3PGissuite.config.showRedliningTools || B3PGissuite.config.showNeedleTool) {
            B3PGissuite.vars.webMapController.getTool("b_removePolygons").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_removePolygons").setVisible(false);
        }

        if (B3PGissuite.config.showPrintTool) {
            B3PGissuite.vars.webMapController.getTool("b_printMap").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_printMap").setVisible(false);
        }

        if (B3PGissuite.config.showLayerSelectionTool) {
            B3PGissuite.vars.webMapController.getTool("b_layerSelection").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_layerSelection").setVisible(false);
        }

        if (B3PGissuite.config.showGPSTool) {
            B3PGissuite.vars.webMapController.getTool("b_gps").setVisible(true);
        } else {
            B3PGissuite.vars.webMapController.getTool("b_gps").setVisible(false);
        }
    },

    /**
     * Hides the I-tool icon. (Flamingo only)
     */
    hideIdentifyIcon: function() {
        if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
            B3PGissuite.vars.webMapController.getMap().getFrameworkMap().callMethod('map1_identifyicon', 'hide');
        }
    },

    /**
     * Shows the I-tool icon. (Flamingo only)
     */
    showIdentifyIcon: function() {
        if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
            B3PGissuite.vars.webMapController.getMap().getFrameworkMap().callMethod('map1_identifyicon', 'show');
        }
    },

    /**
     * Because a simple reload won't change the url in flamingo. Remove the layer
     * and add it again. Maybe a getCap is done but with a little luck the browser
     * cached the last request.
     * @param sldUrl The SLD url for the layer.
     * @param reAddLayer If true the layer will be removed and added again.
     */
    setSldOnDefaultMap: function(sldUrl, reAddLayer) {
        var kbLayer = B3PGissuite.vars.webMapController.getMap("map1").getLayer("fmcLayer");
        kbLayer.setSld(escape(sldUrl));

        if (reAddLayer) {
            B3PGissuite.vars.webMapController.getMap("map1").removeLayerById(kbLayer.getId(), false);
            B3PGissuite.vars.webMapController.getMap("map1").addLayer(kbLayer);
        }
    },

    reloadRedliningLayer: function(themaId, projectnaam, removeFeatures) {
        var groepParam = "GROEPNAAM";
        var projectParam = "PROJECTNAAM";

        if (!B3PGissuite.viewercommons.isStringEmpty(B3PGissuite.config.organizationcode)) {
            B3PGissuite.vars.layerUrl = B3PGissuite.vars.originalLayerUrl + groepParam + "=" + B3PGissuite.config.organizationcode;
        }

        if (!B3PGissuite.viewercommons.isStringEmpty(projectnaam)) {
            B3PGissuite.vars.layerUrl = B3PGissuite.vars.originalLayerUrl + projectParam + "=" + projectnaam;
        }

        if (!B3PGissuite.viewercommons.isStringEmpty(B3PGissuite.config.organizationcode) && !B3PGissuite.viewercommons.isStringEmpty(projectnaam)) {
            B3PGissuite.vars.layerUrl = B3PGissuite.vars.originalLayerUrl + groepParam + "=" + B3PGissuite.config.organizationcode + "&" + projectParam + "=" + projectnaam;
        }

        /* tekenobject van kaart afhalen */
        if (removeFeatures) {
            this.removeAllFeatures();
        }

        /* TODO: Beetje lelijk gewoon vinkje aan uitzetten om redlining laag te refreshen
         * wellicht een keer methode schrijven voor de webmapcontroller die
         * iets dergelijks kan doen */
        var treeComponent = B3PGissuite.get('TreeComponent');
        if (treeComponent !== null) {
            treeComponent.deActivateCheckbox(themaId);
            treeComponent.activateCheckbox(themaId);
        }
    },

    removeAllFeatures: function() {
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
    },

    removeAllMarkers: function() {
        B3PGissuite.vars.webMapController.getMap().removeAllMarkers();
    },

    stopDrawPolygon: function() {
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").stopDrawDrawFeature();
    },

    startDrawPolygon: function(geomType) {
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
        B3PGissuite.vars.webMapController.getMap().getLayer("editMap").drawFeature(geomType);
    }
});