<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfif 0>
	<cflog file="#Application.applicationName#" type="Information" text="[_serverName=#_serverName#] [CGI.HTTP_REFERER=#CGI.HTTP_REFERER#] (#FindNoCase(_serverName, CGI.HTTP_REFERER)#)">
</cfif>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0)>
		<cfscript>
			jsName = ExpandPath(URL.jsName);
			writeOutput(Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now()))));
		</cfscript>
		<cfif (FileExists(jsName))>
			<cffile action="READ" file="#jsName#" variable="_jsCode">
			<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(_jsCode))#">
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	<cfelseif (IsDefined("URL.jsCodeBase")) AND (Len(URL.jsCodeBase) gt 0)>
		<cfif (URL.jsCodeBase eq 1)>
			<cftry>
				<cfinclude template="../js/cfinclude_CrossBrowserLibrary.cfm">

				<cfcatch type="Any">
					<cflog file="#Application.applicationName#" type="ERROR" text="Missing file named (../js/cfinclude_CrossBrowserLibrary.cfm) in (#CGI.SCRIPT_NAME#).">
				</cfcatch>
			</cftry>
		<cfelseif (URL.jsCodeBase eq "1a")>
			<cftry>
				<cfinclude template="../js/cfinclude_CrossBrowserLibrary2.cfm">

				<cfcatch type="Any">
					<cflog file="#Application.applicationName#" type="ERROR" text="Missing file named (../js/cfinclude_CrossBrowserLibrary2.cfm) in (#CGI.SCRIPT_NAME#).">
				</cfcatch>
			</cftry>
		<cfelseif (URL.jsCodeBase eq 2)>
			<cftry>
				<cfset Request.CodeSnapinsLibraryPragma = "head">
				<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
				<cfsavecontent variable="_jsCode"><cfinclude template="../js/cfinclude_BlogSupportLibrary.cfm"></cfsavecontent>
				<cfset Request.cfcontent_js = Request.commonCode.jsMinifier(_jsCode)>

				<cfcatch type="Any">
					<cflog file="#Application.applicationName#" type="ERROR" text="Missing file named (../js/cfinclude_CodeSnapinsLibrary.cfm) in (#CGI.SCRIPT_NAME#).">
				</cfcatch>
			</cftry>
		</cfif>
		<cfscript>
			writeOutput(Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now()))));
		</cfscript>
		<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(Request.cfcontent_js))#">
	</cfif>
</cfif>

