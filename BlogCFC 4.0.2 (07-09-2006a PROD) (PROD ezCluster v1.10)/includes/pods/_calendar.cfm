<!--- _calendar.cfm --->

<cfoutput>
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & 'newCalendar.cfm')>
	<iframe src="#_url#" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</cfoutput>

