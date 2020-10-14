function $(id, _frame) {
	var oO = -1;
	id = ((!!_frame) ? _frame + '.' + id : id);
	if ($cache[id] == null) { oO = _$(id, _frame); $cache[id] = oO;} else {oO = $cache[id];}
	return oO;
}

