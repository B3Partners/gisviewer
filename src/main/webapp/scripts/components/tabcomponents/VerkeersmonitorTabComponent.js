B3PGissuite.defineComponent('VerkeersmonitorComponent', {
    extend: 'BaseComponent',
    tabs:[],
    constructor: function VerkeersmonitorComponent(options){
        options.kolom = "gm_code";
        this.callParent(options);
        this.init();
    },
    init: function(){
        this.tabs = B3PGissuite.getAllByClassName("VerkeersmonitorTabComponent");
    },
    onIdentify: function(geom){
        var me = this;

        var themaid = -1;//B3PGissuite.viewercommons.getLayerIdsAsString(true); // vervangen door wegvakenlaagids
        // optellen aantal gegevensbronnen
        this.loop++;
        var gegevensbronId = 2;
        var cql = "{}";
        var htmlId= "1";
        var bookmarkAppcode = B3PGissuite.config.bookmarkAppcode;
        // haal gegevens op van gegevensbron
        JCollectAdmindata.fillGegevensBronBean(gegevensbronId, themaid, geom, cql, false, htmlId, bookmarkAppcode, function(response){
            me.handleData(response);
        });
    },
    handleData : function(response){
        if(response.records){
            var record = response.records[0];
            var index = this.getIndex(response);
            var id = record.values[index].value;
            this.changeUrls(id);
        }
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