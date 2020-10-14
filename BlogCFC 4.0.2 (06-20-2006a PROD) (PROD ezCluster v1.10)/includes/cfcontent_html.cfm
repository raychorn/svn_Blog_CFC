<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfscript>
	writeOutput('(IsDefined("URL._sessid")) = [#(IsDefined("URL._sessid"))#] (#URL._sessid#) (#(IsDefined("Session.sessid"))#) [#Session.sessid#] (#(URL._sessid IS Session.sessid)#)<br>');
</cfscript>

<cfif (IsDefined("URL._sessid")) AND (IsDefined("Session.sessid")) AND (URL._sessid IS Session.sessid) AND (IsDefined("URL.href")) AND (Len(URL.href) gt 0)>
	<cfscript>
		_http = Request.commonCode.cf_http(URL.href);
		bool_isURL_valid = (Trim(_http.Statuscode) IS "200 OK");
		
		writeOutput('[#bool_isURL_valid#] (#Len(_http.fileContent)#)<br>');
	</cfscript>
	<cfif (bool_isURL_valid) AND 0>
		<cfoutput>
			<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
			<CFHEADER NAME="Pragma" VALUE="no-cache">
			<CFHEADER NAME="cache-control" VALUE="no-cache">
			<cfcontent type="text/html" variable="#_http.fileContent#">
		</cfoutput>
	<cfelse>
		<cflog file="#Application.applicationName#" type="ERROR" text="[URL.href=#URL.href#] File is Invalid or Missing. (#_http.Statuscode#)">
	</cfif>
</cfif>

