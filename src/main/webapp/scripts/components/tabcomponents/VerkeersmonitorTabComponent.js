B3PGissuite.defineComponent('VerkeersmonitorComponent', {
    extend: 'BaseComponent',
    tabs:[],
    layer:null,
    constructor: function VerkeersmonitorComponent(options){
        options.kolom = B3PGissuite.config.externeWegvakidAttr;
        this.callParent(options);

        this.addListener('ViewerComponent', 'frameWorkInitialized', this.init);

    },
    init: function () {
        this.tabs = B3PGissuite.getAllByClassName("VerkeersmonitorTabComponent");
        var layers = B3PGissuite.vars.enabledLayerItems;
        var wmsLayers = B3PGissuite.vars.webMapController.getMap().getAllWMSLayers();
        for (var i = 0; i < layers.length; i++) {
            var layer = layers[i];
            if (layer.id === parseInt(B3PGissuite.config.externelaagid)) {
                for (var j = 0; j < wmsLayers.length; j++) {
                    var wmsLayer = wmsLayers[j];
                    if (wmsLayer.getOption('layers') === layer.wmslayers) {
                        this.layer = wmsLayer;
                        break;
                    }
                }
                break;
            }
        }
    },
    onIdentify: function(geom){
        var me = this;

        var themaid = B3PGissuite.config.externelaagid;//B3PGissuite.viewercommons.getLayerIdsAsString(true); // vervangen door wegvakenlaagids
        // optellen aantal gegevensbronnen
        this.loop++;
        var bookmarkAppcode = B3PGissuite.config.bookmarkAppcode;
        // haal gegevens op van gegevensbron
        JCollectAdmindata.fillGegevensBronBean(-1, themaid, geom, "{}", false, -1, bookmarkAppcode, function(response){
            me.handleData(response);
        });
    },
    handleData : function(response){
        if(response.records){
            var record = response.records[0];
            var index = this.getIndex(response);
            var id = record.values[index].value;
            this.changeUrls(id);
            this.highlightRoad(id);
        }
    },
    highlightRoad: function(id){
        //http://localhost:8084/gisviewer/services/CreateSLD?visibleValue=513&themaId=2&appcode=86967bd47399b0664c4a83d3e30eab25

        //http://localhost/CreateSLD.xml
        /*
         * Haal laag op
         * Maak filter
         * voeg sld toe
         */
    },
    changeUrls: function(id){
        for(var i = 0 ; i < this.tabs.length; i++){
            var tab = this.tabs[i];
            tab.changeUrl(id);
        }
    },
    getIndex : function (response){
        for(var i = 0 ; i < response.labels.length; i++){
            var label =  response.labels[i];
            if(label.label === this.options.kolom || label.kolomNaam === this.options.kolom){
                return i;
            }
        }
        return -1;
    }
});

B3PGissuite.defineComponent('VerkeersmonitorTabComponent', {
    extend: 'BaseComponent',
    count:0,
    src:null,
    id:null,
    defaultOptions: {
        taboptions: {
            tabvakClassname: 'tabvak_with_iframe'
        }
    },
    constructor: function VerkeersmonitorTabComponent(options) {
        this.callParent(options);
        this.src = options.src;
        this.id = options.id;
        this.init();

    },
    init: function() {
        var src = this.src;
        this.component = jQuery('<iframe></iframe>').attr({
            'src': src,
            'id': this.id,
            'name': this.id,
            'frameborder': 1
        });
        if(jQuery('html').hasClass('lt-ie9')) {
            this.component[0].allowTransparency = 'allowtransparency';
        }
    },
    changeUrl: function(id){
        $(this.id).src = this.src + id;
    }
});