/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */
var widthMinus = 33;
function resizeViewer() {
    document.getElementById("content_div").style.width = (getAvail('width') - widthMinus) + 'px';
    var totalwidth = document.getElementById("content_div").offsetWidth;
    var rightwidth = document.getElementById('rightdiv').offsetWidth + 6;
    var flashcontentwidth = totalwidth - rightwidth;
    
    // Het is nodig ze allen te specificeren om geen scrollbars te krijgen, 100% werkt niet
    document.getElementById('maindiv').style.width = totalwidth + 'px';
    document.getElementById('content_div').style.width = totalwidth + 'px';
    document.getElementById('content_div').style.paddingLeft = '0px';
    document.getElementById('content_div').style.paddingRight = '0px';
    document.getElementById('content_div').style.backgroundImage = 'none';
    document.getElementById('content_div').style.backgroundColor = 'White';
    document.getElementById('onderbalk_viewer').style.width = (totalwidth - 15) + 'px';
    document.getElementById('onderbalk_details').style.width = (totalwidth - 15) + 'px';    
    document.getElementById('onder_div').style.width = totalwidth + 'px';
    document.getElementById('dataframediv').style.width = (totalwidth - 2) + 'px';
    document.getElementById('dataframe').style.width = (totalwidth - 2) + 'px';
    document.getElementById('map').style.width = flashcontentwidth + 'px';
    document.getElementById('flashcontent').style.width = flashcontentwidth + 'px';
    document.getElementById('flamingo').style.width = flashcontentwidth + 'px';
    
    document.getElementById('topmenu').className = 'topmenu_viewer';

    document.getElementById('onder_div').style.display = 'none';
    document.getElementById('dataframediv').style.marginBottom = '0px';
    var totalheight = getAvail('height') - 40; //17 afh. van ontwerp
    var top = document.getElementById('topmenu').offsetHeight + document.getElementById('onderbalk_viewer').offsetHeight;
    var bottom = document.getElementById('dataframediv').offsetHeight + document.getElementById('onderbalk_details').offsetHeight + 9;
    var flashcontentheight = totalheight - top - bottom;
    var contentdivheight = totalheight - top;
    
    document.getElementById('maindiv').style.height = contentdivheight + 'px';
    document.getElementById('content_div').style.height = contentdivheight + 'px';
    document.getElementById('bovenkant').style.height = flashcontentheight + 'px';
    document.getElementById('map').style.height = flashcontentheight + 'px';
    document.getElementById('flashcontent').style.height = flashcontentheight + 'px';
    document.getElementById('flamingo').style.height = flashcontentheight + 'px';
    document.getElementById('rightdiv').style.height = flashcontentheight + 'px';
    
    var tabvakheight = flashcontentheight - 20;
    document.getElementById('tab_container').style.height = tabvakheight + 'px';
    document.getElementById('treevak').style.height = (tabvakheight - 6) + 'px';
    document.getElementById('layermaindiv').style.height = (tabvakheight - 18) + 'px';
    document.getElementById('volgordevak').style.height = (tabvakheight - 12) + 'px';
    document.getElementById('orderLayerBox').style.height = (tabvakheight - 87) + 'px';
    document.getElementById('infovak').style.height = (tabvakheight - 6) + 'px';
    document.getElementById('objectframe').style.height = tabvakheight + 'px';
    document.getElementById('objectvak').style.height = tabvakheight + 'px';
    document.getElementById('analysevak').style.height = tabvakheight + 'px';
    document.getElementById('analyseframe').style.height = tabvakheight + 'px';
    
    widthMinus = 0;
}

function resizeAdmindata(noOfRows, noOfKolommen, totale_breedte) {
    document.getElementById('admin_data_content_div').style.width = getAvail('width') + 'px';
    var totalwidth = getAvail('width');
    var totalkolomwidth = document.getElementById('volgnr_th').offsetWidth;
    for(i = 1; i < noOfKolommen + 1; i++) {
        var objId = 'header_kolom_item' + i;
        if(noOfKolommen == i) {
            document.getElementById(objId).style.width = (totale_breedte - totalkolomwidth) + 'px';
        }
        var totalkolomwidth = totalkolomwidth + document.getElementById(objId).offsetWidth;
    }
    var objId = 'header_kolom_item' + noOfKolommen;
    var lastitemwidth = totalwidth - totalkolomwidth;
    document.getElementById(objId).style.width = document.getElementById(objId).offsetWidth + lastitemwidth + 'px';
    
    var footerwidth = document.getElementById(objId).offsetWidth - 25;
    for(i = 1; i < (noOfRows + 1); i++) {
        var objId = 'footer_last_item' + i;
        document.getElementById(objId).style.width = footerwidth + 'px';
    }
}

function getAvail(dir) {
    var x,y;
    if (self.innerHeight) { // all except Explorer, lengte en breedte iets van af halen om ook goed te scalen in Firefox
            x = self.innerWidth;
            y = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
            x = document.documentElement.clientWidth;
            y = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
            x = document.body.clientWidth;
            y = document.body.clientHeight;
    }
    if(dir == 'width') return x;
    else return y;
}