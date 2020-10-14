<cfsetting enablecfoutputonly=false showdebugoutput=false>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : RSS
	Author       : Raymond Camden 
	Created      : March 12, 2003
	Last Updated : August 5, 2005
	History      : Reset history for version 3.0
				   Forgot to remove val() on cat and entry since they are not uuids (rkc 11/13/03)
				   Added processingdirective (rkc 7/21/05)
				   Localized error labels, thanks to PaulH (rkc 7/22/05)
				   Allow for rss version (rkc 8/5/05)
	Purpose		 : Blog RSS feed.
--->

<cfif isDefined("url.mode") and url.mode is "full">
	<cfset mode = "full">
<cfelse>
	<cfset mode = "short">
</cfif>

<!--- only allow 1 or 2 --->
<cfif isDefined("url.version") and url.version is 1>
	<cfset version = 1>
<cfelse>
	<cfset version = 2>
</cfif>

<cfset params = structNew()>

<cfif isDefined("url.mode2")>
	<cfif url.mode2 is "day" and isDefined("url.day") and isDefined("url.month") and isDefined("url.year")>
		<cfset params.byDay = val(url.day)>
		<cfset params.byMonth = val(url.month)>
		<cfset params.byYear = val(url.year)>
	<cfelseif url.mode2 is "month" and isDefined("url.month") and isDefined("url.year")>
		<cfset params.byMonth = val(url.month)>
		<cfset params.byYear = val(url.year)>
	<cfelseif url.mode2 is "cat" and isDefined("url.catid")>
		<cfset params.byCat = url.catid>
	<cfelseif url.mode2 is "entry">
		<cfset params.byEntry = url.entry>
	</cfif>
</cfif>


<cftry>
	<cfcontent type="text/xml"><cfoutput>#application.blog.generateRSS(mode=mode,params=params,version=version)#</cfoutput>
	<cfcatch>
		<cfmail to="#application.blog.getProperty("ownerEmail")#" from="#application.blog.getProperty("ownerEmail")#" subject="rss bug" type="html">
		#application.resourceBundle.getResource("type")#=#cfcatch.type#
		<hr>
		#application.resourceBundle.getResource("message")#=#cfcatch.message#
		<hr>
		#application.resourceBundle.getResource("detail")#=#cfcatch.detail#
		<cfdump var="#cfcatch#">
		</cfmail>
		<!--- Logic is - if they filtered incorrectly, revert to default, if not, abort --->
		<cfif cgi.query_string neq "">
			<cflocation url="rss.cfm">
		<cfelse>
			<cfabort>
		</cfif>
	</cfcatch>
</cftry>

