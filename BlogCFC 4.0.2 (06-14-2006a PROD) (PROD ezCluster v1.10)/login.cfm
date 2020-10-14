<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : November 10, 2003
	History      : Multiple changes (rkc 11/10/03)
	Purpose		 : Login form
--->

<cfparam name="isUsingAJAX" type="boolean" default="#(FindNoCase('/AJAX-Framework/', CGI.HTTP_REFERER) gt 0)#">

<cfparam name="mode" type="string" default="">

<cffunction name="loginForm" output="Yes" returntype="string">
	<cfoutput>
	<div class="date"><cfif (mode eq "")>#application.resourceBundle.getResource("loginform")#<cfelse>#application.resourceBundle.getResource("forgotpassword")#</cfif></div>
	<div class="body">
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'ssl/ssl-login.cfm', '/'))>
	<cfset _urlHomePage = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'original_index.cfm', '/'))>
	<cfif (mode eq "")>
		<cfmodule template="tags/secureForm.cfm" formName="form_login_returningUser" action="#_url#" target="iframe_loginUser">
			<!--- copy additional fields --->
			<cfloop item="field" collection="#form#">
				<!--- the isSimpleValue is probably a bit much.... --->
				<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
					<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
				</cfif>
			</cfloop>
			<input type="hidden" name="redirectURL" value="#_urlHomePage#">
			<input type="hidden" name="_callingServer" value="#Request.commonCode._clusterizeURL('http://' & CGI.SERVER_NAME)#">
			<input type="hidden" name="_appName" value="#Application.applicationName#">
			<input type="hidden" name="_sessionID" value="#Session.sessID#">
			<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
			<table width="100%">
				<tr>
					<td><b>#application.resourceBundle.getResource("username")#</b></td>
					<td><input type="text" name="username" id="login_input_username" size="50" maxlength="255" onkeyup="if (!!validateLoginUserName) { validateLoginUserName() };"></td>
				</tr>
				<tr>
					<td><b>#application.resourceBundle.getResource("password")#</b></td>
					<td><input type="password" name="password" id="login_input_password" size="30" maxlength="50"></td>
				</tr>
				<tr>
					<td>
						<cfset _jsCode = "if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_login_returningUser'); };">
						<cfif (isUsingAJAX)>
							<cfset _jsCode = "this.disabled = true; if (!!parent.performSubmitLoginForm) { var iObj1 = $('login_input_username'); var iObj2 = $('login_input_password'); parent.performSubmitLoginForm(iObj1.value, iObj2.value); } else { alert('Cannot submit this dialog due to a technical issue that will be resolved soon.'); };">
						</cfif>
						<input type="submit" disabled class="buttonClass" id="button_loginSubmit" value="#application.resourceBundle.getResource("login")#" onclick="#_jsCode# return false;">
					</td>
					<td>
						<cfset _jsCode = "var _url = '#_urlHomePage#'; this.disabled = true; window.location.href = _url;">
						<cfif (isUsingAJAX)>
							<cfset _jsCode = "if (!!parent.performCloseLoginRegisterWindow) { parent.performCloseLoginRegisterWindow(); } else { alert('Cannot dismiss this dialog due to a technical issue that will be resolved soon.'); };">
						</cfif>
						<input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="#_jsCode# return false;">
					</td>
				</tr>
			</table>
			<div id="div_ssl_login_status" style="display: none;"></div>
		</cfmodule>
	</cfif>
	<iframe id="iframe_loginUser" name="iframe_loginUser" frameborder="0" width="100%" height="275" scrolling="Auto" style="display: none;"></iframe>
	<cfif ( (mode eq "forgotPassword") OR ( (IsDefined("URL.loginFailure")) AND (URL.loginFailure gt 0) ) OR ( (IsDefined("Session.persistData.loginFailure")) AND (Session.persistData.loginFailure gt 0) ) )>
		<cfif ( (IsDefined("Session.persistData.loginFailure")) AND (mode eq "") )>
			<br><br>
			<h5 align="left" style="color: red;">You have made #Session.persistData.loginFailure# unsuccessful Login Attempts.  Are you sure you know your correct password ?</h5>
		</cfif>

		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'forgotPassword.cfm', '/'))>
		<cfmodule template="tags/secureForm.cfm" formName="form_login_forgotPassword" action="#_url#" secure="false">
			<table width="100%">
				<tr>
					<td><b>#application.resourceBundle.getResource("username")#</b></td>
					<td><input type="text" name="input_username" id="input_forgot_username" size="50" maxlength="255" onkeyup="if (!!validateForgotPasswordUserName) { validateForgotPasswordUserName() };"></td>
				</tr>
				<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
				<tr>
					<td>
						<cfset _jsCode = "if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_login_forgotPassword'); };">
						<cfif (isUsingAJAX)>
							<cfset _jsCode = "this.disabled = true; if (!!parent.performSubmitForgotPasswordForm) { var iObj1 = $('input_forgot_username'); parent.performSubmitForgotPasswordForm(iObj1.value); } else { alert('Cannot submit this dialog due to a technical issue that will be resolved soon.'); };">
						</cfif>
						<input type="submit" class="buttonClass" id="button_forgotPwdSubmit" value="#application.resourceBundle.getResource("forgotpassword")#" onclick="#_jsCode# return false;">
					</td>
					<td>
						<cfset _jsCode = "var _url = '#_urlHomePage#'; this.disabled = true; window.location.href = _url;">
						<cfif (isUsingAJAX)>
							<cfset _jsCode = "if (!!parent.performCloseLoginRegisterWindow) { parent.performCloseLoginRegisterWindow(); } else { alert('Cannot dismiss this dialog due to a technical issue that will be resolved soon.'); };">
						</cfif>
						<input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="#_jsCode# return false;">
					</td>
				</tr>
			</table>
		</cfmodule>
	</cfif>
	<script language="JavaScript1.2" type="text/javascript">
		try {
			var oObj = $('login_input_username');
			if (!!oObj) {
				oObj.focus();
			}
		} catch(e) {
		} finally {
		}
	</script>
	</div>
	</cfoutput>
</cffunction>

<cfif (Session.persistData.loginFailure lte 3)>
	<cfif not isDefined("hideLayout")>
	
		<cfmodule template="tags/layout.cfm">
			<cfoutput>#loginForm()#</cfoutput>
		</cfmodule>
		
	<cfelse>
		
		<cfoutput>#loginForm()#</cfoutput>
		
	</cfif>
<cfelse>
	<cfsavecontent variable="loginForm">
		<cfoutput>
			<h2 align="center" style="color: red">Too Many Unsuccessful Login Attempts... Try Back later on however be sure you Activated your User Account using the Link you received via email.</h2>
		</cfoutput>
	</cfsavecontent>

	<cfif not isDefined("hideLayout")>
	
		<cfmodule template="tags/layout.cfm">
			<cfoutput>#loginForm#</cfoutput>
		</cfmodule>
		
	<cfelse>
		
		<cfoutput>#loginForm#</cfoutput>
		
	</cfif>
</cfif>
