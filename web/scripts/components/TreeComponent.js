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
            this.options.servicetrees[i];
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
                "expandAll": true
            });
        }
        treeview_create({
            "id": this.options.treeid,
            "root": this.options.tree,
            "rootChildrenAsRoots": true,
            "itemLabelCreatorFunction": createLabel,
            "toggleImages": {
                "collapsed": this.options.icons.collapsed,
                "expanded": this.options.icons.expanded,
                "leaf": this.options.icons.leaf
            },
            "saveExpandedState": true,
            "saveScrollState": true,
            "expandAll": this.options.expandAll
        });
    }
});