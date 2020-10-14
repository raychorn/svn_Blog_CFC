<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfscript>
	function filterQuotesForSQL(s) {
		return ReplaceNoCase(s, "'", "''", 'all');
	}
</cfscript>

<html>
<head>
	<title>&copy; 1980-<cfoutput>#Year(Now())#</cfoutput> Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<cfsavecontent variable="theScopes">
	<cfdump var="#CGI#" label="CGI Scope" expand="Yes">
</cfsavecontent>

<cfwddx action="CFML2WDDX" input="#CGI#" output="theScopesWddx" usetimezoneinfo="Yes">

<cfset emailError = false>
<cftry>
	<cfquery name="qAddCopyrightViolation" datasource="#instance.dsn#">
		<cfoutput>
		DECLARE @isAlreadyApproved as bit;
		
		SELECT @isAlreadyApproved = (SELECT TOP 1 bool_isRefererApproved FROM tblCopyrightViolations WHERE (UPPER(HTTP_REFERER) = '#UCASE(CGI.HTTP_REFERER)#'));
		
		IF (@isAlreadyApproved = 0) OR (@isAlreadyApproved IS NULL)
		BEGIN
			INSERT INTO tblCopyrightViolations
			       (arrivalDt, bool_isRefererApproved, bool_isApprovalPending, SERVER_NAME, REMOTE_ADDR, HTTP_REFERER, QUERY_STRING, CGI_Scope_wddx)
			VALUES (GetDate(),0,1,'#filterQuotesForSQL(CGI.SERVER_NAME)#','#filterQuotesForSQL(CGI.REMOTE_ADDR)#','#filterQuotesForSQL(CGI.HTTP_REFERER)#','#filterQuotesForSQL(CGI.QUERY_STRING)#','#filterQuotesForSQL(theScopesWddx)#')
		END;
		</cfoutput>
	</cfquery>

	<cfcatch type="Any">
		<cfset emailError = true>
	</cfcatch>
</cftry>

<table width="100%" cellpadding="-1" cellspacing="-1">
<cfoutput>
	<tr>
		<td align="center" valign="top" colspan="3">
			<h2 align="center">Invalid Use of Copyrighted materials... Your IP Address (#CGI.REMOTE_ADDR#) has been recorded.  Legal Action is pending.  Cease your illegal use of these copyrighted materials immediately.</h2>
			<cfif (IsDefined("Request.ipAddressWasPreviouslyAbused"))>
				<cfif (Request.ipAddressWasPreviouslyAbused)>
					<small>Your IP Address was previously used to view these materials from a site that illegally linked to these materials therefore YOU will not be allowed to view these materials.</small><br><br>
				</cfif>
			</cfif>
		</td>
	</tr>
</cfoutput>
	<tr>
		<td colspan="3">
			<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("agooglead.cfm", false), true) & "&enableMetaRefresh=30">
			<iframe id="iframe_google_ad" name="iframe_google_ad" frameborder="0" scrolling="No" width="480" height="75" src="#_url#"></iframe>
		</td>
	</tr>
	<tr>
		<td width="30%" align="center" valign="top">
		<center>
		<script type="text/javascript"><!--
		google_ad_client = "pub-9119838897885168"; google_alternate_color = "CCFFFF"; google_ad_width = 120; google_ad_height = 600; google_ad_format = "120x600_as"; google_ad_type = "text_image"; google_ad_channel ="1456381594"; google_color_border = "CCCCCC"; google_color_bg = "FFFFFF"; google_color_link = "000000"; google_color_url = "666666"; google_color_text = "333333";
		//--></script>
		<script type="text/javascript"
		  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>
		</center>
		</td>
		<td width="30%" align="center" valign="top">
			<script type="text/javascript"><!--
			google_ad_client = "pub-9119838897885168"; google_ad_width = 120; google_ad_height = 240; google_ad_format = "120x240_as_rimg"; google_cpa_choice = "CAAQg6aazgEaCByzL-E9BzG1KOPC93M";
			//--></script>
			<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
			</script>
		</td>
		<td width="30%" align="center" valign="top">
			<script type="text/javascript"><!--
			google_ad_client = "pub-9119838897885168"; google_ad_width = 120; google_ad_height = 240; google_ad_format = "120x240_as_rimg"; google_cpa_choice = "CAAQjeWZzgEaCGUPemYRwK8bKPG193M";
			//--></script>
			<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
			</script>
		</td>
	</tr>
</table>

</body>
</html>
