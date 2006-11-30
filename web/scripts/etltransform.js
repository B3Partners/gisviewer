var koppels = new Array();

function koppel() {
    var geoaf = document.getElementById('geoa')[document.getElementById('geoa').selectedIndex];
    var adminaf = document.getElementById('admina')[document.getElementById('admina').selectedIndex];

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

    geoaf.style.backgroundColor = '#33CCFF';
    adminaf.style.backgroundColor = '#33CCFF';

    document.getElementById('geoa').blur()
    document.getElementById('admina').blur()

    koppels[koppels.length] = new Array(geoaf, adminaf);
}

function ontkoppel() {
    var geoaf = document.getElementById('geoa')[document.getElementById('geoa').selectedIndex];
    var adminaf = document.getElementById('admina')[document.getElementById('admina').selectedIndex];

    var k1 = isKoppel(geoaf, adminaf);

    if(k1 == "-1") {
        alert(geoaf.innerHTML + ' en ' + adminaf.innerHTML + ' zijn niet gekoppeld');
        return false;
    }

    geoaf.style.backgroundColor = getColor(geoaf.className);
    adminaf.style.backgroundColor = getColor(adminaf.className);

    document.getElementById('geoa').blur()
    document.getElementById('admina').blur()

    koppels[k1] = "-1";
    repairArray();
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
        if(tmpArray[0] == obj) anderObj = tmpArray[1];
        else anderObj = tmpArray[0];
        anderObj.selected = true;
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