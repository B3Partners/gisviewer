
var originalLayerUrl = layerUrl;

function reloadRedliningLayer(themaId, projectnaam, removeFeatures) {
    var groepParam = "GROEPNAAM";
    var projectParam = "PROJECTNAAM";

    if (!isStringEmpty(organizationcode)) {
        layerUrl = originalLayerUrl + groepParam + "=" + organizationcode;
    }

    if (!isStringEmpty(projectnaam)) {
        layerUrl = originalLayerUrl + projectParam + "=" + projectnaam;
    }

    if (!isStringEmpty(organizationcode) && !isStringEmpty(projectnaam)) {
        layerUrl = originalLayerUrl + groepParam + "=" + organizationcode + "&"
        + projectParam + "=" + projectnaam;
    }

    /* tekenobject van kaart afhalen */
    if (removeFeatures) {
        removeAllFeatures();
    }

    /* TODO: Beetje lelijk gewoon vinkje aan uitzetten om redlining laag te refreshen
     * wellicht een keer methode schrijven voor de webmapcontroller die
     * iets dergelijks kan doen */
    deActivateCheckbox(themaId);
    activateCheckbox(themaId);
}

/* Digitree */
function reloadEditBoom(removeFeatures){
    /* tekenobject van kaart afhalen */
    if (removeFeatures) {
        removeAllFeatures();
    }

    for (var i=0; i<enabledLayerItems.length; i++){
        var item = enabledLayerItems[i];
        var themaid = item.id;

        deActivateCheckbox(themaid);
        activateCheckbox(themaid);
    }
}

/* Methodes edit tab */
function selectBoomObject(geom) {
    /* Params
     * geom: Klikpunt op de kaart. Een POINT wkt string.
     * redLineGegevensbronId: geconfigureerde gegevensbronId voor redlining
    */
    var scale = webMapController.getMap().getScale();
    var tol = tolerance;
    //alert("bron = "+boomGegevensbronId);

    EditBoomUtil.getIdAndWktForBoomObject(geom, boomGegevensbronId, scale, tol, returnBoomObject);
}

