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

/* In de ouder wordt editingBoom op true gezet en de breinaald tool
 * geactiveerd. Als de gebruiker op de kaart klikt wordt door de onIdentify
 * de selectBoomObject aangeroepen waaran het klikpunt wordt meegegeven */
function startEditBoom() {
    var ouder = getParent();

    if (ouder) {
        ouder.removeAllFeatures();
        setMutatieDatum();

        var gegevensbronId = document.forms[0].gegevensbron.value;
        ouder.enableEditBoom(gegevensbronId);

        // aantal velden op readonly zetten
        document.forms[0].boomid.readOnly=true;
        //document.forms[0].project.readOnly=true;
    }
}

function startDrawBoomObject() {
    var ouder = getParent();

    if (ouder) {
        emptyBoomForm();
        setMutatieDatum();
        ouder.startDrawPolygon("Point");

        var gegevensbronId = document.forms[0].gegevensbron.value;
        ouder.enableNewBoom(gegevensbronId);

        // aantal velden op readonly zetten
        document.forms[0].boomid.readOnly=false;
        //document.forms[0].project.readOnly=false;
    }
}

function annuleren(){
    var ouder = getParent();

    if (ouder) {
        ouder.removeAllFeatures();
        ouder.disableEditBoom();

        emptyBoomForm();
    }
}

function setMutatieDatum(){
    var currentTime = new Date();
    
    var dag = currentTime.getDate();
    if (dag < 10){
        dag = "0" + dag
    }
    var maand = currentTime.getMonth() + 1;
    if (maand < 10){
        maand = "0" + maand
    }
    var jaar = currentTime.getFullYear();
    var uren = currentTime.getHours();
    if (uren < 10){
        uren = "0" + uren
    }
    var minuten = currentTime.getMinutes();
    if (minuten < 10){
        minuten = "0" + minuten
    }
    var seconden = currentTime.getSeconds();
    if (seconden < 10){
        seconden = "0" + seconden
    }

    document.forms[0].mutatiedatum.value = dag+"-"+maand+"-"+jaar;
    document.forms[0].mutatietijd.value = uren+":"+minuten+":"+seconden;
}

function setUitvoerdatum(){
    var risico = document.forms[0].risicoklasse.value;
    var currentTime = new Date()

    /* dagen er bij op tellen */
    if(risico == "geen verhoogd risico"){
        currentTime.setDate(currentTime.getDate()+1095);
    }else if(risico == "mogelijk verhoogd risico"){
        currentTime.setDate(currentTime.getDate()+30);
    }else if(risico == "tijdelijk verhoogd risico"){
        currentTime.setDate(currentTime.getDate()+365);
    }else if(risico == "attentieboom"){
        currentTime.setDate(currentTime.getDate()+365);
    }else if(risico == "risicoboom"){
        currentTime.setDate(currentTime.getDate()+30);
    }

    var dag = currentTime.getDate();
    if (dag < 10){
        dag = "0" + dag
    }
    var maand = currentTime.getMonth() + 1;
    if (maand < 10){
        maand = "0" + maand
    }
    var jaar = currentTime.getFullYear();

    document.forms[0].uitvoerdatum.value = dag+"-"+maand+"-"+jaar;
}

