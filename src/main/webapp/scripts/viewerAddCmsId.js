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
(function($) {
    $(document).ready(function() {
        $('a').not('.switcher').each(function() {
            var href = $(this).attr('href');
            if (href.match(/viewer.do/) && href !== '#') {
                href = addCmsIdToString(href, 'cmsPageId', cmsPageId);
            }


            $(this).attr('href', href);
        });

        function addCmsIdToString(url, key, value) {
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
    });
}(jQuery));