function stripSpacesBy2s() {
	return this.replace(/\  /ig, "");
}

String.prototype.stripSpacesBy2s = stripSpacesBy2s;

