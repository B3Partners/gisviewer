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

<h1><img src="<html:rewrite page="/images/solutionparc-design/pageicons/home.png"/>" alt="" /> Welkom bij SolutionsParc</h1>
    
<p>
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis id sapien sapien. Quisque tincidunt elementum bibendum. Aliquam erat volutpat. Etiam facilisis commodo nulla id feugiat. Sed enim dui, lobortis non elementum eget, dictum facilisis diam. Aliquam velit urna, sollicitudin nec tempor vel, congue id velit. Curabitur id ligula nisi. Duis eget lacus et arcu blandit vestibulum facilisis nec quam. Proin tempor accumsan erat in posuere. In id velit urna. Donec ligula elit, pharetra sed consequat ac, feugiat ut mauris. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nam bibendum elit eu sem vehicula rhoncus. Duis pretium sem et dolor tempus molestie. Duis vulputate ligula mauris. 
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
                    Thema Natuur, Milieu, Cultuur en Historie
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

<hr>
<div>
    <div style="float: right;">
        <address>B3Partners: Zonnebaan 12C, 3542 EC, Utrecht</address>
    </div>
</div>
<script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script>