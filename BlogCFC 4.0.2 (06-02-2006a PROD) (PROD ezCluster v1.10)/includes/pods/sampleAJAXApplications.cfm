<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">

<cfmodule template="../../tags/podlayout.cfm" title="Sample AJAX Apps">

	<cfoutput>
		<cfscript>
			_urlWaferAnalysis = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/samples/semiconductors/wafer-analysis/') & '?sessID=#Session.sessID#';
	
			if (session.persistData.loggedin) {
				jsCode = "window.open('#_urlWaferAnalysis#','download','width=800,height=600,resizeable=yes,scrollbars=1')";
			} else {
				jsCode = "sampleAppsRequiresLoginBlock()";
			}
		</cfscript>

		<center>
		<a href="" onclick="#jsCode#; return false;">Semiconductor Wafer Analysis</a>
		</center>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>