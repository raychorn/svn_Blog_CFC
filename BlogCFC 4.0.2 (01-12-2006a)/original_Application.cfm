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
<cfparam name="Client.blogname" type="string" default="Default">
<cfset blogname = Client.blogname>

<!--- The prefix is now dynamic in case 2 people want to run blog.cfc on the same machine. Normally they
	  would run both blogs with the same org, and use different names, but on an ISP that may not be possible.
	  So I base part of the application name on the file path.
	  
	Name can only be 64 max. So we will take right most part.
--->
<cferror type="exception" template="error.cfm">

<cfinclude template="includes/udf.cfm">

<cfif not isDefined("application.init") or (isDefined("url.reinit") AND (url.reinit eq "7660"))>
	<!--- load an init blog --->
	<cfset application.blog = createObject("component","org.camden.blog.blog").init(blogname)>

	<cfset application.snapIns = StructNew()>
	<cfset application.snapIns.count = 0>
	<cfset application.snapIns.rootSnapIn = createObject("component","snapin.snapIns").init(application.snapIns)>

<cfif 0>
	<cfdump var="#application.snapIns#" label="application.snapIns" expand="No">
	<cfdump var="#Request#" label="Request" expand="No">
</cfif>	
	
	<!--- all locale related --->
	<cfset application.resourceBundle = createObject("component","org.hastings.locale.resourcebundle")>
	<cfset application.resourceBundle.loadResourceBundle(expandPath("./includes/main"), application.blog.getProperty("locale"))>
	<cfset application.localeutils = createObject("component","org.hastings.locale.utils")>
	<cfset application.localeutils.loadLocale(application.blog.getProperty("locale"))>

	<!--- clear cache --->
	<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">

	<cfset majorVersion = listFirst(server.coldfusion.productversion)>
	<cfset minorVersion = listGetAt(server.coldfusion.productversion,2)>
	<cfset cfversion = majorVersion & "." & minorVersion>
	
	<cfset application.isColdFusionMX7 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 7>
	
	<!--- Used in various places --->
	<cfset application.rootURL = application.blog.getProperty("blogURL")>
	<!--- per documentation - rooturl should be http://www.foo.com/something/something/index.cfm --->
	<cfset application.rootURL = reReplace(application.rootURL, "(.*)/index.cfm", "\1")>
	
	<!--- used for cache purposes is 60 minutes --->
	<cfset application.timeout = 60*60>
	
	<!--- We are initialized --->
	<cfset application.init = true>
	
</cfif>

<cflogin>
	<cfif isDefined("form.username") and isDefined("form.password") and len(trim(form.username)) and len(trim(form.password))>
		<cfif application.blog.authenticate(left(trim(form.username),50),left(trim(form.password),50))>
			<cfloginuser name="#trim(username)#" password="#trim(password)#" roles="admin">
			<!--- 
				  This was added because CF's built in security system has no way to determine if a user is logged on.
				  In the past, I used getAuthUser(), it would return the username if you were logged in, but
				  it also returns a value if you were authenticated at a web server level. (cgi.remote_user)
				  Therefore, the only say way to check for a user logon is with a flag. 
			--->  
			<cfset session.loggedin = true>
		</cfif>
	</cfif>
</cflogin>

<!--- Security Related --->
<cfif isDefined("url.logout") and isLoggedIn()>
	<cfset structDelete(session,"loggedin")>
	<cflogout>
</cfif>

<cfif (isDefined("url.designmode") AND (url.designmode eq "7660")) and not isLoggedIn()>
	<cfsetting enablecfoutputonly=false>
	<cfinclude template="login.cfm">
	<cfabort>
</cfif>

<cfsetting enablecfoutputonly=false>

