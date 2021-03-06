function displayPopUpAtForDiv(oObj, anchorPos) {
	if (!!oObj) {
		oObj.style.position = const_absolute_symbol;
		if ( (!!anchorPos) && (!!anchorPos.x) ) oObj.style.left = (anchorPos.x - 310) + "px";
		if ( (!!anchorPos) && (!!anchorPos.y) ) oObj.style.top = (anchorPos.y - 155) + "px";
		oObj.style.display = ((oObj.style.display == const_none_style) ? const_inline_style : const_none_style);
	}
	return oObj;
}

function displayContactUsContentIn(oObj, actionURL) {
	var _html = '';
	if (!!oObj) {
		_html += '<table width="350px" border="1" bgcolor="#FFFFA8" cellpadding="-1" cellspacing="-1">';
		_html += '<tr bgcolor="silver">';
		_html += '<td>';
		_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
		_html += '<tr>';
		_html += '<td width="90%" align="center" valign="top">';
		_html += '<span class="normalBoldBluePrompt">Contact Us</span>';
		_html += '</td>';
		_html += '<td width="*" align="center" valign="top">';
		_html += '<input type="Button" id="button_dismiss_contactUs_panel" class="buttonClass" value="[X]" onclick="displayPopUpAtForDiv($(\'div_contactUs\')); return false;">';
		_html += '</td>';
		_html += '</tr>';
		_html += '</table>';
		_html += '</td>';
		_html += '</tr>';
		_html += '<tr>';
		_html += '<td>';
		_html += '<form name="form_contactUs" action="' + ((!!actionURL) ? actionURL : '') + '" enctype="application/x-www-form-urlencoded">';
		_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
		_html += '<tr>';
		_html += '<td width="20%" align="left" valign="top">';
		_html += '<span class="normalBoldBluePrompt">Your Email Address:</span>';
		_html += '</td>';
		_html += '<td width="*" align="left" valign="top">';
		_html += '<input name="input_emailAddress" value="yourEmail@yourDomain.com" size="50" maxlength="255">';
		_html += '</td>';
		_html += '</tr>';
		_html += '<tr>';
		_html += '<td>';
		_html += '<span class="normalBoldBluePrompt">Your Message:</span>';
		_html += '</td>';
		_html += '<td>';
		_html += '<textarea name="textarea_yourMessage" cols="50" rows="3"></textarea>';
		_html += '</td>';
		_html += '</tr>';
		_html += '<tr>';
		_html += '<td colspan="2">';
		_html += '<input type="Submit" id="button_submit_contactUs_panel" class="buttonClass" value="[Submit]">';
		_html += '</td>';
		_html += '</tr>';
		_html += '';
		_html += '';
		_html += '';
		_html += '</table>';
		_html += '</form>';
		_html += '</td>';
		_html += '</tr>';
		_html += '</table>';
		try {
			flushGUIObjectChildrenForObj(oObj);
		} catch(e) {
		} finally {
		}
		oObj.innerHTML = _html;
	}
}

function validateLoginUserName() {
	var oObj = $('login_input_username'); 
	var btnObj = $('button_loginSubmit'); 
	if ( (!!oObj) && (!!btnObj) ) { 
		var ar = oObj.value.split('@'); 
		var ar2 = oObj.value.split('.'); 
		btnObj.disabled = ( (ar.length < 2) || (ar2.length < 2) || (ar[0].length < 1) || (ar[1].length < 1) || (ar2[0].length < 1) || (ar2[ar2.length - 1].length < 3) ); 
	};
}
