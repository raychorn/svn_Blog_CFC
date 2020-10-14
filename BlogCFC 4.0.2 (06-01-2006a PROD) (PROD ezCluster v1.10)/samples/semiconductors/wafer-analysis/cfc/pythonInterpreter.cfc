<cfcomponent extends="kla-tencore.AJAX.cfc.ajaxCode" displayname="pythonInterpreter" output="No">
	<cfscript>
		this.vars = StructNew();
		this.vars.aPathName = '';
		this.theCode = '';
		this.vars.statusMsg = '';
		this.vars.linesOfCodeOriginal = ArrayNew(1);
		this.vars.linesOfCode = ArrayNew(1);
		this.const_begin_discard_token = '## ------------------------ LOAD IMPORTS  -----------------------------------------';
		this.const_end_discard_token = '##TAKE IMAGES OF TARGETS';
		this.pythonVars = StructNew();
		this.ignoreTokensList = 'mtc.moveStage,TimerUtil.sleep,WaferRectangle,waferRectangles,imageCollector.setupForImages,GetImage,WaferPosition';
		this.replaceTokensList = 'imagefilename';
		
		function linesOfCodeAsHTML() {
			var i = -1;
			var n = -1;
			var _html = '';

			_html = _html & '<table width="100%" bgcolor="##BFFFFF" cellpadding="-1" cellspacing="-1">';
			_html = _html & '<tr>';
			_html = _html & '<td>';
			_html = _html & '<OL class="textClass">';
			
			n = ArrayLen(this.vars.linesOfCode);
			for (i = 1; i lte n; i = i + 1) {
				if (Len(Trim(this.vars.linesOfCode[i])) gt 0) {
					_html = _html & '<LI><span class="textClass">#this.vars.linesOfCode[i]#</span></LI>';
				}
			}

			_html = _html & '</OL>';
			_html = _html & '</td>';
			_html = _html & '</tr>';
			_html = _html & '</table>';
			
			return _html;
		}

		function grabUsablePythonCode(ar) {
			var i = -1;
			var n = -1;
			var bool_grabbing = false;
			var newAR = ArrayNew(1);

			n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
				bool_grabbing = (Find(this.const_begin_discard_token, ar[i]) eq 0);
				if (bool_grabbing) {
					newAR[ArrayLen(newAR) + 1] = Trim(ar[i]);
				} else {
					break;
				}
			}
			for (; i lte n; i = i + 1) {
				bool_grabbing = (Find(this.const_end_discard_token, ar[i]) eq 0);
				if (NOT bool_grabbing) {
					break;
				}
			}
			for (; i lte n; i = i + 1) {
				newAR[ArrayLen(newAR) + 1] = Trim(ar[i]);
			}
			return newAR;
		}
		
		function convertUsablePythonCode() {
			var i = -1;
			var n = -1;
			var eqLoc = -1;
			var tAR = -1;
			var bool_isEquals = false;
			var bool_ignoreLOC = false;
			var ar_ignoreTokens = -1;
			var nn = -1;
			var j = -1;
			var bool_replacLOC = false;
			var ar_replaceTokens = -1;

			n = ArrayLen(this.vars.linesOfCode);
			for (i = 1; i lte n; i = i + 1) {
				eqLoc = Find('=', this.vars.linesOfCode[i]);
				bool_isEquals = (eqLoc gt 0);
				if (bool_isEquals) {
					tAR = ListToArray(this.vars.linesOfCode[i], '=');
					if (ArrayLen(tAR) eq 2) {
						this.vars.linesOfCode[i] = 'this.pythonVars.' & Trim(tAR[1]) & '=' & tAR[2] & ';';
					}
				}
			}
			for (i = 1; i lte n; i = i + 1) {
				bool_ignoreLOC = false;
				ar_ignoreTokens = ListToArray(this.ignoreTokensList, ',');
				nn = ArrayLen(ar_ignoreTokens);
				for (j = 1; j lte nn; j = j + 1) {
					bool_ignoreLOC = (Find(ar_ignoreTokens[j], this.vars.linesOfCode[i]) gt 0);
					if (bool_ignoreLOC) {
						this.vars.linesOfCode[i] = '';
						break;
					}
				}
			}
			for (i = 1; i lte n; i = i + 1) {
				bool_replacLOC = false;
				ar_replaceTokens = ListToArray(this.replaceTokensList, ',');
				nn = ArrayLen(ar_replaceTokens);
				for (j = 1; j lte nn; j = j + 1) {
					bool_replaceLOC = (Find(ar_replaceTokens[j], this.vars.linesOfCode[i]) gt 0);
					if (bool_replaceLOC) {
						this.vars.linesOfCode[i] = '\/\/' & this.vars.linesOfCode[i];
						break;
					}
				}
			}
		}
		
		function parsePythonCode(someCode) {
			var i = -1;
			var n = -1;
			var cLocF = -1;
			var cLocL = -1;
			var ar = ListToArray(someCode, Chr(13));
			
			ar = grabUsablePythonCode(ar);
			
			n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
			//	this.vars.linesOfCodeOriginal[ArrayLen(this.vars.linesOfCodeOriginal) + 1] = ar[i];
				cLocF = Find('##', ar[i]);
				cLocL = Find('##', Reverse(ar[i]));
				if (cLocL neq 0) {
					cLocL = Len(ar[i]) - cLocL;
				}
				if (cLocF gt 0) {
					if (cLocL gt 0) {
						if ( (cLocF neq cLocL) AND (cLocL gt cLocF) ) {
							try {
								ar[i] = Mid(ar[i], 1, cLocF - 1) & Mid(ar[i], cLocL + 1, Len(ar[i]) - cLocL - 1);
							} catch (Any e) {
							}
						} else {
							ar[i] = Mid(ar[i], 1, cLocF - 1);
						}
					} else {
						ar[i] = Mid(ar[i], 1, cLocF - 1);
					}
				}
				this.vars.linesOfCode[ArrayLen(this.vars.linesOfCode) + 1] = Trim(ar[i]);
			}
			convertUsablePythonCode();
		}
		
		function init(aPathName) {
			if (FileExists(aPathName)) {
				this.vars.aPathName = aPathName;
				cf_file('READ', this.vars.aPathName, 'this.theCode');
				if (NOT Request.fileError) {
				//	parsePythonCode(this.theCode);
				} else {
					this.vars.statusMsg = Request.errorMsg;
				}
			} else {
				this.vars.statusMsg = 'File (#aPathName#) does not exist.';
			}
			return this;
		}
	</cfscript>
</cfcomponent>