function returnBoomObject(jsonString) {
    if (jsonString == "-1") {
        messagePopup("Boom bewerken", "Geen object gevonden.", "error");

        return;
    }

    var boomObj = eval('(' + jsonString + ')');
    var wkt = boomObj.wkt;

    if (wkt.length > 0 && wkt != "-1")
    {
        var polyObject = new Feature(61502,wkt);
        drawObject(polyObject);
    }

    var id = boomObj.id;
    var project = boomObj.project;
    var projectid = boomObj.projectid;
    var boomid = boomObj.boomid;
    var status = boomObj.status;
    var mutatiedatum = boomObj.mutatiedatum;
    var mutatietijd = boomObj.mutatietijd;
    var aktie = boomObj.aktie;
    var boomsoort = boomObj.boomsoort;
    var plantjaar = boomObj.plantjaar;
    var boomhoogte = boomObj.boomhoogte;
    var eindbeeld = boomObj.eindbeeld;
    var scheefstand = boomObj.scheefstand;
    var scheuren = boomObj.scheuren;
    var holten = boomObj.holten;
    var stamvoetschade = boomObj.stamvoetschade;
    var stamschade = boomObj.stamschade;
    var kroonschade = boomObj.kroonschade;
    var inrot = boomObj.inrot;
    var houtboorder = boomObj.houtboorder;
    var zwam = boomObj.zwam;
    var zwam_stamvoet = boomObj.zwam_stamvoet;
    var zwam_stam = boomObj.zwam_stam;
    var zwam_kroon = boomObj.zwam_kroon;
    var dood_hout = boomObj.dood_hout;
    var plakoksel = boomObj.plakoksel;
    var stamschot = boomObj.stamschot;
    var wortelopslag = boomObj.wortelopslag;
    var takken = boomObj.takken;
    var opdruk = boomObj.opdruk;
    var vta1 = boomObj.vta1;
    var vta2 = boomObj.vta2;
    var vta3 = boomObj.vta3;
    var vta4 = boomObj.vta4;
    var vta5 = boomObj.vta5;
    var vta6 = boomObj.vta6;
    var aantastingen = boomObj.aantastingen;
    var maatregelen_kort = boomObj.maatregelen_kort;
    var maatregelen_lang = boomObj.maatregelen_lang;
    var wegtype = boomObj.wegtype;
    var bereikbaarheid = boomObj.bereikbaarheid;
    var nader_onderzoek = boomObj.nader_onderzoek;
    var status_zp = boomObj.status_zp;
    var classificatie = boomObj.classificatie;
    var risicoklasse = boomObj.risicoklasse;
    var uitvoerdatum = boomObj.uitvoerdatum;
    var opmerkingen = boomObj.opmerkingen;
    var extra1 = boomObj.extra1;
    var extra2 = boomObj.extra2;
    var extra3 = boomObj.extra3;
    var extra4 = boomObj.extra4;
    var extra5 = boomObj.extra5;
    var extra6 = boomObj.extra6;
    var extra7 = boomObj.extra7;
    var extra8 = boomObj.extra8;
    var extra9 = boomObj.extra9;
    var extra10 = boomObj.extra10;

    /* formulier op edit tabblad aanpassen */
    var iframe;
    var tab = "";
    for (var i=0; i < enabledtabs.length; i++) {
        if (enabledtabs[i] == "edit"){
            iframe = document.getElementById('editboomframeViewer');
            tab = "edit";
        }
        if (enabledtabs[i] == "ziekte"){
            iframe = document.getElementById('editziekteframeViewer');
            tab = "ziekte"
        }
    }
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;

    innerDoc.getElementById("id").value = id;
    innerDoc.getElementById("project").value = project;
    innerDoc.getElementById("projectid").value = projectid;
    innerDoc.getElementById("boomid").value = boomid;
    innerDoc.getElementById("status").value = status;
    innerDoc.getElementById("mutatiedatum").value = mutatiedatum;
    innerDoc.getElementById("mutatietijd").value = mutatietijd;
    
    if (tab == "ziekte"){
        innerDoc.getElementById("aktie").value = aktie;
    }
    
    innerDoc.getElementById("boomsoort").value = boomsoort;
    innerDoc.getElementById("plantjaar").value = plantjaar;
    innerDoc.getElementById("boomhoogtevrij").value = boomhoogte;
    innerDoc.getElementById("boomhoogte").value = boomhoogte;
    innerDoc.getElementById("eindbeeldvrij").value = eindbeeld;
    innerDoc.getElementById("eindbeeld").value = eindbeeld;
    innerDoc.getElementById("scheefstand").checked = scheefstand;
    innerDoc.getElementById("scheuren").checked = scheuren;
    innerDoc.getElementById("holten").checked = holten;
    innerDoc.getElementById("stamvoetschade").checked = stamvoetschade;
    innerDoc.getElementById("stamschade").checked = stamschade;
    innerDoc.getElementById("kroonschade").checked = kroonschade;
    innerDoc.getElementById("inrot").checked = inrot;
    innerDoc.getElementById("houtboorder").checked = houtboorder;
    innerDoc.getElementById("zwam").checked = zwam;
    innerDoc.getElementById("zwam_stamvoet").checked = zwam_stamvoet;
    innerDoc.getElementById("zwam_stam").checked = zwam_stam;
    innerDoc.getElementById("zwam_kroon").checked = zwam_kroon;
    innerDoc.getElementById("dood_hout").checked = dood_hout;
    innerDoc.getElementById("plakoksel").checked = plakoksel;
    innerDoc.getElementById("stamschot").checked = stamschot;
    innerDoc.getElementById("wortelopslag").checked = wortelopslag;
    innerDoc.getElementById("takken").checked = takken;
    innerDoc.getElementById("opdruk").checked = opdruk;
    innerDoc.getElementById("vta1").checked = vta1;
    innerDoc.getElementById("vta2").checked = vta2;
    innerDoc.getElementById("vta3").checked = vta3;
    innerDoc.getElementById("vta4").checked = vta4;
    innerDoc.getElementById("vta5").checked = vta5;
    innerDoc.getElementById("vta6").checked = vta6;    
    innerDoc.getElementById("aantastingen").value = aantastingen;
    
    fillStatusZiektenDropdown(iframe);
    
    innerDoc.getElementById("maatregelen_kort").value = maatregelen_kort;
    innerDoc.getElementById("maatregelen_lang").value = maatregelen_lang;
    innerDoc.getElementById("wegtype").value = wegtype;
    innerDoc.getElementById("aantastingenvrij").value = aantastingen;
    innerDoc.getElementById("maatregelen_kortvrij").value = maatregelen_kort;
    innerDoc.getElementById("maatregelen_langvrij").value = maatregelen_lang;
    innerDoc.getElementById("wegtypevrij").value = wegtype;
    innerDoc.getElementById("bereikbaarheid").checked = bereikbaarheid;
    innerDoc.getElementById("nader_onderzoek").checked = nader_onderzoek;
    innerDoc.getElementById("status_zp").value = status_zp;
    
    fillClassificatieDropdown(iframe);
    
    innerDoc.getElementById("classificatie").value = classificatie;
    innerDoc.getElementById("risicoklasse").value = risicoklasse;
    innerDoc.getElementById("uitvoerdatum").value = uitvoerdatum;
    
    innerDoc.getElementById("extra1").value = extra1;
    innerDoc.getElementById("extra2").value = extra2;
    innerDoc.getElementById("extra3").value = extra3;
    innerDoc.getElementById("extra4").value = extra4;
    innerDoc.getElementById("extra5").value = extra5;
    innerDoc.getElementById("extra6").value = extra6;
    innerDoc.getElementById("extra7").value = extra7;
    innerDoc.getElementById("extra8").value = extra8;
    innerDoc.getElementById("extra9").value = extra9;
    innerDoc.getElementById("extra10").value = extra10;

    if (opmerkingen != null && opmerkingen != "undefined") {
        innerDoc.getElementById("opmerking").value = opmerkingen;
    } else {
        innerDoc.getElementById("opmerking").value = "";
    }
    
    editingBoom = false;
}

