function _displaySysMessages(s, t, bool_hideShow, taName, useHTML) {
	var cObj = $('div_sysMessages');
	var tObj = $('span_sysMessages_title');
	var sObj = $('span_sysMessages_body');
	var tbObj = $('div_sysMessages_titleBar_tr');
	var taObj = _$(taName);
	var s_ta = '';
	s = ((s == null) ? '' : s);
	t = ((t == null) ? '' : t);
	useHTML = ((useHTML == true) ? useHTML : false);
	if ( (!!cObj) && (!!sObj) && (!!tObj) && (!!tbObj) ) {
		bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
		s_ta = ((useHTML) ? sObj.innerHTML : ((!!taObj) ? taObj.value : ''));
		tbObj.bgColor = ((t.trim().toUpperCase() != const_debug_symbol.trim().toUpperCase()) ? 'red' : 'silver');
		flushCache$(sObj);
		sObj.innerHTML = ((useHTML) ? ((s.length > 0) ? s_ta + '\n' : '') + s : '<textarea id="' + taName + '" class="codeSmaller" cols="150" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>');
		flushCache$(tObj);
		tObj.innerHTML = t;
		cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
		cObj.style.position = const_absolute_style;
		cObj.style.left = 10 + 'px';
		cObj.style.top = document.body.scrollTop + 15 + 'px';
		cObj.style.width = (clientWid$() - 10) + 'px';
		cObj.style.height = (clientHt$() - 10) + 'px';
	} else {
		alert('Programming Error: Missing one of the following - ' + 'cObj = [' + cObj + ']' + ', sObj = [' + sObj + ']' + ', tObj = [' + tObj + ']' + ', tbObj = [' + tbObj + ']');
	}
}

function dispaySysMessages(s, t) {
	return _displaySysMessages(s, t, true, 'textarea_sysMessages_body');
}

function dispayHTMLSysMessages(s, t) {
	return _displaySysMessages(s, t, true, 'textarea_sysMessages_body', true);
}

function _alert(s) {
	return dispaySysMessages(s, 'DEBUG');
}

function _alertHTML(s) {
	return dispayHTMLSysMessages(s, 'DEBUG');
}

function dismissSysMessages() {
	return _displaySysMessages('', '', false, 'textarea_sysMessages_body');
}

function _alertError(s) {
	return dispaySysMessages(s, 'ERROR');
}

function _alertHTMLError(s) {
	return dispayHTMLSysMessages(s, 'ERROR');
}

