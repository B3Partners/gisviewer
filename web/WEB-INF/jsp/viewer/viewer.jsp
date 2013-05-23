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
    
    function catchEmpty(defval, emptyvalue){
        return defval || emptyvalue;
    }

    var beheerder = <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>;
    var organisatiebeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>;
    var themabeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>;
    var gebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>;
    var demogebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>;
    var anoniem= !beheerder && !organisatiebeheerder && !themabeheerder && !gebruiker && !demogebruiker;
    
    var sldServletUrl=window.location.protocol + "//" +  window.location.host +"<html:rewrite page='/CreateSLD'/>";

    var zoekconfiguraties = catchEmpty(${zoekconfiguraties}, [{}]);

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
    var appExtent = catchEmpty("${configMap["extent"]}", "12000,304000,280000,620000");
    // Resolution
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
    var viewerType = catchEmpty("${configMap["viewerType"]}", "flamingo");
    /* If viewerType == flamingo, check for Flash -> If no Flash installed choose OpenLayers */
    if(viewerType === 'flamingo') {
        var flashVersion = ua().pv;
        if(flashVersion[0] === 0) {
            viewerType = 'openlayers';
        }
    }
    /* Viewer type */
    var viewerTemplate = catchEmpty("${configMap["viewerTemplate"]}", "standalone");
    /* ObjectInfo type */
    var objectInfoType = catchEmpty("${configMap["objectInfoType"]}", "popup");
    /* Variable op true zetten als er gebruik wordt gemaakt van uitschuifbare panelen */
    var usePanelControls=catchEmpty(${configMap["usePanelControls"]}, true);
    /* True als de admin- of metadata in een popup wordt getoond
     * False als deze onder de kaart moet worden getoond
     * dataframepopupHandle wordt gebruikt wanneer de data in een popup wordt getoond */
    var useDivPopup=catchEmpty(${configMap["useDivPopup"]}, false);

    if(objectInfoType === "geen") {
        usePopup = false;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = false;
        useBalloonPopup=false;
    }
    if(objectInfoType === "popup") {
        usePopup = true;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = true;
        useBalloonPopup=false;
    }
    if(objectInfoType === "paneel") {
        usePopup = false;
        usePanel = true;
        useDivPopup = false;
        useBalloonPopup=false;
    }
    if (objectInfoType === "balloon"){
        usePopup=false;
        usePanel = false;
        usePanelControls =  false;
        useDivPopup = false;
        useBalloonPopup=true;
    }
    var dataframepopupHandle = null;
    // Use cookies
    var useCookies=catchEmpty(${configMap["useCookies"]}, true);
    /* True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
     * False als je maximaal van 1 thema data kan ophalen. (radiobuttons) */
    var multipleActiveThemas=catchEmpty(${configMap["multipleActiveThemas"]}, true);
    /* Deze waarde wordt gebruikt om de admindata automatisch door te sturen op het moment dat er maar
     * 1 regel en 1 thema aan admindata is. De waarde is voor het aantal kollomen dat weergegeven moet
     * worden om automatisch door te sturen. (bijv: Als de kollomen id, naam, link zijn moet er 3 staan
     * als de admindata automatisch moeten worden doorgestuurd) */
    var autoRedirect=catchEmpty(${configMap["autoRedirect"]}, 2);
    /* Het aantal pixels dat moet worden gebruikt als er ergens in de kaart is geklikt
     * en info wordt opgevraagd. Dus een tolerantie. */
    var tolerance=catchEmpty(${configMap["tolerance"]}, 1);
    /* Bepaalt of legend afbeeldingen ook in de kaartlagen tree zichtbaar kunnen worden gemaakt. */
    var showLegendInTree = catchEmpty(${configMap["showLegendInTree"]}, true);
    /* Bepaalt of ouder clusters allemaal aangevinkt moeten staan voordat
     * kaartlaag zichtbaar is in viewer. Default op true */
    var useInheritCheckbox = catchEmpty(${configMap["useInheritCheckbox"]}, true);
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
    var useSortableFunction=catchEmpty(${configMap["useSortableFunction"]}, false);
    // instellen in ms, dus 5000 voor 5 seconden
    var layerDelay = catchEmpty(${configMap["layerDelay"]}, 5000);
    /* de vertraging voor het refreshen van de kaart. */
    var refreshDelay=catchEmpty(${configMap["refreshDelay"]}, 100);
    /*
     * Geef hier de zoekconfigs op die zichtbaar moeten zijn (moet later in een tabel en dan in de action alleen
     * die configuraties ophalen die in de settings tabel staan. Dus deze param weg (+ bijhorende functie).
     * Voor alles wat weg moet staat: ZOEKCONFIGURATIEWEG (even zoeken op dus) */
    var zoekConfigIds = catchEmpty(${configMap["zoekConfigIds"]}, "");
    /* Voorzieningen */
    var voorzieningConfigIds = catchEmpty(${configMap["voorzieningConfigIds"]}, "");
    var voorzieningConfigStraal = catchEmpty(${configMap["voorzieningConfigStraal"]}, "");
    var voorzieningConfigTypes = catchEmpty(${configMap["voorzieningConfigTypes"]}, "");
    /* Vergunningen */
    var vergunningConfigIds = catchEmpty(${configMap["vergunningConfigIds"]}, "");
    var vergunningConfigStraal = catchEmpty(${configMap["vergunningConfigStraal"]}, "");
    /*
     * De minimale groote van een bbox van een gezocht object. Als de bbox kleiner is wordt deze vergroot tot de
     * hier gegeven waarde. Dit om zoeken op punten mogelijk te maken. */
    var minBboxZoeken=catchEmpty(${configMap["minBboxZoeken"]}, 1000);
    /* Maximaal aantal zoekresultaten */
    var maxResults=catchEmpty(${configMap["maxResults"]}, 25);
    /* Gebruiker wisselt tabbladen door er met de muis overheen te gaan. Indien false
     * dan zijn de tabbladen te wisselen door te klikken */
    var useMouseOverTabs = catchEmpty(${configMap["useMouseOverTabs"]}, true);
    // Tree expand all
    var expandAll=catchEmpty(${configMap["expandAll"]}, false);
    /* TODO: voorzieningen en vergunning even uitgecomment deze geven
     * document.getElementById(tabobj.contentid).style.display = 'none'; is null
     * als de iframes uitstaan en ze wel in de var tabbladen aanstaan.

     * De beschikbare tabbladen. Het ID van de tab, de bijbehoorden Content-div,
     * de naam en eventueel extra Content-divs die geopend moeten worden */
    var tabbladen = {
        "themas": { "id": "themas", "contentid": "treevak", "name": "Kaarten", "extracontent": ["layermaindiv"], "class": "TreeComponent", 'options': { 'tree': themaTree, 'servicestrees': ${servicesTrees}, 'expandAll': expandAll } },
        "zoeken": { "id": "zoeken", "contentid": "infovak", "name": "Zoeken", "class": "SearchComponent", "options": { "hasSearch": ${!empty search}, "hasA11yStartWkt": ${!empty a11yStartWkt} } },
        "gebieden": { "id": "gebieden", "contentid": "objectvakViewer", "name": "Gebieden", "class": "IframeComponent", 'options': { 'src': 'empty_iframe.jsp' } },
        "analyse": { "id": "analyse", "contentid": "analysevakViewer", "name": "Analyse", "class": "IframeComponent", 'options': { 'src': '/gisviewer/vieweranalysedata.do' } },
        "legenda": { "id": "legenda", "contentid": "volgordevak", "name": "Legenda", "resizableContent": true, "class": "LegendComponent" },
        "informatie": { "id": "informatie", "contentid": "beschrijvingvak", "name": "Informatie", "class": "IframeComponent", 'options': { 'src': 'empty_iframe.jsp' } },
        "planselectie": { "id": "planselectie", "contentid": "plannenzoeker", "name": "Planselectie", "class": "PlanSelectionComponent" },
        "meldingen": { "id": "meldingen", "contentid": "meldingenvakViewer", "name": "Melding", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewermeldingen.do?prepareMelding=t' } },
        "voorzieningen": { "id": "voorzieningen", "contentid": "voorzieningzoeker", "name": "Voorziening", "class": "IframeComponent", 'options': { 'src': '/gisviewer/zoekVoorziening.do' } },
        "vergunningen": { "id": "vergunningen", "contentid": "vergunningzoeker", "name": "Vergunning", "class": "IframeComponent", 'options': { 'src': '/gisviewer/zoekVergunning.do' } },
        "redlining": { "id": "redlining", "contentid": "redliningvakViewer", "name": "Redlining", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerredlining.do?prepareRedlining=t' } },
        "cms": {id: "cms", contentid: "cmsvak", name: "Extra" },
        "bag": {id: "bag", contentid: "bagvakViewer", name: "BAG", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerbag.do' } },
        "wkt": {id: "wkt", contentid: "wktvakViewer", name: "WKT", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerwkt.do' } },
        "transparantie": {id: "transparantie", contentid: "transparantievakViewer", name: "Transparantie", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewertransparantie.do' } },
        "tekenen" : {id: "tekenen", contentid: "tekenenvakViewer", name: "Tekenen", "class": "IframeComponent", 'options': { 'src': '/gisviewer/viewerteken.do' } },
        "uploadpoints": { "id": "uploadpoints", "contentid": "uploadtemppointsvakViewer", "name": "Upload Points", "class": "IframeComponent", 'options': { 'src': '/gisviewer/uploadtemppoints.do' } }
    };

    var enabledtabs = [${configMap["tabs"]}];
    var enabledtabsLeft = [${configMap["tabsLeft"]}];

    /* planselectie gebruikt 2 zoekingangen (id's) */
    var planSelectieIds = catchEmpty(${configMap["planSelectieIds"]}, "0,0");
    /* Buttons boven viewer aan / uit */
    var showRedliningTools = catchEmpty(${configMap["showRedliningTools"]}, false);
    var showBufferTool = catchEmpty(${configMap["showBufferTool"]}, false);
    var showSelectBulkTool = catchEmpty(${configMap["showSelectBulkTool"]}, false);
    var showNeedleTool = catchEmpty(${configMap["showNeedleTool"]}, false);
    var showPrintTool = catchEmpty(${configMap["showPrintTool"]}, false);
    var showLayerSelectionTool = catchEmpty(${configMap["showLayerSelectionTool"]}, false);
    var showGPSTool = catchEmpty(${configMap["showGPSTool"]}, false);
    var showEditTool = catchEmpty(${configMap["showEditTool"]}, false);
    var gpsBuffer = catchEmpty("${configMap["gpsBuffer"]}", false);
    
    var layerGrouping = catchEmpty("${configMap["layerGrouping"]}", "lg_forebackground");

    var popupWidth = catchEmpty("${configMap["popupWidth"]}", "90%");
    var popupHeight = catchEmpty("${configMap["popupHeight"]}", "20%");
    var popupLeft = catchEmpty("${configMap["popupLeft"]}", "5%");
    var popupTop = catchEmpty("${configMap["popupTop"]}", "75%");

    var bookmarkAppcode = catchEmpty("${bookmarkAppcode}", "");
	
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
    var treeOrder = catchEmpty("${configMap["treeOrder"]}", 'volgorde');
    var useUserWmsDropdown = catchEmpty(${configMap["useUserWmsDropdown"]}, true);
    var datasetDownload = catchEmpty(${configMap["datasetDownload"]}, false);
    var tilingResolutions = catchEmpty("${configMap["tilingResolutions"]}", "");
    var showServiceUrl = catchEmpty(${configMap["showServiceUrl"]}, false);
    var startLocationX = catchEmpty("${startLocationX}", ""); 
    var startLocationY = catchEmpty("${startLocationY}", "");
</script>

<!-- Total (minified) viewer JS -->
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer-min.js"/>"></script>

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
    if(viewerType === 'flamingo') {
        setTimeout(function() {
            $j("#flashmelding").html('<strong class="noflamingoerror"><br/><br/><br/><br/><br/>U heeft de Flash plugin nodig om de kaart te kunnen zien.<br/>Deze kunt u <a href="http://get.adobe.com/flashplayer/" target="_blank">hier</a> gratis downloaden.</strong>');
        }, 2000);
    }
</script>

<div id="tabjes"><ul id="nav" class="tabsul"></ul></div>
<div id="tab_container"></div>

<div id="tabContentContainers" style="display: none;">
    <div id="cmsvak" style="display: none; overflow: auto;" class="tabvak">
        <%-- als er maar 1 tekstblok is dan die titel plaatsen
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

                    <%-- Anders gewoon de tekst tonen van tekstblok
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
         --%>
    </div>
</div>
        
<script type="text/javascript">

    // Show tabs for correct widht calculations
    $j('#content_viewer').addClass('tablinks_open');
    $j('#content_viewer').addClass('tabrechts_open');
    
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
    var tabComponent = B3PGissuite.createComponent('TabComponent', { 'labelContainer': 'tabjes', 'tabContainer': 'tab_container', useClick: !useMouseOverTabs, useHover: useMouseOverTabs });
    var leftTabComponent = B3PGissuite.createComponent('TabComponent', { 'labelContainer': 'leftcontenttabjes', 'tabContainer': 'leftcontent', useClick: !useMouseOverTabs, useHover: useMouseOverTabs });
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
    
    // Hide tabs when there is no content
    if(noLeftTabs === 0) $j('#content_viewer').addClass('tablinks_dicht').removeClass('tablinks_open');
    if(noOfTabs === 0) $j('#content_viewer').addClass('tablinks_dicht').removeClass('tablinks_open');
    // Show infopanel below when set
    if(!usePopup && usePanel) $j('#content_viewer').addClass('dataframe_open');
    
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
