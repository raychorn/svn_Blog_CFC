<!--- application.cfm --->

<cfif (0)>
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
<cfelse>
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
</cfif>

<cfapplication name="#myAppName#" clientmanagement="Yes" sessionmanagement="Yes" clientstorage="clientvars" setclientcookies="No" setdomaincookies="No" scriptprotect="All" sessiontimeout="#CreateTimeSpan(0,1,0,0)#" applicationtimeout="#CreateTimeSpan(1,0,0,0)#" loginstorage="Session">

<cftry>
	<cfinclude template="cfinclude_cfdump.cfm">
	<cfinclude template="cfinclude_explainError.cfm">

	<cfcatch type="Any">
	</cfcatch>
</cftry>

<cfset err_ajaxCode = false>
<cfset err_ajaxCodeMsg = ''>
<cftry>
	<cfset Request.commonCode = CreateObject("component", "cfc.ajaxCode")>
	<cfcatch type="Any">
		<cfset err_ajaxCode = true>
		<cfdump var="#cfcatch#" label="cfcatch" expand="No">
	</cfcatch>
</cftry>

<cfscript>
	Request.DSN = 'KLADB';

	Request.cf_dump = cf_dump;
	
	Request.const_Cr = Chr(13);
	Request.const_Lf = Chr(10);
	Request.const_Tab = Chr(9);
	Request.const_CrLf = Request.const_Cr & Request.const_Lf;
	Request.parentKeyword = 'parent.';
	Request.cf_html_container_symbol = "html_container";
	Request.const_jsapi_loading_image = "../images/loading.gif";
	Request.const_busy_loading_image = "../images/wait.gif";
	Request.const_paper_color_light_yellow = '##FFFFBF';
	Request.const_color_light_blue = '##80FFFF';
</cfscript>

<cferror type="EXCEPTION" template="onError.cfm" mailto="ray.horn@klatencor.com">

