function getAnchorPosition(anchorname) {
	var useWindow=false;
	var coordinates=new Object();
	var x=0,y=0;
	var use_gebi=false, use_css=false, use_layers=false;
	if (document.getElementById) { use_gebi=true; }
	else if (document.all) { use_css=true; }
	else if (document.layers) { use_layers=true; }
 	if (use_gebi && document.all) {
		x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);
		y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);
	} else if (use_gebi) {
		var o=document.getElementById(anchorname);
		x=AnchorPosition_getPageOffsetLeft(o);
		y=AnchorPosition_getPageOffsetTop(o);
	} else if (use_css) {
		x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);
		y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);
	} else if (use_layers) {
		var found=0;
		for (var i=0; i<document.anchors.length; i++) {
			if (document.anchors[i].name==anchorname) { found=1; break; }
		}
		if (found==0) {
			coordinates.x=0; coordinates.y=0; return coordinates;
		}
		x=document.anchors[i].x;
		y=document.anchors[i].y;
	} else {
		coordinates.x=0; coordinates.y=0; return coordinates;
	}
	coordinates.x=x;
	coordinates.y=y;
	return coordinates;
}

function getAnchorWindowPosition(anchorname) {
	var coordinates=getAnchorPosition(anchorname);
	var x=0;
	var y=0;
	if (document.getElementById) {
		if (isNaN(window.screenX)) {
			x=coordinates.x-document.body.scrollLeft+window.screenLeft;
			y=coordinates.y-document.body.scrollTop+window.screenTop;
			}
		else {
			x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;
			y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;
			}
		}
	else if (document.all) {
		x=coordinates.x-document.body.scrollLeft+window.screenLeft;
		y=coordinates.y-document.body.scrollTop+window.screenTop;
		}
	else if (document.layers) {
		x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;
		y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;
		}
	coordinates.x=x;
	coordinates.y=y;
	return coordinates;
}

function AnchorPosition_getPageOffsetLeft(el) {
	var ol = 0;
	try {
		ol = el.offsetLeft;
		while ((el = el.offsetParent) != null) {
			ol += el.offsetLeft; 
		}
	} catch(e) {
	} finally {
	}
	return ol;
}

function AnchorPosition_getWindowOffsetLeft (el) {
	var x = 0;
	var s = 0;
	try {
		x = AnchorPosition_getPageOffsetLeft(el);
		s = document.body.scrollLeft;
	} catch(e) {
	} finally {
	}
	return x - s;
}

function AnchorPosition_getPageOffsetTop (el) {
	var ot = 0;
	try {
		ot = el.offsetTop;
		while ((el = el.offsetParent) != null) {
			ot += el.offsetTop; 
		}
	} catch(e) {
	} finally {
	}
	return ot;
}

function AnchorPosition_getWindowOffsetTop(el) {
	var x = 0;
	var s = 0;
	try {
		x = AnchorPosition_getPageOffsetTop(el);
		s = document.body.scrollTop;
	} catch(e) {
	} finally {
	}
	return x - s;
}

