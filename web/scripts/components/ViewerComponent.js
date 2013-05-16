/* B3PGissuite namespace for components */
var B3PGissuite = {
    component: {}
};
/* Helper function to create a Component */
B3PGissuite.createComponent = function(className, options) {
    return new B3PGissuite.component[className](options);
};
/* Helper function to define a Component */
B3PGissuite.defineComponent = function(className, classDefinition) {
    // Constructor function of the classDefinition is the constructor for the new component
    B3PGissuite.component[className] = classDefinition.constructor;
    // Set prototype of new component to classDefinition (all functions and options in definition are accessible)
    B3PGissuite.component[className].prototype = classDefinition;
    // If the extend option is set, extend other component
    if(classDefinition.extend) {
        // Set the prototype of the component to the parents prototype, so all non-overridden functions from the parent are accessible
        B3PGissuite.component[className].prototype = jQuery.extend(B3PGissuite.createComponent(classDefinition.extend), B3PGissuite.component[className].prototype);
        // Set the contructor the the new component
        B3PGissuite.component[className].prototype.constructor = B3PGissuite.component[className];
        // Add the callParent function to be able to set the options on the parent object
        B3PGissuite.component[className].prototype.callParent = function(options) {
            // Extend the options with some defaultOptions (if present)
            options = jQuery.extend(classDefinition.defaultOptions || {}, options);
            // Call the parent constructor with the options
            B3PGissuite.component[classDefinition.extend].call(this, options);
        };
    }
};

/* ViewerComponent: basecomponent */
B3PGissuite.defineComponent('ViewerComponent', {
    defaultOptions: {
        id: '',
        tabid: '', 
        title: ''
    },
    constructor: function ViewerComponent(options) {
        this.options = jQuery.extend(this.defaultOptions, options);
        this.component = null;
    },
    init: function() {
        throw('Init must be implemented in a sub-class');
    },
    render: function(domId) {
        jQuery('#' + domId).append(this.component);
        this.afterRender();
    },
    renderTab: function(tabComponent) {
        var domId = tabComponent.createTab(this.options.tabid, this.options.title, {});
        this.render(domId);
    },
    afterRender: function() {}
});