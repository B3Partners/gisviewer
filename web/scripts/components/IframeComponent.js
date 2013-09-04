B3PGissuite.defineComponent('IframeComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        src: '',
        taboptions: {
            tabvakClassname: 'tabvak_with_iframe'
        }
    },
    constructor: function IframeComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        this.component = jQuery('<iframe></iframe>').attr({
            'src': this.options.src,
            'id': this.options.id,
            'name': this.options.id,
            'frameborder': 0
        });
        if(jQuery('html').hasClass('lt-ie9')) {
            this.component[0].allowTransparency = 'allowtransparency';
        }
    }
});