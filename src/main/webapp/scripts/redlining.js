/* sendRedlining methode in action aanroepen. Een nieuw redline object
 * wordt door de back-end opgeslagen */
function submitForm() {    
    var ouder = B3PGissuite.commons.getParent({ parentOnly: true });

    if(ouder) {
        var wkt = ouder.B3PGissuite.viewercommons.getWktActiveFeature(0);
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
        ouder.B3PGissuite.commons.messagePopup("Redlining", "Vul een projectnaam in.", "information");
        return false;
    }

    document.forms[0].sendRedlining.value = 't';
    document.forms[0].submit();

    if (ouder) {        
        ouder.B3PGissuite.viewerComponent.reloadRedliningLayer(kaartlaagId, null, true);
    }

    return false;
}

function submitRemoveForm() {
    var ouder = B3PGissuite.commons.getParent({ parentOnly: true });

    var id = document.forms[0].redliningID.value;
    var projectnaam = document.forms[0].projectnaam.value;
    var kaartlaagId = document.forms[0].kaartlaagId.value;

    if (id == null || id == "" || id == "undefined") {
        if (ouder) {
            ouder.B3PGissuite.commons.messagePopup("Redlining", "Selecteer eerst een object.", "information");
            return false;
        }
    }

    /* polygoon van kaart afhalen */    
    if (ouder) {
        ouder.B3PGissuite.viewerComponent.removeAllFeatures();
    }

    /* removeRedlining methode in action aanroepen */
    document.forms[0].removeRedlining.value = 't';
    document.forms[0].submit();

    if (ouder) {        
        ouder.B3PGissuite.viewerComponent.reloadRedliningLayer(kaartlaagId, null, true);
    }

    return false;
}

/* In de ouder wordt editingRedlining op true gezet en de breinaald tool
 * geactiveerd. Als de gebruiker op de kaart klikt wordt door de onIdentify
 * de selectRedlining aangeroepen waaran het klikpunt wordt meegegeven */
function startEditRedlining() {    
    var ouder = B3PGissuite.commons.getParent({ parentOnly: true }); 
    
    if (ouder) {        
        ouder.B3PGissuite.viewerComponent.removeAllFeatures();
        
        var gegevensbronId = document.forms[0].gegevensbron.value;
        ouder.B3PGissuite.viewerComponent.enableEditRedlining(gegevensbronId);
    }
}

var startedDraw = false;

function startDrawRedlineObject() {    
    var ouder = B3PGissuite.commons.getParent({ parentOnly: true });

    if (ouder) {
        if (startedDraw) {
            ouder.B3PGissuite.viewerComponent.stopDrawPolygon();
        } else {
            emptyForm();
            ouder.B3PGissuite.viewerComponent.startDrawPolygon("Polygon");
        }

        if (startedDraw)
            startedDraw = false;
        else
            startedDraw = true;
    }
}

function emptyForm() {
    var ouder = B3PGissuite.commons.getParent({ parentOnly: true });

    if (ouder) {
        ouder.B3PGissuite.viewerComponent.removeAllFeatures();
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

    var ouder = B3PGissuite.commons.getParent({ parentOnly: true });

    /* gebruik id van redlining kaartlaag om deze aan te zetten in de boom */
    if (ouder) {
        var kaartlaagId = document.forms[0].kaartlaagId.value;
        ouder.B3PGissuite.viewerComponent.reloadRedliningLayer(kaartlaagId, projectnaam, true);
    }

    return true;
}