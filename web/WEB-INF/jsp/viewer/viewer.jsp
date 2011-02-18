<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type='text/javascript' src='dwr/interface/EditUtil.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type='text/javascript' src='dwr/interface/JZoeker.js'></script>

<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/cookiefunctions.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/flashdetect.js"/>"></script>

<script type="text/javascript">
    var baseNameViewer = "${contextPath}";
    
    function catchEmpty(defval){
        return defval
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

    /* showLeftPanel op de gewenste tab zetten als het leftPanel moet worden getoond,
     * en op null als het leftPanel niet moet worden getoond */
    
    var showLeftPanel=catchEmpty(${configMap["showLeftPanel"]});
    if(typeof showLeftPanel === 'undefined') {
        showLeftPanel = null;
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
    
    /* TODO: voorzieningen en vergunning even uitgecomment deze geven
     * document.getElementById(tabobj.contentid).style.display = 'none'; is null
     * als de iframes uitstaan en ze wel in de var tabbladen aanstaan.

     * De beschikbare tabbladen. Het ID van de tab, de bijbehoorden Content-div,
     * de naam en eventueel extra Content-divs die geopend moeten worden */
    var tabbladen = {
        "themas": { "id": "themas", "contentid": "treevak", "name": "Kaarten", "extracontent": ["layermaindiv"] },
        "zoeken": { "id": "zoeken", "contentid": "infovak", "name": "Zoeken" },
        "gebieden": { "id": "gebieden", "contentid": "objectvakViewer", "name": "Gebieden" },
        "analyse": { "id": "analyse", "contentid": "analysevakViewer", "name": "Analyse" },
        "legenda": { "id": "legenda", "contentid": "volgordevak", "name": "Legenda", "resizableContent": true },
        "informatie": { "id": "informatie", "contentid": "beschrijvingvak", "name": "Informatie" },
        "planselectie": { "id": "planselectie", "contentid": "plannenzoeker", "name": "Plan selectie" },
        "meldingen": { "id": "meldingen", "contentid": "meldingenvakViewer", "name": "Melding" },
        "voorzieningen": { "id": "voorzieningen", "contentid": "voorzieningzoeker", "name": "Voorziening" },
        "vergunningen": { "id": "vergunningen", "contentid": "vergunningzoeker", "name": "Vergunning" },
        "redlining": { "id": "redlining", "contentid": "redliningvakViewer", "name": "Redlining" },
        "cms": {id: "cms", contentid: "cmsvak", name: "Extra"}
    };

    var enabledtabs = [${configMap["tabs"]}];

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

</script>
<!--[if lte IE 6]>
    <script type="text/javascript">
        attachOnload(fixViewer);
        attachOnresize(fixViewer);
    </script>
<![endif]-->
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/selectbox.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/moveLayers.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer_design.js"/>"></script>

<script type="text/javascript" src="<html:rewrite page="/scripts/niftycube.js"/>"></script>
<div style="display: none;">
    <html:form action="/viewerdata?code=${kbcode}">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="objectdata"/>
        <input type="hidden" name="search"/>
        <input type="hidden" name="searchId"/>
        <input type="hidden" name="searchClusterId"/>
        <input type="hidden" name="withinObject"/>

        <html:hidden property="themaid" />
        <html:hidden property="analysethemaid" />
        <html:hidden property="lagen" />
        <html:hidden property="coords" />
        <html:hidden property="geom" />
        <html:hidden property="scale"/>
        <html:hidden property="tolerance"/>
    </html:form>
</div>

<div id="leftcontent" style="display: none;">
    &nbsp;
</div>

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

<div id="tabjes">
    <ul id="nav">
        <script type="text/javascript">
            var createdTabs = new Array();
            
            var noOfTabs = 0;
            for(i in enabledtabs) {
                var tabid = enabledtabs[i];
                if(showLeftPanel == null || tabid != showLeftPanel) {
                    noOfTabs++;
                }
            }
            if(noOfTabs > 5) noOfTabs = 5;
            var tabswidth = Math.floor((tabWidth - (noOfTabs-1)) / noOfTabs);
            var cloneTabContentId = null;
            for(i in enabledtabs) {
                var tabid = enabledtabs[i];
                var tabobj = eval("tabbladen."+tabid);
                if(showLeftPanel != null && tabid == showLeftPanel) {
                    cloneTabContentId = tabobj.contentid;
                } else {

                    if (useMouseOverTabs)
                        document.write('<li id="' + tabid + '" onmouseover="switchTab(this);"><a href="#" id="' + tabid + 'link" style="width: ' + tabswidth + 'px;">' + tabobj.name + '</a></li>');
                    else
                        document.write('<li id="' + tabid + '" onclick="switchTab(this);"><a href="#" id="' + tabid + 'link" style="width: ' + tabswidth + 'px;">' + tabobj.name + '</a></li>');

                    createdTabs[i] = enabledtabs[i];
                    if(i == 4) break;
                }
            }

            for(i in tabbladen) {             
                var tabid = tabbladen[i].id;
                checkResizableContent(tabid, tabbladen[i].contentid); 
                var tabIsEnabled = false;
                for(j in createdTabs) {
                    var tabide = createdTabs[j];
                    if(tabid == tabide) tabIsEnabled = true;
                }
                if(!tabIsEnabled) {
                    document.write('<li id="' + tabid + '"><a href="#" id="' + tabid + 'link" style="display: none;">' + tabbladen[i].name + '</a></li>');
                }
            }
        </script>
    </ul>
</div>

<div id="tab_container">

    <div id="treevak" style="display: none;" class="tabvak">
        <div>
        <form id="treeForm">
            <div id="layermaindiv" style="display: none;"></div>
        </form></div>
        <div id="timings"></div>
    </div>

    <form id="volgordeForm">
        <div id="volgordevak" style="display: none;" class="tabvak">
            <div>Bepaal de volgorde waarin de kaartlagen getoond worden</div>
            <div id="orderLayerBox" class="orderLayerBox tabvak_groot"></div>
            <div>
                <script type="text/javascript">
                    if(!useSortableFunction) {
                        document.write('<input type="button" value="Omhoog" onclick="javascript: moveSelectedUp()" class="knop" />');
                        document.write('<input type="button" value="Omlaag" onclick="javascript: moveSelectedDown()" class="knop" />');
                        document.write('<input type="button" value="Herladen" onclick="refreshMapVolgorde();" class="knop" />');
                    }
                </script>
            </div>
            <%--input type="button" value="Verwijderen" onclick="deleteAllLayers();" class="knop" /--%>
        </div>
    </form>

    <div id="plannenzoeker" style="display: none; overflow: auto;" class="tabvak">
        <div class="planselectcontainer">
            <!--<a class="toggleLinkActive" id="kopTekst" onclick="return toggle(this, 'kolomTekst');">Plan selectie module</a>-->
            <div id="kolomTekst">
                Eigenaar:
                <select id="eigenaarselect" name="eigenaarselect" onchange="eigenaarchanged(this)" class="planselectbox" size="10" disabled="true">
                    <option value="">Bezig met laden eigenaren</option>
                </select>
                Plan type
                <select id="plantypeselect" name="plantypeselect" size="10" class="planselectbox" onchange="plantypechanged(this)">
                    <option value="">Kies een eigenaar</option>
                </select>
                Plan status
                <select id="statusselect" name="statusselect" size="10" class="planselectbox" onchange="statuschanged(this)">
                    <option value="">Kies een eigenaar</option>
                </select>
                Plan
                <select id="planselect" name="planselect" size="10" class="planselectbox" onchange="planchanged(this)">
                    <option value="">Kies een eigenaar</option>
                </select>
                <div id="selectedPlan">Geen plan geselecteerd</div>
            </div>

        </div>
    </div>

    <div id="infovak" style="display: none; overflow: auto;" class="tabvak">
        <p>
            Kies de Info-tool en klik vervolgens op een punt<br/>
            op de kaart voor administratieve informatie<br/>
            van het object.
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
    
    <div id="voorzieningzoeker" style="display: none;" class="tabvak_with_iframe"><iframe id="voorzieningZoeker" name="voorzieningZoeker" frameborder="0" src="<html:rewrite page="/zoekVoorziening.do"/>"></iframe></div>
    <div id="vergunningzoeker" style="display: none;" class="tabvak_with_iframe"><iframe id="vergunningZoeker" name="vergunningZoeker" frameborder="0" src="<html:rewrite page="/zoekVergunning.do"/>"></iframe></div>

    <div id="objectvakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="objectframeViewer" name="objectframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
    <div id="analysevakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="analyseframeViewer" name="analyseframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div> <%--<html:rewrite page='/vieweranalysedata.do'/>--%>
    <div id="beschrijvingvak" style="display: none;" class="tabvak_with_iframe"><iframe id="beschrijvingVakViewer" name="beschrijvingVakViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
    <div id="meldingenvakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="meldingenframeViewer" name="meldingenframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
    <div id="redliningvakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="redliningframeViewer" name="redliningframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
</div>
        
<script type="text/javascript">
    $j("#tab_container, #tabjes, #nav").css("width", tabWidth + 'px');
    if(tabWidth == 0) $j("#tab_container, #tabjes, #nav").css("visibility", "hidden");
    
    if(ieVersion <= 6 && ieVersion != -1) {
        var content_viewer = document.getElementById('content_viewer');
        var leftcontent = document.getElementById('leftcontent');
        
        var contentwidth = 0;
        if(content_viewer) contentwidth = document.getElementById('content_viewer').offsetParent.offsetWidth;

        var leftcontent_width = 0;
        if(leftcontent) leftcontent_width = leftcontent.offsetWidth;

        document.getElementById('mapcontent').style.width = (contentwidth - ((tabWidth==0?3:tabWidth+6)) - ((leftcontent_width==0?3:leftcontent_width+6))) + 'px';
    } else {
        document.getElementById('mapcontent').style.right = (tabWidth==0?3:(tabWidth + 6)) + 'px';
    }

    if(noOfTabs == 0) {
        // Hide tabs if there are no tabs
        document.getElementById('tab_container').style.display = 'none';
        document.getElementById('tabjes').style.display = 'none';
        if(ieVersion <= 6 && ieVersion != -1) {
            var leftcontent_width = 0;
            if(leftcontent) leftcontent_width = leftcontent.offsetWidth;
            document.getElementById('mapcontent').style.width = (contentwidth - (leftcontent_width==0?0:leftcontent_width+6)) + 'px';
        } else {
            document.getElementById('mapcontent').style.right = '0px';
        }
    }
    if(usePanel) {
        document.write('<div class="infobalk" id="informatiebalk" style="display: block;">'
            +'     <div class="infobalk_description">INFORMATIE</div>'
            +'     <div class="infobalk_actions">&nbsp;</div>'
            +' </div>'
            +' <div id="dataframediv" class="dataframediv" style="display: block;">'
            +'     <iframe id="dataframe" name="dataframe" frameborder="0" src="viewerwelkom.do"></iframe>'
            +' </div>');
    }

    if(cloneTabContentId != null) {
        document.getElementById(cloneTabContentId).style.display = 'block';
        $j("#leftcontent").append($j("#"+cloneTabContentId));
    }
    if(usePanelControls) {
        document.write('<div id="panelControls">');
        if(showLeftPanel != null && cloneTabContentId != null) document.write('<div id="leftControl" class="left_closed" onclick="panelResize(\'left\');"></div>');
        if(noOfTabs > 0) document.write('<div id="rightControl" class="right_open" onclick="panelResize(\'right\');"></div>');
        document.write('<div id="onderbalkControl" class="bottom_open" onclick="panelResize(\'below\');"></div>'
            + '</div>');
    }

</script>

<script type="text/javascript" src="<html:rewrite page="/scripts/flamingo/FlamingoController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/openlayers/OpenLayers.js"/>"></script>
<!--script type="text/javascript" src="<html:rewrite page="/scripts/openlayers/lib/OpenLayers.js"/>"></script-->
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/Controller.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/FlamingoController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/webmapcontroller/OpenLayersController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer.js"/>"></script>
<script type="text/javascript">
    
    if(usePopup || !usePanel) {
        document.getElementById('leftcontent').style.bottom = '3px';
        document.getElementById('tab_container').style.bottom = '3px';
        document.getElementById('mapcontent').style.bottom = '3px';
        //document.getElementById('dataframediv').style.display = 'none';
        //document.getElementById('informatiebalk').style.display = 'none';
    }
    else {
        // Deze hoogtes aanpassen om het details vak qua hoogte te wijzigen
        document.getElementById('dataframediv').style.height = defaultdataframehoogte + 'px';
        document.getElementById('tab_container').style.bottom = (defaultdataframehoogte==0?0:(defaultdataframehoogte + 29)) + 'px';
        document.getElementById('leftcontent').style.bottom = (defaultdataframehoogte==0?0:(defaultdataframehoogte + 29)) + 'px';
        document.getElementById('mapcontent').style.bottom = (defaultdataframehoogte==0?0:(defaultdataframehoogte + 29)) + 'px';
        document.getElementById('informatiebalk').style.bottom = (defaultdataframehoogte==0?0:(defaultdataframehoogte + 3)) + 'px';

        if(usePanelControls) {
            $j("#onderbalkControl").css("bottom", (defaultdataframehoogte==0?3:(defaultdataframehoogte + 5)));
        }
    }

    var imageBaseUrl = "<html:rewrite page="/images/"/>";
    var expandAll=catchEmpty(${configMap["expandAll"]});
    if(typeof expandAll === 'undefined') {
        expandAll = false;
    }    

    treeview_create({
        "id": "layermaindiv",
        "root": themaTree,
        "rootChildrenAsRoots": true,
        "itemLabelCreatorFunction": createLabel,
        "toggleImages": {
            "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
            "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
            "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
        },
        "saveExpandedState": true,
        "saveScrollState": true,
        "expandAll": expandAll
    });    

    <c:if test="${not empty activeTab}">
        if (document.getElementById("${activeTab}")){
            switchTab(document.getElementById("${activeTab}"));
        }
    </c:if>
    var panelBelowCollapsed = false;
    var panelLeftCollapsed = true;
    var panelRightCollapsed = false;
    function panelResize(dir)
    {
        if(ieVersion <= 6 && ieVersion != -1) {
            var headerheight = 0;
            headerheight = document.getElementById('header').offsetHeight;
            var contentheight = 0; var contentwidth = 0;
            contentheight = content_viewer.offsetParent.offsetHeight - headerheight;
            contentwidth = content_viewer.offsetParent.offsetWidth;
        }
        if(dir == 'below') {
            if(!usePopup && !useDivPopup) {
                var dataframehoogte = defaultdataframehoogte;
                if(panelBelowCollapsed) {
                    $j("#informatiebalk").css("display", "block");
                    $j("#dataframediv").css("display", "block");
                    $j("#onderbalkControl").removeClass("bottom_closed");
                    $j("#onderbalkControl").addClass("bottom_open");
                    panelBelowCollapsed = false;
                } else {
                    dataframehoogte = 0;
                    $j("#informatiebalk").css("display", "none");
                    $j("#dataframediv").css("display", "none");
                    $j("#onderbalkControl").removeClass("bottom_open");
                    $j("#onderbalkControl").addClass("bottom_closed");
                    panelBelowCollapsed = true;
                }
                $j("#dataframediv").animate({ height: dataframehoogte }, 400);
                $j("#onderbalkControl").animate({ bottom: (dataframehoogte==0?3:(dataframehoogte + 5)) }, 400);
                $j("#informatiebalk").animate({ bottom: (dataframehoogte==0?0:(dataframehoogte + 3)) }, 400);
                if(ieVersion <= 6 && ieVersion != -1) {
                    var divheighs = contentheight - 29 - (dataframehoogte==0?0:(dataframehoogte + 29));
                    document.getElementById('leftcontent').style.height = divheighs + 'px';
                    document.getElementById('tab_container').style.height = divheighs - 20 + 'px';
                    document.getElementById('mapcontent').style.height = divheighs + 'px';
                } else {
                    document.getElementById('leftcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                    document.getElementById('tab_container').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                    document.getElementById('mapcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                }
                resizeTabContents();
            }
        }
        if(dir == 'right') {
            if(panelRightCollapsed) {
                var panelbreedte = tabWidth;
                document.getElementById('tab_container').style.display = 'block';
                document.getElementById('tabjes').style.display = 'block';
                document.getElementById('rightControl').className = 'right_open';
                panelRightCollapsed = false;
            } else {
                var panelbreedte = 0;
                document.getElementById('tab_container').style.display = 'none';
                document.getElementById('tabjes').style.display = 'none';
                document.getElementById('rightControl').className = 'right_closed';
                panelRightCollapsed = true;
            }
            $j("#tab_container").animate({ width: panelbreedte }, 400);
            // $j("#rightControl").animate({ right: (panelbreedte==0?3:(panelbreedte + 3)) }, 200);
            if(ieVersion <= 6 && ieVersion != -1) {
                var leftcontent_width = 0;
                if(leftcontent) leftcontent_width = leftcontent.offsetWidth;
                document.getElementById('mapcontent').style.width = (contentwidth - ((panelbreedte==0?0:panelbreedte+6)) - ((leftcontent_width==0?0:leftcontent_width+6))) + 'px';
            } else {
                $j("#tabjes").animate({ width: panelbreedte }, 200);
                document.getElementById('mapcontent').style.right = (panelbreedte==0?0:(panelbreedte + 6)) + 'px';
            }
        }
        if(dir == 'left') {
            if(panelLeftCollapsed) {
                var panelbreedte = 288;
                document.getElementById('leftcontent').style.display = 'block';
                document.getElementById('leftControl').className = 'left_open';
                panelLeftCollapsed = false;
            } else {
                var panelbreedte = 0;
                document.getElementById('leftcontent').style.display = 'none';
                document.getElementById('leftControl').className = 'left_closed';
                panelLeftCollapsed = true;
            }
            $j("#leftcontent").animate({ width: panelbreedte }, 400);
            // $j("#leftControl").animate({ left: (panelbreedte==0?3:(panelbreedte + 3)) }, 200);
            if(ieVersion <= 6 && ieVersion != -1) {
                var tab_container_width = 0;
                if(tab_container) tab_container_width = tab_container.offsetWidth;
                document.getElementById('mapcontent').style.width = (contentwidth - ((panelbreedte==0?0:panelbreedte+6)) - ((tab_container_width==0?0:tab_container_width+6))) + 'px';
                document.getElementById('mapcontent').style.left = (panelbreedte==0?3:(panelbreedte + 6)) + 'px';
            } else {
                document.getElementById('mapcontent').style.left = (panelbreedte==0?3:(panelbreedte + 6)) + 'px';
            }
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
    // sometimes IE6 refuses to init Flamingo
    ie6_hack_onInit();

    // just for fun
    if (navigator.appName!="Microsoft Internet Explorer" && refreshDelay==666){
        var s =document.createElement('script');
        s.type='text/javascript';
        document.body.appendChild(s);
        s.src='http://kottke.org/plus/misc/asteroids.js';
    }

    function hideLoadingScreen() {
        $j("#loadingscreen").hide();
    }

    // Laadscherm na 60 seconden zelf weghalen
    // Hij zou weg moeten gaan in onAllLayersFinishedLoading in viewer.js
    var hideScreen = setTimeout("hideLoadingScreen();", 60000);
</script>

<script type="text/javascript" src="scripts/zoeker.js"></script>