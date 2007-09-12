<%@taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div id="content_style">
    
    <hr size="1" style="color: Black;" width="100%" />
    
    <img src="images/logo.gif" border="0" alt="Logo Noord Brabant" class="nbr" />
    
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <h1>Korte beschrijving van WIS Demo</h1>
                
                <div>
                    <h2>Introductie</h2>
                    WIS demo is gebouwd om gebruikers in staat te stellen invloed te hebben op het ontwerpproces. Op basis van de vele gesprekken en beschikbare informatie is deze demo gebouwd. Het is dus uitdrukkelijk de bedoeling dat iedere ge&iuml;nteresseerde na deze bijeenkomst zelf deze demo gaat gebruiken.<br /><br />
                    Deze demo staat op een testserver, welke soms wordt herstart. Als er even geen contact mogelijk is, dan verzoeken jullie het later nog een keer te proberen. Verder is de demo op dit moment nog niet volledig robuust en er treden soms &quot;verbindingsfouten&quot; op.
                </div>
                <h2>Hoofdelementen van het WIS</h2>
                Het WIS bestaat uit een kaart, een paneel met tabbladen waarmee het WIS wordt bestuurd en vlak met resultaten.
                <p>De kaart kan met de gebruikelijke knoppen bestuurd worden. Er ontbreekt nog zeker een knop, namelijk: export van kaartuitsnede naar formaat van keuze.</p>
                <p>Het besturingspaneel kent nu 4 tabbladen: Thema's, Legenda, Zoeker, Gebieden en Analyse.</p>
                
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
                        <td><a href="#thema">Thema's</a>, <a href="#legenda">Legenda</a>, <a href="#lokatie">Zoeker</a>, <a href="#gebieden">Gebieden</a> en <a href="#analyse">Analyse</a>.</td>
                    </tr>
                </table>
                
                <a name="thema"></a><h2>Tabblad Thema's</h2>
                <strong>Kaarten zichtbaar maken</strong><br />
                Het tabblad Thema's bestaat uit een uitklapbare boomstructuur met alle selecteerbare thema's. Indien een thema nog geen vinkvak heeft dan is de onderliggende dataset nog niet aangemaakt. De gebruiker kan de thema's aan en uitzetten; de kaart wordt dan ververst. Het laatst aangevinkte thema komt altijd bovenop.
                <p>De ACN en percelen kaartlaag zijn alleen zichtbaar wanneer ingezoomd om overmatige serverbelasting te voorkomen.</p>
                
                <p>
                    <strong>Kaartlaaginformatie</strong><br />
                    De themanaam is een link naar projectdata van de kaartlaag. Hier wordt de MoSCoW status vermeld, de geselecteerde bronapplicaties, een beschrijving van de administratieve data en de verantwoordelijke medewerkers en afdelingen.
                </p>
                
                <p>
                    <strong>Actieve kaartlaag</strong><br />
                    Door het selecteren van een kaartlaag wordt deze kaartlaag actief en vervolgacties hebben betrekking op die kaartlaag
                </p>
            </td>
            <td valign="top">
                <a name="lokatie"></a><h2>Tabblad Lokatie</h2>
                Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de lokatie-informatie op: RD x,y co&ouml;rdinaten, WOL/HM aanduiding en adres.
                <p>Voor medewerkers die gewend zijn de WOL/HM aanduiding te gebruiken, kan hier altijd deze informatie worden opgevraagd.</p>
                
                <a name="gebieden"></a><h2>Tabblad Gebieden</h2>
                Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de gebieden op waarin het klikpunt zich bevindt. Per kaarlaag kan aangegeven worden of dit een gebied betreft dat in deze lijst moet worden opgenomen.
                <p>Deze gebieden kunnen later bij de analyse worden gebruikt.</p>
                
                <a name="analyse"></a><h2>Tabblad Analyse</h2>
                Via het tabblad Analyse kunnen geografische selecties en berekeningen gedaan worden. De analyse heeft altijd betrekking op de actieve kaartlaag zoals deze onder tab Thema's is gekozen. Objecten van dit thema kunnen verder worden beperkt door extra criteria op te nemen (nog niet functioneel).
                <p>Vervolgens kan opgegeven worden voor welk gebied de analyse moet worden uitgevoerd. Dit is een van de gebieden zoals bepaald onder de tab gebieden. Bij de analyse worden dus alle objecten meegenomen van de actieve kaartlaag welke liggen in het gebied van keuze.</p>
                <p>Tenslotte dient aangegeven te worden of de gebruiker een selectie of een berekening wil uitvoeren. Bij een selectie kiest men &quot;Geef object&quot; en de gewenste subselectie. Na het klikken van de knop wordt een lijst van objecten getoond. Bij een berekening kiest men &quot;Geef waarde&quot; en vervolgens de gewenste subselectie. Na het klikken van de knop verschijnt on de de knop het resultaat van de berekening.</p>
                <p>De werking van deze tab is nog niet volledig afgewerkt: berekende waarden blijven soms staan en de selectie criteria verdwijnen soms.</p>
                
                <h2>Weergeven van resultaten</h2>
                Voor de gebruiker is de weergave van resultaten van het grootste belang. De objectlijsten in het resultatenvlak zullen ge&euml;xporteerd kunnen worden naar de computer van de gebruiker. Hiermee kan het deze resultaten verder verwerken in rapportages.
                <p>Het WIS geeft de resultaten op 3 manieren weer. De meeste belangrijke informatie van een object wordt op de basisregel getoond en is dus direct zichtbaar. Indien er meer informatie beschikbaar is binnen het WIS dan kan via de I-knop een nieuw scherm worden gestart met extra informatie.</p>
                <p>Voor enkele thema's (en dit worden er steeds meer) is buiten het WIS informatie beschikbaar welke via een webinterface bereikbaar is. Dergelijke informatie kan worden opgevraagd via de link-knop.</p>
                
            </td>
        </tr>
    </table>
    
    <hr size="1" style="color: Black;" width="100%" />
</div>