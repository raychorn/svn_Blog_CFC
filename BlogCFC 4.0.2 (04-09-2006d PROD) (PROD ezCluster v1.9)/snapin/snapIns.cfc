<cfcomponent displayname="snapIns">

	<cfscript>
		this.HEX = "0123456789ABCDEF";
		this.hexMask = BitSHLN(255, 24);  // FF000000
	</cfscript>

	<cffunction name="cf_directory" access="public" returntype="boolean">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_path_" type="string" required="yes">
		<cfargument name="_filter_" type="string" required="yes">
		<cfargument name="_recurse_" type="boolean" default="False">
	
		<cfset Request.directoryError = "False">
		<cfset Request.directoryErrorMsg = "">
		<cfset Request.directoryFullErrorMsg = "">
		<cftry>
			<cfif (_recurse_)>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#" recurse="Yes">
			<cfelse>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#">
			</cfif>

			<cfcatch type="Any">
				<cfset Request.directoryError = "True">

				<cfsavecontent variable="Request.directoryErrorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="Request.directoryFullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch" expand="Yes">
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
		<cfreturn Request.directoryError>
	</cffunction>
	
	<cfscript>
		function num2Hex(n) {
			var i = -1;
			var hx = '';
			var mask = this.hexMask;
			var masked = 0;
			var shiftVal = 24;
			
			for (i = 1; i lte 4; i = i + 1) {
				masked = BitSHRN(BitAnd(n, mask), shiftVal);
				if (masked gt 0) {
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(BitSHRN(masked, 4), 15) + 1, 1)) + 16);
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(masked, 15) + 1, 1)) + 16);
				}
				mask = BitSHRN(mask, 8);
				shiftVal = shiftVal - 8;
			}
			
			return Chr(Asc(Len(hx)) + 32) & hx;
		}
		
		function hex2num(h) {
			var i = -1;
			var n = -1;
			var x = -1;
			var ch = -1;
			var num = 0;
			
			n = Len(h);
			for (i = 1; i lte n; i = i + 1) {
				if (i gt 1) num = BitSHLN(num, 4);
				ch = Mid(h, i, 1);
				x = (Asc(ch) - 16) - Asc('0');
				if (x gt 9) {
					x = x - 7;
				}
				num = num + x;
			}
			return num;
		}
		
		function encodedEncryptedString(plainText) {
			var theKey = generateSecretKey(Request.const_encryption_method);
			var _encrypted = encrypt(plainText, theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			return num2Hex(Len(theKey)) & theKey & num2Hex(Len(_encrypted)) & _encrypted;
		}

		function computeChkSum(s) {
			var i = -1;
			var chkSum = 0;
			var n = Len(s);

			for (i = 1; i lte n; i = i + 1) {
				chkSum = chkSum + Asc(Mid(s, i, 1));
			}
			return chkSum;
		}
		
		function encodedEncryptedString2(plainText) {
			var enc = encodedEncryptedString(plainText);
			var h_chkSum = 0;
			
			h_chkSum = num2Hex(computeChkSum(enc));
			return num2Hex(Len(h_chkSum)) & h_chkSum & enc;
		}

		function decodeEncodedEncryptedString(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.keyLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data.theKey = Mid(eStr, i, data.keyLen);
			i = i + data.keyLen;
			data.isKeyValid = (Len(data.theKey) eq data.keyLen);
			data.i = i;

			data.encHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.encLen = hex2num(Mid(eStr, i, data.encHexLen));
			i = i + data.encHexLen;
			data.encrypted = Mid(eStr, i, data.encLen);
			i = i + data.encLen;
			data.isEncValid = (Len(data.encrypted) eq data.encLen);
			data.i = i - 1;

			data.iLen = Len(eStr);
			data.iValid = (data.i eq data.iLen);
			
			data.error = '';
			data.plaintext = '';
			try {
				data.plaintext = Decrypt(data.encrypted, data.theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			} catch (Any e) {
				data.error = 'ERROR - cannot decrypt your encrypted data. ' & '[' & explainError(e, false) & ']' & ', [const_encryption_method=#Request.const_encryption_method#]' & ', [const_encryption_encoding=#Request.const_encryption_encoding#]';
			}

			return data;
		}

		function decodeEncodedEncryptedString2(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.chkSumLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data._chkSumHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data._chkSumHex = Mid(eStr, i, data._chkSumHexLen);
			i = i + data._chkSumHexLen;
			data._chkSum = hex2num(data._chkSumHex);
			data.enc = Mid(eStr, i, Len(eStr) - i + 1);
			data.chkSum = computeChkSum(data.enc);
			data.isChkSumValid = (data._chkSum eq data.chkSum);
			data.data = decodeEncodedEncryptedString(data.enc);
			return data;
		}

		function explainQueryObject(qO) {
			var r = -1;
			var c = -1;
			var aCols = -1;
			var nCols = -1;
			var _db = '';
			_db = _db & 'recordCount = [#qO.recordCount#]';
			_db = _db & ', columnList = [#qO.columnList#]';
			aCols = ListToArray(qO.columnList, ',');
			nCols = ArrayLen(aCols);
			for (r = 1; r lte qO.recordCount; r = r + 1) {
				_db = _db & '[';
				for (c = 1; c lte nCols; c = c + 1) {
					_db = _db & aCols[c] & '(#r#)=[' & qO[aCols[c]][r] & ']';
					if (c lt nCols) {
						_db = _db & ', ';
					}
				}
				_db = _db & ']';
				if (r lt qO.recordCount) {
					_db = _db & ', ';
				}
			}
			return _db;
		}
		
		function objectForType(objType) {
			var anObj = -1;
			var bool_isError = false;
			var bool_isError2 = false;
			var dotPath = objType;
			var _sql_statement = '';
			var thePath = '';

			bool_isError = cf_directory('Request.qqDir', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), objType & '.cfc', true);
			if (NOT bool_isError) {
				bool_isError2 = cf_directory('Request.qqDir2', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), 'snapIns.cfc', true);
				try {
					thePath = Trim(ReplaceNoCase(ReplaceNoCase(Request.qqDir.DIRECTORY, Request.qqDir2.DIRECTORY, ''), '\', '.'));
				} catch (Any e) {
				}
			}

			if (Len(thePath) gt 0) {
				thePath = thePath & '.';
			}
			dotPath = thePath & dotPath;
			if (Left(dotPath, 1) eq '.') {
				dotPath = Right(dotPath, Len(dotPath) - 1);
			}

			Request.err_objectFactory = false;
			Request.err_objectFactoryMsg = '';
			try {
			   anObj = CreateObject("component", dotPath).init();
			} catch(Any e) {
				Request.err_objectFactory = true;
				Request.err_objectFactoryMsg = 'The object factory was unable to create the object for type "#objType#".';
				writeOutput('<font color="red"><b>#Request.err_objectFactoryMsg# [dotPath=#dotPath#], [thePath=#thePath#], [bool_isError=#bool_isError#], [bool_isError2=#bool_isError2#]</b></font>');
				if (Request.bool_isDebugUser) {
					writeOutput(Request.commonCode.cf_dump(e, 'ColdFusion Error', false));
					writeOutput(Request.commonCode.cf_dump(Request.qqDir, 'Request.qqDir', false));
					writeOutput(Request.commonCode.cf_dump(Request.qqDir2, 'Request.qqDir2', false));
				}
			}
			return anObj;
		}

		function html_nocache() {
			var _html = '';
			var const_Cr = Chr(13);
			var LastModified = DateFormat(Now(), "dd mmm yyyy") & " " & TimeFormat(Now(), "hh:mm:ss") & " GMT-5";
			
			cfm_nocache(LastModified);
			
			_html = _html & '<META HTTP-EQUIV="Pragma" CONTENT="no-cache">' & const_Cr;
			_html = _html & '<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">' & const_Cr;
			_html = _html & '<META HTTP-EQUIV="Last-Modified" CONTENT="#LastModified#">' & const_Cr;
			_html = _html & '<META HTTP-EQUIV="Expires" CONTENT="Mon, 26 Jul 1997 05:00:00 EST">' & const_Cr;
	
			return _html;
		}

		function init(snapInsStruct) {
			var i = -1;
			var thePath = '';
		//	var _db = '';
			var basePath = ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\');
			var bool_isError = cf_directory('Request.qDir', basePath, '*.cfc', true);
			if (NOT bool_isError) {
				bool_isError = cf_directory('Request.qDir2', basePath, 'snapIns.cfc', true);
				if (NOT bool_isError) {
					bool_isError = cf_directory('Request.qDir3', Trim(Request.qDir2.DIRECTORY), '*.cfc', true);
					if (NOT bool_isError) {
						thePath = Trim(Request.qDir3.DIRECTORY);
						for (i = 1; i lte Request.qDir3.recordCount; i = i + 1) {
						//	_db = _db & ', Request.qDir3.NAME[#i#] = [#Request.qDir3.NAME[i]#], Request.qDir2.NAME = [#Request.qDir2.NAME#] (#(UCASE(Request.qDir3.NAME[i]) neq UCASE(Request.qDir2.NAME))#)|';
							if (UCASE(Request.qDir3.NAME[i]) neq UCASE(Request.qDir2.NAME)) {
								snapInsStruct.count = snapInsStruct.count + 1;
								snapInsStruct.snapInsName[snapInsStruct.count] = ReplaceNoCase(Request.qDir3.NAME[i], '.cfc', '');
								snapInsStruct.snapIns[snapInsStruct.count] = objectForType(snapInsStruct.snapInsName[snapInsStruct.count]);
							}
						}
					//	Request.debug_text = 'INFO: thePath = [#thePath#], [#_db#], bool_isError = [#bool_isError#], Request.qDir.recordCount = [#Request.qDir.recordCount#], Request.qDir2.recordCount = [#Request.qDir2.recordCount#], basePath = [#basePath#], ' & explainQueryObject(Request.qDir) & ', ' & explainQueryObject(Request.qDir2) & ', ' & explainQueryObject(Request.qDir3);
					} else {
						Request.debug_text = 'ERROR: Request.directoryErrorMsg = [#Request.directoryErrorMsg#]';
					}
				} else {
					Request.debug_text = 'ERROR: Request.directoryErrorMsg = [#Request.directoryErrorMsg#]';
				}
			} else {
				Request.debug_text = 'ERROR: Request.directoryErrorMsg = [#Request.directoryErrorMsg#]';
			}

			return this;
		}
	</cfscript>

	<cffunction name="cfm_nocache" access="public" returntype="string">
		<cfargument name="LastModified" type="string" required="yes">

		<CFSETTING ENABLECFOUTPUTONLY="YES">
		<CFHEADER NAME="Pragma" VALUE="no-cache">
		<CFHEADER NAME="Cache-Control" VALUE="no-cache, must-revalidate">
		<CFHEADER NAME="Last-Modified" VALUE="#LastModified#">
		<CFHEADER NAME="Expires" VALUE="Mon, 26 Jul 1997 05:00:00 EST">
		<CFSETTING ENABLECFOUTPUTONLY="NO">
		
		<cfreturn "True">
	</cffunction>
</cfcomponent>
