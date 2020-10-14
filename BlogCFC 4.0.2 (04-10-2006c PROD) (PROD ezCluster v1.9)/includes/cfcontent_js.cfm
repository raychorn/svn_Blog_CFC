<cfsetting enablecfoutputonly="Yes">
<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0)>
		<cfscript>
			jsName = ExpandPath(URL.jsName);
			Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now())));
		</cfscript>
		<cfif (FileExists(jsName))>
			<cffile action="READ" file="#jsName#" variable="_jsCode">
			<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(_jsCode))#">
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	<cfelseif (IsDefined("URL.jsCodeBase")) AND (Len(URL.jsCodeBase) gt 0)>
		<cfif (URL.jsCodeBase eq "1a")>
			<cftry>
				<cfsavecontent variable="_cfcontent_js">
					<cfinclude template="../js/cfinclude_CrossBrowserLibrary2.cfm">
				</cfsavecontent>
				<cfset Request.cfcontent_js = "try { #_cfcontent_js# } catch(e) {} finally { };">

				<cfcatch type="Any">
					<cflog file="#Application.applicationName#" type="ERROR" text="Missing file named (../js/cfinclude_CrossBrowserLibrary2.cfm) in (#CGI.SCRIPT_NAME#).">
				</cfcatch>
			</cftry>
		<cfelseif (URL.jsCodeBase eq 2)>
			<cftry>
				<cfsavecontent variable="_cfcontent_js">
					<cfset Request.CodeSnapinsLibraryPragma = "head">
					<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
				</cfsavecontent>
				<cfscript>
					_cfcontent_js = Request.commonCode.jsMinifier(_cfcontent_js);
				</cfscript>
				<cfset Request.cfcontent_js = "try { #_cfcontent_js# } catch(e) {} finally { };">

				<cfcatch type="Any">
					<cflog file="#Application.applicationName#" type="ERROR" text="Missing file named (../js/cfinclude_CodeSnapinsLibrary.cfm) in (#CGI.SCRIPT_NAME#).">
				</cfcatch>
			</cftry>
		</cfif>
<cfif 0>
	<cflog file="#Application.applicationName#" type="Information" text="(#URL.jsCodeBase#) [_serverName=#_serverName#] [CGI.HTTP_REFERER=#CGI.HTTP_REFERER#] (#Len(Request.cfcontent_js)#)">
</cfif>
		<cfif (Len(Request.cfcontent_js) gt 0)>
			<cfscript>
				Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now())));
			</cfscript>
			<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(Request.cfcontent_js))#">
		</cfif>
	</cfif>
</cfif>

