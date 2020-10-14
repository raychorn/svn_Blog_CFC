<cfsetting enablecfoutputonly="Yes">
<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0)>
		<cfscript>
			jsName = ExpandPath(URL.jsName);
			Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now())));
		</cfscript>
		<cfif (FileExists(jsName))>
			<cffile action="READ" file="#jsName#" variable="_jsCode">
			<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(_jsCode))#">
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	</cfif>
</cfif>

