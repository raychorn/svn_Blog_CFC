function displayPopUpAtForDiv(oObj, anchorPos) {
	if (!!oObj) {
		oObj.style.position = const_absolute_symbol;
		if ( (!!anchorPos) && (!!anchorPos.x) ) oObj.style.left = (anchorPos.x - 310) + "px";
		if ( (!!anchorPos) && (!!anchorPos.y) ) oObj.style.top = (anchorPos.y - 165) + "px";
		oObj.style.display = ((oObj.style.display == const_none_style) ? const_inline_style : const_none_style);
	}
	return oObj;
}

function validateConactUsUserEmailAddrs() {
	_validateUserAccountName($('input_emailAddress'),$('button_submit_contactUs_panel'));
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
		_html += '<input name="input_emailAddress" value="yourEmail@yourDomain.com" size="50" maxlength="255" onkeyup="if (!!validateConactUsUserEmailAddrs) { validateConactUsUserEmailAddrs() };">';
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
		_html += '<span class="normalBoldBluePrompt">Kindly allow 24-48 hours for a response.</span>';
		_html += '</td>';
		_html += '</tr>';
		_html += '<tr>';
		_html += '<td colspan="2">';
		_html += '<input type="Submit" id="button_submit_contactUs_panel" class="buttonClass" value="[Submit]">';
		_html += '</td>';
		_html += '</tr>';
		_html += '</table>';
		_html += '</form>';
		_html += '</td>';
		_html += '</tr>';
		_html += '</table>';
		try {
			flushCache$(oObj);
		} catch(e) {
		} finally {
		}
		oObj.innerHTML = _html;
	}
}

function validateLoginUserName() {
	_validateUserAccountName($('login_input_username'),$('button_loginSubmit'));
}

function validateForgotPasswordUserName() {
	_validateUserAccountName($('input_forgot_username'),$('button_forgotPwdSubmit'));
}

function receiveRegisterData(msg) {
	var i = -1;
	var _html = '';
	var ar2 = [];
	var oObj = $('div_register_newUser_status');
	var fObj = $('body_register_newUser');
	if ( (!!oObj) && (!!fObj) ) {
		var ar = msg.split('&');
		for (i = 0; i < ar.length; i++) {
			ar2 = ar[i].split('=');
			if (ar2.length == 2) {
				if (ar2[0].toUpperCase() == 'statusMsg'.toUpperCase()) {
					_html += unescape(ar2[1]);
				} else if (ar2[0].toUpperCase() == 'showForm'.toUpperCase()) {
					fObj.style.display = ((ar2[1].toUpperCase() == 'true'.toUpperCase()) ? const_inline_style : const_none_style);
				}
			}
		}
		oObj.innerHTML = _html;
	}
}

function performSubmitRegisterForm(btnObj, iframeName, src) {
	var oObj = $(iframeName);
	var iObj1 = $('register_input_username');
	var iObj2 = $('register_input_yourname');
	var iObj3 = $('register_input_password');
	var iObj4 = $('register_input_confirmpassword');
//	alert('iframeName = [' + iframeName + ']' + ', oObj = [' + oObj + ']' + ', iObj1 = [' + iObj1 + ']' + ', iObj2 = [' + iObj2 + ']' + ', iObj3 = [' + iObj3 + ']' + ', iObj4 = [' + iObj4 + ']'); 
	if ( (!!btnObj) && (!!oObj) && (!!iObj1) && (!!iObj2) && (!!iObj3) && (!!iObj4) ) {
		var _url = src + '&isajax=1' + '&' + iObj1.name + '=' + escape(iObj1.value) + '&' + iObj2.name + '=' + escape(iObj2.value) + '&' + iObj3.name + '=' + escape(iObj3.value) + '&' + iObj4.name + '=' + escape(iObj4.value);
	//	alert(_url);
		if (!!btnObj) btnObj.disabled = true;
		oObj.src = _url;
	}
}
