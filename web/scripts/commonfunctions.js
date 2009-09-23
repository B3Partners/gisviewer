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
        document.getElementById("popupWindow_Title").innerHTML = 'B3p GIS Viewer popup';
        $("#popupWindow").show();
        if(ieVersion <= 6) fixPopup();
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
        document.getElementById("popupWindow_Title").innerHTML = 'B3p GIS Viewer popup';
        $("#popupWindow").show();
        if(ieVersion <= 6) fixPopup();
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
    if(ieVersion > 4 && ieVersion <= 7) {
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
$(document).ready(function(){
    if(!document.getElementById('popupWindow') && !parent.document.getElementById('popupWindow')) {
        buildPopup();
        $('#popupWindow').draggable({
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
        $('#popupWindow_Close').click(function(){
            dataframepopupHandle.closed = true;
            $("#popupWindow").hide();
        });
        $("#popupWindow").mouseover(function(){startDrag();});
        $("#popupWindow").mouseout(function(){stopDrag();});
        $("#popupWindow").hide();
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
    if(ieVersion > 4 && ieVersion <= 7) fixPopup();
}

function stopResize() {
    document.getElementById('popupWindow_Windowbackground').style.display = 'none';
    document.getElementById('popupWindow_Resizediv').style.display = 'none';
    if(ieVersion > 4 && ieVersion <= 7) fixPopup();
}