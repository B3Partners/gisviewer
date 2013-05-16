<noscript>
<meta http-equiv="refresh" content="0; url=viewer.do?appCode=${bookmarkAppcode}&amp;accessibility=1" />
</noscript>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/engine.js'></script>

<script type='text/javascript' src='dwr/interface/EditUtil.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type='text/javascript' src='dwr/interface/JZoeker.js'></script>
<script type='text/javascript' src='dwr/interface/JZoekconfiguratieThemaUtil.js'></script>
<script type='text/javascript' src='dwr/interface/JEditFeature.js'></script>
<script type='text/javascript' src='dwr/interface/JMaatregelService.js'></script>

<script type='text/javascript' src='dwr/util.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/cookiefunctions.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/flashdetect.js"/>"></script>

<script type="text/javascript">
    var showDebugContent = false;
    
    var waitUntillFullyLoaded = false;

    var baseNameViewer = "${contextPath}";
    
    function catchEmpty(defval){
        return defval;
    }

    var beheerder = <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>;
    var organisatiebeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>;
    var themabeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>;
    var gebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>;
    var demogebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>;
    var anoniem= !beheerder && !organisatiebeheerder && !themabeheerder && !gebruiker && !demogebruiker;
    
    var sldServletUrl=window.location.protocol + "//" +  window.location.host +"<html:rewrite page='/CreateSLD'/>";

    var zoekconfiguraties = catchEmpty(${zoekconfiguraties});
    if(typeof zoekconfiguraties === 'undefined' || !zoekconfiguraties) {  
        zoekconfiguraties = [{}];
    }

    var ingelogdeGebruiker="<c:out value='${pageContext.request.remoteUser}'/>";
    var kburl="${kburl}";
    var kbcode="${kbcode}";

    var themaTree=catchEmpty(${tree});
    if(typeof themaTree === 'undefined' || !themaTree) {
        themaTree = null;
    }
    
    var organizationcode="${organizationcode}";
    var fullbbox='${fullExtent}';

    var bbox='${extent}';
    
    /* Applicatie extent */
    var appExtent = catchEmpty("${configMap["extent"]}");
    if (typeof appExtent === 'undefined' || !appExtent) {
        appExtent = "12000,304000,280000,620000";
    }

    var resolution=catchEmpty(${resolution});

    /* init search */
    var searchConfigId='${searchConfigId}';
    var search='${search}';

    /* search with sld result (searchAction: filter or highlight and zoom) */
    var searchAction='${searchAction}';
    var searchId='${searchId}';
    var searchClusterId='${searchClusterId}';
    var searchSldVisibleValue='${searchSldVisibleValue}';

    /* Viewer type */
    var viewerType = catchEmpty("${configMap["viewerType"]}");
    if(typeof viewerType === 'undefined' || !viewerType) {
        viewerType = 'flamingo';
    }

    /* If viewerType == flamingo, check for Flash -> If no Flash installed choose OpenLayers */
    if(viewerType == 'flamingo') {
        var flashVersion = ua().pv;
        if(flashVersion[0] == 0) {
            viewerType = 'openlayers';
        }
    }

    /* Viewer type */
    var viewerTemplate = catchEmpty("${configMap["viewerTemplate"]}");
    if(typeof viewerTemplate === 'undefined' || !viewerTemplate) {
        viewerTemplate = 'standalone';
    }

    /* ObjectInfo type */
    var objectInfoType = catchEmpty("${configMap["objectInfoType"]}");
    if(typeof objectInfoType === 'undefined' || !objectInfoType) {
        objectInfoType = 'popup';
    }


    /* Variable op true zetten als er gebruik wordt gemaakt van uitschuifbare panelen */
    var usePanelControls=catchEmpty(${configMap["usePanelControls"]});
    if(typeof usePanelControls === 'undefined') {
        usePanelControls = true;
    }

    /* True als de admin- of metadata in een popup wordt getoond
     * False als deze onder de kaart moet worden getoond
     * dataframepopupHandle wordt gebruikt wanneer de data in een popup wordt getoond */
    var useDivPopup=catchEmpty(${configMap["useDivPopup"]});
    if(typeof useDivPopup === 'undefined') {
        useDivPopup = false;
    }

    if(objectInfoType == "geen") {
        usePopup = false;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = false;
        useBalloonPopup=false;
    }
    if(objectInfoType == "popup") {
        usePopup = true;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = true;
        useBalloonPopup=false;
    }
    if(objectInfoType == "paneel") {
        usePopup = false;
        usePanel = true;
        useDivPopup = false;
        useBalloonPopup=false;
    }
    if (objectInfoType== "balloon"){
        usePopup=false;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = false;
        useBalloonPopup=true;
    }

    var dataframepopupHandle = null;

    var useCookies=catchEmpty(${configMap["useCookies"]});
    if(typeof useCookies === 'undefined') {
        useCookies = true;
    }

    /* True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
     * False als je maximaal van 1 thema data kan ophalen. (radiobuttons) */
    var multipleActiveThemas=catchEmpty(${configMap["multipleActiveThemas"]});
    if(typeof multipleActiveThemas === 'undefined') {
        multipleActiveThemas = true;
    }

    /* Deze waarde wordt gebruikt om de admindata automatisch door te sturen op het moment dat er maar
     * 1 regel en 1 thema aan admindata is. De waarde is voor het aantal kollomen dat weergegeven moet
     * worden om automatisch door te sturen. (bijv: Als de kollomen id, naam, link zijn moet er 3 staan
     * als de admindata automatisch moeten worden doorgestuurd) */
    var autoRedirect=catchEmpty(${configMap["autoRedirect"]});
    if(typeof autoRedirect === 'undefined' || !autoRedirect) {
        autoRedirect = 2;
    }

    /* Het aantal pixels dat moet worden gebruikt als er ergens in de kaart is geklikt
     * en info wordt opgevraagd. Dus een tolerantie. */
    var tolerance=catchEmpty(${configMap["tolerance"]});
    if(typeof tolerance === 'undefined' || !tolerance) {
        tolerance = 1;
    }

    /* Bepaalt of legend afbeeldingen ook in de kaartlagen tree zichtbaar kunnen worden gemaakt. */
    var showLegendInTree = catchEmpty(${configMap["showLegendInTree"]});
    if (typeof showLegendInTree === 'undefined') {
        showLegendInTree = true;
    }

    /* Bepaalt of ouder clusters allemaal aangevinkt moeten staan voordat
     * kaartlaag zichtbaar is in viewer. Default op true */
    var useInheritCheckbox = catchEmpty(${configMap["useInheritCheckbox"]});
    
    if(typeof useInheritCheckbox === 'undefined') {
        useInheritCheckbox = true;
    }

    var tabWidth = catchEmpty(${configMap["tabWidth"]});
    if (typeof tabWidth === 'undefined') {
        tabWidth = 288;
    }

    /*
     * Kijkt of de ingelogde gebruiker ook de vorige ingelogde gebruiker is,
     * zo nee, worden eerst alle cookies gewist, zodat een nieuwe gebruiker opnieuw kan beginnen */
    var loggedInUser = readCookie('loggedInUser');
    if(loggedInUser != null) {
        if(loggedInUser != '<c:out value="${pageContext.request.remoteUser}"/>') {
            eraseCookie('activelayer');
            eraseCookie('activetab');
            eraseCookie('checkedLayers');
            eraseCookie('checkedClusters');
        }
    }
    createCookie('loggedInUser', '<c:out value="${pageContext.request.remoteUser}"/>', '7');
	
    /*
     * True als het mogelijk moet zijn om de volgorde van de layers te slepen met de muis
     * de kaart wordt na het slepen automatisch herladen na x aantal (instellen door layerDelay) seconden
     * de buttons Omhoog, Omlaag, Herladen zijn niet zichtbaar
     * 
     * False als de volgorde alleen bepaald moet kunnen worden door de buttons Omhoog en Omlaag */
    var useSortableFunction=catchEmpty(${configMap["useSortableFunction"]});
    if(typeof useSortableFunction === 'undefined') {
        useSortableFunction = false;
    }
    var layerDelay = catchEmpty(${configMap["layerDelay"]}); // instellen in ms, dus 5000 voor 5 seconden
    if(typeof layerDelay === 'undefined' || !layerDelay) {
        layerDelay = 5000;
    }

    /* de vertraging voor het refreshen van de kaart. */
    var refreshDelay=catchEmpty(${configMap["refreshDelay"]});
    if(typeof refreshDelay === 'undefined' || !refreshDelay) {
        refreshDelay = 1000;
    }

    /*
     * Geef hier de zoekconfigs op die zichtbaar moeten zijn (moet later in een tabel en dan in de action alleen
     * die configuraties ophalen die in de settings tabel staan. Dus deze param weg (+ bijhorende functie).
     * Voor alles wat weg moet staat: ZOEKCONFIGURATIEWEG (even zoeken op dus) */
    var zoekConfigIds = catchEmpty(${configMap["zoekConfigIds"]});
    if(typeof zoekConfigIds === 'undefined' || !zoekConfigIds) {
        zoekConfigIds = "";
    }

    /* Voorzieningen */
    var voorzieningConfigIds = catchEmpty(${configMap["voorzieningConfigIds"]});
    if(typeof voorzieningConfigIds === 'undefined' || !voorzieningConfigIds) {
        voorzieningConfigIds = "";
    }

    var voorzieningConfigStraal = catchEmpty(${configMap["voorzieningConfigStraal"]});
    if(typeof voorzieningConfigStraal === 'undefined' || !voorzieningConfigStraal) {
        voorzieningConfigStraal = "";
    }

    var voorzieningConfigTypes = catchEmpty(${configMap["voorzieningConfigTypes"]});
    if(typeof voorzieningConfigTypes === 'undefined' || !voorzieningConfigTypes) {
        voorzieningConfigTypes = "";
    }

    /* Vergunningen */
    var vergunningConfigIds = catchEmpty(${configMap["vergunningConfigIds"]});
    if(typeof vergunningConfigIds === 'undefined' || !vergunningConfigIds) {
        vergunningConfigIds = "";
    }

    var vergunningConfigStraal = catchEmpty(${configMap["vergunningConfigStraal"]});
    if(typeof vergunningConfigStraal === 'undefined' || !vergunningConfigStraal) {
        vergunningConfigStraal = "";
    }
    
    /*
     * De minimale groote van een bbox van een gezocht object. Als de bbox kleiner is wordt deze vergroot tot de
     * hier gegeven waarde. Dit om zoeken op punten mogelijk te maken. */
    var minBboxZoeken=catchEmpty(${configMap["minBboxZoeken"]});
    if(typeof minBboxZoeken === 'undefined' || !minBboxZoeken) {
        minBboxZoeken = 1000;
    }

    /* Maximaal aantal zoekresultaten */
    var maxResults=catchEmpty(${configMap["maxResults"]});
    if(typeof maxResults === 'undefined' || !maxResults) {
        maxResults = 25;
    }

    /* Gebruiker wisselt tabbladen door er met de muis overheen te gaan. Indien false
     * dan zijn de tabbladen te wisselen door te klikken */
    var useMouseOverTabs = catchEmpty(${configMap["useMouseOverTabs"]});
    if (typeof useMouseOverTabs === 'undefined') {
        useMouseOverTabs = true;
    }
    
    // Tree expand all
    var expandAll=catchEmpty(${configMap["expandAll"]});
    if(typeof expandAll === 'undefined') {
        expandAll = false;
    } 
    
    /* TODO: voorzieningen en vergunning even uitgecomment deze geven
     * document.getElementById(tabobj.contentid).style.display = 'none'; is null
     * als de iframes uitstaan en ze wel in de var tabbladen aanstaan.

     * De beschikbare tabbladen. Het ID van de tab, de bijbehoorden Content-div,
     * de naam en eventueel extra Content-divs die geopend moeten worden */
    
    var tabbladen = {
        "themas": { "id": "themas", "contentid": "treevak", "name": "Kaarten", "extracontent": ["layermaindiv"], "class": "TreeComponent", 'options': { 'tree': themaTree, 'servicestrees': ${servicesTrees}, 'expandAll': expandAll } },
        "zoeken": { "id": "zoeken", "contentid": "infovak", "name": "Zoeken" },
        "gebieden": { "id": "gebieden", "contentid": "objectvakViewer", "name": "Gebieden", "class": "IframeComponent", 'options': { 'src': 'empty_iframe.jsp' } },
        "analyse": { "id": "analyse", "contentid": "analysevakViewer", "name": "Analyse", "class": "IframeComponent", 'options': { 'src': '/gisviewer/vieweranalysedata.do' } },
        "legenda": { "id": "legenda", "contentid": "volgordevak", "name": "Legenda", "resizableContent": true },
        "informatie": { "id": "informatie", "contentid": "beschrijvingvak", "name": "Informatie", "class": "IframeComponent", 'options': { 'src': 'empty_iframe.jsp' } },
        "planselectie": { "id": "planselectie", "contentid": "plannenzoeker", "name": "Planselectie" },
        "meldingen": { "id": "meldingen", "contentid": "meldingenvakViewer", "name": "Melding", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewermeldingen.do?prepareMelding=t' } },
        "voorzieningen": { "id": "voorzieningen", "contentid": "voorzieningzoeker", "name": "Voorziening", "class": "IframeComponent", 'options': { 'src': '/gisviewer/zoekVoorziening.do' } },
        "vergunningen": { "id": "vergunningen", "contentid": "vergunningzoeker", "name": "Vergunning", "class": "IframeComponent", 'options': { 'src': '/gisviewer/zoekVergunning.do' } },
        "redlining": { "id": "redlining", "contentid": "redliningvakViewer", "name": "Redlining", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerredlining.do?prepareRedlining=t' } },
        "cms": {id: "cms", contentid: "cmsvak", name: "Extra"},
        "bag": {id: "bag", contentid: "bagvakViewer", name: "BAG", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerbag.do' } },
        "wkt": {id: "wkt", contentid: "wktvakViewer", name: "WKT", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerwkt.do' } },
        "transparantie": {id: "transparantie", contentid: "transparantievakViewer", name: "Transparantie", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewertransparantie.do' } },
        "tekenen" : {id: "tekenen", contentid: "tekenenvakViewer", name: "Tekenen", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerteken.do' } },
        "uploadpoints": { "id": "uploadpoints", "contentid": "uploadtemppointsvakViewer", "name": "Upload Points", "class": "IframeComponent", 'options': { 'src': '/gisviewer/uploadtemppoints.do' } }
    };

    var enabledtabs = [${configMap["tabs"]}];
    var enabledtabsLeft = [${configMap["tabsLeft"]}];

    /* planselectie gebruikt 2 zoekingangen (id's) */
    var planSelectieIds = catchEmpty(${configMap["planSelectieIds"]});
    if(typeof planSelectieIds === 'undefined' || !planSelectieIds) {
        planSelectieIds = "0,0";
    }

    /* Buttons boven viewer aan / uit */
    var showRedliningTools = catchEmpty(${configMap["showRedliningTools"]});
    if (typeof showRedliningTools === 'undefined') {
        showRedliningTools = false;
    }

    var showBufferTool = catchEmpty(${configMap["showBufferTool"]});
    if (typeof showBufferTool === 'undefined') {
        showBufferTool = false;
    }

    var showSelectBulkTool = catchEmpty(${configMap["showSelectBulkTool"]});
    if (typeof showSelectBulkTool === 'undefined') {
        showSelectBulkTool = false;
    }

    var showNeedleTool = catchEmpty(${configMap["showNeedleTool"]});
    if (typeof showNeedleTool === 'undefined') {
        showNeedleTool = false;
    }

    var showPrintTool = catchEmpty(${configMap["showPrintTool"]});
    if (typeof showPrintTool === 'undefined') {
        showPrintTool = false;
    }

    var showLayerSelectionTool = catchEmpty(${configMap["showLayerSelectionTool"]});
    if (typeof showLayerSelectionTool === 'undefined') {
        showLayerSelectionTool = false;
    }
    
    var showGPSTool = catchEmpty(${configMap["showGPSTool"]});
    if (typeof showGPSTool === 'undefined') {
        showGPSTool = false;
    }
    
    var showEditTool = catchEmpty(${configMap["showEditTool"]});
    if (typeof showEditTool === 'undefined') {
        showEditTool = false;
    }
    
    var gpsBuffer = catchEmpty(${configMap["gpsBuffer"]});
    if (typeof gpsBuffer === 'undefined') {
        gpsBuffer = false;
    }

    var layerGrouping = catchEmpty("${configMap["layerGrouping"]}");
    if(typeof layerGrouping === 'undefined' || !layerGrouping) {
        layerGrouping = "lg_forebackground";
    }

    var popupWidth = catchEmpty("${configMap["popupWidth"]}");
    if(typeof popupWidth === 'undefined' || !popupWidth) {
        popupWidth = "90%";
    }

    var popupHeight = catchEmpty("${configMap["popupHeight"]}");
    if(typeof popupHeight === 'undefined' || !popupHeight) {
        popupHeight = "20%";
    }

    var popupLeft = catchEmpty("${configMap["popupLeft"]}");
    if(typeof popupLeft === 'undefined' || !popupLeft) {
        popupLeft = "5%";
    }

    var popupTop = catchEmpty("${configMap["popupTop"]}");
    if(typeof popupTop === 'undefined' || !popupTop) {
        popupTop = "75%";
    }

    var defaultdataframehoogte = catchEmpty(${configMap["defaultdataframehoogte"]});
    if(typeof defaultdataframehoogte === 'undefined' || !defaultdataframehoogte) {
        defaultdataframehoogte = 150;
    }

    var bookmarkAppcode = catchEmpty("${bookmarkAppcode}");
    if(typeof bookmarkAppcode === 'undefined' || !bookmarkAppcode) {
        bookmarkAppcode = "";
    }
	
    /* Variable wordt gebruikt om de huidige active tab in op te slaan */
    var currentActiveTab = null;
    
    function getZoekconfiguraties(){
        return zoekconfiguraties;
    }
    function getVoorzieningConfigIds(){
        return voorzieningConfigIds;
    }
    function getMaxResults(){
        return maxResults;
    }
    function getVoorzieningConfigStraal(){
        return voorzieningConfigStraal;
    }
    function getVoorzieningConfigTypes(){
        return voorzieningConfigTypes;
    }
    function getVergunningConfigIds(){
        return vergunningConfigIds;
    }
    function getVergunningConfigStraal(){
        return vergunningConfigStraal;
    }

    var tekstblokken = ${tekstBlokken};

    /* Boomsortering */
    var treeOrder = catchEmpty("${configMap["treeOrder"]}");
    if(typeof treeOrder === 'undefined' || !treeOrder) {
        treeOrder = 'volgorde';
    }
    
    var useUserWmsDropdown = catchEmpty(${configMap["useUserWmsDropdown"]});
    if(typeof useUserWmsDropdown === 'undefined') {
        useUserWmsDropdown = true;
    }
    
    var datasetDownload = catchEmpty(${configMap["datasetDownload"]});
    if (typeof datasetDownload === 'undefined') {
        datasetDownload = false;
    }
    
    var tilingResolutions = catchEmpty("${configMap["tilingResolutions"]}");
    if (typeof tilingResolutions === 'undefined' || !tilingResolutions) {
        tilingResolutions = "";
    }
    
    var showServiceUrl = catchEmpty(${configMap["showServiceUrl"]});
    if (typeof showServiceUrl === 'undefined') {
        showServiceUrl = false;
    }
    
    var startLocationX = catchEmpty(${startLocationX});
    if (typeof startLocationX === 'undefined' || !startLocationX) {
        startLocationX = "";
    }  
    var startLocationY = catchEmpty(${startLocationY});
    if (typeof startLocationY === 'undefined' || !startLocationY) {
        startLocationY = "";
    }
</script>
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/selectbox.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/moveLayers.js"/>"></script>

<c:set var="defaultMargin" value="3" />
<c:set var="animationDuration" value=".5" />
<style type="text/css">
    /* Defaults -> tabs ingeklapt, dataframe ingeklapt, kaart van volledige breedte en hoogte (minus header) */
    #content_viewer #leftcontent, #content_viewer #leftcontenttabjes, #content_viewer #leftcontentnav, #content_viewer #tab_container, #content_viewer #tabjes, #content_viewer #nav {
        width: 0px;
        transition: all ${animationDuration}s ease-out;
        visibility: hidden;
    }
    #content_viewer #dataframediv {
        height: 0px;
        transition: height ${animationDuration}s ease-out;
    }
    #content_viewer #informatiebalk {
        bottom: -30px;
        visibility: hidden;
        transition: all ${animationDuration}s linear;
    }
    #content_viewer #onderbalkControl {
        bottom: 5px;
        transition: bottom ${animationDuration}s linear;
    }
    #content_viewer #mapcontent {
        left: ${defaultMargin}px;
        right: ${defaultMargin}px;
        bottom: ${defaultMargin}px;
        transition: left ${animationDuration}s linear, right ${animationDuration}s linear, bottom ${animationDuration}s linear;
    }
    #content_viewer #leftcontent, #content_viewer #tab_container {
        bottom: ${defaultMargin}px;
    }
    /* Switches */
    #content_viewer.tablinks_open #leftcontent, #content_viewer.tablinks_open #leftcontenttabjes, #content_viewer.tablinks_open #leftcontentnav {
        width: ${configMap["tabWidth"]}px;
        visibility: visible;
    }
    #content_viewer.tablinks_open #mapcontent {
        left: ${configMap["tabWidth"] + (2 * defaultMargin)}px;
    }
    #content_viewer.tabrechts_open #tab_container, #content_viewer.tabrechts_open #tabjes, #content_viewer.tabrechts_open #nav {
        width: ${configMap["tabWidth"]}px;
        visibility: visible;
    }
    #content_viewer.tabrechts_open #mapcontent {
        right: ${configMap["tabWidth"] + (2 * defaultMargin)}px;
    }
    #content_viewer.dataframe_open #dataframediv {
        height: ${configMap["defaultdataframehoogte"]}px;
    }
    #content_viewer.dataframe_open #informatiebalk {
        visibility: visible;
        bottom: ${configMap["defaultdataframehoogte"] + defaultMargin}px;
    }
    #content_viewer.dataframe_open #mapcontent, #content_viewer.dataframe_open #tab_container, #content_viewer.dataframe_open #leftcontent {
        bottom: ${configMap["defaultdataframehoogte"] + (3 * defaultMargin) + 20}px;
    }
    #content_viewer.dataframe_open #onderbalkControl {
        bottom: ${configMap["defaultdataframehoogte"] + 5}px;
    }
