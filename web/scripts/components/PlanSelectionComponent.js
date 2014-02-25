B3PGissuite.defineComponent('PlanSelectionComponent', {
    extend: 'BaseComponent',
    planEigenaarId: null,
    planId: null,
    plannen: {},
    plantypeAttribuutNaam: 'typePlan',
    planStatusAttribuutNaam: 'planstatus',
    tekstAttribuutNaam: 'documenten',
    selectedPlan: null,
    defaultOptions: {
        containerId: 'planselectcontainer',
        planContainerId: 'kolomTekst',
        selectPlanId: 'selectedPlan',
        eigenaarSelectName: 'eigenaarselect',
        typeSelectName: 'plantypeselect',
        statusSelectName: 'statusselect',
        planSelectName: 'planselect'
    },
    constructor: function PlanSelectionComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {

        /* de geconfigureerde planselectie id's staan als volgt in db
         * 3,1 waarbij eerste id voor eigenaren is en tweede voor plannen */
        if (B3PGissuite.config.planSelectieIds) {
            var planIds = ("" + B3PGissuite.config.planSelectieIds).split(",");
            this.planEigenaarId = planIds[0];
            this.planId = planIds[1];
        }

        this.component = jQuery('<div></div>').attr({id: this.options.containerId});

        var planContainer = jQuery('<div></div>').attr({id: this.options.planContainerId});
        var me = this;

        // Eigenaar select
        var eigenaar = jQuery('<p></p>');
        eigenaar.append(jQuery('<strong></strong>').text('Eigenaar'));
        eigenaar.append(jQuery('<br />'));
        eigenaar.append(jQuery('<select></select>').attr({
            'id': this.options.eigenaarSelectName,
            'name': this.options.eigenaarSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            me.eigenaarchanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plan eigenaar...').attr({'value': ''})));
        planContainer.append(eigenaar);

        // Type select
        var type = jQuery('<p></p>');
        type.append(jQuery('<strong></strong>').text('Type'));
        type.append(jQuery('<br />'));
        type.append(jQuery('<select></select>').attr({
            'id': this.options.typeSelectName,
            'name': this.options.typeSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            me.plantypechanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plantype...').attr({'value': ''})));
        planContainer.append(type);

        // Status select
        var status = jQuery('<p></p>');
        status.append(jQuery('<strong></strong>').text('Status'));
        status.append(jQuery('<br />'));
        status.append(jQuery('<select></select>').attr({
            'id': this.options.statusSelectName,
            'name': this.options.statusSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            me.statuschanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een planstatus...').attr({'value': ''})));
        planContainer.append(status);

        // Plan select
        var plan = jQuery('<p></p>');
        plan.append(jQuery('<strong></strong>').text('Plan'));
        plan.append(jQuery('<br />'));
        plan.append(jQuery('<select></select>').attr({
            'id': this.options.planSelectName,
            'name': this.options.planSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            me.planchanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plan...').attr({'value': ''})));
        planContainer.append(plan);

        planContainer.append(jQuery('<div></div>').attr('id', this.options.selectPlanId).text('Nog geen plan geselecteerd.'));

        this.component.append(planContainer);
    },
    afterRender: function() {
        /*Hier begint het zoeken:*/
        var me = this;
        if (me.planEigenaarId !== null && me.planEigenaarId > 0 && me.planId !== null && me.planId > 0) {
            JZoeker.zoek([me.planEigenaarId], "*", B3PGissuite.config.maxResults, function(list) {
                me.handleGetEigenaar(list);
            });
        }
    },
    handleGetEigenaar: function(list) {
        var eigenaarSelect = document.getElementById(this.options.eigenaarSelectName);
        if (eigenaarSelect) {
            eigenaarSelect.disabled = false;
            if (list !== null && list.length > 0) {
                //eigenaarselect
                dwr.util.removeAllOptions(this.options.eigenaarSelectName);
                dwr.util.addOptions(this.options.eigenaarSelectName, list, "id", "label");
            }
        }
    },
    /*Als er een eigenaar is gekozen.*/
    eigenaarchanged: function(element) {
        var me = this;
        if (element.value !== "") {
            dwr.util.removeAllOptions(me.options.typeSelectName);
            dwr.util.removeAllOptions(me.options.statusSelectName);
            dwr.util.removeAllOptions(me.options.planSelectName);

            dwr.util.addOptions(me.options.typeSelectName, ["Bezig met ophalen..."]);
            dwr.util.addOptions(me.options.statusSelectName, ["Bezig met ophalen..."]);
            dwr.util.addOptions(me.options.planSelectName, ["Bezig met ophalen..."]);

            JZoeker.zoek([me.planId], element.value, B3PGissuite.config.maxResults, function(list) {
                me.handleGetPlannen(list);
            });
            //geen nieuwe eigenaar kiezen tijdens de zoek opdracht
            document.getElementById(me.options.eigenaarSelectName).disabled = true;
            me.setSelectedPlan(null);
        }
    },
    handleGetPlannen: function(list) {
        var me = this;
        //klaar met zoeken dus eigenaar veld weer aan.
        document.getElementById(me.options.eigenaarSelectName).disabled = false;
        dwr.util.removeAllOptions(me.options.planSelectName);
        dwr.util.addOptions(me.options.planSelectName, list, "id", "label");
        //als niks gevonden dan tekstje tonen
        me.plannen = {};
        if (typeof list === 'undefined' || list.length === 0) {
            dwr.util.addOptions(me.options.planSelectName, ["Geen plannen gevonden"]);
        } else {
            me.plannen = list;
        }
        //update de typeselect filter en statusselect filter
        me.updateTypeSelect();
        me.updateStatusSelect();
    },
    /*Update select boxen*/
    updateTypeSelect: function() {
        dwr.util.removeAllOptions(this.options.typeSelectName);
        var typen = this.getDistinctFromPlannen(this.plantypeAttribuutNaam);
        dwr.util.addOptions(this.options.typeSelectName, typen);
    },
    updateStatusSelect: function() {
        dwr.util.removeAllOptions(this.options.statusSelectName);
        //als er al een type is geselecteerd, dan filteren.
        var filteredPlannen = this.plannen;
        if (document.getElementById(this.options.typeSelectName).value.length > 0) {
            filteredPlannen = this.filterPlannen(this.plantypeAttribuutNaam, document.getElementById(this.options.typeSelectName).value, filteredPlannen);
        }
        //alleen de statusen van de gefilterde plannen
        var statussen = this.getDistinctFromPlannen(this.planStatusAttribuutNaam, filteredPlannen);
        dwr.util.addOptions(this.options.statusSelectName, statussen);
    },
    updatePlanSelect: function() {
        dwr.util.removeAllOptions(this.options.planSelectName);
        var filteredPlannen = this.plannen;
        if (document.getElementById(this.options.typeSelectName).value.length > 0) {
            filteredPlannen = this.filterPlannen(this.plantypeAttribuutNaam, document.getElementById(this.options.typeSelectName).value, filteredPlannen);
        }
        if (document.getElementById(this.options.statusSelectName).value.length > 0) {
            filteredPlannen = this.filterPlannen(this.planStatusAttribuutNaam, document.getElementById(this.options.statusSelectName).value, filteredPlannen);
        }
        dwr.util.addOptions(this.options.planSelectName, filteredPlannen, "id", "label");
        if (typeof filteredPlannen === 'undefined' || filteredPlannen.length === 0) {
            dwr.util.addOptions(this.options.planSelectName, ["Er zijn geen plannen gevonden."]);
        }
    },
    /***
     *onchange events:
     *@param element
     */
    plantypechanged: function(element) {
        this.updateStatusSelect();
        this.updatePlanSelect();
        this.setSelectedPlan(null);
    },
    statuschanged: function(element) {
        this.updatePlanSelect(element.value);
        this.setSelectedPlan(null);
    },
    planchanged: function(element) {
        if (element.value != "") {
            var plan;
            var zoekConfigId;
            for (var i = 0; i < this.plannen.length; i++) {
                if (this.plannen[i].id == element.value) {
                    plan = this.plannen[i];
                    break;
                }
            }
            if (plan) {
                this.setSelectedPlan(plan);

                var ext = new Object();

                ext.minx = plan.minx;
                ext.miny = plan.miny;
                ext.maxx = plan.maxx;
                ext.maxy = plan.maxy;

                B3PGissuite.vars.webMapController.getMap("map1").zoomToExtent(ext);
            }
        }
    },
    /*Haalt een lijst met mogelijke waarden op met de meegegeven attribuutnaam uit de plannen*/
    getDistinctFromPlannen: function(attribuutnaam, plannenArray) {
        if (typeof plannenArray === 'undefined') {
            plannenArray = this.plannen;
        }

        var typen = new Array();
        for (var i = 0; i < plannenArray.length; i++) {
            var attributen = plannenArray[i].attributen;

            for (var e = 0; e < attributen.length; e++) {
                if (attributen[e].attribuutnaam == attribuutnaam) {
                    if (!arrayContains(typen, attributen[e].waarde)) {
                        typen.push(attributen[e].waarde);
                    }
                }
            }
        }
        return typen;
    },
    filterPlannen: function(attribuutType, value, plannenArray) {
        if (typeof plannenArray === 'undefined') {
            plannenArray = this.plannen;
        }
        var filteredPlannen = new Array();
        for (var i = 0; i < plannenArray.length; i++) {
            var attributen = plannenArray[i].attributen;
            for (var e = 0; e < attributen.length; e++) {
                if (attributen[e].attribuutnaam == attribuutType) {
                    if (value == attributen[e].waarde) {
                        filteredPlannen.push(plannenArray[i]);
                    }
                }
            }
        }
        return filteredPlannen;
    },
    setSelectedPlan: function(plan) {
        this.selectedPlan = plan;
        if (plan === null) {
            document.getElementById(this.options.selectPlanId).innerHTML = "Nog geen plan geselecteerd.";
        } else {
            //commentaar tool zichtbaar maken:
            document.getElementById(this.options.selectPlanId).innerHTML = "<p>Plan identificatie</p>" + plan.id;
        }
    }
});