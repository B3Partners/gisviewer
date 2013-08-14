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

<div class="tegels">
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="blockwrapper" title="${tb.titel}">
            <c:set var="style" value="" />
            <c:if test="${!empty tb.kleur}">
                <c:set var="style" value="${style}background-color:${tb.kleur};" />
            </c:if>
            
            <c:if test="${!empty tb.hoogte && tb.hoogte != 0}">
                <c:set var="style" value="${style}height:${tb.hoogte}px;" />
            </c:if>
            
            <c:if test="${!empty style}">
                <c:set var="style" value=" style=\"${style}\"" />
            </c:if>
            <div class="tegel"${style}>
                <c:choose>
                    <c:when test="${tb.toonUrl}">
                        <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                    </c:when>
                    <c:otherwise>
                        ${tb.tekst}
                        <c:if test="${!empty tb.url}">
                            <a href="${tb.url}" target="_new">${tb.url}</a>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>

    <!-- Als er geen tekstblokken zijn voor de homepagina toon dan de standaard blokken -->
    <c:if test="${empty tekstBlokken}">
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #F9811E;">
                <html:link page="/maatschappelijkevoorzieningen.do" title="Maatschappelijke voorzieningen" styleId="maatschappelijkevoorzieningen" styleClass="tegellink">
                    Thema Maatschappelijke voorzieningen
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #515151;">
                <html:link page="/actuelezaken.do" title="Actuele zaken" styleId="actuelezaken" styleClass="tegellink">
                    Thema Actuele zaken 
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #9151E5;">
                <html:link page="/wijkgerichtwerken.do" title="Wijkgericht werken" styleId="wijkgerichtwerken" styleClass="tegellink">
                    Thema Wijkgericht werken
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #96CA2D;">
                <html:link page="/beheeropenbareruimte.do" title="Beheer openbare ruimte" styleId="beheeropenbareruimte" styleClass="tegellink">
                    Thema Beheer openbare ruimte
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #FF5050;">
                <html:link page="/natuurmilieucultuurhistorie.do" title="Natuur, Milieu, Cultuur en Historie" styleId="natuurmilieucultuurhistorie" styleClass="tegellink">
                    Thema Natuur, Milieu, Cultuur en Historie
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #00BDFF;">
                <html:link page="/gemeenteopdekaart.do" title="Gemeente op de kaart" styleId="gemeenteopdekaart" styleClass="tegellink">
                    Thema Gemeente op de kaart
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #515151; height: 23px;">
                <html:link page="/login.do" title="Inloggen" styleId="logintegel" styleClass="tegellink">
                    Inloggen
                </html:link>
            </div>
        </div>
        <div class="blockwrapper">
            <div class="tegel" style="background-color: #515151; height: 23px;">
                <html:link page="/" title="Bepaal uw positie" styleId="lokatietegel" styleClass="tegellink">
                    Bepaal uw positie
                </html:link>
            </div>
        </div>
    </c:if>
 </div>

<script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script>