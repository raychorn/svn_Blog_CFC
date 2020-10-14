function stripHTML() {
	var s = null;
	s = this.replace(/(<([^>]+)>)/ig,"");
	s = s.replace(/(&([^;]+);)/ig,"");
	return s;
}

String.prototype.stripHTML = stripHTML;

