var slider;
slider = YAHOO.widget.Slider.getHorizSlider("sliderbg", "sliderthumb", 0, 300);
slider.setValue(300);
slider.getRealValue = function() {
    return Math.round(this.getValue() * (2048/300));
}
slider.subscribe("change", function(offsetFromStart) {
    var fld = document.getElementById("imageSize");
    var actualValue = slider.getRealValue();
    fld.value = actualValue;

});

function changeVal(obj) {
    var strValue = obj.value;
    var fValue = parseFloat(strValue);
    if(!isNaN(fValue)) {
        if(fValue >= 0 && fValue <= 2048) {
            slider.setValue(Math.round(fValue / 10.24), false);
        }
    }
}