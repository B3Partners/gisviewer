B3PGissuite.defineComponent('PlanSelectionComponent', {
    extend: 'ViewerComponent',
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
        this.component = jQuery('<div></div>').attr({ id: this.options.containerId });
        
        var planContainer = jQuery('<div></div>').attr({ id: this.options.planContainerId });
        
        // Eigenaar select
        var eigenaar = jQuery('<p></p>');
        eigenaar.append(jQuery('<b></b>').text('Eigenaar'));
        eigenaar.append(jQuery('<select></select>').attr({
            'id': this.options.eigenaarSelectName,
            'name': this.options.eigenaarSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            eigenaarchanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plantype...').attr({ 'value': '' })));
        planContainer.append(eigenaar);
        
        // Type select
        var type = jQuery('<p></p>');
        type.append(jQuery('<b></b>').text('Type'));
        type.append(jQuery('<select></select>').attr({
            'id': this.options.typeSelectName,
            'name': this.options.typeSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            plantypechanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plantype...').attr({ 'value': '' })));
        planContainer.append(type);
        
        // Status select
        var status = jQuery('<p></p>');
        status.append(jQuery('<b></b>').text('Status'));
        status.append(jQuery('<select></select>').attr({
            'id': this.options.statusSelectName,
            'name': this.options.statusSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            statuschanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een planstatus...').attr({ 'value': '' })));
        planContainer.append(status);
        
        // Plan select
        var plan = jQuery('<p></p>');
        plan.append(jQuery('<b></b>').text('Plan'));
        plan.append(jQuery('<select></select>').attr({
            'id': this.options.planSelectName,
            'name': this.options.planSelectName,
            'class': 'planselectbox',
            'size': 10,
            'disabled': true
        }).change(function() {
            planchanged(this);
        }).append(jQuery('<option></option>').text('Selecteer een plan...').attr({ 'value': '' })));
        planContainer.append(plan);
        
        planContainer.append(jQuery('<div></div>').attr('id', this.options.selectPlanId).text('Nog geen plan geselecteerd.'));
        
        this.component.append(planContainer);
    }
});