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
                    text="van " + ui.values[ 0 ] + " m<sup>2</sup> tot en met " + ui.values[ 1 ] +" m<sup>2</sup>";
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
                    text="van " + ui.values[ 0 ] + " tot en met " + ui.values[ 1 ];
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
    var extraCriteria=new Object();
    extraCriteria[pandenGegevensBronId]="";
    extraCriteria[verblijfsObjectenGegevensBronId]="";
    //bbox
    var extent = parent.webMapController.getMap().getExtent();
    extraCriteria[pandenGegevensBronId]+= "BBOX("+geomAttributeName+", "+extent.minx+","+extent.miny+","+extent.maxx+","+extent.maxy+")";
    
    /*if (minOpp > configMinOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=oppAttributeName+" <= "+minOpp;
    }
    if (maxOpp < configMaxOpp){
        if(extraCriteria.length > 0) extraCriteria+=" && ";
        extraCriteria+=oppAttributeName+" <= "+maxOpp;
    }*/
    //bouwjaar
    var minBouwjaar= $j("#bouwjaarSlider").slider("values",0);
    var maxBouwjaar= $j("#bouwjaarSlider").slider("values",1);
    if (minBouwjaar > configMinOpp){
        if(extraCriteria[pandenGegevensBronId].length > 0) extraCriteria[pandenGegevensBronId]+=" && ";
        extraCriteria[pandenGegevensBronId]+=bouwjaarAttributeName+" >= "+minBouwjaar;
    }
    if (maxBouwjaar < configMaxOpp){
        if(extraCriteria[pandenGegevensBronId].length > 0) extraCriteria[pandenGegevensBronId]+=" && ";
        extraCriteria[pandenGegevensBronId]+=bouwjaarAttributeName+" <= "+maxBouwjaar;
    }
    //opp
    var minOpp= $j("#oppervlakteSlider").slider("values",0);
    var maxOpp= $j("#oppervlakteSlider").slider("values",1);
    if (minOpp > configMinOpp){            
        if(extraCriteria[verblijfsObjectenGegevensBronId].length > 0) extraCriteria[verblijfsObjectenGegevensBronId]+=" && ";
        extraCriteria[verblijfsObjectenGegevensBronId]+=oppAttributeName+" >= "+minOpp; 
    }
    if (maxOpp < configMaxOpp){
        if(extraCriteria[verblijfsObjectenGegevensBronId].length > 0) extraCriteria[verblijfsObjectenGegevensBronId]+=" && ";
        extraCriteria[verblijfsObjectenGegevensBronId]+=oppAttributeName+" <= "+maxOpp;     
    }    
    //gebruiksfuncties
    var gebruiksFunctiesCriteria="";
    $j.each($j("input:checked[name='gebruiksfunctie']"),function(index,elem){
        if(gebruiksFunctiesCriteria.length > 0) gebruiksFunctiesCriteria+=" OR ";
        gebruiksFunctiesCriteria+= gebruiksfunctieAttributeName+" = '"+$j(elem).val()+"'";
    });
    if(extraCriteria[verblijfsObjectenGegevensBronId].length > 0) extraCriteria[verblijfsObjectenGegevensBronId]+=" && ";        
    if (gebruiksFunctiesCriteria==""){
        extraCriteria[verblijfsObjectenGegevensBronId]+=gebruiksfunctieAttributeName+" = null";
    }else{
        extraCriteria[verblijfsObjectenGegevensBronId]+="(";
        extraCriteria[verblijfsObjectenGegevensBronId]+=gebruiksFunctiesCriteria;
        extraCriteria[verblijfsObjectenGegevensBronId]+=")";
    }
    parent.handleGetAdminData(null, null, false, bagThemaId, JSON.stringify(extraCriteria));
}