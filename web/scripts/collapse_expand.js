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