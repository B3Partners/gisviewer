/*
 *B3P Gisviewer is an extension to Flamingo MapComponents making
 *it a complete webbased GIS viewer and configuration tool that
 *works in cooperation with B3P Kaartenbalie.
 *
 *Copyright 2006, 2007, 2008 B3Partners BV
 *
 *This file is part of B3P Gisviewer.
 *
 *B3P Gisviewer is free software: you can redistribute it and/or modify
 *it under the terms of the GNU General Public License as published by
 *the Free Software Foundation, either version 3 of the License, or
 *(at your option) any later version.
 *
 *B3P Gisviewer is distributed in the hope that it will be useful,
 *but WITHOUT ANY WARRANTY; without even the implied warranty of
 *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *GNU General Public License for more details.
 *
 *You should have received a copy of the GNU General Public License
 *along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */


function editFeature(ggbId, attrName, attrVal) {
    getParent().drawFeature(ggbId, attrName, attrVal);
}

function popUp(link, title, width, heigth) {
    getParent().popUp(link, title, width, heigth);
}

//writes the obj data from flamingo to a table
function writeFeatureInfoData(obj){
    var tableData="";
    for (layer in obj){
        tableData+="<table class=\"aanvullende_info_table\" >";
        for (feature in obj[layer]){
            tableData+="    <tr class=\"topRow\">";
            tableData+="        <th colspan=\"2\" class=\"aanvullende_info_td\">&nbsp;";
            tableData+=layer;
            tableData+="        </th>";
            tableData+="    </tr>";
            var tellerAtt=0;
            for (attribute in obj[layer][feature]){
                if (tellerAtt%2==0){
                    tableData+="    <tr>"
                }else{
                    tableData+="    <tr class=\"aanvullende_info_alternateTr\">"
                }
                tellerAtt++;
                tableData+="        <td>"+attribute+"</td>"
                tableData+="        <td>"+obj[layer][feature][attribute]+"</td>"
                tableData+="    </tr>";
            }
            tableData+="    <tr><td> </td><td> </td></tr>";
        }
        tableData+="</table>";
    }
    if (document.getElementById("content_style")!=undefined && tableData.length>0){
        document.getElementById("content_style").style.display="none";
    }
    document.getElementById('getFeatureInfo').innerHTML=tableData;
}

function writeNoResults() {
    var tableData="";
    tableData+="<table class=\"kolomtabel\">";
    tableData+="<tr>";
    tableData+="<td valign=\"top\">";
    tableData+="<div id=\"inleiding\" class=\"inleiding\">";
    tableData+="<h2>" + noResultsHeader + "</h2>";
    tableData+="<p>" + noResultsTekst + "</p>";
    tableData+="</div>";
    tableData+="</td>";
    tableData+="</tr>";
    tableData+="</table>";
    if (document.getElementById("content_style")!=undefined){
        document.getElementById('content_style').innerHTML=tableData;
    }
}

var idcounter = 1;
function handleGetGegevensBronSimpleVertical(gegevensbron) {
    // aftellen verwerkte gegevensbron
    loop--;
    if(!gegevensbron) {
        if (loop==0) {
            // geen enkele gegevensbron was gevuld!
            window.setTimeout("writeNoResults();", timeout);
        }
        return;
    }
    //minstens 1 gegevensbron was gevuld, nooit writeNoResults schrijven
    loop = 0;

    var htmlId = gegevensbron.parentHtmlId;

    // Create container
    var bronContainer = $j('<div></div>').attr({
        "id": "bronContainer" + htmlId + gegevensbron.id,
        "class": "bronContainer"
    });

    // Create table content
    if(gegevensbron.records) {
        $j.each(gegevensbron.records, function(index, record) {
            // Create caption
            var bronCaption = createBronCaption(gegevensbron, true, index+1);
            // Create content table
            var bronContent = $j('<div></div>').attr({
                "id": "bronContent" + htmlId + gegevensbron.id + "_" + record.id,
                "class": "bronContent"
            });
            var bronTable = $j('<table></table>');
            var bronTableBody = $j('<tbody></tbody>');

            $j.each(record.values, function(index2, waarde) {
                var tr = $j('<tr></tr>');
                var th = createTableTh(gegevensbron.labels[index2]);
                tr.append(th);
                var td = createTableTd(waarde);
                tr.append(td);
                bronTableBody.append(tr);
            });

            // Append all to DOM tree
            bronContent.append(bronTable.append(bronTableBody));
            bronContainer.append(bronCaption).append(bronContent);

        });
    }

    // wachtmelding weghalen
    if (document.getElementById("content_style")!=undefined){
        document.getElementById("content_style").style.display="none";
    }

    $j('#' + htmlId).append(bronContainer);
}


