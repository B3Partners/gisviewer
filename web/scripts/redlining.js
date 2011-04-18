function getParent() {
    if (window.opener){
        return window.opener;
    }else if (window.parent){
        return window.parent;
    }else{
        messagePopup("", "No parent found", "error");
        return null;
    }
}

/* sendRedlining methode in action aanroepen. Een nieuw redline object
 * wordt door de back-end opgeslagen */
function submitForm() {
    var ouder = getParent();

    if(ouder) {
        var wkt = ouder.getWktActiveFeature();
        if (wkt) {
            document.forms[0].wkt.value = wkt;
        } else {
            return false;
        }
    } else {
        document.forms[0].wkt.value = "";
    }

    var projectnaam = document.forms[0].projectnaam.value;
    var kaartlaagId = document.forms[0].kaartlaagId.value;
    
    var new_projectnaam = document.forms[0].new_projectnaam.value;
    var ontwerp = document.forms[0].ontwerp.value;

    if (ouder && projectnaam == "Maak uw keuze..." && new_projectnaam == "") {
        ouder.messagePopup("", "Vul een projectnaam in.", "information");
        return false;
    }

    document.forms[0].sendRedlining.value = 't';
    document.forms[0].submit();

    if (ouder) {        
        ouder.reloadRedliningLayer(kaartlaagId, null, true);
    }

    return false;
}

function submitRemoveForm() {
    var ouder = getParent();

    var id = document.forms[0].redliningID.value;
    var projectnaam = document.forms[0].projectnaam.value;
    var kaartlaagId = document.forms[0].kaartlaagId.value;

    if (id == null || id == "" || id == "undefined") {
        if (ouder) {
            ouder.messagePopup("", "Selecteer eerst een redlining object.", "information");
            return false;
        }
    }

    /* polygoon van kaart afhalen */    
    if (ouder) {
        ouder.removeAllFeatures();
    }

    /* removeRedlining methode in action aanroepen */
    document.forms[0].removeRedlining.value = 't';
    document.forms[0].submit();

    if (ouder) {        
        ouder.reloadRedliningLayer(kaartlaagId, null, true);
    }

    return false;
}

/* In de ouder wordt editingRedlining op true gezet en de breinaald tool
 * geactiveerd. Als de gebruiker op de kaart klikt wordt door de onIdentify
 * de selectRedlining aangeroepen waaran het klikpunt wordt meegegeven */
function startEditRedlining() {    
    var ouder = getParent();

    if (ouder) {
        ouder.removeAllFeatures();
        
        var gegevensbronId = document.forms[0].gegevensbron.value;
        ouder.enableEditRedlining(gegevensbronId);
    }
}

var startedDraw = false;

function startDrawRedlineObject() {
    var ouder = getParent();

    if (ouder) {
        if (startedDraw) {
            ouder.stopDrawPolygon();
        } else {
            emptyForm();
            ouder.startDrawPolygon("Polygon");
        }

        if (startedDraw)
            startedDraw = false;
        else
            startedDraw = true;
    }
}

function emptyForm() {
    var ouder = getParent();

    if (ouder) {
        ouder.removeAllFeatures();
    }

    document.forms[0].wkt.value = "";
    document.forms[0].redliningID.value = "";
    //document.forms[0].projectnaam.value = "Maak uw keuze...";
    document.forms[0].new_projectnaam.value = "";
    //document.forms[0].ontwerp.value = "Ontwerp 1";
    document.forms[0].opmerking.value = "";

    return false;
}

/* Als er ander project wordt gekozen in de bestaande projecten dropdown dan
 * opnieuw een verzoek doen voor de redlining kaartlaag */
function projectChanged(project) {
    var projectnaam = project.value;

    if (projectnaam == null || projectnaam == "" || projectnaam == "Maak uw keuze...") {
        return false;
    }

    var ouder = getParent();

    /* gebruik id van redlining kaartlaag om deze aan te zetten in de boom */
    if (ouder) {
        var kaartlaagId = document.forms[0].kaartlaagId.value;
        ouder.reloadRedliningLayer(kaartlaagId, projectnaam, true);
    }

    return true;
}