/**************************************************************************/

function caselessIndexOfAll(s) {
	var _f = 0;
	var _fr = 0;
	var a = [];
	var sl = s.trim().length;
	var st = this.trim().length;
	while ((_f = this.trim().toUpperCase().indexOf(s.trim().toUpperCase(), _fr)) != -1) {
		a.push(_f);
		_fr += _f + sl;
		if (_fr >= st) {
			break;
		}
	}
	return a;
}

String.prototype.caselessIndexOfAll = caselessIndexOfAll;

/**************************************************************************/

function keywordSearchCaseless(kw) {
	var const_begin_tag_symbol = '<';
	var const_end_tag_symbol = '>';
	var const_begin_literal_symbol = '&';
	var const_end_literal_symbol = ';';

	var _debug_output = '';

	function gobbleUpCharsUntil(e_ch, _s) {
		var _ch = '';
		for (; i < _s.length; i++) {
			_ch = _s.substr(i, 1); // charAt(i);
			if (_ch == e_ch) {
				i++;
				_ch = _s.substr(i, 1); // charAt(i);
				break;
			}
		}
		return _ch;
	}

	var _s = this.trim().stripHTML().trim();
	var _hasHTMLtags = this.trim().length != _s.length;
	var _kw = kw.trim().stripHTML().trim().toUpperCase();
	var _f = _s.toUpperCase().indexOf(_kw);
	if ( (_f != -1) && (_hasHTMLtags) ) {
		// found something - try to map it back into the HTML...
		// (1). scan thru this breaking apart words based on where the words fall relative to HTML tags.
		var _ch = '';
		var _word = '';
		var _words_array = [];
		_ch = this.substr(i, 1); // charAt(i);
		for (var i = 0; i < this.length; i++) {
			if (_ch == const_begin_tag_symbol) {
				// gobble-up chars until we reach the end tag symbol
				_ch = gobbleUpCharsUntil(const_end_tag_symbol, this);
			}
			if (_ch == const_begin_literal_symbol) {
				// gobble-up chars until we reach the end literal symbol
				_ch = gobbleUpCharsUntil(const_end_literal_symbol, this);
			}
			// now _ch should be at a char not within an HTML'ish tag or literal...
			// now collect chars until we encounter another HTML'ish symbol be it tag or literal...
			if ( (_ch != const_begin_tag_symbol) && (_ch != const_begin_literal_symbol) ) {
				_word = '';
				for (; i < this.length; i++) {
					_ch = this.substr(i, 1); // charAt(i);
					if ( (_ch == const_begin_tag_symbol) || (_ch == const_begin_literal_symbol) ) {
						break;
					}
					_word += _ch;
				}
				if (_word.trim().length > 0) {
					// store the word in the array along with the index for the word...
					a = [];
					a.push(_word);
					a.push(i - _word.length);
					_words_array.push(a);
				}
			}
			_ch = this.substr(i, 1); // charAt(i);
		}
		if (_words_array.length > 0) {
			// we found some words so now we search the _words_array for the keyword...
			var a = [];
			for (i = 0; i < _words_array.length; i++) {
				a = _words_array[i];
				_s = a[0];
				var _ff = _s.toUpperCase().indexOf(_kw);
				if (_ff != -1) {
					// found the keyword...
					var o_f = _f;
					_f = a[1] + _ff;
					break;
				}
			}
		}
	} else if (_hasHTMLtags == false) {
		// there are no HTML tags to account for so just do the silly search...
		var _f = this.toUpperCase().indexOf(kw.toUpperCase());
	}
	return _f;
}

String.prototype.keywordSearchCaseless = keywordSearchCaseless;

/**************************************************************************/

function countCrs() {
	var cnt = 0;
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1); // charAt(i);
		if (_ch == '\n') {
			cnt++;
		}
	}
	return cnt;
}

String.prototype.countCrs = countCrs;

/**************************************************************************/

function countCrLfs() {
	var cnt = 0;
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1); // charAt(i);
		if ( (_ch == '\n') || (_ch == '\r') ) {
			cnt++;
		}
	}
	return cnt;
}

String.prototype.countCrLfs = countCrLfs;

/**************************************************************************/

function stripHTML() {
	var s = null;
	s = this.replace(/(<([^>]+)>)/ig,""); // trim everything that's between < and >
	s = s.replace(/(&([^;]+);)/ig,""); // trim everything that's between & and ;
	return s;
}

String.prototype.stripHTML = stripHTML;

/**************************************************************************/

function stripTickMarks() {
	return this.replace(/\'/ig, "");
}

String.prototype.stripTickMarks = stripTickMarks;

/**************************************************************************/

function replaceTickMarksWith(ch) {
	return this.replace(/\'/ig, ch);
}

String.prototype.replaceTickMarksWith = replaceTickMarksWith;

/**************************************************************************/

function stripIllegalChars() {
	return escape(this); // .replace(/,/ig, "").replace(/\|/ig, "");
}

String.prototype.stripIllegalChars = stripIllegalChars;

/**************************************************************************/

function _URLEncode() {
	return escape(this);
}

String.prototype.URLEncode = _URLEncode;

/**************************************************************************/

function _URLDecode() {
	return unescape(this);
}

String.prototype.URLDecode = _URLDecode;

/**************************************************************************/

function stripCrLfs() {
	return this.replace(/\n/ig, "").replace(/\r/ig, "");
}

String.prototype.stripCrLfs = stripCrLfs;

/**************************************************************************/

function replaceSubString(i, j, s) {
	var s = this.substring(0, i) + s + this.substring(j, this.length);
	return s;
}

String.prototype.replaceSubString = replaceSubString;

/**************************************************************************/

function clipCaselessReplace(keyword, sText) {
	var _ff = this.toUpperCase().indexOf(keyword.toUpperCase());
	if (_ff != -1) {
		return this.replaceSubString(_ff, _ff + keyword.length, sText);
	}

	return this;
}

String.prototype.clipCaselessReplace = clipCaselessReplace;

/**************************************************************************/

function trim() {  
 	var s = null;
	// trim white space from the left  
	s = this.replace(/^[\s]+/,"");  
	// trim white space from the right  
	s = s.replace(/[\s]+$/,"");  
	return s;
}

function triml() {  
	// trim white space from the left   
	return this.replace(/^[\s]+/,"");
}

function trimr() {  
	// trim white space from the right  
	return this.replace(/[\s]+$/,"");
}

String.prototype.trim = trim;
String.prototype.triml = triml;
String.prototype.trimr = trimr;

/**************************************************************************/

function mungeIntoSymbol() {
	var _symbol = "";

	for (var i = 0; i < this.length; i++) {
		var ch = this.substring(i, i + 1);
		if ( (ch >= "0") && (ch <= "z") ) {
			_symbol += ch;
		} else {
			_symbol += "_";
		}
	}

	return _symbol;
}

String.prototype.mungeIntoSymbol = mungeIntoSymbol;
 
/**************************************************************************/

function replaceDelims(d1, d2) {
	var a = this.split(d1);
	var s_new = a.join(d2);

	return s_new;
}

String.prototype.replaceDelims = replaceDelims;