function handleGetGegevensBronSimpleHorizontal(gegevensbron) {
    // aftellen verwerkte gegevensbron
    loop--;
    if(!gegevensbron) {
        if (loop==0) {
            // geen enkele gegevensbron was gevuld!
            window.setTimeout("writeNoResults();", timeout);
        }
        return;
    }
    //minstens 1 gegevensbron was gevuld, nooit writeNoResults schrijven
    loop = 0;

    var htmlId = gegevensbron.parentHtmlId;

    // Create container
    var bronContainer = $j('<div></div>').attr({
        "id": "bronContainer" + htmlId + gegevensbron.id,
        "class": "bronContainer"
    });

    // Create caption
    var bronCaption = createBronCaption(gegevensbron, true, null);

    // Create content table
    var bronContent = $j('<div></div>').attr({
        "id": "bronContent" + htmlId + gegevensbron.id,
        "class": "bronContent"
    });
    var bronTable = $j('<table></table>');
    var bronTableHead = $j('<thead></thead>');
    var bronTableBody = $j('<tbody></tbody>');

    // Create table heading
    var trHead = createTableHead(gegevensbron.labels, true);
    bronTableHead.append(trHead);

    // Create table content
    if(!gegevensbron.records) {
        var size = 1;
        if (gegevensbron.labels) {
            size = gegevensbron.labels.length;
        }
        var tr = createEmptyRow(size);
        bronTableBody.append(tr);
    } else {
        $j.each(gegevensbron.records, function(index, record) {
            var tr = $j('<tr></tr>');
            $j.each(record.values, function(index2, waarde) {
                var td = createTableTd(waarde);
                tr.append(td);
            });
            bronTableBody.append(tr);
        });
    }

    // wachtmelding weghalen
    if (document.getElementById("content_style")!=undefined){
        document.getElementById("content_style").style.display="none";
    }

    // Append all to DOM tree
    bronContent.append(bronTable.append(bronTableHead).append(bronTableBody));
    bronContainer
    .append(bronCaption)
    .append(bronContent);
    $j('#' + htmlId).append(bronContainer);
}

