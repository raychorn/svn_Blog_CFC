<!--- application.cfm --->

<cfscript>
	aa = ListToArray(ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/'), '/');
	nn = ArrayLen(aa);
	subName = '_';
	for (i = 1; i lte nn; i = i + 1) {
		subName = ListAppend(subName, aa[i], '_');
	}

	myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
	myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
</cfscript>

<cfapplication name="#myAppName#" clientmanagement="Yes" sessionmanagement="Yes" clientstorage="clientvars" setclientcookies="No" setdomaincookies="No" scriptprotect="All" sessiontimeout="#CreateTimeSpan(0,1,0,0)#" applicationtimeout="#CreateTimeSpan(1,0,0,0)#" loginstorage="Session">

<cftry>
	<cfinclude template="../includes/cfinclude_explainError.cfm">
	<cfinclude template="../includes/cfinclude_cflog.cfm">
	<cfinclude template="../includes/cfinclude_cfdump.cfm">

	<cfcatch type="Any">
	</cfcatch>
</cftry>

<cfinclude template="../includes/cfinclude_invalidEmailDomains.cfm">

<cfscript>
	if (IsDefined("URL.isajax")) {
		ajaxAR = ListToArray(CGI.QUERY_STRING, '&');
		ajaxAR_n = ArrayLen(ajaxAR);
		for (i = 1; i lte ajaxAR_n; i = i + 1) {
			FORM[ListFirst(ajaxAR[i], '=')] = URLDecode(ListLast(ajaxAR[i], '='));
		}
	}
</cfscript>

<cfscript>
//	Request.bool_isDebugUser = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );
	Request.bool_isDebugUser = false;

	err_commonCode = false;
	err_commonCodeMsg = '';
	try {
	   Request.commonCode = CreateObject("component", "cfc.commonCode");
	} catch(Any e) {
		Request.commonCode = -1;
		err_commonCode = true;
		err_commonCodeMsg = '(1) The commonCode component has NOT been created.';
		writeOutput('<font color="red"><b>#err_commonCodeMsg#</b></font><br>');
   		if (Request.bool_isDebugUser) writeOutput(cf_dump(e, 'Exception (e)', false));
	}
</cfscript>

<cftry>
	<cfset application.blog = createObject("component","cfc.blog").init('Default')>
	<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
		<cfset instance = application.blog.instance>
	</cfif>

	<cfcatch type="Any">
	</cfcatch>
</cftry>

<cfinclude template="../includes/cfinclude_encryptionSupport.cfm">

<cfscript>
//	Request.bool_isDebugMode = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );
	Request.bool_isDebugMode = false;

	Request.commonCode.readSessionFromDb();
</cfscript>

<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
	<cfset Session.rejectedLogin = false>
	<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST") AND (isDefined("form.username")) and (isDefined("form.password")) and (len(trim(form.username))) and (len(trim(form.password)))>
		<cfscript>
			Request.bool_isValid = application.blog.authenticate(left(trim(form.username),255),left(trim(form.password),50));
		</cfscript>
		<cfif (Request.bool_isValid)>
			<cfscript>
				_sqlStatement = "SELECT id, uid, sessID FROM tblUsersSession WHERE (uid = #Request.qAuthUser.id#) AND (sessID <> '#Session.sessID#')";
				Request.commonCode.safely_execSQL('Request.qCheckUsersSession', instance.dsn, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				}
				Request.bool_isValid = ( (IsDefined("Request.qCheckUsersSession")) AND (Request.qCheckUsersSession.recordCount eq 0) );
			//	writeOutput(Request.commonCode.cf_dump(Request.qCheckUsersSession, 'Request.qCheckUsersSession [#_sqlStatement#] (#Request.bool_isValid#)', false));
			</cfscript>
			<cflog file="#Application.applicationName#_DEBUG" type="Information" text="A. Request.bool_isValid = [#Request.bool_isValid#], Request.qCheckUsersSession.recordCount = [#Request.qCheckUsersSession.recordCount#]">
			<cfif (Request.bool_isValid)>
				<cflogin>
					<cfloginuser name="#trim(username)#" password="#trim(password)#" roles="admin">
				</cflogin>
				<cflog file="#Application.applicationName#_DEBUG" type="Information" text="B. username = [#username#], password = [#password#]">
				<!--- 
					  This was added because CF's built in security system has no way to determine if a user is logged on.
					  In the past, I used getAuthUser(), it would return the username if you were logged in, but
					  it also returns a value if you were authenticated at a web server level. (cgi.remote_user)
					  Therefore, the only say way to check for a user logon is with a flag. 
				--->  
				<cfset session.persistData.loggedin = true>
				<cflog file="#Application.applicationName#_DEBUG" type="Information" text="C. session.persistData.loggedin = [#session.persistData.loggedin#]">
				<cfif (IsDefined("Request.qAuthUser"))>
					<cfset Session.persistData.qauthuser = Request.qAuthUser>
				</cfif>

				<cfscript>
					_sqlStatement = "INSERT INTO tblUsersSession (uid, sessID) VALUES (#Request.qAuthUser.id#,'#Session.sessID#'); SELECT @@IDENTITY as 'id';";
					Request.commonCode.safely_execSQL('Request.qFlagUsersSession', instance.dsn, _sqlStatement);
					if (Request.dbError) {
						Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
					}
				</cfscript>
				<cfmodule template="../tags/scopecache.cfm" scope="db" clearall="true">		
			<cfelse>
				<cfset Session.rejectedLogin = true>
			</cfif>
		<cfelseif (FindNoCase("register.cfm", CGI.HTTP_REFERER) eq 0)>
			<cfscript>
				Session.rejectedInvalidLogin = true;
				Session.persistData.loginFailure = Session.persistData.loginFailure + 1;
			</cfscript>
		</cfif>
	</cfif>
</cflock>
