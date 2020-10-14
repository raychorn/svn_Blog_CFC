function _$(id, _frame) {
	return ((!!_frame) ? ((_frame.document.getElementById) ? _frame.document.getElementById(id) : null) : ((document.getElementById) ? document.getElementById(id) : null));
}
