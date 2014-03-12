B3PGissuite.vars.ltIE8 = document.getElementsByTagName("html")[0].className.match(/lt-ie8/);
/**
 * Array with the current visible layers in correct order.
 * The last is rendered on top.
 */
B3PGissuite.vars.enabledLayerItems = [];
B3PGissuite.vars.dataframepopupHandle = null;
/**
 * String that forms the request to the service. It contains the normal wms request
 * parameters appened with the kaartenbalie url and if available also PROJECT
 * or organization code parameters.
 */
B3PGissuite.vars.layerUrl = "" + B3PGissuite.config.kburl;
/**
 * Cookie arrays with checked layers and clusters (csv string)
 */
B3PGissuite.vars.cookieArray = (B3PGissuite.config.useCookies ? B3PGissuite.commons.readCookie('checkedLayers') : null);
B3PGissuite.vars.cookieClusterArray = (B3PGissuite.config.useCookies ? B3PGissuite.commons.readCookie('checkedClusters') : null);
/**
 * The web map controller
 */
B3PGissuite.vars.webMapController = null;
/**
 * Index used when adding layers. So its possible to leave indexes not used.
 */
B3PGissuite.vars.startLayerIndex = 0;

/**
 * Ballon reference.
 */
B3PGissuite.vars.balloon = null;
B3PGissuite.vars.mapInitialized = false;
B3PGissuite.vars.searchExtent = null;
B3PGissuite.vars.multiPolygonBufferWkt = null;
B3PGissuite.vars.editComponent = null;
B3PGissuite.vars.prevRadioButton = null;
B3PGissuite.vars.originalLayerUrl = "" + B3PGissuite.vars.layerUrl;
B3PGissuite.vars.refresh_timeout_handle = 0;
B3PGissuite.vars.teller = 0;
B3PGissuite.vars.frameWorkInitialized = false;
B3PGissuite.vars.nextIdentifyExtent = null;
B3PGissuite.vars.exportMapWindow = null;
B3PGissuite.vars.btn_highLightSelected = false;
B3PGissuite.vars.highLightGeom = null;
//do only once.
B3PGissuite.vars.initialized = false;
/* build popup functions */
B3PGissuite.vars.currentpopupleft = null;
B3PGissuite.vars.currentpopuptop = null;
B3PGissuite.vars.editingRedlining = false;
B3PGissuite.vars.redLineGegevensbronId = -1;
B3PGissuite.vars.popupCreated = false;

