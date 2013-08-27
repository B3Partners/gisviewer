B3PGissuite.defineComponent('TreeComponent', {
    extend: 'ViewerComponent',
    defaultOptions: {
        treeid: 'layermaindiv',
        tree: [],
        servicetrees: [],
        icons: {
            collapsed: '/gisviewer/images/treeview/plus.gif',
            expanded: '/gisviewer/images/treeview/minus.gif',
            leaf: '/gisviewer/images/treeview/leaft.gif'
        },
        expandAll: false
    },
    /**
     * Temporary list for init.
     */
    layersAan: [],
    clustersAan: [],
    /**
     * Actieve laag en actief cluster
     */
    activeAnalyseThemaId: '',
    activeClusterId: '',
    constructor: function TreeComponent(options) {
        this.callParent(options);
        this.init();
    },
    init: function() {
        this.component = jQuery('<div></div>');
        
        var treeContainer = jQuery('<div></div>')
            .append('<form></form>')
            .append('<div></div>').attr('id', this.options.treeid);
        this.component.append(treeContainer);
        
        var debugContainer = jQuery('<div></div>').attr('id', 'debug-content');
        this.component.append(debugContainer);
        
        for(var i in this.options.servicetrees) {
            this.component.append(jQuery('<div></div>').attr('id', 'layerTreeDiv_' + i));
        }
    },
    afterRender: function() {
        for(var i in this.options.servicetrees) {
            treeview_create({
                "id": 'layerTreeDiv_' + i,
                "root": this.options.servicetrees[i],
                "rootChildrenAsRoots": false,
                "itemLabelCreatorFunction": createServiceLeaf,
                "toggleImages": {
                    "collapsed": this.options.icons.collapsed,
                    "expanded": this.options.icons.expanded,
                    "leaf": this.options.icons.leaf
                },
                "saveExpandedState": true,
                "streeaveScrollState": true,
                "expandAll": true,
                "scope": this
            });
        }
        treeview_create({
            "id": this.options.treeid,
            "root": this.options.tree,
            "rootChildrenAsRoots": true,
            "itemLabelCreatorFunction": this.createLabel,
            "toggleImages": {
                "collapsed": this.options.icons.collapsed,
                "expanded": this.options.icons.expanded,
                "leaf": this.options.icons.leaf
            },
            "saveExpandedState": true,
            "saveScrollState": true,
            "expandAll": this.options.expandAll,
            "scope": this
        });
    },
    /**
     * Sort the layersAan variable
     */
    sortLayersAan: function() {
        this.layersAan.sort(function(a, b) {
            return a.theItem.order - b.theItem.order;
        });
    },
    /**
     * Get clustersAan
     */
    getClustersAan: function() {
        return this.clustersAan;
    },
    /**
     * Get activeAnalyseThemaId
     */
    getActiveAnalyseThemaId: function() {
        return this.activeAnalyseThemaId;
    },
    /**
     * layers bij opstart sorteren op order(belangnr+alfabet)
     * als order niet aangepast mag worden, dan kan dit weg
     */
    clickLayers: function() {
        for (var m=this.layersAan.length-1; m >=0 ; m--){
            this.checkboxClick(this.layersAan[m],true);
        }
    },

    /**
     * layer added in reverse order
     * layer with lowest order number should be on top
     * so added last
     */
    clickClusters: function() {
        for (var i=this.clustersAan.length-1; i >=0 ; i--){
            this.clusterCheckboxClick(this.clustersAan[i], true);
        }
    },
    enableCheckBoxById: function(id) {
        var el=document.getElementById(id);
        if (el) {
            el.checked = true;
            this.checkboxClick(el,false);
        }
    },

    activateCheckbox: function(id) {
        var obj = document.getElementById(id);
        if(obj!=undefined && obj!=null && !obj.checked) {
            document.getElementById(id).click();
        }
    },

    deActivateCheckbox: function(id) {
        if (id==undefined || id==null) {
            return;
        }
        var obj = document.getElementById(id);
        if(obj!=undefined && obj!=null && obj.checked) {
            document.getElementById(id).click();
        }
    },

    /**
     * Set the active thema to be able to fetch object info.
     * @param id The id of the thema.
     * @param label Label to display above the viewer.
     * @param overrule When true overrule the current active thema.
     * @return The active analyse thema.
    */
    setActiveThema: function(id, label, overrule) {
        if (!(id && id!=null && label && label!=null && overrule)) {
            return this.activeAnalyseThemaId;
        }

        if (((this.activeAnalyseThemaId==null || this.activeAnalyseThemaId.length == 0) &&
            (this.activeClusterId==null || this.activeClusterId.length==0)) || overrule){

            this.activeAnalyseThemaId = id;

            var atlabel = document.getElementById('actief_thema');
            if (atlabel && label && atlabel!=null && label!=null) {
                atlabel.innerHTML = '' + label;
            }

            if (document.forms[0] && document.forms[0].coords && document.forms[0].coords.value.length > 0){
                var tokens= document.forms[0].coords.value.split(",");
                var minx = parseFloat(tokens[0]);
                var miny = parseFloat(tokens[1]);
                var maxx;
                var maxy
                if (tokens.length ==4){
                    maxx = parseFloat(tokens[2]);
                    maxy = parseFloat(tokens[3]);
                }else{
                    maxx=minx;
                    maxy=miny;
                }
                onIdentify('',{
                    minx:minx,
                    miny:miny,
                    maxx:maxx,
                    maxy:maxy
                })
            }
        }
        return this.activeAnalyseThemaId;
    },

    addItemAsLayer: function(theItem){
        this.addLayerToEnabledLayerItems(theItem);
        syncLayerCookieAndForm();
        
        //If there is a orgainization code key then add this to the service url.
        if (theItem.wmslayers){
            var organizationCodeKey = theItem.organizationcodekey;
            if(B3PGissuite.config.organizationcode!=undefined && B3PGissuite.config.organizationcode != null && B3PGissuite.config.organizationcode != '' && organizationCodeKey!=undefined && organizationCodeKey != '') {
                if(B3PGissuite.vars.layerUrl.indexOf(organizationCodeKey)<=0) {
                    if(B3PGissuite.vars.layerUrl.indexOf('?')> 0) {
                        B3PGissuite.vars.layerUrl+='&';
                    } else {
                        B3PGissuite.vars.layerUrl+='?';
                    }
                    B3PGissuite.vars.layerUrl = B3PGissuite.vars.layerUrl + organizationCodeKey + "="+B3PGissuite.config.organizationcode;
                }
            }
        }    
    },

    removeItemAsLayer: function(theItem){
        if (this.removeLayerFromEnabledLayerItems(theItem.id) !== null) {
            syncLayerCookieAndForm();
            return;
        }
    },

    refreshLayerWithDelay: function() {
        showLoading();
        if(B3PGissuite.vars.refresh_timeout_handle) { 
            clearTimeout(B3PGissuite.vars.refresh_timeout_handle);
            hideLoading();
        } 
        B3PGissuite.vars.refresh_timeout_handle = setTimeout(this.doRefreshLayer, B3PGissuite.config.refreshDelay);
    },   

    doRefreshLayer: function() {    
        //register after loading
        B3PGissuite.vars.webMapController.registerEvent(Event.ON_ALL_LAYERS_LOADING_COMPLETE,B3PGissuite.vars.webMapController.getMap(), refreshLegendBox);
        refreshLayer();
        refreshLegendBox();
    },

    /**
     * called when a checkbox is clicked.
     */
    checkboxClick: function(obj, dontRefresh) {
        var me = this;
        var item = obj.theItem;
        if(obj.checked) {        
            me.addItemAsLayer(item);
            if (B3PGissuite.config.useInheritCheckbox) {
                //zet bovenliggende cluster vinkjes aan
                var object = document.getElementById(item.id);
                me.enableParentClusters(object);
            }
        } else {
            me.removeItemAsLayer(item);
        }

        if (obj.type=='radio'){
            if (obj.checked){
                var radiogroup=jQuery("input[name='"+obj.name+"']");
                jQuery.each(radiogroup,function(key, value){
                    if (obj.id!=value.id){
                        me.checkboxClick(value,true);
                    }
                })
            }
        }

        if (!dontRefresh){
            if(obj.checked) {
                me.refreshLayerWithDelay();
            }else{
                me.doRefreshLayer();
            }
        }
    },

    /**
     * Called when a user selects a radio element in the tree. Activates the selected
     * thema. When the thema has a metadata link it will display the info in the info tab.
     * @param obj The selected raio element.
    */
    radioClick: function(obj) {
        var oldActiveThemaId = this.activeAnalyseThemaId;
        if (obj && obj!=null && obj.theItem && obj.theItem!=null && obj.theItem.id && obj.theItem.title) {
            this.activeAnalyseThemaId = this.setActiveThema(obj.theItem.id, obj.theItem.title, true);
            this.activateCheckbox(obj.theItem.id);
            this.deActivateCheckbox(oldActiveThemaId);

            if (obj.theItem.metadatalink && obj.theItem.metadatalink.length > 1) {
                if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=obj.theItem.metadatalink;
            }
        }
    },

    /**
     * called when a clustercheckbox is clicked
     */
    clusterCheckboxClick: function(element,dontRefresh) {
        var me = this;
        if (element==undefined || element==null)
            return;
        if (B3PGissuite.vars.layerUrl==null){
            B3PGissuite.vars.layerUrl=""+B3PGissuite.config.kburl;
        }
        var status=element.checked;
        if (status){
            var found=false;
            for (var i=0; i < B3PGissuite.vars.clustersAan.length; i++){
                if (B3PGissuite.vars.clustersAan[i].id==element.id){
                    found=true;
                }
            }
            if (!found)
                B3PGissuite.vars.clustersAan.push(element);
        }else{
            var newClustersAan = new Array();
            for (var j=0; j < B3PGissuite.vars.clustersAan.length; j++){
                if (B3PGissuite.vars.clustersAan[j].id!=element.id){
                    newClustersAan.push(B3PGissuite.vars.clustersAan[j]);
                }
            }
            B3PGissuite.vars.clustersAan=newClustersAan;
        }
        /* indien cookies aan dan cluster id in cookie stoppen */
        var cluster=element.theItem;
        if (B3PGissuite.config.useCookies) {      
            if (element.checked) {
                addClusterIdToCookie(cluster.id);
            }else {
                removeClusterIdFromCookie(cluster.id);
            }
        }
        // Als er niet naar de B3PGissuite.config.useInheritCheckbox wordt gekeken (dus het vinkje bij 'Kaartgroep overerving' is uit)
        // of
        // als een tree gehide is (gebruiker kan de layers niet aan/uit vinken)
        if (!B3PGissuite.config.useInheritCheckbox || cluster.hide_tree) {
            if (element.checked) {

                /* Cluster is net aangevinkt. Children omgekeerd aanzetten zodat
                 * bovenste layer in boom ook bovenop wordt getekend. */
                for (var k = cluster.children.length; k > 0; k--){
                    var child = cluster.children[k-1];

                    if (!child.cluster){
                        me.addItemAsLayer(child);
                        if (!cluster.hide_tree){
                            document.getElementById(child.id).checked=true;
                        }
                    } else {
                        //if cluster is callable AND not 'kaartgroep overerving'
                        if (child.callable && !B3PGissuite.config.useInheritCheckbox){
                            var elemin = document.getElementById(child.id);
                            elemin.checked=true;
                            me.clusterCheckboxClick(elemin,dontRefresh);
                        }
                    }
                }
            } else if (cluster.children){
                for (var d=0; d < cluster.children.length;d++) {
                    var child1=cluster.children[d];
                    if (!child1.cluster){
                        me.removeItemAsLayer(child1);
                        if (!cluster.hide_tree){
                            document.getElementById(child1.id).checked=false;
                        }
                    } else {
                        //if cluster is callable AND not 'kaartgroep overerving'
                        if (child1.callable && !B3PGissuite.config.useInheritCheckbox){
                            var elemout = document.getElementById(child1.id);
                            elemout.checked=false;
                            me.clusterCheckboxClick(elemout,dontRefresh);
                        }
                    }
                }
            }     
        }
        /*Als B3PGissuite.config.useInheritCheckbox dan grafisch in de tree aangegeven dat onderliggende layers niet zichtbaar zijn.*/
        if (B3PGissuite.config.useInheritCheckbox){        
            for (var m=0; m < cluster.children.length;m++){
                child=cluster.children[m];
                if (element.checked) {
                    enableLayer(child.id);
                }else{
                    disableLayer(child.id);
                }
            }
        }
        /*if its a radio and checked,then disable the other radio's*/
        if (element.type=='radio' && cluster.children){
            var childDiv=$j("#layermaindiv_item_" + element.id+"_children");
            if (element.checked){
                //als er child elementen zijn dan die aanzetten en tree expanden.
                if (childDiv){
                    childDiv.removeClass("disabledRadioChilds");
                    $j("#layermaindiv_item_" + element.id+"_children input").removeAttr("disabled");
                    treeview_expandItemChildren("layermaindiv",element.id);
                }
                //andere radio's uitzetten.
                var jqueryElementString="input[name='"+element.name+"']";
                var radiogroup=$j(jqueryElementString);
                $j.each(radiogroup,function(key, value){
                    if (element.id!=value.id){
                        me.clusterCheckboxClick(value,dontRefresh);
                    }
                })
            }else{
                //als een andere van de group aan is dan deze disablen, mits er childs zijn.
                if (childDiv){
                    childDiv.addClass("disabledRadioChilds");
                    treeview_collapseItemChildren("layermaindiv",element.id);
                    $j("#layermaindiv_item_" + element.id+"_children input").attr('disabled',true);
                }
            }
        }

        if (!dontRefresh){
            me.refreshLayerWithDelay();
        }
    },

    /**
     * Creates a leaf in the tree. Is called for each item when creating the tree.
     * @param container The tree container
     * @param item The item with the leaf info.
     * @return useless boolean ?
    */
    createLabel: function(container, item) {
        if (item.cluster) {
            this.createClusterLabel(container, item);
        } else if (!item.hide_tree) {
            if(item.wmslayers){
                checkboxChecked = false;
                var layerPos = this.getLayerPosition(item);
                if(layerPos !== 0) {
                    checkboxChecked = true;
                }
                var themaCheckbox = null;
                parentItem = this.getParentItem(this.options.tree, item);
                if (parentItem.exclusive_childs) {
                    themaCheckbox = this.createRadioThema(item, checkboxChecked, parentItem.id);
                }else{
                    themaCheckbox = this.createCheckboxThema(item, checkboxChecked);
                }
                themaCheckbox.theItem = item;
                if (checkboxChecked) {
                    if (layerPos < 0) {
                        this.layersAan.unshift(themaCheckbox);
                    } else {
                        this.layersAan.push(themaCheckbox);
                    }
                }
                if(item.analyse === "on" || item.analyse === "active") {
                    if (!B3PGissuite.config.multipleActiveThemas){
                        var labelRadio = this.createRadioSingleActiveThema(item);
                        container.appendChild(labelRadio);
                    } else {
                        this.isActiveItem(item);
                    }
                }
                container.appendChild(themaCheckbox);
            }

            if (item.legendurl != undefined && B3PGissuite.config.showLegendInTree) {
                container.appendChild(document.createTextNode('  '));
                container.appendChild(this.createTreeLegendIcon());
            }

            container.appendChild(document.createTextNode('  '));
            container.appendChild(this.createMetadataLink(item));

            if (item.legendurl != undefined && B3PGissuite.config.showLegendInTree) {
                container.appendChild(this.createTreeLegendDiv(item));
            }
            
        } else {
            var divje = this.createInvisibleThemaDiv(item);
            divje.theItem=item;
            container.appendChild(divje);
            if(item.visible=="on" && item.wmslayers){
                this.addItemAsLayer(item);
            }
            return true;
        }

        return false;
    },

    createClusterLabel: function(container, item) {
        if (item.callable) {
            var checkboxChecked = false;
            var clusterPos = this.getClusterPosition(item);
            if(clusterPos !== 0) {
                checkboxChecked = true;
            }
            var checkbox = null;
            var parentItem = this.getParentItem(this.options.tree,item);
            if (parentItem.exclusive_childs){
                checkbox = this.createRadioCluster(item, checkboxChecked, parentItem.id);
            } else {
                checkbox = this.createCheckboxCluster(item, checkboxChecked);
            }

            checkbox.theItem=item;
            container.appendChild(checkbox);

            if (checkboxChecked){
                B3PGissuite.vars.clustersAan.push(checkbox);
            }

            // alleen een callable item kan active zijn
            if (item.active){
                this.setActiveCluster(item, true);
            }
        }
        var hasChildsWithLegend=false;
        if (item.hide_tree && item.callable){
            // hack om toggle plaatje uit te zetten als
            // cluster onzichtbare onderliggende kaartlagen heeft
            var img = document.createElement("img");
            img.setAttribute("border", "0");
            img.src = globalTreeOptions["layermaindiv"].toggleImages["leaf"]
            img.theItem=item;
            container.togglea = img;

            // als een cluster childs heeft en legend moet in tree worden getoond.
            if (B3PGissuite.config.showLegendInTree && item.children){
                //controleer of er een NIET cluster child een legend heeft.
                hasChildsWithLegend=false;
                for (var i=0; i < item.children.length && !hasChildsWithLegend; i++){
                    var child=item.children[i];
                    if (!child.cluster && child.legendurl!=undefined){
                        hasChildsWithLegend=true;
                    }
                }
                if (hasChildsWithLegend){
                    container.appendChild(document.createTextNode('  '));
                    container.appendChild(this.createTreeLegendIcon());                    
                }
            }
        }
        if (!item.hide_tree || item.callable){
            container.appendChild(document.createTextNode('  '));
            container.appendChild(this.createMetadataLink(item));
        }
        container.appendChild(this.createTreeLegendDiv(item));
        if (item.hide_tree && !item.callable){
            return true; //hide
        }
    },

    /**
     * Returns current state of cluster item. When item is active then it always
     * returns -1 so it will be visible.
     * @param item The cluster item.
     * @return 0 = Not in cookie or visible, -1 = No cookie but visible, 1 = In cookie.
    */
    getClusterPosition: function(item) {
        if ((B3PGissuite.vars.cookieClusterArray == null) || !B3PGissuite.config.useCookies) {
            if (item.visible || item.active)
                return -1;
            else
                return 0;
        }
        var arr = B3PGissuite.vars.cookieClusterArray.split(',');
        for(i = 0; i < arr.length; i++) {
            if(arr[i] == item.id) {
                return i+1;
            }
        }
        if (item.active)
            return -1;

        return 0;
    },

    /**
     * Create a checkbox thema
     * @param item the thema item (json)
     * @param checked set to true if this radio must be checked?
     * @return The checkbox element.
    */
    createCheckboxThema: function(item, checked) {
        var me = this;
        return jQuery('<input />')
            .attr({
                'id': item.id,
                'type': 'checkbox',
                'checked': checked,
                'value': item.id
            })
            .click(function() {
                me.checkboxClick(this, false);
            })[0];
    },

    /**
     * Returns current state of layer item. When item analyse is "active" then it
     * always returns -1 so it will be visible.
     * @param item The layer item.
     * @return 0 = Not in cookie or visible, -1 = No cookie but visible, 1 = In cookie.
    */
    getLayerPosition: function(item) {

        if((B3PGissuite.vars.cookieArray == null) || !B3PGissuite.config.useCookies) {
            if (item.visible=="on" || item.analyse=="active")
                return -1;
            else
                return 0;
        }

        var arr = B3PGissuite.vars.cookieArray.split(',');

        for(i = 0; i < arr.length; i++) {
            if(arr[i] == item.id) {
                return i+1;
            }
        }

        if (item.analyse=="active")
            return -1;
        
        return 0;
    },

    /**
     * @param parentCandidate A parent candidate, maybe its the parent of the imte
     * @param item The item we want the parent of.
     */
    getParentItem: function(parentCandidate,item){
        if (parentCandidate.children){
            for (var i=0; i < parentCandidate.children.length;i++){
                if(parentCandidate.children[i]==item){
                    return parentCandidate;
                }else if (parentCandidate.children[i].children){
                    var theParent= this.getParentItem(parentCandidate.children[i],item);
                    if (theParent!=null){
                        return theParent;
                    }
                }
            }        
        }
        return null;
    },

    /**
     * Create a radio thema
     * @param item the thema item (json)
     * @param checked set to true if this radio must be checked?
     * @param groupName the groupname of this radio group (the parent cluster id in most cases)
     * @return The radio element.
    */
    createRadioThema: function(item, checked, groupName){
        var me = this;
        return jQuery('<input />')
            .attr({
                'id': item.id,
                'type': 'radio',
                'checked': checked,
                'value': item.id,
                'name': groupName
            })
            .click(function() {
                me.checkboxClick(this, false);
            })[0];
    },

    /**
     * Check if the item is the current active thema.
     * @param item The item to check.
     * @return boolean
    */
    isActiveItem: function(item) {
        if (!item) {
            return false;
        }
        if(item.analyse=="on"){
            this.setActiveThema(item.id, item.title);
        } else if(item.analyse=="active"){
            this.setActiveThema(item.id, item.title, true);
        }

        if (this.activeAnalyseThemaId != item.id) {
            return false;
        }
        
        if(item.analyse=="active" && B3PGissuite.vars.prevRadioButton != null){
            var rc = document.getElementById(B3PGissuite.vars.prevRadioButton);
            if (rc!=undefined && rc!=null) {
                rc.checked = false;
            }
        }

        if (item.metadatalink && item.metadatalink.length > 1) {
            if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
        }
        B3PGissuite.vars.prevRadioButton = 'radio' + item.id;

        return true;
    },

    /**
     * Create a radio cluster element
     * @param item the cluster item (json)
     * @param checked set to true if this radio must be checked?
     * @param groupName the groupname of this radio group (the parent cluster id in most cases)
     * @return The radio element.
     */
    createRadioCluster: function(item,checked,groupName){
        var me = this;
        return jQuery('<input />')
            .attr({
                'id': item.id,
                'type': 'radio',
                'checked': checked,
                'value': item.id,
                'name': groupName
            })
            .click(function() {
                me.clusterCheckboxClick(this, false);
            })[0];
    },

    /**
     * Create a checkbox cluster element
     * @param item Item the cluster item (json)
     * @param checked Checked set to true if this radio must be checked?
     * @return The checkbox element.
     */
    createCheckboxCluster: function(item, checked){
        var me = this;
        return jQuery('<input />')
            .attr({
                'id': item.id,
                'type': 'checkbox',
                'checked': checked,
                'value': item.id
            })
            .click(function() {
                me.clusterCheckboxClick(this, false);
            })[0];
    },

    /**
     * Create a radio element for active thema.
     * @param item The thema item (json)
     * @return The radio element.
     */
    createRadioSingleActiveThema: function(item){
        var me = this;
        var radio = jQuery('<input />')
            .attr({
                'id': 'radio' + item.id,
                'type': 'radio',
                'checked': this.isActiveItem(item),
                'value': item.id,
                'name': 'selkaartlaag'
            })
            .click(function() {
                me.radioClick(this);
            })[0];
        radio.theItem = item;
        return radio;
    },

    /**
     * Creates a new legend icon element for use in tree.
     * @return The icon element.
    */
    createTreeLegendIcon: function() {
        var me = this;
        var legendicon = document.createElement("img");
        legendicon.src = imageBaseUrl + "icons/application_view_list.png";
        legendicon.alt = "Legenda tonen";
        legendicon.title = "Legenda tonen";
        legendicon.width="15";
        legendicon.height="13";
        legendicon.className = 'treeLegendIcon imagenoborder';
        jQuery(legendicon).click(function(){
            if(!jQuery(this).hasClass("disabledLegendIcon")) {
                me.loadTreeLegendImage(jQuery(this).siblings("div").attr("id"));
            }
        });
        return legendicon;
    },

    /**
     * Loads the legend image when the user clicked on a legend icon.
    */
    loadTreeLegendImage: function(divid) {
        var divobj = document.getElementById(divid);
        var $divobj = jQuery(divobj);
        var item = divobj.theItem;

        var found = $divobj.find("img.legendLoading");
        if(found.length == 0) {
            var legendloading = document.createElement("img");
            legendloading.src = imageBaseUrl + "icons/loadingsmall.gif";
            legendloading.alt = "Loading";
            legendloading.title = "Loading";
            legendloading.className = 'legendLoading imagenoborder';

            divobj.appendChild(legendloading);
        }

        var foundlegend = $divobj.find("img.treeLegendImage");
        if(foundlegend.length == 0) {
            if (item.cluster){
                var addedImages=0;
                for (var i=0; i < item.children.length; i++){
                    var child=item.children[i];
                    if (child.legendurl!=undefined){
                        if (addedImages>0)
                            divobj.appendChild(document.createElement("br"));
                        var legendimg = this.createTreeLegendImage(child);
                        divobj.appendChild(legendimg);
                        legendimg.src = child.legendurl;
                        addedImages++;
                    }
                }
            }else{
                legendimg = this.createTreeLegendImage(item);
                divobj.appendChild(legendimg);
                legendimg.src = item.legendurl;
            }
        }
        jQuery(divobj).toggle();
    },

    /**
     * Creates the image element for the legend
     * @param item Item used for the image name and title
     * @return Image element.
    */
    createTreeLegendImage: function(item){
        var legendimg = document.createElement("img");
        legendimg.name = item.title;
        legendimg.alt = "Legenda " + item.title;

        /**
         * Displays an error when the legend image can not be fetched.
        */
        legendimg.onerror = function() {
            var divobj = jQuery(this).parent();
            divobj.find("img.legendLoading").hide();
            divobj.html('<span style="color: Black;">Legenda kan niet worden opgehaald</span>');
        };

        /**
         * Hides the legend loading message when the legend image is loaded.
        */
        legendimg.onload = function(){
            // TODO: Hoogte check wegehaald, ging niet altijd goed in IE7 waardoor laadicoontje niet werd weggehaald
            // if (parseInt(this.height) > 5){
            jQuery(this).parent().find("img.legendLoading").hide();
        // }
        };
        legendimg.className = 'treeLegendImage';
        // Set src after the img element is appended to make sure onload gets called, even when image is in cache
        // legendimg.src = item.legendurl;
        return legendimg;
    },

    /**
     * Creates the tree legend div.
     * @param item Item used for the image name and title
     * @return Div element.
    */
    createTreeLegendDiv: function(item) {
        var id=item.id + '#tree#' + item.wmslayers;

        var div = document.createElement("div");
        div.name=id;
        div.id=id;
        div.title =item.title;
        div.className="treeLegendClass";
        div.theItem=item;
        div.style.display = 'none';

        return div;
    },

    /**
     * Creates a link element to a new iFrame with the metadata from the item.
     * @param item The item with the metadata.
     * @return The link element.
    */
    createMetadataLink: function(item) {

        var widthMetadataPopup = 800;
        var heightMetadataPopup = 600;
        var widthDownloadPopup = 425;
        var heightDownloadPopup = 250;
        var downloadPopupBlocksViewer = true;
        var metadataPopupBlocksViewer = true;

        var lnk = document.createElement('a');
        lnk.innerHTML = item.title ? item.title : item.id;
        lnk.href = '#';

        var downloadTitle = 'Download dataset van ' + item.title;
        var infoTitle = 'Informatie over ' + item.title; 

        /* Metadata tonen, WMS Service url en Annuleren */
        if (item.metadatalink && item.metadatalink.length > 1 && (item.gegevensbronid == undefined || item.gegevensbronid < 1)) {
            lnk.onclick = function() {
                jQuery("#dialog-download-metadata").dialog("option", "buttons", {                
                    "Metadata": function() {
                        if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                            iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                            jQuery(this).dialog("close");
                        }
                    },
                    "Url": function() {
                        if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                            jQuery(this).dialog("close");                        
                            
                            var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            jQuery("#input_wmsserviceurl").val(url);
                            
                            unblockViewerUI();
                            jQuery("#dialog-wmsservice-url").dialog('open');
                        }
                    },
                    "Annuleren": function() {
                        if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                            jQuery(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });

                jQuery('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                    jQuery(this).html(jQuery(this).parent().attr('text'));
                });

                //blockViewerUI();
                jQuery("#dialog-download-metadata").dialog('open');
            }
            
            return lnk;
        }

        /* Download tonen, WMS Service url en Annuleren */
        if ( (item.metadatalink == undefined || item.metadatalink == '#') && item.gegevensbronid && item.gegevensbronid > 0) {
            lnk.onclick = function() {
                
                /* Wel download en url button tonen */
                if (B3PGissuite.config.datasetDownload && B3PGissuite.config.showServiceUrl) {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", {
                        "Download": function() {                    
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                /* Kijken of er een polygoon is getekend voor subselectie in download */
                                var wkt = getWktForDownload();            
                                if (wkt == "") {
                                    alert("Let op: Er is nog geen selectie ingetekend. U gaat de gehele dataset downloaden.")
                                }

                                iFramePopup('download.do?id=' + item.gegevensbronid, false, downloadTitle, widthDownloadPopup, heightDownloadPopup, downloadPopupBlocksViewer, false);
                                jQuery(this).dialog("close");
                            }
                        },
                        "Url": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                                jQuery(this).dialog("close");                        

                                var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                                jQuery("#input_wmsserviceurl").val(url);

                                unblockViewerUI();
                                jQuery("#dialog-wmsservice-url").dialog('open');
                            }
                        },                
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                } else if (!B3PGissuite.config.datasetDownload && B3PGissuite.config.showServiceUrl) {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", {                    
                        "Url": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                                jQuery(this).dialog("close");                        

                                var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                                jQuery("#input_wmsserviceurl").val(url);

                                unblockViewerUI();
                                jQuery("#dialog-wmsservice-url").dialog('open');
                            }
                        },
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                } else {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", { 
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                }

                jQuery('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                    jQuery(this).html(jQuery(this).parent().attr('text'));
                });
                
                jQuery("#dialog-download-metadata").dialog('open');
            }
            
            return lnk;
        }

        /* Download tonen, Metadata, WMS Service url en Annuleren */
        if (item.metadatalink && item.metadatalink.length > 1 && item.gegevensbronid && item.gegevensbronid > 0) {
            lnk.onclick = function() {
                
                /* Wel download button tonen */
                if (B3PGissuite.config.datasetDownload && B3PGissuite.config.showServiceUrl) {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", {
                        "Download": function() {            
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                /* Kijken of er een polygoon is getekend voor subselectie in download */
                                var wkt = getWktForDownload();            
                                if (wkt == "") {
                                    alert("Let op: Er is nog geen selectie ingetekend. U gaat de gehele dataset downloaden.")
                                }

                                iFramePopup('download.do?id=' + item.gegevensbronid, false, downloadTitle, widthDownloadPopup, heightDownloadPopup, downloadPopupBlocksViewer, false);
                                jQuery(this).dialog("close");
                            }
                        },
                        "Metadata": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                                jQuery(this).dialog("close");
                            }
                        },
                        "Url": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                                jQuery(this).dialog("close");                        

                                var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                                jQuery("#input_wmsserviceurl").val(url);

                                unblockViewerUI();
                                jQuery("#dialog-wmsservice-url").dialog('open');
                            }
                        },
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                } else if (!B3PGissuite.config.datasetDownload && B3PGissuite.config.showServiceUrl) {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", {                    
                        "Metadata": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                                jQuery(this).dialog("close");
                            }
                        },
                        "Url": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                                jQuery(this).dialog("close");                        

                                var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                                jQuery("#input_wmsserviceurl").val(url);

                                unblockViewerUI();
                                jQuery("#dialog-wmsservice-url").dialog('open');
                            }
                        },
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                } else {
                    jQuery("#dialog-download-metadata").dialog("option", "buttons", {                    
                        "Metadata": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                iFramePopup(item.metadatalink, false, infoTitle, widthMetadataPopup, heightMetadataPopup, metadataPopupBlocksViewer, true);
                                jQuery(this).dialog("close");
                            }
                        },
                        "Annuleren": function() {
                            if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                                jQuery(this).dialog("close");
                                unblockViewerUI();
                            }
                        }
                    });
                }            

                jQuery('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                    jQuery(this).html(jQuery(this).parent().attr('text'));
                });

                //blockViewerUI();
                jQuery("#dialog-download-metadata").dialog('open');
            }
            
            return lnk;
        }
        
        /* Alleen url en Annuleren */
        if ( (item.metadatalink == undefined || item.metadatalink == '#') && (item.gegevensbronid == undefined || item.gegevensbronid < 1) && (B3PGissuite.config.showServiceUrl) ) {
            lnk.onclick = function() {
                jQuery("#dialog-download-metadata").dialog("option", "buttons", {                
                    "Url": function() {
                        if (jQuery("#dialog-download-metadata").dialog("isOpen")) {                        
                            jQuery(this).dialog("close");                        
                            
                            var url = B3PGissuite.config.kburl + "service=WMS&request=GetCapabilities&version=1.0.0";
                            jQuery("#input_wmsserviceurl").val(url);
                            
                            unblockViewerUI();
                            jQuery("#dialog-wmsservice-url").dialog('open');
                        }
                    },
                    "Annuleren": function() {
                        if (jQuery("#dialog-download-metadata").dialog("isOpen")) {
                            jQuery(this).dialog("close");
                            unblockViewerUI();
                        }
                    }
                });

                jQuery('div.ui-dialog-buttonset .ui-button .ui-button-text').each(function() {
                    jQuery(this).html(jQuery(this).parent().attr('text'));
                });

                //blockViewerUI();
                jQuery("#dialog-download-metadata").dialog('open');
            }
            
            return lnk;
        }

        return lnk;
    },

    /**
     * Creates a non visible thema div
     * @param item The id for the div element
     * @return HTMLElement
    */
    createInvisibleThemaDiv: function(item) {
        var div = document.createElement("div");
        div.name = item.id;
        div.id = item.id;
        div.style.height = '0';
        div.style.width = '0';
        div.height = 0;
        div.width = 0;
        div.style.display = "none";
        return div;
    },

    /**
     * Set the active cluster to be able to display metadata for this cluster..
     * @param item Cluster item to be activated
     * @param overrule When true overrule the current active item.
    */
    setActiveCluster: function(item, overrule){
        if(((this.activeAnalyseThemaId==null || this.activeAnalyseThemaId.length == 0) && (this.activeClusterId==null || this.activeClusterId.length==0)) || overrule){
            if(item != undefined & item != null) {
                var activeClusterTitle = item.title;
                var atlabel = document.getElementById('actief_thema');
                if (atlabel && activeClusterTitle && atlabel!=null && activeClusterTitle!=null){
                    this.activeClusterId = item.id;
                    atlabel.innerHTML = '' + activeClusterTitle;
                }
                if(item.metadatalink && item.metadatalink.length > 1){
                    if(document.getElementById('beschrijvingVakViewer')) document.getElementById('beschrijvingVakViewer').src=item.metadatalink;
                }
            }
        }
    },

    /**
     * uitleg zie itemHasAllParentsEnabled
     */
    enableParentClusters: function(object) {
        if (object == null) {
            return;
        }
        var parentChildrenDiv = getParentDivContainingChilds(object, 'div');
        if (!parentChildrenDiv) {
            return;
        }
        var parentDiv = getParentByTagName(parentChildrenDiv, 'div');
        var name = getItemName(parentDiv);
        var checkbox = document.getElementById(name);
        checkbox.checked = true;

        this.enableParentClusters(parentDiv);
    },
            
    /* als order niet aangepast mag worden dan moet hier een sort komen */
    addLayerToEnabledLayerItems: function(theItem){
        var foundLayerItem = null;
        for (var i=0; i < B3PGissuite.vars.enabledLayerItems.length; i++){
            if (B3PGissuite.vars.enabledLayerItems[i].id==theItem.id){
                foundLayerItem = B3PGissuite.vars.enabledLayerItems[i];
                break;
            }
        }
        if (foundLayerItem == null) {
            B3PGissuite.vars.enabledLayerItems.push(theItem);
        }
    },

    removeLayerFromEnabledLayerItems: function(itemId){
        for (var i=0; i < B3PGissuite.vars.enabledLayerItems.length; i++){
            if (B3PGissuite.vars.enabledLayerItems[i].id==itemId){
                var foundLayerItem = B3PGissuite.vars.enabledLayerItems[i];
                B3PGissuite.vars.enabledLayerItems.splice(i,1);
                return foundLayerItem;
            }
        }
        return null;
    }

});