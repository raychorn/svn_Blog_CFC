<cfprocessingdirective pageencoding="utf-8">

<cfset upradeStatusMsg = "">

<cfif (FindNoCase("paypal.com", CGI.HTTP_REFERER) gt 0)>
	<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
		<cfset instance = application.blog.instance>
	</cfif>

	<cfscript>
		if ( (IsDefined("Session.persistData.qauthuser.ID")) AND (IsDefined("URL.period")) AND (IsDefined("URL.fee")) ) { 
			_sqlStatement = "INSERT INTO tblUsersPremium (uid, premiumDate, renewalFee) VALUES (#Session.persistData.qauthuser.ID#,#CreateODBCDateTime(DateAdd("d", URL.period, Now()))#,#URL.fee#); SELECT @@IDENTITY as 'id';";
			Request.commonCode.safely_execSQL('Request.qUpgradeUserAccountPremium', instance.DSN, _sqlStatement);
			if (Request.dbError) {
				Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
			} else {
				_sqlStatement = "UPDATE tblUsers SET uRole = 'PREMIUM' WHERE (ID = #Session.persistData.qauthuser.ID#)";
				Request.commonCode.safely_execSQL('Request.qUpgradeUserAccountPremium2', instance.DSN, _sqlStatement);
				if (Request.dbError) {
					Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
				} else {
					upradeStatusMsg = "Congrats on your successful upgrade to Premium.  Enjoy all the benefits now !";
				}
			}
		}
	</cfscript>
</cfif>

<cfsavecontent variable="premiumContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("premiumWelcome")#</div>
	<div class="body">
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<cfif (FindNoCase("paypal.com", CGI.HTTP_REFERER) gt 0)>
				<tr>
					<td align="left" valign="top">
						<span class="normalBoldPrompt">#upradeStatusMsg#</span>
					</td>
				</tr>
			</cfif>
			<tr>
				<td align="left" valign="top">
					<cfset _cancelURL = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, '/')#/original_index.cfm')>
					<span class="normalBoldPrompt"><a href="#_cancelURL#">[Home Page]</a></span>
				</td>
			</tr>
		</table>
	</div>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>

	<cfmodule template="tags/layout.cfm">
		<cfoutput>#premiumContent#</cfoutput>
	</cfmodule>
	
<cfelse>
	
	<cfoutput>#premiumContent#</cfoutput>
	
</cfif>