function emptyBoomForm() {
    var ouder = getParent();

    if (ouder) {
        ouder.removeAllFeatures();
    }

    document.forms[0].wkt.value = "";
    document.forms[0].id.value = "";
    document.forms[0].project.value = "";
    document.forms[0].projectid.value = "";
    document.forms[0].boomid.value = "";
    document.forms[0].status.value = "";
    document.forms[0].mutatiedatum.value = "";
    document.forms[0].mutatietijd.value = "";
    //document.forms[0].inspecteur.value = "";
    document.forms[0].aktie.value = "";
    document.forms[0].boomsoort.value = "";
    document.forms[0].plantjaar.value = "";
    document.forms[0].boomhoogte.value = "";
    document.forms[0].boomhoogtevrij.value = "";
    document.forms[0].eindbeeldvrij.value = "";
    document.forms[0].eindbeeld.value = "";
    document.forms[0].scheefstand.value = "";
    document.forms[0].scheuren.value = "";
    document.forms[0].holten.value = "";
    document.forms[0].stamvoetschade.value = "";
    document.forms[0].stamschade.value = "";
    document.forms[0].kroonschade.value = "";
    document.forms[0].inrot.value = "";
    document.forms[0].houtboorder.value = "";
    document.forms[0].zwam.value = "";
    document.forms[0].zwam_stamvoet.value = "";
    document.forms[0].zwam_stam.value = "";
    document.forms[0].zwam_kroon.value = "";
    document.forms[0].dood_hout.value = "";
    document.forms[0].plakoksel.value = "";
    document.forms[0].stamschot.value = "";
    document.forms[0].wortelopslag.value = "";
    document.forms[0].takken.value = "";
    document.forms[0].opdruk.value = "";
    document.forms[0].vta1.value = "";
    document.forms[0].vta2.value = "";
    document.forms[0].vta3.value = "";
    document.forms[0].vta4.value = "";
    document.forms[0].vta5.value = "";
    document.forms[0].vta6.value = "";
    document.forms[0].aantastingenvrij.value = "";
    document.forms[0].aantastingen.value = "";
    document.forms[0].status_zp.value = "";
    document.forms[0].classificatie.value = "";
    document.forms[0].maatregelen_kortvrij.value = "";
    document.forms[0].maatregelen_kort.value = "";
    document.forms[0].nader_onderzoek.value = "";
    document.forms[0].maatregelen_langvrij.value = "";
    document.forms[0].maatregelen_lang.value = "";
    document.forms[0].risicoklasse.value = "";
    document.forms[0].uitvoerdatum.value = "";
    document.forms[0].bereikbaarheid.value = "";
    document.forms[0].wegtypevrij.value = "";
    document.forms[0].wegtype.value = "";
    document.forms[0].opmerking.value = "";
    document.forms[0].extra1.value = "";
    document.forms[0].extra2.value = "";
    document.forms[0].extra3.value = "";
    document.forms[0].extra4.value = "";
    document.forms[0].extra5.value = "";
    document.forms[0].extra6.value = "";
    document.forms[0].extra7.value = "";
    document.forms[0].extra8.value = "";
    document.forms[0].extra9.value = "";
    document.forms[0].extra10.value = "";

    return false;
}

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

    //var project = document.forms[0].project.value;
    var boomId = document.forms[0].boomid.value;
    var inspecteur = document.forms[0].inspecteur.value;
    var aktie = document.forms[0].aktie.value;
    var plantjaar = document.forms[0].plantjaar.value;
    var boomsoort = document.forms[0].boomsoort.value;

    var missing = "";
    /*if(project == ""){
        missing = missing + "Project "
    }*/
    if(boomId == ""){
        missing = missing + "BoomId "
    }
    if(inspecteur == ""){
        missing = missing + "Inspecteur "
    }
    if(aktie == ""){
        missing = missing + "Aktie "
    }
    if(boomsoort == ""){
        missing = missing + "Boomsoort "
    }
    if (ouder && missing != "") {
        ouder.messagePopup("", "De boom kan niet worden opgeslagen. De volgende velden zijn verplicht: "+missing, "information");
        return false;
    }
    
    /*if(plantjaar == ""){
        plantjaar = 0;
    }*/
    
    if((""+ parseInt(plantjaar)) != plantjaar){
        ouder.messagePopup("", "De boom kan niet worden opgeslagen. Het veld plantjaar moet een nummer zijn.", "information");
        return false;
    }

    document.forms[0].sendEditBoom.value = 't';

    document.forms[0].submit();

    /*if (ouder) {
        ouder.reloadEditBoom(false);
    }*/

    return false;
}