function handleGetGegevensBron(gegevensbron) {
    // aftellen verwerkte gegevensbron
    loop--;
    if(!gegevensbron) {
        if (loop==0) {
            // geen enkele gegevensbron was gevuld!
            window.setTimeout("writeNoResults();", timeout);
        }
        return;
    }
    //minstens 1 gegevensbron was gevuld, nooit writeNoResults schrijven
    loop = 0;

    var htmlId = gegevensbron.parentHtmlId;

    // Create container
    var bronContainer = $j('<div></div>').attr({
        "id": "bronContainer" + htmlId + gegevensbron.id,
        "class": "bronContainer"
    });

    // Create caption
    var bronCaption = createBronCaption(gegevensbron, false, null);

    // Create content table
    var bronContent = $j('<div></div>').attr({
        "id": "bronContent" + htmlId + gegevensbron.id,
        "class": "bronContent bronContentOpen"
    });
    var bronTable = $j('<table></table>');
    var bronTableHead = $j('<thead></thead>');
    var bronTableBody = $j('<tbody></tbody>');

    // Create table heading
    var trHead = createTableHead(gegevensbron.labels, false);
    bronTableHead.append(trHead);

    // Create table content
    if(!gegevensbron.records) {
        var size = 1;
        if (gegevensbron.labels) {
            size = gegevensbron.labels.length;
        }
        var tr = createEmptyRow(size);
        bronTableBody.append(tr);
    // TODO als 1 record en opgegeven aantal kolommen, dan meteen popup openen
    } else {
        $j.each(gegevensbron.records, function(index, record) {
            var tr = $j('<tr></tr>');
            var volgnr = $j('<td></td>').css({
                "width": "50px"
            });

            var icon = $j('<img src="'+wandicon+'" alt="Selecteer object in kaart" title="Selecteer object in kaart" />')
            .click(function() {
                editFeature(gegevensbron.id,gegevensbron.adminPk,record.id);
            });
            volgnr.append(icon);
            volgnr.append(" ");
            volgnr.append(index+1);

            tr.append(volgnr);
            $j.each(record.values, function(index2, waarde) {
                var td = createTableTd(waarde);
                tr.append(td);
            });
            bronTableBody.append(tr);
            // Check if there are childs
            if(record.childs != null && record.childs.length > 0) {
                $j.each(record.childs, function(index2, child) {
                    var childDivId = 'bronChild' + gegevensbron.id + '_' + fixId(record.id) + '_' + fixId(child.id);
                    var tr = $j('<tr></tr>');
                    var toggleIcon = $j('<img src="'+plusicon+'" alt="Openklappen" title="Openklappen" />')
                    .click(function(){
                        var childLoaded = loadChild(childDivId, child.id, '${wkt}', child.cql);
                        if(!childLoaded) toggleBron(childDivId);
                    });
                    var collapse = $j('<td></td>').css({
                        "width": "50px"
                    });
                    tr.append(collapse);
                    var childTd = $j('<td></td>').attr({
                        "colspan": record.values.length
                    });
                    var childCaption = $j('<div></div>').attr({
                        "id": "childCaption" + childDivId,
                        "class": "childCaption"
                    });
                    childCaption
                    .append(toggleIcon)
                    .append(' ' + child.title);
                    if (child.aantalRecords>1) {
                        childCaption.append(' (' + child.aantalRecords + ')');
                    }
                    var childDiv = $j('<div></div>').attr({
                        "id": childDivId,
                        "class": "bronChild bronChildEmpty"
                    });
                    var loadingIcon = $j('<img src="'+loadingicon+'" alt="Loading" title="Loading" />')
                    var childLoading = $j('<div></div>').attr({
                        "id": "childLoading" + childDivId,
                        "class": "childLoading"
                    })
                    .append(loadingIcon)
                    .hide();
                    childTd
                    .append(childCaption)
                    .append(childLoading)
                    .append(childDiv);
                    tr.append(childTd);
                    bronTableBody.append(tr);

                    toggleIcon.click();

                });
            }
        });
    }

    // wachtmelding weghalen
    if (document.getElementById("content_style")!=undefined){
        document.getElementById("content_style").style.display="none";
    }

    // Append all to DOM tree
    bronContent.append(bronTable.append(bronTableHead).append(bronTableBody));
    bronContainer
    .append(bronCaption)
    .append(bronContent);
    $j('#' + htmlId).append(bronContainer);

    // child loading weghalen indien aanwezig
    $j('#'+htmlId).siblings('.childLoading').hide();

    // alle childs pre-loaden
    $j.each(gegevensbron.records, function(index, record) {
        if(record.childs != null && record.childs.length > 0) {
            $j.each(record.childs, function(index2, child) {
                var childDivId = 'bronChild' + gegevensbron.id + '_' + fixId(record.id) + '_' + fixId(child.id);
                var childLoaded = loadChild(childDivId, child.id, '${wkt}', child.cql);
                if(!childLoaded) toggleBron(childDivId);
            });
        }
    });

}

function loadChild(bronContentId, beanId, wkt, beanCql) {
    var $bronContentDiv = $j('#'+bronContentId);

    if($bronContentDiv.hasClass("bronChildEmpty"))
    {
        JCollectAdmindata.fillGegevensBronBean(beanId, 0, wkt, beanCql, bronContentId, handleGetGegevensBron);
        $bronContentDiv.removeClass("bronChildEmpty").addClass("bronContentOpen");
        $j("#childCaption"+bronContentId).hide();
        $j('#childLoading'+bronContentId).show();
        window.setTimeout(function() {
            $j('#childLoading'+bronContentId).hide();
        }, timeout);

        return true;
    }

    return false;
}

