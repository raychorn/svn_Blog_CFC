// misc.js

function uuid$() {
	return (new Date().getTime() + "" + Math.floor(65535 * Math.random()));
}

function _asHex(ch) {
	var HEX = "0123456789ABCDEF";

	function _intAsHex(i) {
		if (i != null) {
		    var ii = i & 0xFF;
			return HEX.charAt((ii >> 4) & 0xF) + HEX.charAt(ii & 0xF);
		}
		return '';
	};

	if (typeof ch == const_string_symbol) {
	    var charCode = ch.charCodeAt(0) & 0xFF;
		return HEX.charAt((charCode >> 4) & 0xF) + HEX.charAt(charCode & 0xF);
	} else if (typeof ch == const_number_symbol) {
		return _intAsHex(ch);
	}
	return ch;
}

function _asColorHex(cVal) {
	var x1 = (cVal & 0xff0000) >> 16;
	var x2 = (cVal & 0x00ff00) >> 8;
	var x3 = cVal & 0x0000ff;
	return _asHex(x1) + _asHex(x2) + _asHex(x3);
}

