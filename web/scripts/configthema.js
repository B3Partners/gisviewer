function createAdminQ() {
    if (document.getElementById('admin_query_text')!=undefined){
        if(currentConnectionType == 'jdbc'){
            if(document.getElementById('admin_query_text').value == '') {
                var admin_tabel = document.getElementById('admin_tabel_select').options[document.getElementById('admin_tabel_select').selectedIndex].value;
                var admin_pk = document.getElementById('admin_pk_select').options[document.getElementById('admin_pk_select').selectedIndex].value;
                var query = 'select * from "' + admin_tabel + '" where "' + admin_pk + '" = ?';
                document.getElementById('admin_query_text').value = query;
            }
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

function hoverRow(obj) {
    obj.className += ' regel_over';
}

var pattern = new RegExp("\\bregel_over\\b");
function hoverRowOut(obj) {
    obj.className = obj.className.replace(pattern, '');
}
function refreshFeatureList(element){
    if (connectionTypes){
        if (connectionTypes[element.value]){
            currentConnectionType=connectionTypes[element.value];
        }
    }
    var value=element.value;
    if (value=="kb"){
        value="";
    }
    JConfigListsUtil.getPossibleFeaturesById(value,handleFeatureList);
}
function handleFeatureList(list){
    showHideJDBC();
    dwr.util.removeAllOptions('admin_tabel_select');
    dwr.util.removeAllOptions('spatial_tabel_select');
    dwr.util.removeAllOptions('admin_pk_select');
    dwr.util.removeAllOptions('spatial_pk_select');
    dwr.util.removeAllOptions('spatial_adminref_select');
    dwr.util.addOptions("admin_tabel_select",[""]);
    dwr.util.addOptions("spatial_tabel_select",[""]);
    dwr.util.addOptions("admin_tabel_select",list,"0","1");
    dwr.util.addOptions("spatial_tabel_select",list,"0","1");
}
function showHideJDBC() {
    //Er voor zorgen dat het tabblad geavanceerd wordt gehide en in gegevens bron adminquery onzichtbaar wordt
    //als thema wfs is (!="jdbc" )
    if (currentConnectionType=="jdbc"){
        document.getElementById('tab-geavanceerd-header').style.display = "block";
        document.getElementById('adminqueryrow').style.display = "block";
        document.getElementById('admin_query_text').style.display = "block";
    } else {
        document.getElementById('tab-geavanceerd-header').style.display = "none";
        document.getElementById('adminqueryrow').style.display = "block";
        document.getElementById('admin_query_text').style.display = "block";
    }
}
function refreshAdminAttributeList(element){
    var connid=document.getElementById('connectie_select').value;
    JConfigListsUtil.getPossibleAttributesById(connid,element.value,handleAdminAttributeList);
    if (element.value!=undefined && element.value.length > 0){
        document.getElementById("wms_querylayers_real").disabled=true;
        document.getElementById("wms_querylayers_real").value="";
    }else{
        document.getElementById("wms_querylayers_real").disabled=false;
    }
}
function handleAdminAttributeList(list){
    dwr.util.removeAllOptions('admin_pk_select');
    dwr.util.addOptions("admin_pk_select",[""]);
    dwr.util.addOptions("admin_pk_select",list,"0","1");
}
function refreshSpatialAttributeList(element){
    var connid=document.getElementById('connectie_select').value;
    JConfigListsUtil.getPossibleAttributesById(connid,element.value,handleSpatialAttributeList);
}
function handleSpatialAttributeList(list){
    dwr.util.removeAllOptions('spatial_pk_select');
    dwr.util.addOptions('spatial_pk_select',[""]);
    dwr.util.addOptions('spatial_pk_select',list,"0","1");
    dwr.util.removeAllOptions('spatial_adminref_select');
    dwr.util.addOptions('spatial_adminref_select',[""]);
    dwr.util.addOptions('spatial_adminref_select',list,"0","1");
}
function refreshTheLists(){
    document.forms[0].refreshLists.value="do";
    document.forms[0].submit();
}