function toggleBron(bronContentId) {
    var $bronContentDiv = $j('#'+bronContentId);

    if($bronContentDiv) {
        // Toggle function
        var $parent = $bronContentDiv.parent().parent();
        if($bronContentDiv.hasClass("bronContentOpen")) {
            $bronContentDiv.removeClass("bronContentOpen").addClass("bronContentClosed");
            $bronContentDiv.hide();

            // If parent has bronChild -> is a child
            if($parent.hasClass("bronChild")) {
                $parent.siblings('.childCaption').show();
                $parent.removeClass("bronContentOpen").addClass("bronContentClosed");
                $bronContentDiv.siblings('.bronCaption').hide();
            }
            if($bronContentDiv.hasClass("bronChild")) {
                $bronContentDiv.siblings('.childCaption').show();
                $bronContentDiv.find('.bronContainer').find('div').hide();
                $bronContentDiv.find('.bronContainer').find('.bronContent').removeClass("bronContentOpen").addClass("bronContentClosed");
            }
        } else {
            $bronContentDiv.removeClass("bronContentClosed").addClass("bronContentOpen");
            $bronContentDiv.show();

            // If parent has bronChild -> is a child
            if($parent.hasClass("bronChild")) {
                $parent.siblings('.childCaption').hide();
                $parent.removeClass("bronContentClosed").addClass("bronContentOpen");
                $bronContentDiv.siblings('.bronCaption').show();
            }
            if($bronContentDiv.hasClass("bronChild")) {
                $bronContentDiv.siblings('.childCaption').hide();
                $bronContentDiv.find('.bronContainer').find('div').show();
                $bronContentDiv.find('.bronContainer').find('.bronContent').removeClass("bronContentClosed").addClass("bronContentOpen");
            }
        }
    }
}

function fixId(myid) {
    var newId = "";
    if (typeof myid === 'string') {
        newId = myid.replace(/(:|\.|\s)/g,'_');
    }
    return newId;
}

function createBronCaption(gegevensbron, simple, index) {
    var createSimple = false;
    if (simple) {
        createSimple = true;
    }

    var htmlId = gegevensbron.parentHtmlId;
    var title = gegevensbron.title;
    if (index) {
        title += " " + index;
    } else {
        index = 0;
    }

    // Create caption
    var bronCaption = $j('<div></div>').attr({
        "id": "bronCaption" + htmlId + gegevensbron.id + index,
        "class": "bronCaption"
    });

    if (createSimple) {
        bronCaption.append(title);
        return bronCaption;
    }

    bronCaption.append('<img src="'+minusicon+'" alt="Dichtklappen" title="Dichtklappen" /> ' + title)
    .click(function() {
        toggleBron("bronContent" + htmlId + gegevensbron.id)
    });

    //CSV export knop
    //TODO: post van maken en toggle uit zetten
    var csv_export_url = "services/Data2CSV?themaId=" + gegevensbron.id + "&objectIds=" + gegevensbron.csvPks;
    var icon = $j('<img src="'+csvexporticon+'"/>').attr({
        "alt": csv_export_url,
        "title": csv_export_url
    })
    .click(function() {
        popUp(csv_export_url, 'csv_export', 600, 500);
    });
    bronCaption.append(" ");
    bronCaption.append(icon);

    //Info export knop
    //TODO: post van maken en toggle uit zetten
    var info_export_url = "viewerdata.do?aanvullendeinfo=t&themaid=" + gegevensbron.id + "&primaryKeys=" + gegevensbron.csvPks+ "&addKaart=j"
    var icona = $j('<img src="'+infoexporticon+'" alt="Info Export" alt="Info Export"/>').attr({
        "alt": info_export_url,
        "title": info_export_url
    })
    .click(function() {
        popUp(info_export_url, 'info_export', 600, 500);
    });
    bronCaption.append(" ");
    bronCaption.append(icona);

    return bronCaption;
}

