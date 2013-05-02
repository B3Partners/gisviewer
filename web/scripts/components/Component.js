function ViewerComponent(options) {
    this.options = jQuery.apply({}, options);
    this.component = null;
    this.init();
};

ViewerComponent.prototype.init = function() {
    throw('Init must be implemented in a sub-class');
};

ViewerComponent.prototype.render = function(domId) {
    jQuery(domId).append(this.component);
};

ViewerComponent.prototype.renderTab = function(TabController) {
    throw('RenderTab must be implemented in a sub-class');
};