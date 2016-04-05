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

B3PGissuite.defineComponent('Cyclomedia', {
    constructor: function Cyclomedia(options) {
        var me = this;
        this.ownCyclomedia = B3PGissuite.vars.webMapController.createTool("ownCyclomediaClicker", Tool.CLICK, {
            click: function (event) {

                var opx = this.map.getLonLatFromPixel(event.xy);
                // format ownCyclomediaUrl = http://www.server.nl?address=[RDX] [RDY]
                var url = B3PGissuite.config.ownCyclomediaUrl;
                url = url.replace("[RDX]", opx.lon);
                url = url.replace("[RDY]", opx.lat);
                if (B3PGissuite.vars.webMapController.getMap().markers) {
                    B3PGissuite.vars.webMapController.getMap().removeMarker("cycloMediaMarker");
                }
                B3PGissuite.viewercommons.popUp(url, "Rondkijkfoto", 1200, 847, false);
                B3PGissuite.vars.webMapController.getMap().setMarker("cycloMediaMarker", opx.lon, opx.lat);
            },
            title: "cyclomedia"
        });
        B3PGissuite.vars.webMapController.addTool(me.ownCyclomedia);

    },
    startClicking: function () {

        this.ownCyclomedia.getFrameworkTool().activate();



    },
    stopClicking: function () {
        this.ownCyclomedia.getFrameworkTool().deactivate();

        if (B3PGissuite.vars.webMapController.getMap().markers) {
            B3PGissuite.vars.webMapController.getMap().removeMarker("cycloMediaMarker");
        }
    }






});