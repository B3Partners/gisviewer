// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

class AbstractComponent extends MovieClip {
    
    // The component's 21 base properties.
    var name:String = null;
    var width:String = null;
    var height:String = null;
    var left:String = null;
    var right:String = null;
    var top:String = null;
    var bottom:String = null;
    var xcenter:String = null;
    var ycenter:String = null;
    var listento:Array = null;
    var visible:Boolean = true;
    var maxwidth:Number = null;
    var minwidth:Number = null;
    var maxheight:Number = null;
    var minheight:Number = null;
    var guides:Object = null; // Associative array.
    var styles:Object = null; // Associative array.
    var cursors:Object = null; // Associative array.
    var strings:Object = null; // Associative array.
    var __width:Number = null;
    var __height:Number = null;
    
    // Some properties used for components to wait for each other.
    private var initAdapters:Array = null;
    private var inited:Boolean = false;
    
    private var resizeAdapter:ResizeAdapter = null;
    
    /** @component {Component}
    * Abstract superclass for all components.
    * @file AbstractComponent.as (sourcefile)
    * @file InitAdapter.as (sourcefile)
    * @file ResizeAdapter.as (sourcefile)
    */
    function AbstractComponent() {
        if (_parent._parent == null) {
            var textField:TextField = createTextField("mTextField", 0, 0, 0, 550, 400);
            textField.html = true;
            textField.htmlText = "<P ALIGN='CENTER'><FONT FACE='Helvetica, Arial' SIZE='12' COLOR='#000000' LETTERSPACING='0' KERNING='0'><B>AbstractComponent</B> - www.flamingo-mc.org</FONT></P>";
            
            return;
        }
        
        _global.flamingo.correctTarget(_parent, this);
    }
    
    function onLoad():Void {
        if (_parent._parent == null) {
            return;
        }
        
        // Retrieves the default configuration for the component, in order to set the base properties.
        var defaultConfig:XMLNode = _global.flamingo.getDefaultXML(this);
        setBaseProperties(defaultConfig);
        
        // Retrieves the application configurations for the component, in order to set the base properties.
        var appConfigs:Array = _global.flamingo.getXMLs(this);
        for (var i = 0; i < appConfigs.length; i++) {
            setBaseProperties(XMLNode(appConfigs[i]));
        }
        
        // Waits for the "listento" components to init before going to the afterLoad() method.
        initAdapters = new Array();
        var component:Object = null;
        var initAdapter:InitAdapter = null;
        for (var i:String in listento) {
            component = _global.flamingo.getComponent(listento[i]);
            if ((component == null) || ((component instanceof AbstractComponent) && (!component.isInited()))) {
                initAdapter = new InitAdapter(this);
                initAdapters.push(initAdapter);
                _global.flamingo.addListener(initAdapter, listento[i], this);
            }
        }
        if (initAdapters.length == 0) {
            afterLoad();
        }
    }
    
    /**
    * Sets the component's 21 base properties.
    * @attr config:XMLNode Configuration in the form of an xml.
    */
    function setBaseProperties(config:XMLNode):Void {
        _global.flamingo.parseXML(this, config);
    }
    
    /**
    * Removes a listener to a "listento" component after that "listento" component has raised an init event.
    * @attr initAdapter:InitAdapter Listener to be removed.
    */
    function removeInitAdapter(initAdapter:InitAdapter):Void {
        for (var i:String in initAdapters) {
            if (initAdapters[i] == initAdapter) {
                initAdapters.splice(i, 1);
                _global.flamingo.removeListener(initAdapter, listento[i], this);
                
                if (initAdapters.length == 0) {
                    afterLoad();
                }
                return;
            }
        }
    }
    
    /**
    * Finishes the init state of the component, calling the component's init() method.
    * This will raise the onInit event.
    */
    function afterLoad():Void {
        
        // Retrieves the default configuration for the component, in order to set the custom properties.
        var defaultConfig:XMLNode = _global.flamingo.getDefaultXML(this);
        setCustomProperties(defaultConfig);
        
        // Retrieves the application configurations for the component, in order to set the custom properties.
        var appConfigs:Array = _global.flamingo.getXMLs(this);
        for (var i = 0; i < appConfigs.length; i++) {
            setCustomProperties(XMLNode(appConfigs[i]));
        }
        
        // Removes the configurations for the component from the Flamingo framework.
        _global.flamingo.deleteXML(this);
        
        setVisible(visible);
        var bounds:Object = _global.flamingo.getPosition(this);
        setBounds(bounds.x, bounds.y, bounds.width, bounds.height);
        
        resizeAdapter = new ResizeAdapter(this);
        if (_parent._parent._parent._name == "mWindow") {
            _global.flamingo.addListener(resizeAdapter, _parent._parent._parent._parent, this);
        } else {
            _global.flamingo.addListener(resizeAdapter, "flamingo", this);
        }
        
        init();
        
        inited = true;
        _global.flamingo.raiseEvent(this, "onInit", this);
    }
    
