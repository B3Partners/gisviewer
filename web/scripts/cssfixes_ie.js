ieFixes = function() {
    fixMenu();
    if(ieVersion <= 6 && ieVersion != -1) {
        fixAbsolutePositions();
        attachOnresize(fixAbsolutePositions);
    }
}
attachOnload(ieFixes);

fixMenu = function() {
    var topmenu = document.getElementById('topmenu');
    var menuitems = topmenu.getElementsByTagName('a');
    var totalmenuwidth = 0;
    var x = 0;
    for(x in menuitems) {
        if(menuitems[x].className == 'activemenulink' || menuitems[x].className == 'menulink') {
            totalmenuwidth += menuitems[x].offsetWidth;
        }
    }
    topmenu.style.width = (totalmenuwidth + 5) + 'px';
}

fixAbsolutePositions = function() {
    var footerheight = 0; var headerheight = 0;
    headerheight = document.getElementById('header').offsetHeight;
    var footer = document.getElementById('footer');
    if(footer) footerheight = footer.offsetHeight;

    var content_viewer = document.getElementById('content_viewer');
    if(content_viewer) {
        content_viewer.style.height = (content_viewer.offsetParent.offsetHeight - headerheight - footerheight) + 'px';
        content_viewer.style.width = (content_viewer.offsetParent.offsetWidth) + 'px';
    }

    var content_normal = document.getElementById('content_normal');
    if(content_normal) {
        content_normal.style.height = (content_normal.offsetParent.offsetHeight - headerheight - footerheight) + 'px';
        if(content_normal.scrollHeight > content_normal.offsetHeight) content_normal.style.marginLeft = '30px;';
    }
    var content = document.getElementById('content');
    if(content) {
        content.style.height = content.offsetParent.offsetHeight + 'px';
        content.style.overflow = 'auto';
    }
    var footer_normal = document.getElementById('footer_normal');
    if(footer_normal) footer_normal.style.bottom = '0px';
    if(footer) footer.style.bottom = '0px';
}

fixPopup = function() {
    if(ieVersion <= 6 && ieVersion != -1) {
        var popupWindow = document.getElementById('popupWindow');
        if(popupWindow) popupHeight = popupWindow.offsetHeight;

        var popupContent = document.getElementById('popupWindow_Content');
        if(popupContent) popupContent.style.height = (popupHeight - 36) + 'px';
    }
}

fixViewer = function() {
    var headerheight = 0;
    headerheight = document.getElementById('header').offsetHeight;

    var content_viewer = document.getElementById('content_viewer');
    var content = document.getElementById('content');
    var viewerinfobalk = document.getElementById('viewerinfobalk');
    var informatiebalk = document.getElementById('informatiebalk');
    var flashcontent = document.getElementById('flashcontent');
    var dataframediv = document.getElementById('dataframediv');
    var tab_container = document.getElementById('tab_container');
    var leftcontent = document.getElementById('leftcontent');
    if(content_viewer) {
        var contentheight = 0; var contentwidth = 0;
        contentheight = content_viewer.offsetParent.offsetHeight - headerheight;
        contentwidth = content_viewer.offsetParent.offsetWidth;
        content_viewer.style.height = contentheight + 'px';

        if(content) {
            content.style.height = content.offsetParent.offsetHeight + 'px';
            content.style.overflow = 'auto';
        }

        if(viewerinfobalk) viewerinfobalk.style.width = (contentwidth - 6) + 'px';
        var tab_container_width = 0;
        if(tab_container) tab_container_width = tab_container.offsetWidth;
        var leftcontent_width = 0;
        if(leftcontent) leftcontent_width = leftcontent.offsetWidth;
        if(usePopup) {
            if(tab_container) {
                tab_container.style.height = (contentheight - 49) + 'px';
            }
            if(leftcontent) {
                leftcontent.style.height = (contentheight - 49) + 'px';
            }
            if(flashcontent) {
                flashcontent.style.width = (contentwidth - ((tab_container_width==0?0:tab_container_width+9)) - ((leftcontent_width==0?0:leftcontent_width+9))) + 'px';
                flashcontent.style.height = (contentheight - 29) + 'px';
            }
       } else {
           if(dataframediv) {
               dataframediv.style.height = dataframehoogte + 'px';
               dataframediv.style.width = viewerinfobalk.style.width = (contentwidth - 6) + 'px';
           }
           if(tab_container) {
               tab_container.style.height = (contentheight - 29 - (dataframehoogte + 49)) + 'px';
           }
           if(leftcontent) {
                leftcontent.style.height = (contentheight - 29 - (dataframehoogte + 29)) + 'px';
            }
           if(flashcontent) {
               flashcontent.style.height = (contentheight - 29 - (dataframehoogte + 29)) + 'px';
               flashcontent.style.width = (contentwidth - ((tab_container_width==0?0:tab_container_width+9)) - ((leftcontent_width==0?0:leftcontent_width+9))) + 'px';
           }
           if(informatiebalk) {
               informatiebalk.style.bottom = (dataframehoogte + 3) + 'px';
               informatiebalk.style.width = (contentwidth - 6) + 'px';
           }
        }
    }
}