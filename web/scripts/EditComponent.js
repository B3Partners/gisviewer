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
/**
 * EditComponent
 * Can edit features.
 * 
 */
function EditComponent(){
    this.geom = null;
    this.currentFID = null;
    this.vectorLayer = null;
    this.mode = null;
    
    this.init = function(){
        var lagen = B3PGissuite.vars.webMapController.getMap().getAllVectorLayers();
        if(lagen.length >0 ){
            this.vectorLayer = lagen[0];
        }else{
            alert("Geen vectorlayer aanwezig");
        }
    },
    
    this.edit = function (feature,gegevensBronId){
        this.vectorLayer.removeAllFeatures();
        var me =this;
        JEditFeature.getFeature(feature.id,gegevensBronId,function (data){
            var results = JSON.parse(data);
            if(results.success){
                me.receiveFeatureAttributes(results.features[0]);
            }else{
                alert("Ophalen van gegevens mislukt." + data.message);
            }
        });
        
    },

    this.receiveFeatureAttributes = function (result,showDeleteButton, keepFeatures){
        this.removeCurrentEditWindow();
        
        if(keepFeatures == undefined || keepFeatures == null){
            keepFeatures = false;
        }
        if(!keepFeatures){
            this.vectorLayer.removeAllFeatures();
        }
        var table = null;
        // Create div
        var div = document.createElement('div');
        var fid = (result.fid);
        if(fid){
            if(typeof fid === "string"){
                fid = fid.replace(/\./g,'_');
                fid = fid.replace(/ /g,'_');
            }
            this.mode = "edit";
        }else{
            fid = "-1";
            this.mode = "new";
        }
        this.currentFID = fid;
        div.id = 'editComponent' + fid;
        table = document.createElement("table");

        // Make headers and hidden fields for identification of the feature
        var head = document.createElement("th");
        var headText = document.createTextNode(result.featurename);
        head.appendChild(headText);
        table.appendChild(head);

        var fidHidden = this.createHiddenField("fid", result.fid);
        table.appendChild(fidHidden);

        var gbId = this.createHiddenField("gegevensbronId",result.gegevensbronId);
        table.appendChild(gbId);

        var rows = result.values;
        if(!rows){
            return table;
        }
        // Create the editable fields        
        for( var i = 0 ; i < rows.length; i++){
            var row = rows[i];
            var r =  this.createRow(row);
            table.appendChild(r);
        }

        // Create the non-editable field
        var readonlyRows = result.readonly;
        for( var j = 0 ; j < readonlyRows.length; j++){
            var readOnly = readonlyRows[j];
            var rij =  this.createRow(readOnly,true);
            table.appendChild(rij);
        }

        // Create the button(s)
        if(result.geom_attribute){
            var geomAttrHidden = this.createHiddenField("geometry_attribute", result.geom_attribute);
            table.appendChild(geomAttrHidden);

            var geomButtonRow = document.createElement("tr");
            var geomCel = document.createElement("td");
            var geomBtn = document.createElement("input");
            var geomType = result.geom_type;
            geomBtn.setAttribute("id", fid );
            geomBtn.setAttribute("type","button");
            geomBtn.setAttribute("value","Bewerk geometrie");
            geomBtn.setAttribute("onclick",'B3PGissuite.vars.editComponent.editGeom("'+geomType+'");');
            geomCel.appendChild(geomBtn);
            geomButtonRow.appendChild(geomCel);
            table.appendChild(geomButtonRow);
            this.geom = result.geom;
        }

        var buttonRow = document.createElement("tr");
        var cel = document.createElement("td");
        var saveBtn = document.createElement("input");
        saveBtn.setAttribute("id", fid );
        saveBtn.setAttribute("type","button");
        saveBtn.setAttribute("value","Opslaan");
        saveBtn.setAttribute("onclick",'B3PGissuite.vars.editComponent.saveFeature(this);');
        
        cel.appendChild(saveBtn);
        buttonRow.appendChild(cel);

        if(showDeleteButton){
            var removeCel = document.createElement("td");
            var removeBtn = document.createElement("input");
            removeBtn.setAttribute("id", fid );
            removeBtn.setAttribute("type","button");
            removeBtn.setAttribute("value","Verwijder");
            removeBtn.setAttribute("onclick",'B3PGissuite.vars.editComponent.removeFeature(this);');
            cel.appendChild(removeBtn);
            cel.setAttribute("colspan",2);
            buttonRow.appendChild(removeCel);
        }
        table.appendChild(buttonRow);
        
        var form = document.createElement("form");
        form.setAttribute("id","editForm"+fid);
        form.appendChild(table);

        div.appendChild(form);
        B3PGissuite.commons.dialogPopUp($j(div), "Bewerk feature", 400, 400,null);
            
        return table;
    },
    
    this.saveFeature = function (button){
        var id = button.id;
        var elements = $j("#editForm" + id + " :input:not(:button):not(input[type=hidden])");
        var feature = {};
        feature.columns = new Object();
        $j.each(elements,function(index,val){
            var value = val.value;
            if(value != null && value != ""){
                feature.columns[val.id] = value;
            }
            
        });
        var hiddens = $j("#editForm" + id + " :input[type=hidden]");
        $j.each(hiddens,function(index,val){
            if(val.value){
                feature[val.id] = val.value;
            }
        });
        var feat = this.vectorLayer.getActiveFeature(-1);
        if(feat){
            this.geom = feat.wkt;
            feature["geom"] = this.geom;
        }
        feature.mode = this.mode;
        this.vectorLayer.removeAllFeatures();
        // Save to datastore
        var me = this;
        JEditFeature.editFeature(JSON.stringify(feature), function (data){
            me.saveCallback(data);
        })
    },
    
    this.removeFeature = function (button){
        var ans = confirm("Wilt u dit feature verwijderen?");
        if(ans){
            var id = button.id;
            var gbId = $j("#editForm" + id + " #gegevensbronId");

            var feature = {
                fid : this.currentFID,
                gegevensbronId: gbId.val()
            };
            var me = this;
            JEditFeature.removeFeature(JSON.stringify(feature), function (data){
                me.removeCallback(data);
            });
        }
    },
    
    this.editGeom = function (type){
        if(this.geom){        
            var feature = new Feature("editComponent"+this.currentFID, this.geom);
            this.vectorLayer.addFeature(feature);
        }else{
            var me = this;
            B3PGissuite.vars.webMapController.registerEvent(Event.ON_FEATURE_ADDED,this.vectorLayer,function (layerName,object){
                B3PGissuite.vars.webMapController.unRegisterEvent(parent.Event.ON_FEATURE_ADDED,me.vectorLayer,arguments.callee);
                me.geomFinished(layerName, object);
            });
            this.vectorLayer.drawFeature(type);
        }
        
        
    },
    
    this.geomFinished = function(layerName, object){
        this.geom = object.wkt.wktgeom;
    },
    
    this.createRow = function (attribute,readonly){
        var row = document.createElement("tr");
        
        var cel = document.createElement("td");
        var label = document.createTextNode(attribute.label);
        cel.appendChild(label);
        
        var inputCel = document.createElement("td");
        
        var input = null;
        if(attribute.defaultValues && !readonly){
            input = document.createElement("select");
            input.setAttribute("name", attribute.columnname);
            
            this.addOption("", input,"-- Maak een keuze --" );
            var values = attribute.defaultValues;
            var selected = false;
            for( var i = 0 ; i < values.length ; i++ ){
                var val = values[i];
                var option = this.addOption(val, input);
                if(attribute.value && attribute.value == val){
                    option.setAttribute("selected","selected");
                    selected = true;
                }
            }
            
            if(!selected && attribute.value){
                var extraOption = this.addOption(attribute.value, input);
                extraOption.setAttribute("selected","selected");
            }
            input.style.width = "150px";
        }else if(attribute.type == "Boolean"){
            input = document.createElement("input");
            input.setAttribute("type","checkbox");
            
            if(attribute.value){
                input.setAttribute("checked",attribute.value);
            }
        }else{
            input = document.createElement("input");
      
            input.setAttribute("type","text");
            if(attribute.value){
                input.setAttribute("value",attribute.value);
            }
            input.style.width = "150px";
        }
        if(readonly){
            input.setAttribute("disabled",true);
        }
        input.setAttribute("id", attribute.columnname);
        inputCel.appendChild(input);
        
        row.appendChild(cel);
        row.appendChild(inputCel);
        return row;
    },
    
    this.addOption = function(val, input, innerHMTL){
        if(!innerHMTL){
            innerHMTL = val;
        }
        var option = document.createElement("option");
        option.setAttribute("value", val);
        option.setAttribute("id", val);
        option.innerHTML = innerHMTL;
        input.appendChild(option);
        return option;
    },
    
    this.createHiddenField = function (id, value){
        var hidden = document.createElement("input");
        hidden.setAttribute("id",id );
        hidden.setAttribute("type","hidden");
        hidden.setAttribute("value",value);
        return hidden;
    },
    
    this.saveCallback = function (success){
        if(!success){
            alert("Bewerken mislukt");
        }else{
            B3PGissuite.vars.webMapController.getMap().update();
        }
        this.mode = null;
        lightBoxPopUp.dialog("close");
        this.removeCurrentEditWindow();
    },
    
    this.removeCallback = function (success){
        if(!success){
            alert("Verwijderen mislukt");
        }else{
            B3PGissuite.vars.webMapController.getMap().update();
        }
        this.mode = null;
        lightBoxPopUp.dialog("close");
        this.removeCurrentEditWindow();
    },
    
    this.removeCurrentEditWindow = function (){
        var div = $j('#editComponent' + this.currentFID);
        div.remove();
    }
    this.init();
}