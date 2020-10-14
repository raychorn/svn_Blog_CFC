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
	<cfsavecontent variable="_htmlValidated">
		<cfoutput>
			<cfmodule template="../tags/singleTabbedContent.cfm" tabTitle="Account Validated">
				<h2 align="center">Your User Account has been Activated.  You may now login.</h2>
				<br>
				<a href="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#">Click HERE to continue...</a>
			</cfmodule>
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="_htmlNotValidated">
		<cfoutput>
			<cfmodule template="../tags/singleTabbedContent.cfm" tabTitle="Account Not Validated">
				<h2 align="center">Your User Account has NOT been Activated.  Your Account Activation Email Expires after 24 hrs of receipt.</h2>
				<br>
				<a href="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#">Click HERE to continue...</a>
			</cfmodule>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		_userToValidate = '';
		_uuidToValdate = '';
		if (IsDefined("CGI.QUERY_STRING")) {
			ar = ListToArray(CGI.QUERY_STRING, '&');
			if (ArrayLen(ar) eq 2) {
				_userToValidate = ListLast(ar[1], '=');
				_uuidToValdate = ar[2];
			}
		}
		if ( (Len(_userToValidate) gt 0) AND (Len(_uuidToValdate) gt 0) ) {
			_sqlStatement = "UPDATE tblUsers SET isValid = 1 FROM tblUsers INNER JOIN tblUsersAccountValidation ON tblUsers.id = tblUsersAccountValidation.uid WHERE (tblUsers.username = '#Request.commonCode.filterQuotesForSQL(_userToValidate)#') AND (tblUsersAccountValidation.uuid = '#Request.commonCode.filterQuotesForSQL(_uuidToValdate)#') AND (GetDate() < tblUsersAccountValidation.endDate)";
			Request.commonCode.safely_execSQL('Request.qActivateUserAccount', instance.DSN, _sqlStatement);
			if (Request.dbError) {
				Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
			} else {
				_sqlStatement = "SELECT tblUsers.id, tblUsers.isValid FROM tblUsers INNER JOIN tblUsersAccountValidation ON tblUsers.id = tblUsersAccountValidation.uid WHERE (tblUsers.username = '#Request.commonCode.filterQuotesForSQL(_userToValidate)#') AND (tblUsersAccountValidation.uuid = '#Request.commonCode.filterQuotesForSQL(_uuidToValdate)#')";
				Request.commonCode.safely_execSQL('Request.qCheckUserAccountValidation', instance.DSN, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				} else if ( (IsDefined("Request.qCheckUserAccountValidation")) AND (IsQuery(Request.qCheckUserAccountValidation)) AND (Request.qCheckUserAccountValidation.recordCount gt 0) ) {
					if (Request.qCheckUserAccountValidation.isValid) {
						writeOutput(_htmlValidated);
						Request.commonCode.safely_cfmail('raychorn@hotmail.com', 'do-not-respond@contentopia.net', 'Notice: User Account Successfully Validated (#_userToValidate#)', _htmlValidated);
					} else {
						writeOutput(_htmlNotValidated);
						Request.commonCode.safely_cfmail('raychorn@hotmail.com', 'do-not-respond@contentopia.net', 'Notice: User Account Not Validated (#_userToValidate#)', _htmlNotValidated);
					}
				} else {
					writeOutput(_htmlNotValidated);
				}
			}
		}
	</cfscript>
</cfif>
