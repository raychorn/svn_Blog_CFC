function jsObjectExplainer(o) {
	var _db = ''; 
	var m = -1;
	var o_m = -1;
	var typOf = typeof o;

	if (typOf == const_object_symbol) {
		for (m in o) {
			_db += 'o[' + m + '] = '; 
			try {
				o_m = o[m];
			} catch(e) {
				o_m = 'undefined';
			} finally {
			}
			_db += '(' + o_m + ')\n'; 
		}
	}
	alert('jsObjectExplainer(' + o + ', typOf = [' + typOf + ']) ::' + ((o.length) ? ' o.length = [' + ((o.length) ? o.length : 'undefined') + ']' : '') + '\n' + _db);
}
