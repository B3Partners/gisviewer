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
    /* Root item. For the service leaf this is the groupname. */
    if (item.id == 0) {
        container.appendChild(createCheckboxService(item));
        container.appendChild(document.createTextNode(' '));
        container.appendChild(document.createTextNode(item.name));

        return;
    }

    container.appendChild(document.createTextNode(item.name));
    container.appendChild(document.createTextNode(' '));

    if (item.show)
        container.appendChild(createCheckboxLayer(item, true));
    else
        container.appendChild(createCheckboxLayer(item, false));

    container.appendChild(document.createTextNode(' '));

    if (item.default_on)
        container.appendChild(createCheckboxDefaultOnLayer(item, true));
    else
        container.appendChild(createCheckboxDefaultOnLayer(item, false));

    /* Alleen selectbox tonen als er meer dan alleen een default style is */
    if (item.styles) {
        if (item.styles[0] != "default") {
            container.appendChild(createSelectBoxLayerStyles(item));
        }
    }
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

function createCheckboxService(item) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="servicesAan" type="checkbox" id="' + item.id + '"';

        checkboxControleString += ' value="' + item.serviceid + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);
    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.name = 'servicesAan'
        checkbox.value = item.serviceid;
    }

    return checkbox;
}

function createSelectBoxLayerStyles(item) {
    var selectItem;
    var layerId = item.id;

    var useStyle = "default";
    if (item.use_style != undefined && item.use_style != "default") {
        useStyle = item.use_style;
    }

    /* Todo: Controleren of een van de options al geselecteerd moet zijn */

    if (ieVersion <= 8 && ieVersion != -1) {
        var controleStr = '<select name="useLayerStyles" id="selStyle_' + item.id + '"';

        controleStr += '<option value="' + layerId + '@default">-Kies style-</option>';

        for (var i=0; i < item.styles.length; i++) {            
            if (item.styles[i] != "default") {

                if (useStyle ==  item.styles[i]) {
                    controleStr += '<option SELECTED value=' + layerId + '@' + item.styles[i] + '>' + item.styles[i] + '</option>';
                } else {
                    controleStr += '<option value=' + layerId + '@' + item.styles[i] + '>' + item.styles[i] + '</option>';
                }
            }
        }

        controleStr += '>';
        selectItem = document.createElement(controleStr);

    } else {
        selectItem = document.createElement('select');

        selectItem.id = 'selStyle_' + item.id;
        selectItem.name = 'useLayerStyles';

        var defOption = document.createElement("option");

        defOption.text = '-Kies style-';
        defOption.value = layerId + '@default';

        selectItem.options.add(defOption);

        for (var j=0; j < item.styles.length; j++) {
            if (item.styles[j] != "default") {
                var objOption = document.createElement("option");

                objOption.text = item.styles[j];
                objOption.value = layerId + '@' + item.styles[j];

                if (useStyle ==  item.styles[j]) {
                    objOption.selected = true;
                }

                selectItem.options.add(objOption);
            }
        } 
    }

    return selectItem;
}