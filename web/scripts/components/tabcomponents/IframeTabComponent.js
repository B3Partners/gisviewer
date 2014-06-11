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
            src = this.addToQueryString(src, 'cmsPageId', B3PGissuite.config.cmsPageId);
        }
        if(B3PGissuite.commons.getDebug()) {
            src = this.addToQueryString(src, 'debug', 'true');
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
    },
    addToQueryString: function(url, key, value) {
        var query = url.indexOf('?');
        if (query === url.length - 1) {
            // Strip any ? on the end of the URL
            url = url.substring(0, query);
            query = -1;
        }
        var anchor = url.indexOf('#');
        return (anchor > 0 ? url.substring(0, anchor) : url)
             + (query > 0 ? "&" + key + "=" + value : "?" + key + "=" + value)
             + (anchor > 0 ? url.substring(anchor) : "");
    }
});