</style>

<div style="display: none;">
    <html:form action="/viewerdata?code=${kbcode}">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="objectdata"/>
        <input type="hidden" name="search"/>
        <input type="hidden" name="searchId"/>
        <input type="hidden" name="searchClusterId"/>
        <input type="hidden" name="withinObject"/>
        <input type="hidden" name="onlyFeaturesInGeom"/>
        <input type="hidden" name="extraCriteria"/>
        <input type="hidden" name="bookmarkAppcode"/>

        <html:hidden property="themaid" />
        <html:hidden property="analysethemaid" />
        <html:hidden property="lagen" />
        <html:hidden property="coords" />
        <html:hidden property="geom" />
        <html:hidden property="scale"/>
        <html:hidden property="tolerance"/>
    </html:form>
</div>

<div id="leftcontenttabjes"><ul id="leftcontentnav" class="tabsul"></ul></div>
<div id="leftcontent"></div>

<div id="mapcontent">
    <div id="flashmelding"></div>
</div>
<script type="text/javascript">
    if(viewerType == 'flamingo') {
        setTimeout(function() {
            $j("#flashmelding").html('<strong class="noflamingoerror"><br/><br/><br/><br/><br/>U heeft de Flash plugin nodig om de kaart te kunnen zien.<br/>Deze kunt u <a href="http://get.adobe.com/flashplayer/" target="_blank">hier</a> gratis downloaden.</strong>');
        }, 2000);
    }
