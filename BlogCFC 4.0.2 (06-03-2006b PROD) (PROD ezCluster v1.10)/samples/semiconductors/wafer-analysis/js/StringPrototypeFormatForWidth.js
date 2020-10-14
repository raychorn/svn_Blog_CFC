function formatForWidth(iWidth) {
	var s = '';
	var ss = '';
	var t = this;
	var i = -1;
	var ar = this.split(',');
	var n = ar.length;
	if ( (this.length > iWidth) && (ar.length > 1) ) {
		t = '';
		for (i = 0; i < n; i++) {
			ss = ar[i] + ((i < (n- 1)) ? ',' : '');
			if ((s.length + ss.length) >= iWidth) {
				t += s + '\n' + ss;
				s = '';
			} else {
				s += ss;
			}
		}
		t += s;
	}
	return t;
}

String.prototype.formatForWidth = formatForWidth;

