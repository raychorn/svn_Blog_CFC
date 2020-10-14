function register_AJAX_function(f) {
	_stack_AJAX_functions.push(f);
}

function handle_next_AJAX_function() {
	var f = _stack_AJAX_functions.pop();
	if (!!f) { eval(f);	}
}

function ajaxBegins(width) {
	var resp = '';
	if (width == null) {
		width = const_jsapi_width_value;
	}
	resp = '<table width="' + parseInt(width) + 'px" bgcolor="' + const_paper_color_light_yellow + '" border="1" cellpadding="-1" cellspacing="-1">';
	resp += '<tr>';
	resp += '<td height="25px">';
	return resp;
}

function ajaxEnds() {
	var resp = '';
	resp += '</td>';
	resp += '</tr>';
	resp += '</table>';
	return resp;
}

function showAJAXBegins(sMsg, sImage, imageHeight) {
	var resp = '';
	var frameCode = '';
	var divName = const_cf_html_container_symbol;
	var cObj = $(divName);

	if (!!cObj) {
		imageHeight = ((!!imageHeight) ? imageHeight : '55%');

		var ar_docHref = document.location.href.split('?');
		if (ar_docHref.length > 1) {
			ar_docHref.pop();
		}
		docHref = ar_docHref.join('');
		ar_docHref = document.location.href.split('/');
		if ( (ar_docHref.length > 1) && (ar_docHref[ar_docHref.length - 1].toLowerCase().indexOf('.cfm') > -1) ) {
			ar_docHref.pop();
		}
		docHref = ar_docHref.join('/');
		
		resp = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';
		resp += '<html><head><title>System Activity Display</title>';
		resp += '<link rel=stylesheet type="text/css" href="' + docHref + ((docHref.charAt(docHref.length - 1) != '/') ? '/' : '') + 'AJAX/ajaxStyles.css">';
		resp += '</head>';
		resp += '<body>';
		resp += ajaxBegins();
		resp += '<b>' + ((!!sMsg) ? sMsg : const_loading_data_message_symbol) + '</b>';
		resp += '&nbsp;&nbsp;<img height="' + imageHeight + '" src="' + ((!!sImage) ? sImage : const_jsapi_loading_image) + '" border="0">';
		resp += ajaxEnds();
		resp += '</body></html>';
//	_alert(resp);
		frameCode = '<iframe id="iframe_showAJAXBegins" frameborder="0" marginwidth="0" marginheight="0" scrolling="No" style="display: none;"></iframe>';
		if (cObj.innerHTML.length > 0) {
			flushCache$(cObj); 
		}
		cObj.innerHTML = frameCode;
		var frObj = $('iframe_showAJAXBegins');
		if (!!frObj) {
			frObj.contentWindow.document.writeln(resp);
			frObj.style.display = const_inline_style;
			cObj.style.position = const_absolute_style;
			cObj.style.top = '0px';
			cObj.style.left = (clientWid$() - const_jsapi_width_value - 1) + 'px';
			cObj.style.height = '30px';
			cObj.style.width = const_jsapi_width_value + 'px';
			frObj.style.position = const_absolute_style;
			frObj.style.top = document.body.scrollTop + 'px';
			frObj.style.left = '0px';
			frObj.style.height = '30px';
			frObj.style.width = const_jsapi_width_value + 'px';
		//	alert('(' + frObj.style.top + ',' + frObj.style.left + ')' + ', (' + frObj.style.height + ',' + frObj.style.width + ')');
		}

		var dObj = $(const_div_floating_debug_menu);
		if (!!dObj) {
			dObj.style.position = cObj.style.position;
		}
	}
}

function showAJAXEnds() {
	var frObj = $('iframe_showAJAXBegins');
	if (!!frObj) {
		if (frObj.style.display != const_none_style) {
			frObj.style.display = const_none_style;
		}
	}
}

function clearAJAXEnds() {
	var resp = '';
	var divName = const_cf_html_container_symbol;
	var cObj = $(divName);

	if (!!cObj) {
		if (cObj.innerHTML.length > 0) {
			flushCache$(cObj); 
		}
		resp = ajaxBegins();
		resp += '<b>' + const_system_ready_message_symbol + '</b>';
		resp += ajaxEnds();
		cObj.innerHTML = resp;
	}
}

function initJSQ(qryObjName, columnList) {
	var s_code = qryObjName + ' = -1;';
	var qryObj = eval(s_code);
	try { eval(qryObjName + ' = ((' + qryObjName + ') ? object_destructor(' + qryObjName + ') : null)'); } catch(e) { } finally { };
	eval(qryObjName + " = QObj.get$((columnList) ? columnList : '')");
}

