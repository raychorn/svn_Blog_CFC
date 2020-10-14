<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : October 26, 2005
	History      : added processingdir (rkc 11/10/03)
				   point to index.cfm (rkc 8/5/05)
				   Change link (rkc 10/26/05)
	Purpose		 : Display search box
--->

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("advertisement")#">

	<cfoutput>
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
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>