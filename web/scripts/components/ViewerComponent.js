/* Helper function to create a Component */
B3PGissuite.createComponent = function(className, options) {
    if(typeof B3PGissuite.component[className] === 'undefined') {
        throw('The class ' + className + ' is not defined. Maybe you forgot to include the source file?');
    }
    if(typeof B3PGissuite.idregistry[className] === 'undefined') {
        B3PGissuite.idregistry[className] = 0;
    }
    var nextid = B3PGissuite.idregistry[className]++;
    // Component id is lowercased className + incremental number
    var instanceId = (className.charAt(0).toLowerCase() + className.slice(1)) + nextid;
    B3PGissuite.instances[instanceId] = new B3PGissuite.component[className](options);
    return B3PGissuite.instances[instanceId];
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
/* Helper function to get access to a component (for example var tree = B3PGissuite.get('TreeComponent'); ) */
B3PGissuite.get = function(className, id) {
    // Default instanceid is zero (the first instance)
    var idnumber = id || 0;
    var instanceId = (className.charAt(0).toLowerCase() + className.slice(1)) + idnumber;
    if(typeof B3PGissuite.instances[instanceId] === 'undefined') {
        return null;
    }
    return B3PGissuite.instances[instanceId];
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
        var domId = tabComponent.createTab(this.options.tabid, this.options.title, this.options.taboptions || {});
        this.render(domId);
    },
    afterRender: function() {}
});