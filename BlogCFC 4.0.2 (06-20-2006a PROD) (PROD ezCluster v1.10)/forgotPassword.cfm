<cfprocessingdirective pageencoding="utf-8">

<cfset statusMsg = "">

<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST") AND (IsDefined("FORM.INPUT_USERNAME")) AND (Len(FORM.INPUT_USERNAME) gt 0)>
	<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
		<cfset instance = application.blog.instance>
	</cfif>

	<cfscript>
		_sqlStatement = "SELECT password FROM tblUsers WHERE (username = '#Request.commonCode.filterQuotesForSQL(FORM.INPUT_USERNAME)#')";
		Request.commonCode.safely_execSQL('Request.qGetBlogUserPassword', instance.dsn, _sqlStatement);
		if (Request.dbError) {
			writeOutput('<span class="errorBoldPrompt">#Request.explainErrorHTML#</span>');
			Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#]');
			statusMsg = statusMsg & Request.explainErrorHTML;
		}
	</cfscript>

	<cfsavecontent variable="forgotPasswordEmail">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<cftry>
	<cfsavecontent variable="yourPassword_html">
		<cfoutput>
			<cfif (IsDefined("Request.qGetBlogUserPassword.password"))>"<b>#Request.commonCode.decodeEncodedEncryptedString(Request.qGetBlogUserPassword.password).PLAINTEXT#</b>"</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfcatch type="Any">
		<cfset yourPassword_html = "">
	</cfcatch>
</cftry>
<H3 style="color: blue;">Your password is #yourPassword_html#. (The password in <b>bold</b> appears between the '"' characters.)</H3>

<small>Your password remains secure because we only share this information with you upon request.</small>

</body>
</html>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		if (NOT Request.dbError) {
			Request.commonCode.safely_cfmail(FORM.INPUT_USERNAME, 'do-not-respond@contentopia.net', 'User Password EMail from #instance.blogTitle#', forgotPasswordEmail);
			if (Request.anError) {
				statusMsg = statusMsg & '<span class="errorBoldPrompt">#Request.errorMsg#</span>';
			}
			_url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'login.cfm', '/'));
			statusMsg = statusMsg & '<br><br><a href="#_url#">Click HERE to Login...</a>';
		}
	</cfscript>
</cfif>

<cfif (Session.persistData.loginFailure lte 3)>
	<cfsavecontent variable="forgotPwdForm">
	
		<cfoutput>
		<div class="date">#application.resourceBundle.getResource("forgotpasswordform")#</div>
		<div class="body">
			#statusMsg#
			<br>
			<br>
			<h4 align="left" style="color: blue;">Your Password has been sent to your email address.</h4>

			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'original_index.cfm', '/'))>
			<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>Click HERE to continue...</a>
		</div>
		</cfoutput>
	
	</cfsavecontent>
	
	<cfif not isDefined("hideLayout")>
	
		<cfmodule template="tags/layout.cfm">
			<cfoutput>#forgotPwdForm#</cfoutput>
		</cfmodule>
		
	<cfelse>
		
		<cfoutput>#forgotPwdForm#</cfoutput>
		
	</cfif>
<cfelse>
	<cfsavecontent variable="_html">
		<cfoutput>
			<h2 align="center" style="color: red">Too Many Unsuccessful Login Attempts... Try Back later on however be sure you Activated your User Account using the Link you received via email.</h2>
		</cfoutput>
	</cfsavecontent>

	<cfif not isDefined("hideLayout")>
	
		<cfmodule template="tags/layout.cfm">
			<cfoutput>#_html#</cfoutput>
		</cfmodule>
		
	<cfelse>
		
		<cfoutput>#_html#</cfoutput>
		
	</cfif>
</cfif>
