<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.imageName")) AND (Len(URL.imageName) gt 0)>
		<cfscript>
			imageName = ExpandPath(URL.imageName);
			Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now())));
		</cfscript>
		<cfset _type = "">
		<cfif (FindNoCase(".jpg", URL.imageName) gt 0)>
			<cfset _type = "image/jpeg">
		<cfelseif (FindNoCase(".gif", URL.imageName) gt 0)>
			<cfset _type = "image/gif">
		</cfif>
		<cfscript>
			Request.commonCode.cf_file_read_binary(imageName, 'Request.cfcontent_img');
		</cfscript>
		<cfcontent type="_type" variable="#ToBinary(ToBase64(Request.cfcontent_img))#">
	</cfif>
</cfif>