B3PGissuite.viewercommons = {
    /**
     * Controleert of een item in de huidige schaal past.
     * Voor een enkele layer wordt gekeken of die er in past
     * Voor een cluster wordt gekeken of er 1 van de layers in de schaal past.
     * @param item json thema of cluster
     * @param scale de scale waarvoor gekeken moet worden of de layer daar zichtbaar is.
     * @return boolean wel of niet zichtbaar in scale.
     */
    isItemInScale: function(item, scale) {
        if (scale == 'NaN' || scale < 0 || !item) {
            return false;
        }

        var itemVisible = true;

        if (item.children) {
            itemVisible = false;
            for (var i = 0; i < item.children.length; i++) {
                if(this.isItemInScale(item.children[i], scale)) {
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

    convertStringToArray: function(waarde) {
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

    getNLExtent: function() {
        return "12000,304000,280000,620000";
    },
    getNLMaxBounds: function() {
        return Utils.createBounds(new Extent(this.getNLExtent()));
    },
    getNLTilingRes: function() {
        return "512,256,128,64,32,16,8,4,2,1,0.5,0.125";
    },

    getBaseUrl: function() {
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
    getBboxMinSize2: function(feature) {
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
    loadBusyJSP: function(handle, type) {
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

    /**
     * Handles onIdentify by the user to retrieve object information. This function
     * submits the data via form to the back-end.
     * @param geom The (buffered) geometry of the click location.
     * @param highlightThemaId Is used to also highlight the clicked object.
     * @param selectionWithinObject Boolean indicates if it should retrieve objectdata
     * for all objects within the current selection (polygon). When false it retrives only
     * data directly under the (buffered) click location.
     * @param themaIds the thema ids where this request must be done. If ommited the 
     * selected thema's are used. It doesn't change the checkboxes.
     * @param extraCriteria JavaScript object with CQL criteria that is used as filter for getting the features.
     */
    handleGetAdminData: function(geom, highlightThemaId, selectionWithinObject, themaIds, extraCriteria) {

        if (!B3PGissuite.config.usePopup && !B3PGissuite.config.usePanel && !B3PGissuite.config.useBalloonPopup) {
            return;
        }

        removeSearchResultMarker();

        var treeComponent = B3PGissuite.get('TreeComponent');
        if (themaIds === undefined) {
            if (!B3PGissuite.config.multipleActiveThemas && treeComponent !== null) {
                themaIds = treeComponent.getActiveAnalyseThemaId();
            } else {
                themaIds = this.getLayerIdsAsString(true);
            }

            if (themaIds == null || themaIds == '') {
                B3PGissuite.commons.hideLoading();
                return;
            }
        }

        //set the extra criteria.
        document.forms[0].extraCriteria.value = "";
        if (extraCriteria) {
            document.forms[0].extraCriteria.value = extraCriteria;
        }

        //set the correct action
        document.forms[0].admindata.value = 't';
        document.forms[0].metadata.value = '';
        document.forms[0].objectdata.value = '';

        document.forms[0].themaid.value = themaIds;

        document.forms[0].lagen.value = '';

        //als er een init search is meegegeven (dus ook een sld is gemaakt)
        if (B3PGissuite.config.searchAction.toLowerCase().indexOf("filter") >= 0) {

            document.forms[0].search.value = B3PGissuite.config.search;
            document.forms[0].B3PGissuite.config.searchId.value = B3PGissuite.config.searchId;
            document.forms[0].B3PGissuite.config.searchClusterId.value = B3PGissuite.config.searchClusterId;
        }

        document.forms[0].geom.value = geom;

        var schaal;
        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
            schaal = B3PGissuite.vars.webMapController.getMap().getResolution();
        } else {
            schaal = B3PGissuite.vars.webMapController.getMap().getScaleHint();
        }

        document.forms[0].scale.value = schaal;
        document.forms[0].tolerance.value = B3PGissuite.config.tolerance;

        if (selectionWithinObject) {
            document.forms[0].withinObject.value = "1";
            document.forms[0].onlyFeaturesInGeom.value = "true";
        } else {
            document.forms[0].withinObject.value = "-1";
            document.forms[0].onlyFeaturesInGeom.value = "false";
        }

        if (B3PGissuite.config.bookmarkAppcode != null) {
            document.forms[0].bookmarkAppcode.value = B3PGissuite.config.bookmarkAppcode;
        }

        if (highlightThemaId != null) {
            document.forms[0].themaid.value = highlightThemaId;
        }

        if (B3PGissuite.config.usePopup) {
            // open popup when not opened en submit form to popup
            if (B3PGissuite.vars.dataframepopupHandle == null || B3PGissuite.vars.dataframepopupHandle.closed) {
                if (B3PGissuite.config.useDivPopup) {
                    B3PGissuite.vars.dataframepopupHandle = popUpData('dataframedivpopup', 680, 225, true);
                } else {
                    B3PGissuite.vars.dataframepopupHandle = popUpData('dataframepopup', 680, 225, false);
                }
            }

            if (B3PGissuite.config.useDivPopup) {
                //$j("#popupWindow").show();
                document.forms[0].target = 'dataframedivpopup';
                B3PGissuite.viewercommons.loadBusyJSP(B3PGissuite.vars.dataframepopupHandle, 'div');
            } else {
                document.forms[0].target = 'dataframepopup';
                B3PGissuite.viewercommons.loadBusyJSP(B3PGissuite.vars.dataframepopupHandle, 'window');
            }

            /* display marker in middle of click point */
            var point = this.getPointFromGeom(geom);
            placeSearchResultMarker(point.x, point.y);

        } else if (B3PGissuite.config.useBalloonPopup) {
            if (!B3PGissuite.vars.balloon) {
                var offsetX = 0;
                var offsetY = 0;

                /* offsetY nodig voor de flamingo toolbalk boven de kaart */
                if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
                    offsetY = 36;
                }

                B3PGissuite.vars.balloon = new Balloon($j("#mapcontent"), B3PGissuite.vars.webMapController, 'infoBalloon', 300, 300, offsetX, offsetY);
            }
            document.forms[0].target = 'dataframeballoonpopup';

            /*Bepaal midden van vraag geometry*/
            var point = this.getPointFromGeom(geom);

            //B3PGissuite.vars.balloon.resetPositionOfBalloon(centerX,centerY);
            B3PGissuite.vars.balloon.setPosition(point.x, point.y, true);

            var iframeElement = $j('<iframe id="dataframeballoonpopup" name="dataframeballoonpopup" class="popup_Iframe" src="admindatabusy.do?theme=' + B3PGissuite.config.theme + '" frameborder="0">');
            B3PGissuite.vars.balloon.getContentElement().html(iframeElement);
        } else {
            document.forms[0].target = 'dataframe';
            B3PGissuite.viewercommons.loadBusyJSP('dataframe', 'panel');
        }

        document.forms[0].submit();
    },

    getPointFromGeom: function(geom) {
        var coordString = geom.replace(/POLYGON/g, '').replace(/POINT/, '').replace(/\(/g, '').replace(/\)/g, '');
        var xyPairs = coordString.split(",");

        var minx;
        var maxx;
        var miny;
        var maxy;

        for (var i = 0; i < xyPairs.length; i++) {
            var xy = xyPairs[i].split(" ");
            var x = Number(xy[0]);
            var y = Number(xy[1]);

            if (minx === undefined) {
                minx = x;
                maxx = x;
            }
            if (miny === undefined) {
                miny = y;
                maxy = y;
            }
            if (x > maxx) {
                maxx = x;
            }
            if (x < minx) {
                minx = x;
            }
            if (y > maxy) {
                maxy = y;
            }
            if (y < miny) {
                miny = y;
            }
        }

        var centerX = (minx + maxx) / 2;
        var centerY = (miny + maxy) / 2;

        return { x: centerX, y: centerY };
    },

    switchTab: function(id) {
        if (tabComponent.hasTab(id)) {
            tabComponent.setActive(id);
        }
        if (leftTabComponent.hasTab(id)) {
            leftTabComponent.setActive(id);
        }
    },

    isStringEmpty: function(str) {
        return (!str || 0 === str.length);
    },

    /*
     * Calculates and returns the ??? from 1:??? for the current extent and 
     * current mapwidth in pixels. Average ppi value assumed. The 0.00028
     * could be made into a config setting in gisviewerconfig.
     */
    calcScaleForCurrentExtent: function() {
        var extent = B3PGissuite.vars.webMapController.getMap().getExtent();
        var newMapWidth = extent.maxx - extent.minx;

        var screenWidth = $j("#mapcontent").width();
        var scale = newMapWidth / (screenWidth * 0.00028);

        return Math.round(Number(scale));
    },

    /* Kan gebruikt worden om wat debug info onderin de kaartboom weer te geven zoals
     * specifieke timings of huidig omgerekende schaal */
    setDebugContent: function() {
        var scale = calcScaleForCurrentExtent();
        var html = "<p><b>Schaal 1 : " + scale + "</b></p>";

        $j("#debug-content").html(html);
    },

    loadObjectInfo: function(geom) {
        var gebiedenTabActive = false;

        for (i in B3PGissuite.config.enabledtabs) {
            if (B3PGissuite.config.enabledtabs[i] === "gebieden") {
                gebiedenTabActive = true;
            }
        }

        for (i in B3PGissuite.config.enabledtabsLeft) {
            if (B3PGissuite.config.enabledtabsLeft[i] === "gebieden") {
                gebiedenTabActive = true;
            }
        }

        if (!gebiedenTabActive) {
            return;
        }

        var activeAnalyseThemaId = '';
        var treeComponent = B3PGissuite.get('TreeComponent');

        if (treeComponent !== null) {
            activeAnalyseThemaId = treeComponent.getActiveAnalyseThemaId();
        }

        document.forms[0].admindata.value = '';
        document.forms[0].metadata.value = '';

        if (!B3PGissuite.config.multipleActiveThemas) {
            document.forms[0].themaid.value = activeAnalyseThemaId;
        } else {
            document.forms[0].themaid.value = this.getLayerIdsAsString();
        }

        document.forms[0].analysethemaid.value = activeAnalyseThemaId;
        document.forms[0].objectdata.value = 't';
        document.forms[0].target = 'objectframeViewer';

        // Use current scale and tolerance for click point
        var schaal;
        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
            schaal = B3PGissuite.vars.webMapController.getMap().getResolution();
        } else {
            schaal = B3PGissuite.vars.webMapController.getMap().getScaleHint();
        }

        document.forms[0].scale.value = schaal;
        document.forms[0].tolerance.value = B3PGissuite.config.tolerance;

        document.forms[0].geom.value = geom;

        document.forms[0].submit();
    },

    /**
     * Get alle enabled layer items
     * @param onlyWithinScale Only get the visible, within currentScale items.
     */
    getLayerIdsAsString: function(onlyWithinScale) {
        var ret = "";
        var firstTime = true;
        var treeComponent = B3PGissuite.get('TreeComponent');

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

                if (!B3PGissuite.viewercommons.isItemInScale(B3PGissuite.vars.enabledLayerItems[i], currentscale)) {
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
    }
};

/**
 * Uses a search configuration and search params in the url. Is done when searching via url
 * params and is called when the viewer (framework) is loaded.
 */
function doInitSearch() {
    if (B3PGissuite.config.searchConfigId.length > 0 && B3PGissuite.config.search.length >= 0) {
        B3PGissuite.commons.showLoading();

        var termen = B3PGissuite.config.search.split(",");
        
        if (termen && termen.length > 0 && termen[0] != "") {
            JZoeker.zoek(new Array(B3PGissuite.config.searchConfigId), termen, 0, handleInitSearch);
        } else {             
            B3PGissuite.commons.hideLoading();
        }
    }
}

/**
 * Callback method used in doInitSearch() function. This function hides the loading
 * screen and calls the handleInitSearchResult() method for further handling.
 * @param list List with search results from back-end.
 */
function handleInitSearch(list) {
    B3PGissuite.commons.hideLoading();
    
    if (list && list.length > 0) {
        handleInitSearchResult(list[0], B3PGissuite.config.searchAction, B3PGissuite.config.searchId, B3PGissuite.config.searchClusterId, B3PGissuite.config.searchSldVisibleValue);
    }
}

/**
 * Handles the search results from the back-end. It performs the given action.
 * @param result List with search results.
 * @param action The search action to perform (zoom, highlight or filter)
 * @param themaId Adds this value as themaId parameter for the SLD options.
 * @param clusterId Adds this value as clusterId parameter for the SLD options.
 * @param visibleValue Displays this value for the result. If none is provided
 * the result id is displayed instead.
 */
function handleInitSearchResult(result, action, themaId, clusterId, visibleValue) {
    var doZoom = true;
    var doHighlight = false;
    var doFilter = false;
    
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
        if (visval != null) {
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

    placeSearchResultMarker(x, y);
    B3PGissuite.viewercommons.switchTab("zoeken");

    /* Lagen aanzetten na zoeken */
    JZoekconfiguratieThemaUtil.getThemas(B3PGissuite.config.searchConfigId, function(data) {
        zoekconfiguratieThemasCallBack(data);
        switchLayersOn();

        if (doZoom) {
            result = B3PGissuite.viewercommons.getBboxMinSize2(result);
            var ext = new Object();
            ext.minx = result.minx;
            ext.miny = result.miny;
            ext.maxx = result.maxx;
            ext.maxy = result.maxy;
            if (B3PGissuite.vars.mapInitialized) {
                moveToExtent(ext.minx, ext.miny, ext.maxx, ext.maxy);
            } else {
                B3PGissuite.vars.searchExtent = ext;
            }
        }
    });
}

function placeSearchResultMarker(x, y) {
    B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", x, y);
}

function removeSearchResultMarker() {
    B3PGissuite.vars.webMapController.getMap().removeMarker("searchResultMarker");
}

function getActiveLayerId(cookiestring) {
    if (!cookiestring)
        return null;
    var items = cookiestring.split('##');
    return items[0];
}
function getActiveLayerLabel(cookiestring) {
    if (!cookiestring)
        return null;
    var items = cookiestring.split('##');
    return items[1];
}

function onChangeTool(id, event) {
    if (id == 'identify') {        
        B3PGissuite.viewerComponent.hideIdentifyIcon();
        if (webMapController instanceof FlamingoController) {
            B3PGissuite.vars.btn_highLightSelected = false;
        }
    }
}

var currentHighlightWkt;
function onIdentify(movie, extend) {
    if (!B3PGissuite.config.usePopup && !B3PGissuite.config.usePanel && !B3PGissuite.config.useBalloonPopup) {
        return;
    }

    /* Wordt gebruikt om bij het highlighten van analyse lagen de wkt te union'nen
     * met al eerder (aangrenzende) highlight objecten */
    currentHighlightWkt = getWkt();

    //todo: nog weghalen... Dit moet uniform werken.
    if (extend == undefined) {
        extend = movie;
    }

    var geom = "";
    if (extend.minx != extend.maxx && extend.miny != extend.maxy) {
        // polygon
        geom += "POLYGON((";
        geom += extend.minx + " " + extend.miny + ",";
        geom += extend.maxx + " " + extend.miny + ",";
        geom += extend.maxx + " " + extend.maxy + ",";
        geom += extend.minx + " " + extend.maxy + ",";
        geom += extend.minx + " " + extend.miny;
        geom += "))";
    } else {
        // point
        geom += "POINT(";
        geom += extend.minx + " " + extend.miny;
        geom += ")";
    }

    B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();

    /* kijken of bezig met editen redline objecten */
    if (B3PGissuite.vars.editingRedlining) {
        B3PGissuite.viewerComponent.hideIdentifyIcon();
        selectRedlineObject(geom);
        return;
    }

    if (B3PGissuite.vars.btn_highLightSelected) {
        /* TODO: Vervangen voor generiek iets. Dit is nu nodig omdat
         * de flamingo config een breinaald
         * Mogelijke fix: nieuw soort tool maken (de highlight tool). Deze voeg je in OL niet aan
         * de panel toe, maar wel aan de tools array. Deze tool roep de highlightfunctionaliteit in
         * de gisviewer aan.*/
        if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
            B3PGissuite.vars.webMapController.activateTool("breinaald");
        } else {
            B3PGissuite.vars.webMapController.activateTool("identify");
        }

        B3PGissuite.viewerComponent.hideIdentifyIcon();
        highLightThemaObject(geom);
    } else {
        B3PGissuite.vars.btn_highLightSelected = false;

        B3PGissuite.vars.webMapController.activateTool("identify");

        B3PGissuite.viewerComponent.showIdentifyIcon();
        B3PGissuite.viewercommons.handleGetAdminData(geom, null, false);
    }

    B3PGissuite.viewercommons.loadObjectInfo(geom);
}

//update the getFeatureInfo in the feature window.
function updateGetFeatureInfo(data) {

    /* TODO: Deze methode geeft geen GetFeatureInfo weer in Firefox.
     * Werkt wel in IE en Chrome
     */
    var featureInfoTimeOut = 30;
    B3PGissuite.vars.teller++;

    //if times out return;
    if (B3PGissuite.vars.teller > featureInfoTimeOut) {
        B3PGissuite.vars.teller = 0;
        return;
    }

    //if the admindata window is loaded then update the page (add the featureinfo thats given by the getFeatureInfo request.
    if (B3PGissuite.config.usePopup && B3PGissuite.vars.dataframepopupHandle.contentWindow.writeFeatureInfoData) {
        B3PGissuite.vars.dataframepopupHandle.contentWindow.writeFeatureInfoData(data);
        data = null;
    } else if (window.frames.dataframe.writeFeatureInfoData) {
        window.frames.dataframe.writeFeatureInfoData(data);
        data = null;
    } else {
        //if the admindata window is not loaded yet then retry after 1sec
        setTimeout(function() {
            updateGetFeatureInfo(data);
        }, 1000);
    }
}

function onIdentifyData(id, data) {
    B3PGissuite.vars.teller = 0;
    updateGetFeatureInfo(data);
}

function onFrameworkLoaded() {
    if (document.getElementById("treeForm") && (B3PGissuite.commons.getIEVersion() <= 8 && B3PGissuite.commons.getIEVersion() != -1)) {
        document.getElementById("treeForm").reset();
    }

    if (!B3PGissuite.vars.frameWorkInitialized) {
        var treeComponent = B3PGissuite.get('TreeComponent');
        if (treeComponent !== null) {
            treeComponent.clickClusters();
            treeComponent.sortLayersAan();
            treeComponent.clickLayers();
        }

        B3PGissuite.viewerComponent.initFullExtent();
        B3PGissuite.viewerComponent.setStartExtent();

        if (treeComponent !== null) {
            treeComponent.doRefreshLayer();
        }
    }

    B3PGissuite.vars.frameWorkInitialized = true;

    B3PGissuite.vars.mapInitialized = true;

    /* Fix zodat Openlayers viewer ook onAllLayersFinishedLoading() aanroept */
    if (B3PGissuite.vars.webMapController.getMap().isUpdating()) {
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE, B3PGissuite.vars.webMapController.getMap(), onAllLayersFinishedLoading);
    } else {
        setTimeout(onAllLayersFinishedLoading, 0);
    }

    /* Tiling resoluties zetten zodat Flamingo navigatie de juiste zoomniveaus
     * overneemt. Indien geen resoluties opgegeven kun je in Flamingo gewoon
     * oneindig ver blijven inzoomen Let op: Bij OpenLayers gebeurt dit
     * al bij maken Map */
    if (B3PGissuite.vars.webMapController instanceof FlamingoController) {

        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions != '') {
            B3PGissuite.vars.webMapController.getMap("map1").setTilingResolutions(B3PGissuite.config.tilingResolutions);
        }

        /* Standaard pan tool activeren */
        B3PGissuite.vars.webMapController.activateTool("toolPan");
    } else {
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_FINISHED_CHANGE_EXTENT, B3PGissuite.vars.webMapController.getMap(), ol_ZoomEnd);
    }

    updateSizeOL();

    doInitSearch();

    placeStartLocationMarker();
}

function ol_ZoomEnd() {
    var treeComponent = B3PGissuite.get('TreeComponent'),
        legendComponent = B3PGissuite.get('LegendComponent');
    if(treeComponent !== null) {
        treeComponent.checkScaleForLayers();
    }
    if(legendComponent !== null) {
        legendComponent.refreshLegendBox();
    }
}

/*
 * Bit of a hack to use configured tab width in combination with SCSS created stylesheets
 * We need some of the SCSS configured values in addition to the Gisviewerconfig value for tab width
 * We solved this by creating a css-properties container (#css_props) and assigned some CSS values
 * to that DIV so we can read those with JS. We combine these values with the tabWidth configured in
 * the Gisviewerconfig using the same calculation used in SCSS. We append this styling to the head.
 */
function configureTabWidth() {
    var extramargin = parseInt($j('#css_props').css('margin-left'), 10),
            defaultmargin = parseInt($j('#css_props').css('margin-right'), 10),
            csscontent = '';
    if (B3PGissuite.config.tabWidth) {
        // get margins configured in CSS
        var tabwidth = parseInt(B3PGissuite.config.tabWidth, 10),
                tabwidth_margin = tabwidth + extramargin + (2 * defaultmargin);
        // CSS creation, same logic as in SCC stylesheet
        var csscontent = '#content_viewer.tabrechts_open #tab_container, #content_viewer.tabrechts_open #tabjes, #content_viewer.tabrechts_open #nav {' +
                'width: ' + tabwidth + 'px !important;' +
                '}' +
                '#content_viewer.tabrechts_open #mapcontent {' +
                'right: ' + tabwidth_margin + 'px !important;' +
                '}';
    }
    if (B3PGissuite.config.tabWidthLeft) {
        // get margins configured in CSS
        var tabwidthLeft = parseInt(B3PGissuite.config.tabWidthLeft, 10),
                tabwidthleft_margin = tabwidthLeft + extramargin + (2 * defaultmargin);
        // CSS creation, same logic as in SCC stylesheet
        csscontent += '#content_viewer.tablinks_open #leftcontent, #content_viewer.tablinks_open #leftcontenttabjes, #content_viewer.tablinks_open #leftcontentnav {' +
                'width: ' + tabwidthLeft + 'px !important;' +
                '}' +
                '#content_viewer.tablinks_open #mapcontent {' +
                'left: ' + tabwidthleft_margin + 'px !important;' +
                '}';
    }
    if (csscontent !== '') {
        $j("head").append("<style>" + csscontent + "</style>");
    }
}

B3PGissuite.vars.prevUpdateTime = new Date();
B3PGissuite.vars.thresholdTime = 500;
B3PGissuite.vars.timeoutId = null;

function updateSizeOL() {
    if (!B3PGissuite.vars.webMapController instanceof OpenLayersController)
        return;
    var currentUpdateTime = new Date();
    if ((currentUpdateTime.getTime() - B3PGissuite.vars.prevUpdateTime.getTime()) > B3PGissuite.vars.thresholdTime) {
        B3PGissuite.vars.timeoutId = null;
        B3PGissuite.vars.prevUpdateTime = new Date();
        B3PGissuite.vars.webMapController.getMap().updateSize();
    } else {
        if (B3PGissuite.vars.timeoutId !== null) {
            clearTimeout(B3PGissuite.vars.timeoutId);
        }
        B3PGissuite.vars.timeoutId = setTimeout(updateSizeOL, 100);
    }
}

function placeStartLocationMarker() {
    if (B3PGissuite.config.startLocationX != "" && B3PGissuite.config.startLocationY != "") {
        placeSearchResultMarker(B3PGissuite.config.startLocationX, B3PGissuite.config.startLocationY);
    }
}

function ie6_hack_onInit() {
    if (navigator.appVersion.indexOf("MSIE") != -1) {
        version = parseFloat(navigator.appVersion.split("MSIE")[1]);

        if (version == 6) {
            setTimeout("doOnInit=true; onFrameworkLoaded();", 5000);
        }
    }
}

function moveToExtent(minx, miny, maxx, maxy) {
    B3PGissuite.vars.webMapController.getMap().zoomToExtent({
        minx: minx,
        miny: miny,
        maxx: maxx,
        maxy: maxy
    }, 0);

    updateSizeOL();
}

function setFullExtent(minx, miny, maxx, maxy) {
    B3PGissuite.vars.webMapController.getMap().setMaxExtent({
        minx: minx,
        miny: miny,
        maxx: maxx,
        maxy: maxy
    });
}
function doIdentify(minx, miny, maxx, maxy) {
    B3PGissuite.vars.webMapController.getMap().doIdentify({
        minx: minx,
        miny: miny
    });
    B3PGissuite.vars.webMapController.activateTool("identify");
}

function doIdentifyAfterUpdate(minx, miny, maxx, maxy) {
    B3PGissuite.vars.nextIdentifyExtent = {};
    B3PGissuite.vars.nextIdentifyExtent.minx = minx;
    B3PGissuite.vars.nextIdentifyExtent.miny = miny;
    B3PGissuite.vars.nextIdentifyExtent.maxx = maxx;
    B3PGissuite.vars.nextIdentifyExtent.maxy = maxy;
}

function moveAndIdentify(minx, miny, maxx, maxy) {
    moveToExtent(minx, miny, maxx, maxy);
    var centerX = Number(Number(Number(minx) + Number(maxx)) / 2);
    var centerY = Number(Number(Number(miny) + Number(maxy)) / 2);
    //doIdentify(centerX,centerY,centerX,centerY);
    doIdentifyAfterUpdate(centerX, centerY, centerX, centerY);
}

function onAllLayersFinishedLoading(mapId) {
    var treeComponent = B3PGissuite.get('TreeComponent'),
        legendComponent = B3PGissuite.get('LegendComponent');

    if(treeComponent) {
        treeComponent.checkScaleForLayers();
    }

    if (B3PGissuite.vars.nextIdentifyExtent !== null) {
        doIdentify(B3PGissuite.vars.nextIdentifyExtent.minx, B3PGissuite.vars.nextIdentifyExtent.miny, B3PGissuite.vars.nextIdentifyExtent.maxx, B3PGissuite.vars.nextIdentifyExtent.maxy);
        B3PGissuite.vars.nextIdentifyExtent = null;
    }

    if (B3PGissuite.config.waitUntillFullyLoaded) {
        $j("#loadingscreen").hide();
    }

    /* Do again so that layers outside of scale dont show up in legend tab at startup */
    if(legendComponent !== null) {
        legendComponent.refreshLegendBox();
    }

    /* Config optie maken ? */
    if (B3PGissuite.config.showDebugContent) {
        B3PGissuite.viewercommons.setDebugContent();
    }
}

/*Get de flash movie*/
function getMovie(movieName) {
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        return document[movieName];
    }
}

/**
 *Functie zoekt een waarde op (val) van een thema met id
 * themaId uit de thematree list die meegegeven is.
 * @param themaList
 * @param themaId
 * @param val
 **/
function searchThemaValue(themaList, themaId, val) {
    for (var i in themaList) {
        if (i == "id" && themaList[i] == themaId) {
            return themaList[val];
        }

        if (i == "children") {
            for (var ichild in themaList[i]) {
                var returnValue = searchThemaValue(themaList[i][ichild], themaId, val);
                if (returnValue != undefined && returnValue != null) {
                    return returnValue;
                }

            }
        }
    }

    return null;
}

function getWMSRequests() {
    var requests = [];
    var background;

    var bgLayers = new Array();
    var fgLayers = new Array();

    var layers = B3PGissuite.vars.webMapController.getMap("map1").getAllWMSLayers();

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
            var request =
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
        var item = getItemFromWmsLayer(fgLayers[k]);

        var currentscale;
        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
            currentscale = B3PGissuite.vars.webMapController.getMap().getResolution();
        } else {
            currentscale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
        }

        var inScale = B3PGissuite.viewercommons.isItemInScale(item, currentscale);

        /* Also add tem points url in print */
        var testUrl = fgLayers[k].getURL();
        var isTempPointsLayer = false;
        if (testUrl.indexOf("tempPointsLayer") !== -1) {
            isTempPointsLayer = true;
        }

        if (fgLayers[k].getURL() !== null && inScale || isTempPointsLayer) {
            var request = {
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
}

function getItemFromWmsLayer(layer) {
    var item;
    if (layer.options) {
        item = getItemByLayer(B3PGissuite.config.themaTree, layer.options.layers);
    } else {
        item = layer.getFrameworkLayer();
    }

    return item;
}

function getWktStringForPrint() {
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
}

function getLegendUrls() {
    var layerItems = new Array();
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
}

function exportObjectData2PDF(htmlId, gegevensbron, index, idcounter) {
    var pdf_export_url = "services/Data2PDF";

    var pdfFormId = "bronCaption" + htmlId + gegevensbron.id + index + "PDFfrm" + idcounter;
    var submitForm = $j('<form></form>').attr({
        method: 'post',
        action: pdf_export_url,
        target: 'pdfIframe',
        id: pdfFormId,
        style: 'float: left;'
    });

    var submitForm = document.createElement("FORM");
    document.body.appendChild(submitForm);
    submitForm.method = "POST";

    var gbInput = document.createElement('input');
    gbInput.id = 'gbId';
    gbInput.name = 'gbId';
    gbInput.type = 'hidden';
    gbInput.value = gegevensbron.id;
    submitForm.appendChild(gbInput);

    var settingsInput = document.createElement('input');
    settingsInput.id = 'objectIds';
    settingsInput.name = 'objectIds';
    settingsInput.type = 'hidden';
    settingsInput.value = gegevensbron.csvPks;
    submitForm.appendChild(settingsInput);

    var orInput = document.createElement('input');
    orInput.id = 'orientation';
    orInput.name = 'orientation';
    orInput.type = 'hidden';
    orInput.value = 'staand';
    submitForm.appendChild(orInput);

    var wmsRequests = getWMSRequests();
    var tilingRequests = getTilingRequests();

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

    submitForm.target = "pdfIframe";
    submitForm.action = pdf_export_url;

    var jsonSettings = {
        requests: tilingRequests,
        geometries: [],
        bbox: mapBbox,
        width: mapWidth,
        height: mapHeight
    };

    var settingsInput = document.createElement('input');
    settingsInput.id = 'jsonSettings';
    settingsInput.name = 'jsonSettings';
    settingsInput.type = 'hidden';
    settingsInput.value = JSON.stringify(jsonSettings);

    submitForm.appendChild(settingsInput);
    submitForm.submit();

    return;
}

function exportMap() {
    var submitForm = document.createElement("FORM");
    document.body.appendChild(submitForm);
    submitForm.method = "POST";

    /* Legend urls */
    var legendUrlsString = getLegendUrls();

    var legendUrlInput = document.createElement('input');
    legendUrlInput.id = 'legendUrls';
    legendUrlInput.name = 'legendUrls';
    legendUrlInput.type = 'hidden';
    legendUrlInput.value = legendUrlsString;
    submitForm.appendChild(legendUrlInput);

    var wmsRequests = getWMSRequests();
    var tilingRequests = getTilingRequests();

    /* als eerst tiling url's daarna gewone wms meegeven */
    for (var i = 0; i < wmsRequests.length; i++) {
        tilingRequests.push(wmsRequests[i]);
    }

    /* TODO: Width en height meegeven voor tiling berekeningen als er geen gewone
     * wms url in de print zit waar dit uit gehaald kan worden */

    var mapWidth = B3PGissuite.vars.webMapController.getMap("map1").getScreenWidth();
    var mapHeight = B3PGissuite.vars.webMapController.getMap("map1").getScreenHeight();

    var minX = B3PGissuite.vars.webMapController.getMap("map1").getExtent().minx;
    var minY = B3PGissuite.vars.webMapController.getMap("map1").getExtent().miny;
    var maxX = B3PGissuite.vars.webMapController.getMap("map1").getExtent().maxx;
    var maxY = B3PGissuite.vars.webMapController.getMap("map1").getExtent().maxy;

    var mapBbox = minX + "," + minY + "," + maxX + "," + maxY;
    submitForm.target = "exportMapWindowNaam";
    submitForm.action = "printmap.do";

    var wktString = getWktStringForPrint();

    var jsonSettings = {
        requests: tilingRequests,
        geometries: wktString,
        bbox: mapBbox,
        width: mapWidth,
        height: mapHeight
    };

    var jsonSettingsInput = document.createElement('input');
    jsonSettingsInput.id = 'jsonSettings';
    jsonSettingsInput.name = 'jsonSettings';
    jsonSettingsInput.type = 'hidden';

    var jsonString = JSON.stringify(jsonSettings);
    jsonSettingsInput.value = jsonString;
    submitForm.appendChild(jsonSettingsInput);

    submitForm.submit();

    if (B3PGissuite.vars.exportMapWindow == undefined || B3PGissuite.vars.exportMapWindow == null || B3PGissuite.vars.exportMapWindow.closed) {
        B3PGissuite.vars.exportMapWindow = window.open("", "exportMapWindowNaam");
        B3PGissuite.vars.exportMapWindow.focus();
    }
}

function getTilingRequests() {
    var tilingRequests = [];
    var layers = B3PGissuite.vars.webMapController.getMap("map1").getAllTilingLayers();

    /* tiling layers toevoegen */
    for (var j = 0; j < layers.length; j++) {
        var currentscale = B3PGissuite.vars.webMapController.getMap().getResolution();

        var item;
        if (layers[j].options) {
            item = getItemByLayer(B3PGissuite.config.themaTree, layers[j].options.LAYERS);
        } else {
            item = layers[j].getFrameworkLayer();
        }

        var inScale = B3PGissuite.viewercommons.isItemInScale(item, currentscale);

        if (!inScale) {
            continue;
        }

        var bbox = layers[j].getOption("BBOX");
        var resolutions = layers[j].getOption("RESOLUTIONS");
        var tileWidth = layers[j].getOption("TILEWIDTH");
        var tileHeight = layers[j].getOption("TILEHEIGHT");
        var url = buildTilingServiceUrl(layers[j]);

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
}

function checkParam(url, name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");

    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);

    var results = regex.exec(url);
    if (results == null) {
        return false;
    }

    return true;
}

function buildTilingServiceUrl(tilingLayer) {
    var serviceUrl = tilingLayer.getOption("url");

    if (!checkParam(serviceUrl, "service") && !checkParam(serviceUrl, "SERVICE")) {
        serviceUrl += "&SERVICE=" + tilingLayer.getOption("SERVICE");
    }
    if (!checkParam(serviceUrl, "version") && !checkParam(serviceUrl, "VERSION")) {
        serviceUrl += "&VERSION=" + tilingLayer.getOption("VERSION");
    }
    if (!checkParam(serviceUrl, "layer") && !checkParam(serviceUrl, "LAYER")) {
        serviceUrl += "&LAYERS=" + tilingLayer.getOption("LAYERS");
    }
    if (!checkParam(serviceUrl, "styles") && !checkParam(serviceUrl, "STYLES")) {
        serviceUrl += "&STYLES=" + tilingLayer.getOption("STYLES");
    }
    if (!checkParam(serviceUrl, "format") && !checkParam(serviceUrl, "FORMAT")) {
        serviceUrl += "&FORMAT=" + tilingLayer.getOption("FORMAT");
    }
    if (!checkParam(serviceUrl, "srs") && !checkParam(serviceUrl, "SRS")) {
        serviceUrl += "&SRS=" + tilingLayer.getOption("SRS");
    }
    if (!checkParam(serviceUrl, "request") && !checkParam(serviceUrl, "REQUEST")) {
        serviceUrl += "&REQUEST=" + tilingLayer.getOption("REQUEST");
    }

    return serviceUrl;
}

/* Voor openlayers wil je soms de hele polygon op het scherm hebben niet alleen
 * de laatst actieve. Als je bijvoorbeeld in OL een polygon edit krijg je anders 
 * van getActiveFeature alleen de laatste feature (een Point) terug. In
 * this.getFrameworkLayer().features[0] zit het hele polygon.
 */
function getWktActiveFeature(index) {
    var object;
    object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature(index);

    if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
        var arr = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getAllFeatures();

        if (arr && arr.length == 1) {
            object = arr[0];
        }
    }

    if (object == null)
    {
        B3PGissuite.commons.messagePopup("Melding", "Er is nog geen tekenobject op het scherm.", "pencil");
        return null;
    }

    return object.getWkt();
}

function getWktForDownload() {
    var object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature();

    if (object == null) {
        return "";
    }

    return object.getWkt();
}

function getWkt() {
    var object = B3PGissuite.vars.webMapController.getMap().getLayer("editMap").getActiveFeature(-1);

    if (object == null) {
        return null;
    }
    
    if (!object.wktgeom) {
        return object.getWkt();
    }

    return object.wktgeom;
}

function b_getfeatures(id, event) {
    var wkt = getWktActiveFeature(-1);

    if (wkt) {
        B3PGissuite.viewercommons.handleGetAdminData(wkt, null, true);

        // Also load objectinfo into gebieden tab
        B3PGissuite.viewercommons.loadObjectInfo(wkt);
    }
}
/* Buffer functies voor aanroep back-end en tekenen buffer op het scherm */
function b_buffer(id, event) {
    var wkt;

    /* Indien door highlight de global var is gevuld deze
     * dan gebruiken bij buffer als deze niet null is
     * De getWktActiveFeature geeft bij sommige multipolygons niet
     * een correcte wkt terug. er mist dan een , ( of ) waardoor bufferen
     * mis gaat. Deze is dus alleen gevuld na een highlight
     * voor anders getekende polygons wordt gewoon de active feature gebruikt. */
    if (B3PGissuite.vars.multiPolygonBufferWkt != null) {
        wkt = B3PGissuite.vars.multiPolygonBufferWkt;
    } else {
        wkt = getWktActiveFeature(-1);
    }

    B3PGissuite.vars.multiPolygonBufferWkt = null;

    if (wkt == null)
    {
        return;
    }

    var str = prompt('Geef de bufferafstand in meters', '100');
    var afstand = 0;

    if ((str == '') || (str == 'undefined') || (str == null))
        return;

    if (!isNaN(str)) {
        str = str.replace(",", ".");
        afstand = str;
    } else {
        B3PGissuite.commons.messagePopup("Melding", "Geen getal.", "error");
        return;
    }

    if (afstand == 0)
    {
        B3PGissuite.commons.messagePopup("Melding", "Buffer mag niet 0 zijn.", "error");
        return;
    }

    EditUtil.buffer(wkt, afstand, returnBuffer);
}

function b_print(id, event) {
    exportMap();
}

function b_layerSelection(id, event) {
    B3PGissuite.commons.iFramePopup('kaartselectie.do', false, 'Kaartselectie', 800, 600, true, true);
}

function b_overview(id, event) {
    if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
        B3PGissuite.vars.webMapController.getMap().getFrameworkMap().callMethod('overviewwindow', 'show');
    }
}

function b_gps_stop(id, event) {
    B3PGissuite.viewerComponent.removeAllMarkers();
}

function drawFeature(ggbId, attrName, attrVal) {

    JMapData.getWkt(ggbId, attrName, attrVal, drawWkt);
}

function returnBuffer(wkt) {
    drawWkt(wkt);
}

function drawWkt(wkt) {
    if (wkt.length > 0)
    {
        var polyObject = new Feature(61502, wkt);

        drawObject(polyObject);
    }
}

function drawObject(feature) {
    B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
    B3PGissuite.vars.webMapController.getMap().getLayer("editMap").addFeature(feature);
}

/**
 * Alle geimplementeerde eventhandling functies
 * @param id
 * @param params
 */
function b_removePolygons(id, params) {
    currentHighlightWkt = "";    
    highLightedLayerid = 0;
    
    B3PGissuite.vars.btn_highLightSelected = false;

    B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();

    if (B3PGissuite.vars.webMapController instanceof OpenLayersController) {
        var measureValueDiv = document.getElementById("olControlMeasurePolygonValue");
        if (measureValueDiv) {
            measureValueDiv.style.display = "none";
        }
    }
}

/* er is net op de highlight knop gedrukt */
function b_highlight(id, params) {
    
    /* For OpenLayers turn on or off because otherwise you cannot turn off
     * highlighting in OpenLayers */
    if (webMapController instanceof FlamingoController) {
        B3PGissuite.vars.btn_highLightSelected = true;
    } else if (webMapController instanceof OpenLayersController) {
        if (B3PGissuite.vars.btn_highLightSelected == true) {
            B3PGissuite.vars.btn_highLightSelected = false;
        } else {
            B3PGissuite.vars.btn_highLightSelected = true;
        }
    }

    /* TODO: Vervangen voor generiek iets. Dit is nu nodig omdat
     * de flamingo config een breinaald
     * Mogelijke fix: nieuw soort tool maken (de highlight tool). Deze voeg je in OL niet aan
     * de panel toe, maar wel aan de tools array. Deze tool roep de highlightfunctionaliteit in
     * de gisviewer aan.*/
    if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
        B3PGissuite.vars.webMapController.activateTool("breinaald");
    } else {
        B3PGissuite.vars.webMapController.activateTool("identify");
    }
}

