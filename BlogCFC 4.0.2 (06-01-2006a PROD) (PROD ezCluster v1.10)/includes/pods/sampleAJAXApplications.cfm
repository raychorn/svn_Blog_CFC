<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">

<cfmodule template="../../tags/podlayout.cfm" title="Sample AJAX Apps">

	<cfscript>
		_urlWaferAnalysis = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/samples/semiconductors/wafer-analysis/');
	</cfscript>

	<cfoutput>
		<center>
		<a href="#_urlWaferAnalysis#" target="_blank">Semiconductor Wafer Analysis</a>
		</center>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>