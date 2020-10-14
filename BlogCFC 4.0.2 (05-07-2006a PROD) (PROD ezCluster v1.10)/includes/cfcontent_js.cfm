<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0)>
		<cflock name="#CGI.SCRIPT_NAME#" timeout="10" type="EXCLUSIVE">
			<cfscript>
				jsName = ExpandPath(URL.jsName);
	
				_jsName = jsName & '$'; // new JavaScript file name - this one is obfuscated...
	
				_aSrcFileDt = -1;
				_aDstFileDt = -1;
				bool_outOfDate = false;
				bool_isError = Request.commonCode.cf_directory('Request.qJsDir', GetDirectoryFromPath(jsName), GetFileFromPath(jsName) & '*', false);
	
				if ( (NOT bool_isError) AND (Request.qJsDir.recordCount gt 0) ) {
					try {
						for (i = 1; i lte Request.qJsDir.recordCount; i = i + 1) {
							if ( (FindNoCase('.js', Request.qJsDir.name[i]) gt 0) AND (NOT IsDate(_aSrcFileDt)) ) {
								_aSrcFileDt = ParseDateTime("#Request.qJsDir.dateLastModified[i]#");
							} else if ( (FindNoCase('.js$', Request.qJsDir.name[i]) gt 0) AND (NOT IsDate(_aDstFileDt)) ) {
								_aDstFileDt = ParseDateTime("#Request.qJsDir.dateLastModified[i]#");
							}
						}
						bool_outOfDate = ( ( (IsDate(_aSrcFileDt)) OR (NOT IsDate(_aDstFileDt)) ) AND (DateCompare(_aSrcFileDt, _aDstFileDt) gt 0) );
					} catch (Any e) {
					}
				}
				
				if ( (FileExists(_jsName)) AND (NOT bool_outOfDate) ) {
					jsName = _jsName;
				} else {
					Request.commonCode.cf_file_read(jsName, 'Request.jsContentsIn');
					if ( (NOT Request.fileError) AND (FindNoCase('.dat', jsName) eq 0) ) {
						Request.jsContentsOut = Request.commonCode.enkrip2(Request.commonCode.jsMinifier(Request.jsContentsIn));
						Request.jsContentsOut = '/* (c). Copyright 1990 - #Year(Now())#, Hierarchical Applications Limited, All Rights Reserved. The contents of this file may NOT be used by anyone without specific written permission of the owners of this site and the authors of these materials. */ ' & Request.jsContentsOut.ciphertext & ' ' & Request.jsContentsOut.decipher & ' ' & Request.jsContentsOut.decipherNow;
						Request.commonCode.cf_file_write(_jsName, Request.jsContentsOut);
						if (NOT Request.fileError) {
							jsName = _jsName;
						}
					}
				}
			</cfscript>
		</cflock>

		<cfif (FileExists(jsName))>
			<cfoutput>
				<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
				<CFHEADER NAME="Pragma" VALUE="no-cache">
				<CFHEADER NAME="cache-control" VALUE="no-cache">
				<cfcontent type="text/javascript" file="#jsName#">
			</cfoutput>
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	</cfif>
</cfif>

