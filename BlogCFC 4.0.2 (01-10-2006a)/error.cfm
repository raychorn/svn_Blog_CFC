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
		<td>#error.browser#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("referer")#:</td>
		<td>#error.httpreferer#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("message")#:</td>
		<td>#error.message#</td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("type")#:</td>
		<td>#error.type#</td>
	</tr>
	<cfif structKeyExists(error,"rootcause")>
	<tr>
		<td>#application.resourceBundle.getResource("rootCause")#:</td>
		<td><cfdump var="#error.rootcause#"></td>
	</tr>
	</cfif>
	<tr>
		<td>#application.resourceBundle.getResource("tagContext")#:</td>
		<td><cfdump var="#error.tagcontext#"></td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfif blogConfig.mailserver is "">
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report">#mail#</cfmail>
<cfelse>
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report"
			server="#blogConfig.mailserver#" username="#blogConfig.mailusername#" password="#blogConfig.mailpassword#">#mail#</cfmail>
</cfif>

<cfmodule template="tags/layout.cfm">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("errorpageheader")#</div>
	<div class="body">
	<p>
	#application.resourceBundle.getResource("errorpagebody")#
	</p>
	<cfif isUserInRole("admin")>
		<cfoutput>#mail#</cfoutput>
	</cfif>
	</div>
	</cfoutput>
	
</cfmodule>