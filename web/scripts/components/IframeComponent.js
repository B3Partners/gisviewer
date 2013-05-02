function IframeComponent(options) {
    var defaultOptions = {
        src: '',
        id: '',
        title: ''
    };
    ViewerComponent.call(this, jQuery.apply(defaultOptions, options));
}
// Extend ViewerComponent
IframeComponent.prototype = new ViewerComponent();
IframeComponent.prototype.constructor = IframeComponent;

IframeComponent.prototype.init = function() {
    this.component = jQuery('<iframe></iframe>').attr({
        src: this.options.src,
        id: this.options.id,
        name: this.options.id,
        frameborder: 0
    });
};

IframeComponent.prototype.renderTab = function(tabController) {
    var domId = tabController.createTab(this.options.id, this.options.title, {
        tabvakClassname: 'tabvak_with_iframe'
    });
    this.render(domId);
};