function stripIllegalChars() {
	return this.URLEncode(); 
}

String.prototype.stripIllegalChars = stripIllegalChars;

