B3PGissuite.defineComponent('VerkeersmonitorTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        src: "",
        taboptions: {
            tabvakClassname: 'tabvak_with_iframe'
        }
    },
    constructor: function SearchTabComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        var src = this.options.src;
        this.component = jQuery('<iframe></iframe>').attr({
            'src': src,
            'id': this.options.id,
            'name': this.options.id,
            'frameborder': 0
        });
        if(jQuery('html').hasClass('lt-ie9')) {
            this.component[0].allowTransparency = 'allowtransparency';
        }
    }
});