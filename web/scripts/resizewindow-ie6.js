function resizeViewer() {  
    resizeViewerIE6();
}

function resizeViewerIE6() {
    document.getElementById("content_div").style.width = getAvail('width') + 'px';
    var totalwidth = removePx(document.getElementById("content_div").style.width);
    var rightwidth = document.getElementById("rightdiv").offsetWidth + 6;
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
    var totalheight = getAvail('height') - 46; //23 afh. van ontwerp
    document.getElementById("content_div").style.height = totalheight + 'px';
    var totalheight = removePx(document.getElementById("content_div").style.height);
    var top = document.getElementById("topmenu").offsetHeight + document.getElementById("onderbalk_viewer").offsetHeight + 13;
    var bottom = document.getElementById("dataframediv").offsetHeight + document.getElementById("onderbalk_details").offsetHeight + 13;
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
    document.getElementById('treevak').style.height = (tabvakheight - 8) + 'px';
    document.getElementById('layermaindiv').style.height = (tabvakheight - 20) + 'px';
    document.getElementById('volgordevak').style.height = (tabvakheight - 31) + 'px';
    document.getElementById('orderLayerBox').style.height = (tabvakheight - 106) + 'px';
    document.getElementById('infovak').style.height = (tabvakheight - 10) + 'px';
    document.getElementById('objectframe').style.height = tabvakheight + 'px';
    document.getElementById('objectvak').style.height = tabvakheight + 'px';
    document.getElementById('analysevak').style.height = tabvakheight + 'px';
    document.getElementById('analyseframe').style.height = tabvakheight + 'px';
}

function resizeAdmindata(noOfRows, noOfKolommen, totale_breedte) {
    document.getElementById('admin_data_content_div').style.width = getAvail('width') + 'px';
    var totalwidth = getAvail('width');
    var totalkolomwidth = document.getElementById("volgnr_th").offsetWidth;
    for(i = 1; i < noOfKolommen + 1; i++) {
        var objId = 'header_kolom_item' + i;
        var kolombreedte = document.getElementById(objId).offsetWidth
        if(noOfKolommen == i) {
            var obj = document.getElementById(objId);
            obj.style.width = (totale_breedte - totalkolomwidth) + 'px';
            kolombreedte = totale_breedte - totalkolomwidth;
        }
        totalkolomwidth = parseInt(totalkolomwidth) + parseInt(kolombreedte);
    }
    var objId = 'header_kolom_item' + noOfKolommen;
    var lastitemwidth = (totalwidth - totalkolomwidth) + document.getElementById(objId).offsetWidth;
    document.getElementById(objId).style.width = lastitemwidth + 'px';
    
    var footerwidth = lastitemwidth - 25;
    for(i = 1; i < (noOfRows + 1); i++) {
        var objId = 'footer_last_item' + i;
        document.getElementById(objId).style.width = footerwidth + 'px';
    }
}

function getAvail(dir) {
    var myWidth = 0, myHeight = 0;
    
    if( typeof( window.innerWidth ) == 'number' ) {
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }

    if(dir == 'width') return myWidth;
    else return myHeight;
}

function removePx(str) {
    return str.substring(0,str.length-2);
}