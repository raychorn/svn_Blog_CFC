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
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
	<form action="#_url#" method="post" onSubmit="return(this.email.value.length != 0)">
	<p align="center"><input type="text" id="subscribe_user_name" name="email" size="40" maxlength="255" <cfif (NOT session.persistData.loggedin)>disabled title="You may only Subscribe to this Blog when you are a Registered User of this Blog and you have activated your User Account."</cfif> onkeyup="if (!!_validateUserAccountName) { _validateUserAccountName($('subscribe_user_name')); };" onkeydown="var sRed = this.style.border; var iRed = sRed.indexOf(' red'); iRed = ((iRed == -1) ? sRed.indexOf('red ') : iRed); var boolRed = (iRed != -1); var bool = ( (event.keyCode != 13) || ( (event.keyCode == 13) && (boolRed == false) ) ); if ( (boolRed) && (event.keyCode == 13) ) { alert(this.title); }; return bool;"></p>
	<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
	</form>
	<cfif (NOT session.persistData.loggedin)>
		<span class="redBlogArticleAccessBoldPrompt">You may only Subscribe to this Blog when you are a Registered User of this Blog and you have activated your User Account.</span>
	</cfif>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>