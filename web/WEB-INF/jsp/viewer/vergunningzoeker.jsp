<%-- 
    Document   : vergunnningzoeker
    Created on : Nov 1, 2010, 1:17:34 PM
    Author     : Jytte
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type='text/javascript' src='dwr/interface/JZoeker.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>

<div style="padding: 5px;">
    <div>
        <div>
            Zoek vergunningen als volgt:
            <ul>
                <li>kies op welke manier u het adres wil zoeken
                <li>voer (een deel van) het adres in
                <li>klik op zoeken
                <li>kies het juiste adres uit lijst
                <li>voer maximale afstand tot vergunning in
                <li>voer het soort voorziening in
                <li>kies de gewenste vergunning uit lijst
            </ul>
        </div>
        <div id="vergunningConfigurationsContainer" style="padding-bottom: 10px; margin-bottom: 10px;"></div>
        <div id="vergunningInputFieldsContainer"></div>
        <br>
        <div class="searchResultsClass" id="vergunningResults"></div>
    </div>
</div>
<script type="text/javascript" src="scripts/vergunningzoeker.js"></script>
<script type="text/javascript">
    $j(document).ready(function() {
        createSearchConfigurations();
    })
</script>