var highLightedLayerid = 0;
function highLightThemaObject(geom) {
    highlightLayers = new Array();
    var treeComponent = B3PGissuite.get('TreeComponent');

    /* geom bewaren voor callbaack van popup */
    B3PGissuite.vars.highLightGeom = geom;
    
    var scale;
    if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
        scale = B3PGissuite.vars.webMapController.getMap().getResolution();
    } else {
        scale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
    }

    var tol = B3PGissuite.config.tolerance;

    /* indien meerdere analyse themas dan popup voor keuze */
    for (var i = 0; i < B3PGissuite.vars.enabledLayerItems.length; i++) {
        var item = B3PGissuite.vars.enabledLayerItems[i];

        var object = document.getElementById(item.id);

        /* alleen uitvoern als configuratie optie hiervan op true staat */
        if (B3PGissuite.config.useInheritCheckbox) {
            /* Item alleen toevoegen aan de layers indien
             * parent cluster(s) allemaal aangevinkt staan of
             * geen cluster heeft */
            if (treeComponent !== null && !treeComponent.itemHasAllParentsEnabled(object))
                continue;
        }
        
        if (item.highlight == 'on' && B3PGissuite.viewercommons.isItemInScale(item, scale) ) {
            highlightLayers.push(item);
        }
    }

    /* Indien meerdere actieve highlightlayers en er is nog geen highLightedLayerid
     * geselecteerd via pop-up, de pop-up tonen. Zie ook handlePopupValue(); */
    if (highlightLayers.length > 1 && highLightedLayerid < 1) {
        B3PGissuite.commons.iFramePopup('viewerhighlight.do', false, 'Kaartlaag selectie', 400, 300, true, false);
    }

    /* Indien er maar 1 analyse laag actief is dan dit id gebruiken */
    if (highlightLayers.length == 1) {
        highLightedLayerid = highlightLayers[0].id;
    }
    
    if (highLightedLayerid > 0) {        
        EditUtil.getHighlightWktForThema(highLightedLayerid, geom, scale, tol, currentHighlightWkt, returnHighlight);
    }
}

