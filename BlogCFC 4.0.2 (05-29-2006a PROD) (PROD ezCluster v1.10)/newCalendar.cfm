<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_tPath" type="string" default="">
<cfparam name="_folder" type="string" default="">

<cfoutput>
	<html>
	<head>
		#Request.commonCode.html_nocache()#
		<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />

		<cfset Request.jsCodeObfuscationIndex = 1>
		<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
		<cfsavecontent variable="_jscode">
			<cfoutput>
				#Request.commonCode.readAndObfuscateJSCode('js/433511201010924803.dat')#
				#Request.commonCode.readAndObfuscateJSCode('js/decontextmenu.js')#
			</cfoutput>
		</cfsavecontent>

		<script language="JavaScript1.2" type="text/javascript">
			var xx$ = "#URLEncodedFormat(_jscode)#";
		</script>
	
		<script language="JavaScript1.2" type="text/javascript">
			if (!!xx$) { eval(unescape(xx$)) };
		</script>

		<script language="JavaScript1.2" type="text/javascript">
			<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
				#Request.jsCodeObfuscationDecoderAR[_i]#
			</cfloop>
		</script>
	</head>

	<body>

	<cfinclude template="includes/pods/calendar.cfm">
	
	</body>
	</html>
</cfoutput>

