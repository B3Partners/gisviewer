<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div id="content_style">
    
    <hr size="1" width="100%" />
    
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <html:messages id="message" message="true">
                    <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
                </html:messages><br/>
                <h1>Provinciaal Omgevingsplan Limburg (POL 2006)</h1>
                
                <div class="inleiding">
                    <h2>Introductie</h2>
                    Het Provinciaal Omgevingsplan Limburg (POL2006) is een plan op hoofdlijnen. 
                    Het biedt een samenhangend overzicht van de provinciale visie op de ontwikkeling 
                    van de kwaliteitsregio Limburg, en de ambities, rol en werkwijze op een groot 
                    aantal beleidsterreinen. Het is zowel Structuurvisie, Streekplan, 
                    Waterhuishoudingplan, Milieubeleidplan, als Verkeer en vervoerplan, en 
                    bevat de hoofdlijnen van de fysieke onderdelen van het economische, en 
                    sociaal-culturele beleid.  POL2006 wordt op een speciale manier op deze 
                    website aangeboden voorzien van linken naar de alle erin genoemde POL-aanvullingen, 
                    kaarten en andere documenten.
                    <p>
                    Deze webapplicatie is nog in opbouw en staat op een testserver, welke soms wordt herstart. 
                    Als er even geen contact mogelijk is, dan verzoeken wij u het later nog een keer te proberen. 
                </div>
                <h2>Hoofdelementen van de POL 2006 viewer</h2>
                <a name="thema"></a><h2>Tabblad Thema's</h2>
                <strong>Kaarten zichtbaar maken</strong><br />
                Het tabblad Thema's bestaat uit een uitklapbare boomstructuur met alle selecteerbare thema's. 
                Indien een thema geen vinkvak heeft dan is de onderliggende dataset niet aangemaakt. 
                De gebruiker kan de thema's aan en uitzetten; de kaart wordt dan ververst.
                <p>
                    <strong>Actieve kaartlaag</strong><br />
                    Door het selecteren van een kaartlaag wordt deze kaartlaag actief en vervolgacties hebben betrekking op die kaartlaag
                </p>
                
            </td>
            <td valign="top">               
                <a name="legenda"></a><h2>Tabblad Legenda</h2>
                <p>U kunt met de knoppen "Omlaag" en "Omhoog" de volgorde van de kaartlagen aanpassen. 
                    Wilt u een bepaalde kaartlaag als bovenste kaartlaag hebben, dan kunt u met de knop "Omhoog" deze kaartlaag naar de gewenste positie verplaatsen. 
                    U dient vervolgens op de knop "Herlaad kaart" te klikken, waarmee de kaart ververst wordt en 
                de kaartlagen worden getoond volgens de volgorde van het legendapaneel (bovenaan in het vak betekent bovenste kaartlaag).</p>
                <p>Met de knop "Verwijder alle lagen" kunt u met &eacute;&eacute;n druk op de knop alle kaartlagen verwijderen en 
                houdt u slechts de basiskaart over.</p>

                <a name="zoeker"></a><h2>Tabblad Zoeker</h2>
                Zodra in de kaart met de Info icoon wordt geklikt, haalt de viewer de lokatie-informatie op: RD x,y co&ouml;rdinaten en adres.
                <p>Daarnaast vind u de mogelijkheid een bepaalde locatie op de kaart op te zoeken. Dit kunt u doen door 
                of het veld "Plaatsnaam" of het veld "Postcode" in te vullen en op de knop "Ga naar" te klikken.</p>
                
                <h2>Weergeven van resultaten</h2>
                <p>De viewer geeft de resultaten op 3 manieren weer. De meeste belangrijke informatie van een object wordt op de basisregel getoond en 
                    is dus direct zichtbaar. Indien er meer informatie beschikbaar is dan kan via de I-knop een nieuw scherm worden gestart 
                met extra informatie.</p>
                <p>Voor enkele thema's is buiten de viewer informatie beschikbaar welke via een webinterface bereikbaar is. 
                Dergelijke informatie kan worden opgevraagd via de link-knop.</p>
                
            </td>
        </tr>
    </table>
    
    <hr size="1" width="100%" />
    <tiles:insert name="loginblock"/>
</div>