function selectRedlineObject(geom) {
    /* Params
     * geom: Klikpunt op de kaart. Een POINT wkt string.
     * B3PGissuite.vars.redLineGegevensbronId: geconfigureerde gegevensbronId voor redlining
     */
    var scale;
    if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
        scale = B3PGissuite.vars.webMapController.getMap().getResolution();
    } else {
        scale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
    }

    var tol = B3PGissuite.config.tolerance;

    EditUtil.getIdAndWktForRedliningObject(geom, B3PGissuite.vars.redLineGegevensbronId, scale, tol, returnRedlineObject);
}

function returnRedlineObject(jsonString) {
    if (jsonString == "-1") {
        B3PGissuite.commons.messagePopup("Redlining bewerken", "Geen object gevonden.", "information");

        return;
    }

    var redlineObj = eval('(' + jsonString + ')');
    var wkt = redlineObj.wkt;

    if (wkt.length > 0 && wkt != "-1")
    {
        var polyObject = new Feature(61502, wkt);
        drawObject(polyObject);
    }

    var id = redlineObj.id;
    var projectnaam = redlineObj.projectnaam;
    var ontwerp = redlineObj.ontwerp;
    var opmerking = redlineObj.opmerking;

    /* formulier op redline tabblad aanpassen */
    var iframe = document.getElementById('redliningframeViewer');
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;

    innerDoc.getElementById("redliningID").value = id;
    innerDoc.getElementById("projectnaam").value = projectnaam;
    innerDoc.getElementById("new_projectnaam").value = '';
    innerDoc.getElementById("ontwerp").value = ontwerp;

    if (opmerking != null && opmerking != "undefined") {
        innerDoc.getElementById("opmerking").value = opmerking;
    } else {
        innerDoc.getElementById("opmerking").value = "";
    }

    B3PGissuite.vars.editingRedlining = false;
}

