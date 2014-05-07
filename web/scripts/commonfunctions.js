// jQuery gives problems with DWR - util.js, so noConflict mode. Usage for jQuery selecter becomes $j() instead of $()
$j = jQuery.noConflict();
// Start B3PGissuite functions
(function() {

    /* B3PGissuite namespace */
    window.B3PGissuite = {
        component: {},
        instances: {},
        idregistry: {},
        vars: {},
        config: {},
        events: {},
        commons: {
            /* vars */
            ieVersion: null,
            uiBlocked: false,
            loadingDivCounter: 0,
            loadingTimer: null,
            lightBoxPopUp: null,
            prevpopup: null,
            messageDialog: null,
            messageDialogCreated: false,
            /*
            Initialize function
             */
            initialize: function() {
                this.initPolyfills();
                $j(document).ready(function() {
                    if(window.dwr && window.dwr.engine) {
                        window.dwr.engine.setErrorHandler(B3PGissuite.commons.dwrErrorHandler);
                    }
                });
            },

            initPolyfills: function() {
                // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
                if (!String.prototype.trim) {
                    String.prototype.trim = function () {
                        return this.replace(/^\s+|\s+$/g, '');
                    };
                }
            },

            dwrErrorHandler: function(msg) {
                if (msg !== '') {
                    B3PGissuite.commons.messagePopup("Fout", msg, "information");
                }
            },

            /* functions */
            arrayContains: function(array,element) {
                for (var i = 0; i < array.length; i++) {
                    if (array[i] == element) {
                        return true;
                    }
                }
                return false;
            },
            getParent: function(options) {
                // When the application is started from a link with a target (_blank) then window.opener
                // will be set to that original page. In this case it is not possible to access the document.
                // In this case we do not return the opener
                try {
                    if (window.opener && window.opener.document && window.opener.document.getElementById){
                        return window.opener;
                    }else if (window.parent){
                        return window.parent;
                    }
                } catch(e) {}
                if(options && options.hasOwnProperty('parentOnly') && options.parentOnly) {
                    if(!(options && options.hasOwnProperty('supressError') && options.supressError)) {
                        this.messagePopup("Fout", "No parent found", "error");
                    }
                    return null;
                }
                return window;
            },
            attachOnload: function(onloadfunction) {
                $j(document).ready(onloadfunction);
            },
            checkLocation: function() {
                var currentWindow = self;
                var startLocation = self.location;

                try {
                    do {
                        var tmpWindow = currentWindow.parent;
                        if (tmpWindow.location !== "" && tmpWindow.location != currentWindow.location) {
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
            },
            checkLocationPopup: function(usePopup) {
               if(!usePopup) {
                    if (top.location == self.location) {
                        top.location = '/gisviewer/index.do';
                    }
                }
            },
            getIEVersion: function() {
                if(this.ieVersion === null) {
                    var ua = navigator.userAgent;
                    var MSIEOffset = ua.indexOf("MSIE ");
                    if (MSIEOffset == -1) {
                        this.ieVersion = -1;
                    } else {
                        this.ieVersion = parseFloat(ua.substring(MSIEOffset + 5, ua.indexOf(";", MSIEOffset)));
                    }
                }
                return this.ieVersion;
            },
            findPos: function(obj) {
                var curleft = 0, curtop = 0;
                if (obj.offsetParent) {
                    do {
                        curleft += obj.offsetLeft;
                        curtop += obj.offsetTop;
                    } while (obj == obj.offsetParent);
                }
                return [curleft,curtop];
            },
            blockViewerUI: function() {
                if(!this.uiBlocked) {
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
                    this.uiBlocked = true;
                }
            },
            unblockViewerUI: function() {
                // small timeout to prevent accidental mouseclicks
                if(this.uiBlocked) {
                    setTimeout(function() {
                        $j('#content_viewer, #header').unblock();
                        this.uiBlocked = false;
                    }, 30);
                }
            },
            startDrag: function() {
                this.blockViewerUI();
            },
            stopDrag: function() {
                this.unblockViewerUI();
            },
            startResize: function() {
                this.blockViewerUI();
                $j("#popupWindow_Resizediv").show();
            },
            stopResize: function() {
                this.unblockViewerUI();
                $j("#popupWindow_Resizediv").hide();
            },
            showLoading: function(parentdiv) {
                var me = this;
                if(this.loadingTimer !== null) {
                    clearTimeout(this.loadingTimer);
                }
                if(!document.getElementById('loadingDiv')) {
                    var loadingDiv = document.createElement('div');
                    loadingDiv.id = 'loadingDiv';
                    loadingDiv.innerHTML = 'Bezig met laden<br /><img src="images/icons/loading.gif" border="0" alt="laadbalk">';
                    document.body.appendChild(loadingDiv);
                }
                if (parentdiv){
                    var pos = this.findObjectCenter(parentdiv);
                    $j('#loadingDiv').css({left: pos[1], top: pos[0]});
                }else{
                    $j('#loadingDiv').css({left: "50%", top: "50%", marginLeft: "-175px", marginTop: "-30px"});

                }

                this.loadingDivCounter++;
                $j('#loadingDiv').show();

                this.loadingTimer = setTimeout(function() {
                    me.removeLoading();
                }, 90000);
            },
            hideLoading: function() {
                if(this.loadingDivCounter > 0)
                    this.loadingDivCounter--;

                if(this.loadingDivCounter === 0) {
                    $j('#loadingDiv').hide();
                }
            },
            removeLoading: function() {
                $j('#loadingDiv').hide();
                this.loadingDivCounter = 0;
            },
            findObjectCenter: function(objectid) {
                var obj = $j('#'+objectid);
                var offset = obj.offset();
                var width = obj.width();
                var height = obj.height();
                var top = offset.top + (height / 2);
                var left = offset.left + (width / 2);

                return [top, left];
            },
            dialogPopUp: function(innerJqueryElement, title, width, height, dialogOptions) {
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

                if (lightBoxPopUp !== null) {
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
            },
            iFramePopup: function(url, newpopup, title, width, height, blockviewer, showScrollbars) {
                if(!newpopup) newpopup = false;
                if(!title) title = "";
                if(!width) width = 300;
                if(!height) height = 300;
                if(!blockviewer) blockviewer = false;

                var showdiv = null;
                if(newpopup || this.prevpopup === null) {
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
                        this.prevpopup = $div;
                        showdiv = this.prevpopup;
                    } else {
                        showdiv = $div;
                    }
                } else {
                    this.prevpopup.find('iframe').attr("src", url);
                    showdiv = this.prevpopup;
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
                    dialogOptions.dragStart = function(event, ui) { B3PGissuite.commons.startDrag(); };
                    dialogOptions.dragStop = function(event, ui) { B3PGissuite.commons.stopDrag(); };
                    dialogOptions.resizeStart = function(event, ui) { B3PGissuite.commons.startResize(); };
                    dialogOptions.resizeStop = function(event, ui) { B3PGissuite.commons.stopResize(); };
                } else {
                    dialogOptions.close = function(event, ui) { B3PGissuite.commons.unblockViewerUI(); };
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

                if (this.getIEVersion() != -1 && this.getIEVersion() <= 7) {
                    showdiv.find('iframe').load(function () {
                        $j(this).width((width-30) + 'px');
                        $j(this).height((height-30) + 'px');

                        $j(this).css('height', (height-50) + 'px');
                        $j(this).css('width', (width-40) + 'px');

                        setTimeout(function() {
                            showdiv.dialog("option", "height", height);
                        }, 0);
                    });
                }

                if(blockviewer) this.blockViewerUI();
            },
            closeiFramePopup: function() {
                this.prevpopup.dialog('close');
                this.unblockViewerUI();
            },
            /* msgType = (help, information, error) */
            messagePopup: function(title, message, msgType) {
                if(!this.messageDialogCreated) {
                    this.messageDialog = $j('<div></div>')
                    .html('<div class="msgIcon" style="float: left; padding-top: 20px; margin-right: 10px;"></div><div class="msgText" style="float: left; padding-top: 20px;"></div>')
                    .dialog({
                        autoOpen: false,
                        resizable: false,
                        buttons: [
                            {
                                text: "Sluiten",
                                click: function() { $j(this).dialog("close"); }
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

                    this.messageDialogCreated = true;
                }

                if(msgType) {
                    var img = '<img src="images/icons/'+msgType+'.png" alt="'+msgType+'" />';
                    this.messageDialog.find(".msgIcon").html(img);
                }

                this.messageDialog.find(".msgText").html(message);
                this.messageDialog.dialog("option", "title", title);
                this.messageDialog.dialog('open');
            },
            createCookie: function(name,value,days) {
                var expires;
                if (days) {
                    var date = new Date();
                    date.setTime(date.getTime()+(days*24*60*60*1000));
                    expires = "; expires="+date.toGMTString();
                }
                else expires = "";
                document.cookie = name+"="+value+expires+"; path=/";
            },
            readCookie: function(name) {
                var nameEQ = name + "=";
                var ca = document.cookie.split(';');
                for(var i=0;i < ca.length;i++) {
                    var c = ca[i];
                    while (c.charAt(0)==' ') c = c.substring(1,c.length);
                    if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length,c.length);
                }
                return null;

            },
            eraseCookie: function(name) {
                this.createCookie(name,"",-1);
            },
            /*
             * Flash detection script, based on SWFobject 2.2
             **/
            flashCheck: function() {

                var UNDEF = "undefined",
                OBJECT = "object",
                SHOCKWAVE_FLASH = "Shockwave Flash",
                SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
                FLASH_MIME_TYPE = "application/x-shockwave-flash",
                EXPRESS_INSTALL_ID = "SWFObjectExprInst",
                ON_READY_STATE_CHANGE = "onreadystatechange",
                win = window,
                doc = document,
                nav = navigator,
                plugin = false;

                var w3cdom = typeof doc.getElementById != UNDEF && typeof doc.getElementsByTagName != UNDEF && typeof doc.createElement != UNDEF,
                        u = nav.userAgent.toLowerCase(),
                        p = nav.platform.toLowerCase(),
                        windows = p ? /win/.test(p) : /win/.test(u),
                        mac = p ? /mac/.test(p) : /mac/.test(u),
                        webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, // returns either the webkit version or false if not webkit
                        ie = !+"\v1", // feature detection based on Andrea Giammarchi's solution: http://webreflection.blogspot.com/2009/01/32-bytes-to-know-if-your-browser-is-ie.html
                        playerVersion = [0,0,0],
                        d = null;
                if (typeof nav.plugins != UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] == OBJECT) {
                        d = nav.plugins[SHOCKWAVE_FLASH].description;
                        if (d && !(typeof nav.mimeTypes != UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
                                plugin = true;
                                ie = false; // cascaded feature detection for Internet Explorer
                                d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
                                playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
                                playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
                                playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
                        }
                }
                else if (typeof win.ActiveXObject != UNDEF) {
                        try {
                                var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
                                if (a) { // a will return null when ActiveX is disabled
                                        d = a.GetVariable("$version");
                                        if (d) {
                                                ie = true; // cascaded feature detection for Internet Explorer
                                                d = d.split(" ")[1].split(",");
                                                playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
                                        }
                                }
                        }
                        catch(e) {}
                }
                return { w3:w3cdom, pv:playerVersion, wk:webkit, ie:ie, win:windows, mac:mac };
            },
            whichTransitionEvent: function() {
                var t;
                var el = document.createElement('fakeelement');
                var transitions = {
                    'transition': 'transitionend',
                    'OTransition': 'oTransitionEnd',
                    'MozTransition': 'transitionend',
                    'WebkitTransition': 'webkitTransitionEnd'
                };

                for (t in transitions) {
                    if (el.style[t] !== undefined) {
                        return transitions[t];
                    }
                }
                return null;
            },
            attachTransitionListener: function(obj, handler) {
                var transitionEnd = this.whichTransitionEvent(),
                        me = this;
                if (transitionEnd === null)
                    return;
                obj.addEventListener(transitionEnd,handler, false);
            },
            /* unused functions, could be removed */
            showHelpDialog: function(divid) {
                $j("#" + divid).dialog({
                    resizable: true,
                    draggable: true,
                    show: 'slide',
                    hide: 'slide'
                });
                $j("#" + divid).dialog('open');
                return false;
            },
            adjustLoadingCounter: function(adjustment) {
                this.loadingDivCounter += adjustment;
            },
            closeDialogPopup: function() {
                if(this.lightBoxPopUp !== null) {
                    this.lightBoxPopUp.dialog('close');
                }
            }
        }
    };
    B3PGissuite.commons.initialize();

})();