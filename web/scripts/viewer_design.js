var resizableTabs = new Array();
var checkResizableContent = function() {
    for(i in tabbladen) {
        
        var tabid = tabbladen[i].id;
        var contentid = tabbladen[i].contentid;
        var tabcontent = document.getElementById(contentid);
        if(tabcontent) var tabChilds = tabcontent.childNodes;
        for(i in tabChilds) {
            if(tabChilds[i].className != undefined && tabChilds[i].className.search('tabvak_groot') != -1) {
                resizableTabs[resizableTabs.length] = tabid;
                resizableTabs[resizableTabs.length] = contentid;
            }
        }
    }
}

resizeTabContents = function() {
    var tmpCurrentActiveTab = currentActiveTab;
    var totalTabHeight = document.getElementById('tab_container').offsetHeight - 30; // Minus margin
    for(var i = 0; i < resizableTabs.length; i++) {
        switchTab(document.getElementById(resizableTabs[i]));
        i = i+1;
        var tabcontent = document.getElementById(resizableTabs[i]);
        var tabChilds = tabcontent.childNodes;
        var totalContentsHeight = 0;
        for(j in tabChilds) {
            if(tabChilds[j].className != undefined && tabChilds[j].className.search('tabvak_groot') != -1) {
                var childToResize = tabChilds[j];
            } else {
                if(!isNaN(tabChilds[j].offsetHeight)) totalContentsHeight += tabChilds[j].offsetHeight;
            }
        }
        if(ieVersion != -1 && ieVersion <= 7) totalContentsHeight += 15;
        if(childToResize && childToResize.style) {
            var childContentHeight = totalTabHeight - totalContentsHeight;
            if(childContentHeight >= 0) childToResize.style.height = childContentHeight + 'px';
        }
    }
    if(tmpCurrentActiveTab != null) switchTab(document.getElementById(tmpCurrentActiveTab));
}
$j(document).ready(function() {
	checkResizableContent();
	resizeTabContents();
});
attachOnresize(resizeTabContents);