<cfprocessingdirective pageencoding="utf-8">

<cfparam name="statusMsg" type="string" default="">
<cfparam name="showForm" type="boolean" default="true">

<cfif (IsDefined("session.persistData.registerStatus"))>
	<cfscript>
		if (Len(session.persistData.registerStatus) gt 0) {
			ar = ListToArray(session.persistData.registerStatus, '&');
			arN = ArrayLen(ar);
			for (i = 1; i lte arN; i = i + 1) {
				ar2 = ListToArray(ar[i], '=');
				arN2 = ArrayLen(ar2);
				if (arN2 eq 2) {
					if (ar2[1] is 'statusMsg') {
						statusMsg = URLDecode(ar2[2]);
					} else if (ar2[1] is 'showForm') {
						showForm = URLDecode(ar2[2]);
					}
				}
			}
		}
		StructDelete(session.persistData, 'registerStatus');
	</cfscript>
</cfif>

<cfsavecontent variable="registerForm">
	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("registerform")#</div>
	<div id="body_register_newUser" class="body" style="display: inline;">
	<cfif (showForm)>
		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'ssl/ssl-register.cfm', '/'))>
		<cfset _urlHomePage = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'register.cfm', '/'))>
		<cfif (Request.bool_isDebugMode)>
			<small>_urlHomePage = [#_urlHomePage#]</small><br>
		</cfif>
		<cfmodule template="tags/secureForm.cfm" formName="form_register_newUser" action="#_url#">
			<!--- copy additional fields --->
			<cfloop item="field" collection="#form#">
				<!--- the isSimpleValue is probably a bit much.... --->
				<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
					<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
				</cfif>
			</cfloop>
			<input type="hidden" name="redirectURL" value="#_urlHomePage#">
			<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
			<table width="100%">
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("username")#</b></td>
					<td width="*"><input type="text" id="register_input_username" name="username" value="" size="50" maxlength="255" onkeyup="var obj = $('register_input_password'); var thisValue = ''; var obj2 = $('register_input_confirmpassword'); var otherValue = ''; if (obj != null) { thisValue = obj.value; }; if (obj2 != null) { otherValue = obj2.value; }; return (isValidatedRegisterUserName() || validatePassword(thisValue, otherValue));">&nbsp;<span class="redBoldPrompt">(Required - Your Valid Internet Email Address)</span></td>
				</tr>
				<tr>
					<td width="15%"><b>#application.resourceBundle.getResource("yourname")#</b></td>
					<td width="*"><input type="text" id="register_input_yourname" name="yourname" value="" size="30" maxlength="50" onkeyup="return isValidatedRegisterUsersName();">&nbsp;<span class="redBoldPrompt">(Required - Your Name, first name and last name with a space between.)</span></td>
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
					<cfif (IsDefined("Register.secureFormAction"))>
						<cfset _url = Register.secureFormAction>
					</cfif>
					<td width="15%"><input type="submit" disabled class="buttonClass" id="button_registerSubmit" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="#application.resourceBundle.getResource("register")#" onclick="if (!!performSubmitRegisterForm) { performSubmitRegisterForm(this, 'iframe_sslInterface_form_register_newUser', '#_url#'); }; return false;"></td> <!--- if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_register_newUser'); }; --->
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
	</div>

	<div id="div_register_newUser_status">
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
