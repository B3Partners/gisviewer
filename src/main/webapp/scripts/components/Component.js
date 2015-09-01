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
    B3PGissuite.instances[instanceId] = new B3PGissuite.component[className](options || {});
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

    // Add event handling
    // Fire events
    B3PGissuite.component[className].prototype.fireEvent = function(evtName, evtData) {
        // Check if there are listeners registered
        if(B3PGissuite.events.hasOwnProperty(className) && B3PGissuite.events[className].hasOwnProperty(evtName)) {
            // Loop over all registered listeners
            for(var k = 0; k < B3PGissuite.events[className][evtName].length; k++) {
                // Listener to temp var
                var registeredListener = B3PGissuite.events[className][evtName][k];
                // Call the registered listener handler with scope and eventData
                registeredListener.handler.call(registeredListener.scope, evtData);
            }
        }
    };

    // Register event listeners
    B3PGissuite.component[className].prototype.addListener = function(clsName, evtName, handler, scope) {
        // Check if there are listeners registered for targetClass
        if(!B3PGissuite.events.hasOwnProperty(clsName)) {
            B3PGissuite.events[clsName] = {};
        }
        // Check if there are listeners registered for event
        if(!B3PGissuite.events[clsName].hasOwnProperty(evtName)) {
            B3PGissuite.events[clsName][evtName] = [];
        }
        // Add listener for classname + eventname
        B3PGissuite.events[clsName][evtName].push({handler: handler, scope: scope || this});
    };

    // Singleton classes are created immediately
    if(classDefinition.hasOwnProperty('singleton') && classDefinition.singleton) {
        B3PGissuite.createComponent(className);
    }
};

B3PGissuite.extendComponent = function(className, extension) {
    jQuery.extend(B3PGissuite.component[className].prototype, extension);
};

/* Helper function to get access to a component (for example var tree = B3PGissuite.get('TreeTabComponent'); ) */
B3PGissuite.get = function(className, id) {
    // Default instanceid is zero (the first instance)
    var idnumber = id || 0;
    var instanceId = (className.charAt(0).toLowerCase() + className.slice(1)) + idnumber;
    if(typeof B3PGissuite.instances[instanceId] === 'undefined') {
        return null;
    }
    return B3PGissuite.instances[instanceId];
};