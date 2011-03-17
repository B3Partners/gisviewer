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
    document.forms[0].sendRedlining.value = 't';
    document.forms[0].submit();

    return null;
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
    document.forms[0].removeRedlining.value = 't';
    document.forms[0].submit();

    return null;
}

function emptyForm() {
    document.forms[0].prepareRedlining.value = 't';
    document.forms[0].submit();
}

function editRedline() {
    var ouder = getParent();
    var gegevensbronId = document.forms[0].gegevensbron.value;

    ouder.enableEditRedlining(gegevensbronId);
}

function updateRedliningForm() {
    $j("#new_projectnaam").val('test 1');
}