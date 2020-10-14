<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>

	<cfoutput>
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
	</cfoutput>

</head>

<body>

<cfoutput>

	<cfset _url = ListFirst(CGI.SCRIPT_NAME, "/") & "/_index.cfm">
	<cfset _url = Request.commonCode.clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#_url#')>
	<cfif (Len(CGI.QUERY_STRING) gt 0)>
		<cfif (Find("?", _url) gt 0)>
			<cfset _url = _url & "&" & CGI.QUERY_STRING>
		<cfelse>
			<cfset _url = _url & "?" & CGI.QUERY_STRING>
		</cfif>
	</cfif>
	
	<cfif (CGI.SERVER_NAME IS "laptop.halsmalltalker.com") AND (Len(CGI.HTTP_REFERER) eq 0)>
		<cfif 1>
			<iframe frameborder="0" height="100%" width="100%" scrolling="Auto" src="#_url#"></iframe>
		<cfelse>
			<small style="font-size: 10px; color: blue;">_url = [#_url#]</small><br>
		</cfif>
	<cfelse>
		<cflocation url="#_url#" addtoken="No">
	</cfif>

</cfoutput>

</body>
</html>
