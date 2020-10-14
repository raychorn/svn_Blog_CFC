<cfparam name="enableMetaRefresh" type="string" default="0">
<cfscript>
	Request.commonCode.cfm_nocache(GetHttpTimeString(DateAdd("yyyy", -50, Now())));
</cfscript>
<cfoutput>
	<cfif (enableMetaRefresh gt 0)>
		<meta http-equiv="refresh" content="#enableMetaRefresh#">
	</cfif>
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
</cfoutput>

<cfset rndBanner = RandRange(1, 20, "SHA1PRNG")>
<cfif (rndBanner eq 1)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
	google_ad_client = "pub-9119838897885168";
	google_ad_width = 468;
	google_ad_height = 60;
	google_ad_format = "468x60_as_rimg";
	google_cpa_choice = "CAAQj6eVzgEaCIxA5niBniDSKOm293M";
	//-->
	</script>
<cfelseif (rndBanner eq 2)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
	google_ad_client = "pub-9119838897885168";
	google_ad_width = 468;
	google_ad_height = 60;
	google_ad_format = "468x60_as_rimg";
	google_cpa_choice = "CAAQ8aaVzgEaCPJg3qtkyXM9KOm293M";
	//-->
	</script>
<cfelseif (rndBanner eq 3)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
	google_ad_client = "pub-9119838897885168";
	google_ad_width = 468;
	google_ad_height = 60;
	google_ad_format = "468x60_as_rimg";
	google_cpa_choice = "CAAQ58WdzgEaCFLK1ovSD_DNKNvD93M";
	//-->
	</script>
<cfelseif (rndBanner eq 4)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
	google_ad_client = "pub-9119838897885168";
	google_ad_width = 468;
	google_ad_height = 60;
	google_ad_format = "468x60_as_rimg";
	google_cpa_choice = "CAAQq8WdzgEaCCQIMpsWzihvKNvD93M";
	//-->
	</script>
<cfelseif (rndBanner gte 5)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
	google_ad_client = "pub-9119838897885168";
	google_ad_width = 468;
	google_ad_height = 60;
	google_ad_format = "468x60_as";
	google_ad_type = "image";
	google_ad_channel ="1456381594";
	google_page_url = document.location;
	google_color_border = "E0FFE3";
	google_color_bg = "E0FFE3";
	google_color_link = "0000CC";
	google_color_url = "008000";
	google_color_text = "000000";
	//-->
	</script>
</cfif>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

