B3PGissuite.defineComponent('LegendTabComponent', {
    extend: 'BaseComponent',
    defaultOptions: {
        formid: 'volgordeForm',
        orderboxId: 'orderLayerBox',
        sliderBoxId: 'transSlider',
        sliderId: 'slider',
        useSortableFunction: true,
        layerDelay: 5000,
        taboptions: {
            resizableContent: true
        }
    },
    reloadTimer: null,
    orderContainer: null,
    //the loading legend images (needed to abort loading)
    loadingLegendImages: {},
    //queue of the legend objects that needs to be loaded
    legendImageQueue: [],
    //slots that can be used to load the legend objects
    legendImageLoadingSpace: 1,
    selectedLayer: null,

    constructor: function LegendTabComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        var me = this;
        this.component = jQuery('<form></form>').attr({ 'id': this.options.formId });

        this.orderContainer = jQuery('<div></div>').attr({ 'id': this.options.orderboxId, 'class': this.options.orderboxId + ' tabvak_groot' });
        this.component.append(this.orderContainer);

        var slider = jQuery('<div></div>').attr({
            'id': this.options.sliderBoxId
        }).css({
            'height': '50px',
            'width': '260px',
            'padding-left': '5px'
        });
        slider.append(jQuery('<p></p>').text('Transparantie van alle voorgrondlagen.'));
        slider.append(jQuery('<div></div>').text('-').css({
            'float': 'left',
            'font-size': '22px',
            'padding-right': '3px',
            'margin-top': '-8px'
        }));
        slider.append(jQuery('<div></div>').attr({
            'id': this.options.sliderId
        }).css({
            'width': '215px',
            'float': 'left'
        }));
        slider.append(jQuery('<div></div>').text('+').css({
            'float': 'left',
            'font-size': '22px',
            'padding-left': '10px',
            'margin-top': '-6px'
        }));
        slider.append(jQuery('<div></div>').css({ 'clear': 'both' }));
        this.component.append(slider);
        
        /* TODO: useSortableFunction kunnen instellen via GVC 
         * Komt nu niet correct in this.options
        */
        this.options.useSortableFunction = true;
        
        if(this.options.useSortableFunction) {
            this.component.append(jQuery('<p></p>').text('Bepaal de volgorde waarin de kaartlagen getoond worden'));
            var knoppenContainer = jQuery('<div></div>');
            knoppenContainer.append(jQuery('<input />').attr({
                type: 'button',
                value: 'Omhoog',
                'class': 'knop'
            }).click(function() {
                me.moveSelectedUp();
            }));
            knoppenContainer.append(jQuery('<input />').attr({
                type: 'button',
                value: 'Omlaag',
                'class': 'knop'
            }).click(function() {
                me.moveSelectedDown();
            }));
            knoppenContainer.append(jQuery('<input />').attr({
                type: 'button',
                value: 'Aanpassen',
                'class': 'knop'
            }).click(function() {
                me.refreshMapVolgorde();
            }));
            this.component.append(knoppenContainer);
        }
    },
    afterRender: function() {
        jQuery("#" + this.options.sliderId).slider({
            min: 0,
            max: 100,
            value: 100,
            animate: true,
            change: function(event, ui) {
                var opacity = 1.0 - (ui.value)/100;
                var layers = B3PGissuite.vars.webMapController.getMap().getLayers();
                for( var i = 0 ; i < layers.length ; i++ ){
                    var l = layers[i];
                    if(!l.getOption("background")) {
                        l.setOpacity (opacity);
                    }
                }
            }
        });
        if(this.options.useSortableFunction) {
            this.orderContainer.sortable({
                stop: function() {
                    setTimerForReload();
                },
                start: function() {
                    clearTimerForReload();
                }
            });
        }
    },
    setTimerForReload: function() {
        var me = this;
        this.reloadTimer = setTimeout(function() {
            me.refreshMapVolgorde();
        }, this.options.layerDelay);
    },
    clearTimerForReload: function() {
        clearTimeout(this.reloadTimer);
    },

    refreshMapVolgorde: function() {
        this.refreshLegendBox();
        B3PGissuite.viewerComponent.refreshLayer(true);
        var treeComponent = B3PGissuite.get('TreeTabComponent');
        if(treeComponent) {
            treeComponent.syncLayerCookieAndForm();
        }
    },

    refreshLegendBox: function() {
        this.resetLegendImageQueue();

        var res, me = this;
        if (B3PGissuite.config.tilingResolutions && B3PGissuite.config.tilingResolutions !== "") {
            res = B3PGissuite.vars.webMapController.getMap().getResolution();
        } else {
            res = B3PGissuite.vars.webMapController.getMap().getScaleHint();
        }

        B3PGissuite.vars.webMapController.unRegisterEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE, B3PGissuite.vars.webMapController.getMap(), function() {
            me.refreshLegendBox();
        }, this);

        var visibleLayerItems = new Array();
        var invisibleLayerItems = new Array();

        for (var k = 0; k < B3PGissuite.vars.enabledLayerItems.length; k++) {
            var item = B3PGissuite.vars.enabledLayerItems[k];
            var found = false;

            // ouder moet aan staan en binnen schaal
            if (B3PGissuite.config.useInheritCheckbox) {
                var object = document.getElementById(item.id);
                //Item alleen toevoegen aan de layers indien
                //parent cluster(s) allemaal aangevinkt staan of
                //geen cluster heeft   
                var treeComponent = B3PGissuite.get('TreeTabComponent');
                
                if (treeComponent && !treeComponent.itemHasAllParentsEnabled(object) || (!B3PGissuite.viewercommons.isItemInScale(item, res))) {
                    found = true;
                    invisibleLayerItems.push(item);
                }
                // alleen binnen schaal tonen in legenda
            } else {
                if (!B3PGissuite.viewercommons.isItemInScale(item, res)) {
                    found = true;
                    invisibleLayerItems.push(item);
                }
            }

            if (!found) {
                visibleLayerItems.push(item);
            }
        }

        B3PGissuite.vars.enabledLayerItems = new Array();
        var totalLength = 0;
        if (orderLayerBox) {
            totalLength = orderLayerBox.childNodes.length;
        }

        //Kijk of ze al bestaan en in die volgorde staan.
        for (var i = (totalLength - 1); i > -1; i--) {
            var stillVisible = false;
            var itemId = this.splitValue(orderLayerBox.childNodes[i].id)[0];
            for (var m = 0; m < visibleLayerItems.length; m++) {
                if (visibleLayerItems[m].id == itemId) {
                    var foundLayerItem = visibleLayerItems[m];
                    B3PGissuite.vars.enabledLayerItems.push(foundLayerItem);
                    visibleLayerItems.splice(m, 1);
                    stillVisible = true;
                }
            }
            if (!stillVisible) {
                //orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
                //$j(orderLayerBox.childNodes[i]).remove();
                $j(orderLayerBox.childNodes[i]).css("display", "none");
            }
        }

        if (visibleLayerItems.length > 0) {
            B3PGissuite.vars.enabledLayerItems = B3PGissuite.vars.enabledLayerItems.concat(visibleLayerItems);
        }

        this.resetLegendImageQueue();

        for (var j = 0; j < B3PGissuite.vars.enabledLayerItems.length; j++) {
            item = B3PGissuite.vars.enabledLayerItems[j];

            this.addLayerToLegendBox(item, false);
        }

        if (invisibleLayerItems.length > 0) {
            B3PGissuite.vars.enabledLayerItems = B3PGissuite.vars.enabledLayerItems.concat(invisibleLayerItems);
        }
    },
    /** TODO: Improve this code using jQuery */
    createLegendDiv: function(item) {
        var id = item.id + '##' + item.wmslayers;
        var myImage = new Image();
        var me = this;
        myImage.name = item.title;
        myImage.id = id;
        myImage.onerror = function() {
            me.imageOnerror(this);
        };
        myImage.onload = function() {
            me.imageOnload(this);
        };

        var spanEl = document.createElement("span");
        spanEl.innerHTML = ' ' + item.title + '<br />';
        spanEl.className = 'orderLayerSpanClass';

        var div = document.createElement("div");
        div.name = id;
        div.id = id;
        div.title = item.title;
        div.className = "orderLayerClass";
        div.appendChild(spanEl);
        div.theItem = item;

        /* nieuw */
        div.onclick = function() {
            me.selectLayer(this);
        };

        if (item.legendurl !== undefined) {
            myImage.src = item.legendurl;
            this.loadingLegendImages[id] = myImage;
        } else {
            myImage.onerror();
        }

        div.onclick = function() {
            me.selectLayer(this);
        };

        if (item.hide_legend) {
            div.style.display = "none";
        }
        return div;
    },
    imageOnerror: function(img) {
        img.style.height = '0';
        img.style.width = '0';
        img.height = 0;
        img.width = 0;
        //release 1 loading space
        this.legendImageLoadingSpace++;
        this.loadNextInLegendImageQueue();
    },
    imageOnload: function(img) {
        //if not is a loading image then don't add to the DOM
        if (this.loadingLegendImages[img.id] !== undefined) {
            if(parseInt(img.height, 10) > 5) {
                var legendimg = document.createElement("img");
                legendimg.src = img.src;
                legendimg.onerror = img.onerror;
                legendimg.className = "imagenoborder";
                legendimg.alt = img.name;
                legendimg.title = img.name;
                var legendImage = document.getElementById(img.id);
                if (legendImage) {
                    legendImage.appendChild(legendimg);
                }
            }
            //done loading remove
            delete this.loadingLegendImages[img.id];
            //release 1 loading space
            this.legendImageLoadingSpace++;
            this.loadNextInLegendImageQueue();
        }
    },

    //adds a layer to the legenda
    //if atBottomOfType is set to true the layer will be added at the bottom of its type (background or top type)
    addLayerToLegendBox: function(theItem, atBottomOfType) {
        //check if already exists in legend
        var layerDiv = this.findLayerDivInLegendBox(theItem);
        if (layerDiv !== null) {
            if ($j(layerDiv).css("display") == "none") {
                var beforeChild = this.findBeforeDivInLegendBox(theItem, atBottomOfType);
                if (beforeChild === null) {
                    $j(orderLayerBox).append($j(layerDiv));
                } else {
                    /* TODO: Nagaan of bovenin toevoegen kan. */
                    if (beforeChild.id == layerDiv.id) {
                        $j(orderLayerBox).prepend($j(layerDiv));
                    } else {
                        $j(beforeChild).before($j(layerDiv));
                    }
                    //$j(orderLayerBox).insertBefore($j(layerDiv),beforeChild);
                }
            }
            $j(layerDiv).css("display", theItem.hide_legend ? "none" : "block");
            return;
        }

        this.legendImageQueue.push({
            theItem: theItem,
            atBottomOfType: atBottomOfType
        });
        this.loadNextInLegendImageQueue();
    },

    /**
     Load the next image object.
     */
    loadNextInLegendImageQueue: function() {
        if (this.legendImageLoadingSpace > 0 && this.legendImageQueue.length > 0) {
            //consume 1 loading place
            this.legendImageLoadingSpace--;
            var nextLegend = this.legendImageQueue.shift();
            var theItem = nextLegend.theItem;
            var atBottomOfType = nextLegend.nextLegend;

            var div = this.createLegendDiv(theItem);

            var beforeChild = null;

            if (orderLayerBox) {
                if (orderLayerBox.hasChildNodes()) {
                    beforeChild = this.findBeforeDivInLegendBox(theItem, atBottomOfType);
                }
                if (beforeChild === null) {
                    orderLayerBox.appendChild(div);
                } else {
                    orderLayerBox.insertBefore(div, beforeChild);
                }

            }

        }
    },
    resetLegendImageQueue: function() {
        //B3PGissuite.vars.loadingLegendImages= new Object();
        this.legendImageQueue = [];
        this.legendImageLoadingSpace = 2;
    },
    findLayerDivInLegendBox: function(theItem) {
        var id = theItem.id + '##' + theItem.wmslayers;

        if (orderLayerBox) {
            for (var i = 0; i < orderLayerBox.childNodes.length; i++) {
                var child = orderLayerBox.childNodes.item(i);
                if (child.id == id) {
                    return child;
                }
            }
        }

        return null;
    },

    findBeforeDivInLegendBox: function(theItem, atBottomOfType) {
        var beforeChild = null, orderLayerItem;
        //place layer before the background layers.
        if (theItem.background) {
            if (atBottomOfType) {
                beforeChild = null;
            } else {
                for (var i = 0; i < orderLayerBox.childNodes.length; i++) {
                    orderLayerItem = orderLayerBox.childNodes.item(i).theItem;
                    if (orderLayerItem) {
                        if (orderLayerItem.background) {
                            beforeChild = orderLayerBox.childNodes.item(i);
                            break;
                        }
                    }
                }
            }
        } else {
            if (atBottomOfType) {
                var previousChild = null;
                for (var j = 0; j < orderLayerBox.childNodes.length; j++) {
                    orderLayerItem = orderLayerBox.childNodes.item(j).theItem;
                    if (orderLayerItem && orderLayerItem.background) {
                        beforeChild = previousChild;
                        break;
                    }
                    previousChild = orderLayerBox.childNodes.item(j);
                }
            } else {
                beforeChild = orderLayerBox.firstChild;
            }
        }
        return beforeChild;
    },

    deleteAllLayers: function() {
        var totalLength = orderLayerBox.childNodes.length;
        for (var i = (totalLength - 1); i > -1; i--) {
            document.getElementById(this.splitValue(orderLayerBox.childNodes[i].id)[0]).checked = false;
            orderLayerBox.removeChild(orderLayerBox.childNodes[i]);
        }
        this.enabledLayerItems = [];
        var treeComponent = B3PGissuite.get('TreeTabComponent');
        if (treeComponent !== null) {
            treeComponent.syncLayerCookieAndForm();
            treeComponent.doRefreshLayer();
        }
    },
            
    splitValue: function(str) {
        return str.split('##');
    },

    selectLayer: function(element){
        if (this.selectedLayer){
            this.selectedLayer.className="orderLayerClass";
        }
        element.className="orderLayerClassSelected";
        this.selectedLayer=element;
    },
    switchLayers: function(element1,element2){
        var name=element1.name;
        var className=element1.className;
        var innerHTML=element1.innerHTML;
        var id=element1.id;
        var title= element1.title;

        element1.name=element2.name;
        element1.className=element2.className;
        element1.innerHTML=element2.innerHTML;
        element1.id=element2.id;
        element1.title=element2.title;

        element2.name=name;
        element2.className=className;
        element2.innerHTML=innerHTML;
        element2.id=id;
        element2.title=title;
    },
    moveSelected: function(amount){
        if (this.selectedLayer){
            var orderLayerBox= document.getElementById("orderLayerBox");
            var orderLayers=orderLayerBox.childNodes;
            for (var i=0; i < orderLayers.length; i++){
                if (orderLayers[i].name==this.selectedLayer.name){
                    if (i+amount > -1 && i+amount < orderLayers.length){
                        this.switchLayers(orderLayers[i+amount],orderLayers[i]);
                        this.selectedLayer=orderLayers[i+amount];
                        return;
                    }
                }
            }
        }else{
            alert("Selecteer eerst een kaart om te verplaatsen");
        }
    },
    moveSelectedDown: function(){
        this.moveSelected(1);
    },
    moveSelectedUp: function(){
        this.moveSelected(-1);
    }
});