/* 
 * Copyright (C) 2013 geertplaisier
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

(function($){
    $(document).ready(function() {
        function changeViewertype(useviewer) {
            $('a').not('.switcher').each(function() {
                var href = $(this).attr('href');
                if(useviewer) {
                    if(!href.match(/forceViewer/)) href = href + '?forceViewer=true';
                } else {
                    href = href.replace('?forceViewer=true', '');
                }
                $(this).attr('href', href);
            });
        }
        var viewerswitch = $('<p></p>').addClass('solutionparc_switch');
        viewerswitch.append('<a href="#" id="viewerlayout" class="switcher switch_right active"><img src="' + basepath + 'images/icons/map.png" alt="Viewerweergave" /> Viewer</a>');
        viewerswitch.append('<a href="#" id="listlayout" class="switcher switch_left"><img src="' + basepath + 'images/icons/search_list.png" alt="Lijstweergave" /> Lijst</a>');
        viewerswitch.children('a').click(function(e) {
            e.preventDefault();
            $('.switcher').removeClass('active');
            $(this).addClass('active');
            if($(this).attr('id') === 'viewerlayout') {
                changeViewertype(true);
            } else {
                changeViewertype(false);
            }
            return false;
        });
        viewerswitch.insertBefore('.solutionparc_homeblocks, .solutionparc_vervolgblocks');
        changeViewertype(true);
    });
}(jQuery));