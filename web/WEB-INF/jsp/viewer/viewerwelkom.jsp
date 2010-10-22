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

<div id="content_style" style="margin-top: -10px;">
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <div class="inleiding">
                    <h2>B3P GIS Suite</h2>
                    <p>
                        Deze B3P GIS Suite toont de mogelijkheden van de GIS viewer. 
                        Op deze plaats vindt u later korte informatie en uitleg over
                        het actieve thema van de kaart. Ook kunnen hier een logo en andere
                        lay-out elementen van de opdrachtgever verwerkt worden.
                    </p>
                </div>
           </td>
            <td valign="top">               
                <h2>Actief Thema</h2>
                <p>
                    Het actieve thema wordt rechts getoond in de titelbalk hierboven. U kunt
                    informatie opvragen door met de informatie-tool in de kaart te klikken.
                    Deze informatie verschijnt dan hier. Via zoeken of zoomen navigeert u eerst
                    naar het juiste deel van de kaart. Voor meer hulp klik <html:link page="/help.do" module="">Help</html:link>
                </p>
           </td>
        </tr>
    </table>
</div>
