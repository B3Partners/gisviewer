/**
 * Copyright (c)2005-2007 Matt Kruse (javascripttoolbox.com)
 * 
 * Dual licensed under the MIT and GPL licenses. 
 * This basically means you can use this code however you want for
 * free, but don't claim to have written it yourself!
 * Donations always accepted: http://www.JavascriptToolbox.com/donate/
 * 
 * Please do not link to the .js files on javascripttoolbox.com from
 * your site. Copy the files locally to your server instead.
 * 
 */
s_moveOptionUp = function(obj) {
	if (!s_hasOptions(obj)) { return false; }
	for (i=0; i<obj.options.length; i++) {
		if (obj.options[i].selected) {
			if (i>0 && !obj.options[i-1].selected) {
				s_swapOptions(obj,i,i-1);
				obj.options[i-1].selected = true;
			}
		}
	}
	return true;
};

s_moveOptionDown = function(obj) {
	if (!s_hasOptions(obj)) { return false; }
	for (i=obj.options.length-1; i>=0; i--) {
		if (obj.options[i].selected) {
			if (i != (obj.options.length-1) && ! obj.options[i+1].selected) {
				s_swapOptions(obj,i,i+1);
				obj.options[i+1].selected = true;
			}
		}
	}
	return true;
};

s_swapOptions = function(obj,i,j) {
	if (!s_hasOptions(obj)) { return false; }
	var o = obj.options;
	if (i<0 || i>=o.length || j<0 || j>=o.length) { return false; }
	var i_selected = o[i].selected;
	var j_selected = o[j].selected;
	var temp = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
	var temp2= new Option(o[j].text, o[j].value, o[j].defaultSelected, o[j].selected);
	o[i] = temp2;
	o[j] = temp;
	o[i].selected = j_selected;
	o[j].selected = i_selected;
	return true;
};

s_hasOptions = function(obj) {
	return (obj!=null && typeof(obj.options)!="undefined" && obj.options!=null);
};

s_addOption = function(obj,text,value,selected) {
	if (obj!=null && obj.options!=null) {
		obj.options[obj.options.length] = new Option(text, value, false, selected);
	}
};