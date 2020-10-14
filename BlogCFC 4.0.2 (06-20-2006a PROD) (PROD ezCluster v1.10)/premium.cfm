<cfprocessingdirective pageencoding="utf-8">

<cfparam name="isUsingAJAX" type="boolean" default="#(FindNoCase('/AJAX-Framework/', CGI.HTTP_REFERER) gt 0)#">

<cfsavecontent variable="premiumContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("premiumTitle")#</div>
	<div class="body">

		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
					<cfset _actionURL = "https://www.paypal.com/cgi-bin/webscr">
					<cfset _businessEmail = "payments@contentopia.net">
					<cfset imgHost = "https://www.paypal.com">
					<cfif (isDebugMode()) OR (Request.commonCode.isServerLocal())>
						<small><b>[SandBox Mode]</b></small><br>
						<cfset _actionURL = "https://www.sandbox.paypal.com/cgi-bin/webscr">
						<cfset _businessEmail = "raychorn@contentopia.net">
						<cfset imgHost = "https://www.sandbox.paypal.com">
					</cfif>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<td align="right" valign="top">
								<form action="#_actionURL#" method="post" target="_blank">
								<input type="image" src="#imgHost#/en_US/i/btn/x-click-butcc-subscribe.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
								<img alt="" border="0" src="#imgHost#/en_US/i/scr/pixel.gif" width="1" height="1">
								<input type="hidden" name="cmd" value="_xclick-subscriptions">
								<input type="hidden" name="business" value="#_businessEmail#">
								<input type="hidden" name="item_name" value="Premium Monthly Subscription ColdFusion, JavaScript and AJAX Social Networking Site">
								<input type="hidden" name="item_number" value="Premium_Subscription_1_Per_Month">
								<input type="hidden" name="no_shipping" value="1">
								<input type="hidden" name="return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/validateMonthlyPremiumUserAccount/#Session.sessID#/">
								<input type="hidden" name="cancel_return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/cancelPremiumUserAccountPurchase/#Session.sessID#/">
								<input type="hidden" name="no_note" value="1">
								<input type="hidden" name="currency_code" value="USD">
								<input type="hidden" name="bn" value="PP-SubscriptionsBF">
								<input type="hidden" name="a3" value="1.00">
								<input type="hidden" name="p3" value="1">
								<input type="hidden" name="t3" value="M">
								<input type="hidden" name="src" value="1">
								<input type="hidden" name="sra" value="1">
								</form>
							</td>
							<td align="left" valign="middle">
								<span class="normalBoldPrompt">Option A. Monthly Premium Access for only $1.00.
								</span>
							</td>
						</tr>
						<tr>
							<td align="right" valign="top">
								<form action="#_actionURL#" method="post" target="_blank">
								<input type="image" src="#imgHost#/en_US/i/btn/x-click-butcc-subscribe.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
								<img alt="" border="0" src="#imgHost#/en_US/i/scr/pixel.gif" width="1" height="1">
								<input type="hidden" name="cmd" value="_xclick-subscriptions">
								<input type="hidden" name="business" value="#_businessEmail#">
								<input type="hidden" name="item_name" value="Premium 6 Months Subscription ColdFusion, JavaScript and AJAX Social Networking Site">
								<input type="hidden" name="item_number" value="Premium_Subscription_4_Per_6_Months">
								<input type="hidden" name="no_shipping" value="1">
								<input type="hidden" name="return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/validateSixMonthsPremiumUserAccount/#Session.sessID#/">
								<input type="hidden" name="cancel_return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/cancelPremiumUserAccountPurchase/#Session.sessID#/">
								<input type="hidden" name="no_note" value="1">
								<input type="hidden" name="currency_code" value="USD">
								<input type="hidden" name="bn" value="PP-SubscriptionsBF">
								<input type="hidden" name="a3" value="4.00">
								<input type="hidden" name="p3" value="6">
								<input type="hidden" name="t3" value="M">
								<input type="hidden" name="src" value="1">
								<input type="hidden" name="sra" value="1">
								</form>
							</td>
							<td align="left" valign="middle">
								<span class="normalBoldPrompt">Option B. 6 Months Premium Access for only $4.00.
								</span>
							</td>
						</tr>
						<tr>
							<td align="right" valign="top">
								<form action="#_actionURL#" method="post" target="_blank">
								<input type="image" src="#imgHost#/en_US/i/btn/x-click-butcc-subscribe.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
								<img alt="" border="0" src="#imgHost#/en_US/i/scr/pixel.gif" width="1" height="1">
								<input type="hidden" name="cmd" value="_xclick-subscriptions">
								<input type="hidden" name="business" value="#_businessEmail#">
								<input type="hidden" name="item_name" value="Premium 12 Months Subscription ColdFusion, JavaScript and AJAX Social Networking Site">
								<input type="hidden" name="item_number" value="Premium_Subscription_6_Per_Year">
								<input type="hidden" name="no_shipping" value="1">
								<input type="hidden" name="return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/validateYearlyPremiumUserAccount/#Session.sessID#/">
								<input type="hidden" name="cancel_return" value="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/i/cancelPremiumUserAccountPurchase/#Session.sessID#/">
								<input type="hidden" name="no_note" value="1">
								<input type="hidden" name="currency_code" value="USD">
								<input type="hidden" name="bn" value="PP-SubscriptionsBF">
								<input type="hidden" name="a3" value="6.00">
								<input type="hidden" name="p3" value="12">
								<input type="hidden" name="t3" value="M">
								<input type="hidden" name="src" value="1">
								<input type="hidden" name="sra" value="1">
								</form>
							</td>
							<td align="left" valign="middle">
								<span class="normalBoldPrompt">Option C. 12 Months Premium Access for only $6.00.
								</span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="left" valign="top">
					<span class="normalBoldPrompt">
					HAL Smalltalker, Inc. is wholly owned by Hierarchical Applications Limited and is responsible for processing our Subscriptions.
					</span>
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
			<cfif (NOT isUsingAJAX)>
				<tr>
					<td align="left" valign="top">
						<cfset _cancelURL = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, '/')#/original_index.cfm')>
						<span class="normalBoldPrompt"><a href="#_cancelURL#">[Home Page]</a></span>
					</td>
				</tr>
			</cfif>
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
