<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : November 10, 2003
	History      : Multiple changes (rkc 11/10/03)
	Purpose		 : Login form
--->

<cffunction name="loginForm" output="Yes" returntype="string">
	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("loginform")#</div>
	<div class="body">
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'ssl-login.cfm', '/'))>
	<cfset _urlHomePage = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
	<cfmodule template="tags/secureForm.cfm" formName="form_login_returningUser" action="#_url#">
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
				<td><b>#application.resourceBundle.getResource("username")#</b></td>
				<td><input type="text" name="username" id="login_input_username" size="50" maxlength="255" onkeyup="if (!!validateLoginUserName) { validateLoginUserName() };"></td>
			</tr>
			<tr>
				<td><b>#application.resourceBundle.getResource("password")#</b></td>
				<td><input type="password" name="password" size="30" maxlength="50"></td>
			</tr>
			<tr>
				<td><input type="submit" disabled class="buttonClass" id="button_loginSubmit" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="#application.resourceBundle.getResource("login")#" onclick="if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_login_returningUser'); }; return false;"></td>
				<td><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_urlHomePage#'; this.disabled = true; window.location.href = _url; return false;"></td>
			</tr>
		</table>
	</cfmodule>
	<cfif ( (IsDefined("URL.loginFailure")) AND (URL.loginFailure gt 0) ) OR ( (IsDefined("Session.persistData.loginFailure")) AND (Session.persistData.loginFailure gt 0) )>
		<br><br>
		<cfif (IsDefined("Session.persistData.loginFailure"))>
			<h5 align="left" style="color: red;">You have made #Session.persistData.loginFailure# unsuccessful Login Attempts.  Are you sure you know your correct password ?</h5>
		</cfif>

		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'forgotPassword.cfm', '/'))>
		<cfmodule template="tags/secureForm.cfm" formName="form_login_forgotPassword" action="#_url#">
			<table width="100%">
				<tr>
					<td><b>#application.resourceBundle.getResource("username")#</b></td>
					<td><input type="text" name="input_username" id="login_input_username" size="50" maxlength="255"></td>
				</tr>
				<cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif>
				<tr>
					<td><input type="submit" class="buttonClass" id="button_forgotPwdSubmit" value="#application.resourceBundle.getResource("forgotpassword")#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="if (!!delayedButtonDisablerByID) { delayedButtonDisablerByID(this.id, 'form_login_forgotPassword'); }; return false;"></td>
					<td><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_urlHomePage#'; this.disabled = true; window.location.href = _url; return false;"></td>
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
