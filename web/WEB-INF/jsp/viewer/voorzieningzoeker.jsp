<%-- 
    Document   : voorzieningzoeker
    Created on : Nov 1, 2010, 1:17:53 PM
    Author     : Jytte
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type='text/javascript' src='dwr/interface/JZoeker.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

<div style="margin: 5px;">
    <div>
        <div>
            Zoek voorzieningen als volgt:
            <ul>
                <li>kies op welke manier u het adres wil zoeken
                <li>voer (een deel van) het adres in
                <li>voer maximale afstand tot voorziening in
                <li>voer het soort voorziening in
                <li>klik op zoeken
                <li>kies het juiste adres uit lijst
                <li>kies de gewenste voorziening uit lijst
            </ul>
        </div>
        <div id="voorzieningConfigurationsContainer"></div>
        <div id="voorzieningInputFieldsContainer"></div>
        <div id="locatieBlok" style="display:none;">
            Klik op de locatie die u bedoelt:
            <div id="locatieResults">

            </div>
        </div>
        <div id="geenLocatieBlok" style="display:none;">
            Er zijn geen locaties gevonden.
        </div>

        <div id="voorzieningBlok" style="display:none;">
            Klik op de voorziening die u bedoelt:
            <div id="voorzieningResults">

            </div>
        </div>
        <div id="geenResultaatBlok" style="display:none;">
            Er zijn geen voorzieningen gevonden in het door u opgegeven zoekgebied.
        </div>

    </div>
</div>
<script type="text/javascript" src="scripts/voorzieningzoeker.js"></script>