B3PGissuite.defineComponent('Layout', {

    singleton: true,

    tabComponents: {
        leftTab: null,
        rightTab: null
    },

    constructor: function Layout() {
        this.init();
    },

    init: function() {},

    setTabComponents: function(rightTabComponent, leftTabComponent) {
        this.tabComponents = {
            leftTab: leftTabComponent,
            rightTab: rightTabComponent
        };
    },

    createLayout: function(afterElement) {
        var me = this,
            noOfTabs = this.tabComponents.rightTab.getTabCount(),
            noLeftTabs = this.tabComponents.leftTab.getTabCount();
        if(B3PGissuite.config.usePanel) {
            var infobalk = jQuery('<div></div>').attr('id', 'informatiebalk').addClass('infobalk')
                                .append(jQuery('<div></div>').html('INFORMATIE').addClass('infobalk_description'))
                                .append(jQuery('<div></div>').html('&nbsp;').addClass('infobalk_actions'));
            var dataframediv = jQuery('<div></div>').attr('id', 'dataframediv').addClass('dataframediv')
                                    .html('<iframe id="dataframe" name="dataframe" frameborder="0" src="viewerwelkom.do?cmsPageId=' + B3PGissuite.config.cmsPageId + '"></iframe>');
            afterElement.after(dataframediv);
            afterElement.after(infobalk);
            afterElement = dataframediv;
        }
        if(B3PGissuite.config.usePanelControls) {
            var panelControls = jQuery('<div></div>').attr('id', 'panelControls');
            if(noOfTabs > 0) {
                panelControls.append(jQuery('<div></div>').attr('id', 'rightControl').addClass('right_open').click(function() {
                    me.panelResize('right');
                }).append('<a href="#"></a>'));
            }
            if(noLeftTabs > 0) {
                panelControls.append(jQuery('<div></div>').attr('id', 'leftControl').addClass('left_closed').click(function() {
                    me.panelResize('left');
                }).append('<a href="#"></a>'));
            }
            panelControls.append(jQuery('<div></div>').attr('id', 'onderbalkControl').addClass('bottom_open').click(function() {
                    me.panelResize('below');
                }).append('<a href="#"></a>'));
            afterElement.after(panelControls);
        }
        // Hide tabs when there is no content
        if(noLeftTabs === 0) {
            $j('#content_viewer').addClass('tablinks_verborgen').removeClass('tablinks_open');
        }
        if(noOfTabs === 0) {
            $j('#content_viewer').addClass('tabrechts_verborgen').removeClass('tabrechts_open');
        }
        // Show infopanel below when set
        if(!B3PGissuite.config.usePopup && B3PGissuite.config.usePanel) {
            $j('#content_viewer').addClass('dataframe_open');
        }
    },

    prepareTabs: function() {
        // Show tabs for correct widht calculations
        $j('#content_viewer').addClass('tablinks_open');
        $j('#content_viewer').addClass('tabrechts_open');
    },

    /*
     * Bit of a hack to use configured tab width in combination with SCSS created stylesheets
     * We need some of the SCSS configured values in addition to the Gisviewerconfig value for tab width
     * We solved this by creating a css-properties container (#css_props) and assigned some CSS values
     * to that DIV so we can read those with JS. We combine these values with the tabWidth configured in
     * the Gisviewerconfig using the same calculation used in SCSS. We append this styling to the head.
     */
    configureTabWidth: function() {
        var extramargin = parseInt($j('#css_props').css('margin-left'), 10),
                defaultmargin = parseInt($j('#css_props').css('margin-right'), 10),
                csscontent = '';
        if (B3PGissuite.config.tabWidth) {
            // get margins configured in CSS
            var tabwidth = parseInt(B3PGissuite.config.tabWidth, 10),
                    tabwidth_margin = tabwidth + extramargin + (2 * defaultmargin);
            // CSS creation, same logic as in SCC stylesheet
            csscontent = '#content_viewer.tabrechts_open #tab_container, #content_viewer.tabrechts_open #tabjes, #content_viewer.tabrechts_open #nav {' +
                    'width: ' + tabwidth + 'px !important;' +
                    '}' +
                    '#content_viewer.tabrechts_open #mapcontent {' +
                    'right: ' + tabwidth_margin + 'px !important;' +
                    '}';
        }
        if (B3PGissuite.config.tabWidthLeft) {
            // get margins configured in CSS
            var tabwidthLeft = parseInt(B3PGissuite.config.tabWidthLeft, 10),
                    tabwidthleft_margin = tabwidthLeft + extramargin + (2 * defaultmargin);
            // CSS creation, same logic as in SCC stylesheet
            csscontent += '#content_viewer.tablinks_open #leftcontent, #content_viewer.tablinks_open #leftcontenttabjes, #content_viewer.tablinks_open #leftcontentnav {' +
                    'width: ' + tabwidthLeft + 'px !important;' +
                    '}' +
                    '#content_viewer.tablinks_open #mapcontent {' +
                    'left: ' + tabwidthleft_margin + 'px !important;' +
                    '}';
        }
        if (csscontent !== '') {
            $j("head").append("<style>" + csscontent + "</style>");
        }
    },

    switchTab: function(id) {
        if (this.tabComponents.rightTab.hasTab(id)) {
            this.tabComponents.rightTab.setActive(id);
        }
        if (this.tabComponents.leftTab.hasTab(id)) {
            this.tabComponents.leftTab.setActive(id);
        }
    },

    panelResize: function(dir){
        if(dir === 'left') {
            if($j('#content_viewer').hasClass('tablinks_open')) $j('#content_viewer').removeClass('tablinks_open').addClass('tablinks_dicht');
            else $j('#content_viewer').addClass('tablinks_open').removeClass('tablinks_dicht');
        }
        if(dir === 'right') {
            if($j('#content_viewer').hasClass('tabrechts_open')) $j('#content_viewer').removeClass('tabrechts_open').addClass('tabrechts_dicht');
            else $j('#content_viewer').addClass('tabrechts_open').removeClass('tabrechts_dicht');
        }
        if(dir === 'below') {
            if($j('#content_viewer').hasClass('dataframe_open')) $j('#content_viewer').removeClass('dataframe_open').addClass('dataframe_dicht');
            else $j('#content_viewer').addClass('dataframe_open').removeClass('dataframe_dicht');
        }
        if(B3PGissuite.viewerComponent) {
            B3PGissuite.viewerComponent.updateSizeOL();
        }
    },

    showTabvakLoading: function(message) {
        $j("#tab_container").append('<div class="tabvakloading"><div>' + message + '<br /><br /><img src="/gisviewer/images/icons/loadingsmall.gif" alt="Bezig met laden..." /></div></div>');
        $j("#tab_container").find(".tabvakloading").fadeTo(0, 0.8);
    },

    hideTabvakLoading: function() {
        $j("#tab_container").find(".tabvakloading").remove();
    },

    initHideLoadingScreen: function() {
        var me = this;
        /* Laadscherm na 60 seconden zelf weghalen
         * Hij zou weg moeten gaan in onAllLayersFinishedLoading in viewer.js
         */
        if (B3PGissuite.config.waitUntillFullyLoaded) {
            window.setTimeout(function() {
                me.hideLoadingScreen();
            }, 60000);
        } else {
            $j(document).ready(function(){
                me.hideLoadingScreen();
            });
        }
    },

    hideLoadingScreen: function() {
        $j("#loadingscreen").hide();
    }

});