var koppels = new Array();

function koppel() {
    var geoaf = document.getElementById('geoa')[document.getElementById('geoa').selectedIndex];
    var adminaf = document.getElementById('admina')[document.getElementById('admina').selectedIndex];
    
    if(geoaf == undefined || adminaf == undefined) return false;

    var g1 = zoekKoppel(geoaf);
    var a1 = zoekKoppel(adminaf);

    if(g1 != "-1") {
        alert(geoaf.innerHTML + ' is al gekoppeld.');
        return false;
    }

    if(a1 != "-1") {
        alert(adminaf.innerHTML + ' is al gekoppeld.');
        return false;
    }

    var optGeo = moveSelectedOptions(document.getElementById('geoa'),document.getElementById('Ggeoa'),false);
    var optAdm = moveSelectedOptions(document.getElementById('admina'),document.getElementById('Gadmina'),false);

    koppels[koppels.length] = new Array(optGeo, optAdm);
}

function ontkoppel() {
    var geoaf = document.getElementById('Ggeoa')[document.getElementById('Ggeoa').selectedIndex];
    var adminaf = document.getElementById('Gadmina')[document.getElementById('Gadmina').selectedIndex];

    if(geoaf == undefined || adminaf == undefined) return false;

    var k1 = isKoppel(geoaf, adminaf);

    if(k1 == "-1") {
        alert(geoaf.innerHTML + ' en ' + adminaf.innerHTML + ' zijn niet gekoppeld');
        return false;
    }

    koppels[k1] = "-1";
    repairArray();

    moveSelectedOptions(document.getElementById('Ggeoa'),document.getElementById('geoa'),false);
    moveSelectedOptions(document.getElementById('Gadmina'),document.getElementById('admina'),false);
}

function getColor(className) {
    if(className == 'oud') return 'Brown';
    if(className == 'nieuw') return 'Green';
    if(className == 'ontkoppeld') return 'Red';
    if(className == 'parkeren') return 'Orange';
    if(className == 'definitief_ontkoppeld') return 'Gray';
    return 'White';
}

function selecteerGekoppelde(obj) {
    var selObj = obj[obj.selectedIndex];
    var i = zoekKoppel(selObj);
    var anderObj;
    if(i != "-1") {
        var tmpArray = koppels[i];
        if(tmpArray[0] == selObj) {
            anderObj = tmpArray[1];
        } else {
            anderObj = tmpArray[0];
        }
        anderObj.selected = true;
        if(obj.name == 'Ggeoa') dAR(anderObj);
        else if(drawObject()){};
    }
}

function zoekKoppel(obj) {
    for(i = 0; i < koppels.length; i++) {
        tempArray = koppels[i];
        if(tempArray[0] == obj || tempArray[1] == obj) return i;
    }
    return "-1";
}

function isKoppel(obj, obj1) {
    for(i = 0; i < koppels.length; i++) {
        tempArray = koppels[i];
        if((tempArray[0] == obj && tempArray[1] == obj1) || (tempArray[0] == obj1 && tempArray[1] == obj)) return i;
    }
    return "-1";
}

function repairArray() {
    var tmpArray = new Array();
    var counter = 0;
    for(i = 0; i < koppels.length; i++) {
        if(koppels[i] != "-1") {
            tmpArray[counter] = koppels[i];
            counter++;
        }
    }
    koppels = tmpArray;
}

function handleGetData(str) {
  document.getElementById('adminvak').innerHTML = str;
}

function dAR(obj) {
    JAdminData.getData(obj.value, handleGetData);
}

function doAjaxRequest(obj) {
    var selObj = obj[obj.selectedIndex];
    var id = selObj.value;
    JAdminData.getData(id, handleGetData);
}

// Functies voor het verplaatsen van de options

function hasOptions(obj) {
    if(obj!=null && obj.options!=null) {
        return true;
    }
    return false;
}

function moveSelectedOptions(from,to){
    if(!hasOptions(from)) return;
    for(var i=0;i<from.options.length;i++) {
        var o = from.options[i];
        if(o.selected) {
            if(!hasOptions(to)){ var index = 0; }
            else{ var index=to.options.length; }
            var newOpt = new Option( o.text, o.value, false, false);
            newOpt.className = o.className;
            to.options[index] = newOpt;
        }
    }
    for(var i=(from.options.length-1);i>=0;i--) {
        var o = from.options[i];
        if(o.selected) {
            from.options[i] = null;
        }
    }
    from.selectedIndex = -1;
    to.selectedIndex = -1;
    return newOpt;
}