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
<%@ page isELIgnored="false"%>

<div style="padding: 5px;">
    <div class="messages">
        <html:messages id="message" message="true" >
            <div id="error_tab">
                <c:out value="${message}" escapeXml="false"/>
            </div>
        </html:messages>
        <html:messages id="message" name="acknowledgeMessages">
            <div class="acknowledge_tab">
                <c:out value="${message}"/>
            </div>
        </html:messages>
    </div>

    <p>${tekenTekstBoven}</p>

    <img src="${tekenPlaatje}"/>

    <p>${tekenTekstOnder}</p>

    <p>
        <input type="button" value="Nieuw" id="teken_add_new" />
        <input type="button" value="Selecteer" id="teken_select_feature" />
    </p>
    
    <h3>Filter</h3>
    
    <p>Filter de objecten in de kaart.</p>
        
    <p>
        <input type="text" id="teken_filter_value" size="20" /> 
        <input type="button" value="Filter" id="teken_filter_features" />
        <input type="button" value="Reset" id="teken_filter_all_features" />
    </p>

    <div id="multipleResults" style="width: 100%;"/>

</div>
<script type='text/javascript' src='dwr/interface/JEditFeature.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/components/Teken.js"/>"></script>
<script>
    B3PGissuite.createComponent('Teken', {
        title: "${tekenTitel}",
        gegevensbron: "${tekenGegevensbron}"
    });
</script>