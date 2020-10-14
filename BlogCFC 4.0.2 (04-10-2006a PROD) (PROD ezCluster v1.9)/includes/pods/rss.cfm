<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : rss.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : June 23, 2005
	History      : history cleared for 4.0
	Purpose		 : Display rss box
--->

<cfmodule template="../../tags/podlayout.cfm" title="RSS">

	<cfoutput>
	<br>
	<center>
	<p align="center">
	<cfset rssShortURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'rss.cfm', '/')) & '&mode=short'>
	<cfset rssFullURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'rss.cfm', '/')) & '&mode=full'>

	<cfif (session.loggedin)><a href="#rssShortURL#" target="_blank" <cfif isDebugMode()>title="rssShortURL = [#rssShortURL#]"</cfif>>#application.resourceBundle.getResource("shortmode")#</a><cfelse>#application.resourceBundle.getResource("shortmode")#</cfif> / <cfif (session.loggedin)><a href="#rssFullURL#" target="_blank" <cfif isDebugMode()>title="rssFullURL = [#rssFullURL#]"</cfif>>#application.resourceBundle.getResource("fullmode")#</a><cfelse>#application.resourceBundle.getResource("fullmode")#</cfif><br>
	</p>
	</center>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>