function trim() {  
	var s = this.replace(/^[\s]+/,"");  
	s = s.replace(/[\s]+$/,"");  
	return s;
}

String.prototype.trim = trim;

