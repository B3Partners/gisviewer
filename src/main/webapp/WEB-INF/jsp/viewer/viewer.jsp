<noscript>
<meta http-equiv="refresh" content="0; url=viewer.do?appCode=${bookmarkAppcode}&amp;cmsPageId=${cmsPageId}" />
</noscript>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/engine.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/interface/EditUtil.js?v=${JS_VERSION}'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/interface/JZoeker.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/interface/JZoekconfiguratieThemaUtil.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/interface/JEditFeature.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/interface/JMaatregelService.js?v=${JS_VERSION}'></script>
<script type='text/javascript' src='dwr/util.js?v=${JS_VERSION}'></script>

<script type="text/javascript">

    function getValue(configValue) {
        return configValue;
    }

    function checkValidity(configValue) {
        if (typeof configValue === 'undefined' || configValue === '') {
            return false;
        }
        return true;
    }

    function defaultTrue(configValue) {
        if (typeof configValue === 'undefined' || configValue === '') {
            return true;
        }

        return configValue;
    }

    function defaultFalse(configValue) {
        if (typeof configValue === 'undefined' || configValue === '') {
            return false;
        }
        return configValue;
    }

    <%-- om dubbel ophalen te voorkomen voor check 
     checkValidity(zcs) ? zcs :
    --%>
    var zzcs = getValue(${zoekconfiguraties});
    if (typeof zzcs === 'undefined' || !zzcs) {
        zzcs = [{}];
    }
    var ltree = getValue(${tree});
    if (typeof ltree === 'undefined' || !ltree) {
        ltree = null;
    }

    B3PGissuite.config = {
        'showDebugContent': false,
        'waitUntillFullyLoaded': false,
        'baseNameViewer': "${contextPath}",
        'user': {
            'ingelogdeGebruiker': "<c:out value='${pageContext.request.remoteUser}'/>",
            'beheerder': <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>,
            'organisatiebeheerder': <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>,
            'themabeheerder': <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>,
            'gebruiker': <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>,
            'demogebruiker': <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>
        },
        'userRoles': checkValidity(${userRoles}) ? getValue(${userRoles}) : [],
        'sldServletUrl': window.location.protocol + "//" + window.location.host + "<html:rewrite page='/CreateSLD'/>",
        'zoekconfiguraties': zzcs,
        'kburl': "${kburl}",
        'kbcode': "${kbcode}",
        'themaTree': ltree,
        'serviceTrees': checkValidity(${servicesTrees}) ? ${servicesTrees} : [],
        'treeOrder': checkValidity("${configMap["treeOrder"]}") ? "${configMap["treeOrder"]}" : "",
        'organizationcode': "${organizationcode}",
        'fullbbox': '${fullExtent}',
        'bbox': '${extent}',
        /* Applicatie extent */
        'appExtent': checkValidity("${configMap["extent"]}") ? "${configMap["extent"]}" : "12000,304000,280000,620000",
        'fullExtent': checkValidity("${configMap["fullextent"]}") ? "${configMap["fullextent"]}" : "",
        // Resolution
        'resolution': checkValidity("${resolution}") ? "${resolution}" : "",
        'tilingResolutions': checkValidity("${configMap["tilingResolutions"]}") ? "${configMap["tilingResolutions"]}" : "",
        /* init search */
        'searchConfigId': '${searchConfigId}',
        'search': '${search}',
        /* search with sld result (searchAction: filter or highlight and zoom) */
        'searchAction': '${searchAction}',
        'searchId': '${searchId}',
        'searchClusterId': '${searchClusterId}',
        'searchSldVisibleValue': '${searchSldVisibleValue}',
        /* Viewer type */
        'viewerType': checkValidity("${configMap["viewerType"]}") ? "${configMap["viewerType"]}" : "flamingo",
        /* Viewer type */
        'viewerTemplate': checkValidity("${configMap["viewerTemplate"]}") ? "${configMap["viewerTemplate"]}" : "standalone",
        /* ObjectInfo type */
        'objectInfoType': checkValidity("${configMap["objectInfoType"]}") ? "${configMap["objectInfoType"]}" : "popup",
        /* Variable op true zetten als er gebruik wordt gemaakt van uitschuifbare panelen */
        'usePanelControls': defaultTrue(${configMap["usePanelControls"]}),
        /* True als de admin- of metadata in een popup wordt getoond
         * False als deze onder de kaart moet worden getoond
         * dataframepopupHandle wordt gebruikt wanneer de data in een popup wordt getoond */
        'useDivPopup': defaultFalse(${configMap["useDivPopup"]}),
        'usePopup': false,
        'usePanel': false,
        'useBalloonPopup': false,
        // Use cookies
        'useCookies': defaultTrue(${configMap["useCookies"]}),
        /* True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
         * False als je maximaal van 1 thema data kan ophalen. (radiobuttons) */
        'multipleActiveThemas': defaultTrue(${configMap["multipleActiveThemas"]}),
        /* Deze waarde wordt gebruikt om de admindata automatisch door te sturen op het moment dat er maar
         * 1 regel en 1 thema aan admindata is. De waarde is voor het aantal kollomen dat weergegeven moet
         * worden om automatisch door te sturen. (bijv: Als de kollomen id, naam, link zijn moet er 3 staan
         * als de admindata automatisch moeten worden doorgestuurd) */
        'autoRedirect': checkValidity(${configMap["autoRedirect"]}) ? getValue(${configMap["autoRedirect"]}) : 2,
        /* Het aantal pixels dat moet worden gebruikt als er ergens in de kaart is geklikt
         * en info wordt opgevraagd. Dus een tolerantie. */
        'tolerance': checkValidity(${configMap["tolerance"]}) ? getValue(${configMap["tolerance"]}) : 1,
        /* Bepaalt of legend afbeeldingen ook in de kaartlagen tree zichtbaar kunnen worden gemaakt. */
        'showLegendInTree': defaultTrue(${configMap["showLegendInTree"]}),
        /* Bepaalt of ouder clusters allemaal aangevinkt moeten staan voordat
         * kaartlaag zichtbaar is in viewer. Default op true */
        'useInheritCheckbox': defaultTrue(${configMap["useInheritCheckbox"]}),
        /*
         * True als het mogelijk moet zijn om de volgorde van de layers te slepen met de muis
         * de kaart wordt na het slepen automatisch herladen na x aantal (instellen door layerDelay) seconden
         * de buttons Omhoog, Omlaag, Herladen zijn niet zichtbaar
         * 
         * False als de volgorde alleen bepaald moet kunnen worden door de buttons Omhoog en Omlaag */
        'useSortableFunction': defaultTrue(${configMap["useSortableFunction"]}),
        // instellen in ms, dus 5000 voor 5 seconden
        'layerDelay': checkValidity(${configMap["layerDelay"]}) ? getValue(${configMap["layerDelay"]}) : 5000,
        /* de vertraging voor het refreshen van de kaart. */
        'refreshDelay': checkValidity(${configMap["refreshDelay"]}) ? getValue(${configMap["refreshDelay"]}) : 100,
        /*
         * Geef hier de zoekconfigs op die zichtbaar moeten zijn (moet later in een tabel en dan in de action alleen
         * die configuraties ophalen die in de settings tabel staan. Dus deze param weg (+ bijhorende functie).
         * Voor alles wat weg moet staat: ZOEKCONFIGURATIEWEG (even zoeken op dus) */
        'zoekConfigIds': checkValidity(${configMap["zoekConfigIds"]}) ? getValue(${configMap["zoekConfigIds"]}) : "",
        /* Voorzieningen */
        'voorzieningConfigIds': checkValidity(${configMap["voorzieningConfigIds"]}) ? getValue(${configMap["voorzieningConfigIds"]}) : "",
        'voorzieningConfigStraal': checkValidity(${configMap["voorzieningConfigStraal"]}) ? getValue(${configMap["voorzieningConfigStraal"]}) : "",
        'voorzieningConfigTypes': checkValidity(${configMap["voorzieningConfigTypes"]}) ? getValue(${configMap["voorzieningConfigTypes"]}) : "",
        /* Vergunningen */
        'vergunningConfigIds': checkValidity(${configMap["vergunningConfigIds"]}) ? getValue(${configMap["vergunningConfigIds"]}) : "",
        'vergunningConfigStraal': checkValidity(${configMap["vergunningConfigStraal"]}) ? getValue(${configMap["vergunningConfigStraal"]}) : "",
        /*
         * De minimale groote van een bbox van een gezocht object. Als de bbox kleiner is wordt deze vergroot tot de
         * hier gegeven waarde. Dit om zoeken op punten mogelijk te maken. */
        'minBboxZoeken': checkValidity(${configMap["minBboxZoeken"]}) ? getValue(${configMap["minBboxZoeken"]}) : 1000,
        /* Maximaal aantal zoekresultaten */
        'maxResults': checkValidity(${configMap["maxResults"]}) ? getValue(${configMap["maxResults"]}) : 25,
        /* Gebruiker wisselt tabbladen door er met de muis overheen te gaan. Indien false
         * dan zijn de tabbladen te wisselen door te klikken */
        'useMouseOverTabs': defaultTrue(${configMap["useMouseOverTabs"]}),
        // Tree expand all
        'expandAll': defaultFalse(${configMap["expandAll"]}),
        'enabledtabs': [${configMap["tabs"]}],
        'enabledtabsLeft': [${configMap["tabsLeft"]}],
        /* planselectie gebruikt 2 zoekingangen (id's) */
        'planSelectieIds': checkValidity(${configMap["planSelectieIds"]}) ? getValue(${configMap["planSelectieIds"]}) : "0,0",
        /* Buttons boven viewer aan / uit */
        'showRedliningTools': defaultFalse(${configMap["showRedliningTools"]}),
        'showBufferTool': defaultFalse(${configMap["showBufferTool"]}),
        'showSelectBulkTool': defaultFalse(${configMap["showSelectBulkTool"]}),
        'showNeedleTool': defaultFalse(${configMap["showNeedleTool"]}),
        'showPrintTool': defaultFalse(${configMap["showPrintTool"]}),
        'showLayerSelectionTool': defaultFalse(${configMap["showLayerSelectionTool"]}),
        'showGPSTool': defaultFalse(${configMap["showGPSTool"]}),
        'showXYTool': defaultFalse(${configMap["showXYTool"]}),
        'showEditTool': defaultFalse(${configMap["showEditTool"]}),
        'gpsBuffer': checkValidity(${configMap["gpsBuffer"]}) ? getValue(${configMap["gpsBuffer"]}) : 1000,
        'layerGrouping': checkValidity("${configMap["layerGrouping"]}") ? "${configMap["layerGrouping"]}" : "lg_forebackground",
        'popupWidth': checkValidity("${configMap["popupWidth"]}") ? "${configMap["popupWidth"]}" : "90%",
        'popupHeight': checkValidity("${configMap["popupHeight"]}") ? "${configMap["popupHeight"]}" : "20%",
        'popupLeft': checkValidity("${configMap["popupLeft"]}") ? "${configMap["popupLeft"]}" : "5%",
        'popupTop': checkValidity("${configMap["popupTop"]}") ? "${configMap["popupTop"]}" : "75%",
        'bookmarkAppcode': checkValidity("${bookmarkAppcode}") ? "${bookmarkAppcode}" : "",
        'tekstBlokken': checkValidity(${tekstBlokken}) ? getValue(${tekstBlokken}) : [],
        'datasetDownload': defaultFalse(${configMap["datasetDownload"]}),
        'showServiceUrl': defaultFalse(${configMap["showServiceUrl"]}),
        'startLocationX': checkValidity(${startLocationX}) ? getValue(${startLocationX}) : "",
        'startLocationY': checkValidity(${startLocationY}) ? getValue(${startLocationY}) : "",
        'cfgActiveTab': checkValidity('${configMap["activeTab"]}') ? '${configMap["activeTab"]}' : "themas",
        'cfgActiveTabLeft': checkValidity('${configMap["activeTabLeft"]}') ? '${configMap["activeTabLeft"]}' : null,
        'tabWidth': checkValidity('${configMap["tabWidth"]}') ? '${configMap["tabWidth"]}' : "288",
        'tabWidthLeft': checkValidity('${configMap["tabWidthLeft"]}') ? '${configMap["tabWidthLeft"]}' : "288",
        'dataframehoogte': checkValidity('${configMap["defaultdataframehoogte"]}') ? ${configMap["defaultdataframehoogte"]} : "150",
        'showInfoTab': checkValidity('${configMap["showInfoTab"]}') ? '${configMap["showInfoTab"]}' : null,
        'cmsPageId': checkValidity('${cmsPageId}') ? '${cmsPageId}' : '',
        'theme': checkValidity('${theme}') ? '${theme}' : '',
        'helpUrl': checkValidity('${configMap["helpUrl"]}') ? '${configMap["helpUrl"]}' : null,
        'showGoogleMapsIcon': defaultFalse(${configMap["showGoogleMapsIcon"]}),
        'showBookmarkIcon': defaultFalse(${configMap["showBookmarkIcon"]}),
        'contactUrl': checkValidity('${configMap["contactUrl"]}') ? '${configMap["contactUrl"]}' : null,
        'tekenKaartlaagId': checkValidity('${configMap["tekenKaartlaagId"]}') ? '${configMap["tekenKaartlaagId"]}' : null,
        'tekenFilterColumn': checkValidity('${configMap["tekenFilterColumn"]}') ? '${configMap["tekenFilterColumn"]}' : null,
        'zoekenAutoIdentify': defaultTrue(${configMap["zoekenAutoIdentify"]}),
        'useOwnCyclomedia' : defaultFalse(${configMap["useOwnCyclomedia"]}),
        'ownCyclomediaUrl' :checkValidity('${configMap["ownCyclomediaUrl"]}') ?'${configMap["ownCyclomediaUrl"]}' :null
    };

    /* If B3PGissuite.config.viewerType == flamingo, check for Flash -> If no Flash installed choose OpenLayers */
    if (B3PGissuite.config.viewerType === 'flamingo') {
        var flashVersion = B3PGissuite.commons.flashCheck().pv;
        if (flashVersion[0] === 0) {
            B3PGissuite.config.viewerType = 'openlayers';
        }
    }
    if (B3PGissuite.config.objectInfoType === "geen") {
        B3PGissuite.config.usePopup = false;
        B3PGissuite.config.usePanel = false;
        B3PGissuite.config.usePanelControls = false;
        B3PGissuite.config.useDivPopup = false;
        B3PGissuite.config.useBalloonPopup = false;
    }
    if (B3PGissuite.config.objectInfoType === "popup") {
        B3PGissuite.config.usePopup = true;
        B3PGissuite.config.usePanel = false;
        B3PGissuite.config.usePanelControls = false;
        B3PGissuite.config.useDivPopup = true;
        B3PGissuite.config.useBalloonPopup = false;
    }
    if (B3PGissuite.config.objectInfoType === "paneel") {
        B3PGissuite.config.usePopup = false;
        B3PGissuite.config.usePanel = true;
        B3PGissuite.config.useDivPopup = false;
        B3PGissuite.config.useBalloonPopup = false;
    }
    if (B3PGissuite.config.objectInfoType === "balloon") {
        B3PGissuite.config.usePopup = false;
        B3PGissuite.config.usePanel = false;
        B3PGissuite.config.usePanelControls = false;
        B3PGissuite.config.useDivPopup = false;
        B3PGissuite.config.useBalloonPopup = true;
    }

    /* 
     * Definitie beschikbare tabbladen.
     */
    B3PGissuite.config.tabbladen = {
        "themas": {"id": "themas", "contentid": "treevak", "name": "Kaarten", "class": "TreeTabComponent", 'options': {'tree': B3PGissuite.config.themaTree, 'servicestrees': B3PGissuite.config.serviceTrees, 'expandAll': B3PGissuite.config.expandAll}},
        "zoeken": {"id": "zoeken", "contentid": "infovak", "name": "Zoeken", "class": "SearchTabComponent", "options": {"hasSearch": (B3PGissuite.config.search !== ''), "hasA11yStartWkt": ${!empty a11yStartWkt}}},
        "gebieden": {"id": "gebieden", "contentid": "objectframeViewer", "name": "Gebieden", "class": "IframeTabComponent", 'options': {'src': 'empty_iframe.jsp'}},
        "analyse": {"id": "analyse", "contentid": "analyseframeViewer", "name": "Analyse", "class": "AnalyseTabComponent" },
        "legenda": {"id": "legenda", "contentid": "volgordevak", "name": "Legenda", "class": "LegendTabComponent", 'options': {'useSortableFunction': B3PGissuite.config.useSortableFunction, 'layerDelay': B3PGissuite.config.layerDelay}},
        //"informatie": { "id": "informatie", "contentid": "beschrijvingVakViewer", "name": "Informatie", "class": "IframeTabComponent", 'options': { 'src': 'empty_iframe.jsp' } },
        "planselectie": {"id": "planselectie", "contentid": "plannenzoeker", "name": "Planselectie", "class": "PlanSelectionTabComponent"},
        "meldingen": {"id": "meldingen", "contentid": "meldingenframeViewer", "name": "Melding", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewermeldingen.do?prepareMelding=t'}},
        // "voorzieningen": { "id": "voorzieningen", "contentid": "voorzieningframeZoeker", "name": "Voorziening", "class": "IframeTabComponent", 'options': { 'src': '/gisviewer/zoekVoorziening.do' } },
        // "vergunningen": { "id": "vergunningen", "contentid": "vergunningframeZoeker", "name": "Vergunning", "class": "IframeTabComponent", 'options': { 'src': '/gisviewer/zoekVergunning.do' } },
        "redlining": {"id": "redlining", "contentid": "redliningframeViewer", "name": "Redlining", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewerredlining.do?prepareRedlining=t'}},
        // "cms": {id: "cms", contentid: "cmsvak", name: "Extra", "class": "CMSTabComponent", 'options': { 'tekstBlokken': B3PGissuite.config.tekstBlokken } },
        "bag": {id: "bag", contentid: "bagframeViewer", name: "BAG", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewerbag.do'}},
        "wkt": {id: "wkt", contentid: "wktframeViewer", name: "WKT", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewerwkt.do'}},
        "transparantie": {id: "transparantie", contentid: "transparantieframeViewer", name: "Transparantie", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewertransparantie.do'}},
        "tekenen": {id: "tekenen", contentid: "tekenenframeViewer", name: "Tekenen", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/viewerteken.do'}},
        "uploadpoints": {"id": "uploadpoints", "contentid": "uploadtemppointsframeViewer", "name": "Upload Points", "class": "IframeTabComponent", 'options': {'src': '/gisviewer/uploadtemppoints.do'}},
        "layerinfo": {"id": "layerinfo", "name": "Laag informatie", "class": "LayerInfoTabComponent", 'options': {}},
        "externeinformatie":  {id: "externeinformatie", contentid: "verkeersmonitorframeViewer", name: "Verkeersmonitor", "class": "VerkeersmonitorComponent", 'options': {'src': '/visweb?id=123'}},
        "verkeersmonitor1":  {id: "verkeersmonitor1", contentid: "verkeersmonitorframeViewer", name: "Verkeersmonitor", "class": "IframeTabComponent", 'options': {'src': '/visweb?id=123'}},
        "verkeersmonitor2":  {id: "verkeersmonitor2", contentid: "verkeersmonitorframeViewer", name: "Verkeersmonitor", "class": "IframeTabComponent", 'options': {'src': '/visweb?id=123'}},
        "verkeersmonitor3":  {id: "verkeersmonitor3", contentid: "verkeersmonitorframeViewer", name: "Verkeersmonitor", "class": "IframeTabComponent", 'options': {'src': '/visweb?id=123'}}
    };

    var imageBaseUrl = "<html:rewrite page="/images/"/>";
</script>

<c:choose>
    <c:when test="${not empty param.debug}">
        <!-- common -->
        <script type="text/javascript" src="<html:rewrite page="/scripts/lib/swfobject.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/lib/proj4js-compressed.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/viewer.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/MaatregelComponent.js?v=${JS_VERSION}"/>"></script>
        <!-- openlayers -->
        <script type="text/javascript" src="<html:rewrite page="/scripts/openlayers/lib/OpenLayers.js?v=${JS_VERSION}"/>"></script>
        <!-- webmapcontrollers -->
        <script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/Controller.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/FlamingoController.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/OpenLayersController.js?v=${JS_VERSION}"/>"></script>
        <!-- components -->
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/BaseComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/ViewerComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/Search.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/Layout.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/Balloon.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/Edit.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/GPS.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/TabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/IframeTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/TreeTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/LegendTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/PlanSelectionTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/SearchTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/CMSTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/LayerInfoTabComponent.js?v=${JS_VERSION}"/>"></script>
        <script type="text/javascript" src="<html:rewrite page="/scripts/components/tabcomponents/AnalyseTabComponent.js?v=${JS_VERSION}"/>"></script>
    </c:when>
    <c:otherwise>
        <!-- Total (minified) viewer JS -->
        <script type="text/javascript" src="<html:rewrite page="/scripts/viewer-min.js?v=${JS_VERSION}"/>"></script>
    </c:otherwise>
</c:choose>
<jsp:include page="/WEB-INF/jsp/viewer/viewerscripts.jsp" />

<div style="display: none;">
    <html:form action="/viewerdata?code=${kbcode}&cmsPageId=${cmsPageId}">
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

<div id="mapcontent"><div id="flashmelding"></div></div>
<script type="text/javascript">
    if (B3PGissuite.config.viewerType === 'flamingo') {
        setTimeout(function() {
            $j("#flashmelding").html('<strong class="noflamingoerror"><br/><br/><br/><br/><br/>U heeft de Flash plugin nodig om de kaart te kunnen zien.<br/>Deze kunt u <a href="http://get.adobe.com/flashplayer/" target="_blank">hier</a> gratis downloaden.</strong>');
        }, 2000);
    }
</script>

<div id="tabjes"><ul id="nav" class="tabsul"></ul></div>
<div id="tab_container"></div>
<div id="css_props"></div>

<script type="text/javascript">
    (function() {
    <c:if test="${not empty param.debug}">B3PGissuite.commons.setDebug(true);</c:if>
            /**
             * Start off with initMapComponent()
             */
            B3PGissuite.viewerComponent = B3PGissuite.createComponent('ViewerComponent', {viewerType: B3PGissuite.config.viewerType});
            B3PGissuite.viewerComponent.initMapComponent();
            B3PGissuite.commons.attachTransitionListener($j("#mapcontent")[0], function() {
                B3PGissuite.viewerComponent.updateSizeOL();
            });
            // Init CSS properties for configured tab width
            B3PGissuite.get('Layout').configurePanelSizes();
            B3PGissuite.get('Layout').prepareTabs();
            // Init tab controllers
            var rightTabComponent = B3PGissuite.createComponent('TabComponent', {
                direction: 'right',
                labelContainer: 'tabjes',
                tabContainer: 'tab_container',
                useClick: !B3PGissuite.config.useMouseOverTabs,
                useHover: B3PGissuite.config.useMouseOverTabs,
                defaultTab: B3PGissuite.config.cfgActiveTab,
                enabledTabs: B3PGissuite.config.enabledtabs
            });
            var leftTabComponent = B3PGissuite.createComponent('TabComponent', {
                direction: 'left',
                labelContainer: 'leftcontenttabjes',
                tabContainer: 'leftcontent',
                useClick: !B3PGissuite.config.useMouseOverTabs,
                useHover: B3PGissuite.config.useMouseOverTabs,
                defaultTab: B3PGissuite.config.cfgActiveTabLeft,
                enabledTabs: B3PGissuite.config.enabledtabsLeft
            });
            // Set tabcomponents to layoutmanager
            B3PGissuite.get('Layout').setTabComponents(rightTabComponent, leftTabComponent);
            // Build the layout (admindatadiv, panelcontrols etc)
            // Argument is the html-element which is used to add after
            B3PGissuite.get('Layout').createLayout($j('#css_props'));
            // Hide loading screen
            B3PGissuite.get('Layout').initHideLoadingScreen();

    <c:if test="${not empty expandNodes}">
            (function() {
                var treeComponent = B3PGissuite.get('TreeTabComponent'),
                        expandNodes =${expandNodes};
                if (treeComponent !== null && expandNodes !== null) {
                    treeComponent.expandNodes(expandNodes);
                }
            }());
    </c:if>
        }());
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

    <c:set var="helpUrl" value="${configMap['helpUrl']}"/>
    <c:set var="showGoogleMapsIcon" value="${configMap['showGoogleMapsIcon']}"/>
    <c:set var="showBookmarkIcon" value="${configMap['showBookmarkIcon']}"/>
    <c:set var="contactUrl" value="${configMap['contactUrl']}"/>

    <c:if test="${! empty helpUrl}">
        <div class="embedded_icon">
            <html:link page="${helpUrl}" target="_blank" module="">
                <img src="<html:rewrite page="/images/help.png"/>" alt="Help" title="Help" border="0" />
            </html:link>
        </div>
    </c:if>

    <c:if test="${showGoogleMapsIcon}">
        <div class="embedded_icon">
            <a href="#" class="getLatLonForGoogleMaps">
                <img src="<html:rewrite page="/images/google_maps.png"/>" alt="Toon Google Map van de kaart" title="Toon Google Map van de kaart" border="0" />
            </a>
        </div>
    </c:if>

    <c:if test="${showBookmarkIcon}">
        <div class="embedded_icon">
            <a href="#" class="getBookmark">
                <img src="<html:rewrite page="/images/bookmark.png"/>" alt="Bookmark de kaart" title="Bookmark de kaart" border="0" />
            </a>
        </div>
    </c:if>

    <c:if test="${!empty contactUrl}">
        <div class="embedded_icon">
            <a href="mailto:${contactUrl}">
                <img src="<html:rewrite page="/images/email.png"/>" alt="${contactUrl}" title="${contactUrl}" />
            </a>
        </div>
    </c:if>
    <%-- 
    <div class="embedded_icon">    
        <html:link page="/viewer.do?appCode=${appCode}&amp;accessibility=1" target="_new" styleClass="${stijlklasse}" module="">
            <img src="<html:rewrite page="/images/search_list.png"/>" alt="Zoeken met lijsten" title="Zoeken met lijsten" border="0" />
        </html:link>    
    </div>
    --%>
</div>
