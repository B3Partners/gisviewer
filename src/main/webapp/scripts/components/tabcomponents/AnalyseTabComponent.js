B3PGissuite.defineComponent('AnalyseTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {},
    resultcontainer: null,
    constructor: function AnalyseTabComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        var container = $j('<div></div>').css('margin', '5px');
        var inner = $j('<div></div>').addClass('analysecontainer');
        var buttoncontainer = $j('<div></div>');
        var button = $j('<input />')
                        .attr({
                            'type': 'button',
                            'name': 'analysedata'
                        })
                        .val('Analyse')
                        .addClass('zoek_knop')
                        .click(this.doAjaxRequest.bind(this));
        this.resultcontainer = $j('<div></div>').addClass('analyseresult').css('height', '10px');
        this.resultcontainer.html('<p>Klik op knop voor analyse</p>');
        buttoncontainer.append(button);
        inner.append('<p>Kies de redlining-tool en teken een vlak op de kaart. De objecten van de actieve kaartlagen worden geanalyseerd nadat u op de analyse knop hebt geklikt.</p>');
        inner.append(buttoncontainer);
        inner.append();
        container.append(inner);
        this.component = container;
    },
    doAjaxRequest: function() {
        var wkt = B3PGissuite.viewercommons.getWktActiveFeature(-1);
        var themaIdArray =  B3PGissuite.vars.enabledLayerItems;
        var themaIds = "";
        for (var i=0; i < themaIdArray.length; i++){
            if (themaIdArray[i].analyse === "on") {
                if (themaIds.length > 0) {
                    themaIds += ",";
                }
                themaIds += themaIdArray[i].id;
            }
        }
        if (wkt && themaIds.length>0){
            this.resultcontainer.html("<p>Informatie ophalen, een ogenblik aub ...</p>");
            JMapData.getAnalyseData(wkt, themaIds, null, this.handleAnalyseMap.bind(this));
        }else{
            this.resultcontainer.html(
                "<p>Er kan geen informatie opgehaald worden, omdat er \n"+
                "ofwel geen vlak getekend is in de kaart \n" +
                "ofwel er geen analyseerde kaartlagen aanstaan.</p>"
            );
        }
    },
    handleAnalyseMap: function(map) {
        if (!map) {
            this.resultcontainer.html("Geen resultaten gevonden");
            return;
        }
        var result = "";
        for (var layer in map ) {
            var lresult = map [layer];
            result += "<br>";
             for (var item in lresult) {
                var litem = lresult [item];
                 result += litem + "<br>";
            }
        }
        this.resultcontainer.html(result);
    }
});