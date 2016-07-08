/* 
 * Copyright (C) 2012 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

B3PGissuite.defineComponent('GPS', {

    gps_timeoutId: null,
    gps_interval: 5000,
    gps_buffer: null,
    gps_lat: null,
    gps_lon: null,

    constructor: function GPS(options) {
        Proj4js.defs["EPSG:28992"] = "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs";
        Proj4js.defs["EPSG:4236"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ";
        if (options && options.buffer) {
            this.gps_buffer = options.buffer;
        }
    },

    startPolling: function() {
        var me = this;
        this.gps_timeoutId = setInterval(function() {
            me.once();
        }, this.gps_interval);
        this.once();
    },

    stopPolling: function() {
        clearInterval(this.gps_timeoutId);
    },

    getGpsLat: function() {
        return this.gps_lat;
    },

    getGpsLon: function() {
        return this.gps_lon;
    },

    once: function() {
        if (!(navigator && navigator.geolocation)) {
            return;
        }
        var me = this;
        navigator.geolocation.getCurrentPosition(
            function(location) {
                me.receiveLocation(location);
            }, function(error) {
                me.errorHandler(error);
            }
        );
    },

    receiveLocation: function(location) {
        var lat = location.coords.latitude;
        var lon = location.coords.longitude;

        this.gps_lat = lat;
        this.gps_lon = lon;

        var point = this.transformLatLon(Number(lon), Number(lat));

        var minx = point.x - this.gps_buffer;
        var miny = point.y - this.gps_buffer;
        var maxx = point.x + this.gps_buffer;
        var maxy = point.y + this.gps_buffer;

        var extent = new Extent(minx, miny, maxx, maxy);

        B3PGissuite.vars.webMapController.getMap().zoomToExtent(extent);
        B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", point.x, point.y);
    },

    errorHandler: function(error) {
        alert("Kan locatie niet bepalen");
    },

    transformLatLon: function(x, y) {
        var source = new Proj4js.Proj("EPSG:4236");
        var dest = new Proj4js.Proj("EPSG:28992");
        var point = new Proj4js.Point(x, y);
        Proj4js.transform(source, dest, point);
        return point;
    }
});