function fillStatusZiektenDropdown(iframe){
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
    
    var aantasting = innerDoc.getElementById("aantastingen").value;
    var select = innerDoc.getElementById("status_zp"); 
    
    emptyStatusDropdown(iframe);
        
    if(aantasting == 'eikenprocessierups' || aantasting == 'bloedingsziekte' || aantasting == 'massaria' || aantasting == 'iepziekte' || aantasting == 'essterfte'){
        select.add(new Option("melding", "melding"), null);
        select.add(new Option("monitoring", "monitoring"), null);
        select.add(new Option("registratie", "registratie"), null);
        select.add(new Option("bestreden", "bestreden"), null);
    }
    
    innerDoc.getElementById("aantastingenvrij").value = "";
}

function fillClassificatieDropdown(iframe) {
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
    
    var status_zp = innerDoc.getElementById("status_zp").value;
    var select = innerDoc.getElementById("classificatie"); 
    
    emptyClassificatieDropdown(iframe);
    
    if(status_zp == 'melding'){
        select.add(new Option("gemeente", "gemeente"), null);
        select.add(new Option("particulier", "particulier"), null);
        select.add(new Option("provincie", "provincie"), null);
    }else if(status_zp == 'monitoring'){
        select.add(new Option("spuitlocatie", "spuitlocatie"), null);
        select.add(new Option("feromoonval", "feromoonval"), null);
        select.add(new Option("controlelocatie", "feromoonval"), null);
    }else if(status_zp == 'registratie'){
        select.add(new Option("prioriteit: urgent", "prioriteit: urgent"), null);
        select.add(new Option("prioriteit: standaard", "prioriteit: standaard"), null);
        select.add(new Option("prioriteit: laag", "prioriteit: laag"), null);
        select.add(new Option("prioriteit: geen", "prioriteit: geen"), null);
    }else if(status_zp == 'bestreden'){
        select.add(new Option("hoge plaagdruk", "hoge plaagdruk"), null);
        select.add(new Option("matige plaagdruk", "matige plaagdruk"), null);
        select.add(new Option("lage plaagdruk", "lage plaagdruk"), null);
        select.add(new Option("geen plaagdruk", "geen plaagdruk"), null);
    }
}

function emptyStatusDropdown(iframe) {  
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
     
    var selectStatus = innerDoc.getElementById("status_zp"); 
    
    selectStatus.remove(9);
    selectStatus.remove(8);
    selectStatus.remove(7);
    selectStatus.remove(6);
    selectStatus.remove(5);
    selectStatus.remove(4);
    selectStatus.remove(3);
    selectStatus.remove(2);
    selectStatus.remove(1);  
}

