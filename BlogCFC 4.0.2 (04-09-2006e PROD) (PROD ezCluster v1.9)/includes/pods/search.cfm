<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : October 26, 2005
	History      : added processingdir (rkc 11/10/03)
				   point to index.cfm (rkc 8/5/05)
				   Change link (rkc 10/26/05)
	Purpose		 : Display search box
--->

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("search")#">

	<cfoutput>
	<br>
	<cfset _URL = Request.commonCode._URLSessionFormat("http://#CGI.SERVER_NAME#/blog/_index.cfm", false)>
	<form action="#_URL#&mode=search" method="post" onSubmit="return(this.search.value.length != 0)">
	<p align="center"><input type="text" name="search"></p>
	<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
	</form>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>