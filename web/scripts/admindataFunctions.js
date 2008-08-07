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
/**
 * handle the returned value
 */
function handleSetAttribute(str){
    document.getElementById(str[0]).innerHTML=str[1];
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
/**
 * Highlight the clicked object.
 */
function highlight(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
    flamingo.call('map1_fmcLayer','setRecordedValues','demo_gemeenten_2006',attributeName,trim(attributeValue,' '));
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