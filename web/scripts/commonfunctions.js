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
    var currentWindow = self;
    var startLocation = self.location;

    try {
        do {
            var tmpWindow = currentWindow.parent;
            if (tmpWindow.location!=""
                && tmpWindow.location != currentWindow.location) {
                currentWindow = tmpWindow;
            } else {
                break;
            }
         } while (true);
    } catch(err) {
        // access denied: cross domain in iframe
    }

    if (currentWindow.location != startLocation) {
        currentWindow.location = startLocation;
    }
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

var uiBlocked = false;
function blockViewerUI() {
    if(!uiBlocked) {
        $j('#content_viewer, #header').block({
            message: null,
            baseZ: 100,
            css: {
                cursor: 'auto'
            },
            overlayCSS: {
                backgroundColor: '#000',
                opacity: 0.3,
                cursor: 'auto'
            }
        });
        uiBlocked = true;
    }
}

function unblockViewerUI() {
    // small timeout to prevent accidental mouseclicks
    if(uiBlocked) {
        setTimeout(function() {
            $j('#content_viewer, #header').unblock();
            uiBlocked = false;
        }, 30);
    }
}

function startDrag() {
    // $j("#popupWindow_Windowbackground").show();
    blockViewerUI();
}

function stopDrag() {
    // $j("#popupWindow_Windowbackground").hide();
    unblockViewerUI();
}

function startResize() {
    // $j("#popupWindow_Windowbackground").show();
    blockViewerUI();
    $j("#popupWindow_Resizediv").show();
    if(ieVersion <= 7 && ieVersion != -1) fixPopup();
}

function stopResize() {
    // $j("#popupWindow_Windowbackground").hide();
    unblockViewerUI();
    $j("#popupWindow_Resizediv").hide();
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

function adjustLoadingCounter(adjustment) {
    loadingDivCounter+=adjustment;
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
/*Opens a dialogpopup. DialogOptions is extra jquery.dialog options*/
var lightBoxPopUp=null;
function dialogPopUp(innerJqueryElement,title,width,height,dialogOptions){      
    innerJqueryElement.width("100%").height("95%");
    if(!title) title = "";
    if(!width) width = 300;
    if(!height) height = 300;

    var options={resizable: true,
        draggable: true,
        show: 'slide',
        hide: 'slide',
        title: title,
        containment: 'document',
        iframeFix: true
    };
    if (dialogOptions){
        for (var key in dialogOptions){
            options[key]=dialogOptions[key];
        }
    }

    if (lightBoxPopUp!=null){
        lightBoxPopUp.dialog('close');
    }
    lightBoxPopUp = $j('<div></div>').width(width).height(height).css("background-color", "#ffffff");
    lightBoxPopUp.append(innerJqueryElement);
    lightBoxPopUp.dialog(options);
    lightBoxPopUp.dialog("option", "title", title);
    lightBoxPopUp.dialog("option", "height", height);
    lightBoxPopUp.dialog("option", "width", width);
    lightBoxPopUp.dialog('open');    
    return lightBoxPopUp;
}

var prevpopup;
function iFramePopup(url, newpopup, title, width, height, blockviewer, showScrollbars) {
    if(!newpopup) newpopup = false;
    if(!title) title = "";
    if(!width) width = 300;
    if(!height) height = 300;
    if(!blockviewer) blockviewer = false;
    
    var showdiv = null;
    if(newpopup || prevpopup == null) {
        var $div = $j('<div></div>').width(width).height(height).css("background-color", "#ffffff");
        var $iframe = $j('<iframe></iframe>').attr({
            src: url,
            frameBorder: 0
        }).css({
            border: "0px none",
            width: "100%",
            height: "99%"
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

    var dialogOptions = {
        resizable: showScrollbars,
        draggable: true,
        show: 'slide',
        hide: 'slide',
        title: title,
        containment: 'document',
        autoOpen: false
    };
    if(!blockviewer) {
        dialogOptions.dragStart = function(event, ui) {startDrag();};
        dialogOptions.dragStop = function(event, ui) {stopDrag();};
        dialogOptions.resizeStart = function(event, ui) {startResize();};
        dialogOptions.resizeStop = function(event, ui) {stopResize();};
    } else {
        dialogOptions.close = function(event, ui) {unblockViewerUI();};
    }
    showdiv.dialog(dialogOptions);
    showdiv.dialog("option", "title", title);
    showdiv.dialog("option", "height", height);
    showdiv.dialog("option", "width", width);    
        
    if (!showScrollbars) {
        showdiv.find('iframe').attr("scrolling", "no");
    } else {
        showdiv.find('iframe').attr("scrolling", "yes");
    }

    showdiv.dialog('open');

    if (ieVersion != -1 && ieVersion <= 7) {
        showdiv.find('iframe').load(function (){
            $j(this).width((width-30) + 'px');
            $j(this).height((height-30) + 'px');

            $j(this).css('height', (height-50) + 'px');
            $j(this).css('width', (width-40) + 'px');
        });
    }
    
    if(blockviewer) blockViewerUI();
}

function closeDialogPopup(){
    dialogPopup.dialog('close');
}

function closeiFramepopup() {
    prevpopup.dialog('close');
    unblockViewerUI();
}

var $messageDialog = null;
var messageDialogCreated = false;
/* msgType = (help, information, error) */
function messagePopup(title, message, msgType) {
    if(!messageDialogCreated) {
        $messageDialog = $j('<div></div>')
        .html('<div class="msgIcon" style="float: left; padding: 10px;"></div><div class="msgText" style="float: left; padding: 10px; padding-left: 0px;"></div>')
        .dialog({
            autoOpen: false,
            resizable: false,
            buttons: [
                {
                    text: "Sluiten",
                    click: function() {$j(this).dialog("close");}
                }
            ]
        });
        
        // Center sluiten button
        $j(".ui-dialog-buttonpane").css({
            "text-align": "center",
            "border": "0px none",
            "padding-left": "0px",
            "padding-right": "0px"
        });
        $j(".ui-dialog-buttonpane button, .ui-dialog-buttonset").css({
            "float": "none",
            "margin-left": "0px",
            "margin-right": "0px"
        }).find("span").html("Sluiten");
        messageDialogCreated = true;
    }
    if(msgType) $messageDialog.find(".msgIcon").html('<img src="images/icons/'+msgType+'.png" alt="'+msgType+'" />');
    $messageDialog.find(".msgText").html(message);
    $messageDialog.dialog("option", "title", title);
    $messageDialog.dialog('open');
}