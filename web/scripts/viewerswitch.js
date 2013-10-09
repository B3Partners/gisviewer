/* 
 * Copyright (C) 2013 B3Partners B.V.
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
        function changeViewertype(layouttype) {
            var useviewer = (layouttype === 'kaartlayout');
            $('a').not('.switcher').each(function() {
                var href = $(this).attr('href');
                if(useviewer) {
                    if(!href.match(/forceViewer/) && href.match(/viewer.do/) && href !== '#') {
                        href = addToQueryString(href, 'forceViewer', 'true');
                    }
                } else {
                    href = href.replace(/[\&\?]forceViewer=true/, '');
                }
                $(this).attr('href', href);
            });
            saveViewerPreference(layouttype);
        }
        function addToQueryString(url, key, value) {
            var query = url.indexOf('?');
            if (query === url.length - 1) {
                // Strip any ? on the end of the URL
                url = url.substring(0, query);
                query = -1;
            }
            var anchor = url.indexOf('#');
            return (anchor > 0 ? url.substring(0, anchor) : url)
                 + (query > 0 ? "&" + key + "=" + value : "?" + key + "=" + value)
                 + (anchor > 0 ? url.substring(anchor) : "");
        }
        function saveViewerPreference(value) {
            document.cookie = "gisviewerpref="+value+"; path=/";
        }
        function readViewerPreference() {
            var nameEQ = "gisviewerpref=";
            var ca = document.cookie.split(';');
            for(var i=0;i < ca.length;i++) {
                var c = ca[i];
                c = c.replace(/^\s+|\s+$/g, ''); // trun
                if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length,c.length);
            }
            return null;
        }
        var cookievalue = readViewerPreference();
        if(cookievalue === null) cookievalue = 'kaartlayout';
        var viewerswitchContainer = $('<div></div>').addClass('viewerswitch_container');
        var viewerswitch = $('<ul></ul>').addClass('viewerlist_switch');
        viewerswitchContainer.prepend('<span>Kies weergave:</span>');
        viewerswitch.append('<li><a href="#kaartweergave" id="kaartlayout" class="switcher switch_right' + (cookievalue === 'kaartlayout' ? ' active' : '') + '"><img src="' + gisviewerurls.mapicon + '" alt="Kaartweergave" /> Kaart</a></li>');
        viewerswitch.append('<li><a href="#tekstweergave" id="tekstlayout" class="switcher switch_left' + (cookievalue === 'tekstlayout' ? ' active' : '') + '"><img src="' + gisviewerurls.listicon + '" alt="Tekstweergave" /> Tekst</a></li>');
        viewerswitch.find('.switcher').click(function(e) {
            e.preventDefault();
            $('.switcher').removeClass('active');
            $(this).addClass('active');
            changeViewertype($(this).attr('id'));
            return false;
        });
        viewerswitchContainer.append(viewerswitch);
        viewerswitchContainer.insertBefore('.tegels, .viewerswitch');
        changeViewertype(cookievalue);
    });
}(jQuery));