<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; 1980-<cfoutput>#Year(Now())#</cfoutput> Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<cfsavecontent variable="theScopes">
	<cfdump var="#CGI#" label="CGI Scope" expand="Yes">
</cfsavecontent>

<cfset emailError = false>
<cftry>
	<cfmail from="do-not-respond@contentopia.net" to="rabid_one@contentopia.net" subject="Invalid Referral - Copyright Violation" type="HTML">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; 1980-<cfoutput>#Year(Now())#</cfoutput> Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>
	#theScopes#
</body>
</html>
		</cfoutput>
	</cfmail>

	<cfcatch type="Any">
		<cfset emailError = true>
	</cfcatch>
</cftry>

<cflog file="#Application.applicationName#_COPYRIGHTS" type="Information" text="IP (#CGI.REMOTE_ADDR#) has violated Copyrights from (#CGI.HTTP_REFERER#)">

<table width="100%" cellpadding="-1" cellspacing="-1">
<cfoutput>
	<tr>
		<td align="center" valign="top" colspan="2">
			<h2 align="center">Invalid Use of Copyrighted materials... Your IP Address (#CGI.REMOTE_ADDR#) has been recorded.  Legal Action is pending.  Cease your illegal use of these copyrighted materials immediately.</h2>
		</td>
	</tr>
</cfoutput>
	<tr>
		<td width="*" align="center" valign="top">
		<center>
		<script type="text/javascript"><!--
		google_ad_client = "pub-9119838897885168";
		google_alternate_color = "CCFFFF";
		google_ad_width = 120;
		google_ad_height = 600;
		google_ad_format = "120x600_as";
		google_ad_type = "text_image";
		google_ad_channel ="1456381594";
		google_color_border = "CCCCCC";
		google_color_bg = "FFFFFF";
		google_color_link = "000000";
		google_color_url = "666666";
		google_color_text = "333333";
		//--></script>
		<script type="text/javascript"
		  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
		</script>
		</center>
		</td>
		<td width="*" align="center" valign="top">
			<script type="text/javascript"><!--
			google_ad_client = "pub-9119838897885168";
			google_ad_width = 120;
			google_ad_height = 240;
			google_ad_format = "120x240_as_rimg";
			google_cpa_choice = "CAAQg6aazgEaCByzL-E9BzG1KOPC93M";
			//--></script>
			<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
			</script>
		</td>
	</tr>
</table>

<cfif 0>
	<cfoutput>
	#theScopes#
	</cfoutput>
</cfif>

</body>
</html>
