function createAdminQ() {
    if (document.getElementById('admin_query_text')!=undefined){
        if(document.getElementById('admin_query_text').value == '') {
            var admin_tabel = document.getElementById('admin_tabel_select').options[document.getElementById('admin_tabel_select').selectedIndex].value;
            var admin_pk = document.getElementById('admin_pk_select').options[document.getElementById('admin_pk_select').selectedIndex].value;
            var query = 'select * from "' + admin_tabel + '" where "' + admin_pk + '" = ?';
            document.getElementById('admin_query_text').value = query;
        }
    }
}

function showHelp(obj) {
    var helpDiv = obj.nextSibling;
    showHideDiv(helpDiv);
    return false;
}

var prevOpened = null;
function showHideDiv(obj) {
    var iObj = document.getElementById('iframeBehindHelp');
    if(prevOpened != null) {
        prevOpened.style.display = 'none';
        iObj.style.display = 'none';
    }
    if(prevOpened != obj) {
        prevOpened = obj;
        if(obj.style.display != 'block') {
            obj.style.display = 'block';
            var objPos = findPos(obj);
            iObj.style.width = obj.offsetWidth + 'px';
            iObj.style.height = obj.offsetHeight + 'px';
            iObj.style.left = objPos[0] + 'px';
            iObj.style.top = objPos[1] + 'px';
            iObj.style.display = 'block';
        } else {
            obj.style.display = 'none';
        }
    }
}

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

function hoverRow(obj) {
    obj.className += ' regel_over';
}

var pattern = new RegExp("\\bregel_over\\b");
function hoverRowOut(obj) {
    obj.className = obj.className.replace(pattern, '');
}
function refreshFeatureList(element){
    currentConnectionType=connectionTypes[element.value];
    JConfigListsUtil.getPossibleFeaturesById(element.value,handleFeatureList);
}
function handleFeatureList(list){
    if (currentConnectionType=="jdbc"){
        document.getElementById('jdbcRows').className="tbodyshow";
    }else{
        document.getElementById('jdbcRows').className="tbodyhide";
    }
    dwr.util.removeAllOptions('admin_tabel_select');
    dwr.util.removeAllOptions('spatial_tabel_select');
    dwr.util.removeAllOptions('admin_pk_select');
    dwr.util.removeAllOptions('spatial_pk_select');
    dwr.util.removeAllOptions('spatial_adminref_select');
    dwr.util.addOptions("admin_tabel_select",[""]);
    dwr.util.addOptions("spatial_tabel_select",[""]);
    dwr.util.addOptions("admin_tabel_select",list);
    dwr.util.addOptions("spatial_tabel_select",list);
}
function refreshAdminAttributeList(element){
    var connid=document.getElementById('connectie_select').value;
    JConfigListsUtil.getPossibleAttributesById(connid,element.value,handleAdminAttributeList);
}
function handleAdminAttributeList(list){
    dwr.util.removeAllOptions('admin_pk_select');
    dwr.util.addOptions("admin_pk_select",[""]);
    dwr.util.addOptions("admin_pk_select",list);
}
function refreshSpatialAttributeList(element){
    var connid=document.getElementById('connectie_select').value;
    JConfigListsUtil.getPossibleAttributesById(connid,element.value,handleSpatialAttributeList);
}
function handleSpatialAttributeList(list){
    dwr.util.removeAllOptions('spatial_pk_select');
    dwr.util.addOptions('spatial_pk_select',[""]);
    dwr.util.addOptions('spatial_pk_select',list);
    dwr.util.removeAllOptions('spatial_adminref_select');
    dwr.util.addOptions('spatial_adminref_select',[""]);
    dwr.util.addOptions('spatial_adminref_select',list);
}
function refreshTheLists(){
    document.forms[0].refreshLists.value="do";
    document.forms[0].submit();
}