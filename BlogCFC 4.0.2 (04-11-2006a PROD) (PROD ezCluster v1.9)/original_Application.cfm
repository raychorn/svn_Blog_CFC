<cfsetting enablecfoutputonly=true showdebugoutput=true>
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : Some time ago
	Last Updated : October 3, 2005
	History      : Reset history for version 4.0
				 : Saving some info in app scope now (rkc 10/3/05)
	Purpose		 : Blog application page
--->

<cfset setEncoding("form","utf-8")>
<cfset setEncoding("url","utf-8")>

<!--- Edit this line if you are not using a default blog --->
<cfparam name="blogname" type="string" default="Default">
<cfif (IsDefined("Session.blogname"))>
	<cfset blogname = Session.blogname>
</cfif>

<!--- The prefix is now dynamic in case 2 people want to run blog.cfc on the same machine. Normally they
	  would run both blogs with the same org, and use different names, but on an ISP that may not be possible.
	  So I base part of the application name on the file path.
	  
	Name can only be 64 max. So we will take right most part.
--->
<cferror type="exception" template="error.cfm">

<cfif (NOT isDefined("application.init")) OR (NOT application.init) OR (isDefined("url.reinit") AND (url.reinit eq "7660")) OR (isDefined("application.reinit") AND (application.reinit eq "7660"))>
	<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
		<!--- load an init blog --->
		<cfset application.blog = createObject("component","org.camden.blog.blog").init(blogname)>
		<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
			<cfset instance = application.blog.instance>
		</cfif>
	
		<cfset application.snapIns = StructNew()>
		<cfset application.snapIns.count = 0>
		<cfset application.snapIns.rootSnapIn = createObject("component","snapin.snapIns").init(application.snapIns)>
	
		<!--- all locale related --->
		<cfset application.resourceBundle = createObject("component","org.hastings.locale.resourcebundle")>
		<cfset application._fname = expandPath("includes/main")>
		<cfscript>
			application._fname = ReplaceNoCase(application._fname, 'includes\includes\', 'includes\');
		//	writeOutput('<b>application._fname = [#application._fname#]</b><br>');
		</cfscript>
		<cfset application.resourceBundle.loadResourceBundle(application._fname, application.blog.getProperty("locale"))>
		<cfset application.localeutils = createObject("component","org.hastings.locale.utils")>
		<cfset application.localeutils.loadLocale(application.blog.getProperty("locale"))>
	
		<cfset majorVersion = listFirst(server.coldfusion.productversion)>
		<cfset minorVersion = listGetAt(server.coldfusion.productversion,2)>
		<cfset cfversion = majorVersion & "." & minorVersion>
		
		<cfset application.isColdFusionMX7 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 7>
		
		<!--- Used in various places --->
		<cfset application.rootURL = application.blog.getProperty("blogURL")>
		<!--- per documentation - rooturl should be http://www.foo.com/something/something/index.cfm --->
		<cfset application.rootURL = reReplace(application.rootURL, "(.*)/index.cfm", "\1")>
	
		<cfscript>
			ar = ListToArray(application.rooturl, "/");
			ar2 = ListToArray(ar[2], ".");
			ar2a = ArrayNew(1);
			ar2a[ArrayLen(ar2a) + 1] = ar2[1];
			ar2a[ArrayLen(ar2a) + 1] = ar2[ArrayLen(ar2) - 1];
			ar2a[ArrayLen(ar2a) + 1] = ar2[ArrayLen(ar2)];
			ar[2] = ArrayToList(ar2a, ".");
			if ( (UCASE(ar[1]) eq UCASE('http:')) AND (ArrayLen(ar) eq 3) ) {
				application.rootURL = ar[1] & '//' & ar[2] & '/' & ar[3];
			}
		</cfscript>
		
		<cfmodule template="tags/scopecache.cfm" scope="db" clearall="true">		
	
		<!--- used for cache purposes is 60 minutes --->
		<cfset application.timeout = 60*60>

		<!--- We are initialized --->
		<cfset application.init = true>
	</cflock>
</cfif>

<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
	<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST") AND (isDefined("form.username")) and (isDefined("form.password")) and (len(trim(form.username))) and (len(trim(form.password)))>
		<cfset bool_isValid = application.blog.authenticate(left(trim(form.username),255),left(trim(form.password),50))>
		<cfif (bool_isValid)>
			<cflogin>
				<cfloginuser name="#trim(username)#" password="#trim(password)#" roles="admin">
			</cflogin>
			<!--- 
				  This was added because CF's built in security system has no way to determine if a user is logged on.
				  In the past, I used getAuthUser(), it would return the username if you were logged in, but
				  it also returns a value if you were authenticated at a web server level. (cgi.remote_user)
				  Therefore, the only say way to check for a user logon is with a flag. 
			--->  
			<cfset session.persistData.loggedin = true>
			<cfif (IsDefined("Request.qAuthUser"))>
				<cfset Session.persistData.qauthuser = Request.qAuthUser>
			</cfif>
		<cfelseif (FindNoCase("register.cfm", CGI.HTTP_REFERER) eq 0)>
			<cfscript>
				Session.persistData.loginFailure = Session.persistData.loginFailure + 1;
			</cfscript>
		</cfif>
	</cfif>
</cflock>

<cfsetting enablecfoutputonly=false>

