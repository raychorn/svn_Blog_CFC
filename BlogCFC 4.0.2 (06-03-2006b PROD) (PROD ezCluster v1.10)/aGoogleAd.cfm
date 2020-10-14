<cfsetting showdebugoutput="No">

<cfparam name="enableMetaRefresh" type="string" default="0">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Google Ads</title>
	<cfscript>
		Request.commonCode.cfm_nocache();
	</cfscript>
	<cfoutput>
		<cfif (enableMetaRefresh gt 0)>
			<script language="JavaScript1.2" type="text/javascript">
				var _url = "#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?enableMetaRefresh=#enableMetaRefresh#')#";
				var global_tid = setInterval("window.location.href = '" + _url + "'", #(enableMetaRefresh * 1000)#);
				
				function unloadPage() {
					clearInterval(global_tid);
				}
			</script>
		</cfif>

		<cfset Request.jsCodeObfuscationIndex = 1>
		<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
		<cfsavecontent variable="_jscode">
			<cfoutput>
				#Request.commonCode.readAndObfuscateJSCode('js/433511201010924803.dat')#
				#Request.commonCode.readAndObfuscateJSCode('js/decontextmenu.js')#
			</cfoutput>
		</cfsavecontent>
	
		<script language="JavaScript1.2" type="text/javascript">
			var isSiteHavingProblems = 0; 
			var xx$ = "#URLEncodedFormat(_jscode)#";
		</script>
	
		<script language="JavaScript1.2" type="text/javascript">
			if (!!xx$) { eval(unescape(xx$)) };
		</script>

		<script language="JavaScript1.2" type="text/javascript">
			<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
				#Request.jsCodeObfuscationDecoderAR[_i]#
			</cfloop>
		</script>

	</cfoutput>
</head>

<body onunload="unloadPage()">

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
<cfelseif (rndBanner gte 5) AND (rndBanner lte 8)>
	<!-- Begin PayPal Logo --><A HREF="https://www.paypal.com/us/mrb/pal=CGAH5JUDXESUG" target="_blank"><IMG  SRC="http://images.paypal.com/en_US/i/bnr/paypal_mrb_banner.gif" BORDER="0" ALT="Sign up for PayPal and start accepting credit card payments instantly."></A><!-- End PayPal Logo -->
<cfelseif (rndBanner gte 9)>
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
<cfif (rndBanner lte 5) OR (rndBanner gte 9)>
	<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
	</script>
</cfif>

</body>
</html>
