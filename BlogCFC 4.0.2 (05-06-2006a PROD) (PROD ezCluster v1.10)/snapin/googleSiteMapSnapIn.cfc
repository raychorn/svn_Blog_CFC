<cfcomponent displayname="googleSiteMapSnapIn" output="Yes" extends="snapIns">
	
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
						<form>
							<button id="btn_googleSiteMapLinks" style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;" onclick="toggleGoogleSiteMap(); return false;">[Google Site Map]</button>
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
					<div id="div_GoogleSiteMap_links" style="display: none;">
						<iframe id="iframe_GoogleSiteMap" frameborder="1" height="300" width="100%" scrolling="Auto"></iframe>
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
			}
		}
	</cfscript>
</cfcomponent>
