function objectExplainer(obj) {
	var _db = '';
	var m = -1;
	var i = -1;
	var a = [];
	
	_db = '[';
	if ( (!!obj) && (typeof obj == const_object_symbol) ) {
		if (!!obj.length) {
		    for (i = 0; i < obj.length; i++) {
				a.push('obj[' + i + '] = [' + obj[i] + ']');
		    }
		} else {
			for (m in obj) {
				a.push(m + ' = [' + obj[m] + ']');
			}
		}
		_db += a.join(', ');
	} else {
		_db += obj;
	}
	_db += ']';
	return _db;
}

