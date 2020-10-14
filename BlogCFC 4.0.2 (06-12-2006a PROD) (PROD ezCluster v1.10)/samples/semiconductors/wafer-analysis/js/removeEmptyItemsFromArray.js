function removeEmptyItemsFromArray(ar) {
	var ar2 = [];
	if (typeof ar == const_object_symbol) {
		for (var i = 0; i < ar.length; i++) {
			if ( (!!ar[i]) && (ar[i].trim().length > 0) ) ar2[ar2.length] = ar[i];
		}
		return ar2;
	}
	return ar;
}

