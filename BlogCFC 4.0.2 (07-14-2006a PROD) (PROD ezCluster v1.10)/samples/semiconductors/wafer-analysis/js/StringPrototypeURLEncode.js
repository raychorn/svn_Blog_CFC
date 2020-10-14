function _URLEncode() {
	return URLEncode(this);
}

String.prototype.URLEncode = _URLEncode;

