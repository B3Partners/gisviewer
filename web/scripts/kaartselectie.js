/* kaartselectie functies */
var kaartgroepenAan = new Array();
var kaartlagenAan = new Array();

var imagepath = '/gisviewer/images/icons/';
var checkedimage = 'ok.png';
var notcheckedimage = 'delete.png';
var hassld = 'dropdown_red.png';
var hasnosld = 'dropdown_gray.png';

function createLeaf(container, item) {
    container.appendChild(document.createTextNode(' '));
    container.appendChild(document.createTextNode(item.title));

    /* aan/uit vinkjes kaartgroepen en kaartlagen */
    if (!item.cluster) {
        if (item.kaartSelected) {
            container.appendChild(createCheckboxThema(item, true));
        } else {
            container.appendChild(createCheckboxThema(item, false));
        }
    } else if (item.callable) {
        container.appendChild(createDummySpace());
    }

    container.appendChild(document.createTextNode(' '));

    /* default aan/uit vinkjes kaartgroepen en kaartlagen */
    if (!item.cluster) {
        if (item.kaartDefaultOn) {
            container.appendChild(createCheckboxDefaultOnThema(item, true));
        } else {
            container.appendChild(createCheckboxDefaultOnThema(item, false));
        }
    } else if (item.callable) {
        if (item.groupDefaultOn) {
            container.appendChild(createCheckboxDefaultOnCluster(item, true));
        } else {
            container.appendChild(createCheckboxDefaultOnCluster(item, false));
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

    container.appendChild(createInputHiddenLayerId(item));

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

    container.appendChild(document.createTextNode(' '));
    container.appendChild(createInputLayerSldPart(item));
}

function createCheckboxThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input style="display: none;" class="checkboxThema" name="kaartlagenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.className = "checkboxThema";
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartlagenAan'
        checkbox.style.display = 'none';
        checkbox.value = item.id;
        
        if (checked) {
            checkbox.checked = true;
        }
    }
    
    var div = document.createElement('div');
    div.className ='treeview_image';
    
    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement(item.id, imagetype, '', "on_" + item.id);
    
    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}

function createCheckboxDefaultOnThema(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input style="display: none;" class="checkboxThemaOn" name="kaartlagenDefaultAan" type="checkbox" id="on_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'on_' + item.id;
        checkbox.className = "checkboxThemaOn";
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartlagenDefaultAan'
        checkbox.style.display = 'none';
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    
    var div = document.createElement('div');
    div.className ='treeview_image_on';
    
    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement("on_" + item.id, imagetype, item.id, '');
    
    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}

function createCheckboxLayer(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {
        var checkboxControleString = '<input style="display: none;" name="layersAan" type="checkbox" id="l_' + item.id + '"';
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
        checkbox.style.display = 'none';
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    
    var div = document.createElement('div');
    div.className ='treeview_image';
    
    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement("l_" + item.id, imagetype, '', "lOn_" + item.id);
    
    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}

function createCheckboxDefaultOnLayer(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input style="display: none" name="layersDefaultAan" type="checkbox" id="lOn_' + item.id + '"';
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
        checkbox.style.display = 'none';
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }
    
    var div = document.createElement('div');
    div.className ='treeview_image_on';
    
    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement("lOn_" + item.id, imagetype, "l_" + item.id, '');
    
    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}

function createCheckboxService(item) {
    var checkbox;

    checkbox = document.createElement('input');
    checkbox.id = item.id;
    checkbox.type = 'checkbox';
    checkbox.name = 'servicesAan'
    checkbox.value = item.serviceid;
        
    return checkbox;
}

function createSelectBoxLayerStyles(item) {
    var selectItem;
    var layerId = item.id;

    var useStyle = "default";
    if (item.use_style != undefined && item.use_style != "default") {
        useStyle = item.use_style;
    }
    
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

            if (useStyle == item.styles[j]) {
                objOption.selected = true;
            }

            selectItem.options.add(objOption);
        }
    } 

    return selectItem;
}

