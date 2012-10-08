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
function MaatregelComponent(){
    this.container = null;
    this.maatregelContainer = null;
    this.listContainer = null;
    this.maatregelSelectText=null;
    this.maatregelSelect=null;
    this.popup=null;
    this.questionObject=null;
    this.currentCrow=null;
    
    this.maatregelen=null;
    
    this.objectType=null;
    this.bronId=null;
    this.featureId=null;
    
    this.maatregelId=null;
    
    this.maatregelType=null;
    
    /*'STATICS'*/
    this.radioPrefix="radioGroup";
    this.defiOptionPrefix="defi";
    this.customInputPrefix="customInput";
    this.inputPrefix="hoeveelheid";
    /**
     * Init this constructor
     */
    this.init = function(){
        
        
        this.container = $j('<div class="maatregelMainContainer"></div>');
        this.listContainer = $j('<div class="maatregelListContainer"></div>');
        this.maatregelContainer = $j('<div class="maatregelContainer"></div>');
        this.container.append(this.listContainer);
        this.container.append(this.maatregelContainer);
        
        this.popup=dialogPopUp(this.container, "Maatregelen", 600, 600,null);
        var me = this;        
    },
    /**
     *Open maatregel form.
     */
    this.open = function (objectType,bronId,featureId){
        //reset
        this.maatregelId=null;
        
        this.bronId=bronId;
        this.featureId = featureId;
        this.objectType = objectType; 
                
        
        if (this.maatregelSelect==null){
            this.createMaatregelSelect();
        }
        this.refresh();
        
        this.popup.dialog('open');
    },
    /**
     * Refresh stored maatregelen list
     */
    this.refreshMaatregelenList = function(){   
        var me = this;
        var headString ="<h2>"+this.featureId;
        if (this.objectType){
            headString+=" ("+this.objectType+")";
        }else{
            headString+=" (Onbekend object type)";
        }
        headString+="<h2>";
        this.listContainer.html(headString);
        JMaatregelService.getGeplandeMaatregelen(this.bronId,this.featureId,function(data){
            data = JSON.parse(data);
            if (data.success){
                me.maatregelen = data.results;
                me.createMaatregelenList();
            }else if(data.error){
                alert(data.error);
            }
        });
    },
    /**
     * Create the stored maatregelen html elements.
     */
    this.createMaatregelenList = function(){        
        var me = this;
        if (this.maatregelen.length>0){
            this.listContainer.append("<b><u>Gevonden maatregelen:</u><br/></b>");
        }
        for (var i=0; i < this.maatregelen.length; i++){
            var maatregelDiv = $j("<div class='maatregel_item'></div>");
            this.listContainer.append(maatregelDiv);            
            var omschDiv= $j("<div class='maatregel_text'></div>");
            var maatregelLink = $j("<a href='javascript: void(0)' id='openMaatregel_"+this.maatregelen[i].id+"'>"+this.maatregelen[i].maatregel.omschrijving+"</a>");
            maatregelLink.click(function(evt){
                me.showMaatregel(evt.target.id.split("_")[1]);
            });
            omschDiv.append(maatregelLink);
            maatregelDiv.append(omschDiv);
            
            var verwDiv= $j("<div class='maatregel_remove'></div>");
            var verwijderLink = $j("<a id='verwMaatregel_"+this.maatregelen[i].id+"' href='javascript: void(0)'>Verwijder</a>");
            verwijderLink.click(function(evt){
                me.removeMaatregel(evt.target.id.split("_")[1]);
            });           
            verwDiv.append(verwijderLink);
            maatregelDiv.append(verwDiv);
        }
        
    },
    
    /**
     *Show stored maatregel
     *@param id the id of the maatregel_gepland
     */
    this.showMaatregel=function(id){        
        var me = this;
        this.maatregelId=id;
        JMaatregelService.getSavedMaatregel(id, function (data){
            me.handleSavedMaatregel(data);
        });
    },
    
    /**
     * 
     */
    this.handleSavedMaatregel = function(data){
        data = JSON.parse(data);
        if (data.success){
            var me=this;
            var result = data.result;
            var maatregelId=result.maatregel.id;  
            this.maatregelSelect.val(maatregelId);
            JMaatregelService.getVragen(maatregelId,function (data){
                me.handleGetVragen(data);
                me.populateForm(result);
            });
        }else if (data.error){
            alert(data.error);
        }
    },
    /**
     * populate the form
     */
    this.populateForm = function(result){
        var eigenschappen = result.eigenschappen;
        for (var e=0; e < eigenschappen.length; e++){
            var eigenschap = eigenschappen[e];
            //var vraagId=this.radioPrefix + eigenschap.deficode.substring(0,1);
            var el=document.getElementById(this.defiOptionPrefix+eigenschap.deficode);
            el.checked=true;
            if (eigenschap.hoeveelheid){
                var hEl = document.getElementById(this.inputPrefix+eigenschap.deficode.substring(0,1));
                if (hEl){
                    hEl.value=eigenschap.hoeveelheid;
                }
            }
            //fill the customInputs.
            if (eigenschap.customInputs){
                for (var c=0; c < eigenschap.customInputs.length; c++){
                    var customInput=eigenschap.customInputs[c];
                    var inputEl=document.getElementById(this.customInputPrefix+eigenschap.deficode+customInput.index);
                    if (inputEl){
                        inputEl.value=customInput.value;
                    }
                }
            }
        }
        if (result.hoeveelheid){
            var mhEl=document.getElementById("maatregel_hoeveelheid");
            if (mhEl){
                mhEl.value=result.hoeveelheid;
            }
        }
    },
    
    this.createMaatregelSelect = function(){
        var me=this;
        this.maatregelSelectText = $j("<span>Voeg een maatregel toe: </span>");
        this.maatregelContainer.html("");
        this.maatregelContainer.append(this.maatregelSelectText);
        this.maatregelSelect = $j("<SELECT id='maatregelSelect'></SELECT>");
        this.maatregelContainer.append(this.maatregelSelect);            
        
        JMaatregelService.getMaatregelen(this.objectType,function (maatregelen){
            me.handleGetMaatregelen(maatregelen)            
            //add change function
            me.maatregelSelect.change(function(){
                me.maatregelSelectChanged();
            });
        });
    },
    /**
     * Start new maatregel
     */
    this.newMaatregel=function(){
        this.maatregelId=null;
        this.buildVraagForm();
    },
    /**
     * Handle function when maatregels are returned.
     */
    this.handleGetMaatregelen = function (data){        
        dwr.util.removeAllOptions("maatregelSelect");
        dwr.util.addOptions("maatregelSelect",[ "Kies maatregel..."]);
        var response = JSON.parse(data);
        if (response.success){
            dwr.util.addOptions("maatregelSelect",response.results,"id","omschrijving");
        }
    },
    /**
     * Handle when maatregel changed.
     */
    this.maatregelSelectChanged = function(){
        this.clearQuestions();
        var val=this.maatregelSelect.val();
        if (val){
            var me =this;
            JMaatregelService.getVragen(val,function (data){
                me.handleGetVragen(data)
            });
        }
    },
    /**
     * Handle when the vragen are returned.
     */
    this.handleGetVragen= function(data){        
        var response = JSON.parse(data);
        if (response.success){
            if (response.result){
                this.currentCrow=new CrowObject(response.result);
                this.buildVraagForm();
            }
        }else{
            this.currentCrow=null;
        }
    },
    /**
     *Build form
     */
    this.buildVraagForm = function(){        
        this.clearQuestions();        
        this.maatregelSelectText.html("Maatregel: ");
        this.questionObject = $j("<div class='maatregel_vraag'></div>");
        this.maatregelContainer.append(this.questionObject);           
        if (this.currentCrow.getMaatregelTekst()){
            var tekst=this.currentCrow.getMaatregelTekst();
            if (this.currentCrow.getCustomInputs()){
                //backwards for string changes.
                tekst = this.insertCustomInputs(tekst,this.currentCrow.getCustomInputs());                
            }   
            this.questionObject.html("<div class='maatregel_vraagTekst'>"+tekst+"</div>");                    
        }if (this.currentCrow.getMaatregelEenheid()){
            var eenheidEl= $j("<div class='maatregel_vraagHoeveelheid'></div>");
            eenheidEl.append("Hoeveelheid: ");
            eenheidEl.append($j("<input id='maatregel_hoeveelheid' type='text'></input>"));
            eenheidEl.append(" "+this.currentCrow.getMaatregelEenheid());
            this.questionObject.append(eenheidEl);
        }
        var me = this;
        var vragen=this.currentCrow.getVragen();
        for (var v=0; v < vragen.length; v++){
            var vraag = vragen[v];  
            var vraagEl=$j("<div id='vraagSelect"+vraag.id+"' class='maatregel_vraagSelect'></div>");
            this.questionObject.append(vraagEl);
            if (vraag.vraagOpties){
                var id="questionSelect_"+vraag.id;
                var radioName=this.radioPrefix+vraag.id;
                vraagEl.append("<hr/>");
                var eenheid=null;
                for (var o = 0; o < vraag.vraagOpties.length; o++){
                    var optie = vraag.vraagOpties[o];
                    
                    var tekst=optie.tekst;
                    if (optie.customInputs){
                        //backwards for string changes.
                        tekst=this.insertCustomInputs(tekst, optie.customInputs,optie.deficode);
                    }                    
                    var radioEl=$j("<input id="+this.defiOptionPrefix+optie.deficode+" type='radio' name='"+radioName+"' value='"+optie.deficode+"'></input>"+tekst+"<br/>");
                    //check first
                    if (o==0){
                        radioEl.attr("checked","checked");
                    }
                    vraagEl.append(radioEl);
                    /*radioEl.change(function(){
                        me.vraagRadioChanged(this,vraag.id);
                    });*/
                    if (optie.eenheid){
                        eenheid=optie.eenheid;
                    }
                }
                if (eenheid){
                    var amountInput= $j("<input type='tekst'></input>");
                    amountInput.attr("id",this.inputPrefix+vraag.id);
                    vraagEl.append(amountInput);
                    vraagEl.append(" "+eenheid);
                }
            }
        }
            
        var buttonDiv = $j("<div class='maatregel_button'></div>");
        var saveButton = $j("<button type='button'>Opslaan</button>");
        saveButton.click(function(){
            me.save();
        });            
        buttonDiv.append(saveButton);
        var cancelButton= $j("<button type='button'>Annuleer</button>");
        cancelButton.click(function(){
            me.refresh();
        });            
        buttonDiv.append(cancelButton);
        this.questionObject.append(buttonDiv);
    },
    /**
     *Refresh the component.
     */
    this.refresh = function(){
        this.refreshMaatregelenList();
        this.maatregelId=null;
        this.clearQuestions();
        if (this.maatregelSelect){
            this.maatregelSelect.val("");
        }
    }
    
    this.clearQuestions = function(){
        if (this.questionObject){
            this.questionObject.remove();
        };
    },
    /**
     *Test the component.
     */
    this.test = function (){
        //this.newMaatregel("Gras");
        //this.showMaatregel(13);
    },
    /**
     * Sent the values to the backend
     */
    this.save = function (){
        var me =this;
        var values=this.getFormValues();        
        var valueString=JSON.stringify(values);
        JMaatregelService.save(valueString,function(data){
            data = JSON.parse(data);
            if (data.success){
                me.refresh();
            }else if (data.error){
                alert(data.error);
            }
        });
    },
    /**
     * Get all the form values
     * @return a javascript with values.
     */
    this.getFormValues = function(){
        var obj={};
        if (this.maatregelId){
            obj.id=this.maatregelId;
        }
        //get maatregel
        obj.maatregel = this.maatregelSelect.val();
        //get hoeveelheid for maatregel        
        var maatregel_hoeveelheid=document.getElementById("maatregel_hoeveelheid");
        if (maatregel_hoeveelheid && maatregel_hoeveelheid.value.length>0){
            obj.hoeveelheid = maatregel_hoeveelheid.value;
        }        
        //get object type
        obj.objectType = this.objectType;
        //get featureId
        obj.featureId = this.featureId;
        //get bronid
        obj.bronId= this.bronId;
        //get vraag answers
        var vraagIds= this.currentCrow.getVraagIds();
        obj.eigenschappen = [];
        for (var i=0; i < vraagIds.length; i++){
            var checkedRadio=$j("input[name='"+this.radioPrefix+vraagIds[i]+"']:checked");
            if (checkedRadio){
                var eigenschap={};
                eigenschap.deficode=checkedRadio.val();
                var hoeveelheidInput=document.getElementById(this.inputPrefix+vraagIds[i]);
                if (hoeveelheidInput && hoeveelheidInput.value.length){
                    eigenschap.hoeveelheid=hoeveelheidInput.value;
                }
                var count=0;
                var customInputEl = document.getElementById(this.customInputPrefix+eigenschap.deficode+count);                 
                while (customInputEl){
                    if (eigenschap.customInputs==undefined){
                        eigenschap.customInputs=[];
                    }
                    eigenschap.customInputs.push({
                        index: count,
                        value: customInputEl.value
                    });
                    count++;
                    customInputEl = document.getElementById(this.customInputPrefix+eigenschap.deficode+count); 
                }
                obj.eigenschappen.push(eigenschap);
            }
        }
        return obj;
    },
    
    this.removeMaatregel = function(id){
        var me = this;
        JMaatregelService.deleteMaatregel(id,function(data){
            data = JSON.parse(data);
            if (data.success){
                me.refresh();
            }else if (data.error){
                alert(data.error);
            }
        });
    },
    
    /**
     * insert the customInputs in the text
     * @text the text
     * @customInputs the customInputs
     * @extraInputId extra string for id for input
     * @return the tekst including html input fields
     */
    this.insertCustomInputs = function (text,customInputs,extraInputId){
        if (extraInputId==undefined || extraInputId ==null){
            extraInputId="";
        }
        for (var c=customInputs.length-1; c >=0 ; c--){
            var customInput = customInputs[c];

            //there are 4 points but if length of input field is smaller then that's the length
            var lengthOfPoints=4;
            if (customInput.length < lengthOfPoints){
                lengthOfPoints=customInput.length;
            }
            //check if there are points at the given location.
            if (text.substr(customInput.startIndex, lengthOfPoints)==".......".substr(0, lengthOfPoints)){
                var inputString = " <input id='"+this.customInputPrefix + extraInputId +c+"' type='text' maxlength='"+customInput.length+"' size='"+customInput.length+"'></input> ";
                var tempText = text.substring(0,customInput.startIndex);
                tempText+=inputString;
                tempText+= text.substring(customInput.startIndex+lengthOfPoints+1);
                text=tempText;
            }
        }
        return text;
    }
    
    
    
    this.init();
    
}
/**
 * Object om makkelijk crow info te raadplegen.
 */
