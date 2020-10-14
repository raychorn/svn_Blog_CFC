function _displaySysMessages(s, t, bool_hideShow, taName) {
	var cObj = $('div_sysMessages');
	var tObj = $('span_sysMessages_title');
	var sObj = $('span_sysMessages_body');
	var tbObj = $('div_sysMessages_titleBar_tr');
	var taObj = _$(taName);
	var s_ta = '';
	if ( (!!cObj) && (!!sObj) && (!!tObj) && (!!tbObj) ) {
		try {
			bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
			s_ta = ((!!taObj) ? taObj.value : '');
			tbObj.bgColor = ((t.trim().toUpperCase() != const_debug_symbol.trim().toUpperCase()) ? 'red' : 'silver');
			flushCache$(sObj);
			sObj.innerHTML = '<textarea id="' + taName + '" class="codeSmaller" cols="140" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>';
			flushCache$(tObj);
			tObj.innerHTML = t;
			cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
			cObj.style.position = 'absolute';
			cObj.style.left = 10 + 'px';
			cObj.style.top = document.body.scrollTop + 50 + 'px';
			cObj.style.width = (clientWid$() - 10) + 'px';
			cObj.style.height = (clientHt$() - 10) + 'px';
		} catch(e) {
			jsErrorExplainer(e, '_displaySysMessages()');
		} finally {
		}
	} else {
		alert('Programming Error: Missing one of the following - ' + 'cObj = [' + cObj + ']' + ', sObj = [' + sObj + ']' + ', tObj = [' + tObj + ']' + ', tbObj = [' + tbObj + ']');
	}
}

function dispaySysMessages(s, t) {
	return _displaySysMessages(s, t, true, 'textarea_sysMessages_body');
}

function _alert(s) {
	return dispaySysMessages(s, 'DEBUG');
}

function dismissSysMessages() {
	return _displaySysMessages('', '', false, 'textarea_sysMessages_body');
}

function _alertError(s) {
	return dispaySysMessages(s, 'ERROR');
}
