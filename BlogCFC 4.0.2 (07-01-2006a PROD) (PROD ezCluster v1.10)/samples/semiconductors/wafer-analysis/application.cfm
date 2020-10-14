<cfscript>
	if (NOT IsDefined("This.name")) {
		aa = ListToArray('/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/', '/');
		subName = aa[1];
		if (Len(subName) gt 0) {
			subName = '_' & subName;
		}

		myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
		myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
		myAppName = UCASE(myAppName);
	}
</cfscript>

<cfapplication name="#myAppName#" clientmanagement="Yes" sessionmanagement="Yes" clientstorage="clientvars" setclientcookies="No" setdomaincookies="No" scriptprotect="All" sessiontimeout="#CreateTimeSpan(0,1,0,0)#" applicationtimeout="#CreateTimeSpan(1,0,0,0)#" loginstorage="Session">

<cffunction name="cf_log" access="public">
	<cfargument name="_someText_" type="string" required="yes">
	
	<cflog file="#Application.applicationName#" type="Information" text="#_someText_#">
</cffunction>

<cfinclude template="AJAX/cfinclude_explainError.cfm">
<cfinclude template="AJAX/cfinclude_cfdump.cfm">

<cfscript>
	err_ajaxCode = false;
	err_ajaxCodeMsg = '';
	errorExplanation = '';
</cfscript>

<cfscript>
	Request.cf_log = cf_log;
	Request.cf_dump = cf_dump;
	Request.explainError = explainError;
	Request.explainObject = explainError;
	Request._explainError = _explainError;
	Request.explainErrorWithStack = explainErrorWithStack;
</cfscript>

<cfscript>
	Request.DSN = 'KLADB';
	
	Request.const_Cr = Chr(13);
	Request.const_Lf = Chr(10);
	Request.const_Tab = Chr(9);
	Request.const_CrLf = Request.const_Cr & Request.const_Lf;
	Request.parentKeyword = 'parent.';
	Request.cf_html_container_symbol = "html_container";
	Request.const_jsapi_loading_image = "images/loading.gif";
	Request.const_busy_loading_image = "images/wait.gif";
	Request.const_paper_color_light_yellow = '##FFFFBF';
	Request.const_color_light_blue = '##80FFFF';
	
	temporalIndex = '#GetTickCount()#';
	Randomize(Right(temporalIndex, Min(Len(temporalIndex), 9)), 'SHA1PRNG');
	
	Request.cf_div_floating_debug_menu = 'div_floating_debug_menu';
	
	Request.AUTH_USER = 'admin';

	err_ajaxCode = false;
	err_ajaxCodeMsg = '';
	try {
		_prefix = ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
		prefix = ReplaceNoCase(_prefix, '/', '.', 'all');
		if (Left(prefix, 1) eq '.') {
			prefix = Right(prefix, Len(prefix) - 1);
		}
		Request.commonCode = CreateObject("component", prefix & ".ajax.cfc.ajaxCode");
	} catch(Any e) {
		err_ajaxCode = true;
		err_ajaxCodeMsg = '(1) The ajaxCode component has NOT been created.';
		writeOutput('<font color="red"><b>#err_ajaxCodeMsg# | Reason: [#e.message#] [#e.detail#]</b></font><br>');
	}
	if (err_ajaxCode) {
		Request.cf_log(Application.applicationname, 'Error', '[#err_ajaxCodeMsg#]');
	}
	
	err_someCode = false;
	err_someCodeMsg = '';
	try {
	   Request.pythonCode = CreateObject("component", prefix & ".cfc.pythonInterpreter");
	} catch(Any e) {
		err_someCode = true;
		err_someCodeMsg = '(1) The pythonInterpreter component has NOT been created.';
		writeOutput('<font color="red"><b>#err_someCodeMsg# | Reason: [#e.message#] [#e.detail#]</b></font><br>');
	}
	if (err_someCode) {
		Request.cf_log(Application.applicationname, 'Error', '[#err_someCodeMsg#]');
	}

	Request._cfm_path = _prefix & "/ajax/";
	Request.cfm_gateway_process_html = "#Request._cfm_path#AJAX_functions.cfm";
	
//	writeOutput('<br><br><br><br><br><br>Request._cfm_path = [#Request._cfm_path#], Request.cfm_gateway_process_html = [#Request.cfm_gateway_process_html#]<br>');

	Request.RuntimeLicenseStatus = '';
</cfscript>

<cfset makeNewRuntimeLicense = (Request.commonCode.isServerLocal()) AND false>

<!--- BEGIN: Read the Runtime License File --->
<cfif (NOT makeNewRuntimeLicense)>
	<cfscript>
		aStruct = Request.commonCode.readRuntimeLicenseFile();
		Request.RuntimeLicenseStatus = aStruct.RuntimeLicenseStatus;
	</cfscript>
	<cfif 0>
		<br><br><br><br><br><br>
		<cfdump var="#aStruct#" label="aStruct" expand="No">
	</cfif>
</cfif>
<!--- END! Read the Runtime License File --->


<!--- BEGIN: Make a Runtime License File --->
<cfif (makeNewRuntimeLicense)>
	<cfscript>
		Request.commonCode.writeRuntimeLicenseForEndDate(CreateDateTime(2099, 12, 31, 23, 59, 59));
	</cfscript>
</cfif>
<!--- END! Make a Runtime License File --->

<cfscript>
	Request.commonCode.readSessionFromDb();
</cfscript>

<cfscript>
	if ( (NOT IsDefined("Session.persistData.loggedin")) OR (NOT Session.persistData.loggedin) ) {
		Request.RuntimeLicenseStatus = '<br><br><br><h2 style="color: red">101. Use of this Prototype is limited to only those who have valid User Accounts for this site.  Kindly obtain a valid User Account and return to use this Prototype.<br><br>&copy; 1990-#Year(Now())# Hierarchical Applications Limited, All Rights Reserved.</h2>';
	}
</cfscript>
