function toCamelCase( sInput ) {
	var sArray = sInput.split('-');
	if (sArray.length == 1)	{
		return sArray[0];
	}
	var ret = '';
	var s = '';
	var len = sArray.length
	for(var i = 0; i < len; i++) {
		s = sArray[i];
		ret += s.charAt(0).toUpperCase() + s.substring(1)
	}
	return ret;
}

