function jsErrorExplainer(errObj, funcName, bool_useAlert) {
	var _db = '';
	var msg = '';
	if (!!errObj) {
		_db += "errObj.number is: [" + (errObj.number & 0xFFFF) + ']\n'; 
		_db += "errObj.description is: [" + errObj.description + ']\n'; 
		_db += "errObj.name is: [" + errObj.name + ']\n'; 
		_db += "errObj.message is: [" + errObj.message + ']\n';
		msg = ((!!funcName) ? funcName + '\n' : '') + errObj.toString() + '\n' + _db;
	}
	if (bool_useAlert = ((bool_useAlert == true) ? bool_useAlert : false)) {
		if (!!_alert) _alert(msg);	else alert(msg);
	}
	return msg;
}