function handlePopupValue(value) {
    highLightedLayerid = value;
    
    var object = document.getElementById(value);
    var treeComponent = B3PGissuite.get('TreeComponent');
    if (treeComponent !== null) {
        treeComponent.setActiveThema(value, object.theItem.title, true);
    }

    /*
     * TODO
     * uitzoeken of thema onzichtbaar is en dan bovenliggend cluster gebruiken.
     * setActiveCluster(item, true);
     */

    var scale;
    if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
        scale = B3PGissuite.vars.webMapController.getMap().getResolution();
    } else {
        scale = B3PGissuite.vars.webMapController.getMap().getScaleHint();
    }

    var tol = B3PGissuite.config.tolerance;
    EditUtil.getHighlightWktForThema(value, B3PGissuite.vars.highLightGeom, scale, tol, null, returnHighlight);
}

/* backend heeft wkt teruggegeven */
function returnHighlight(wkt) {
    /* Fout in back-end of wkt is een POINT */
    if (wkt.length > 0 && wkt == "-1") {
        B3PGissuite.commons.messagePopup("Selecteer object", "Geen object gevonden.", "information");
    }
    
    if (wkt.length > 0 && wkt != "-1")
    {
        var polyObject = new Feature(61502, wkt);
        drawObject(polyObject);

        /* verkregen back-end polygon voor highlight even in global var opslaan
         * deze dan gebruiken bij buffer als deze niet null is
         * De getWktActiveFeature geeft bij sommige multipolygons niet
         * een correcte wkt terug. er mist dan een , ( of ) waardoor bufferen
         * mis gaat */
        B3PGissuite.vars.multiPolygonBufferWkt = wkt;
    }
}