</script>

<div id="tabjes"><ul id="nav" class="tabsul"></ul></div>
<div id="tab_container"></div>

<div id="tabContentContainers" style="display: none;">
    <div id="volgordevak">
        <form action="" id="volgordeForm">  
            <div id="orderLayerBox" class="orderLayerBox tabvak_groot"></div>

            <!-- slider -->
            <div id="transSlider" style="height: 50px; width: 260px; padding-left: 5px;">
                <p>
                    Transparantie van alle voorgrondlagen.
                </p>

                <div style="float: left; font-size: 22px; padding-right: 3px; margin-top: -8px;">-</div>
                <div id="slider" style="width: 215px; float: left"></div>
                <div style="float: left; font-size: 22px; padding-left: 10px; margin-top: -6px;">+</div>
                <div style="clear: both;"></div>
            </div>

            <script type="text/javascript">
                $j(function() {
                    $j("#slider").slider({
                        min: 0,
                        max: 100,
                        value: 100,
                        animate: true,
                        change: function(event, ui) { 
                            transparency(ui.value); 
                        }
                    });
                });
                function transparency(value){
                    var opacity = 1.0 - value/100;
                    var layers = parent.webMapController.getMap().getLayers();
                    for( var i = 0 ; i < layers.length ; i++ ){
                        var l = layers[i];
                        if(!l.getOption("background")){
                            l.setOpacity (opacity);
                        }
                    }
                }
            </script>

            <%--
            <p>Bepaal de volgorde waarin de kaartlagen getoond worden</p>

            <div>
                <script type="text/javascript">
                    if(!useSortableFunction) {
                        document.write('<input type="button" value="Omhoog" onclick="javascript: moveSelectedUp()" class="knop" />');
                        document.write('<input type="button" value="Omlaag" onclick="javascript: moveSelectedDown()" class="knop" />');
                        document.write('<input type="button" value="Herladen" onclick="refreshMapVolgorde();" class="knop" />');
                    }
                </script>
            </div>
            --%>
        </form>
    </div>
    <div id="plannenzoeker" style="display: none; overflow: auto;" class="tabvak">
        <div class="planselectcontainer">
            <div id="kolomTekst">
                <p>
                    U kunt met onderstaande filters een plan selecteren. De viewer zal
                    hier dan naar toe zoomen.
                </p>

                <p>
                    <b>Eigenaar</b>
                    <select id="eigenaarselect" name="eigenaarselect" onchange="eigenaarchanged(this)" class="planselectbox" size="10" disabled="true">
                        <option value="">Bezig met laden eigenaren...</option>
                    </select>
                </p>

                <p>
                    <b>Type</b>
                    <select id="plantypeselect" name="plantypeselect" size="10" class="planselectbox" onchange="plantypechanged(this)">
                        <option value="">Selecteer een plantype...</option>
                    </select>
                </p>

                <p>
                    <b>Status</b>
                    <select id="statusselect" name="statusselect" size="10" class="planselectbox" onchange="statuschanged(this)">
                        <option value="">Selecteer een planstatus...</option>
                    </select>
                </p>

                <p>
                    <b>Plan</b>
                    <select id="planselect" name="planselect" size="10" class="planselectbox" onchange="planchanged(this)">
                        <option value="">Selecteer een plan...</option>
                    </select>
                </p>

                <div id="selectedPlan">Nog geen plan geselecteerd.</div>
            </div>
        </div>
    </div>
    <div id="infovak" style="display: none; overflow: auto;" class="tabvak">
        <c:if test="${!empty search}">
            <p>
                <input type="button" class="knop" value="Verwijder marker" onclick="removeSearchResultMarker();"/>
            </p>
        </c:if>

        <p>
            Kies uit de lijst de objecten waar u op wilt zoeken en vul
            daarna de zoekvulden in.
        </p>

        <p>
            <c:if test="${!empty a11yStartWkt}">
                <p>
                    U heeft een startlocatie ingesteld. Deze locatie staat op 
                    de kaart gemarkeerd. Bij zoekers die hier gebruik van maken
                    wordt de afstand naar de startlocatie getoond.
                </p>
                <p>
                    <input type="button" class="knop" value="Verwijder marker" onclick="removeSearchResultMarker();"/>
                </p>
            </c:if>
        </p>

        <div>
            <div id="searchConfigurationsContainer"></div>
            <div id="searchInputFieldsContainer"></div>
            <br>
            <div class="searchResultsClass" id="searchResults"></div>
        </div>
    </div>
    <div id="cmsvak" style="display: none; overflow: auto;" class="tabvak">
        <%-- als er maar 1 tekstblok is dan die titel plaatsen --%>
        <c:if test="${fn:length(tekstBlokken)==1}">
            <script type="text/javascript">
                $j("#cmslink").html("${tekstBlokken[0].titel}");
            </script>
        </c:if>
        <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
            <div class="content_block_tab">
                <div class="content_title"><c:out value="${tb.titel}"/></div>
                <!-- Indien toonUrl aangevinkt is dan inhoud van url in iFrame tonen -->
                <c:choose>
                    <c:when test="${tb.toonUrl}">
                        <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                    </c:when>

                    <%-- Anders gewoon de tekst tonen van tekstblok --%>
                    <c:when test="${!tb.toonUrl}">
                        <div class="inleiding_body">
                            ${tb.tekst}

                            <c:if test="${!empty tb.url}">
                                Meer informatie: <a href="${tb.url}" target="_new">${tb.url}</a>
                            </c:if>

                            <c:if test="${tb.toonUrl}">
                                <iframe id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                            </c:if>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Mapviewer JS -->
