function window_onUnload() {
	// BEGIN: Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...

	AJaxContextObj.remove$s();
	AJAXObj.remove$s();
	QObj.remove$s();
	GUIActsObj.remove$s();
	DictObj.remove$s();
	AJAXEngine.remove$s();
	// END! Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...

	// BEGIN: Clean-up event handlers to avoid memory leaks...
	var bodyObj = document.getElementsByTagName('body')[0];
	if (!!bodyObj) {
		var a = bodyObj.getElementsByTagName('div');
		for (var i = 0; i < a.length; i++) {
			flushCache$(a[i]);
		}
		flushCache$(bodyObj);
	}
	// END! Clean-up event handlers to avoid memory leaks...
}

