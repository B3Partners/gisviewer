
function setStatusValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
    var oldValue = element.innerHTML;
    var newValue;
    
    if(oldValue == '' || oldValue == 'Nieuw' || oldValue == 'nieuw') {
        newValue = 'afgemeld';
    } else {
        newValue = 'nieuw';
    }

    JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, handleSetAttribute);
}

function setStatusValueDigitree(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
    /* Nu wordt er gegeken naar wat de waarde is die in de link staat,
     * deze wordt gebruikt, niet attributeValue */
    var oldValue = element.innerHTML;

    if(oldValue == 'Leeg' || oldValue == 'Nee' || oldValue == 'Nieuw' || oldValue == 'nieuw') {
        var newValue = 'Ja';
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, handleSetAttribute);
    }

    /* TODO: Nadenken over hoe data terug te wijzigen als record niet meer voorkomt
     * in view na eerste wijziging. Bijvoorbeeld een view die alleen statussen Nieuw
     * toont zal het record na deze setValue niet meer teruggeven */
    if (oldValue == 'Ja') {
        messagePopup("Informatie", "Waarde is al gewijzigd.", "information");
    }
}

