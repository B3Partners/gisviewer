// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

class ResizeAdapter {
    
    private var listener:AbstractComponent = null;
    
    function ResizeAdapter(listener:AbstractComponent) {
        this.listener = listener;
    }
    
    function onResize():Void {
        var bounds:Object = _global.flamingo.getPosition(listener);
        listener.setBounds(bounds.x, bounds.y, bounds.width, bounds.height);
    }
    
    function onHide():Void {
        listener.setVisible(false);
    }
    
}
