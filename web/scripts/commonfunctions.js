function arrayContains(array,element) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == element) {
            return true;
        }
    }
    return false;
}

function getParent() {
    if (window.opener){
        return window.opener;
    }else if (window.parent){
        return window.parent;
    }else{
        return window;
    }
}

// jQuery gives problems with DWR - util.js, so noConflict mode. Usage for jQuery selecter becomes $j() instead of $()
$j = jQuery.noConflict();

attachOnload = function(onloadfunction) {
    if(typeof(onloadfunction) == 'function') {
        var oldonload=window.onload;
        if(typeof(oldonload) == 'function') {
            window.onload = function() {
                oldonload();
                onloadfunction();
            }
        } else {
            window.onload = function() {
                onloadfunction();
            }
        }
    }
}

var resizeFunctions = new Array();

resizeFunction = function() {
    for(i in resizeFunctions) {
        resizeFunctions[i]();
    }
}

window.onresize = resizeFunction;

attachOnresize = function(onresizefunction) {
    if(typeof(onresizefunction) == 'function') {
        resizeFunctions[resizeFunctions.length] = onresizefunction;
        /* var oldonresize=window.onresize;
        if(typeof(oldonresize) == 'function') {
            window.onresize = function() {
                oldonresize();
                onresizefunction();
            }
        } else {
            window.onresize = function() {
                onresizefunction();
            }
        } */
    }
}

checkLocation = function() {
    if (top.location != self.location)
        top.location = self.location;
}

checkLocationPopup = function() {
   if(!usePopup) {
        if (top.location == self.location) {
            top.location = '/gisviewer/index.do';
        }
    }
}

getIEVersionNumber = function() {
    var ua = navigator.userAgent;
    var MSIEOffset = ua.indexOf("MSIE ");
    if (MSIEOffset == -1) {
        return -1;
    } else {
        return parseFloat(ua.substring(MSIEOffset + 5, ua.indexOf(";", MSIEOffset)));
    }
}

var ieVersion = getIEVersionNumber();

function findPos(obj) {
    var curleft = curtop = 0;
    if (obj.offsetParent) {
        do {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
        } while (obj == obj.offsetParent);
    }
    return [curleft,curtop];
}

function startDrag() {
    document.getElementById('popupWindow_Windowbackground').style.display = 'block';
}

function stopDrag() {
    document.getElementById('popupWindow_Windowbackground').style.display = 'none';
}

function startResize() {
    document.getElementById('popupWindow_Windowbackground').style.display = 'block';
    document.getElementById('popupWindow_Resizediv').style.display = 'block';
    if(ieVersion <= 7 && ieVersion != -1) fixPopup();
}

function stopResize() {
    document.getElementById('popupWindow_Windowbackground').style.display = 'none';
    document.getElementById('popupWindow_Resizediv').style.display = 'none';
    if(ieVersion <= 7 && ieVersion != -1) fixPopup();
}

function showHelpDialog(divid) {
    $j("#" + divid).dialog({
        resizable: true,
        draggable: true,
        show: 'slide',
        hide: 'slide'
    });
    $j("#" + divid).dialog('open');
    return false;
}

var loadingDivCounter = 0;
var loadingTimer = null;
function showLoading(parentdiv) {
    if(loadingTimer != null) clearTimeout(loadingTimer);
    if(!document.getElementById('loadingDiv')) {
        var loadingDiv = document.createElement('div');
        loadingDiv.id = 'loadingDiv';
        loadingDiv.innerHTML = 'Bezig met laden<br /><img src="images/icons/loading.gif" border="0" alt="laadbalk">';
        document.body.appendChild(loadingDiv);
    }
    if (parentdiv){
        var pos = findObjectCenter(parentdiv);
        $j('#loadingDiv').css({left: pos[1], top: pos[0]});
    }else{
        $j('#loadingDiv').css({left: "50%", top: "50%", marginLeft: "-175px", marginTop: "-30px"});

    }

    loadingDivCounter++;
    $j('#loadingDiv').show();

    loadingTimer = setTimeout("removeLoading()", 90000);
}

function hideLoading() {
    if(loadingDivCounter > 0)
        loadingDivCounter--;

    if(loadingDivCounter == 0)
        $j('#loadingDiv').hide();
}

function removeLoading() {
    $j('#loadingDiv').hide();
    loadingDivCounter = 0;
}

function findObjectCenter(objectid) {
    var obj = $j('#'+objectid);
    var offset = obj.offset();
    var width = obj.width();
    var height = obj.height();
    var top = offset.top + (height / 2);
    var left = offset.left + (width / 2);
    
    return [top, left];
}


var prevpopup;
function iFramePopup(url, newpopup, title, width, height) {
    if(!newpopup) newpopup = false;
    if(!title) title = "";
    if(!width) width = 300;
    if(!height) height = 300;

    var showdiv = null;
    if(newpopup || prevpopup == null) {
        var $div = $j('<div></div>').width(width).height(height).css("background-color", "#ffffff");
        var $iframe = $j('<iframe></iframe>').attr({
            src: url,
            frameborder: 0
        }).css({
            border: "0px none",
            width: "95%",
            height: "95%"
        });
        $div.append($iframe);
        if(!newpopup) {
            prevpopup = $div;
            showdiv = prevpopup;
        } else {
            showdiv = $div;
        }
    } else {
        prevpopup.find('iframe').attr("src", url);
        showdiv = prevpopup;
    }

    showdiv.dialog({
        resizable: true,
        draggable: true,
        show: 'slide',
        hide: 'slide',
        title: title,
        containment: 'document',
        iframeFix: true,
        dragStart: function(event, ui) {startDrag();},
        dragStop: function(event, ui) {stopDrag();},
        resizeStart: function(event, ui) {startResize();},
        resizeStop: function(event, ui) {stopResize();}
    });
    showdiv.dialog("option", "title", title);
    showdiv.dialog("option", "height", height);
    showdiv.dialog("option", "width", width);
    showdiv.dialog('open');
}

function closeiFramepopup() {
    prevpopup.dialog('close');
}