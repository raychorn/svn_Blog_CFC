<!--- _downloads.cfm --->

<cfoutput>
	<cfmodule template="../../tags/podlayout.cfm" containerClass="rightMenuWide" title="#application.resourceBundle.getResource("downloads")#">
		<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & 'newDownloads.cfm')>
		<iframe id="iframe_newDownloads" src="#_url#" marginwidth="0" marginheight="0" frameborder="0"></iframe>
	</cfmodule>
</cfoutput>

