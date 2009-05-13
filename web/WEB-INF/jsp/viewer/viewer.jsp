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

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/cookiefunctions.js"/>"></script>
<script type="text/javascript">
    var beheerder = <c:out value="${f:isUserInRole(pageContext.request, 'beheerder')}"/>;
    var organisatiebeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'organisatiebeheerder')}"/>;
    var themabeheerder = <c:out value="${f:isUserInRole(pageContext.request, 'themabeheerder')}"/>;
    var gebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'gebruiker')}"/>;
    var demogebruiker = <c:out value="${f:isUserInRole(pageContext.request, 'demogebruiker')}"/>;    

    var kburl="${kburl}";
    var themaTree=${tree};
    var visibleTree=${tree};
    
    var organizationcode="${organizationcode}";
    var fullbbox='${fullExtent}';
    var bbox='${extent}';
    //Wel of niet cookies
    var useCookies=false;
    /* True als het mogelijk moet zijn om featureinfo op te halen van de aangevinkte (checkbox) layers
     * False als je maximaal van 1 thema data kan ophalen. (radiobuttons)
     */
    var multipleActiveThemas=true;
    
    /* True als de admin- of metadata in een popup wordt getoond
     * False als deze onder de kaart moet worden getoond
     * dataframepopupHandle wordt gebruikt wanneer de data in een popup wordt getoond
     */
    var usePopup=false;
    var dataframepopupHandle = null;
    
    if(demogebruiker) usePopup=true;
    
    
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
    
    //Instellingen voor edam volendam
    /*adresThemaId=7;
    
    infoArray[0] = "straatnaam";
    infoArray[1] = "huisnr";
    
    zoekThemaIds[0]=7;
    zoekThemaIds[1]=9;
    
    zoekKolommen[0]="straatnaam,naambedrijf";
    zoekKolommen[1]="AdresOpgemaakt";
    
    naamZoekThemas[0]="Bedrijven";
    naamZoekThemas[1]="Percelen";
    
    aparteZoekVelden[0]=true;
    aparteZoekVelden[1]=true;
    
    naamZoekVelden[0]="Straatnaam,Bedrijfsnaam"
    naamZoekVelden[1]="Adres";*/
    
    /* De rechten van de verschillende gebruikers. De tabbladen die ze mogen zien en de volgorde waarin ze getoond worden.
     * TODO: Hoe te handelen als een gebruiker meerdere rollen heeft en verschillende tabbladen voor deze rollen?? Komt dit voor?
     *       Nu wordt de laatste rol gebruikt om de tabs te bepalen (bijv: user=beheerder en themabeheerder, dan worden themabeheerder tabs gebruikt */
    var userrights = {
        "beheerder": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        // "organisatiebeheerder": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        // "themabeheerder": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        "gebruiker": ["tab0", "tab4", "tab1", "tab2", "tab3"],
        "demogebruiker": ["tab1", "tab4", "tab5"]
    };
    
    /* De beschikbare tabbladen. Het ID van de tab, de bijbehoorden Content-div,
     * de naam en eventueel extra Content-divs die geopend moeten worden */
    var tabbladen = {
        "tab0": { "id": "tab0", "contentid": "treevak", "name": "Thema's", "extracontent": ["layermaindiv"] },
        "tab1": { "id": "tab1", "contentid": "infovak", "name": "Zoeker" },
        "tab2": { "id": "tab2", "contentid": "objectvakViewer", "name": "Gebieden" },
        "tab3": { "id": "tab3", "contentid": "analysevakViewer", "name": "Analyse" },
        "tab4": { "id": "tab4", "contentid": "volgordevak", "name": "Legenda" },
        "tab5": { "id": "tab5", "contentid": "beschrijvingvak", "name": "Informatie" }
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

</script>
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/selectbox.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/moveLayers.js"/>"></script>

<script type="text/javascript" src="<html:rewrite page="/scripts/jquery.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/jquery-ui-sortable.js"/>"></script>

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
        <html:hidden property="scale"/>
    </html:form>
</div>

<table width="100%" height="100%">
    <tr id="bovenbalkTr">
        <td width="100%">
            <table class="onderbalkTable" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="onderbalkTableLeft">
                        VIEWER
                    </td>
                    <td class="onderbalkTableRight">
                        <div style="float: left;"><span id="actief_thema">Actieve thema</span></div>
                        <div style="float: right;">
                            <tiles:insert name="loginblock"/>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%" height="100%">
            <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="100%" height="100%">
                        <div id="flashcontent">
                            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
                        </div>
                        <script type="text/javascript">
                            var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "100%", "100%", "8", "#FFFFFF");
                            so.write("flashcontent");
                            var flamingo = document.getElementById("flamingo");                            
                        </script>
                    </td>
                    <td>
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td id="tabjes">
                                    <ul id="nav">
                                        <script type="text/javascript">
                                            var createdTabs = new Array();
                                            var noOfTabs = enabledtabs.length;
                                            if(noOfTabs > 5) noOfTabs = 5;
                                            var tabwidth = Math.floor(287 / noOfTabs);
                                            for(i in enabledtabs) {
                                                var tabid = enabledtabs[i];
                                                var tabobj = eval("tabbladen."+tabid);
                                                document.write('<li id="' + tabid + '" onmouseover="switchTab(this);"><a href="#" id="' + tabid + 'link" style="width: ' + tabwidth + 'px;">' + tabobj.name + '</a></li>');
                                                createdTabs[i] = enabledtabs[i];
                                                if(i == 4) break;
                                            }

                                            for(i in tabbladen) {
                                                var tabid = tabbladen[i].id;
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
                                </td>
                            </tr>
                            <tr>
                                <td id="tab_container_td">
                                    <div id="tab_container">
                                        <script type="text/javascript">
                                            if(navigator.userAgent.indexOf("Firefox")!= -1) {
                                                document.write('<div id="tabcontainervakscroll">');
                                            }
                                        </script>
                                            <div id="treevak" style="display: none;" class="tabvak">
                                                <div id="layermaindiv" style="display: none;"></div>
                                            </div>
                                            <div id="volgordevak" style="display: none;" class="tabvak">
                                                Bepaal de volgorde waarin de kaartlagen getoond worden
                                                <form id="volgordeForm">
                                                    <div id="orderLayerBox" class="orderLayerBox"></div>
                                                    <script type="text/javascript">
                                                        if(!useSortableFunction) {
                                                            document.write('<input type="button" value="Omhoog" onclick="javascript: moveSelectedUp()" class="knop" />');
                                                            document.write('<input type="button" value="Omlaag" onclick="javascript: moveSelectedDown()" class="knop" />');
                                                            document.write('<input type="button" value="Herladen" onclick="refreshMapVolgorde();" class="knop" />');
                                                        }
                                                    </script>
                                                    <%--input type="button" value="Verwijderen" onclick="deleteAllLayers();" class="knop" /--%>
                                                </form>
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
                                            
                                            <div id="objectvakViewer" style="display: none;" class="tabvak_with_iframe">
                                                <iframe id="objectframeViewer" name="objectframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe>
                                            </div>
                                            <div id="analysevakViewer" style="display: none;" class="tabvak_with_iframe">
                                                <iframe id="analyseframeViewer" name="analyseframeViewer" frameborder="0" src="empty_iframe.jsp"></iframe>
                                            </div>
                                            <div id="beschrijvingvak" style="display: none;" class="tabvak_with_iframe">
                                                <iframe id="beschrijvingVakViewer" name="beschrijvingVakViewer" frameborder="0" src="empty_iframe.jsp"></iframe>
                                            </div>
                                        <script type="text/javascript">
                                            if(navigator.userAgent.indexOf("Firefox")!= -1) {
                                                document.write('</div>');
                                            }
                                        </script>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id="onderstukTr">
        <td width="100%">
            <table class="onderbalkTable" cellpadding="0" cellspacing="0" style="margin-bottom: 3px;">
                <tr>
                    <td class="onderbalkTableLeft">
                        INFORMATIE
                    </td>
                    <td class="onderbalkTableRight">
                        
                    </td>
                </tr>
            </table>
            <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="100%">
                        <div id="dataframediv" class="dataframediv">
                            <iframe id="dataframe" name="dataframe" frameborder="0" src="viewerwelkom.do"></iframe>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script type="text/javascript" src="<html:rewrite page="/scripts/FMCController.js"/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/viewer.js"/>"></script>
<script type="text/javascript">
   if(usePopup) {
        document.getElementById('onderstukTr').style.display = 'none';
   } else {
       // Deze hoogtes aanpassen om het details vak qua hoogte te wijzigen
       var dataframehoogte = '200px';
       document.getElementById('dataframediv').style.height = dataframehoogte; 
       document.getElementById('dataframe').style.height = dataframehoogte; 
   }
   
   if(navigator.userAgent.indexOf("Firefox")!= -1) {
        setFirefoxCSS();
        resizeTabVak();
        window.onresize = function() {  
            document.getElementById('tabcontainervakscroll').style.height = '1px';
            document.getElementById('tabcontainervakscroll').style.width = '1px';
            resizeTabVak();
        }
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
    "expandAll": false
    });
   
    
</script>

