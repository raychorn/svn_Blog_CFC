<cfcomponent>

	<cfinclude template="includes/cfinclude_explainError.cfm">
	<cfinclude template="includes/cfinclude_cflog.cfm">
	<cfinclude template="includes/cfinclude_cfdump.cfm">

	<cfscript>
		if (NOT IsDefined("This.name")) {
			aa = ListToArray(CGI.SCRIPT_NAME, '/');
			subName = aa[1];
			if (Len(subName) gt 0) {
				subName = '_' & subName;
			}

			myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
			myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
			This.name = UCASE(myAppName);
		}
	</cfscript>
	<cfset This.clientManagement = "Yes">
	<cfset This.sessionManagement = "Yes">
	<cfset This.sessionTimeout = CreateTimeSpan(0,1,0,0)>
	<cfset This.applicationTimeout = CreateTimeSpan(1,0,0,0)>
	<cfset This.clientStorage = "clientvars">
	<cfset This.loginStorage = "session">
	<cfset This.setClientCookies = "No">
	<cfset This.setDomainCookies = "No">
	<cfset This.scriptProtect = "All">

	<cfscript>
		this.cf_log = cf_log;
		this.cf_dump = cf_dump;

		function onError(Exception, EventName) {
			var errorExplanation = '';
			
			Request._explainError = _explainError;
			Request.explainError = explainError;
			Request.explainErrorWithStack = explainErrorWithStack;

			errorExplanation = Request.explainErrorWithStack(Exception, false);

			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				this.cf_log(Application.applicationname, 'Error', '[#EventName#] [#errorExplanation#]');
			}

			if ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) ) {
				if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
					writeOutput('<h2>An unexpected error occurred.</h2>');
					writeOutput('<p>Error Event: #EventName#</p>');
					writeOutput('<p>Error details:<br>');
					if (FindNoCase("laptop.halsmalltalker.com", CGI.SERVER_NAME) gt 0) {
						cf_dump(CGI, 'CGI Scope', false);
						cf_dump(FORM, 'FORM Scope', false);
						cf_dump(Exception, EventName, false);
					} else {
						writeOutput(Request.explainErrorWithStack(Exception, true));
					}
				}
			}
		}
	</cfscript>

	<cffunction name="onSessionStart">
	   <cfscript>
	      Session.started = now();
	      Session.shoppingCart = StructNew();
	      Session.shoppingCart.items =0;
	   </cfscript>
	      <cflock scope="Application" timeout="5" type="Exclusive">
	         <cfset Application.sessions = Application.sessions + 1>
	   </cflock>
		<cflog file="#Application.applicationName#" type="Information" text="Session #Session.sessionid# started. Active sessions: #Application.sessions#">
	</cffunction>

	<cffunction name="onSessionEnd">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>
	
		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cflock name="AppLock" timeout="5" type="Exclusive">
			<cfif (NOT IsDefined("Arguments.AppScope.sessions"))>
				<cfset ApplicationScope.sessions = 0>
			</cfif>
			<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>
		</cflock>

		<cflog file="#Arguments.AppScope.applicationName#" type="Information" text="Session #Arguments.SessionScope.sessionid# ended. Length: #sessionLength# Active sessions: #Arguments.AppScope.sessions#">
	</cffunction>

	<cffunction name="onApplicationStart" access="public">
		<cfif 0>
			<cftry>
				<!--- Test whether the DB is accessible by selecting some data. --->
				<cfquery name="testDB" dataSource="#Request.INTRANET_DS#">
					SELECT TOP 1 * FROM AvnUsers
				</cfquery>
				<!--- If we get a database error, report an error to the user, log the
				      error information, and do not start the application. --->
				<cfcatch type="database">
					<cfoutput>
						This application encountered an error<br>
						Unable to use the ColdFusion Data Source named "#Request.INTRANET_DS#"<br>
						Please contact support.
					</cfoutput>
					<cflog file="#This.Name#" type="error" text="#Request.INTRANET_DS# DSN is not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
					<cfreturn False>
				</cfcatch>
			</cftry>
		</cfif>

		<cflog file="#This.Name#" type="Information" text="Application Started">
		<!--- You do not have to lock code in the onApplicationStart method that sets
		      Application scope variables. --->
		<cfscript>
			Application.sessions = 0;
		</cfscript>
		<cfreturn True>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public">
		<cfargument name="ApplicationScope" required=true/>
		<cflog file="#This.Name#" type="Information" text="Application #Arguments.ApplicationScope.applicationname# Ended" >
	</cffunction>

	<cffunction name="onRequestStart" access="public">
		<cfargument name = "_targetPage" required=true/>
		
		<cfscript>
			Request.const_encryption_method = 'BLOWFISH';
			Request.const_encryption_encoding = 'Hex';

			Request.const_owners_blog_url = 'http://rayhorn.contentopia.net/blog/';
			Request.typeOf_emailsContent = 'HTML';
			
			Request.bool_isDebugUser = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );

			err_commonCode = false;
			err_commonCodeMsg = '';
			try {
			   Request.commonCode = CreateObject("component", "cfc.commonCode");
			} catch(Any e) {
				Request.commonCode = -1;
				err_commonCode = true;
				err_commonCodeMsg = '(1) The commonCode component has NOT been created.';
				writeOutput('<font color="red"><b>#err_commonCodeMsg#</b></font><br>');
		   		if (Request.bool_isDebugUser) writeOutput(cf_dump(e, 'Exception (e)', false));
			}
			
			Request.cf_log = Request.commonCode.cf_log;
			Request.cf_dump = Request.commonCode.cf_dump;
			Request._explainError = Request.commonCode._explainError;
			Request.explainError = Request.commonCode.explainError;
			Request.explainErrorWithStack = Request.commonCode.explainErrorWithStack;

			if (NOT IsDefined("session.loggedin")) {
				session.loggedin = false;
			}
		</cfscript>

		<cfscript>
			Request.const_blogURLMode_IIS = 'IIS';
			Request.const_blogURLMode_APACHE = 'APACHE';
			Request.const_blogURLMode_APACHE2 = 'APACHE2';
			if (FindNoCase(Request.const_blogURLMode_APACHE, CGI.SERVER_SOFTWARE) gt 0) {
				if ( (FindNoCase('\Apache2\htdocs\', CGI.PATH_TRANSLATED) gt 0) OR (FindNoCase('C:\Inetpub\wwwroot\', CGI.PATH_TRANSLATED) gt 0) ) {
					Request.blogURLMode = Request.const_blogURLMode_APACHE2;
				} else {
					Request.blogURLMode = Request.const_blogURLMode_APACHE;
				}
			} else {
				Request.blogURLMode = Request.const_blogURLMode_IIS;
			}
			Request.overrideServerMode = false;
			Request.ezClusterServerMode = true;
			
			temporalIndex = '#GetTickCount()#';
			Randomize(Right(temporalIndex, Min(Len(temporalIndex), 9)), 'SHA1PRNG');
		</cfscript>
		
		<cfscript>
			allowedReferers = 'google.com,google.de,google.com.au,yahoo.com,macromedia.com,contentopia.net,halsmalltalker.com,postami.com';
		</cfscript>

		<cfscript>
			bool_isInvalidReferral = false;
			if (Len(CGI.HTTP_REFERER) gt 0) {
				bool_isInvalidReferral = true;
				ar_allowedReferers = ListToArray(allowedReferers, ',');
				n = ArrayLen(ar_allowedReferers);
				for (i = 1; i lte n; i = i + 1) {
					if (FindNoCase(ar_allowedReferers[i], CGI.HTTP_REFERER) gt 0) {
						bool_isInvalidReferral = false;
						break;
					}
				}
			}
		</cfscript>

		<cfset Request.bool_applicationCFC_mode = true>
		<cfif 0>
			<cfset application.reinit = "7660">
		</cfif>
		<cfinclude template="original_Application.cfm">

		<cfif (NOT bool_isInvalidReferral)>
			<cfset dbError = false>
			<cftry>
				<cfquery name="qIsIPAddrFromPastViolation" datasource="#instance.dsn#">
					<cfoutput>
						SELECT COUNT(REMOTE_ADDR) as cnt
						FROM tblCopyrightViolations
						WHERE (REMOTE_ADDR = '#CGI.REMOTE_ADDR#')
					</cfoutput>
				</cfquery>
			
				<cfcatch type="Any">
					<cfset dbError = true>
				</cfcatch>
			</cftry>
			
			<cfset Request.ipAddressWasPreviouslyAbused = false>
			<cfif (NOT dbError) AND (IsDefined("qIsIPAddrFromPastViolation.cnt"))>
				<cfif (qIsIPAddrFromPastViolation.cnt gt 0)>
					<cfset Request.ipAddressWasPreviouslyAbused = true>
					<cfset bool_isInvalidReferral = true>
				</cfif>
			</cfif>
		</cfif>		
		
		<cfif (bool_isInvalidReferral) AND (FindNoCase("/rss.cfm", CGI.SCRIPT_NAME) eq 0)>
			<cfinclude template="invalid_refereral_handler.cfm">
			<cfreturn False>
		</cfif>

		<!--- Security Related --->
		<cfif isDefined("url.logout") and isLoggedIn()>
			<cfset structDelete(session,"loggedin")>
			<cfset session.loggedin = false>
			<cflogout>
		</cfif>
		
		<cfif (isDefined("url.designmode") AND (url.designmode eq "7660")) AND (not session.loggedin)>
			<cfsetting enablecfoutputonly=false>
			<cfinclude template="login.cfm">
			<cfreturn False>
		</cfif>

		<cfreturn True>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>
	</cffunction>
</cfcomponent>
<!---  --->


