/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
Place following line in head TAG:
<script language="JavaScript" src="/WHEREINPATH/collapse_expand_single_item.js"></script>

Place in body TAG:
<img src="/IMAGESDIR/u.gif" name="imgfirst" width="9" height="9" border="0" >
<a  href="#first" onClick="shoh('first');" >Customer Support</a>
<div style="display: none;" id="first" >
	TEXT, TEXT, TEXT
</div>
 */

imgout = new Image(9,9);
imgin  = new Image(9,9);
imgout.src="../images/u.gif";
imgin.src="../images/d.gif";

//Switch expand collapse icons
function filter(imagename, objectsrc) {
    if (document.images) {
        document.images[imagename].src=eval(objectsrc+".src");
    }
}

//show OR hide funtion depends on if element is shown or hidden
function shoh(id) {	
    if (document.getElementById) { // DOM3 = IE5, NS6
        if (document.getElementById(id).style.display == "none"){
            document.getElementById(id).style.display = 'block';
            filter(("img"+id),'imgin');			
        } else {
            filter(("img"+id),'imgout');
            document.getElementById(id).style.display = 'none';			
        }	
    } else { 
        if (document.layers) {	
            if (document.id.display == "none"){
                document.id.display = 'block';
                filter(("img"+id),'imgin');
            } else {
                filter(("img"+id),'imgout');	
                document.id.display = 'none';
            }
        } else {
            if (document.all.id.style.visibility == "none"){
                document.all.id.style.display = 'block';
            } else {
                filter(("img"+id),'imgout');
                document.all.id.style.display = 'none';
            }
        }
    }
}