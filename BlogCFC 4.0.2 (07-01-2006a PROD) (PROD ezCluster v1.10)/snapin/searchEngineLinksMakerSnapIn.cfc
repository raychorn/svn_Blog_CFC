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
				<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
					<td align="left" valign="bottom">
						<form>
							<cfset theClass = ' style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;"'>
							<cfif (NOT Request.commonCode.isBrowserIE())>
								<cfset theClass = ' class="buttonClassFF"'>
							</cfif>
							<button id="btn_makeSearchEngineLinks" #theClass# onclick="openSElinks(); return false;">[Make Search Engine Links]</button>
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
				<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
					<div id="div_SE_links" style="display: none;">
						<iframe id="iframe_se_links" frameborder="1" height="300" width="100%" scrolling="Auto"></iframe>
					</div>
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
				//	writeOutput(Request.cf_dump(CGI, 'CGI Scope (2)', false));
				}
			}
		}
	</cfscript>
</cfcomponent>
