<cfprocessingdirective pageencoding="utf-8">

<cfsavecontent variable="premiumContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("premiumTitle")#</div>
	<div class="body">

		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<td align="left" valign="top">
								<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
								<input type="image" src="https://www.paypal.com/en_US/i/btn/x-click-butcc-subscribe.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
								<img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
								<input type="hidden" name="cmd" value="_xclick-subscriptions">
								<input type="hidden" name="business" value="payments@contentopia.net">
								<input type="hidden" name="item_name" value="Weekly Subscription ColdFusion, JavaScript and AJAX Social Networking Site">
								<input type="hidden" name="item_number" value="Weekly_Subscription_1_Per_Week">
								<input type="hidden" name="no_shipping" value="1">
								<input type="hidden" name="return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/validatePremiumUserAccount/#Session.sessID#/?period=7&fee=1">
								<input type="hidden" name="cancel_return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/cancelPremiumUserAccountPurchase/#Session.sessID#/">
								<input type="hidden" name="no_note" value="1">
								<input type="hidden" name="currency_code" value="USD">
								<input type="hidden" name="bn" value="PP-SubscriptionsBF">
								<input type="hidden" name="a3" value="1.00">
								<input type="hidden" name="p3" value="1">
								<input type="hidden" name="t3" value="W">
								<input type="hidden" name="src" value="1">
								<input type="hidden" name="sra" value="1">
								</form>
							</td>
							<td align="left" valign="middle">
								<span class="normalBoldPrompt">Premium Access cost is only $1.00 per week.<br><br>
								HAL Smalltalker, Inc. is wholly owned by Hierarchical Applications Limited and is responsible for processing our Subscriptions.
								</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<cfif (Request.commonCode.isUserPremium())>
				<tr>
					<td align="left" valign="top">
							<A HREF="https://www.paypal.com/cgi-bin/webscr?cmd=_subscr-find&alias=payments%40contentopia%2enet">
							<IMG SRC="https://www.paypal.com/en_US/i/btn/cancel_subscribe_gen.gif" BORDER="0">
							</A>
					</td>
				</tr>
			</cfif>
			<tr>
				<td align="left" valign="top">
					<cfset _cancelURL = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, '/')#/_index.cfm')>
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
