B3PGissuite.defineComponent('Search', {

    singleton: true,

    constructor: function Search() {
        this.init();
    },

    init: function() {
        
    },

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
            zoekconfiguratieThemasCallBack(data);
            switchLayersOn();
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
    }

});