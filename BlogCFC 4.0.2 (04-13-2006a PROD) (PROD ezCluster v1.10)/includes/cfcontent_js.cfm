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
		</cfscript>
		<cfif (FileExists(jsName))>
			<cfoutput>
				<CFHEADER NAME="Last-Modified" VALUE="#GetHttpTimeString(DateAdd("yyyy", -50, Now()))#">
				<CFHEADER NAME="Expires" VALUE="Mon, 26 Jul 1997 05:00:00 EST">
				<cfcontent type="text/javascript" file="#jsName#">
			</cfoutput>
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	</cfif>
</cfif>

