<cfprocessingdirective pageencoding="utf-8">

<cfsavecontent variable="eulaContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("eula")#</div>
	<div class="body">
		<OL>
			<LI><p align="justify" class="normalBoldBluePrompt">Users are required to enter their valid Internet Email Address as their user name upon Registering.</p></LI>
			<LI><p align="justify" class="normalBoldBluePrompt">Users are required to validate their User Names by clicking on the Link they receive via email.</p></LI>
			<LI><p align="justify" class="normalBoldBluePrompt">Users may not share their user accounts.  Each user account will be allowed one single login session at a time.  Violations may result in user fees or loss of access to be determined by the Administrators of this site.</p></LI>
			<LI><p align="justify" class="normalBoldBluePrompt">Users may be denied access to their User Accounts whenever the terms of the EULA are not followed; to be determined by the Site Administrators at their discretion.</p></LI>
		</OL>
		<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
		<a href="#_mainURL#">Click HERE to continue...</a>
	</div>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>

	<cfmodule template="tags/layout.cfm">
		<cfoutput>#eulaContent#</cfoutput>
	</cfmodule>
	
<cfelse>
	
	<cfoutput>#eulaContent#</cfoutput>
	
</cfif>
