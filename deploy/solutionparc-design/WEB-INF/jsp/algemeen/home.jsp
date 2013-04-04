<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript">
    <!--
    function reloadOpener() {
        window.opener.document.forms[0].submit();
    }

    function reloadAndClose() {
        //reloadOpener();
        window.close();
    }
    // -->
</script>

<!-- tiles:insert definition="actionMessages"/ -->
<!-- Loop door tekstblokken heen -->

<h1><img src="<html:rewrite page="/images/solutionparc-design/pageicons/home.png"/>" alt="" /> GeoMidOffice via de Cloud: kaarten delen, objecten beheren</h1>
    
<p>
    SolutionsParc brengt gemeentelijke informatie samen in een standaard gegevensmagazijn. 
    Alle basisregistraties, de meeste kernregistraties en andere nuttige thema's vinden hun 
    plaats in het magazijn. Koppelvlakken zijn beschikbaar om de informatie te laden. 
    Services maken die informatie beschikbaar aan bijbehorende webapplicaties met kaarten 
    en/of beheerfaciliteiten. Gebruikers zijn medewerkers, burgers en omliggende overheids- 
    of adviesorganisaties. SolutionsParc biedt dit alles volledig beveiligd als Cloud-oplossing.
</p>

<div class="solutionparc_homeblocks">
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="blockwrapper">
            ${tb.tekst}
        </div>
    </c:forEach>

    <!-- Als er geen tekstblokken zijn voor de homepagina toon dan de standaard blokken -->
    <c:if test="${empty tekstBlokken}">
        <div class="blockwrapper">
            <div class="home_tegel" id="maatschappelijkevoorzieningen">
                <html:link page="/maatschappelijkevoorzieningen.do" title="Maatschappelijke voorzieningen">
                    Thema Maatschappelijke voorzieningen
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="actuelezaken">
                <html:link page="/actuelezaken.do" title="Actuele zaken">
                    Thema Actuele zaken
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="wijkgerichtwerken">
                <html:link page="/wijkgerichtwerken.do" title="Wijkgericht werken">
                    Thema Wijkgericht werken
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="beheeropenbareruimte">
                <html:link page="/beheeropenbareruimte.do" title="Beheer openbare ruimte">
                    Thema Beheer openbare ruimte
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="natuurmilieucultuurhistorie">
                <html:link page="/natuurmilieucultuurhistorie.do" title="Natuur, Milieu, Cultuur en Historie">
                    Thema Natuur, Milieu, Cultuur en Historie 2
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="gemeenteopdekaart">
                <html:link page="/gemeenteopdekaart.do" title="Gemeente op de kaart">
                    Thema Gemeente op de kaart
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="logintegel">
                <html:link page="/login.do" title="Inloggen">
                    Inloggen
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="home_tegel" id="lokatietegel">
                <a href="#" title="Bepaal uw positie">
                    Bepaal uw positie
                </a>
            </div>
        </div>
     </c:if>
 </div>

<script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script>