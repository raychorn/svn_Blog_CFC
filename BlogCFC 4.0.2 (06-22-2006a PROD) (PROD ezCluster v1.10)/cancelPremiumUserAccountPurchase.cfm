<cfprocessingdirective pageencoding="utf-8">

<cfsavecontent variable="premiumContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("premiumCancel")#</div>
	<div class="body">
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<cfif (FindNoCase("paypal.com", CGI.HTTP_REFERER) gt 0)>
				<tr>
					<td align="left" valign="top">
						<span class="normalBoldPrompt">We'll be here when you choose to upgrade your account to Premium.</span>
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
