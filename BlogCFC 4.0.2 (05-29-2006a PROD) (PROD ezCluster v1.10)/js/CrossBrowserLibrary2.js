function disableWidget(obj, bool) {
	if (obj != null) {
		obj.disabled = ((bool == true) ? true : false);
	}
}

function disableWidgetByID(id, bool) {
	var obj = -1;
	obj = $(id);
	disableWidget(obj, bool);
}

function analyzePassword(s) {
	var i = -1;
	var ch = -1;
	var alphaCount = 0;
	var numericCount = 0;
	var specialCount = 0;
	var o = new Object();
	
	for (i = 0; i < s.length; i++) {
		ch = s.charCodeAt(i);
		alphaCount += (((ch >= 65) && (ch <= 90)) ? 1 : 0);
		alphaCount += (((ch >= 97) && (ch <= 122)) ? 1 : 0);
		numericCount += (((ch >= 48) && (ch <= 57)) ? 1 : 0);
		specialCount += (((ch >= 33) && (ch <= 47)) ? 1 : 0);
		specialCount += (((ch >= 58) && (ch <= 64)) ? 1 : 0);
		specialCount += (((ch >= 123) && (ch <= 126)) ? 1 : 0);
	}
	o.sInput = s;
	o.alphaCount = alphaCount;
	o.numericCount = numericCount;
	o.specialCount = specialCount;
	return o;
}

function _isWeakPassword(ap) {
	return ( ( (ap.alphaCount == 0) || (ap.numericCount == 0) || (ap.specialCount == 0) ) && (ap.sInput.trim().length < 8) );
}

function isWeakPassword(s) {
	var ap = analyzePassword(s);
	
	return _isWeakPassword(ap);
}

function _isMediumPassword(ap) {
	return ( ( ( (ap.alphaCount > 0) && (ap.numericCount > 0) ) || ( (ap.alphaCount > 0) && (ap.specialCount > 0) ) && (ap.sInput.trim().length > 4) ) || ( (ap.sInput.trim().length >= 8) && (ap.sInput.trim().length < 12) ) );
}

function isMediumPassword(s) {
	var ap = analyzePassword(s);
	
	return (_isWeakPassword(ap) && _isMediumPassword(ap));
}

function _isStrongPassword(ap) {
	return ( ( (ap.alphaCount > 0) || (ap.numericCount > 0) || (ap.specialCount > 0) ) && (ap.sInput.trim().length >= 12) );
}

function isStrongPassword(s) {
	var ap = analyzePassword(s);
	
	return (_isMediumPassword(ap) && _isStrongPassword(ap));
}

function isPasswordValid(s) {
	return (s.trim().length > 0);
}
				
