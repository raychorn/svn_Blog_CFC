<cfcomponent>

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

	<cffunction name="cf_log" access="public">
		<cfargument name="_someText_" type="string" required="yes">
		
		<cflog file="#Application.applicationName#" type="Information" text="#_someText_#">
	</cffunction>

	<cffunction name="cf_dump" access="public">
		<cfargument name="_aVar_" type="any" required="yes">
		<cfargument name="_aLabel_" type="string" required="yes">
		<cfargument name="_aBool_" type="boolean" default="False">
		
		<cfif (_aBool_)>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="Yes">
		<cfelse>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="No">
		</cfif>
	</cffunction>

	<cfscript>
		this.cf_log = cf_log;
		this.cf_dump = cf_dump;

		function _explainError(_error, bool_asHTML, bool_includeStackTrace) {
			var e = '';
			var v = '';
			var vn = '';
			var i = -1;
			var k = -1;
			var bool_isError = false;
			var sCurrent = -1;
			var sId = -1;
			var sLine = -1;
			var sColumn = -1;
			var sTemplate = -1;
			var nTagStack = -1;
			var sMisc = '';
			var sMiscList = '';
			var _content = '<ul>';
			var _ignoreList = '<remoteAddress>, <browser>, <dateTime>, <HTTPReferer>, <diagnostics>, <TagContext>';
			var _specialList = '<StackTrace>';
			var content_specialList = '';
			var aToken = '';
			var special_templatesList = ''; // comma-delimited list or template keywords

			if (NOT IsBoolean(bool_asHTML)) {
				bool_asHTML = false;
			}
			
			if (NOT IsBoolean(bool_includeStackTrace)) {
				bool_includeStackTrace = false;
			}
			
			if (NOT bool_asHTML) {
				_content = '';
			}

			for (e in _error) {
				if (FindNoCase('<#e#>', _ignoreList) eq 0) {
					try {
						if (0) {
							v = '--- UNKNOWN --';
							vn = "_error." & e;
			
							if (IsDefined(vn)) {
								v = Evaluate(vn);
							}
						} else {
							v = _error[e];
						}
					} catch (Any ee) {
						v = '--- ERROR --';
					}
	
					if (FindNoCase('<#e#>', _specialList) neq 0) {
						if (NOT bool_asHTML) {
							content_specialList = content_specialList & '#e#=#v#, ';
						} else {
							v = '<textarea cols="100" rows="20" readonly style="font-size: 10px;">#v#</textarea>';
							content_specialList = content_specialList & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					} else if (IsSimpleValue(v)) {
						if (NOT bool_asHTML) {
							_content = _content & '#e#=#v#,';
						} else {
							_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					}
				}
			}
			if (bool_includeStackTrace) {
				nTagStack = ArrayLen(_error.TAGCONTEXT);
				if (NOT bool_asHTML) {
					_content = _content &	'The contents of the tag stack are: nTagStack = [#nTagStack#], ';
				} else {
					_content = _content &	'<li><p><b>The contents of the tag stack are: nTagStack = [#nTagStack#] </b>';
				}
				if (nTagStack gt 0) {
					for (i = 1; i neq nTagStack; i = i + 1) {
						bool_isError = false;
						try {
							sCurrent = _error.TAGCONTEXT[i];
						} catch (Any e2) {
							bool_isError = true;
							break;
						}
						if (NOT bool_isError) {
							sMiscList = '';
							for (sMisc in sCurrent) {
								if (NOT bool_asHTML) {
									sMiscList = ListAppend(sMiscList, ' [#sMisc#=#sCurrent[sMisc]#] ', ' | ');
								} else {
									sMiscList = sMiscList & '<b><small>[#sMisc#=#sCurrent[sMisc]#]</small></b><br>';
								}
							}
							if (NOT bool_asHTML) {
								_content = _content & sMiscList & '.';
							} else {
								_content = _content & '<br>' & sMiscList & '.';
							}
						}
					}
				}
				if (bool_asHTML) {
					_content = _content & '</p></li>';
				}
				_content = _content & content_specialList;
				if (bool_asHTML) {
					_content = _content & '</ul>';
				} else {
					_content = _content & ',';
				}
			}
			
			return _content;
		}

		function explainError(_error, bool_asHTML) {
			return Request._explainError(_error, bool_asHTML, false);
		}

		function explainErrorWithStack(_error, bool_asHTML) {
			return Request._explainError(_error, bool_asHTML, true);
		}
		
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
			Request.cf_log = this.cf_log;
			Request.cf_dump = this.cf_dump;
			Request._explainError = _explainError;
			Request.explainError = explainError;
			Request.explainErrorWithStack = explainErrorWithStack;

			Request.const_encryption_method = 'BLOWFISH';
			Request.const_encryption_encoding = 'Hex';

			Request.const_owners_blog_url = 'http://rayhorn.contentopia.net/blog/';
			Request.typeOf_emailsContent = 'HTML';
			
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
		</cfscript>
		
		<cfscript>
			allowedReferers = 'google.com,google.de,yahoo.com,macromedia.com,contentopia.net,halsmalltalker.com';
		</cfscript>

		<cfset newList = "">
		<cfif (Len(CGI.HTTP_REFERER) gt 0)>
			<cfset newList = ListGetAt(CGI.HTTP_REFERER, 2, "/")>
			<cfset num = ListLen(newList, ".")>
			<cfscript>
				for (i = 1; i lte num - 2; i = i + 1) {
					newList = ListDeleteAt(newList, 1, ".");
				}
			</cfscript>
		</cfif>

		<cfset Request.bool_applicationCFC_mode = true>
		<cfset application.reinit = "7660">
		<cfinclude template="original_Application.cfm">
		
		<cfif (Len(CGI.HTTP_REFERER) gt 0) AND (ListFindNoCase(allowedReferers, newList, ",") eq 0) AND (FindNoCase("/rss.cfm", CGI.SCRIPT_NAME) eq 0)>
			<cfinclude template="invalid_refereral_handler.cfm">
			<cfreturn False>
		</cfif>
		
		<cfreturn True>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>
	</cffunction>
</cfcomponent>
<!---  --->


