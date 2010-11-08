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

<div style="margin: 5px;">
    <div id="vergunningConfigurationsContainer"></div>
    <div id="vergunningInputFieldsContainer"></div>
    <div id="locatieBlok" style="display:none;">
        Klik op de locatie die u bedoelt:
        <div id="locatieResults">

        </div>
    </div>
    <div id="geenLocatieBlok" style="display:none;">
        Er zijn geen vergunningen gevonden.
    </div>

    <div id="vergunningBlok" style="display:none;">
        Klik op de vergunningen die u bedoelt:
        <div id="vergunningResults">

        </div>
    </div>
    <div id="geenResultaatBlok" style="display:none;">
        Er zijn geen vergunningen gevonden in het door u opgegeven zoekgebied.
    </div>
    <div id="typeInputFieldsContainer"></div>
    <div id="buttonContainer"></div>
</div>
<script type="text/javascript" src="scripts/vergunningzoeker.js"></script>