function onGetCapabilities(id, params) {
    B3PGissuite.commons.hideLoading();
}

function onConfigComplete(id, params) {
    if (!B3PGissuite.vars.initialized) {
        B3PGissuite.vars.initialized = true;
        B3PGissuite.viewerComponent.initializeButtons();
        B3PGissuite.viewerComponent.checkDisplayButtons();
        // TODO: gaat dit goed? Dit word nu aangeroepen met document.ready(),
        // nu niet meer met flamingoevent
        onFrameworkLoaded();
    }
}

function getBookMark() {
    /* url base */
    var url = createPermaLink();
    addToFavorites(url);
}

function getFullExtent() {
    var fullExtent = B3PGissuite.vars.webMapController.getMap().getExtent();

    return fullExtent;
}

function getCenterWkt() {
    var fullExtent = getFullExtent();

    var minx = Math.round(Number(fullExtent.minx) + 1);
    var miny = Math.round(Number(fullExtent.miny) + 1);
    var maxx = Math.round(Number(fullExtent.maxx) - 1);
    var maxy = Math.round(Number(fullExtent.maxy) - 1);

    var x = (minx + maxx) / 2;
    var y = (miny + maxy) / 2;

    return "POINT(" + x + " " + y + ");";
}

function getMinWkt() {
    var fullExtent = getFullExtent();

    var minx = Math.round(Number(fullExtent.minx) + 1);
    var miny = Math.round(Number(fullExtent.miny) + 1);

    return "POINT(" + minx + " " + miny + ");";
}

function getMaxWkt() {
    var fullExtent = getFullExtent();

    var maxx = Math.round(Number(fullExtent.maxx) - 1);
    var maxy = Math.round(Number(fullExtent.maxy) - 1);

    return "POINT(" + maxx + " " + maxy + ");";
}

/* Berekenen lattitude en longitude waardes voor gebruik in Google
 * maps aanroep */
function getLatLonForGoogleMaps() {
    var centerWkt = getCenterWkt();
    var minWkt = getMinWkt();
    var maxWkt = getMaxWkt();

    JMapData.getLatLonForRDPoint(centerWkt, minWkt, maxWkt, openGoogleMaps);
}

/* Uses classic Google Maps parameters ll and spn */
function openGoogleMaps(values) {
    var ll = "&ll=" + values[1] + "," + values[0];
    var spn = "&spn=" + values[3] + "," + values[3];

    var options = "&hl=nl&om=0";

    var url = "https://maps.google.com/maps?ie=UTF8" + ll + spn + options;

    window.open(url);
}

function getDestinationWkt(gbId, pk, val) {
    JMapData.getWkt(gbId, pk, val, getLatLonForGoogleMapDirections);
}

function getLatLonForGoogleMapDirections(destWkt) {
    JMapData.getLatLonForGoogleDirections(destWkt, openGoogleMapsDirections);
}

function openGoogleMapsDirections(values) {

    /* Check of er een gps locatie is gezet. Dit gebeurt
     * in GPSComponent.receiveLocation();
     */
    if (gps_lat !== undefined && gps_lon !== undefined) {
        values[1] = gps_lat;
        values[0] = gps_lon;
    }

    if (values[0] == "" || values[1] == "") {
        B3PGissuite.commons.messagePopup("Info", "Er is nog geen gps- of startlocatie bekend.", "information");
        
        return;
    }

    var saddr = "?saddr=" + values[1] + "," + values[0];
    var daddr = "&daddr=" + values[3] + "," + values[2];

    var url = "https://maps.google.com/maps" + saddr + daddr;

    window.open(url);
}

