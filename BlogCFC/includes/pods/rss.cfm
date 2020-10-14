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

<cfset rssURL = application.rootURL & "/rss.cfm">

<cfmodule template="../../tags/podlayout.cfm" title="RSS">

	<cfoutput>
	<p align="center">
	<a href="#rssURL#?mode=short">#application.resourceBundle.getResource("shortmode")#</a> / <a href="#rssURL#?mode=full">#application.resourceBundle.getResource("fullmode")#</a><br>
	</p>
	<a href="http://www.feedvalidator.org/check.cgi?url=http://rayhorn.contentopia.net/blog/rss.cfm%3Fmode%3Dfull" target="_blank"><img src="images/valid-rss.png" height="18" alt="[Valid RSS]" title="Validate my RSS feed" /></a>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>