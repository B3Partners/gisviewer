/* BaseComponent */
B3PGissuite.defineComponent('BaseComponent', {
    defaultOptions: {
        id: '',
        tabid: '',
        title: ''
    },
    constructor: function BaseComponent(options) {
        this.options = jQuery.extend(this.defaultOptions, options);
        this.component = null;
    },
    init: function() {
        throw('Init must be implemented in a sub-class');
    },
    render: function(domId) {
        this.tabPanel = jQuery('#' + domId);
        this.tabPanel.append(this.component);
        this.afterRender();
    },
    renderTab: function(tabComponent) {
        this.tabComponent = tabComponent;
        var domId = this.tabComponent.createTab(this.options.tabid, this.options.title, this.options.taboptions || {});
        this.render(domId);
    },
    afterRender: function() {},
    getTabComponent: function() {
        if(this.tabComponent) return this.tabComponent;
        return null;
    },
    getTabPanel: function() {
        return this.tabPanel;
    }
});