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

<div id="content_style">
    
    <hr>
    
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <html:messages id="message" message="true">
                    <div style="color: red; font-weight: bold"><c:out value="${message}"/></div>
                </html:messages><br>
                <h1>B3P GIS Suite Demo</h1>
                
                <div class="inleiding">
                    <h2>Introductie</h2>
                    Deze B3P GIS Suite demo toont de mogelijkheden van de GIS viewer zoals deze binnen de GIS suite gebruikt wordt.
                    De getoonde kaarten zijn alleen ten bate van deze demo beschikbaar. Later worden voor elk project specifieke
                    kaarten aangeschaft en geconfigureerd.
                    <p>
                        Deze demo staat op een testserver, welke soms wordt herstart.
                        Als er even geen contact mogelijk is, dan verzoeken wij u het later nog een keer te proberen.
                    </p>
                </div>
                <h2>Hoofdelementen van de GIS Viewer</h2>
                De GIS viewer bestaat uit een kaart, een paneel met tabbladen waarmee de viewer wordt bestuurd en een paneel met resultaten.
                <!--
                <table class="presentation_table">
                    <tr><th colspan="2">Kort samengevat</th></tr>
                    <tr>
                        <td valign="top">WIS</td>
                        <td>
                            <ul>
                                <li>Kaart</li>
                                <li>Paneel met tabbladen voor de besturing</li>
                                <li>Vlak met resultaten</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>Besturing</td>
                        <td>Gebruikelijke knoppen. Export knop ontbreekt nog.</td>
                    </tr>
                    <tr>
                        <td>Tabbladen</td>
                        <td><a href="#thema">Thema's</a>, <a href="#legenda">Legenda</a>, <a href="#zoeker">Zoeker</a>, 
                        <a href="#gebieden">Gebieden</a> en <a href="#analyse">Analyse</a>.</td>
                    </tr>
                </table>
                -->
                <a name="thema"></a><h2>Tabblad Thema's</h2>
                <strong>Kaarten zichtbaar maken</strong><br>
                Het tabblad Thema's bestaat uit een uitklapbare boomstructuur met alle selecteerbare thema's. 
                Indien een thema geen vinkvak heeft dan is de onderliggende dataset niet aangemaakt. 
                De gebruiker kan de thema's aan en uitzetten; de kaart wordt dan ververst.
                <p>Sommige kaartlagen zijn pas zichtbaar wanneer ingezoomd om overmatige serverbelasting te voorkomen.</p>
                
                <p>
                    <strong>Kaartlaaginformatie</strong><br>
                    De themanaam is een link naar metadata van de kaartlaag. 
                </p>
                
                <p>
                    <strong>Actieve kaartlaag</strong><br>
                    Door het selecteren van een kaartlaag wordt deze kaartlaag actief en vervolgacties hebben betrekking op die kaartlaag
                </p>
                
                <a name="legenda"></a><h2>Tabblad Legenda</h2>
                Het tabblad legenda bestaat uit een paneel waarop u alle actieve kaartlagen kunt vinden. 
                Bij deze kaartlagen is een afbeelding geplaatst waarop u kunt zien hoe u de betreffende kaartlaag op de kaart kunt onderscheiden.
                <p>U kunt met de knoppen "Omlaag" en "Omhoog" de volgorde van de kaartlagen aanpassen. 
                    Wilt u een bepaalde kaartlaag als bovenste kaartlaag hebben, dan kunt u met de knop "Omhoog" deze kaartlaag naar de gewenste positie verplaatsen. 
                    U dient vervolgens op de knop "Herlaad kaart" te klikken, waarmee de kaart ververst wordt en 
                de kaartlagen worden getoond volgens de volgorde van het legendapaneel (bovenaan in het vak betekent bovenste kaartlaag).</p>
                <p>Met de knop "Verwijder alle lagen" kunt u met &eacute;&eacute;n druk op de knop alle kaartlagen verwijderen en 
                houdt u slechts de basiskaart over.</p>
            </td>
            <td valign="top">               
                <a name="zoeker"></a><h2>Tabblad Zoeker</h2>
                Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de lokatie-informatie op: RD x,y co&ouml;rdinaten, WOL/HM aanduiding en adres.
                <p>Medewerkers die gewend zijn de WOL/HM aanduiding te gebruiken, kunnen hier altijd deze informatie vinden.</p>
                <p>Daarnaast vind u de mogelijkheid een bepaalde locatie op de kaart op te zoeken. Dit kunt u doen door 
                of het veld "Plaatsnaam" of het veld "Postcode" of het veld "Wegnr / hm" in te vullen en op de knop "Ga naar" te klikken.</p>
                
                <a name="gebieden"></a><h2>Tabblad Gebieden</h2>
                Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de gebieden op waarin het klikpunt zich bevindt. 
                Per kaarlaag is door de beheerder aangegeven of dit een gebied betreft dat in deze lijst moet worden opgenomen.
                <p>De gevonden gebieden kunnen later bij de analyse worden gebruikt.</p>
                
                <a name="analyse"></a><h2>Tabblad Analyse</h2>
                Via het tabblad Analyse kunnen geografische selecties en berekeningen gedaan worden. 
                De analyse heeft altijd betrekking op de actieve kaartlaag zoals deze onder tab Thema's is gekozen. 
                Objecten van dit thema kunnen verder worden beperkt door extra criteria op te nemen.
                <p>Vervolgens kan opgegeven worden voor welk gebied de analyse moet worden uitgevoerd. 
                    Dit is een van de gebieden zoals bepaald onder de tab Gebieden. 
                Bij de analyse worden dus alle objecten meegenomen van de actieve kaartlaag welke liggen in het gebied van keuze.</p>
                <p>Tenslotte dient aangegeven te worden of de gebruiker een selectie of een berekening wil uitvoeren. 
                    Bij een selectie kiest men &quot;Geef object&quot; en de gewenste subselectie. Na het klikken van de knop wordt een lijst van objecten getoond. 
                    Bij een berekening kiest men &quot;Geef waarde&quot; en vervolgens de gewenste subselectie. 
                Na het klikken van de knop verschijnt on de de knop het resultaat van de berekening.</p>
                
                <h2>Weergeven van resultaten</h2>
                Voor de gebruiker is de weergave van resultaten van het grootste belang. 
                De objectlijsten in het resultatenpaneel kunnen ge&euml;xporteerd worden naar de computer van de gebruiker. 
                Hiermee kan hij deze resultaten verder verwerken in rapportages.
                <p>De viewer geeft de resultaten op 3 manieren weer. De meeste belangrijke informatie van een object wordt op de basisregel getoond en 
                    is dus direct zichtbaar. Indien er meer informatie beschikbaar is dan kan via de I-knop een nieuw scherm worden gestart 
                met extra informatie.</p>
                <p>Voor enkele thema's is buiten de viewer informatie beschikbaar welke via een webinterface bereikbaar is. 
                Dergelijke informatie kan worden opgevraagd via de link-knop.</p>
                
            </td>
        </tr>
    </table>
    
    <hr>
    <tiles:insert name="loginblock"/>
</div>