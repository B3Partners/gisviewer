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
        var lagen = this.parent.B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        var me = this;
        if (lagen.length > 0) {
            var laag = lagen[0];
            me.parent.B3PGissuite.vars.webMapController.registerEvent(me.parent.Event.ON_FEATURE_ADDED, laag, function(layerName, object) {
                me.retrievePoint(layerName, object);
            });
        } else {
            setTimeout(function() {
                me.init();
            }, 300);
        }
        
        jQuery('#teken_add_new').click(function() {
            me.addNew();
        });
        jQuery('#teken_select_feature').click(function() {
            me.selectFeature();
        });
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

    selectFeature: function() {
        var lagen = this.parent.B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        if (lagen.length > 0) {
            var laag = lagen[0];
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