<cfprocessingdirective pageencoding="utf-8">

<cfparam name="filename" type="string" default="">

<cfif (Len(filename) gt 0)>
	<cfset filename = URLDecode(filename)>
</cfif>

<cfset filename = ReplaceNoCase(filename, "/downloads/", "/downloads#Request.folder_mask#/")>

<cfset _filename = ReplaceNoCase(filename, "/downloads#Request.folder_mask#/", "/downloads/")>

<cfsavecontent variable="downloadContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("download")#</div>
	<div class="body">
		<h5 align="center" style="color: blue;">Downloading... (<a href="#_filename#" target="_blank">#_filename#</a>)</h5>
		<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
		<a href="#_filename#" target="_blank">Click HERE to Download in case your requested file does not begin to download automatically...</a>
		<br><br><br><br>
		<a href="#_mainURL#">Click HERE to continue...</a>
	</div>
	<cfif ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) )>
		<cfif (FindNoCase(".ZIP", filename) gt 0)>
			<form name="myForm" action="#filename#" method="get" target="_blank">
				<input type="Submit" name="btn_submit" value="[Download]" style="display: none;">
			</form>
			<script language="JavaScript1.2" type="text/javascript">
				document.myForm.submit();
			</script>
		<cfelse>
			<script language="JavaScript1.2" type="text/javascript">
				downloadWin = window.open('#filename#',"download", "width=800,height=600,resizeable=yes,scrollbars=1");
			</script>
		</cfif>
	</cfif>
	</cfoutput>

</cfsavecontent>

<cfif (NOT isDefined("hideLayout")) AND (Len(CGI.HTTP_REFERER) gt 0)>

	<cfmodule template="tags/layout.cfm">
		<cfoutput>#downloadContent#</cfoutput>
	</cfmodule>
	
<cfelse>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<cfoutput>
	<html>
	<head>
		#application.snapIns.rootSnapIn.html_nocache()#
		<title>cfdump Function #Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
	
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
	</head>
	
	<body>
	
	<cfoutput>#downloadContent#</cfoutput>
	
	</body>
	</html>
	</cfoutput>
	
</cfif>

