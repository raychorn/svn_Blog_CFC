<cfcomponent displayname="searchEngineLinksMakerSnapIn" output="Yes" extends="snapIns">
	
	<cffunction name="jsCodeForHead" returntype="string" access="public" output="Yes">
		<cfset var _html = "">

		<cfif isUserInRole("admin")>
			<cfsavecontent variable="_html">
				<script language="JavaScript1.2" type="text/javascript">
				<!--
				//-->
				</script>
			</cfsavecontent>
		</cfif>
		
		<cfscript>
			if (isUserInRole("admin")) {
			}
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="jsCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif isUserInRole("admin")>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
				//-->
				</script>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlActionButton" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfoutput>
				<cfif isUserInRole("admin")>
					<td align="center" valign="bottom">
						<form action="#CGI.SCRIPT_NAME#" enctype="application/x-www-form-urlencoded" method="post">
							<button id="btn_makeSearchEngineLinks" name="btn_makeSearchEngineLinks" type="submit" style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;">[Make Search Engine Links]</button>
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
				<cfif isUserInRole("admin")>
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
			if (isUserInRole("admin")) {
				if ((UCASE(CGI.REQUEST_METHOD) eq "POST") AND (IsDefined("FORM.BTN_MAKESEARCHENGINELINKS"))) {
					writeOutput(Request.cf_dump(CGI, 'CGI Scope (2)', false));
				}
			}
		}
	</cfscript>
</cfcomponent>
