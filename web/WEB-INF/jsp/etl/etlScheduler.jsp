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
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<div id="extractHome">
    <h1>Extract</h1>
    <div class="kop">Takenlijst</div>
    <div class="listItemKop">
        <div class="listItemDatum"><strong>Datum</strong></div>
        <div class="listItemTijd"><strong>Tijd</strong></div>
        <div class="listItemProces"><strong>Proces</strong></div>
        <div class="listItemStart"><strong>Start handmatig</strong></div>
    </div>
    <div class="listItem">
        <div class="listItemDatum">Iedere 4e dag van de maand</div>
        <div class="listItemTijd">02:00</div>
        <div class="listItemProces">Geo Data - Weg</div>
        <div class="listItemStart"><button>Start Proces</button></div>
    </div>
    <div class="listItem">
        <div class="listItemDatum">Iedere 2e dag van de week</div>
        <div class="listItemTijd">12:00</div>
        <div class="listItemProces">ViaView - Verharding</div>
        <div class="listItemStart"><button>Start Proces</button></div>
    </div>
    <div class="listItem" style="border-bottom: 1px solid Black;">
        <div class="listItemDatum">Iedere 16e dag van de maand</div>
        <div class="listItemTijd">19:00</div>
        <div class="listItemProces">GB PLANtsoen - Sloot</div>
        <div class="listItemStart"><button>Start Proces</button></div>
    </div>
    
    <div class="kop">Log</div>
    <div class="listLogItemKop">
        <div class="listLogItemDatum"><strong>Datum</strong></div>
        <div class="listLogItemProces"><strong>Proces</strong></div>
        <div class="listLogItemGekoppeld"><strong>Gekoppeld</strong></div>
        <div class="listLogItemOud"><strong>Oud</strong></div>
        <div class="listLogItemNieuw"><strong>Nieuw</strong></div>
    </div>
    <div class="listLogItem">
        <div class="listLogItemDatum">04-11-2006</div>
        <div class="listLogItemProces">Geo Data - Weg</div>
        <div class="listLogItemGekoppeld">254</div>
        <div class="listLogItemOud">19</div>
        <div class="listLogItemNieuw">23</div>
    </div>
    <div class="listLogItem">
        <div class="listLogItemDatum">28-11-2006</div>
        <div class="listLogItemProces">VieView - Verharding</div>
        <div class="listLogItemGekoppeld">24</div>
        <div class="listLogItemOud">2</div>
        <div class="listLogItemNieuw">1</div>
    </div>
    <div class="listLogItem">
        <div class="listLogItemDatum">16-11-2006</div>
        <div class="listLogItemProces">GB PLANtsoen - Sloot</div>
        <div class="listLogItemGekoppeld">568</div>
        <div class="listLogItemOud">55</div>
        <div class="listLogItemNieuw">26</div>
    </div>
</div>
<div id="transformHome">
    <h1>Transform</h1>
    <div class="kop">Status</div>
    <div class="listLogItemKop">
        <div class="listLogItemDatum"><strong>Datum</strong></div>
        <div class="listLogItemProces" style="width: 250px;"><strong>Proces</strong></div>
        <div class="listLogItemGekoppeld"><strong>Gekoppeld</strong></div>
        <div class="listLogItemOud"><strong>Oud</strong></div>
        <div class="listLogItemNieuw"><strong>Nieuw</strong></div>
        <div class="listLogItemNieuw"><strong>Parkeren</strong></div>
        <div class="listLogItemNieuw" style="width: 100px;"><strong>Def. Ontkoppeld</strong></div>
        <div class="listItemStart"><strong>Start Proces</strong></div>
    </div>
    <div class="listLogItem">
        <div class="listLogItemDatum">29-11-2006</div>
        <div class="listLogItemProces" style="width: 250px;">GB PLANtsoen - Sloot</div>
        <div class="listLogItemGekoppeld">254</div>
        <div class="listLogItemOud">19</div>
        <div class="listLogItemNieuw">23</div>
        <div class="listLogItemNieuw">45</div>
        <div class="listLogItemNieuw" style="width: 100px;">8</div>
        <div class="listItemStart"><button onclick="javascript:location.href='etltransform.do';">Start Proces</button></div>
    </div>
    <div class="listLogItemGray" style="border-bottom: 1px solid Black;">
        <div class="listLogItemDatum">27-11-2006</div>
        <div class="listLogItemProces" style="width: 250px;">VieView - Verharding</div>
        <div class="listLogItemGekoppeld">24</div>
        <div class="listLogItemOud">2</div>
        <div class="listLogItemNieuw">1</div>
        <div class="listLogItemNieuw">0</div>
        <div class="listLogItemNieuw" style="width: 100px;">0</div>
        <div class="listItemStart">&nbsp;</div>
    </div>
    
    <div class="kop"><nobr>Gegevens beheerders</nobr></div>
    <div class="listItemKop">
        <div class="listItemNaam"><strong>Naam</strong></div>
        <div class="listLogItemProces"><strong>Laatste actie</strong></div>
        <div class="listItemNaam"><strong>Aantal openstaande items</strong></div>
    </div>
    <div class="listItem">
        <div class="listItemNaam">Beheerder Geo Data &amp; GB PLANtsoen</div>
        <div class="listLogItemProces">Transformeren van Geo Data - Weg</div>
        <div class="listItemNaam">0</div>
    </div>
    <div class="listItem">
        <div class="listItemNaam">Beheerder ViaView</div>
        <div class="listLogItemProces">Niets</div>
        <div class="listItemNaam">855</div>
    </div>
</div>
<div id="loadHome">
    <h1>Load</h1>
    <div class="kop">Takenlijst</div>
    <div class="listItemKop">
        <div class="listItemDatum"><strong>Datum</strong></div>
        <div class="listItemTijd"><strong>Tijd</strong></div>
        <div class="listItemProces"><strong>Proces</strong></div>
        <div class="listItemStart"><strong>Start handmatig</strong></div>
    </div>
    <div class="listItem" style="border-bottom: 1px solid Black;">
        <div class="listItemDatum">Iedere 19e dag van de maand</div>
        <div class="listItemTijd">02:00</div>
        <div class="listItemProces">Geo Data - Weg</div>
        <div class="listItemStart"><button>Start Proces</button></div>
    </div>
    
    <div class="kop">Log</div>
    <div class="listLogItemKop">
        <div class="listLogItemDatum"><strong>Datum</strong></div>
        <div class="listLogItemProces"><strong>Proces</strong></div>
        <div class="listLogItemGekoppeld"><strong>Gekoppeld</strong></div>
        <div class="listLogItemOud"><strong>Oud</strong></div>
        <div class="listLogItemNieuw"><strong>Nieuw</strong></div>
    </div>
    <div class="listLogItem">
        <div class="listLogItemDatum">13-09-2006</div>
        <div class="listLogItemProces">Geo Data - weg</div>
        <div class="listLogItemGekoppeld">422</div>
        <div class="listLogItemOud">48</div>
        <div class="listLogItemNieuw">59</div>
    </div>
</div>