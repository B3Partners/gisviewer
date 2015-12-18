B3PGissuite.defineComponent('LayerInfoTabComponent', {
    extend: 'BaseComponent',
    // Constructor
    constructor: function LayerInfoTabComponent(options) {
        this.callParent(options);
        this.layerInfo = {};
        this.visibleItems = {};
        this.numberVisibleItems = 0;
        this.addListener('TreeTabComponent', 'showLayerInfo', this.showLayerInfo);
        this.addListener('TreeTabComponent', 'hideLayerInfo', this.hideLayerInfo);
    },
    // Show the layer info text
    showLayerInfo: function(item) {
        // Check if component is inside tab
        if(this.tabComponent === null || this.tabPanel === null || this.tabContainer === null) {
            return;
        }
        // Get current scale
        var me = this;
        // Check if the layer is in scale and has a number for id
        if(isNaN(item.id)) return;
        // Text is in layerInfo object so show panel immediately
        if(this.layerInfo.hasOwnProperty(item.id)) {
            return this.showTabPanel(item);
        }
        // Text is not present yet in cache, so get text with Ajax
        JMapData.getKaartlaagInfoTekst(item.id, function(tekst) {
            // Text is not empty
            if (tekst && tekst !== "") {
                // Cache text
                me.layerInfo[item.id] = tekst;
                // Show left panel
                me.showTabPanel(item);
            }
        });
    },
    afterRender: function() {
        this.tabComponent = this.getTabComponent();
        this.tabPanel = this.getTabPanel();
        this.tabContainer = jQuery('<div></div>');
        if(this.tabComponent.isOnlyTab(this.options.tabid)) {
            this.tabComponent.setActive(this.options.tabid);
            this.tabPanel.append(jQuery('<div></div>').html('<a class="closeInfo" href="#">[x]</a>').css({ 'padding': '0 2px 5px 0' }).click(function() {
                for(var itemid in this.visibleItems) if(this.visibleItems.hasOwnProperty(itemid)) {
                    this.hideLayerInfo({ id: itemid });
                }
            }.bind(this)));
        }
        this.tabPanel.append(this.tabContainer);
        if(!this.tabComponent.isHidden() && this.tabComponent.isOnlyTab(this.options.tabid)) {
            this.tabComponent.toggleTab();
        }
    },
    // Make the text container and
    showTabPanel: function(item) {
        // Create unique ID
        var divid = 'layerInfo' + item.id,
            me = this,
            domItem = null;
        // Check if the text is present
        if(!this.layerInfo.hasOwnProperty(item.id)) return;
        // Check if the container is not present already
        if(!document.getElementById(divid)) {
            // Add the text and text container
            this.visibleItems[item.id] = divid;
            this.numberVisibleItems++;
            domItem = jQuery('<div id="' + divid + '" class="layerInfo" href="#"><a class="closeInfo" href="#">[x]</a>' + this.layerInfo[item.id] + '</div>');
            domItem.find('.closeInfo').click(function(e) {
                e.preventDefault();
                me.hideLayerInfo(item);
            });
            this.tabContainer.prepend(domItem);
        }
        // viewer.jsp variable and function
        if(this.tabComponent.isHidden() && this.tabComponent.isOnlyTab(this.options.tabid)) {
            // Show the leftpanel (if not visible already)
            this.tabComponent.toggleTab();
        }
    },
    // Hide the layer text for a layer
    hideLayerInfo: function(item) {
        // Check if component is inside tab
        if(this.tabComponent === null || this.tabPanel === null || this.tabContainer === null) {
            return;
        }
        // Check if the item is visible
        if(this.visibleItems.hasOwnProperty(item.id)) {
            // Remove from DOM
            jQuery('#' + this.visibleItems[item.id]).remove();
            // Remove from visible items list
            delete this.visibleItems[item.id];
            // Lower number of visible items
            this.numberVisibleItems--;
        }
        // If there are no visible items left
        if(this.numberVisibleItems === 0 && !this.tabComponent.isHidden() && this.tabComponent.isOnlyTab(this.options.tabid)) {
            // Hide the leftpanel (if visible)
            this.tabComponent.toggleTab();
        }
    }
});