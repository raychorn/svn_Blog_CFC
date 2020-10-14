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
		var _ignoreList = '<remoteAddress>, <browser>, <dateTime>, <HTTPReferer>, <diagnostics>, <TagContext>';
		var _specialList = '<StackTrace>';
		var content_specialList = '';
		var aToken = '';
		var special_templatesList = ''; // comma-delimited list or template keywords

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
					if (0) {
						v = '--- UNKNOWN --';
						vn = "_error." & e;
		
						if (IsDefined(vn)) {
							v = Evaluate(vn);
						}
					} else {
						v = _error[e];
					}
				} catch (Any ee) {
					v = '--- ERROR --';
				}

				if (FindNoCase('<#e#>', _specialList) neq 0) {
					if (NOT bool_asHTML) {
						content_specialList = content_specialList & '#e#=#v#, ';
					} else {
						v = '<textarea cols="100" rows="20" readonly style="font-size: 10px;">#v#</textarea>';
						content_specialList = content_specialList & '<li><b>#e#</b>&nbsp;#v#</li>';
					}
				} else if (IsSimpleValue(v)) {
					if (NOT bool_asHTML) {
						_content = _content & '#e#=#v#,';
					} else {
						_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
					}
				}
			}
		}
		if (bool_includeStackTrace) {
			nTagStack = ArrayLen(_error.TAGCONTEXT);
			if (NOT bool_asHTML) {
				_content = _content &	'The contents of the tag stack are: nTagStack = [#nTagStack#], ';
			} else {
				_content = _content &	'<li><p><b>The contents of the tag stack are: nTagStack = [#nTagStack#] </b>';
			}
			if (nTagStack gt 0) {
				for (i = 1; i neq nTagStack; i = i + 1) {
					bool_isError = false;
					try {
						sCurrent = _error.TAGCONTEXT[i];
					} catch (Any e2) {
						bool_isError = true;
						break;
					}
					if (NOT bool_isError) {
						sMiscList = '';
						for (sMisc in sCurrent) {
							if (NOT bool_asHTML) {
								sMiscList = ListAppend(sMiscList, ' [#sMisc#=#sCurrent[sMisc]#] ', ' | ');
							} else {
								sMiscList = sMiscList & '<b><small>[#sMisc#=#sCurrent[sMisc]#]</small></b><br>';
							}
						}
						if (NOT bool_asHTML) {
							_content = _content & sMiscList & '.';
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
				_content = _content & ',';
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
