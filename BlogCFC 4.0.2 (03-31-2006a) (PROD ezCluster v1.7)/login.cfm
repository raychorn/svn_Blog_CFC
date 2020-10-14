<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : November 10, 2003
	History      : Multiple changes (rkc 11/10/03)
	Purpose		 : Login form
--->

<cfsavecontent variable="loginForm">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("loginform")#</div>
	<div class="body">
	<form action="#cgi.script_name#?#cgi.query_string#" method="post">
	<!--- copy additional fields --->
	<cfloop item="field" collection="#form#">
		<!--- the isSimpleValue is probably a bit much.... --->
		<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
			<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
		</cfif>
	</cfloop>
	<table>
		<tr>
			<td><b>#application.resourceBundle.getResource("username")#</b></td>
			<td><input type="text" name="username"></td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("password")#</b></td>
			<td><input type="password" name="password"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" value="#application.resourceBundle.getResource("login")#"></td>
		</tr>
	</table>
	</form>
	</div>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>

	<cfmodule template="tags/layout.cfm">
		<cfoutput>#loginForm#</cfoutput>
	</cfmodule>
	
<cfelse>
	
	<cfoutput>#loginForm#</cfoutput>
	
</cfif>
