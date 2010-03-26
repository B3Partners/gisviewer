/*Hulp functions*/
//contains on array function
function arrayContains(array,element) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == element) {
            return true;
        }
    }
    return false;
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
            top.location = '<html:rewrite page="/index.do"/>';
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

var currentpopupleft = null;
var currentpopuptop = null;
popUp = function(URL, naam, width, height, useDiv) {
    var screenwidth = 600;
    var screenheight = 500;
    var useDivPopup = false;
    if (width){
        screenwidth=width;
    }
    if (height){
        screenheight=height;
    }
    if(useDiv) {
        useDivPopup = useDiv;
    }

    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
    if(currentpopupleft != null) {
        popupleft = currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
    if(currentpopuptop != null) {
        currentpopuptop = popuptop
    }
    
    if(useDivPopup) {
        if(!popupCreated) initPopup();
        document.getElementById("dataframedivpopup").src = URL;
        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';
        $j("#popupWindow").show();
        if(ieVersion <= 6 && ieVersion != -1) fixPopup();
    } else {
        properties = "toolbar = 0, " +
        "scrollbars = 1, " +
        "location = 0, " +
        "statusbar = 1, " +
        "menubar = 0, " +
        "resizable = 1, " +
        "width = " + screenwidth + ", " +
        "height = " + screenheight + ", " +
        "top = " + popuptop + ", " +
        "left = " + popupleft;
        return eval("page" + naam + " = window.open('" + URL + "', '" + naam + "', properties);");
    }
}

popUpData = function(naam, width, height, useDiv) {
    var screenwidth = 600;
    var screenheight = 500;
    var useDivPopup = false;
    if (width){
        screenwidth=width;
    }
    if (height){
        screenheight=height;
    }
    if(useDiv) {
        useDivPopup = useDiv;
    }

    var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
    if(currentpopupleft != null) {
        popupleft = currentpopupleft;
    }

    var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
    if(currentpopuptop != null) {
        currentpopuptop = popuptop
    }

    if(useDivPopup) {
        if(!popupCreated) initPopup();
        document.getElementById("popupWindow_Title").innerHTML = 'Gisviewer Informatie';
        $j("#popupWindow").show();
        if(ieVersion <= 6 && ieVersion != -1) fixPopup();
        return document.getElementById("dataframedivpopup");
    } else {
        properties = "toolbar = 0, " +
        "scrollbars = 1, " +
        "location = 0, " +
        "statusbar = 1, " +
        "menubar = 0, " +
        "resizable = 1, " +
        "width = " + screenwidth + ", " +
        "height = " + screenheight + ", " +
        "top = " + popuptop + ", " +
        "left = " + popupleft;
        return window.open('', naam, properties);
    }
}

buildPopup = function() {
    var popupDiv = document.createElement('div');
    popupDiv.styleClass = 'popup_Window';
    popupDiv.id = 'popupWindow';
    var popupHandle = document.createElement('div');
    popupHandle.styleClass = 'popup_Handle';
    popupHandle.id = 'popupWindow_Handle';
    var popupTitle = document.createElement('div');
    popupTitle.className = 'popup_Title';
    popupTitle.id = 'popupWindow_Title';
    var popupClose = document.createElement('a');
    popupClose.className = 'popup_Close';
    popupClose.id = 'popupWindow_Close';
    popupClose.href = '#';
    popupClose.innerHTML = '[ x ]';
    popupHandle.appendChild(popupTitle);
    popupHandle.appendChild(popupClose);
    popupDiv.appendChild(popupHandle);
    var popupContent = document.createElement('div');
    popupContent.styleClass = 'popup_Content';
    popupContent.id = 'popupWindow_Content';
    var popupIframe = null;
    if(ieVersion <= 7 && ieVersion != -1) {
        popupIframe = document.createElement('<iframe name="dataframedivpopup">');
    } else {
        popupIframe = document.createElement('iframe');
        popupIframe.name = 'dataframedivpopup';
    }
    popupIframe.styleClass = 'popup_Iframe';
    popupIframe.id = 'dataframedivpopup';
    popupIframe.src = '';
    var popupResizediv = document.createElement('div');
    popupResizediv.id = 'popupWindow_Resizediv';
    popupContent.appendChild(popupIframe);
    popupContent.appendChild(popupResizediv);
    popupDiv.appendChild(popupContent);

    var popupWindowBackground = document.createElement('div');
    popupWindowBackground.styleClass = 'popupWindow_Windowbackground';
    popupWindowBackground.id = 'popupWindow_Windowbackground';

    document.body.appendChild(popupDiv);
    document.body.appendChild(popupWindowBackground);
}

var popupCreated = false;
$j(document).ready(function(){
    if(!document.getElementById('popupWindow') && !parent.document.getElementById('popupWindow')) {
        buildPopup();
        $j('#popupWindow').draggable({
            handle:    '#popupWindow_Handle',
            iframeFix: true,
            zIndex: 200,
            containment: 'document',
            start: function(event, ui) { startDrag(); },
            stop: function(event, ui) { stopDrag(); }
        }).resizable({
            handles: 'se',
            start: function(event, ui) { startResize(); },
            stop: function(event, ui) { stopResize(); }
        });
        $j('#popupWindow_Close').click(function(){
            dataframepopupHandle.closed = true;
            $j("#popupWindow").hide();
        });
        $j("#popupWindow").mouseover(function(){startDrag();});
        $j("#popupWindow").mouseout(function(){stopDrag();});
        $j("#popupWindow").hide();
    }
    popupCreated = true;
});

function findPos(obj) {
    var curleft = curtop = 0;
    if (obj.offsetParent) {
        do {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
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
function showLoading(parentdiv) {
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
}

function hideLoading() {
    if(loadingDivCounter > 0)
        loadingDivCounter--;

    if(loadingDivCounter == 0)
        $j('#loadingDiv').hide();
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