function emptyClassificatieDropdown(iframe) {  
    var innerDoc = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
    
    var selectClassificatie = innerDoc.getElementById("classificatie"); 
    
    selectClassificatie.remove(9);
    selectClassificatie.remove(8);
    selectClassificatie.remove(7);
    selectClassificatie.remove(6);
    selectClassificatie.remove(5);
    selectClassificatie.remove(4);
    selectClassificatie.remove(3);
    selectClassificatie.remove(2);
    selectClassificatie.remove(1);    
}
/* End methodes edit tab */


//function wordt aangeroepen als er een identify wordt gedaan met de tool op deze map.
function onIdentify(movie,extend) {
    if(!usePopup && !usePanel && !useBalloonPopup) {
        return;
    }

    //todo: nog weghalen... Dit moet uniform werken.
    if (extend==undefined){
        extend=movie;
    }

    var geom = "";
    if (extend.minx!=extend.maxx && extend.miny!=extend.maxy) {
        // polygon
        geom += "POLYGON((";
        geom += extend.minx +" "+ extend.miny +",";
        geom += extend.maxx +" "+ extend.miny +",";
        geom += extend.maxx +" "+ extend.maxy +",";
        geom += extend.minx +" "+ extend.maxy +",";
        geom += extend.minx +" "+ extend.miny;
        geom += "))";
    }else{
        // point
        geom += "POINT(";
        geom += extend.minx +" "+ extend.miny;
        geom += ")";
    }

    webMapController.getMap().getLayer("editMap").removeAllFeatures();

    /* kijken of bezig met editen redline objecten */
    if (editingRedlining) {
        hideIdentifyIcon();
        selectRedlineObject(geom);
        return;
    }else if(editingBoom){
        hideIdentifyIcon();
        selectBoomObject(geom);
        return;
    }

    if (btn_highLightSelected) {        
        /* TODO: Vervangen voor generiek iets. Dit is nu nodig omdat
         * de flamingo config een breinaald
         * Mogelijke fix: nieuw soort tool maken (de highlight tool). Deze voeg je in OL niet aan
         * de panel toe, maar wel aan de tools array. Deze tool roep de highlightfunctionaliteit in
         * de gisviewer aan.*/
        if (webMapController instanceof FlamingoController) {
            webMapController.activateTool("breinaald");
        } else {
            webMapController.activateTool("identify");
        }

        hideIdentifyIcon();
        highLightThemaObject(geom);
    } else {
        btn_highLightSelected = false;
        
        webMapController.activateTool("identify");

        showIdentifyIcon();
        handleGetAdminData(geom, null, false);
    }
    
    loadObjectInfo(geom);
}


/* Berekenen lattitude en longitude waardes voor gebruik in Google
 * maps aanroep */
function getLatLonForGoogleMaps() {
    var centerWkt = getCenterWkt();
    var minWkt = getMinWkt();
    var maxWkt = getMaxWkt();

    JMapData.getLatLonForRDPoint(centerWkt, minWkt, maxWkt, openGoogleMaps);
}

/* Zie: http://mapki.com/wiki/Google_Map_Parameters */
function openGoogleMaps(values) {
    var ll = "&ll=" + values[1] + "," + values[0];
    var spn = "&spn=" + values[3] + "," + values[3];
    var options = "&hl=nl&om=0";
    var url = "https://maps.google.com/maps?ie=UTF8" + ll + spn + options;
    window.open(url);
}

var editingRedlining = false;
var redLineGegevensbronId = -1;
var editingBoom = false;

function enableEditRedlining(id) {
    editingRedlining = true;
    redLineGegevensbronId = id;

    webMapController.activateTool("breinaald");
}

function enableEditBoom(id) {
    editingBoom = true;
    boomGegevensbronId = id;

    webMapController.activateTool("breinaald");
}

function disableEditBoom(){
    editingBoom = false;
}

function enableNewBoom(id) {
    boomGegevensbronId = id;
}

