<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>ezCluster &copy; Hierarchical Applications Limited, All Rights Reserved.</title>

	<cfoutput>
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
	</cfoutput>

</head>

<body>

<cfoutput>
	<cfset _url = ListFirst(CGI.SCRIPT_NAME, "/") & "/_index.cfm?" & CGI.QUERY_STRING>
	<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#_url#')>
	<cfif 1>
		<cflocation url="#_url#" addtoken="No">
	<cfelse>
		<small>_url = [#_url#]</small>
	</cfif>
</cfoutput>

</body>
</html>
