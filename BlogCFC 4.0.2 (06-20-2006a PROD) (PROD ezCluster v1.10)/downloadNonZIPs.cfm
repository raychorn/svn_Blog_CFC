<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="fileURL" type="string" default="">

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

	<cfif (Len(fileURL) gt 0)>
		<iframe frameborder="0" height="100%" width="100%" scrolling="Auto" src="#fileURL#"></iframe>
	</cfif>

</cfoutput>

</body>
</html>