function createPermaLink() {
    var protocol = window.location.protocol + "//";
    var host = window.location.host;

    var urlBase = protocol + host + B3PGissuite.config.baseNameViewer + "/viewer.do?";

    /* applicatie code */
    var appCode = "";
    if (B3PGissuite.config.bookmarkAppcode != undefined && B3PGissuite.config.bookmarkAppcode != "") {
        appCode = "appCode=" + B3PGissuite.config.bookmarkAppcode;
    }

    /* kaartlagen ophalen */
    var id = "";
    var layerIds = B3PGissuite.viewercommons.getLayerIdsAsString();
    if (layerIds != undefined && layerIds != "") {
        id = "&id=" + layerIds;
    }

    /* kaartgroepen ophalen */
    var clusterIds = "";
    var treeComponent = B3PGissuite.get('TreeComponent');
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
    if (fullExtent != undefined && fullExtent != "") {
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

    if (controllerRes != undefined && controllerRes != "") {
        reso = "&resolution=" + controllerRes;
    }

    var force = "&forceViewer=true";
    var pageId = "&cmsPageId=" + B3PGissuite.config.cmsPageId;
    
    var url = urlBase + appCode + id + clusterIds + extent + force + pageId;

    return url;
}

function addToFavorites(url) {
    var title = "B3P Gisviewer bookmark";

    if (Boolean(window.chrome)) { // chrome
        chromeBookMarkPopup(url, title);
    } else if (window.sidebar) { // Firefox
        chromeBookMarkPopup(url, title);
        /*window.sidebar.addPanel(title, url, "");
         window.external.AddFavorite(url, title); */
    } else if (window.external) { // IE 6,7 not 8?
        /* Moet gekoppeld zijn aan userevent of iets met runat server ? */
        window.external.AddFavorite(url, title);
    } else if (window.opera && window.print) { // Opera 
        return true;
    }

    return null;
}

function chromeBookMarkPopup(url, title) {
    var chromePopup = window.open(url, title, "height=300, width=850,toolbar=no,scrollbars=no,menubar=no");

    var html = "<p>Voeg deze link toe aan uw favorieten:</p>" + url;

    chromePopup.document.write(html);
}

function popUp(URL, naam, width, height, useDiv) {

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

    if (B3PGissuite.vars.currentpopupleft != null) {
        popupleft = B3PGissuite.vars.currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2 : 100;

    if (B3PGissuite.vars.currentpopuptop != null) {
        B3PGissuite.vars.currentpopuptop = popuptop;
    }

    if (useDivPopup) {
        if (!B3PGissuite.vars.popupCreated)
            initPopup();

        document.getElementById("dataframedivpopup").src = URL;
        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';

        $j("#popupWindow").width(width);
        $j("#popupWindow").height(height);

        $j("#popupWindow").show();

        if (B3PGissuite.commons.getIEVersion() <= 6 && B3PGissuite.commons.getIEVersion() != -1) {
            fixPopup();
        }

    } else {

        properties = "toolbar = 0, " +
                "scrollbars = 1, " +
                "location = 0, " +
                "statusbar = 1, " +
                "menubar = 0, " +
                "resizable = 0, " +
                "width = " + screenwidth + ", " +
                "height = " + screenheight + ", " +
                "top = " + popuptop + ", " +
                "left = " + popupleft;

        return window.open(URL, naam, properties);
    }

    return null;
}

function popUpData(naam, width, height, useDiv) {
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

    if (B3PGissuite.vars.currentpopupleft != null) {
        popupleft = B3PGissuite.vars.currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2 : 100;

    if (B3PGissuite.vars.currentpopuptop != null) {
        B3PGissuite.vars.currentpopuptop = popuptop;
    }

    if (useDivPopup) {
        if (!B3PGissuite.vars.popupCreated)
            initPopup();

        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';
        $j("#popupWindow").show();

        if (B3PGissuite.commons.getIEVersion() <= 6 && B3PGissuite.commons.getIEVersion() != -1)
            fixPopup();

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
}

function buildPopup() {
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
    popupHandle.appendChild(popupTitle);
    popupHandle.appendChild(popupClose);
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
}

/**
 * @param mapDiv The div element where the map is in.
 * @param webMapController the webMapController that controlles the map
 * @param balloonId the id of the DOM element that represents the balloon.
 * @param balloonWidth the width of the balloon (optional, default: 300);
 * @param balloonHeight the height of the balloon (optional, default: 300);
 * @param offsetX the offset x
 * @param offsetY the offset y
 * @param balloonCornerSize the size of the rounded balloon corners of the round.png image(optional, default: 20);
 * @param balloonArrowHeight the hight of the arrowImage (optional, default: 40);
 */
function Balloon(mapDiv, webMapController, balloonId, balloonWidth, balloonHeight, offsetX, offsetY, balloonCornerSize, balloonArrowHeight) {
    this.mapDiv = mapDiv;
    this.webMapController = webMapController;
    this.balloonId = balloonId;
    this.balloonWidth = 300;
    this.balloonHeight = 300;
    this.balloonCornerSize = 20;
    this.balloonArrowHeight = 40;
    this.offsetX = 0;
    this.offsetY = 0;
    //this.leftOfPoint;
    //this.topOfPoint;

    //the balloon jquery dom element.
    //this.balloon;
    //this.xCoord;
    //this.yCoord;

    if (balloonWidth) {
        this.balloonWidth = balloonWidth;
    }
    if (balloonHeight)
        this.balloonHeight = balloonHeight;
    if (balloonCornerSize) {
        this.balloonCornerSize = balloonCornerSize;
    }
    if (balloonArrowHeight) {
        this.balloonArrowHeight = balloonArrowHeight;
    }
    if (offsetX) {
        this.offsetX = offsetX;
    }
    if (offsetY) {
        this.offsetY = offsetY;
    }
    /**
     *Private function. Don't use.
     *@param x
     *@param y
     */
    this._createBalloon = function(x, y) {
        //create balloon and styling.
        this.balloon = $j("<div class='infoBalloon' id='" + this.balloonId + "'></div>");
        this.balloon.css('position', 'absolute');
        this.balloon.css('width', "" + this.balloonWidth + "px");
        this.balloon.css('height', "" + this.balloonHeight + "px");
        this.balloon.css('z-index', '13000');

        var maxCornerSize = this.balloonHeight - (this.balloonArrowHeight * 2) + 2 - this.balloonCornerSize;
        this.balloon.append($j("<div class='balloonCornerTopLeft'><img style='position: absolute;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.balloonCornerSize + 'px')
                .css('height', this.balloonCornerSize + 'px')
                .css('left', '0px')
                .css('top', this.balloonArrowHeight - 1 + 'px')
                .css('width', this.balloonWidth - this.balloonCornerSize + 'px')
                .css('height', maxCornerSize + 'px')
                );
        this.balloon.append($j("<div class='balloonCornerTopRight'><img style='position: absolute; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.balloonCornerSize + 'px')
                .css('height', maxCornerSize + 'px')
                .css('top', this.balloonArrowHeight - 1 + 'px')
                .css('right', '0px')
                );
        this.balloon.append($j("<div class='balloonCornerBottomLeft'><img style='position: absolute; top: -748px;' src='images/infoBalloon/round.png'/></div>")
                .css('height', this.balloonCornerSize + 'px')
                .css('left', '0px')
                .css('bottom', this.balloonArrowHeight - 1 + 'px')
                .css('width', this.balloonWidth - this.balloonCornerSize)
                );
        this.balloon.append($j("<div class='balloonCornerBottomRight'><img style='position: absolute; top: -748px; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.balloonCornerSize + 'px')
                .css('height', this.balloonCornerSize + 'px')
                .css('right', '0px')
                .css('bottom', this.balloonArrowHeight - 1 + 'px')

                );
        //arrows
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        //content
        this.balloon.append($j("<div class='balloonContent'></div>")
                .css('top', this.balloonArrowHeight + 20 + 'px')
                .css('bottom', this.balloonArrowHeight + 4 + 'px')
                );
        //closing button
        var thisObj = this;
        this.balloon.append($j("<div class='balloonCloseButton'></div>")
                .css('right', '7px')
                .css('top', '' + (this.balloonArrowHeight + 3) + 'px')
                .click(function() {
            thisObj.remove();
            return false;
        })

                );
        this.xCoord = x;
        this.yCoord = y;

        //calculate position
        this._resetPositionOfBalloon(x, y);

        //append the balloon.
        $j(this.mapDiv).append(this.balloon);

        this.webMapController.registerEvent(Event.ON_FINISHED_CHANGE_EXTENT, this.webMapController.getMap(), this.setPosition, this);
    };

    /**
     *Private function. Use setPosition(x,y,true) to reset the position
     *Reset the position to the point. And displays the right Arrow to the point
     *Sets the this.leftOfPoint and this.topOfPoint
     *@param x the x coord
     *@param y the y coord
     */
    this._resetPositionOfBalloon = function(x, y) {
        //calculate position
        var centerCoord = this.webMapController.getMap().getCenter();
        var centerPixel = this.webMapController.getMap().coordinateToPixel(centerCoord.x, centerCoord.y);
        var infoPixel = this.webMapController.getMap().coordinateToPixel(x, y);

        //determine the left and top.
        if (infoPixel.x > centerPixel.x) {
            this.leftOfPoint = true;
        } else {
            this.leftOfPoint = false;
        }
        if (infoPixel.y > centerPixel.y) {
            this.topOfPoint = true;
        } else {
            this.topOfPoint = false;
        }
        //display the right arrow
        this.balloon.find(".balloonArrow").css('display', 'none');
        //$j("#infoBalloon > .balloonArrow").css('display', 'block');
        if (!this.leftOfPoint && !this.topOfPoint) {
            //popup is bottom right of the point
            this.balloon.find(".balloonArrowTopLeft").css("display", "block");
        } else if (this.leftOfPoint && !this.topOfPoint) {
            //popup is bottom left of the point
            this.balloon.find(".balloonArrowTopRight").css("display", "block");
        } else if (this.leftOfPoint && this.topOfPoint) {
            //popup is top left of the point
            this.balloon.find(".balloonArrowBottomRight").css("display", "block");
        } else {
            //pop up is top right of the point
            this.balloon.find(".balloonArrowBottomLeft").css("display", "block");
        }
    };

    /**
     *Set the position of this balloon. Create it if not exists
     *@param x xcoord
     *@param y ycoord
     *@param resetPositionOfBalloon boolean if true the balloon arrow will be
     *redrawn (this.resetPositionOfBalloon is called)
     */
    this.setPosition = function(x, y, resetPositionOfBalloon) {
        if (this.balloon == undefined) {
            this._createBalloon(x, y);
        } else if (resetPositionOfBalloon) {
            this._resetPositionOfBalloon(x, y);
        }
        if (x != undefined && y != undefined) {
            this.xCoord = x;
            this.yCoord = y;
        } else if (this.xCoord == undefined || this.yCoord == undefined) {
            throw "No coords found for this balloon";
        } else {
            x = this.xCoord;
            y = this.yCoord;
        }
        //if the point is out of the extent hide balloon
        var curExt = this.webMapController.getMap().getExtent();
        if (curExt.minx > x ||
                curExt.maxx < x ||
                curExt.miny > y ||
                curExt.maxy < y) {
            /*TODO wat doen als hij er buiten valt.*/
            this.balloon.css('display', 'none');
            return;
        } else {
            /*TODO wat doen als hij er weer binnen valt*/
            this.balloon.css('display', 'block');
        }

        //calculate position
        var infoPixel = this.webMapController.getMap().coordinateToPixel(x, y);

        //determine the left and top.
        var left = infoPixel.x + this.offsetX;
        var top = infoPixel.y + this.offsetY;
        if (this.leftOfPoint) {
            left = left - this.balloonWidth;
        }
        if (this.topOfPoint) {
            top = top - this.balloonHeight;
        }
        //set position of balloon
        this.balloon.css('left', "" + left + "px");
        this.balloon.css('top', "" + top + "px");
    };

    /*Remove the balloon*/
    this.remove = function() {
        this.balloon.remove();
        this.webMapController.unRegisterEvent(Event.ON_FINISHED_CHANGE_EXTENT, this.webMapController.getMap(), this.setPosition, this);
        delete this.balloon;
    };

    /*Get the DOM element where the content can be placed.*/
    this.getContentElement = function() {
        return this.balloon.find('.balloonContent');
    };

    this.hide = function() {
        this.balloon.css("display", 'none');
    };

    this.show = function() {
        this.balloon.css("display", 'block');
    };
}

// Aanroepen voor een loading screen in de tabs.
function showTabvakLoading(message) {
    $j("#tab_container").append('<div class="tabvakloading"><div>' + message + '<br /><br /><img src="/gisviewer/images/icons/loadingsmall.gif" alt="Bezig met laden..." /></div></div>');
    $j("#tab_container").find(".tabvakloading").fadeTo(0, 0.8);
}

function hideTabvakLoading() {
    $j("#tab_container").find(".tabvakloading").remove();
}

function enableEditRedlining(id) {
    B3PGissuite.vars.editingRedlining = true;
    B3PGissuite.vars.redLineGegevensbronId = id;

    if (B3PGissuite.vars.webMapController instanceof FlamingoController) {
        B3PGissuite.vars.webMapController.activateTool("breinaald");
    } else {
        B3PGissuite.vars.webMapController.activateTool("identify");
    }
}

function createServiceLeaf(container, item) {
    /* root item. alleen groepname tonen en geen vinkjes */
    if (item.id == 0) {
        container.appendChild(createServiceLayerLink(item));
        return;
    }

    var checkBox;
    if (item.default_on) {
        checkBox = createCheckboxUserLayer(item, true);
        container.appendChild(checkBox);
    } else {
        container.appendChild(createCheckboxUserLayer(item, false));
    }

    container.appendChild(document.createTextNode(' '));
    container.appendChild(createServiceLayerLink(item));

    if (item.default_on) {
        checkboxUserLayerClick(checkBox);
    }
}

function createCheckboxUserLayer(item, checked) {
    var checkbox;

    if (B3PGissuite.commons.getIEVersion() <= 8 && B3PGissuite.commons.getIEVersion() != -1) {
        var checkboxControleString = '<input name="userLayers" type="checkbox" id="ul_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="checkboxUserLayerClick(this)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'ul_' + item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'userLayers';
        checkbox.value = item.id;

        checkbox.onclick = function() {
            checkboxUserLayerClick(this);
        };

        if (checked) {
            checkbox.checked = true;
        }
    }

    /* json item toevoegen aan element zodat later makkelijk
     * gebruikt kan worden */
    checkbox.theItem = item;

    return checkbox;
}

function checkboxUserLayerClick(checkbox) {
    var item = checkbox.theItem;
    var checked = checkbox.checked;

    /* laagnaam aan wmslayers toevoegen */
    var wmslayers = new Array();
    wmslayers[0] = item.name;
    item.wmslayers = wmslayers;

    /* laagnaam aan wmsquerylayers toevoegen */
    if (item.queryable) {
        var wmsquerylayers = new Array();
        wmsquerylayers[0] = item.name;

        item.wmsquerylayers = wmsquerylayers;
    }

    /* item als laag klaarzetten */
    var layers = new Array();
    layers[0] = item;

    /* laag toevoegen aan viewer */
    var treeComponent = B3PGissuite.get('TreeComponent');
    if (treeComponent !== null) {
        if (checked) {
            treeComponent.addItemAsLayer(item);
            treeComponent.refreshLayerWithDelay();
        } else {
            treeComponent.removeItemAsLayer(item);
            treeComponent.doRefreshLayer();
        }
    }
}

function createServiceLayerLink(item) {
    var lnk = document.createElement('a');
    lnk.innerHTML = item.title ? item.title : item.id;
    lnk.href = '#';

    if (item.service_url != undefined) {
        lnk.onclick = function() {
            $j("#dialog-download-metadata").dialog("option", "buttons", {
                "Url": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        $j(this).dialog("close");

                        var url = item.service_url + "service=WMS&request=GetCapabilities&version=1.0.0";
                        $j("#input_wmsserviceurl").val(url);

                        B3PGissuite.commons.unblockViewerUI();
                        $j("#dialog-wmsservice-url").dialog('open');
                    }
                },
                "Annuleren": function() {
                    if ($j("#dialog-download-metadata").dialog("isOpen")) {
                        $j(this).dialog("close");
                        B3PGissuite.commons.unblockViewerUI();
                    }
                }
            });

            $j('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                $j(this).html($j(this).parent().attr('text'));
            });

            B3PGissuite.commons.blockViewerUI();
            $j("#dialog-download-metadata").dialog('open');
        };
    }

    return lnk;
}

/**
 * get the item that has the configuration of this wmslayer string
 * @param item the item to begin the search
 * @param layers the layers string of a layer object
 * @return the item
 */
function getItemByLayer(item, layers) {
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
                var foundItem = getItemByLayer(child, layers);
                if (foundItem != null) {
                    return foundItem;
                }
            }
        }
    }

    return null;
}

function doIdentifyAfterSearch(x, y) {
    if (!B3PGissuite.config.usePopup && !B3PGissuite.config.usePanel && !B3PGissuite.config.useBalloonPopup) {
        return;
    }

    var geom = "";

    geom += "POINT(";
    geom += x + " " + y;
    geom += ")";

    B3PGissuite.vars.webMapController.getMap().getLayer("editMap").removeAllFeatures();
    B3PGissuite.vars.btn_highLightSelected = false;
    B3PGissuite.vars.webMapController.activateTool("identify");

    B3PGissuite.viewerComponent.showIdentifyIcon();
    B3PGissuite.viewercommons.handleGetAdminData(geom, null, true);
    B3PGissuite.viewercommons.loadObjectInfo(geom);
}

$j(document).ready(function() {
    /* Alleen tabs vullen als ze ook echt aanstaan */
    var vergunningTabOn = false;
    var zoekenTabOn = false;

    for (var i = 0; i < B3PGissuite.config.enabledtabs.length; i++) {
        if (B3PGissuite.config.enabledtabs[i] === "vergunningen")
            vergunningTabOn = true;
        if (B3PGissuite.config.enabledtabs[i] === "zoeken")
            zoekenTabOn = true;
    }
    for (var i = 0; i < B3PGissuite.config.enabledtabsLeft.length; i++) {
        if (B3PGissuite.config.enabledtabsLeft[i] === "vergunningen")
            vergunningTabOn = true;
        if (B3PGissuite.config.enabledtabsLeft[i] === "zoeken")
            zoekenTabOn = true;
    }

    if (zoekenTabOn || vergunningTabOn) {
        /* Indien 1 zoeker dan deze gelijk tonen */
        var arr = B3PGissuite.config.zoekConfigIds.split(",");
        var c = $j("#searchInputFieldsContainer");

        if (arr !== null && arr.length > 1) {
            createSearchConfigurations();
        } else if (arr !== null && arr.length === 1 && arr[0] !== '') {
            //var zc = B3PGissuite.config.zoekconfiguraties[0];
            var zc = setZoekconfiguratieWithId(Number(arr[0]));
            JZoekconfiguratieThemaUtil.getThemas(zc.id, zoekconfiguratieThemasCallBack);
            var zoekVelden = zc.zoekVelden;
            fillSearchDiv(c, zoekVelden, null);
        }
    }

    var pwCreated = false;
    if (document.getElementById('popupWindow')) {
        pwCreated = true;
    }

    try {
        if (B3PGissuite.commons.getParent({ parentOnly: true }).document.getElementById('popupWindow')) {
            pwCreated = true;
        }
    } catch (err) {
    }

    if (!pwCreated) {
        buildPopup();

        $j('#popupWindow').draggable({
            handle: '#popupWindow_Handle',
            iframeFix: true,
            zIndex: 200,
            containment: 'document',
            start: function(event, ui) {
                B3PGissuite.commons.startDrag();
            },
            stop: function(event, ui) {
                B3PGissuite.commons.stopDrag();
            }
        }).resizable({
            handles: 'se',
            start: function(event, ui) {
                B3PGissuite.commons.startResize();
            },
            stop: function(event, ui) {
                B3PGissuite.commons.stopResize();
            }
        });

        $j('#popupWindow_Close').click(function() {
            if (B3PGissuite.vars.dataframepopupHandle)
                B3PGissuite.vars.dataframepopupHandle.closed = true;

            $j("#popupWindow").hide();
        });
    }

    B3PGissuite.vars.popupCreated = true;

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

});