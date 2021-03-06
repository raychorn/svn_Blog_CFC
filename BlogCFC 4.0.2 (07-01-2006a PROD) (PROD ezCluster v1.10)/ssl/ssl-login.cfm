<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_callingServer" type="string" default="rabid.contentopia.net">
<cfparam name="_appName" type="string" default="#Application.applicationName#">
<cfparam name="_sessionID" type="string" default="#Session.sessID#">

<cfoutput>
	<html>
	<head>
		<title>SSL Login</title>
		#Request.commonCode.html_nocache()#
		<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />

		<cfset Request.jsCodeObfuscationIndex = 1>
		<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
		<cfsavecontent variable="_jscode">
			<cfoutput>
				#Request.commonCode.readAndObfuscateJSCode('../js/433511201010924803.dat')#
				#Request.commonCode.readAndObfuscateJSCode('../js/decontextmenu.js')#
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
	
		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'original_index.cfm', '/'))>
		<cfif (IsDefined("FORM.redirectURL")) AND (Len(Trim(FORM.redirectURL)) gt 0)>
			<cfset _url = FORM.redirectURL>
		</cfif>
	
		<cfscript>
			Request.commonCode.commitSessionToDb();
		</cfscript>

		<cflog file="#Application.applicationName#_DEBUG" type="Information" text="D. Request.bool_isValid = [#Request.bool_isValid#], Session.rejectedLogin = [#Session.rejectedLogin#]">
		
		<cfif (NOT Request.bool_isValid) AND (Session.rejectedLogin)>
			<cfsavecontent variable="_status">
				<cfoutput>
					<span class="errorBoldPrompt">Your Login Attempt was rejected because: </span>
					<UL class="errorBoldPrompt">
						<LI>(a) You were logged-in from a different workstation and you need to wait a bit longer for your previous Session to be retired.</LI>
						<LI>(b) You have shared your User Account with another user who is still logged-in however this is a EULA Violation and hence you cannot login at this time.</LI>
						<LI>(c) Your User Account has been flagged for a EULA Violation and you will not be allowed to login since we take EULA Violations quite seriously.</LI>
						<LI>(d) You entered a username or password we cannot verify.</LI>
						<LI>(e) You have failed to login too many times and your user account has been flagged for a security violation which means you may need to wait for your Session to be retired before trying again.</LI>
					</UL>
					<span class="errorBoldPrompt">Please try back again, you never know you might just change our minds about all this...</span><br><br>
					<span class="textClass"><a href="#_url#" target="_top">Click Here to Continue...</a></span>
				</cfoutput>
			</cfsavecontent>
			<cfset _url = 'http://#_callingServer#/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/loginStatus.cfm'>
			<cfset _status_ = URLEncodedFormat(_status)>
			<cflocation url="#_url#?_status=#Left(_status_, Min(Len(_status_), 2000))#" addtoken="No">
		<cfelse>
			<div style="display: none;">
				<form action="#_url#" method="Get" id="form_proceed" target="_parent">
					<input type="submit" name="btnSubmit">
				</form>
			</div>
			<script language="JavaScript1.2" type="text/javascript">
				var oForm = document.getElementById('form_proceed');
				if (!!oForm) {
					oForm.submit();
				}
			</script>
		</cfif>
	
	</body>
	</html>

</cfoutput>
