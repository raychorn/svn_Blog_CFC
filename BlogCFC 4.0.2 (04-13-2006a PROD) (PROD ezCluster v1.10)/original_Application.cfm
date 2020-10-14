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

<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
	<cfscript>
		application.reinit = '7660';
	
		application.blog = createObject("component","org.camden.blog.blog").init(blogname);
	
		_rbFile = application._fname & "_" & application.blog.getProperty("locale") & ".properties";
	
		_rbFileDt = -1;
		bool_isError = Request.commonCode.cf_directory('Request.qDir', GetDirectoryFromPath(_rbFile), GetFileFromPath(_rbFile), false);
		if ( (NOT bool_isError) AND (Request.qDir.recordCount gt 0) ) {
			_rbFileDt = Request.qDir.dateLastModified;
		}
		if ( (IsDefined("application.resourceBundleDt")) AND (IsDefined("application.resourceBundle.resourceBundle")) ) {
			try {
				if ( (_rbFileDt neq -1) AND (DateCompare(_rbFileDt, application.resourceBundleDt) gt 0) ) {
					application.resourceBundleDt = _rbFileDt;
				} else {
					application.reinit = -1;
				}
			} catch (Any e) {
				application.resourceBundleDt = _rbFileDt;
			}
		} else {
			application.resourceBundleDt = _rbFileDt;
		}
	</cfscript>
</cflock>

<cfif (NOT isDefined("application.init")) OR (NOT application.init) OR (isDefined("url.reinit") AND (url.reinit eq "7660")) OR (isDefined("application.reinit") AND (application.reinit eq "7660"))>
	<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
		<!--- load an init blog --->
		<cfset application.snapIns = StructNew()>
		<cfset application.snapIns.count = 0>
		<cfset application.snapIns.rootSnapIn = createObject("component","snapin.snapIns").init(application.snapIns)>
	
		<!--- all locale related --->
		<cfset application.resourceBundle = createObject("component","org.hastings.locale.resourcebundle")>
		<cfset application._fname = expandPath("includes/main")>
		<cfscript>
			application._fname = ReplaceNoCase(application._fname, 'includes\includes\', 'includes\');
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

<cfset instance = application.blog.instance>

<cfscript>
	Session.rejectedLogin = false;
	Session.rejectedInvalidLogin = false;
</cfscript>

<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
	<cfset Session.rejectedLogin = false>
	<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST") AND (isDefined("form.username")) and (isDefined("form.password")) and (len(trim(form.username))) and (len(trim(form.password)))>
		<cfscript>
			bool_isValid = application.blog.authenticate(left(trim(form.username),255),left(trim(form.password),50));
		</cfscript>
		<cfif (bool_isValid)>
			<cfscript>
				_sqlStatement = "SELECT id, uid, sessID FROM tblUsersSession WHERE (uid = #Request.qAuthUser.id#) AND (sessID <> #Session.sessID#)";
				Request.commonCode.safely_execSQL('Request.qCheckUsersSession', instance.dsn, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				}
				bool_isValid = ( (IsDefined("Request.qCheckUsersSession")) AND (Request.qCheckUsersSession.recordCount eq 0) );
			</cfscript>
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

				<cfscript>
					_sqlStatement = "INSERT INTO tblUsersSession (uid, sessID) VALUES (#Request.qAuthUser.id#,#Session.sessID#); SELECT @@IDENTITY as 'id';";
					Request.commonCode.safely_execSQL('Request.qFlagUsersSession', instance.dsn, _sqlStatement);
					if (Request.dbError) {
						Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
					}
				</cfscript>
				<cfmodule template="tags/scopecache.cfm" scope="db" clearall="true">		
			<cfelse>
				<cfset Session.rejectedLogin = true>
			</cfif>
		<cfelseif (FindNoCase("register.cfm", CGI.HTTP_REFERER) eq 0)>
			<cfscript>
				Session.rejectedInvalidLogin = true;
				Session.persistData.loginFailure = Session.persistData.loginFailure + 1;
			</cfscript>
		</cfif>
	</cfif>
</cflock>

<cfsetting enablecfoutputonly=false>

