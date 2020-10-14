<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfoutput>
	<html>
	<head>
		<title>SSL Login</title>
	</head>
	
	<body>
	
		<cfif (isDebugMode())>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="center" valign="top">
						<cfdump var="#Application#" label="App Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#Session#" label="Session Scope [#Session.sessID#]" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#Request#" label="Request Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#CGI#" label="CGI Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#FORM#" label="FORM Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#URL#" label="URL Scope" expand="No">
					</td>
				</tr>
			</table>
		</cfif>
	
		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
		<cfif (IsDefined("FORM.redirectURL")) AND (Len(Trim(FORM.redirectURL)) gt 0)>
			<cfset _url = FORM.redirectURL>
		</cfif>
	
		<cfscript>
			Request.commonCode.commitSessionToDb();
		</cfscript>
		
		<cflocation url="#_url#" addtoken="No">
	
	</body>
	</html>

</cfoutput>
