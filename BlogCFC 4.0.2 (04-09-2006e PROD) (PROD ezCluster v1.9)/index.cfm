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
	<cflocation url="#Request.commonCode.makeLinkToSelf('_index.cfm', false)#" addtoken="No">
</cfoutput>

</body>
</html>
