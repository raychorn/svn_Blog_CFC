<cfprocessingdirective pageencoding="utf-8">

<cfset statusMsg = "">
<cfset showForm = true>

<cfif (IsDefined("FORM.USERNAME")) AND (IsDefined("FORM.YOURNAME")) AND (IsDefined("FORM.PASSWORD")) AND (IsDefined("FORM.CONFIRMPASSWORD"))>
	<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
		<cfset instance = application.blog.instance>
	</cfif>

	<cfset _urlValidateLink = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("validateUserAccount/#FORM.USERNAME#/", false), true)>

	<cfscript>
		ar = ListToArray(_urlValidateLink, '?');
		ar[2] = '/';
		_urlValidateLink = ArrayToList(ar, '');
	</cfscript>
	
	<cfsavecontent variable="registerNotice">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H3>This is your User Account Validation Email from #instance.blogTitle#</H3>

<p align="justify" style="font-size: 10px;"><small>
Click <a href="#_urlValidateLink#" target="_blank">HERE</a> to validate your user account.
</small>
</p>

</body>
</html>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		_sqlStatement = "INSERT INTO tblUsers (username, uName, password, uRole, isValid) VALUES ('#Request.commonCode.filterQuotesForSQL(FORM.USERNAME)#','#Request.commonCode.filterQuotesForSQL(FORM.YOURNAME)#','#Request.commonCode.encodedEncryptedString(Request.commonCode.filterQuotesForSQL(FORM.PASSWORD))#','User',0); SELECT @@IDENTITY as 'id';";
		Request.commonCode.safely_execSQL('Request.qAddBlogUser', instance.dsn, _sqlStatement);
		if ( (Request.dbError) AND (NOT Request.isPKviolation) ) {
			writeOutput('<span class="errorBoldPrompt">#Request.explainErrorHTML#</span>');
			Request.commonCode.cf_log(Application.applicationname, 'Information', '[#Request.explainErrorText#]');
			statusMsg = statusMsg & Request.explainErrorHTML;
		} else {
			showForm = false;
			if (Request.isPKviolation) {
				statusMsg = statusMsg & '<span class="errorBoldPrompt">Warning: PLS do not Register more than once.  It appears you have already Registered.  Kindly refer to the Account Activation EMail you received and follow the instructons to Activate your User Account.</span>';
			}
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
		<form id="form_register_newUser" action="#Request.commonCode.makeLinkToSelf('_index.cfm', true)#" method="post" enctype="application/x-www-form-urlencoded">
		<!--- copy additional fields --->
		<cfloop item="field" collection="#form#">
			<!--- the isSimpleValue is probably a bit much.... --->
			<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
				<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
			</cfif>
		</cfloop>
		<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("_index.cfm", false), true)>
		<table width="100%">
			<tr>
				<td width="15%"><b>#application.resourceBundle.getResource("username")#</b></td>
				<td width="*"><input type="text" id="register_input_username" name="username" value="" size="50" maxlength="255">&nbsp;<span class="redBoldPrompt">(Required - Your Valid Internet Email Address)</span></td>
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
				<td width="15%"><input type="submit" disabled class="buttonClass" id="button_registerSubmit" value="#application.resourceBundle.getResource("register")#" onclick="delayedButtonDisablerByID(this.id, 'form_register_newUser'); return false;"></td>
				<td width="*"><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_url#'; this.disabled = true; window.location.href = _url; return false;"></td>
			</tr>
			<tr>
				<td colspan="2">
					<span id="span_register_newUser_status_message" class="onholdStatusBoldClass"></span>
				</td>
			</tr>
		</table>
		</form>
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
