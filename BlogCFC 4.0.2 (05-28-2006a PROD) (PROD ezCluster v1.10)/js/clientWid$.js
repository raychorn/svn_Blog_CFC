function clientWid$() {
	var _clientWidth = -1;
	var ta = typeof window.innerWidth;
	if (ta.trim().toUpperCase() == const_number_symbol.trim().toUpperCase()) {
		_clientWidth = window.innerWidth;
	} else {
		if (document.documentElement && document.documentElement.clientWidth) {
			_clientWidth = document.documentElement.clientWidth;
		} else {
			if (document.body && document.body.clientWidth) {
				_clientWidth = document.body.clientWidth;
			}
		}
	}
	return _clientWidth;
}