function submitRemoveForm() {
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

    var id = document.forms[0].id.value;

    if (id == null || id == "" || id == "undefined") {
        if (ouder) {
            ouder.messagePopup("", "Selecteer eerst een boom object.", "information");
            return false;
        }
    }

    /* removeRedlining methode in action aanroepen */
    document.forms[0].removeBoom.value = 't';
    document.forms[0].submit();

    if (ouder) {
        ouder.removeAllFeatures();;
    }

    return false;
}

function reloadMap(){
    var ouder = getParent();

    if (ouder) {
        ouder.reloadEditBoom(true);
    }
}

function changeAantating(){
    var aantasting = document.forms[0].aantastingen.value;

    var select = document.getElementById("status_zp");
    
    emptyStatusDropdown();
    
    if (aantasting == 'eikenprocessierups' || aantasting == 'bloedingsziekte' 
        || aantasting == 'massaria' || aantasting == 'iepziekte'
        || aantasting == 'essterfte' ) {
        
        select.appendChild(getOption("", "kies status.."));
        select.appendChild(getOption("melding", "melding"));
        select.appendChild(getOption("monitoring", "monitoring"));
        select.appendChild(getOption("registratie", "registratie"));
        select.appendChild(getOption("bestreden", "bestreden"));
    } else {        
        emptyClassificatieDropdown();
    }
    
    document.forms[0].aantastingenvrij.value = "";
}

function changeStatusZP(){
    var status_zp = document.forms[0].status_zp.value;

    var select = document.getElementById("classificatie");
    
    emptyClassificatieDropdown();
    
    if(status_zp == 'melding'){
    	select.appendChild(getOption("", "kies classificatie.."));
        select.appendChild(getOption("gemeente", "gemeente"));
        select.appendChild(getOption("particulier", "particulier"));
        select.appendChild(getOption("provincie", "provincie"));
    }else if(status_zp == 'monitoring'){
    	select.appendChild(getOption("", "kies classificatie.."));
        select.appendChild(getOption("spuitlocatie", "spuitlocatie"));
        select.appendChild(getOption("feromoonval", "feromoonval"));
        select.appendChild(getOption("controlelocatie", "controlelocatie"));
    }else if(status_zp == 'registratie'){
    	select.appendChild(getOption("", "kies classificatie.."));
        select.appendChild(getOption("prioriteit: urgent", "prioriteit: urgent"));
        select.appendChild(getOption("prioriteit: standaard", "prioriteit: standaard"));
        select.appendChild(getOption("prioriteit: laag", "prioriteit: laag"));
        select.appendChild(getOption("prioriteit: geen", "prioriteit: geen"));
    }else if(status_zp == 'bestreden'){
    	select.appendChild(getOption("", "kies classificatie.."));;
        select.appendChild(getOption("hoge plaagdruk", "hoge plaagdruk"));
        select.appendChild(getOption("matige plaagdruk", "matige plaagdruk"));
        select.appendChild(getOption("lage plaagdruk", "lage plaagdruk"));
        select.appendChild(getOption("geen plaagdruk", "geen plaagdruk"));
    }
}

function emptyStatusDropdown() {    
    var selectStatus = document.getElementById("status_zp");
    if(selectStatus.hasChildNodes()) {
        while(selectStatus.childNodes.length >= 1) {
            selectStatus.removeChild(selectStatus.firstChild);
        }
    }
}

function emptyClassificatieDropdown() {        
    var selectClassificatie = document.getElementById("classificatie");
    if(selectClassificatie.hasChildNodes()) {
        while(selectClassificatie.childNodes.length >= 1) {
            selectClassificatie.removeChild(selectClassificatie.firstChild);
        }
    }
}


function getOption(value, text) {
    var option = document.createElement('option');
    option.value = value;
    option.innerHTML = text;
    return option;
}