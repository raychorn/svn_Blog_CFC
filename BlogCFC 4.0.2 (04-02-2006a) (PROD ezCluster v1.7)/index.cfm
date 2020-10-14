<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>ezCluster &copy; Hierarchical Applications Limited, All Rights Reserved.</title>

	<script language="JavaScript1.2" type="text/javascript">var m$=""; function cIE() { if (document.all) {(m$); return false;} }; function cNS(e) { if (document.layers||(document.getElementById&&!document.all)) {if (e.which==2||e.which==3) { (m$); return false;}}}; if (document.layers) { document.captureEvents(Event.MOUSEDOWN); document.onmousedown=cNS; }	else { document.onmouseup=cNS; document.oncontextmenu=cIE; }; document.oncontextmenu = new Function("return false");</script>

</head>

<body>

<cfoutput>
	<cfscript>
	//	myPrefix = ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
	//	myURL = Request.commonCode._URLSessionFormat(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME##myPrefix#/_index.cfm'), false);
	</cfscript>
	<cfif (Request.bool_isDebugUser) AND 0>
		<cfdump var="#Request.qQ#" label="Request.qQ [#myURL#]" expand="No">
	</cfif>
	<cflocation url="#Request.commonCode.makeLinkToSelf('_index.cfm', false)#" addtoken="No">
</cfoutput>

</body>
</html>
