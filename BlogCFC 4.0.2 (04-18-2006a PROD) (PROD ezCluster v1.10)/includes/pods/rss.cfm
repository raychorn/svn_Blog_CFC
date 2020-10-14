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
	<cfset rssShortURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/short/rss")>
	<cfset rssFullURL = Request.commonCode.clusterizeURLForSessionOnly("http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#/full/rss")>
	<cfscript>
		anchorTitle = '';
		if (NOT session.persistData.loggedin) {
			anchorTitle = 'Access to RSS Feeds is restricted to Registered Users Only !  Be sure to Register for your User Account today !';
		} else {
			anchorTitle = 'Access to RSS Feeds is restricted to Premium Users Only !  Kindly upgrade your User Account to Premium today !';
		}
	</cfscript>
	<cfif ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) )><a href="#rssShortURL#" target="_blank">#application.resourceBundle.getResource("shortmode")#</a><cfelse><a href="" title="#anchorTitle#" onclick="return false;">#application.resourceBundle.getResource("shortmode")#</a></cfif> / <cfif ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) )><a href="#rssFullURL#" target="_blank">#application.resourceBundle.getResource("fullmode")#</a><cfelse><a href="" title="#anchorTitle#" onclick="return false;">#application.resourceBundle.getResource("fullmode")#</a></cfif><br>
	</p>
	</center>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>