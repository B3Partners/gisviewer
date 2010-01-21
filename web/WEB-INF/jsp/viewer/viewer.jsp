<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type='text/javascript' src='dwr/interface/EditUtil.js'></script>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type='text/javascript' src='dwr/interface/JZoeker.js'></script>

<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/cookiefunctions.js"/>"></script>

<script type="text/javascript">
    var beheerder = <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>;
    var organisatiebeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>;
    var themabeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>;
    var gebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>;
    var demogebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>;
    var anoniem= !beheerder && !organisatiebeheerder && !themabeheerder && !gebruiker && !demogebruiker;
    
    var sldServletUrl=window.location.protocol + "//" +  window.location.host +"<html:rewrite page='/CreateSLD'/>";

    var ingelogdeGebruiker="<c:out value='${pageContext.request.remoteUser}'/>";
    var kburl="${kburl}";
    var themaTree=${tree};
    var visibleTree=${tree};
    
    var organizationcode="${organizationcode}";
    var fullbbox='${fullExtent}';
    var bbox='${extent}';

    // init search
    var searchConfigId='${searchConfigId}';
    var search='${search}';

    //search with sld result (searchAction: filter or highlight and zoom)
    var searchAction='${searchAction}';
    var searchSldThemaId='${searchSldThemaId}';
    var searchSldClusterId='${searchSldClusterId}';
    var searchSldVisibleValue='${searchSldVisibleValue}';

    //Wel of niet cookies
    var useCookies=false;
    /* True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
     * False als je maximaal van 1 thema data kan ophalen. (radiobuttons)
     */
    var multipleActiveThemas=false;
    
    /* True als de admin- of metadata in een popup wordt getoond
     * False als deze onder de kaart moet worden getoond
     * dataframepopupHandle wordt gebruikt wanneer de data in een popup wordt getoond
     */
    var usePopup=false;
    var useDivPopup=false;
    var dataframepopupHandle = null;

    /* Variable op true zetten als er gebruik wordt gemaakt van uitschuifbare panelen
     * showLeftPanel op de gewenste tab zetten als het leftPanel moet worden getoond,
     * en op null als het leftPanel niet moet worden getoond */
    var usePanelControls = true;
    var showLeftPanel = null;

    /* Deze waarde wordt gebruikt om de admindata automatisch door te sturen op het moment dat er maar
     * 1 regel en 1 thema aan admindata is. De waarde is voor het aantal kollomen dat weergegeven moet
     * worden om automatisch door te sturen. (bijv: Als de kollomen id, naam, link zijn moet er 3 staan
     * als de admindata automatisch moeten worden doorgestuurd)
     */
    var autoRedirect = 2;
    
    /* het aantal pixels dat moet worden gebruikt als er ergens in de kaart is geklikt
     * en info wordt opgevraagd. Dus een tolerantie.
     **/
    var tolerance=1;
    if(demogebruiker) usePopup=false;
    
    
    /*
     * Kijkt of de ingelogde gebruiker ook de vorige ingelogde gebruiker is,
     * zo nee, worden eerst alle cookies gewist, zodat een nieuwe gebruiker opnieuw kan beginnen
     */
    var loggedInUser = readCookie('loggedInUser');
    if(loggedInUser != null) {
        if(loggedInUser != '<c:out value="${pageContext.request.remoteUser}"/>') {
            eraseCookie('activelayer');
            eraseCookie('activetab');
            eraseCookie('checkedLayers');
        }
    }
    createCookie('loggedInUser', '<c:out value="${pageContext.request.remoteUser}"/>', '7');
	
    /*
     * True als het mogelijk moet zijn om de volgorde van de layers te slepen met de muis
     * de kaart wordt na het slepen automatisch herladen na x aantal (instellen door layerDelay) seconden
     * de buttons Omhoog, Omlaag, Herladen zijn niet zichtbaar
     * 
     * False als de volgorde alleen bepaald moet kunnen worden door de buttons Omhoog en Omlaag
     */
    var useSortableFunction=false;
    var layerDelay = 5000; // instellen in ms, dus 5000 voor 5 seconden

    //de vertraging voor het refreshen van de kaart.
    var refreshDelay=1000;
    var nr = 0;
    
    /****************************************************************************
    Zoeker instellingen
     ******************************************************************************/
    /*
     *Het id van het thema dat wordt gebruikt om de dichtsbij zijnde adres te tonen.
     */
    var adresThemaId=88;
    /*
     * De kolommen van het thema dat moet worden getoond als er een identify wordt gedaan.
     */
    var infoArray = new Array();
    infoArray[0] = "bu_naam";
    infoArray[1] = "gm_naam"; 
    /*
     * Geef hier de thema nummers op waarop gezocht moet kunnen worden.
     */
    var zoekThemaIds = new Array();
    zoekThemaIds[0]=88;
    /*
     * Geef hier per thema op op welke kolommen gezocht moet worden. Moet het voor een thema op meerdere kolommen
     * geeft dan de kolommen gescheiden door een komma (Zonder spaties rond de komma!).
     */
    var zoekKolommen = new Array();
    zoekKolommen[0]= "bu_naam,gm_naam";
    /* Zet aparteZoekThemas op true als je per zoekthema een apart zoek invoer selectie wil. (selectie box wordt zichtbaar)
     * Met aparteZoekThemas[<index>] kan je de eventueel een naam aangeven die boven het zoekveld moet komen.
     **/
    var aparteZoekThemas= true;
    var naamZoekThemas= new Array();
    naamZoekThemas[0]="Buurt"
    /*Zet aparte zoek velden per thema     
     **/
    var aparteZoekVelden= new Array();
    aparteZoekVelden[0]=true;   
    /*Naam van de aparte zoekvelden*/
    var naamZoekVelden= new Array();
    naamZoekVelden[0]="Buurtnaam,Gemeentenaam"
    /*
     * De minimale groote van een bbox van een gezocht object. Als de bbox kleiner is wordt deze vergroot tot de
     * hier gegeven waarde. Dit om zoeken op punten mogelijk te maken.
     */
    var minBboxZoeken=1000;
    /*
     * Maximaal aantal zoekresultaten
     */
    var maxResults=25;
    
    /* De rechten van de verschillende gebruikers. De tabbladen die ze mogen zien en de volgorde waarin ze getoond worden.
     * TODO: Hoe te handelen als een gebruiker meerdere rollen heeft en verschillende tabbladen voor deze rollen?? Komt dit voor?
     *       Nu wordt de laatste rol gebruikt om de tabs te bepalen (bijv: user=beheerder en themabeheerder, dan worden themabeheerder tabs gebruikt */
    var userrights = {
        "beheerder": ["tab0", "tab4", "tab1", "tab2", "tab3", "tab6"],
        // "organisatiebeheerder": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        // "themabeheerder": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        "gebruiker": ["tab2", "tab3", "tab0", "tab5", "tab6"],
        "demogebruiker": ["tab1", "tab4", "tab5"],
        "anoniem": ["tab0", "tab4", "tab1", "tab5"]
    };
    
    /* De beschikbare tabbladen. Het ID van de tab, de bijbehoorden Content-div,
     * de naam en eventueel extra Content-divs die geopend moeten worden */
    var tabbladen = {
        "tab0": { "id": "tab0", "contentid": "treevak", "name": "Thema's", "extracontent": ["layermaindiv"] },
        "tab1": { "id": "tab1", "contentid": "infovak", "name": "Zoeken" },
        "tab2": { "id": "tab2", "contentid": "objectvakViewer", "name": "Gebieden" },
        "tab3": { "id": "tab3", "contentid": "analysevakViewer", "name": "Analyse" },
        "tab4": { "id": "tab4", "contentid": "volgordevak", "name": "Legenda", "resizableContent": true },
        "tab5": { "id": "tab5", "contentid": "beschrijvingvak", "name": "Informatie" },
        "tab6": { "id": "tab6", "contentid": "plannenzoeker", "name": "Plan selectie" }
    };

    var enabledtabs = new Array();
    if(beheerder) enabledtabs = userrights.beheerder;
    if(gebruiker) {
        for(k in userrights.gebruiker) {
            var found = false;
            for(j in enabledtabs) {
                if(userrights.gebruiker[k] == enabledtabs[j]) found = true;
            }
            if(!found) enabledtabs[enabledtabs.length] = userrights.gebruiker[k];
        }
    }
    if(demogebruiker) {
        for(k in userrights.demogebruiker) {
            var found = false;
            for(j in enabledtabs) {
                if(userrights.demogebruiker[k] == enabledtabs[j]) found = true;
            }
            if(!found) enabledtabs[enabledtabs.length] = userrights.demogebruiker[k];
        }
    }
    if(anoniem){
        for(k in userrights.anoniem) {
            var found = false;
            for(j in enabledtabs) {
                if(userrights.anoniem[k] == enabledtabs[j]) found = true;
            }
            if(!found) enabledtabs[enabledtabs.length] = userrights.anoniem[k];
        }
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
    <html:form action="/viewerdata">
        <input type="hidden" name="admindata" />
        <input type="hidden" name="metadata" />
        <input type="hidden" name="objectdata"/>
        <input type="hidden" name="analysedata"/>
        <html:hidden property="themaid" />
        <html:hidden property="analysethemaid" />
        <html:hidden property="lagen" />
        <%--html:hidden property="xcoord" />
        <html:hidden property="ycoord"/ --%>
        <html:hidden property="coords" />
        <html:hidden property="geom" />
        <html:hidden property="scale"/>
        <html:hidden property="tolerance"/>
    </html:form>
</div>

<div class="infobalk" id="viewerinfobalk">
    <div class="infobalk_description">VIEWER</div>
    <div class="infobalk_actions">
        <div style="float: left;"><span id="actief_thema"></span></div>
        <tiles:insert name="loginblock"/>
    </div>
</div>

<div id="leftcontent" style="display: none;">
    &nbsp;
</div>

<div id="flashcontent">
    <strong style="color: Red;"><br/><br/><br/><br/><br/>U heeft de Flash plugin nodig om de kaart te kunnen zien.<br/>Deze kunt u <a href="http://get.adobe.com/flashplayer/" target="_blank">hier</a> gratis downloaden.</strong>
</div>
<script type="text/javascript">
    var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "100%", "100%", "8", "#FFFFFF");
    so.addParam("wmode", "transparent");
    so.write("flashcontent");
    var flamingo = document.getElementById("flamingo");
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
            var tabwidth = Math.floor((288 - (noOfTabs-1)) / noOfTabs);
            var cloneTabContentId = null;
            for(i in enabledtabs) {
                var tabid = enabledtabs[i];
                var tabobj = eval("tabbladen."+tabid);
                if(showLeftPanel != null && tabid == showLeftPanel) {
                    cloneTabContentId = tabobj.contentid;
                } else {
                    document.write('<li id="' + tabid + '" onmouseover="switchTab(this);"><a href="#" id="' + tabid + 'link" style="width: ' + tabwidth + 'px;">' + tabobj.name + '</a></li>');
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
        <form id="treeForm">
            <div id="layermaindiv" style="display: none;"></div>
        </form>
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
        <div id="start_message">
            Kies de Info-tool en klik vervolgens op een punt<br/>
            op de kaart voor administratieve informatie<br/>
            van het object.
        </div>

        <div id="algdatavak" style="display: none;">
            <b>RD Co&ouml;rdinaten</b><br />
            <span id="rdcoords"></span><br /><br />
            <b>Adres</b><br />
            <span id="kadastraledata"></span>
        </div>

        <!-- input fields for search -->
        <div>
            <br>
            <script type="text/javascript">
                if (aparteZoekThemas){
                    if (zoekThemaIds.length >= 1){
                        document.write('<b>Zoek op:</b><br>')
                        document.write('<SELECT id="searchSelect" onchange="searchSelectChanged(this)">');
                        document.write('<OPTION value="">Kies waar op u wilt zoeken.....</OPTION>')
                    }
                    for (var i=0; i < zoekThemaIds.length; i++){
                        var naamZoekThema="Zoek op locatie:";
                        if (naamZoekThemas[i]!=undefined){
                            naamZoekThema=naamZoekThemas[i];
                        }else{
                            naamZoekThema=zoekKolommen[i];
                        }
                        document.write('<OPTION value="'+i+'">'+naamZoekThema+'</OPTION>');
                    }
                    if (zoekThemaIds.length >= 1){
                        document.write('</SELECT>');
                    }
                    document.write('<DIV id="searchInputFieldsContainer">&nbsp;</DIV>')
                }else{
                    document.write('<b>Zoek naar locatie:</b>');
                    document.write('<br>');
                    document.write('<input type="text" id="searchField_0" name="locatieveld" size="40"/>');
                    document.write('&nbsp;');
                    document.write('<input type="button" value=" Zoek " onclick="getCoords();" class="knop" />');
                }
            </script>
            <br>
            <div class="searchResultsClass" id="searchResults"></div>
        </div>
        <!-- end of search -->
    </div>

    <div id="objectvakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="objectframeViewer" name="objectframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
    <div id="analysevakViewer" style="display: none;" class="tabvak_with_iframe"><iframe id="analyseframeViewer" name="analyseframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>
    <div id="beschrijvingvak" style="display: none;" class="tabvak_with_iframe"><iframe id="beschrijvingVakViewer" name="beschrijvingVakViewer" frameborder="0" src="empty_iframe.jsp"></iframe></div>

</div>

<script type="text/javascript">
    if(!usePopup) {
        document.write('<div class="infobalk" id="informatiebalk" style="display: none;">'
            +'     <div class="infobalk_description">INFORMATIE</div>'
            +'     <div class="infobalk_actions">&nbsp;</div>'
            +' </div>'
            +' <div id="dataframediv" class="dataframediv" style="display: none;">'
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
        document.write('<div id="rightControl" class="right_open" onclick="panelResize(\'right\');"></div>'
            + '<div id="onderbalkControl" class="bottom_closed" onclick="panelResize(\'below\');"></div>'
            + '</div>');
    }

</script>

<script type="text/javascript" src="<html:rewrite page="/scripts/flamingo/FlamingoController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer.js"/>"></script>
<script type="text/javascript">
    var dataframehoogte = 0;
    if(usePopup) {
        document.getElementById('leftcontent').style.bottom = '3px';
        document.getElementById('tab_container').style.bottom = '3px';
        document.getElementById('flashcontent').style.bottom = '3px';
        //document.getElementById('dataframediv').style.display = 'none';
        //document.getElementById('informatiebalk').style.display = 'none';
    } else {
        // Deze hoogtes aanpassen om het details vak qua hoogte te wijzigen
        document.getElementById('dataframediv').style.height = dataframehoogte + 'px';
        document.getElementById('tab_container').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
        document.getElementById('leftcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
        document.getElementById('flashcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
        document.getElementById('informatiebalk').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 3)) + 'px';
    }

    filterInvisibleItems(visibleTree);
    treeview_create({
        "id": "layermaindiv",
        "root": visibleTree,
        "rootChildrenAsRoots": true,
        "itemLabelCreatorFunction": createLabel,
        "toggleImages": {
            "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
            "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
            "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
        },
        "saveExpandedState": true,
        "saveScrollState": true,
        "expandAll": true
    });

    var panelBelowCollapsed = true;
    var panelLeftCollapsed = true;
    var panelRightCollapsed = false;
    function panelResize(dir)
    {
        if(ieVersion <= 6 && ieVersion != -1) {
            var headerheight = 0;
            headerheight = document.getElementById('header').offsetHeight;
            var contentheight = 0; var contentwidth = 0;
            var content_viewer = document.getElementById('content_viewer');
            contentheight = content_viewer.offsetParent.offsetHeight - headerheight;
            contentwidth = content_viewer.offsetParent.offsetWidth;
        }
        if(dir == 'below') {
            if(!usePopup && !useDivPopup) {
                if(panelBelowCollapsed) {
                    dataframehoogte = 150;
                    document.getElementById('informatiebalk').style.display = 'block';
                    document.getElementById('dataframediv').style.display = 'block';
                    document.getElementById('onderbalkControl').className = 'bottom_open';
                    panelBelowCollapsed = false;
                } else {
                    dataframehoogte = 0;
                    document.getElementById('informatiebalk').style.display = 'none';
                    document.getElementById('dataframediv').style.display = 'none';
                    document.getElementById('onderbalkControl').className = 'bottom_closed';
                    panelBelowCollapsed = true;
                }
                $j("#dataframediv").animate({ height: dataframehoogte }, 400);
                $j("#onderbalkControl").animate({ bottom: (dataframehoogte==0?3:(dataframehoogte + 4)) }, 400);
                $j("#informatiebalk").animate({ bottom: (dataframehoogte==0?0:(dataframehoogte + 3)) }, 400);
                if(ieVersion <= 6 && ieVersion != -1) {
                    var divheighs = contentheight - 29 - (dataframehoogte==0?0:(dataframehoogte + 29));
                    document.getElementById('leftcontent').style.height = divheighs + 'px';
                    document.getElementById('tab_container').style.height = divheighs - 20 + 'px';
                    document.getElementById('flashcontent').style.height = divheighs + 'px';
                } else {
                    document.getElementById('leftcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                    document.getElementById('tab_container').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                    document.getElementById('flashcontent').style.bottom = (dataframehoogte==0?0:(dataframehoogte + 29)) + 'px';
                }
                resizeTabContents();
            }
        }
        if(dir == 'right') {
            if(panelRightCollapsed) {
                var panelbreedte = 288;
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
                document.getElementById('flashcontent').style.width = (contentwidth - ((panelbreedte==0?0:panelbreedte+6)) - ((leftcontent_width==0?0:leftcontent_width+6))) + 'px';
            } else {
                $j("#tabjes").animate({ width: panelbreedte }, 200);
                document.getElementById('flashcontent').style.right = (panelbreedte==0?0:(panelbreedte + 6)) + 'px';
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
                document.getElementById('flashcontent').style.width = (contentwidth - ((panelbreedte==0?0:panelbreedte+6)) - ((tab_container_width==0?0:tab_container_width+6))) + 'px';
                document.getElementById('flashcontent').style.left = (panelbreedte==0?3:(panelbreedte + 6)) + 'px';
            } else {
                document.getElementById('flashcontent').style.left = (panelbreedte==0?3:(panelbreedte + 6)) + 'px';
            }
        }
    }

    // sometimes IE6 refuses to init Flamingo
    ie6_hack_onInit();
	
</script>

<script type="text/javascript" src="scripts/zoeker.js"></script>