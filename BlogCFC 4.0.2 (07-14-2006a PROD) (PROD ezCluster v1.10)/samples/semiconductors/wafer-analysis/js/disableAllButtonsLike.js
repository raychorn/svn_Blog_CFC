function disableAllButtonsLike(aName) {
	var els = document.getElementsByTagName("BUTTON");
	for (var i = 0; i < els.length; i++) {
		if (els[i].id.toUpperCase().indexOf(aName.toUpperCase()) != -1) {
			els[i].disabled = true;
		}
	}
}

