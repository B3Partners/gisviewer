<%@taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<p style="margin-top: 50px;">
    <hr size="1" style="color: Black;" width="100%" />
    <table>
        <tr>
            <td>
                <img src="images/logo.gif" border="0" alt="Logo Noord Brabant" />
            </td>
            <td valign="bottom">
                <h1>Korte beschrijving van WIS Demo</h1>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
                <h2 style="MARGIN: 12pt 0cm 3pt"><em>Introductie</em></h2>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">WIS demo is gebouwd om gebruikers in staat te stellen invloed te hebben op het ontwerpproces. Op basis van de vele gesprekken en beschikbare informatie is deze demo gebouwd. Het is dus uitdrukkelijk de bedoeling dat iedere ge&iuml;nteresseerde na deze bijeenkomst zelf deze demo gaat gebruiken.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Deze demo staat op een testserver, welke soms wordt herstart. Als er even geen contact mogelijk is, dan verzoeken<span style="mso-spacerun: yes">&nbsp; </span>jullie het later nog een keer te proberen. Verder is de demo op dit moment nog niet volledig robuust en er treden soms &quot;verbindingsfouten&quot; op.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <h2 style="MARGIN: 12pt 0cm 3pt"><em>Hoofdelementen van het WIS</em></h2>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Het WIS bestaat uit een kaart, een paneel met tabbladen waarmee het WIS wordt bestuurd en vlak met resultaten.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">De kaart kan met de gebruikelijke knoppen bestuurd worden. Er ontbreekt nog zeker een knop, namelijk: export van kaartuitsnede naar formaat van keuze.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Het besturingspaneel kent nu 4 tabbladen: Thema's, Lokatie, Gebieden en Analyse.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <h3 style="MARGIN: 12pt 0cm 3pt">Tabblad Thema's</h3>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><em style="mso-bidi-font-style: normal"><font size="3"><font face="Times New Roman">Kaarten zichtbaar maken<o:p></o:p></font></font></em></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Het tabblad Thema's bestaat uit een uitklapbare boomstructuur met alle selecteerbare thema's. Indien een thema nog geen vinkvak heeft dan is de onderliggende dataset nog niet aangemaakt. De gebruiker kan de thema's aan en uitzetten; de kaart wordt dan ververst. Het laatst aangevinkte thema komt altijd bovenop.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">De ACN en percelen kaartlaag zijn alleen zichtbaar wanneer ingezoomd om overmatige serverbelasting te voorkomen.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><em style="mso-bidi-font-style: normal"><font size="3"><font face="Times New Roman">Kaartlaaginformatie<o:p></o:p></font></font></em></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">De themanaam is een link naar projectdata van de kaartlaag. Hier wordt de MoSCoW status vermeld, de geselecteerde bronapplicaties, een beschrijving van de administratieve data en de verantwoordelijke medewerkers en afdelingen.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><em style="mso-bidi-font-style: normal"><font size="3"><font face="Times New Roman">Actieve kaartlaag<o:p></o:p></font></font></em></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Door het selecteren van een kaartlaag wordt deze kaartlaag actief en vervolgacties hebben betrekking op die kaartlaag</font></p>
                <h3 style="MARGIN: 12pt 0cm 3pt">Tabblad Lokatie</h3>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de lokatie-informatie op: RD x,y co&ouml;rdinaten, WOL/HM aanduiding en adres.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Voor medewerkers die gewend zijn de WOL/HM aanduiding te gebruiken, kan hier altijd deze informatie worden opgevraagd.</font></p>
                <h3 style="MARGIN: 12pt 0cm 3pt">Tabblad Gebieden</h3>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Zodra in de kaart met de Info icoon wordt geklikt, haalt het WIS de gebieden op waarin het klikpunt zich bevindt. Per kaarlaag kan aangegeven worden of dit een gebied betreft dat in deze lijst moet worden opgenomen.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Deze gebieden kunnen later bij de analyse worden gebruikt.</font></p>
                <h3 style="MARGIN: 12pt 0cm 3pt">Tabblad Analyse</h3>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Via het tabblad Analyse kunnen geografische selecties en berekeningen gedaan worden. De analyse heeft altijd betrekking op de actieve kaartlaag zoals deze onder tab Thema's is gekozen. Objecten van dit thema kunnen verder worden beperkt door extra criteria op te nemen (nog niet functioneel).</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Vervolgens kan opgegeven worden voor welk gebied de analyse moet worden uitgevoerd. Dit is een van de gebieden zoals bepaald onder de tab gebieden. Bij de analyse worden dus alle objecten meegenomen van de actieve kaartlaag welke liggen in het gebied van keuze.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Tenslotte dient aangegeven te worden of de gebruiker een selectie of een berekening wil uitvoeren. Bij een selectie kiest men &quot;Geef object&quot; en de gewenste subselectie. Na het klikken van de knop wordt een lijst van objecten getoond. Bij een berekening kiest men &quot;Geef waarde&quot; en vervolgens de gewenste subselectie. Na het klikken van de knop verschijnt on de de knop het resultaat van de berekening.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">De werking van deze tab is nog niet volledig afgewerkt: berekende waarden blijven soms staan en de selectie criteria verdwijnen soms.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <h2 style="MARGIN: 12pt 0cm 3pt"><em>Weergeven van resultaten</em></h2>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Voor de gebruiker is de weergave van resultaten van het grootste belang. De objectlijsten in het resultatenvlak zullen ge&euml;xporteerd kunnen worden naar de computer van de gebruiker. Hiermee kan het deze resultaten verder verwerken in rapportages.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Het WIS geeft de resultaten op 3 manieren weer. De meeste belangrijke informatie van een object wordt op de basisregel getoond en is dus direct zichtbaar. Indien er meer informatie beschikbaar is binnen het WIS dan kan via de I-knop een nieuw scherm worden gestart met extra informatie.</font></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><o:p><font face="Times New Roman" size="3">&nbsp;</font></o:p></p>
                <p class="MsoNormal" style="MARGIN: 0cm 0cm 0pt"><font face="Times New Roman" size="3">Voor enkele thema's (en dit worden er steeds meer) is buiten het WIS informatie beschikbaar welke via een webinterface bereikbaar is. Dergelijke informatie kan worden opgevraagd via de link-knop.</font></p>                <p>
            </td>
        </tr>
    </table>
    <hr size="1" style="color: Black;" width="100%" />
</p>