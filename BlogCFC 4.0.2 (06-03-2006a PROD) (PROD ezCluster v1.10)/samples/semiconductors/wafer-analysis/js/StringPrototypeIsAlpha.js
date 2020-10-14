function isAlpha(iLoc) {
	iLoc = ((!!iLoc) ? iLoc : 0);
	iLoc = ((iLoc < 0) ? 0 : iLoc);
	iLoc = ((iLoc > (this.length - 1)) ? this.length : iLoc);
	var _ch = this.substr(iLoc, 1);
	return ( (_ch.toLowerCase() >= 'a') && (_ch.toLowerCase() <= 'z') );
}

String.prototype.isAlpha = isAlpha;