    /**
    * Sets the component's custom properties. Properties can be attributes and composites.
    * @attr config:XMLNode Configuration in the form of an xml.
    */
    function setCustomProperties(config:XMLNode):Void {
        
        // Parses the xml attributes to object attributes.
        for (var attributeName:String in config.attributes) {
            var value:String = config.attributes[attributeName];
            setAttribute(attributeName, value);
        }
        
        // Parses the xml child nodes to object composites.
        for (var i:Number = 0; i < config.childNodes.length; i++) {
            var xmlNode:XMLNode = config.childNodes[i];
            var nodeName:String = xmlNode.nodeName;
            if (nodeName.indexOf(":") > -1) {
                nodeName = nodeName.substr(nodeName.indexOf(":") + 1);
            }
            addComposite(nodeName, xmlNode);
        }
        
        //this.addComponents(config);
    }
    
    function setAttribute(name:String, value:String):Void { }
    
    function addComposite(name:String, config:XMLNode):Void { }
    
    /**
    * Shows or hides the component.
    * In case that the component is child of a Window component, shows or hides the Windows component likewise.
    * This will raise the onSetVisible event.
    * @param visible:Boolean True or false.
    */
    function setVisible(visible:Boolean):Void {
        if (this.visible != visible) {
            this.visible = visible;
            _visible = visible;
            
            _global.flamingo.raiseEvent(this, "onSetVisible", this, visible);
            
            if (_parent._parent._parent._name == "mWindow") {
                _parent._parent._parent._parent.setVisible(visible);
            }
        }
    }
    
    /**
    * Sets the position and the size of the component.
    * This will raise the onResize event.
    * @param x:Number The x position.
    * @param y:Number The y position.
    * @param width:Number The width.
    * @param height:Number The height.
    */
    function setBounds(x:Number, y:Number, width:Number, height:Number):Void {
        _x = x;
        _y = y;
        __width = width;
        __height = height;
        
        if (inited) {
            layout();
        }
        
        _global.flamingo.raiseEvent(this, "onResize", this);
    }
    
    function init():Void { }
    
    function isInited():Boolean {
        return inited;
    }
    
    function layout():Void { }
    
    /**
    * Displays the values of the component's 21 base properties.
    * This can be useful for debugging.
    */
    function traceProperties():Void {
        _global.flamingo.tracer(this);
        
        _global.flamingo.tracer("NAME " + name);
        _global.flamingo.tracer("WIDTH " + width);
        _global.flamingo.tracer("HEIGHT " + height);
        _global.flamingo.tracer("LEFT " + left);
        _global.flamingo.tracer("RIGHT " + right);
        _global.flamingo.tracer("TOP " + top);
        _global.flamingo.tracer("BOTTOM " + bottom);
        _global.flamingo.tracer("XCENTER " + xcenter);
        _global.flamingo.tracer("YCENTER " + ycenter);
        _global.flamingo.tracer("LISTENTO " + listento.toString());
        _global.flamingo.tracer("VISIBLE " + visible);
        _global.flamingo.tracer("MAXWIDTH " + maxwidth);
        _global.flamingo.tracer("MINWIDTH " + minwidth);
        _global.flamingo.tracer("MAXHEIGHT " + maxheight);
        _global.flamingo.tracer("MINHEIGHT " + minheight);
        
        for (var i:String in guides) {
            _global.flamingo.tracer("GUIDE " + guides[i]);
        }
        for (var i:String in styles) {
            _global.flamingo.tracer("STYLE " + styles[i]);
        }
        for (var i:String in cursors) {
            _global.flamingo.tracer("CURSOR " + cursors[i]);
        }
        for (var i:String in strings) {
            for (var j:String in strings[i]) {
                _global.flamingo.tracer("STRING " + i + " " + j + " " + strings[i][j]);
            }
        }
        
        _global.flamingo.tracer("__WIDTH " + __width);
        _global.flamingo.tracer("__HEIGHT " + __height);
    }
    
}
