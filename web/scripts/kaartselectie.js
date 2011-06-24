/* kaartselectie functies */
var kaartgroepenAan = new Array();
var kaartlagenAan = new Array();

function createLeaf(container, item) {
    container.appendChild(document.createTextNode(' '));
    container.appendChild(document.createTextNode(item.title));

    if (item.cluster)
        container.appendChild(createCheckboxClusterStruts(item, false));
    else
        container.appendChild(createCheckboxThema(item, false));

    return false;
}

function createCheckboxCluster(item, checked){

    var checkbox;
    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input name="kaartgroepenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="clusterClick(this)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);
    }else{
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.value = item.id;
        checkbox.onclick = function(){
            clusterClick(this);
        }
        if(checked) {
            checkbox.checked = true;
        }
    }

    return checkbox;
}

function createCheckboxClusterStruts(item, checked){
    var checkbox;

    checkbox = document.createElement('html:multibox');
    checkbox.id = item.id;
    checkbox.property = 'kaartgroepenAan';
    checkbox.value = item.id;

    return checkbox;
}

function createCheckboxThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input name="kaartlagenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '" onclick="themaClick(this)"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.type = 'checkbox';
        checkbox.value = item.id;

        checkbox.onclick = function() {
            themaClick(this);
        }

        if (checked) {
            checkbox.checked = true;
        }
    }
    return checkbox;
}
