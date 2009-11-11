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
var flamingo= parent.flamingo;
if(opener) {
  flamingo= opener.flamingo;
}

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
    // sld string opbouwen
    var sldstring =""+sldServletUrl;// window.location.protocol + "//" +  window.location.host + "/gisviewer/CreateSLD";//"<%=request.getAttribute('absoluteURLPrefix') %>" +  "<html:rewrite page="/SldServlet" module=""/>";
    
    var ouder = getParent();
    var fmco = getParent().flamingoController;
    if(fmco == undefined){
        ouder = getParent().getParent();
        fmco = ouder.flamingoController;
    }
    var mapje = fmco.getMap();
    var existingLayer = mapje.getLayer("fmcLayer");
    var wmsLayer=ouder.searchThemaValue(ouder.themaTree,themaid,"wmslayers");
    waardepk = waardepk.trim();
    sldstring += "?visibleValue=" + waardepk;
    sldstring += "&id=" + themaid;
    //var kaartenbalieurl = getParent().kburl;
    var beginChar = "?";
    if(existingLayer.getUrl().indexOf("?") != -1){
        beginChar = "&";
    }
    //sldstring="http://dev.b3p.nl/SldGeneratorStyle/CreateSLD.xml";
    //sldstring="http://b3p-meine:8084/gisviewer/CreateSLD";

    sldstring= escape(sldstring);



    var sldUrl = existingLayer.getUrl() + beginChar + "SLD=" + sldstring;
    existingLayer.setUrl(sldUrl);
    var sldLayer= new FlamingoWMSLayer("sldLayer");
    sldLayer.setTimeOut("30");
    sldLayer.setRetryOnError("10");
    sldLayer.setFormat(existingLayer.getFormat());
    sldLayer.setTransparent(true);
    sldLayer.setUrl(sldUrl);
    sldLayer.setGetcapabilitiesUrl(existingLayer.getUrl());
    sldLayer.setGetfeatureinfoUrl(existingLayer.getUrl());
    sldLayer.setLayers(wmsLayer);
    sldLayer.setExceptions(existingLayer.getExceptions());
    sldLayer.setSrs(existingLayer.getSrs());
    sldLayer.setVersion(existingLayer.getVersion());
    sldLayer.setShowerros(true);

    
    fmco.getMap().addLayer(sldLayer, true,true);
}