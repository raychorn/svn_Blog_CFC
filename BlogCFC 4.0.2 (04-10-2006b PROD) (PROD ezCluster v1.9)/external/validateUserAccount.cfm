<cfprocessingdirective pageencoding="utf-8">

<cfif 0>
	<style>
		li {
			font-size: 10px;
		};
	</style>
	<cfscript>
		writeOutput('CGI.SCRIPT_NAME = [#CGI.SCRIPT_NAME#]<br>');
		if (IsDefined("Application")) writeOutput('Application Scope:<br>' & Request.commonCode.StructExplainer(Application, true));
		if (IsDefined("Session")) writeOutput('Session Scope:<br>' & Request.commonCode.StructExplainer(Session, true));
		if (IsDefined("URL")) writeOutput('URL Scope:<br>' & Request.commonCode.StructExplainer(URL, true));
		if (IsDefined("FORM")) writeOutput('FORM Scope:<br>' & Request.commonCode.StructExplainer(FORM, true));
		if (IsDefined("CGI")) writeOutput('CGI Scope:<br>' & Request.commonCode.StructExplainer(CGI, true));
	</cfscript>
</cfif>

<cfif 1>
	<cfsavecontent variable="_html">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<h2 align="center">Your User Account has been Activated.  You may now login.</h2>
<br>
<a href="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#">Click HERE to continue...</a>

</body>
</html>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		_userToValidate = '';
		if (IsDefined("URL.parm")) {
			_userToValidate = URL.parm;
		}
		
		if (Len(_userToValidate) gt 0) {
			_sqlStatement = "UPDATE tblUsers SET isValid = 1 WHERE (username = '#Request.commonCode.filterQuotesForSQL(_userToValidate)#')";
			Request.commonCode.safely_execSQL('Request.qActivateUserAccount', instance.DSN, _sqlStatement);
			if (Request.dbError) {
				Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
			} else {
				writeOutput(_html);
			}
		}
	</cfscript>
</cfif>
