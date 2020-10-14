<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : November 10, 2003
	History      : Multiple changes (rkc 11/10/03)
	Purpose		 : Login form
--->

<cfif (session.loginFailure lte 3)>
	<cfsavecontent variable="loginForm">
	
		<cfoutput>
		<div class="date">#application.resourceBundle.getResource("loginform")#</div>
		<div class="body">
		<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("_index.cfm", false), false)>
		<form id="form_login_returningUser" action="#_url#" method="post" enctype="application/x-www-form-urlencoded">
		<!--- copy additional fields --->
		<cfloop item="field" collection="#form#">
			<!--- the isSimpleValue is probably a bit much.... --->
			<cfif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
				<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
			</cfif>
		</cfloop>
		<table width="100%">
			<tr>
				<td><b>#application.resourceBundle.getResource("username")#</b></td>
				<td><input type="text" name="username" id="login_input_username" size="50" maxlength="255"></td>
			</tr>
			<tr>
				<td><b>#application.resourceBundle.getResource("password")#</b></td>
				<td><input type="password" name="password" size="30" maxlength="50"></td>
			</tr>
			<tr>
				<td><input type="submit" class="buttonClass" id="button_loginSubmit" value="#application.resourceBundle.getResource("login")#" onclick="delayedButtonDisablerByID(this.id, 'form_login_returningUser'); return false;"></td>
				<td><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_url#'; this.disabled = true; window.location.href = _url; return false;"></td>
			</tr>
		</table>
		</form>
		<cfif ( (IsDefined("URL.loginFailure")) AND (URL.loginFailure gt 0) ) OR ( (IsDefined("Session.loginfailure")) AND (Session.loginfailure gt 0) )>
			<br><br>
			<cfif (IsDefined("Session.loginfailure"))>
				<h5 align="left" style="color: red;">You have made #Session.loginfailure# unsuccessful Login Attempts.  Are you sure you know your correct password ?</h5>
			</cfif>
			<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("forgotPassword.cfm", false), false)>
			<form id="form_login_forgotPassword" action="#_url#" method="post" enctype="application/x-www-form-urlencoded">
				<table width="100%">
					<tr>
						<td><b>#application.resourceBundle.getResource("username")#</b></td>
						<td><input type="text" name="input_username" id="login_input_username" size="50" maxlength="255"></td>
					</tr>
					<tr>
						<td><input type="submit" class="buttonClass" id="button_forgotPwdSubmit" value="#application.resourceBundle.getResource("forgotpassword")#" onclick="delayedButtonDisablerByID(this.id, 'form_login_forgotPassword'); return false;"></td>
						<cfset _urlHomePage = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("_index.cfm", false), false)>
						<td><input type="Button" class="buttonClass" value="#application.resourceBundle.getResource("cancel")#" onclick="var _url = '#_urlHomePage#'; this.disabled = true; window.location.href = _url; return false;"></td>
					</tr>
				</table>
			</form>
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
	
	</cfsavecontent>
	
	<cfif not isDefined("hideLayout")>
	
		<cfmodule template="tags/layout.cfm">
			<cfoutput>#loginForm#</cfoutput>
		</cfmodule>
		
	<cfelse>
		
		<cfoutput>#loginForm#</cfoutput>
		
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
