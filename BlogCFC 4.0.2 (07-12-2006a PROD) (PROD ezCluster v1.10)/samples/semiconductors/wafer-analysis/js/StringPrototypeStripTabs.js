function stripTabs(s) {
	s = ((!s) ? '' : s);
	return this.replace(/\t/ig, s);
}

String.prototype.stripTabs = stripTabs;