function createInputLayerSldPart(item) {
    var input;
    var sld_part = "";
    
    var selectbox = null;
    /* Alleen selectbox tonen als er meer dan alleen een default style is */
    if (item.styles) {
        if (item.styles[0] != "default") {
            selectbox = createSelectBoxLayerStyles(item);
        }
    }

    if (item.sld_part != undefined && item.sld_part != '') {
        sld_part = item.sld_part;
    }

    input = document.createElement('textarea');
    input.id = item.id;
    input.name = 'useLayerSldParts'
    input.value = sld_part;
    input.rows = 1;
    input.cols = 15;
    
    var imagetype = hasnosld;
    if(sld_part != "" || (item.use_style != undefined && item.use_style != "default")) imagetype = hassld;
    
    var img = document.createElement('img');
    img.src = imagepath + imagetype;
    img.title = "Indien aanwezig kies een layer style of voer een stukje SLD in.";
    $j(img).click(function(e){
        openSldContainer('sldcontainer_' + item.id);
        e.stopPropagation();
    });
    
    var imgclone = $j(img).clone();
    imgclone.css({"float": "right"});
    imgclone.click(function(e) {
        closeSldContainers();
        e.stopPropagation();
    });
    
    var sldcontainer = document.createElement('div');
    sldcontainer.className = 'kaartlaagselectieSldContainer';
    sldcontainer.id = 'sldcontainer_' + item.id;
    
    sldcontainer.appendChild(imgclone[0]);
    
    if (selectbox != null) {
        var lbl = document.createElement('label');
        lbl.innerHTML = 'Selecteer een style';
        
        sldcontainer.appendChild(lbl);
        sldcontainer.appendChild(selectbox);
    } else {
        var labelNoStyles = document.createElement('label');
        labelNoStyles.innerHTML = 'Geen styles aanwezig.';

        sldcontainer.appendChild(labelNoStyles);
    }

    /*
     * TODO: Is even uitgecomment. Sld parts invoeren doen we nu nog niet.
    
    var lbl2 = document.createElement('label');
    if(selectbox == null) lbl2.innerHTML = 'Voer een SLD in';
    else lbl2.innerHTML = 'Of voer een SLD in';  
    
    sldcontainer.appendChild(lbl2);
    sldcontainer.appendChild(input);
    */    
   
    var divcontainer = document.createElement('div');
    divcontainer.className = 'kaartlaagselectieContainer';
    
    divcontainer.appendChild(img);
    divcontainer.appendChild(sldcontainer);
    $j(divcontainer).click(function(e) {
        e.stopPropagation();
    });
    
    return divcontainer;
}

/* userLayerIds wordt gebruikt om de layerid's te kunnen koppelen
 * aan de textarea's */
function createInputHiddenLayerId(item) {
    var input;

    var layerId = item.id;

    input = document.createElement('input');
    input.id = item.id;
    input.name = 'userLayerIds';
    input.type = 'hidden';
    input.value = layerId;

    return input;
}

function createDummySpace() {
    var div = document.createElement('div');
    div.className = 'checkboxDummy';
    return div;
}

function createImageReplacement(id, imagetype, dependant, child) {
    var img = document.createElement('img');
    img.src = imagepath + imagetype;
    img.id = id + '_image';
    $j(img).click(function(e){
        var checkBox = $j("#" + id);
        if(checkBox.is(":checked")) {
            checkBox.attr('checked', false);
            $j(this).attr("src", imagepath + notcheckedimage);
            if(child != '') {
                $j("#" + child).attr('checked', false);
                $j("#" + child + "_image").attr("src", imagepath + notcheckedimage);
            }
        } else {
            checkBox.attr('checked', true);
            $j(this).attr("src", imagepath + checkedimage);
            if(dependant != '' && !$j("#"+dependant).is(":checked")) {
                $j("#" + dependant).attr('checked', true);
                $j("#" + dependant + "_image").attr("src", imagepath + checkedimage);
            }
        }
        e.stopPropagation();
    });
    return img;
}

function openSldContainer(containerid) {
    $j('.kaartlaagselectieSldContainer').hide();
    $j('#'+containerid).show();
    if (ieVersion <= 8 && ieVersion != -1) {
        $j('.kaartlaagselectieContainer').css("z-index", "4000");
        $j('#'+containerid).parent().css("z-index", "5000");
    }
}

function closeSldContainers() {
    $j('.kaartlaagselectieSldContainer').hide();
}

function createCheckboxCluster(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input style="display: none;" class="checkboxThema" name="kaartgroepenAan" type="checkbox" id="' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = item.id;
        checkbox.className = "checkboxThema";
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartgroepenAan'
        checkbox.style.display = 'none';
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }

    var div = document.createElement('div');
    div.className ='treeview_image';

    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement(item.id, imagetype, '', "on_" + item.id);

    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}

function createCheckboxDefaultOnCluster(item, checked) {
    var checkbox;

    if (ieVersion <= 8 && ieVersion != -1) {

        var checkboxControleString = '<input style="display: none;" class="checkboxThemaOn" name="kaartgroepenDefaultAan" type="checkbox" id="on_' + item.id + '"';
        if (checked) {
            checkboxControleString += ' checked="checked"';
        }
        checkboxControleString += ' value="' + item.id + '"';
        checkboxControleString += '>';
        checkbox = document.createElement(checkboxControleString);

    } else {
        checkbox = document.createElement('input');
        checkbox.id = 'on_' + item.id;
        checkbox.className = "checkboxThemaOn";
        checkbox.type = 'checkbox';
        checkbox.name = 'kaartgroepenDefaultAan'
        checkbox.style.display = 'none';
        checkbox.value = item.id;

        if (checked) {
            checkbox.checked = true;
        }
    }

    var div = document.createElement('div');
    div.className ='treeview_image_on';

    var imagetype = notcheckedimage;
    if(checked) imagetype = checkedimage;
    var img = createImageReplacement("on_" + item.id, imagetype, item.id, '');

    div.appendChild(img);
    div.appendChild(checkbox);

    return div;
}