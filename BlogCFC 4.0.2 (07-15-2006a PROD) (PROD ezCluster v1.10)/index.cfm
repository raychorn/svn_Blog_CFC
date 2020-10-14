<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>

	<cfset Request.jsCodeObfuscationIndex = 1>
	<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
	<cfsavecontent variable="_jscode">
		<cfoutput>
			#Request.commonCode.readAndObfuscateJSCode('js/433511201010924803.dat')#
			#Request.commonCode.readAndObfuscateJSCode('js/decontextmenu.js')#
		</cfoutput>
	</cfsavecontent>

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
			var isSiteHavingProblems = 0; 
			var xx$ = "#URLEncodedFormat(_jscode)#";
		</script>
	</cfoutput>

	<script language="JavaScript1.2" type="text/javascript">
		if (!!xx$) { eval(unescape(xx$)) };
	</script>

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
			<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
				#Request.jsCodeObfuscationDecoderAR[_i]#
			</cfloop>
		</script>
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
			<iframe frameborder="0" height="100%" width="99.9%" scrolling="Auto" src="#_url#"></iframe>
		<cfelse>
			<small style="font-size: 10px; color: blue;">_url = [#_url#]</small><br>
		</cfif>
	<cfelse>
		<cflocation url="#_url#" addtoken="No">
	</cfif>

</cfoutput>

</body>
</html>
