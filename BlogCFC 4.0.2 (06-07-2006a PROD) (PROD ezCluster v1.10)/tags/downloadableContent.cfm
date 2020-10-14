<cfsetting enablecfoutputonly="Yes">
<!--- downloadableContent.cfm
 --->
<cfif (thisTag.executionMode is "start")>
	<cfoutput>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		
		<html>
		<head>
			#Request.commonCode.html_nocache()#
			<title>cfdump Function #Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
			<meta name="robots" content="index,follow" />
			<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
			<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
		
			<cfset Request.jsCodeObfuscationIndex = 1>
			<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
			<cfsavecontent variable="_jscode">
				<cfoutput>
					#Request.commonCode.readAndObfuscateJSCode('../../../js/433511201010924803.dat')#
					#Request.commonCode.readAndObfuscateJSCode('../../../js/decontextmenu.js')#
				</cfoutput>
			</cfsavecontent>
		
			<script language="JavaScript1.2" type="text/javascript">
				var isSiteHavingProblems = 0; 
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
		
		<div>
		<span class="codeCopyright">#Request.commonCode.standardCopyrightNotice()#</span><br>
	</cfoutput>
<cfelseif (thisTag.executionMode is "end")>
	<cfoutput>
		</div>
		
		</body>
		</html>
	</cfoutput>
</cfif>