<script type="text/javascript" src="<html:rewrite page="/scripts/openlayers/OpenLayers.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/proj4js-compressed.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/Controller.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/FlamingoController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/OpenLayersController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer.js"/>"></script>
<!-- Tabcomponents JS -->
<script type="text/javascript" src="<html:rewrite page="/scripts/components/ViewerComponent.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/components/TabComponent.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/components/IframeComponent.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/components/TreeComponent.js"/>"></script>
        
<script type="text/javascript">
    // Show left tabs when enabled
    var showLeftPanel = false;
    if(enabledtabsLeft.length !== 0) {
        showLeftPanel = true;
        $j('#leftcontenttabjes, #leftcontent').show();
    }
    // Function to create a tab
    function createTabcomponent(tabno, tabComponent) {
        // Get tabid
        var tabid = enabledtabs[tabno];
        // Get tabobj from tabbladen defs
        var tabobj = tabbladen[tabid];
        // If a class is defined, create class
        if(tabobj.class) {
            // Extend default options by options from tabbladen defs
            var options = jQuery.extend({
                tabid: tabid,
                id: tabobj.contentid,
                title: tabobj.name
            }, tabobj.options || {});
            // Create the defined component
            var comp = B3PGissuite.createComponent(tabobj.class, options);
            // Render the component to the tab
            comp.renderTab(tabComponent);
        // Else create a tab from existing content
        } else {
            // Set taboptions
            var options = { 'contentid': tabobj.contentid, 'checkResize': true };
            // Create a tab
            tabComponent.createTab(tabid, tabobj.name, options);
        }
    }
    // Init tab controllers
    var tabComponent = B3PGissuite.createComponent('TabComponent', { 'labelContainer': 'tabjes', 'tabContainer': 'tab_container', 'width': tabWidth, useClick: !useMouseOverTabs, useHover: useMouseOverTabs });
    var leftTabComponent = B3PGissuite.createComponent('TabComponent', { 'labelContainer': 'leftcontenttabjes', 'tabContainer': 'leftcontent', 'width': tabWidth, useClick: !useMouseOverTabs, useHover: useMouseOverTabs });
    // Loop over enabled tabs
    for(i in enabledtabs) {
        createTabcomponent(i, tabComponent);
    }
    // Loop over tabs on the left
    for(i in enabledtabsLeft) {
        createTabcomponent(i, leftTabComponent);
    }

    var noOfTabs = tabComponent.getTabCount(), noLeftTabs = leftTabComponent.getTabCount();
    if(usePanel) {
        document.write('<div class="infobalk" id="informatiebalk">'
            +'     <div class="infobalk_description">INFORMATIE</div>'
            +'     <div class="infobalk_actions">&nbsp;</div>'
            +' </div>'
            +' <div id="dataframediv" class="dataframediv">'
            +'     <iframe id="dataframe" name="dataframe" frameborder="0" src="viewerwelkom.do"></iframe>'
            +' </div>');
    }
    if(usePanelControls) {
        document.write('<div id="panelControls">');
        if(noOfTabs > 0) document.write('<div id="rightControl" class="right_open" onclick="panelResize(\'right\');"><a href="#"></a></div>');
        if(noLeftTabs > 0) document.write('<div id="leftControl" class="left_closed" onclick="panelResize(\'left\');"><a href="#"></a></div>');
        document.write('<div id="onderbalkControl" class="bottom_open" onclick="panelResize(\'below\');"></div></div>');
    }

    if(noLeftTabs > 0) {
        $j('#content_viewer').addClass('tablinks_open');
    }
    if(noOfTabs > 0) {
        $j('#content_viewer').addClass('tabrechts_open');
    }
    if(!usePopup && usePanel) {
        $j('#content_viewer').addClass('dataframe_open');
    }
    
    /**
    * Start off with initMapComponent()
    */
    initMapComponent();
    
    var activeTab = readCookie('activetab');
    if(activeTab !== null) {
        switchTab(activeTab);
    } else if (demogebruiker) {
        switchTab('themas');
    } else {
        switchTab('themas');
    }
    var orderLayerBox= document.getElementById("orderLayerBox");
