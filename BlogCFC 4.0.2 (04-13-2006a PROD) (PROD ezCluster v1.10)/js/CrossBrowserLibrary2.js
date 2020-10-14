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
				
function isValidatedRegisterUserName() {
	var oObj = $('register_input_username'); 
	if (!!oObj) { 
		var _f = oObj.value.search(/^[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\.(?:[a-zA-Z]{2}|com|org|net|biz|info|cc|ws|us|tv)$/); 
		var _f2a = oObj.value.indexOf('@hotmail.com'); 
		var _f2b = oObj.value.indexOf('@gmail.com'); 
		var _f2c = oObj.value.indexOf('@yahoo.com'); 
	//	window.status = '_f = [' + _f + ']' + ', _f2a = [' + _f2a + ']' + ', _f2b = [' + _f2b + ']' + ', _f2c = [' + _f2c + ']';
		return (( (_f == -1) || (_f2a != -1) || (_f2b != -1) || (_f2c != -1) ) ? true : false); 
	};
	return true;
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
		if ( (!!btnObj) && (!!formObj) ) {
			btnObj.disabled = true;
			var tid = cache_delayedButtonDisablerByID.pop();
			clearInterval(tid);
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