function createTableHead(labels, simple) {
    var createSimple = false;
    if (simple) {
        createSimple = true;
    }
    // Create table heading
    var trHead = $j('<tr></tr>');
    if (!createSimple) {
        var volgnr = $j('<th></th>').css({
            "width": "50px"
        })
        .html('Volgnr');
        trHead.append(volgnr);
    }
    $j.each(labels, function(index, label) {
        var th = createTableTh(label);
        trHead.append(th);
    });
    return trHead;
}

function createTableTh(label) {
    var kolomBreedte = (label.kolomBreedte == 0) ? 150 : label.kolomBreedte;
    var th = $j('<th></th>')
    .css({
        "width": kolomBreedte + "px"
    })
    .html(label.label);
    return th;
}

function createTableTd(waarde) {
    var kolomBreedte = (waarde.kolomBreedte == 0) ? 150 : waarde.kolomBreedte;
    var td = $j('<td></td>')
    .css({
        "width": kolomBreedte + "px"
    });

    if(waarde.type == 'TYPE_DATA') {
        if (!waarde.value) {
            td.html("-");
        } else {
            td.html(waarde.value);
        }
    }

    if(waarde.type == 'TYPE_URL') {
        if (!waarde.value) {
            td.html("-");
        } else {
            var icon = $j('<img src="'+infoicon+'" alt="Aanvullende informatie" title="Aanvullende informatie" />')
            .click(function() {
                popUp(waarde.value, 'aanvullende_info_scherm', 500, 600);
            });
            td.html(icon);
        }
    }

    if(waarde.type == 'TYPE_FUNCTION') {
        if (!waarde.value) {
            td.html("-");
        } else if(waarde.value.search('###') != -1) {
            var funcarray = waarde.value.split('###');
            var icon2 = $j('<img src="'+flagicon+'" alt="'+funcarray[0]+'" title="'+funcarray[0]+'" />')
            .click(function() {
                eval(funcarray[1]);
            });
            td.html(icon2);
        } else {
            var icon3 = $j('<img src="'+flagicon+'" alt="Voer functie uit" title="Voer functie uit" />')
            .click(function() {
                eval(waarde.value);
            });
            td.html(icon3);
        }
    }

    if (waarde.type == 'TYPE_QUERY') {
        $j.each(waarde.valueList, function(index3, listWaarde) {
            if (!listWaarde) {
                td.append("-");
            } else {
                var linkspan = $j('<span></span>');
                // TODO: icon kiezen afh van extentie listWaarde
                var icon4 = $j('<img src="'+urlicon+'" alt="Externe informatie"/>')
                .attr({
                    "title": listWaarde
                })
                .click(function() {
                    popUp(listWaarde, 'externe_link', 600, 500);
                });
                linkspan.html(icon4);
                td.append(linkspan);
                td.append(" ");
            }
        });
    }
    return td;
}

function createEmptyRow(size) {
    var tr = $j('<tr></tr>');
    var td = $j('<td></td>').attr({
        "colspan": size
    })
    .html("leeg");
    tr.append(td);
    return tr;
}

/*
 *Hier staan alle javascriptfuncties. Deze kunnen worden aangeroepen door bij
 *de themadata aan te geven dat het veld van het type javascript is. Het commando 
 *wat je dan invult is de naam van de functie.
 *De functie wordt altijd met de volgende parameters aangeroepen:
 *element: het html element dat is aangeklikt
 *themaid: id van het thema
 *keyName: primairy key name
 *keyValue: waarde van de primairy key
 *attributeName: gekozen (in themadata) attribuut naam
 *attributeValue: waarde van het attribuut
 *eenheid: eventueel eenheid voor omrekenen
 *
 */

/**set attributevalue
 * change the value
 */
function setAttributeValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
    // Leeg -> Ja
    // Nee -> Ja
    // Ja -> Nee
    var oldValue = element.innerHTML; // Nu wordt er gegeken naar wat de waarde is die in de link staat, deze wordt gebruikt, niet attributeValue
    var newValue = 'Nee';
    if(oldValue == 'Leeg' || oldValue == 'Nee' || oldValue == 'Nieuw')
        newValue = 'Ja';
    JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, handleSetAttribute);
}

