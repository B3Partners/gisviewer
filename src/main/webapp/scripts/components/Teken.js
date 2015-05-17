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

B3PGissuite.defineComponent('Teken', {

    currentResults: null,
    isEditting: false,
    gegevensbron: null,
    parent: null,
    listenerAdded: false,

    constructor: function Teken(options) {
        var me = this;
        this.gegevensbron = options.gegevensbron;
        this.parent = B3PGissuite.commons.getParent({ parentOnly: true });
        jQuery(document).ready(function() {
            me.parent.B3PGissuite.get('Layout').changeTabTitle('tekenen', options.title);
            me.init();
        });
    },
    
    init: function() {
        var me = this;
        jQuery('#teken_add_new').click(function() {
            me.addNew();
        });
        
        jQuery('#teken_select_feature').click(function() {
            me.selectFeature();
        });
        
        jQuery('#teken_filter_features').click(function() {
            me.filterFeatures(false);
        }); 
        
        jQuery('#teken_filter_all_features').click(function() {
            me.filterFeatures(true);
        });
    },
    
    filterFeatures: function (showAll) {
        var me = this;
        
        var themaId = this.parent.B3PGissuite.config.tekenKaartlaagId;        
        var filterColumn = this.parent.B3PGissuite.config.tekenFilterColumn;    
        
        var userColumn = $j("#teken_filter_column").val();
        if (!this.parent.B3PGissuite.viewercommons.isStringEmpty(userColumn)) {
            filterColumn = userColumn;
        } else {
            $j("#teken_filter_column").val(filterColumn);
        }
        
        if (showAll) {
            $j("#teken_filter_column").val("");
            $j("#teken_filter_value").val("");  
        }  
        
        var filterValue = $j("#teken_filter_value").val();
        
        var appCode = this.parent.B3PGissuite.config.bookmarkAppcode;
        
        var baseUrl = this.parent.B3PGissuite.viewercommons.getBaseUrl();
        var sldUrl = baseUrl + "/services/CreateSLD/appcode/" + appCode +"/propname/" + filterColumn + "/propvalue/" + filterValue + "/id/" + themaId;
        
        me.reloadTekenlayer(themaId, sldUrl);
    },
    
    reloadTekenlayer: function(themaId, sldUrl) {
        if (!this.parent.B3PGissuite.viewercommons.isStringEmpty(sldUrl)) {
            this.parent.B3PGissuite.vars.layerUrl = this.parent.B3PGissuite.vars.originalLayerUrl + "&sld=" + sldUrl;
        }
        
        // teken kaartlaag uit/aan vinken
        var treeComponent = this.parent.B3PGissuite.get('TreeTabComponent');
        if (treeComponent !== null) {
            treeComponent.deActivateCheckbox(themaId);
            treeComponent.activateCheckbox(themaId);
        }
    },

    addNew: function () {
        var me = this;
        this.parent.JEditFeature.getFeatureType(this.gegevensbron, function(data) {
            var results = JSON.parse(data);
            if (results.success) {
                me.parent.B3PGissuite.vars.editComponent.receiveFeatureAttributes(results.featuretype, false, true);
            } else {
                alert("Ophalen van gegevens mislukt." + results.message);
            }
        });
    },
    
    registerFeatureAddedEvent: function(laag) {
        var me = this;
        try {
            /**
             * This is a very hacky part. The problem is that the event handler is overriden by the Edit module.
             * This is probably a bug/problem in the OpenLayersController where the featureadded event is hanled by single function.
             * There can only be one listener. Below we check if the function attached to the listener is 'our' function.
             * If not we add the listener again. 
             */
            if(
                me.parent.B3PGissuite.vars.webMapController.events[me.parent.Event.ON_FEATURE_ADDED] &&
                me.parent.B3PGissuite.vars.webMapController.events[me.parent.Event.ON_FEATURE_ADDED][laag.frameworkLayer.id] &&
                me.parent.B3PGissuite.vars.webMapController.events[me.parent.Event.ON_FEATURE_ADDED][laag.frameworkLayer.id].name !== 'featureAdded'
            )
            {
                me.listenerAdded = false;
            }
            /**
             * Add the listener if we have not added before
             */
            if(!me.listenerAdded) {
                // We are using a 'named' function here to be able to compare the name in the check above
                me.parent.B3PGissuite.vars.webMapController.registerEvent(me.parent.Event.ON_FEATURE_ADDED, laag, function featureAdded(layerName, object) {
                    me.retrievePoint(layerName, object);
                });
                me.listenerAdded = true;
            }
        } catch(e) {}
    },

    selectFeature: function() {
        var lagen = this.parent.B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        if (lagen.length > 0) {
            var laag = lagen[0];
            this.registerFeatureAddedEvent(laag);
            if (this.isEditting) {
                this.isEditting = false;
                laag.stopDrawDrawFeature();
            } else {
                this.isEditting = true;
                laag.drawFeature("Point");
            }
        } else {
            alert("Geen tekenlaag beschikbaar voor editten.");
        }
    },

    retrievePoint: function(layerName, object) {
        if (!this.isEditting) return;
        var lagen = this.parent.B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        var laag = lagen[0];
        laag.stopDrawDrawFeature();
        this.isEditting = false;
        var feature = object.wkt;
        var scale = this.parent.B3PGissuite.vars.webMapController.getMap().getScale();
        var distance = scale * 4;
        var me = this;
        laag.removeAllFeatures();
        this.parent.JEditFeature.getFeatureByWkt(this.gegevensbron, feature, distance, function(data) {
            me.receiveFeatureAttributes(data, true);
        });
    },

    receiveFeatureAttributes: function(data) {
        var result = JSON.parse(data);
        if (result.success) {
            var resultsDiv = $j("#multipleResults");
            var features = result.features;
            this.currentResults = null;
            if (features.length === 1) {
                resultsDiv.empty();
                this.parent.B3PGissuite.vars.editComponent.receiveFeatureAttributes(features[0], true);
            } else if (features.length === 0) {
                alert("Ophalen van gegevens mislukt: Geen features gevonden");
            } else {
                this.currentResults = features;
                resultsDiv.empty();
                resultsDiv.html("<h3>Resultaten</h3>");
                for (var i = 0; i < features.length; i++) {
                    var resultRow = this.createResult(features[i], i);
                    resultsDiv.append(resultRow);
                }
            }
        } else {
            alert("Ophalen van gegevens mislukt." + result.message);
        }
    },

    createResult: function(feature, index) {
        var me = this;
        return jQuery('<div></div>').attr({ 'id': feature.fid }).append(
            jQuery('<a></a>').attr({ 'href': '#' }).html((index + 1) + ". " + feature.fid).click(function() {
                me.openLink(index);
            })
        );
    },

    openLink: function(index) {
        this.parent.B3PGissuite.vars.editComponent.receiveFeatureAttributes(this.currentResults[index], true);
    }
    
});