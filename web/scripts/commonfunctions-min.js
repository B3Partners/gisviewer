$j=jQuery.noConflict();
(function(){window.B3PGissuite={component:{},instances:{},idregistry:{},vars:{},config:{},events:{},commons:{ieVersion:null,uiBlocked:false,loadingDivCounter:0,loadingTimer:null,lightBoxPopUp:null,prevpopup:null,messageDialog:null,messageDialogCreated:false,initialize:function(){this.initPolyfills();$j(document).ready(function(){window.dwr&&window.dwr.engine&&window.dwr.engine.setErrorHandler(B3PGissuite.commons.dwrErrorHandler)})},initPolyfills:function(){if(!String.prototype.trim)String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g,
"")}},dwrErrorHandler:function(a){a!==""&&B3PGissuite.commons.messagePopup("Fout",a,"information")},arrayContains:function(a,b){for(var c=0;c<a.length;c++)if(a[c]==b)return true;return false},getParent:function(a){try{if(window.opener&&window.opener.document&&window.opener.document.getElementById)return window.opener;else if(window.parent)return window.parent}catch(b){}return a&&a.hasOwnProperty("parentOnly")&&a.parentOnly?((!a||!a.hasOwnProperty("supressError")||!a.supressError)&&this.messagePopup("Fout",
"No parent found","error"),null):window},attachOnload:function(a){$j(document).ready(a)},checkLocation:function(){var a=self,b=self.location;try{do{var c=a.parent;if(c.location!==""&&c.location!=a.location)a=c;else break}while(1)}catch(d){}if(a.location!=b)a.location=b},checkLocationPopup:function(a){if(!a&&top.location==self.location)top.location="/gisviewer/index.do"},getIEVersion:function(){if(this.ieVersion===null){var a=navigator.userAgent,b=a.indexOf("MSIE ");this.ieVersion=b==-1?-1:parseFloat(a.substring(b+
5,a.indexOf(";",b)))}return this.ieVersion},findPos:function(a){var b=0,c=0;if(a.offsetParent){do b+=a.offsetLeft,c+=a.offsetTop;while(a==a.offsetParent)}return[b,c]},blockViewerUI:function(){if(!this.uiBlocked)$j("#content_viewer, #header").block({message:null,baseZ:100,css:{cursor:"auto"},overlayCSS:{backgroundColor:"#000",opacity:0.3,cursor:"auto"}}),this.uiBlocked=true},unblockViewerUI:function(){this.uiBlocked&&setTimeout(function(){$j("#content_viewer, #header").unblock();this.uiBlocked=false},
30)},startDrag:function(){this.blockViewerUI()},stopDrag:function(){this.unblockViewerUI()},startResize:function(){this.blockViewerUI();$j("#popupWindow_Resizediv").show()},stopResize:function(){this.unblockViewerUI();$j("#popupWindow_Resizediv").hide()},showLoading:function(a){var b=this;this.loadingTimer!==null&&clearTimeout(this.loadingTimer);if(!document.getElementById("loadingDiv")){var c=document.createElement("div");c.id="loadingDiv";c.innerHTML='Bezig met laden<br /><img src="images/icons/loading.gif" border="0" alt="laadbalk">';
document.body.appendChild(c)}a?(a=this.findObjectCenter(a),$j("#loadingDiv").css({left:a[1],top:a[0]})):$j("#loadingDiv").css({left:"50%",top:"50%",marginLeft:"-175px",marginTop:"-30px"});this.loadingDivCounter++;$j("#loadingDiv").show();this.loadingTimer=setTimeout(function(){b.removeLoading()},9E4)},hideLoading:function(){this.loadingDivCounter>0&&this.loadingDivCounter--;this.loadingDivCounter===0&&$j("#loadingDiv").hide()},removeLoading:function(){$j("#loadingDiv").hide();this.loadingDivCounter=
0},findObjectCenter:function(a){var b=$j("#"+a),a=b.offset(),c=b.width(),b=b.height();return[a.top+b/2,a.left+c/2]},dialogPopUp:function(a,b,c,d,e){a.width("100%").height("95%");b||(b="");c||(c=300);d||(d=300);var h={resizable:true,draggable:true,show:"slide",hide:"slide",title:b,containment:"document",iframeFix:true};if(e)for(var i in e)h[i]=e[i];lightBoxPopUp!==null&&lightBoxPopUp.dialog("close");lightBoxPopUp=$j("<div></div>").width(c).height(d).css("background-color","#ffffff");lightBoxPopUp.append(a);
lightBoxPopUp.dialog(h);lightBoxPopUp.dialog("option","title",b);lightBoxPopUp.dialog("option","height",d);lightBoxPopUp.dialog("option","width",c);lightBoxPopUp.dialog("open");return lightBoxPopUp},iFramePopup:function(a,b,c,d,e,h,i){b||(b=false);c||(c="");d||(d=300);e||(e=300);h||(h=false);var f=null;if(b||this.prevpopup===null){var g=$j("<div></div>").width(d).height(e).css("background-color","#ffffff"),a=$j("<iframe></iframe>").attr({src:a,frameBorder:0}).css({border:"0px none",width:"100%",height:"99%"});
g.append(a);f=b?g:this.prevpopup=g}else this.prevpopup.find("iframe").attr("src",a),f=this.prevpopup;b={resizable:i,draggable:true,show:"slide",hide:"slide",title:c,containment:"document",autoOpen:false};h?b.close=function(){B3PGissuite.commons.unblockViewerUI()}:(b.dragStart=function(){B3PGissuite.commons.startDrag()},b.dragStop=function(){B3PGissuite.commons.stopDrag()},b.resizeStart=function(){B3PGissuite.commons.startResize()},b.resizeStop=function(){B3PGissuite.commons.stopResize()});f.dialog(b);
f.dialog("option","title",c);f.dialog("option","height",e);f.dialog("option","width",d);i?f.find("iframe").attr("scrolling","yes"):f.find("iframe").attr("scrolling","no");f.dialog("open");this.getIEVersion()!=-1&&this.getIEVersion()<=7&&f.find("iframe").load(function(){$j(this).width(d-30+"px");$j(this).height(e-30+"px");$j(this).css("height",e-50+"px");$j(this).css("width",d-40+"px");setTimeout(function(){f.dialog("option","height",e)},0)});h&&this.blockViewerUI()},closeiFramePopup:function(){this.prevpopup.dialog("close");
this.unblockViewerUI()},messagePopup:function(a,b,c){if(!this.messageDialogCreated)this.messageDialog=$j("<div></div>").html('<div class="msgIcon" style="float: left; padding-top: 20px; margin-right: 10px;"></div><div class="msgText" style="float: left; padding-top: 20px;"></div>').dialog({autoOpen:false,resizable:false,buttons:[{text:"Sluiten",click:function(){$j(this).dialog("close")}}]}),$j(".ui-dialog-buttonpane").css({"text-align":"center",border:"0px none","padding-left":"0px","padding-right":"0px"}),
$j(".ui-dialog-buttonpane button, .ui-dialog-buttonset").css({"float":"none","margin-left":"0px","margin-right":"0px"}).find("span").html("Sluiten"),this.messageDialogCreated=true;c&&this.messageDialog.find(".msgIcon").html('<img src="images/icons/'+c+'.png" alt="'+c+'" />');this.messageDialog.find(".msgText").html(b);this.messageDialog.dialog("option","title",a);this.messageDialog.dialog("open")},createCookie:function(a,b,c){if(c){var d=new Date;d.setTime(d.getTime()+c*864E5);c="; expires="+d.toGMTString()}else c=
"";document.cookie=a+"="+b+c+"; path=/"},readCookie:function(a){a+="=";for(var b=document.cookie.split(";"),c=0;c<b.length;c++){for(var d=b[c];d.charAt(0)==" ";)d=d.substring(1,d.length);if(d.indexOf(a)===0)return d.substring(a.length,d.length)}return null},eraseCookie:function(a){this.createCookie(a,"",-1)},flashCheck:function(){var a=window,b=document,c=navigator,b=typeof b.getElementById!="undefined"&&typeof b.getElementsByTagName!="undefined"&&typeof b.createElement!="undefined",d=c.userAgent.toLowerCase(),
e=c.platform.toLowerCase(),h=e?/win/.test(e):/win/.test(d),e=e?/mac/.test(e):/mac/.test(d),d=/webkit/.test(d)?parseFloat(d.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")):false,i=!+"\u000b1",f=[0,0,0],g=null;if(typeof c.plugins!="undefined"&&typeof c.plugins["Shockwave Flash"]=="object"){if((g=c.plugins["Shockwave Flash"].description)&&!(typeof c.mimeTypes!="undefined"&&c.mimeTypes["application/x-shockwave-flash"]&&!c.mimeTypes["application/x-shockwave-flash"].enabledPlugin))i=false,g=g.replace(/^.*\s+(\S+\s+\S+$)/,
"$1"),f[0]=parseInt(g.replace(/^(.*)\..*$/,"$1"),10),f[1]=parseInt(g.replace(/^.*\.(.*)\s.*$/,"$1"),10),f[2]=/[a-zA-Z]/.test(g)?parseInt(g.replace(/^.*[a-zA-Z]+(.*)$/,"$1"),10):0}else if(typeof a.ActiveXObject!="undefined")try{var j=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");if(j&&(g=j.GetVariable("$version")))i=true,g=g.split(" ")[1].split(","),f=[parseInt(g[0],10),parseInt(g[1],10),parseInt(g[2],10)]}catch(k){}return{w3:b,pv:f,wk:d,ie:i,win:h,mac:e}},whichTransitionEvent:function(){var a,
b=document.createElement("fakeelement"),c={transition:"transitionend",OTransition:"oTransitionEnd",MozTransition:"transitionend",WebkitTransition:"webkitTransitionEnd"};for(a in c)if(b.style[a]!==void 0)return c[a];return null},attachTransitionListener:function(a,b){var c=this.whichTransitionEvent();c!==null&&a.addEventListener(c,b,false)},showHelpDialog:function(a){$j("#"+a).dialog({resizable:true,draggable:true,show:"slide",hide:"slide"});$j("#"+a).dialog("open");return false},adjustLoadingCounter:function(a){this.loadingDivCounter+=
a},closeDialogPopup:function(){this.lightBoxPopUp!==null&&this.lightBoxPopUp.dialog("close")}}};B3PGissuite.commons.initialize()})();B3PGissuite.createComponent=function(a,b){if(typeof B3PGissuite.component[a]==="undefined")throw"The class "+a+" is not defined. Maybe you forgot to include the source file?";typeof B3PGissuite.idregistry[a]==="undefined"&&(B3PGissuite.idregistry[a]=0);var c=B3PGissuite.idregistry[a]++,c=a.charAt(0).toLowerCase()+a.slice(1)+c;B3PGissuite.instances[c]=new B3PGissuite.component[a](b||{});return B3PGissuite.instances[c]};
B3PGissuite.defineComponent=function(a,b){B3PGissuite.component[a]=b.constructor;B3PGissuite.component[a].prototype=b;if(b.extend)B3PGissuite.component[a].prototype=jQuery.extend(B3PGissuite.createComponent(b.extend),B3PGissuite.component[a].prototype),B3PGissuite.component[a].prototype.constructor=B3PGissuite.component[a],B3PGissuite.component[a].prototype.callParent=function(a){a=jQuery.extend(b.defaultOptions||{},a);B3PGissuite.component[b.extend].call(this,a)};B3PGissuite.component[a].prototype.fireEvent=
function(c,b){if(B3PGissuite.events.hasOwnProperty(a)&&B3PGissuite.events[a].hasOwnProperty(c))for(var e=0;e<B3PGissuite.events[a][c].length;e++){var h=B3PGissuite.events[a][c][e];h.handler.call(h.scope,b)}};B3PGissuite.component[a].prototype.addListener=function(a,b,e,h){B3PGissuite.events.hasOwnProperty(a)||(B3PGissuite.events[a]={});B3PGissuite.events[a].hasOwnProperty(b)||(B3PGissuite.events[a][b]=[]);B3PGissuite.events[a][b].push({handler:e,scope:h||this})};b.hasOwnProperty("singleton")&&b.singleton&&
B3PGissuite.createComponent(a)};B3PGissuite.get=function(a,b){var c;c=a.charAt(0).toLowerCase()+a.slice(1)+(b||0);return typeof B3PGissuite.instances[c]==="undefined"?null:B3PGissuite.instances[c]};