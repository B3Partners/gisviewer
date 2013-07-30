<div id="transSlider" style="height: 50px; width: 260px; padding-left: 5px;">
    <p>
        Transparantie van alle voorgrondlagen.
    </p>

    <div style="float: left; font-size: 22px; padding-right: 3px; margin-top: -8px;">-</div>
    <div id="slider" style="width: 215px; float: left"></div>
    <div style="float: left; font-size: 22px; padding-left: 10px; margin-top: -6px;">+</div>
    <div style="clear: both;"></div>
</div>

<script type="text/javascript">
    $j(function() {
        $j("#slider").slider({
            min: 0,
            max: 100,
            value: 100,
            animate: true,
            change: function(event, ui) {
                transparency(ui.value);
            }
        });
    });
    function transparency(value) {
        var opacity = 1.0 - value / 100;
        var layers = parent.webMapController.getMap().getLayers();
        for (var i = 0; i < layers.length; i++) {
            var l = layers[i];
            if (!l.getOption("background")) {
                l.setOpacity(opacity);
            }
        }
    }
</script>