<cfprocessingdirective pageencoding="utf-8">

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

	<cfset _urlValidateLink = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'validateUserAccount/#FORM.USERNAME#/', '/') & '?' & _uuid>
	
	<cfsavecontent variable="registerNotice">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H3>This is your User Account Validation Email from #instance.blogTitle#</H3>

<H5 style="color: blue;">You have 24 hrs to Validate your User Account.</H5>

<p align="justify" style="font-size: 10px;"><small>
Click <a href="#_urlValidateLink#" target="_blank" <cfif isDebugMode()>title="_url = [#_urlValidateLink#]"</cfif>>HERE</a> to validate your user account.
</small>
</p>

</body>
</html>
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
			statusMsg = statusMsg & '<br><br><a href="#Request.commonCode.makeLinkToSelf('_index.cfm', false)#">Click HERE to continue...</a>';
		}
	</cfscript>
</cfif>

<cfsavecontent variable="registerForm">
	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("registerform")#</div>
	<div class="body">
	<cfif (showForm)>
		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#')>
		<cfmodule template="tags/secureForm.cfm" formName="form_register_newUser" action="#_url#">
			<!--- copy additional fields --->
			<cfloop item="field" collection="#form#">
				<!--- the isSimpleValue is probably a bit much.... --->
				<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
					<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
				</cfif>
			</cfloop>
			<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
			<table width="100%">
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("username")#</b></td>
					<td width="*"><input type="text" id="register_input_username" name="username" value="" size="50" maxlength="255" onkeyup="var obj = $('register_input_password'); var thisValue = ''; var obj2 = $('register_input_confirmpassword'); var otherValue = ''; if (obj != null) { thisValue = obj.value; }; if (obj2 != null) { otherValue = obj2.value; }; return validatePassword(thisValue, otherValue);">&nbsp;<span class="redBoldPrompt">(Required - Your Valid Internet Email Address)</span></td>
				</tr>
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("yourname")#</b></td>
					<td width="*"><input type="text" id="register_input_yourname" name="yourname" value="" size="30" maxlength="50">&nbsp;<span class="redBoldPrompt">(Required - Your Name of Nick Name, may also use Screen Name)</span></td>
				</tr>
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("password")#</b></td>
					<td width="*">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td width="40%" align="left">
									<input type="password" name="password" id="register_input_password" value="" size="30" maxlength="50" onkeyup="return validatePassword(this.value);">&nbsp;<span class="redBoldPrompt">(Required)</span>
								</td>
								<td id="td_password_rating" width="*" align="center" style="border: thin solid silver;">
									<div id="div_password_rating"><span id="span_password_rating" class="normalBoldBluePrompt">(Not Rated)</span></div>
								</td>
								<td width="40%">
									&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("confirmpassword")#</b></td>
					<td width="*">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td width="40%" align="left">
									<input type="password" name="confirmpassword" id="register_input_confirmpassword" value="" size="30" maxlength="50" onkeyup="var obj = $('register_input_password'); otherValue = ''; if (obj != null) { otherValue = obj.value; }; return validatePassword(this.value, otherValue);">&nbsp;<span class="redBoldPrompt">(Required)</span>
								</td>
								<td id="td_password_matches" width="*" align="center" style="border: thin solid silver;">
									<div id="div_password_matches"><span id="span_password_matches" class="redBoldPrompt">&nbsp;(Does Not Match)</span></div>
								</td>
								<td width="40%">
									&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="15%"><input type="submit" disabled class="buttonClass" id="button_registerSubmit" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="#application.resourceBundle.getResource("register")#" onclick="if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_register_newUser'); }; return false;"></td>
					<cfset _cancelURL = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, '/')#/_index.cfm')>
					<td width="*"><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_cancelURL#'; this.disabled = true; window.location.href = _url; return false;"></td>
				</tr>
				<tr>
					<td colspan="2">
						<span id="span_register_newUser_status_message" class="onholdStatusBoldClass"></span>
					</td>
				</tr>
			</table>
		</cfmodule>
		<script language="JavaScript1.2" type="text/javascript">
			try {
				var oObj = $('register_input_username');
				if (!!oObj) {
					oObj.focus();
				}
			} catch(e) {
			} finally {
			}
		</script>
	</cfif>
	<br><br>#statusMsg#
	</div>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>
	<cfmodule template="tags/layout.cfm">
		<cfoutput>#registerForm#</cfoutput>
	</cfmodule>
<cfelse>
	<cfoutput>#registerForm#</cfoutput>
</cfif>
