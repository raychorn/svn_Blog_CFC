<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : error.cfm
	Author       : Raymond Camden 
	Created      : March 20, 2005
	Last Updated : June 22 2005
	History      : Show error if logged in. (rkc 4/4/05)
				   BD didn't like error.rootcause (rkc 5/27/05)
				   PaulH added locale strings (rkc 7/22/05)
	Purpose		 : Handles errors
--->

<!--- Send the error report --->
<cfset blogConfig = application.blog.getProperties()>

<cfsavecontent variable="mail">
<cfoutput>
#application.resourceBundle.getResource("errorOccured")#:<br>
<table border="1" width="100%">
	<tr>
		<td>#application.resourceBundle.getResource("date")#:</td>
		<td>#dateFormat(now(),"m/d/yy")# #timeFormat(now(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("scriptName")#:</td>
		<td>#cgi.script_name#?#cgi.query_string#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("browser")#:</td>
		<td>#CGI.HTTP_USER_AGENT#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("referer")#:</td>
		<td>#CGI.HTTP_REFERER#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("message")#:</td>
		<td><cfif (IsDefined("Request.Exception.message"))>#Request.Exception.message#</cfif></td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("type")#:</td>
		<td><cfif (IsDefined("Request.Exception.type"))>#Request.Exception.type#</cfif></td>
	</tr>
	<cfif structKeyExists(Request.Exception,"rootcause")>
	<tr>
		<td>#application.resourceBundle.getResource("rootCause")#:</td>
		<td><cfdump var="#Request.Exception.rootcause#"></td>
	</tr>
	</cfif>
	<cfif structKeyExists(Request.Exception,"tagcontext")>
	<tr>
		<td>#application.resourceBundle.getResource("tagContext")#:</td>
		<td><cfdump var="#Request.Exception.tagcontext#"></td>
	</tr>
	</cfif>
</table>
</cfoutput>
</cfsavecontent>

<cfif blogConfig.mailserver is "">
	<cfmail to="#blogConfig.owneremail#" from="do-not-respond@contentopia.net" subject="Error Report" type="#Request.typeOf_emailsContent#">#mail#</cfmail>
<cfelse>
	<cfmail to="#blogConfig.owneremail#" from="do-not-respond@contentopia.net" subject="Error Report"
			server="#blogConfig.mailserver#" username="#blogConfig.mailusername#" password="#blogConfig.mailpassword#"  type="#Request.typeOf_emailsContent#">#mail#</cfmail>
</cfif>

<cfsavecontent variable="_htmlPageContent">
	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("errorpageheader")#</div>
	<div class="body">
	<p>
	#application.resourceBundle.getResource("errorpagebody")#
	</p>
		<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
		<a href="#_mainURL#">Click HERE to continue...</a>
	</div>
	</cfoutput>
</cfsavecontent>

<cfoutput>
#_htmlPageContent#
</cfoutput>

