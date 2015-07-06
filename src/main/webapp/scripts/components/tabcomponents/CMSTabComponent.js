B3PGissuite.defineComponent('CMSTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        tekstBlokken: []
    },
    constructor: function CMSTabComponent(options) {
        this.callParent(options);
        // If there is only 1 tekstblok, set tab title to title of tekstblok
        if(this.options.tekstBlokken.length === 1) {
            this.options.title = this.options.tekstBlokken[0].titel;
        }
        this.init();
    },
    init: function() {
        var component = jQuery('<div></div>');
        jQuery.each(this.options.tekstBlokken, function(index, tekstblok) {
            var container = jQuery('<div></div>').addClass('content_block_tab');
            container.append(jQuery('<div></div>').text(tekstblok.titel).addClass('content_title'));
            if(tekstblok.toonUrl) {
                container.append(
                    jQuery('<iframe></iframe>').attr({
                        'src': tekstblok.url,
                        'name': 'iframe_' + tekstblok.titel,
                        'id': 'iframe_' + tekstblok.titel,
                        'frameborder': '0'
                    }).addClass('iframe_tekstblok')
                );
            } else {
                var tekst = jQuery('<div></div>').addClass('inleiding_body').html(tekstblok.tekst);
                if(tekstblok.url && tekstblok.url !== '') {
                    tekst.append('Meer informatie: ');
                    tekst.append(jQuery('<a></a>').text(tekstblok.url).attr({
                        'href': tekstblok.url,
                        'target': '_new'
                    }));
                }
                container.append(tekst);
            }
            component.append(container);
        });
        this.component = component;
    }
});