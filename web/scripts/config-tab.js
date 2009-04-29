createTabs = function(containerid) {
    var container = document.getElementById(containerid);
    var tabheaders = container.childNodes;
    for(var i=0; i<tabheaders.length; i++) {
        if(tabheaders[i].nodeName.toUpperCase() == 'DIV') {
            tabheaders[i].onclick = function() { switchTab(this); }
        }
    }
}

var currenttab = null;
var currenttabheader = null;
switchTab = function(obj) {
    if(currenttab != null) {
        currenttab.style.display = 'none';
    }
    if(currenttabheader != null) {
        currenttabheader.className = currenttabheader.className.replace(/ active_tab/, '');
    }
    var contentid = obj.id.replace(/header/, 'content');
    var tab = document.getElementById(contentid);
    tab.style.display = 'block';
    obj.className = obj.className + ' active_tab';
    currenttab = tab;
    currenttabheader = obj;
}

firstTab = function(objid) {
    // Insert cookiefunctions here
    switchTab(document.getElementById(objid));
}