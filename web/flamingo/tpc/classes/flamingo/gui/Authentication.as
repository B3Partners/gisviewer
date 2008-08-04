// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.gui.*;

class flamingo.gui.Authentication extends AbstractComponent {
    
    private var roles:Array = null;
    
    function init():Void {
        var rolesString:String = _global.flamingo.mFlamingo.roles;
        if (rolesString == null) {
            roles = new Array();
        } else {
            roles = rolesString.split(",");
        }
        
        addTextField();
    }
    
    function isRole(role:String):Boolean {
        for (var i:String in roles) {
            if (roles[i] == role) {
                return true;
            }
        }
        return false;
    }
    
    private function addTextField():Void {
        var textFormat:TextFormat = new TextFormat();
        var style:Object = _global.flamingo.getStyleSheet("flamingo").getStyle(".general");
	textFormat.font = style["fontFamily"];
	textFormat.size = style["fontSize"] - 1;
	
        var textField:TextField = createTextField("textField_mc", 0, 0, 0, __width, __height);
        textField.multiline = true;
        textField.setNewTextFormat(textFormat);
        
        if (roles.length == 0) {
            textField.text = "User has no roles.";
        } else {
            textField.text = "User has roles:\n";
            for (var i:Number = 0; i < roles.length; i++) {
                textField.text += roles[i] + "\n";
            }
        }
    }
    
}
