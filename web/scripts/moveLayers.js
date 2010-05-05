/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */
var selectedLayer;
function selectLayer(element){
    if (selectedLayer){
        selectedLayer.className="orderLayerClass";
    }
    element.className="orderLayerClassSelected";
    selectedLayer=element;
}
function switchLayers(element1,element2){
    var name=element1.name;
    var className=element1.className;
    var innerHTML=element1.innerHTML;
    var id=element1.id;
    var title= element1.title;

    element1.name=element2.name;
    element1.className=element2.className;
    element1.innerHTML=element2.innerHTML;
    element1.id=element2.id;
    element1.title=element2.title;

    element2.name=name;
    element2.className=className;
    element2.innerHTML=innerHTML;
    element2.id=id;
    element2.title=title;
}
function moveSelected(amount){
    if (selectedLayer){
        var orderLayerBox= document.getElementById("orderLayerBox");
        var orderLayers=orderLayerBox.childNodes;
        for (var i=0; i < orderLayers.length; i++){
            if (orderLayers[i].name==selectedLayer.name){
                if (i+amount > -1 && i+amount < orderLayers.length){
                    switchLayers(orderLayers[i+amount],orderLayers[i]);
                    selectedLayer=orderLayers[i+amount];
                    return;
                }
            }
        }      
    }else{
        alert("Selecteer eerst een kaart om te verplaatsen");
    }
}
function moveSelectedDown(){
    moveSelected(1);
}
function moveSelectedUp(){
    moveSelected(-1);
}