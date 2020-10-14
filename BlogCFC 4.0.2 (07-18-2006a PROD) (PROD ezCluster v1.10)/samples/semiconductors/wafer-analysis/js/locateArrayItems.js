function locateArrayItems(a, what, start) {
	var f = 0;
	if (start) {
		startWhere = start 
	}
	else {
		startWhere = 0;
	}
	for(f=startWhere; f < a.length; f++) {
		if (a[f].toString().substr(0,what.length) == what.toString()) {
			return f;
		}
	}
	return -1;
}

