function simulateCheckBoxClick(id) {
	var cObj = $(id);
	if (!!cObj) {
		cObj.checked = ((cObj.checked) ? false : true);
		window.status = 'typeof cObj.onclick = [' + (typeof cObj.onclick) + ']';
		if (typeof cObj.onclick == const_function_symbol) cObj.onclick();
	}
}