var currentThemaid, currentKeyName, currentKeyValue, currentAttributeName, currentEenheid;
var isOpen = false;
var currentEl;
function setAttributeText(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
    if(isOpen) {
        currentEl.style.display = 'block';
    }
    isOpen = true;
    currentEl = element;
    currentThemaid = themaid;
    currentKeyName = keyName;
    currentKeyValue = keyValue;
    currentAttributeName = attributeName;
    currentEenheid = eenheid;
    var opmerkingenedit = document.getElementById('opmerkingenedit');
    var pos = findPos(element);
    opmerkingenedit.style.left = pos[0]-1 + 'px';
    opmerkingenedit.style.top = pos[1]-1 + 'px';
    opmerkingenedit.style.display = 'block';
    document.getElementById('opmText').focus();
    element.style.display = 'none';
    document.getElementById('opmText').value = attributeValue;
    document.getElementById('opmOkButton').onclick = function() {
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, document.getElementById('opmText').value, handleSetText);
    }
    document.getElementById('opmCancelButton').onclick = function() {
        document.getElementById('opmerkingenedit').style.display = 'none';
        element.style.display = 'block';
        isOpen = false;
    }
    return false;
}

/**
 * handle the returned value
 */
function handleSetAttribute(str){
    document.getElementById(str[0]).innerHTML=str[1];
}

function handleSetText(str) {
    document.getElementById('opmerkingenedit').style.display = 'none';
    document.getElementById(str[0]).innerHTML=str[1];
    document.getElementById(str[0]).onclick = function() {
        setAttributeText(this, currentThemaid, currentKeyName, currentKeyValue, currentAttributeName, str[1], currentEenheid);
    }
    document.getElementById(str[0]).style.display = 'block';
    isOpen = false;
}

/**
 *Calculate the Area of the object.
 */
function berekenOppervlakte(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){   
    JMapData.getArea(element.id,themaid,attributeName,attributeValue,eenheid,handleGetArea);
}
/**
 *Handle the returned area.
 */
function handleGetArea(str){
    document.getElementById(str[0]).innerHTML=str[1];
}  

function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}

function rtrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}

function getParent(){
    if (window.opener){
        return window.opener;
    }else if (window.parent){
        return window.parent;
    }else{
        alert("No parent found");
        return null;
    }
}

function highlightFeature(deze, themaid, naampk, waardepk, naamingevuldekolom, waardeingevuldekolom, waardevaneenheidkolom){

    var sldstring=window.location.protocol + "//" +  window.location.host + "/gisviewer/CreateSLD";
    //"<%=request.getAttribute('absoluteURLPrefix') %>" +  "<html:rewrite page="/SldServlet" module=""/>";
    
    var ouder = getParent();
    var fmco = getParent().webMapController;
    if(fmco == undefined){
        ouder = getParent().getParent();
        fmco = ouder.webMapController;
    }
    var mapje = fmco.getMap();
    var existingLayer = mapje.getLayerById("fmcLayer");
    var wmsLayer=ouder.searchThemaValue(ouder.themaTree,themaid,"wmslayers");
    var visValue=trim(waardepk);
    if (waardeingevuldekolom!=null && waardeingevuldekolom.length>0){
        visValue=trim(waardeingevuldekolom);
    }
    visValue=visValue.replace(" ","%20");
    sldstring += "?visibleValue=" + visValue;
    sldstring += "&id=" + themaid;
    var beginChar = "?";
    if(existingLayer.getOption("url").indexOf("?") != -1){
        beginChar = "&";
    }

    sldstring= escape(sldstring);

    var sldUrl = existingLayer.getOption("url") + beginChar + "SLD=" + sldstring;
    var ogcOptions={
        transparent: true,
        format: existingLayer.getFormat(),
        layers: wmsLayer,
        exceptions: existingLayer.getExceptions(),
        srs: existingLayer.getSrs(),
        version: existingLayer.getVersion()
    }
    var options={
        id: "sldLayer",
        timeout: "30",
        retryonerror: "10",
        getcapabilitiesurl: existingLayer.getUrl(),
        getfeatureinfourl: existingLayer.getUrl(),
        showerrors: true
    };
    var sldLayer=webMapController.createWMSLayer("sldLayer", sldUrl, ogcOptions, options);
    fmco.getMap().addLayer(sldLayer);//true,true
}