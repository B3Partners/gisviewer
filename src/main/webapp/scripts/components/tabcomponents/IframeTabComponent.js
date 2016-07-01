B3PGissuite.defineComponent('IframeTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        src: '',
        taboptions: {
            tabvakClassname: 'tabvak_with_iframe'
        }
    },
    constructor: function IframeTabComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        var src = this.options.src;
        if(B3PGissuite.config.cmsPageId) {
            src = B3PGissuite.viewercommons.addToQueryString(src, 'cmsPageId', B3PGissuite.config.cmsPageId);
        }
        if(B3PGissuite.config.bookmarkAppcode) {
            src = B3PGissuite.viewercommons.addToQueryString(src, 'appCode', B3PGissuite.config.bookmarkAppcode);
        }
        if(B3PGissuite.commons.getDebug()) {
            src = B3PGissuite.viewercommons.addToQueryString(src, 'debug', 'true');
        }
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