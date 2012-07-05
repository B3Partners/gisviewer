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

    <!-- Loop door tekstblokken heen -->
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="content_block">
            <div class="content_title"><c:out value="${tb.titel}"/></div>

            <!-- Indien toonUrl aangevinkt is dan inhoud van url in iFrame tonen -->
            <c:if test="${tb.toonUrl}">
                <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
            </c:if>

            <!-- Anders gewoon de tekst tonen van tekstblok -->
            <c:if test="${!tb.toonUrl}">
            <div class="inleiding_body">
                ${tb.tekst}

                <c:if test="${!empty tb.url}">
                Meer informatie: <a href="${tb.url}" target="_new">${tb.url}</a>
                </c:if>

                <c:if test="${tb.toonUrl}">
                    <iframe id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                </c:if>
            </div>
            </c:if>
        </div>
    </c:forEach>

    <!-- Gewone help pagina tonen als er geen tekstblokken zijn -->
    <c:if test="${empty tekstBlokken}">
        <table class="kolomtabel">
            <tr>
                <td valign="top">
                    <tiles:insert definition="actionMessages"/>
                    <h1>Help</h1>

                    <h2>Hoofdelementen van de GIS Viewer</h2>
					De GIS viewer bestaat uit een kaart met bovenin navigatie knoppen, een aantal tools en rechts een paneel met
					tabbladen Kaarten, Legenda en Zoeken.

                    <a name="thema"></a><h2>Tabblad Kaarten</h2>
					<strong>Kaarten zichtbaar maken</strong><br>
					Het tabblad Kaarten bestaat uit een uitklapbare boomstructuur met alle selecteerbare
					kaartlagen. Indien een kaartlaag geen vinkvak heeft dan is de onderliggende dataset niet aangemaakt. 
					De gebruiker kan de kaartlagen en groepen aan en uitzetten; de kaart wordt dan ververst.
					
					<p>Sommige kaartlagen zijn pas zichtbaar vanaf een bepaald zoomniveau om overmatige serverbelasting te voorkomen. 
					Dit is ook afhankelijk van de achterliggende dataset/service.</p>
					
					<p>
					<strong>Kaartlaaginformatie</strong><br>
					De kaartlaagnaam in de boom kan een link bevatten naar een metadata pagina.
					</p>

                    <a name="legenda"></a><h2>Tabblad Legenda</h2>
                    Het tabblad legenda bestaat uit een paneel waarop u alle actieve kaartlagen kunt vinden. Bij deze 
					kaartlagen is een afbeelding geplaatst waarop u kunt zien hoe u de betreffende kaartlaag op de kaart
					kunt onderscheiden.
                </td>
				
                <td valign="top">
                    <a name="zoeker"></a><h2>Tabblad Zoeken</h2>
					Via het zoeken tabblad kunt u zoeken op adressen binnen de BAG. Als u een straatnaam en/of huisnummer
					invult krijgt u onder het zoekveld een lijst met resultaten. Als u klikt op een van deze resultaten zoomt de
					viewer naar de bijbehorende locatie. Als er maar 1 resultaat gevonden is zoomt de viewer direct.
                </td>
            </tr>
        </table>
    </c:if>
</div>
