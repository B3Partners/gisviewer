$j(document).ready(function() {
    // For testing purposes: createDummyBlocks(10);
    var $textblocks = $j('.content_block').not('#loginblock');
    var textblocklength = $textblocks.length;
    var $carouselContainer = $j('#carouselcontainerblock');
    
    // Only apply carousel with more that two blocks
    if($textblocks.length > 2) {

        var $ul = $j('<ul></ul>');
        $ul.attr("id", "carousel");
        $ul.addClass("jcarousel-skin-tango");

        $textblocks.each(function() {
            var $li = $j('<li></li>');
            $li.append($j(this));
            $ul.append($li);
            if($j.browser.msie && $j.browser.version < 9) {
                // If IE8 or lower, remove CSS3 styles, which give problems with carousel
                $j(this).find(".inleiding_body").css({
                    "-pie-background": "none",
                    "border-radius": "0px",
                    "box-shadow": "none"
                });
            }
        });

        $carouselContainer.append($ul);

        // Determine width to center controls
        var controlswidth = (textblocklength * 35);
        if(textblocklength > 10) controlswidth = 430;
        var $controls = $j('<div></div>');
        $controls.attr("id", "carouselcontrols");
        $controls.css("width", controlswidth + 'px');

        // If more than 10 controls, make it a carousel
        if(textblocklength > 10) {
            var $controlsul = $j('<ul></ul>');
            $controlsul.attr("id", "controlcarousel");
            $controlsul.addClass("jcarousel-skin-tango");
        }

        var counter = 1;
        $textblocks.each(function() {
            var title = $j(this).find('.content_title').html();
            var $counterblock = $j('<a></a>');
            $counterblock.addClass("counterblock");
            $counterblock.html(counter++);
            $counterblock.qtip({
                content: {
                    text: title
                },
                position: {
                    corner: {
                        target: 'bottomMiddle',
                        tooltip: 'topMiddle'
                    }
                },
                style: {
                    name: 'cream',
                    tip: 'topMiddle',
                    color: 'black',
                    title: {
                        border: '0px none',
                        color: 'black'
                    },
                    width: {
                        min: 200,
                        max: 325 
                    },
                    'text-align': 'center',
                    background: '#FFF0C5',
                    border: {
                        color: '#FFE1A3'
                    }
                },
                show: {
                    delay: 0
                }
            });

            if(textblocklength > 10) {
                var $controlsli = $j('<li></li>');
                $controlsli.append($counterblock)
                $controlsul.append($controlsli);
            } else {
                $controls.append($counterblock);
            }
        });

        if(textblocklength > 10) $controls.append($controlsul);
        $controls.append('<div style="clear: both;"></div>');
        $carouselContainer.append($controls);

        $j('#carousel').jcarousel({
            wrap: 'circular',
            scroll: 1,
            animation: 'slow',
            easing: 'easeOutCirc',
            initCallback: carousel_initCallback,
            itemFallbackDimension: 400
        });

        if(textblocklength > 10) {
            $j('#controlcarousel').jcarousel({
                scroll: 10,
                animation: 'slow',
                initCallback: controlsCarousel_initCallback,
                itemFallbackDimension: 25
            });
        }
    }
});

function carousel_initCallback(carousel) {
    $j(".counterblock").bind('click', function() {
        carousel.scroll(jQuery.jcarousel.intval(jQuery(this).text()));
        return false;
    });

    $j('#carousel').bind('mousewheel', function(event, delta) {
        var dir = delta > 0 ? 'up' : 'down';
        if(dir == 'up') carousel.next();
        else carousel.prev();
        return false;
    });
}

function controlsCarousel_initCallback(carousel) {
    $j('#controlcarousel').bind('mousewheel', function(event, delta) {
        var dir = delta > 0 ? 'up' : 'down';
        if(dir == 'up') carousel.next();
        else carousel.prev();
        return false;
    });
    // alert(carousel.size);
}

// Creates dummy blocks for testing purposes
function createDummyBlocks(amount) {
    var testcounter = 1;
    while(amount > 0) {
        var html = '<div class="content_block item">' +
            '<div class="content">' + 
                '<div class="content_title">Testtitel ' + testcounter + '</div>' +
                '<div class="inleiding_body">' + 
                    'Testinhoud van dit testblokje ' + (testcounter++) +
                '</div>' +
            '</div>' +
        '</div>';
        $j("#content").append(html);
        amount--;
    }
}