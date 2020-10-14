<!--- fetchDecoder.cfm --->
<cfsetting showdebugoutput="No">

<cfif (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<cfsavecontent variable="_jscode2a"><cfoutput>#Request.commonCode.readAndObfuscateJSCode('../js/decontextmenu.js')#</cfoutput></cfsavecontent>
	<cfsavecontent variable="_jscode2b"><cfoutput>#Request.commonCode.readAndObfuscateJSCode('../js/CrossBrowserLibrary.js')#</cfoutput></cfsavecontent>
	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
			var xx$ = "#URLEncodedFormat(_jscode2a)#";
			if (!!parent.deliverDecoder) parent.deliverDecoder(xx$);

			var xx$ = "#URLEncodedFormat(_jscode2b)#";
			if (!!parent.deliverDecoder) parent.deliverDecoder(xx$);
		</script>
	</cfoutput>
</cfif>
