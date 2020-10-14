<cfif (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0)>
		<cfscript>
			jsName = ExpandPath(URL.jsName);
			writeOutput(Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now()))));
		</cfscript>
		<cfcontent type="text/javascript" file="#jsName#">
	<cfelseif (IsDefined("URL.jsCodeBase")) AND (Len(URL.jsCodeBase) gt 0)>
		<cfif (URL.jsCodeBase eq 1)>
			<cfinclude template="../js/cfinclude_CrossBrowserLibrary.cfm">
			<cfset Request.cfcontent_js = application.crossBrowserLibraryJSCode>
		<cfelseif (URL.jsCodeBase eq 2)>
			<cfset Request.CodeSnapinsLibraryPragma = "head">
			<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
			<cfsavecontent variable="_jsCode"><cfinclude template="../js/cfinclude_BlogSupportLibrary.cfm"></cfsavecontent>
			<cfset Request.cfcontent_js = Request.commonCode.jsMinifier(_jsCode)>
		</cfif>
		<cfscript>
			writeOutput(Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now()))));
		</cfscript>
		<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(Request.cfcontent_js))#">
	</cfif>
</cfif>

