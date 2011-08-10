/*
 *
 *var configMaxBouwjaar=2011;
    var configMinBouwjaar=1570;
    var configMaxOpp=15200;
    var configMinOpp=1;
 */
$j(document).ready(function (){
    //oppervlakte slider
    $j("#oppervlakteSlider" ).slider({
            range: true,
            min: configMinOpp,
            max: configMaxOpp,
            values: [ configMinOpp, configMaxOpp ],
            slide: function( event, ui ) {
                var text="";
                if (ui.values[0]==configMinOpp && ui.values[1]==configMaxOpp){
                    text="Alles";
                }else{
                    text="van " + ui.values[ 0 ] + " m<sup>2</sup> tot " + ui.values[ 1 ] +" m<sup>2</sup>";
                }
                $j("#oppervlakteHoeveelheid" ).html(text);
            }
    });
    //bouwjaar slider
    $j("#bouwjaarSlider" ).slider({
            range: true,
            min: configMinBouwjaar,
            max: configMaxBouwjaar,
            values: [ configMinBouwjaar, configMaxBouwjaar ],
            slide: function( event, ui ) {
                var text="";
                if (ui.values[0]==configMinBouwjaar && ui.values[1]==configMaxBouwjaar){
                    text="Alles";
                }else{
                    text="van " + ui.values[ 0 ] + " tot " + ui.values[ 1 ];
                }
                $j("#bouwjaarHoeveelheid" ).html(text);
            }
    });
});

function getParent() {
    if (window.opener){
        return window.opener;
    }else if (window.parent){
        return window.parent;
    }else{
        messagePopup("", "No parent found", "error");

        return null;
    }
}

function getBagObjects(){
    var extraCriteria="";
    var minOpp= $j("#oppervlakteSlider").slider("values",0);
    var maxOpp= $j("#oppervlakteSlider").slider("values",1);
    if (minOpp > configMinOpp || maxOpp < configMaxOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+="minopp <= "+maxOpp;     
        extraCriteria+=" && ";
        extraCriteria+="maxopp >= "+minOpp; 
    }
    /*if (minOpp > configMinOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=oppAttributeName+" <= "+minOpp;
    }
    if (maxOpp < configMaxOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=oppAttributeName+" <= "+maxOpp;
    }*/
    
    var minBouwjaar= $j("#bouwjaarSlider").slider("values",0);
    var maxBouwjaar= $j("#bouwjaarSlider").slider("values",1);
    if (minBouwjaar > configMinOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=bouwjaarAttributeName+" >= "+minBouwjaar;
    }
    if (maxBouwjaar < configMaxOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=bouwjaarAttributeName+" <= "+maxBouwjaar;
    }    
    parent.handleGetAdminData(null, null, false, bagThemaId, extraCriteria);
}