function clientHt$() {
	var _clientHeight = -1;
	var ta = typeof window.innerHeight;
	if (ta.trim().toUpperCase() == const_number_symbol.trim().toUpperCase()) {
		_clientHeight = window.innerHeight;
	} else {
		if (document.documentElement && document.documentElement.clientHeight) {
			_clientHeight = document.documentElement.clientHeight;
		} else {
			if (document.body && document.body.clientHeight) {
				_clientHeight = document.body.clientHeight;
			}
		}
	}
	return _clientHeight;
}
