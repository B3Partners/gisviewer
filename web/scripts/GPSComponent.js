/* 
 * Copyright (C) 2012 Expression organization is undefined on line 4, column 61 in Templates/Licenses/license-gpl30.txt.
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
var gps_timeoutId = null;
var gps_interval = 15000;
var gps_buffer = null;

var gps_lat;
var gps_lon;

function GPSComponent(locationBuffer) {
    if (locationBuffer) {
        gps_buffer = locationBuffer;
    }

    Proj4js.defs["EPSG:28992"] = "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812 +units=m +no_defs";
    Proj4js.defs["EPSG:4236"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ";

    this.startPolling = function() {
        gps_timeoutId = setInterval(once, gps_interval);
        once();
    };

    this.stopPolling = function() {
        clearInterval(gps_timeoutId);
    };

    once = function() {
        if (!(navigator && navigator.geolocation)) {
            return;
        }

        navigator.geolocation.getCurrentPosition(
                function(location) {
                    receiveLocation(location);
                }, errorHandler);
    };

    receiveLocation = function(location) {
        var lat = location.coords.latitude;
        var lon = location.coords.longitude;

        gpsLat = lat;
        gpsLon = lon;

        var point = transformLatLon(Number(lon), Number(lat));

        var minx = point.x - gps_buffer;
        var miny = point.y - gps_buffer;
        var maxx = point.x + gps_buffer;
        var maxy = point.y + gps_buffer;

        var extent = new Extent(minx, miny, maxx, maxy);

        B3PGissuite.vars.webMapController.getMap().zoomToExtent(extent);
        B3PGissuite.vars.webMapController.getMap().setMarker("searchResultMarker", point.x, point.y);
    };

    errorHandler = function(error) {
        alert("Kan locatie niet bepalen");
    };

    transformLatLon = function(x, y) {
        var source = new Proj4js.Proj("EPSG:4236");
        var dest = new Proj4js.Proj("EPSG:28992");
        var point = new Proj4js.Point(x, y);

        Proj4js.transform(source, dest, point);

        return point;
    };
}