B3PGissuite.defineComponent('IframeComponent', {
    extend: 'ViewerComponent',
    defaultOptions: {
        src: ''
    },
    constructor: function IframeComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        this.component = jQuery('<iframe></iframe>').attr({
            src: this.options.src,
            id: this.options.id,
            name: this.options.id,
            frameborder: 0
        });
        if(jQuery('html').hasClass('lt-ie9')) {
            this.component[0].allowTransparency = 'allowtransparency';
        }
    },
    renderTab: function(tabComponent) {
        var domId = tabComponent.createTab(this.options.tabid, this.options.title, {
            tabvakClassname: 'tabvak_with_iframe'
        });
        this.render(domId);
    }
});