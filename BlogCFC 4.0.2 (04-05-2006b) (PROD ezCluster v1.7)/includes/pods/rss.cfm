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
	<center>
	<p align="center">
	<cfset rssShortURL = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("rss.cfm?mode=short", false), false)>
	<cfset rssFullURL = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("rss.cfm?mode=full", false), false)>
	<cfif (session.loggedin)><a href="#rssShortURL#" target="_blank">#application.resourceBundle.getResource("shortmode")#</a><cfelse>#application.resourceBundle.getResource("shortmode")#</cfif> / <cfif (session.loggedin)><a href="#rssFullURL#" target="_blank">#application.resourceBundle.getResource("fullmode")#</a><cfelse>#application.resourceBundle.getResource("fullmode")#</cfif><br>
	</p>
	<cfif 0>
		<a href="http://www.feedvalidator.org/check.cgi?url=http://#CGI.SERVER_NAME#/blog/rss.cfm%3Fmode%3Dfull" target="_blank"><img src="#application.rooturl#/images/valid-rss.png" height="18" alt="[Valid RSS]" title="Validate my RSS feed" /></a>
	</cfif>
	</center>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>