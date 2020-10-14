<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
	<cfset instance = application.blog.instance>
</cfif>

<cfscript>
	usersNowOnline = 0;
	_sqlStatement = "SELECT COUNT(id) as cnt FROM tblUsersSession";
	Request.commonCode.safely_execSQL('Request.qCountUsersSessions', instance.dsn, _sqlStatement);
	if (Request.dbError) {
		Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
	} else if ( (IsQuery(Request.qCountUsersSessions)) AND (Request.qCountUsersSessions.recordCount gt 0) AND (Request.qCountUsersSessions.cnt gt 0) ) {
		usersNowOnline = Request.qCountUsersSessions.cnt;
	}
</cfscript>
