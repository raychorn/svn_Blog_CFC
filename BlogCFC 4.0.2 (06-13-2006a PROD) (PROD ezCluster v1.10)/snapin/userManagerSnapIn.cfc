<cfcomponent displayname="userManagerSnapIn" output="No" extends="snapIns">
	
	<cffunction name="jsCodeForHead" returntype="string" access="public" output="Yes">
		<cfset var _html = "">

		<cfreturn _html>
	</cffunction>

	<cffunction name="jsCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif session.persistData.loggedin>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlActionButton" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
				<td align="left" valign="bottom">
					<form>
						<cfset theClass = ' style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;"'>
						<cfif (NOT Request.commonCode.isBrowserIE())>
							<cfset theClass = ' class="buttonClassFF"'>
						</cfif>
						<button id="btn_userManager" #theClass# onclick="openUserManager(); return false;">[User Manager]</button>
					</form>
				</td>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
				<div id="div_usermanager" style="display: none;">
					<table width="600px" border="0" cellpadding="-1" cellspacing="-1">
						<tr>
							<td width="100%" align="right" bgcolor="silver" colspan="3">
								<button id="btn_usermanagerClose" style="font-size: 10px;" onclick="closeUserManager(); return false;">[X]</button>
							</td>
						</tr>
						<tr>
							<td width="100%">
								<iframe id="iframe_userManager" frameborder="1" scrolling="Auto" width="100%" height="400"></iframe>
							</td>
						</tr>
					</table>
				</div>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cfscript>
		function init() {
			return this;
		}

		function cgiEvent() {
		}
	</cfscript>
</cfcomponent>
