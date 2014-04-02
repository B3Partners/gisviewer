B3PGissuite.defineComponent('Balloon', {

    defaultOptions: {
        mapDiv: "#mapcontent",
        webMapController: null,
        balloonId: 'infoBalloon',
        balloonWidth: 300,
        balloonHeight: 300,
        balloonCornerSize: 20,
        balloonArrowHeight: 40,
        offsetX: 0,
        offsetY: 0
    },

    /**
     * @param mapDiv The div element where the map is in.
     * @param webMapController the webMapController that controlles the map
     * @param balloonId the id of the DOM element that represents the balloon.
     * @param balloonWidth the width of the balloon (optional, default: 300);
     * @param balloonHeight the height of the balloon (optional, default: 300);
     * @param offsetX the offset x
     * @param offsetY the offset y
     * @param balloonCornerSize the size of the rounded balloon corners of the round.png image(optional, default: 20);
     * @param balloonArrowHeight the hight of the arrowImage (optional, default: 40);
     */
    constructor: function Balloon(options) {
        this.options = jQuery.extend(this.defaultOptions, options);
    },

    /**
     *Private function. Don't use.
     *@param x
     *@param y
     */
    _createBalloon: function(x, y) {
        //create balloon and styling.
        this.balloon = $j("<div class='infoBalloon' id='" + this.options.balloonId + "'></div>");
        this.balloon.css('position', 'absolute');
        this.balloon.css('width', "" + this.options.balloonWidth + "px");
        this.balloon.css('height', "" + this.options.balloonHeight + "px");
        this.balloon.css('z-index', '13000');

        var maxCornerSize = this.options.balloonHeight - (this.options.balloonArrowHeight * 2) + 2 - this.options.balloonCornerSize;
        this.balloon.append($j("<div class='balloonCornerTopLeft'><img style='position: absolute;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.options.balloonCornerSize + 'px')
                .css('height', this.options.balloonCornerSize + 'px')
                .css('left', '0px')
                .css('top', this.options.balloonArrowHeight - 1 + 'px')
                .css('width', this.options.balloonWidth - this.options.balloonCornerSize + 'px')
                .css('height', maxCornerSize + 'px')
                );
        this.balloon.append($j("<div class='balloonCornerTopRight'><img style='position: absolute; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.options.balloonCornerSize + 'px')
                .css('height', maxCornerSize + 'px')
                .css('top', this.options.balloonArrowHeight - 1 + 'px')
                .css('right', '0px')
                );
        this.balloon.append($j("<div class='balloonCornerBottomLeft'><img style='position: absolute; top: -748px;' src='images/infoBalloon/round.png'/></div>")
                .css('height', this.options.balloonCornerSize + 'px')
                .css('left', '0px')
                .css('bottom', this.options.balloonArrowHeight - 1 + 'px')
                .css('width', this.options.balloonWidth - this.options.balloonCornerSize)
                );
        this.balloon.append($j("<div class='balloonCornerBottomRight'><img style='position: absolute; top: -748px; left: -1004px;' src='images/infoBalloon/round.png'/></div>")
                .css('width', this.options.balloonCornerSize + 'px')
                .css('height', this.options.balloonCornerSize + 'px')
                .css('right', '0px')
                .css('bottom', this.options.balloonArrowHeight - 1 + 'px')

                );
        //arrows
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowTopRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomLeft' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        this.balloon.append($j("<div class='balloonArrow balloonArrowBottomRight' style='display: none;'><img src='images/infoBalloon/arrow.png'/></div>"));
        //content
        this.balloon.append($j("<div class='balloonContent'></div>")
                .css('top', this.options.balloonArrowHeight + 20 + 'px')
                .css('bottom', this.options.balloonArrowHeight + 4 + 'px')
                );
        //closing button
        var thisObj = this;
        this.balloon.append($j("<div class='balloonCloseButton'></div>")
                .css('right', '7px')
                .css('top', '' + (this.options.balloonArrowHeight + 3) + 'px')
                .click(function() {
            thisObj.remove();
            return false;
        })

                );
        this.xCoord = x;
        this.yCoord = y;

        //calculate position
        this._resetPositionOfBalloon(x, y);

        //append the balloon.
        $j(this.options.mapDiv).append(this.balloon);

        this.options.webMapController.registerEvent(Event.ON_FINISHED_CHANGE_EXTENT, this.options.webMapController.getMap(), this.setPosition, this);
    },

    /**
     *Private function. Use setPosition(x,y,true) to reset the position
     *Reset the position to the point. And displays the right Arrow to the point
     *Sets the this.leftOfPoint and this.topOfPoint
     *@param x the x coord
     *@param y the y coord
     */
    _resetPositionOfBalloon: function(x, y) {
        //calculate position
        var centerCoord = this.options.webMapController.getMap().getCenter();
        var centerPixel = this.options.webMapController.getMap().coordinateToPixel(centerCoord.x, centerCoord.y);
        var infoPixel = this.options.webMapController.getMap().coordinateToPixel(x, y);

        //determine the left and top.
        if (infoPixel.x > centerPixel.x) {
            this.leftOfPoint = true;
        } else {
            this.leftOfPoint = false;
        }
        if (infoPixel.y > centerPixel.y) {
            this.topOfPoint = true;
        } else {
            this.topOfPoint = false;
        }
        //display the right arrow
        this.balloon.find(".balloonArrow").css('display', 'none');
        //$j("#infoBalloon > .balloonArrow").css('display', 'block');
        if (!this.leftOfPoint && !this.topOfPoint) {
            //popup is bottom right of the point
            this.balloon.find(".balloonArrowTopLeft").css("display", "block");
        } else if (this.leftOfPoint && !this.topOfPoint) {
            //popup is bottom left of the point
            this.balloon.find(".balloonArrowTopRight").css("display", "block");
        } else if (this.leftOfPoint && this.topOfPoint) {
            //popup is top left of the point
            this.balloon.find(".balloonArrowBottomRight").css("display", "block");
        } else {
            //pop up is top right of the point
            this.balloon.find(".balloonArrowBottomLeft").css("display", "block");
        }
    },

    /**
     *Set the position of this balloon. Create it if not exists
     *@param x xcoord
     *@param y ycoord
     *@param resetPositionOfBalloon boolean if true the balloon arrow will be
     *redrawn (this.resetPositionOfBalloon is called)
     */
    setPosition: function(x, y, resetPositionOfBalloon) {
        if (this.balloon === undefined) {
            this._createBalloon(x, y);
        } else if (resetPositionOfBalloon) {
            this._resetPositionOfBalloon(x, y);
        }
        if (x !== undefined && y !== undefined) {
            this.xCoord = x;
            this.yCoord = y;
        } else if (this.xCoord === undefined || this.yCoord === undefined) {
            throw "No coords found for this balloon";
        } else {
            x = this.xCoord;
            y = this.yCoord;
        }
        //if the point is out of the extent hide balloon
        var curExt = this.options.webMapController.getMap().getExtent();
        if (curExt.minx > x ||
                curExt.maxx < x ||
                curExt.miny > y ||
                curExt.maxy < y) {
            /*TODO wat doen als hij er buiten valt.*/
            this.balloon.css('display', 'none');
            return;
        } else {
            /*TODO wat doen als hij er weer binnen valt*/
            this.balloon.css('display', 'block');
        }

        //calculate position
        var infoPixel = this.options.webMapController.getMap().coordinateToPixel(x, y);

        //determine the left and top.
        var left = infoPixel.x + this.options.offsetX;
        var top = infoPixel.y + this.options.offsetY;
        if (this.leftOfPoint) {
            left = left - this.options.balloonWidth;
        }
        if (this.topOfPoint) {
            top = top - this.options.balloonHeight;
        }
        //set position of balloon
        this.balloon.css('left', "" + left + "px");
        this.balloon.css('top', "" + top + "px");
    },

    /*Remove the balloon*/
    remove: function() {
        this.balloon.remove();
        this.options.webMapController.unRegisterEvent(Event.ON_FINISHED_CHANGE_EXTENT, this.options.webMapController.getMap(), this.setPosition, this);
        delete this.balloon;
    },

    /*Get the DOM element where the content can be placed.*/
    getContentElement: function() {
        return this.balloon.find('.balloonContent');
    },

    hide: function() {
        this.balloon.css("display", 'none');
    },

    show: function() {
        this.balloon.css("display", 'block');
    }

});