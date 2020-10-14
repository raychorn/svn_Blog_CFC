<cfcomponent displayname="searchEngineLinksMakerSnapIn" output="Yes" extends="snapIns">
	
	<cffunction name="jsCodeForHead" returntype="string" access="public" output="Yes">
		<cfset var _html = "">

		<cfreturn _html>
	</cffunction>

	<cffunction name="jsCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlActionButton" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfoutput>
				<cfif session.persistData.loggedin>
					<td align="center" valign="bottom">
						<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#')>
						<form action="#_url#" enctype="application/x-www-form-urlencoded" method="post">
							<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
							<button id="btn_makeSearchEngineLinks" name="btn_makeSearchEngineLinks" type="submit" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;">[Make Search Engine Links]</button>
						</form>
					</td>
				</cfif>	
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfoutput>
				<cfif session.persistData.loggedin>
				</cfif>	
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cfscript>
		function init() {
			return this;
		}
		
		function cgiEvent() {
			if (session.persistData.loggedin) {
				if ((UCASE(CGI.REQUEST_METHOD) eq "POST") AND (IsDefined("FORM.BTN_MAKESEARCHENGINELINKS"))) {
					writeOutput(Request.cf_dump(CGI, 'CGI Scope (2)', false));
				}
			}
		}
	</cfscript>
</cfcomponent>
