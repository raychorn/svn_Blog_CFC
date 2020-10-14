/**************************************************************************/

function sum() {
	var _sum = 0;

	for (i = 0; i < this.length; i++) {
		_sum += this[i];
	}

	return _sum;
}

Array.prototype.sum = sum;

/**************************************************************************/

function avg() {
	return (this.sum()/this.length);
}

Array.prototype.avg = avg;

/**************************************************************************/

function max() {
	var m = -1;
	if (typeof this[0] == const_number_symbol) {
		m = this[0];
	}
	for (var i = this.length; i > 0; i--) {
		if (typeof this[i] == const_number_symbol) {
			m = Math.max(m, this[i]);
		}
	}
	return m;
}

Array.prototype.max = max;

/**************************************************************************/

function min() {
	var m = -1;
	if (typeof this[0] == const_number_symbol) {
		m = this[0];
	}
	for (var i = this.length; i > 0; i--) {
		if (typeof this[i] == const_number_symbol) {
			m = Math.min(m, this[i]);
		}
	}
	return m;
}

Array.prototype.min = min;

/**************************************************************************/

function iMax() {
	var m = this.max();

	for (var i = 0; i < this.length; i++) {
		if (this[i] == m) {
			return i;
		}
	}
	return -1;
}

Array.prototype.iMax = iMax;

/**************************************************************************/

function iMin() {
	var m = this.min();

	for (var i = 0; i < this.length; i++) {
		if (this[i] == m) {
			return i;
		}
	}
	return -1;
}

Array.prototype.iMin = iMin;

/**************************************************************************/

function cfString() {
	var s = '';
	var b = true;

	for (var i = 0; i < this.length; i++) {
		if (b) {
			s += "'" + this[i] + "'";
			b = false;
		} else {
			s += ', ' + "'" + this[i] + "'";
		}
	}
	return s;
}

Array.prototype.cfString = cfString;

/**************************************************************************/

function keyValFromKey(keyName) {
	var val = -1;
	var aa = [];

	keyName = keyName.trim().toUpperCase();
	for (var i = 0; i < this.length; i++) {
		aa = this[i].toString().split(',');
		if (aa.length == 2) {
			if (aa[0].trim().toUpperCase() == keyName) {
				val = aa[1];
				break;
			}
		}
	}
	return val;
}

Array.prototype.keyValFromKey = keyValFromKey;