</script>

<script type="text/javascript">

    var imageBaseUrl = "<html:rewrite page="/images/"/>";

    <c:if test="${not empty activeTab}">
        if (document.getElementById("${activeTab}")){
            switchTab("${activeTab}");
        }
    </c:if>

    <c:if test="${empty activeTab}">
        var cfgAtiveTab = catchEmpty("${configMap["activeTab"]}");
        if(typeof cfgAtiveTab === 'undefined' || !cfgAtiveTab) {
            cfgAtiveTab = "themas";
        }

        switchTab(cfgAtiveTab);
    </c:if>

        var panelBelowCollapsed = false;
        var panelLeftCollapsed = !showLeftPanel;
        var panelRightCollapsed = false;
        function panelResize(dir)
        {
            if(dir === 'left') {
                if($j('#content_viewer').hasClass('tablinks_open')) $j('#content_viewer').removeClass('tablinks_open').addClass('tablinks_dicht');
                else $j('#content_viewer').addClass('tablinks_open').removeClass('tablinks_dicht');
            }
            if(dir === 'right') {
                if($j('#content_viewer').hasClass('tabrechts_open')) $j('#content_viewer').removeClass('tabrechts_open').addClass('tabrechts_dicht');
                else $j('#content_viewer').addClass('tabrechts_open').removeClass('tabrechts_dicht');
            }
            if(dir === 'below') {
                if($j('#content_viewer').hasClass('dataframe_open')) $j('#content_viewer').removeClass('dataframe_open').addClass('dataframe_dicht');
                else $j('#content_viewer').addClass('dataframe_open').removeClass('dataframe_dicht');
            }
        }
        var expandNodes=null;

    <c:if test="${not empty expandNodes}">
        expandNodes=${expandNodes};
    </c:if>

        if(expandNodes!=null){
            for (var i=0; i < expandNodes.length; i++){
                messagePopup("", expandNodes[i], "information");
                treeview_expandItemChildren("layermaindiv","c"+expandNodes[i]);
            }
        }

        function hideLoadingScreen() {
            $j("#loadingscreen").hide();
        }

        /* Laadscherm na 60 seconden zelf weghalen
         * Hij zou weg moeten gaan in onAllLayersFinishedLoading in viewer.js
         */
        if (waitUntillFullyLoaded) {
            var hideScreen = setTimeout("hideLoadingScreen();", 60000);
        }
