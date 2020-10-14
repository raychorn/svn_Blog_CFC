function doAJAX_func(cmd, callBackFuncName, vararg_params) {
	var j = -1;
	var j2 = -1;
	var ar = [];
	var ar2 = [];
	var ampersand_i = -1;
	var equals_i = -1;
	var _argCnt = 0;
	var anArg = '';
	var iArg = 0;
	var s_argSpec = '';
	var isObject = false;
	var sValue = '&cfm=' + cmd + '&AUTH_USER=' + ((!!cf_AUTH_USER) ? cf_AUTH_USER : '') + '&callBack=' + callBackFuncName;
	
	var _db = '';

    // BEGIN: Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...
	// a Parm may be a simple value or a Query String using the standard CGI Query String specification of "&name=value"...
	iArg = 0;
    for (var i = 0; i < arguments.length - 2; i++) {
		anArg = arguments[i + 2];
		isObject = false;
		_db += ', (typeof anArg) = [' + (typeof anArg) + ']';
		if ((typeof anArg).toUpperCase() == const_object_symbol.toUpperCase()) {
			// the arg might be an array or a complex object...
			var k = -1;
			for (k = 0; k < anArg.length; k++) {
				if (anArg[k].trim().length > 0) {
					if ((typeof anArg[k]).toUpperCase() != const_string_symbol.toUpperCase()) {
						try {
							anArg[k] = anArg[k].toString();
						} catch(e) {
							anArg[k] = ''; // default is empty string whenever the thing that is not a string cannot be made into a string...
						} finally {
						}
					}
					s_argSpec += '&arg' + (iArg + 1) + '=' + anArg[k].URLEncode();
					_argCnt++;
					iArg++;
				}
			}
			isObject = true;
		} else if ((typeof anArg).toUpperCase() != const_string_symbol.toUpperCase()) {
			try {
				anArg = anArg.toString();
			} catch(e) {
				anArg = ''; // default is empty string whenever the thing that is not a string cannot be made into a string...
			} finally {
			}
		}
		_db += ', isObject = [' + isObject + ']';
		if (isObject == false) {
			ampersand_i = anArg.indexOf('&');
			equals_i = anArg.indexOf('=');
			if ( (ampersand_i != -1) && (equals_i != -1) && (ampersand_i < equals_i) ) {
				s_argSpec += anArg.toString().URLEncode();
				_argCnt++;
				iArg++;
			} else if (anArg.indexOf(',') != -1) {
				ar = anArg.split(',');
				for (j = 0; j < ar.length; j++) {
					if (ar[j].indexOf('=') != -1) {
						ar2 = ar[j].split('=');
						j2 = (j * 2);
						s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0].toString().URLEncode();
						_argCnt++;
						iArg++;
						s_argSpec += '&arg' + j2 + '=' + ar2[1].toString().URLEncode();
						_argCnt++;
						iArg++;
					} else {
						s_argSpec += '&arg' + (j + 1) + '=' + ar[j].toString().URLEncode();
						_argCnt++;
						iArg++;
					}
				}
			} else {
				s_argSpec += '&arg' + (iArg + 1) + '=' + anArg.toString().URLEncode();
				_argCnt++;
				iArg++;
			}
		}
    }
	sValue += '&argCnt=' + _argCnt + s_argSpec;
    // END! Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...

	window.status = '';
	if (global_echo_AJAX_commands) {
		_alert('doAJAX_func(cmd = [' + cmd + '], callBackFuncName = [' + callBackFuncName + ']) = [' + sValue + ']');
	} else {
		if (oAJAXEngine.isXmlHttpPreferred == false) {
			oAJAXEngine.setMethodGet();
		}
		oAJAXEngine.sendPacket(sValue);
	}
}

