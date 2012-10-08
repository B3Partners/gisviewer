/* 
 * Copyright (C) 2012 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
var editComponent = parent.editComponent;
var currentResults = null;
var isEditting = false;
function changeTabTitle(){
    parent.$j("#tekenenlink").html(parent.$j("#tekenenlink").html().replace("Tekenen",title))
}

function addNew(){
    parent.JEditFeature.getFeatureType(gegevensbron,function(data){
        var results = JSON.parse(data);
        if(results.success){
            parent.editComponent.receiveFeatureAttributes(results.featuretype);
        }else{
            alert("Ophalen van gegevens mislukt." + results.message);
        }
    })
}

function selectFeature(){    
    var lagen = webMapController.getMap().getAllVectorLayers();
    if(lagen.length >0){
        var laag = lagen[0]
        var me = this;
        if(isEditting){
            isEditting = false;
            laag.stopDrawDrawFeature();
        }else{
            isEditting = true;
            laag.drawFeature("Point");
        }
    }else{
        alert("Geen tekenlaag beschikbaar voor editten.");
    }
}

function retrievePoint(layerName,object){
    if(isEditting){
        var lagen = webMapController.getMap().getAllVectorLayers();
        var laag = lagen[0]
        laag.stopDrawDrawFeature();
        isEditting = false;
        var feature = object.wkt;
        var scale = webMapController.getMap().getScale();
        var distance = scale * 2;
        var me = this;
        laag.removeAllFeatures();
        parent.JEditFeature.getFeatureByWkt(gegevensbron,feature,distance,
            function (data){
                me.receiveFeatureAttributes(data,true );
            });
    }
}

function receiveFeatureAttributes(data){
    var result = JSON.parse(data);
    if(result.success){
        var resultsDiv = $j("#multipleResults");
        var features = result.features;
        this.currentResults=null;
        if(features.length == 1){
            resultsDiv.empty();
            parent.editComponent.receiveFeatureAttributes(features[0],true);
        }else if(features.length == 0){
            alert("Ophalen van gegevens mislukt: Geen features gevonden");
        }else{
            this.currentResults=features;
            resultsDiv.empty();
            resultsDiv[0].innerHTML = "<h3>Resultaten</h3>";
            for (var i = 0 ; i < features.length ;i++){
                var resultRow = createResult(features[i],i);
                resultsDiv.append(resultRow);
            }
        }
    }else{
        alert("Ophalen van gegevens mislukt." + result.message);
    }
}

function createResult (feature, index){
    var div = document.createElement('div');
    div.setAttribute("id",feature.fid);
    var link = document.createElement('a');
    link.setAttribute('href', '#');
    link.setAttribute("onclick","openLink(" + index + ");");
    link.innerHTML = (index+1) + ". "  + feature.fid;
    div.appendChild(link);
    return div;
}

function openLink(index){
    parent.editComponent.receiveFeatureAttributes(this.currentResults[index],true);
}

function init(){
    var lagen = webMapController.getMap().getAllVectorLayers();
    if(lagen.length > 0 ){
        var laag = lagen[0]
        var me = this;
        webMapController.registerEvent(parent.Event.ON_FEATURE_ADDED,laag,function(layerName,object){
            retrievePoint(layerName,object);
        },me);
    }else{
        setTimeout(init,300);
    }
}

$j(document).ready(function(){
    changeTabTitle();
     editComponent = parent.editComponent;
     init();
});