function _validateUserAccountName(oObj, btnObj) {
	var i = -1;
	var _f2Any = false;
	if (!!oObj) {
		var _f = oObj.value.search(/^[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\.(?:[a-zA-Z]{2}|com|org|net|biz|info|cc|ws|us|tv)$/);
		var ar = js_invalidEmailDomains.split(',');
		for (i = 0; i < ar.length; i++) {
			_f2Any = _f2Any || (oObj.value.indexOf(ar[i]) != -1);
		}
		if (!!btnObj) btnObj.disabled = ( (_f == -1) || (_f2Any) ); 
		if ( (_f == -1) || _f2Any ) {
			oObj.style.border = 'thin solid red';
			oObj.title = 'Your User Name is NOT acceptable because ' + ((_f == -1) ? '"your domain name uses an invalid TLD" ' : '') + ((_f2Any) ? '"your domain name is for an anonymous email service which is a EULA Violation" ' : '') + '.';
		} else {
			oObj.style.border = 'thin solid lime';
			oObj.title = 'Your User Name is acceptable. You may proceed, however this does not mean your email address is necessarily valid unless it can accept in-coming email from our email server(s).';
		}
		return (( (_f == -1) || (_f2Any) ) ? true : false); 
	};
	return false;
}

function isValidatedRegisterUserName() {
	return _validateUserAccountName($('register_input_username'));
}

function isValidatedRegisterUsersName() {
	var i = -1;
	var isValid = true; 
	var obj = $('register_input_yourname'); 
	var otherObj = $('register_input_username');
	var btnObj = $('button_registerSubmit'); 
	var matchObj = $('div_password_matches');
	if ( (!!obj) && (!!btnObj) && (!!otherObj) && (!!matchObj) ) { 
		if (obj.value.length > 0) {
			var ar = obj.value.split(' '); 
			for (i = 0; i < ar.length; i++) {
				ar[i] = ar[i].charAt(0).toUpperCase() + ar[i].substring(1, ar[i].length).toLowerCase();
			}
			obj.value = ar.join(' ');
			isValid = (((ar.length == 2) && (ar[0].trim().length > 0) && (ar[1].trim().length > 0)) ? false : true); 
		}
		var x = otherObj.style.border;
		var b = ( (x.length == 0) || (x.toString().indexOf('red') != -1) || (matchObj.innerHTML.indexOf('Matches') == -1) );
		btnObj.disabled = (((isValid) || (b)) ? true : false); 
	//	if (!isValid) alert('isValid = [' + isValid + ']' + ', b = [' + b + ']' + ', test1 = [' + (x.length == 0) + ']' + ', test2 = [' + x.toString() + ']' + ', test3 = [' + matchObj.innerHTML + ']');
		obj.style.border = ((isValid) ? 'thin solid red' : 'thin solid lime'); 
	}; 
	return isValid;
}

function validatePassword(s, sOther) {
	var bool_isPasswordValid = isPasswordValid(s);
	var bool_isOtherPasswordPresent = (sOther != null);
	var bool_isOtherPasswordValid = (((bool_isOtherPasswordPresent) && (s == sOther)) ? true : false);
	var ap = -1;
	var cObj1 = $('register_input_password');
	var cObj2 = $('register_input_confirmpassword');
	var bool_shallSubmitBtnBeDisabled = true;
	var bool_passwordsMatches = false;

	var cObj = $((bool_isOtherPasswordPresent) ? 'span_password_matches' : 'span_password_rating');
	var tdObj = $((bool_isOtherPasswordPresent) ? 'td_password_matches' : 'td_password_rating');
	try {
		if (bool_isPasswordValid) {
			// rate the password...
			ap = analyzePassword(s);
			// display the rating...
			if ( (cObj != null) && (tdObj != null) ) {
				if (bool_isOtherPasswordPresent) {
					if (s == sOther) {
						tdObj.style.background = 'lime';
						cObj.innerHTML = '(Matches)';
						disableWidgetByID('div_password_matches', false);
						bool_passwordsMatches = true;
					} else {
						tdObj.style.background = '';
						cObj.innerHTML = '(Does Not Match)';
						disableWidgetByID('div_password_matches', true);
						bool_passwordsMatches = false;
					}
				} else {
					if (_isStrongPassword(ap)) {
						tdObj.style.background = 'lime';
						cObj.innerHTML = '(Strong)';
						disableWidgetByID('div_password_rating', false);
					} else if (_isMediumPassword(ap)) {
						tdObj.style.background = 'cyan';
						cObj.innerHTML = '(Medium)';
						disableWidgetByID('div_password_rating', false);
					} else if (_isWeakPassword(ap)) {
						tdObj.style.background = 'yellow';
						cObj.innerHTML = '(Weak)';
						disableWidgetByID('div_password_rating', false);
					} else {
						tdObj.style.background = '';
						cObj.innerHTML = '(Not Rated)';
						disableWidgetByID('div_password_rating', true);
					}
				}
			}
		} else {
			if ( (cObj != null) && (tdObj != null) ) {
				if (bool_isOtherPasswordPresent) {
					tdObj.style.background = '';
					cObj.innerHTML = '(Does Not Match)';
					disableWidgetByID('div_password_matches', true);
					bool_passwordsMatches = false;
				} else {
					tdObj.style.background = '';
					cObj.innerHTML = '(Not Rated)';
					disableWidgetByID('div_password_rating', true);
				}
			}
		}

		bool_shallSubmitBtnBeDisabled = true;
		if ( (cObj1 != null) && (cObj2 != null) ) {
			bool_shallSubmitBtnBeDisabled = ( (cObj1.value.trim().length > 0) && (cObj2.value.trim().length > 0) );
		}

		if ( (bool_shallSubmitBtnBeDisabled == false) || (bool_passwordsMatches == false) ) {
			var mObj = $('span_register_newUser_status_message');
			if (mObj != null) {
				if (bool_isOtherPasswordValid == false) {
					mObj.innerHTML = 'WARNING: Password is not valid because it does not match or it is the first password entered.';
				} else {
					mObj.innerHTML = 'WARNING: Password is not valid because it does not contain the following characters ("a"-"z" or "A"-"Z" and "0"-"9" and any special characters). PLS enter a valid password.';
				}
			}

			disableWidgetByID('button_registerSubmit', true);
			return true;
		} else {
			var mObj = $('span_register_newUser_status_message');
			if (mObj != null) {
				mObj.innerHTML = '';
			}
			
			disableWidgetByID('button_registerSubmit', isValidatedRegisterUserName());
			return false;
		}
	} catch(e) {
	} finally {
	}

	return true;
}

var cache_delayedButtonDisablerByID = [];

function delayedDisablerProcessByID(id, formID) {
	try {
		var btnObj = $(id);
		var formObj = $(formID);
		var dObj = $('div_ssl_login_status');
		if ( (!!btnObj) && (!!formObj) ) {
			btnObj.disabled = true;
			var tid = cache_delayedButtonDisablerByID.pop();
			clearInterval(tid);
			dObj.style.display = const_inline_style;
			var ar_server = document.location.href.split('/');
			var _url = 'http://' + ar_server[2] + '/' + ar_server[3] + '/images/i_animated_loading.gif';
			dObj.innerHTML = '<span class="normalBoldBluePrompt">Processing Login... Please stand-by, this may take a few seconds.</span><img src="' + _url + '" alt="" width="32" height="32" border="0">';
			formObj.submit();
		}
	} catch(e) {
	} finally {
	}
}

function delayedButtonDisablerByID(id, formID) {
	var btnObj = $(id);
	if (!!btnObj) {
		var tid = setInterval("delayedDisablerProcessByID('" + id + "', '" + formID + "')", 10);
		cache_delayedButtonDisablerByID.push(tid);
	}
}