</script>

<script type="text/javascript" src="scripts/zoeker.js"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/GPSComponent.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/EditComponent.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/MaatregelComponent.js"/>"></script>
<script type="text/javascript">
    /* Weghalen als viewer.jsp klaar is */
    if (!waitUntillFullyLoaded) {
        $j(document).ready(function(){
            $j("#loadingscreen").hide();
        });
    }
</script>

<div id="dialog-download-metadata" title="Kaartlaag opties" style="display: none;">
    <p>
        <span class="ui-icon ui-icon-info" style="float:left; margin:0 7px 20px 0;"></span>
        U heeft voor deze kaartlaag de volgende keuzes.
    </p>
</div>

<div id="dialog-wmsservice-url" title="Kopieer WMS Service url" style="display: none;">
    <p>
        <span class="ui-icon ui-icon-info" style="float:left; margin:0 7px 20px 0;"></span>
        Hieronder de url naar de achterliggende WMS service. U kunt deze in uw eigen
        GIS omgeving gebruiken om de lagen te bekijken.
    </p>
    <p>
        <input type="text" class="input_wmsserviceurl" id="input_wmsserviceurl" name="input_wmsserviceurl" value="" />
    </p>    
</div>

<div id="embedded_icons" style="display: none;">
    <div class="embedded_icon">
        <html:link page="/help.do?id=${kaartid}" target="_blank" module="">
            <img src="<html:rewrite page="/images/help.png"/>" alt="Help" title="Help" border="0" />
        </html:link>
    </div>

    <div class="embedded_icon">
        <a href="#" onclick="getLatLonForGoogleMaps();">
            <img src="<html:rewrite page="/images/google_maps.png"/>" alt="Toon Google Map van de kaart" title="Toon Google Map van de kaart" border="0" />
        </a>
    </div>

    <div class="embedded_icon">
        <a href="#" onclick="getBookMark();">
            <img src="<html:rewrite page="/images/bookmark.png"/>" alt="Bookmark de kaart" title="Bookmark de kaart" border="0" />
        </a>
    </div>

    <div class="embedded_icon">
        <a href="mailto:support@b3partners.nl">
            <img src="<html:rewrite page="/images/email.png"/>" alt="Stuur een e-mail naar de beheerder" title="Stuur een e-mail naar de beheerder" border="0" />
        </a>
    </div>

    <div class="embedded_icon">
        <%--
        <html:link page="/viewer.do?appCode=${appCode}&amp;accessibility=1" target="_new" styleClass="${stijlklasse}" module="">
            <img src="<html:rewrite page="/images/search_list.png"/>" alt="Zoeken met lijsten" title="Zoeken met lijsten" border="0" />
        </html:link>
        --%>
    </div>
</div>
