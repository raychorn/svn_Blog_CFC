<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : subscribe.cfm
	Author       : Raymond Camden 
	Created      : May 12, 2005
	Last Updated : 
	History      : 
	Purpose		 : Allow folks to subscribe.
--->

<!--- 
	  I know. The caller. syntax is icky. This should be safe since all pods work in the same context. 
	  I may move the UDFs to the request scope so it's less icky. At the same time, it's not the big huge of
	  a deal. In fact, I bet no one is even going to read this. If you do, hi, how are you. Send me an email
	  and we can talk about how sometimes it is necessary to break the rules a bit. Then maybe we can have a
	  beer and talk about good sci-fi movies.
--->
<cfinclude template="../udf.cfm">

<cfif isDefined("form.email") and len(trim(form.email)) and Request.commonCode.isEmail(trim(form.email))>
	<cfset application.blog.addSubscriber(trim(form.email))>
</cfif>

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("subscribe")#">

	<cfoutput>
	#application.resourceBundle.getResource("subscribeblog")#
	<cfset _URL = Request.commonCode._URLSessionFormat("http://#CGI.SERVER_NAME#/blog/_index.cfm", false)>
	<form action="#_URL#" method="post" onSubmit="return(this.email.value.length != 0)">
	<p align="center"><input type="text" name="email"></p>
	<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
	</form>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>