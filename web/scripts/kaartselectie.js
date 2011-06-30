/* kaartselectie functies */
var kaartgroepenAan = new Array();
var kaartlagenAan = new Array();

function createLeaf(container, item) {
    container.appendChild(document.createTextNode(' '));
    container.appendChild(document.createTextNode(item.title));

    // aan/uit vinkjes
    if (!item.cluster) {
        if (item.kaartSelected) {
            container.appendChild(createCheckboxThema(item, true));
        } else {
            container.appendChild(createCheckboxThema(item, false));
        }
    }

    container.appendChild(document.createTextNode(' '));

    // default visible vinkjes
    if (!item.cluster) {
        if (item.kaartDefaultOn) {
            container.appendChild(createCheckboxDefaultOnThema(item, true));
        } else {
            container.appendChild(createCheckboxDefaultOnThema(item, false));
        }
    }

    return false;
}

function createServiceLeaf(container, item) {
    container.appendChild(document.createTextNode(item.name));
    container.appendChild(document.createTextNode(' '));

    /* root item. alleen groepname tonen en geen vinkjes */
    if (item.id == 0) {
        return;
    }

    if (item.show)
        container.appendChild(createCheckboxLayer(item, true));
    else
        container.appendChild(createCheckboxLayer(item, false));

    container.appendChild(document.createTextNode(' '));

    if (item.default_on)
        container.appendChild(createCheckboxDefaultOnLayer(item, true));
    else
        container.appendChild(createCheckboxDefaultOnLayer(item, false));
}

function createCheckboxCluster(item, checked){

    var checkbox;
    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="kaartgroepenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);
    }else{
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartgroepenAan'
        checkbox.value = item.id;
        if(checked) {
            checkbox.checked = true;
        }
    }

    return checkbox;
}

function createCheckboxDefaultOnCluster(item, checked){

    var checkbox;
    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="kaartgroepenDefaultAan" type="checkbox" id="on_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);
    }else{
        checkbox = document.createElement('input');
        checkbox.id = 'on_' + item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartgroepenDefaultAan'
        checkbox.value = item.id;
        if(checked) {
            checkbox.checked = true;
        }
    }

    return checkbox;
}

function createCheckboxThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input name="kaartlagenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartlagenAan'
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}

function createCheckboxDefaultOnThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input name="kaartlagenDefaultAan" type="checkbox" id="on_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'on_' + item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartlagenDefaultAan'
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}

function createCheckboxLayer(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="layersAan" type="checkbox" id="l_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'l_' +item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'layersAan'
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}

function createCheckboxDefaultOnLayer(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input name="layersDefaultAan" type="checkbox" id="lOn_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'lOn_' + item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'layersDefaultAan'
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}