var popupCreated = false;
$j(document).ready(function() {

    /* Alleen tabs vullen als ze ook echt aanstaan */
    var analyseTabOn = false;
    var meldingenTabOn = false;
    var vergunningTabOn = false;
    var zoekenTabOn = false;
    var redliningTabOn = false;
    var bagTabOn = false;
    var wktTabOn = false;
    var transparantieTabOn = false;
    var tekenTabOn = false;
    var editTabOn = false;
    var ziekteTabOn = false;

    for (var i=0; i < enabledtabs.length; i++) {
        if (enabledtabs[i] == "analyse")
            analyseTabOn = true;

        if (enabledtabs[i] == "meldingen")
            meldingenTabOn = true;

        if (enabledtabs[i] == "vergunningen")
            vergunningTabOn = true;

        if (enabledtabs[i] == "redlining")
            redliningTabOn = true;

        if (enabledtabs[i] == "bag")
            bagTabOn = true;

        if (enabledtabs[i] == "zoeken")
            zoekenTabOn = true;
        
        if (enabledtabs[i] == "wkt")
            wktTabOn = true;
        
        if (enabledtabs[i] == "transparantie")
            transparantieTabOn = true;
        
        if (enabledtabs[i] == "tekenen")
            tekenTabOn = true;
        
        if (enabledtabs[i] == "edit")
            editTabOn = true;
        
        if (enabledtabs[i] == "ziekte")
            ziekteTabOn = true;
    }

    if (analyseTabOn) {
        if (document.getElementById('analyseframeViewer')) {
            document.getElementById('analyseframeViewer').src='/digitree/vieweranalysedata.do';
        }
    }

    if (meldingenTabOn) {
        if(document.getElementById('meldingenframeViewer')) {
            document.getElementById('meldingenframeViewer').src='/digitree/viewermeldingen.do?prepareMelding=t';
        }
    }

    if (redliningTabOn) {
        if(document.getElementById('redliningframeViewer')) {
            document.getElementById('redliningframeViewer').src='/digitree/viewerredlining.do?prepareRedlining=t';
        }
    }

    if (bagTabOn) {
        if(document.getElementById('bagframeViewer')) {
            document.getElementById('bagframeViewer').src='/digitree/viewerbag.do';
        }
    }
    
    if (wktTabOn) {
        if(document.getElementById('wktframeViewer')) {
            document.getElementById('wktframeViewer').src='/digitree/viewerwkt.do';
        }
    }
    
    if (transparantieTabOn) {
        if(document.getElementById('transparantieframeViewer')) {
            document.getElementById('transparantieframeViewer').src='/digitree/viewertransparantie.do';
        }
    }
    
    if (tekenTabOn) {
        if(document.getElementById('tekenenframeViewer')) {
            document.getElementById('tekenenframeViewer').src='/digitree/viewerteken.do';
        }
    }
    
    if (editTabOn) {
        if(document.getElementById('editboomframeViewer')) {
            document.getElementById('editboomframeViewer').src='/digitree/viewereditboom.do';
        }
    }
    
    if (ziekteTabOn) {
        if(document.getElementById('editziekteframeViewer')) {
            document.getElementById('editziekteframeViewer').src='/digitree/viewereditziekte.do';
        }
    }

    if (zoekenTabOn || vergunningTabOn) {
        createSearchConfigurations();
    }

    var pwCreated = false;
    if(document.getElementById('popupWindow')) {
        pwCreated = true;
    }

    try {
        if(getParent().document.getElementById('popupWindow')) {
            pwCreated = true;
        }
    } catch(err) {}

    if(!pwCreated) {
        buildPopup();

        $j('#popupWindow').draggable({
            handle:    '#popupWindow_Handle',
            iframeFix: true,
            zIndex: 200,
            containment: 'document',
            start: function(event, ui) {
                startDrag();
            },
            stop: function(event, ui) {
                stopDrag();
            }
        }).resizable({
            handles: 'se',
            start: function(event, ui) {
                startResize();
            },
            stop: function(event, ui) {
                stopResize();
            }
        });

        $j('#popupWindow_Close').click(function(){
            if (dataframepopupHandle)
                dataframepopupHandle.closed = true;

            $j("#popupWindow").hide();
        });

    /* $j("#popupWindow").mouseover(function(){
            startDrag();
        });
        $j("#popupWindow").mouseout(function(){
            stopDrag();
        }); */

    }

    popupCreated = true;
    createDownloadMetadataDialog();
    createWMSServiceUrlDialog();
});