function CrowObject(obj){
    this.crow=obj;
    
    this.getMaatregelTekst = function(){
        return this.crow.tekst;
    },  
    this.getMaatregelEenheid = function(){
        return this.crow.eenheid;
    },
    this.getCustomInputs = function(){
        return this.crow.customInputs
    },
    this.getVragen = function(){
        return this.crow.vragen;
    },
    /**
     *Get 'eenheid' from deficode
     */
    this.getEenheid = function(deficode){
        var vraagOptie =this.getVraagOptie(deficode);
        if (vraagOptie){
            return vraagOptie.eenheid;
        }
        return null;
    },
    /**
     * Get options of question with deficode.
     */
    this.getVraagOptie = function (deficode){
        for (var v=0; v < this.crow.vragen.length; v++){
            var vraag = this.crow.vragen[v];   
            for (var o=0; o < vraag.vraagOpties.length; o++){
                if (vraag.vraagOpties[o].deficode == deficode){
                    return vraag.vraagOpties[o];
                }
            }
        }
        return null;
    },
    /**
     * get the id's of the vragen
     * return array of ids
     */
    this.getVraagIds = function (){
        var vraagIds=[];
        for (var v=0; v < this.crow.vragen.length; v++){
            var vraag = this.crow.vragen[v]; 
            vraagIds.push(vraag.id);
        }
        return vraagIds;
    }
}
var maatregelComp=null;
function showMaatregel(objectType,bronId,featureId){
    if (maatregelComp==null){
        maatregelComp=new MaatregelComponent();
    }
    maatregelComp.open(objectType,bronId,featureId);
}
/*setTimeout(function(){
    var m = new MaatregelComponent();    
    setTimeout(function(){
        m.open("Gras",1,"feature_1");
        m.test();
    },1000);
},1000);*/