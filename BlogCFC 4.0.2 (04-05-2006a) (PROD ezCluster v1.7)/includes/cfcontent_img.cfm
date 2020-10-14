<cfif (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.imageName")) AND (Len(URL.imageName) gt 0)>
		<cfscript>
			imageName = ExpandPath(URL.imageName);
			writeOutput(Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now()))));
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

