<cfscript>
	function _explainError(_error, bool_asHTML, bool_includeStackTrace) {
		var e = '';
		var v = '';
		var vn = '';
		var i = -1;
		var k = -1;
		var bool_isError = false;
		var sCurrent = -1;
		var sId = -1;
		var sLine = -1;
		var sColumn = -1;
		var sTemplate = -1;
		var nTagStack = -1;
		var sMisc = '';
		var sMiscList = '';
		var _content = '<ul>';
		var _ignoreList = '<remoteAddress>,<browser>,<dateTime>,<HTTPReferer>,<diagnostics>,<TagContext>';
		var _StackTraceSymbol = '<StackTrace>';
		var content_specialList = '';
		var aToken = '';

		if (NOT IsBoolean(bool_asHTML)) {
			bool_asHTML = false;
		}
		
		if (NOT IsBoolean(bool_includeStackTrace)) {
			bool_includeStackTrace = false;
		}
		
		if (NOT bool_asHTML) {
			_content = '';
		}

		for (e in _error) {
			if (FindNoCase('<#e#>', _ignoreList) eq 0) {
				try {
					v = _error[e];
				} catch (Any ee) {
					v = '--- ERROR --';
				}

				if (FindNoCase('<#e#>', _StackTraceSymbol) neq 0) {
					if (NOT bool_asHTML) {
						content_specialList = content_specialList & '#e#=#v#, ' & Chr(13);
					} else {
						v = '<textarea cols="160" rows="10" readonly style="font-size: 10px; color: red;">#v#</textarea>';
						content_specialList = content_specialList & '<li style="font-size: 10px; color: red;"><b>#e#</b>&nbsp;#v#</li>';
					}
				} else if (IsSimpleValue(v)) {
					if (NOT bool_asHTML) {
						_content = _content & '#e#=#v#,' & Chr(13);
					} else {
						_content = _content & '<li style="font-size: 10px; color: red;"><b>#e#</b>&nbsp;#v#</li>';
					}
				} else {
					try {
						if (NOT bool_asHTML) {
							if (NOT IsObject(v)) {
								_content = _content & '#e#=#_explainError(v, bool_asHTML, bool_includeStackTrace)#,' & Chr(13);
							} else {
								_content = _content & '#e#=-- OBJECT --,' & Chr(13);
							}
						} else {
							if (NOT IsObject(v)) {
								_content = _content & '<li style="font-size: 10px; color: red;"><b>#e#</b>&nbsp;#_explainError(v, bool_asHTML, bool_includeStackTrace)#</li>';
							} else {
								_content = _content & '<li style="font-size: 10px; color: red;"><b>#e#</b>&nbsp;-- OBJECT --</li>';
							}
						}
					} catch (Any e2) {
					}
				}
			}
		}
		if (bool_includeStackTrace) {
			nTagStack = ArrayLen(_error.TAGCONTEXT);
			if (NOT bool_asHTML) {
				_content = _content &	'The contents of the tag stack are: nTagStack = [#nTagStack#], ' & Chr(13);
			} else {
				_content = _content &	'<li><p style="font-size: 10px; color: red;"><b>The contents of the tag stack are: nTagStack = [#nTagStack#] </b>';
			}
			if (nTagStack gt 0) {
				for (i = 1; i neq nTagStack; i = i + 1) {
					bool_isError = false;
					try {
						sCurrent = _error.TAGCONTEXT[i];
					} catch (Any e2) {
						bool_isError = true;
					}
					if (NOT bool_isError) {
						sMiscList = '';
						for (sMisc in sCurrent) {
							if (NOT bool_asHTML) {
								sMiscList = ListAppend(sMiscList, ' [#sMisc#=#sCurrent[sMisc]#] ', ' | ') & Chr(13);
							} else {
								sMiscList = sMiscList & '<b><small>[#sMisc#=#sCurrent[sMisc]#]</small></b><br>';
							}
						}
						if (NOT bool_asHTML) {
							_content = _content & sMiscList & '.' & Chr(13);
						} else {
							_content = _content & '<br>' & sMiscList & '.';
						}
					}
				}
			}
			if (bool_asHTML) {
				_content = _content & '</p></li>';
			}
			_content = _content & content_specialList;
			if (bool_asHTML) {
				_content = _content & '</ul>';
			} else {
				_content = _content & ',' & Chr(13);
			}
		}
		
		return _content;
	}

	function explainError(_error, bool_asHTML) {
		return _explainError(_error, bool_asHTML, false);
	}

	function explainErrorWithStack(_error, bool_asHTML) {
		return _explainError(_error, bool_asHTML, true);
	}
</cfscript>
