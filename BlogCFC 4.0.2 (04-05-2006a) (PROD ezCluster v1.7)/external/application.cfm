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

<cfscript>
	Request.bool_isDebugUser = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );

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

