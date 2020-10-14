<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfoutput>
	<html>
	<head>
		<title>SSL Register</title>
	</head>
	
	<body>
	
		<cfif (isDebugMode()) OR 1>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="center" valign="top">
						<cfdump var="#Application#" label="App Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#Session#" label="Session Scope [#Session.sessID#]" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#Request#" label="Request Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#CGI#" label="CGI Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#FORM#" label="FORM Scope" expand="No">
					</td>
					<td align="center" valign="top">
						<cfdump var="#URL#" label="URL Scope" expand="No">
					</td>
				</tr>
			</table>
		</cfif>
	
		<cfset statusMsg = "">
		<cfset showForm = true>
		
		<cfif (IsDefined("FORM.USERNAME")) AND (IsDefined("FORM.YOURNAME")) AND (IsDefined("FORM.PASSWORD")) AND (IsDefined("FORM.CONFIRMPASSWORD"))>
			<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
				<cfset instance = application.blog.instance>
			</cfif>
			
			<cfscript>
				_uuid = CreateUUID();
		
				_sqlStatement = "INSERT INTO tblUsers (username, uName, password, uRole, isValid) VALUES ('#Request.commonCode.filterQuotesForSQL(FORM.USERNAME)#','#Request.commonCode.filterQuotesForSQL(FORM.YOURNAME)#','#Request.commonCode.encodedEncryptedString(Request.commonCode.filterQuotesForSQL(FORM.PASSWORD))#','User',0); SELECT @@IDENTITY as 'id';";
				Request.commonCode.safely_execSQL('Request.qAddBlogUser', instance.dsn, _sqlStatement);
				if ( (Request.dbError) AND (NOT Request.isPKviolation) ) {
					if (isDebugMode()) writeOutput('<span class="errorBoldPrompt">#Request.explainErrorHTML#</span>');
					Request.commonCode.cf_log(Application.applicationname, 'Information', '[#Request.explainErrorText#]');
					statusMsg = statusMsg & Request.explainErrorHTML;
				} else {
					showForm = false;
					if (Request.isPKviolation) {
						statusMsg = statusMsg & '<span class="errorBoldPrompt">Warning: PLS do not Register more than once.  It appears you have already Registered.  Kindly refer to the Account Activation EMail you received and follow the instructons to Activate your User Account.</span>';
					}
		
					_sqlStatement = "SELECT id FROM tblUsers WHERE (username = '#Request.commonCode.filterQuotesForSQL(FORM.USERNAME)#')";
					Request.commonCode.safely_execSQL('Request.qGetUserID', instance.dsn, _sqlStatement);
					if (Request.dbError) {
						Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
					} else if ( (IsDefined("Request.qGetUserID")) AND (IsQuery(Request.qGetUserID)) AND (Request.qGetUserID.recordCount gt 0) ) {
						_sqlStatement = "INSERT INTO tblUsersAccountValidation (uid, endDate, uuid) VALUES (#Request.qGetUserID.id#,DateAdd(day,1,GetDate()),'#_uuid#'); SELECT @@IDENTITY as 'id';";
						Request.commonCode.safely_execSQL('Request.qGetAccountValidation', instance.dsn, _sqlStatement);
						if (Request.dbError) {
							Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
						}
					}
				}
			</cfscript>
		
			<cfset _urlValidateLink = Request.commonCode.clusterizeURL('http://rabid.contentopia.net') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/validateUserAccount/#FORM.USERNAME#/' & '?' & _uuid>
			
			<cfsavecontent variable="registerNotice">
				<cfoutput>
					<cfmodule template="../tags/singleTabbedContent.cfm" tabTitle="Validation Email">
						<H3>This is your User Account Validation Email from #instance.blogTitle#</H3>
						
						<H5 style="color: blue;">You have 24 hrs to Validate your User Account.</H5>
						
						<p align="justify" style="font-size: 10px;"><small>
						Click <a href="#_urlValidateLink#" target="_blank" <cfif isDebugMode()>title="_url = [#_urlValidateLink#]"</cfif>>HERE</a> to validate your user account.
						</small>
						</p>
					</cfmodule>
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				if (NOT showForm) {
					Request.commonCode.safely_cfmail(FORM.USERNAME, 'do-not-respond@contentopia.net', 'User Account Validation EMail from #instance.blogTitle#', registerNotice);
					if (NOT Request.anError) {
						statusMsg = statusMsg & '<span class="normalBoldBluePrompt">Your Account Validation Email has been sent to your email address.  If you did not receive this email you will need to create a new user account.</span>';
					} else {
						statusMsg = statusMsg & '<span class="errorBoldPrompt">#Request.errorMsg#</span>';
					}
					Request.commonCode.safely_cfmail('raychorn@hotmail.com', 'do-not-respond@contentopia.net', 'Notice: User Account Validation EMail from #instance.blogTitle#', registerNotice);
					_url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://rabid.contentopia.net') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main');
					statusMsg = statusMsg & '<br><br><a href="#_url#">Click HERE to continue...</a>';
				}
			</cfscript>
		</cfif>

		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://rabid.contentopia.net') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'original_index.cfm', '/'))>
		<cfif (IsDefined("FORM.redirectURL")) AND (Len(Trim(FORM.redirectURL)) gt 0)>
			<cfset _url = FORM.redirectURL>
		</cfif>
	
		<cfscript>
			Request.commonCode.commitSessionToDb();
		</cfscript>

		<script language="JavaScript1.2" type="text/javascript">
			if (!!parent.receiveRegisterData) {
				parent.receiveRegisterData('&statusMsg=#URLEncodedFormat(statusMsg)#&showForm=#showForm#');
			}
		</script>
	
	</body>
	</html>

</cfoutput>
