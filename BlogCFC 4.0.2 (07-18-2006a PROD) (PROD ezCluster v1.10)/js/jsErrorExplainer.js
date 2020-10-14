function jsErrorExplainer(e, funcName) {
	var _db = ''; 
	_db += "e.number is: " + (e.number & 0xFFFF) + '\n'; 
	_db += "e.description is: " + e.description + '\n'; 
	_db += "e.name is: " + e.name + '\n'; 
	_db += "e.message is: " + e.message + '\n';
	alert(funcName + '\n' + e.toString() + '\n' + _db);
}
