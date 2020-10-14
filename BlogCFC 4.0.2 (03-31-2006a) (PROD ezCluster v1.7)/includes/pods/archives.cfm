<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : archives.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : November 4, 2005
	History      : fix for SEO links (rkc 11/4/05)
	Purpose		 : Display archives
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="pod_archives" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("archivesbysubject")#">

	<cfset cats = application.blog.getCategories()>
	<cfloop query="cats">
		<cfif entryCount>
			<cfoutput><NOBR><small>[<a href="#application.rootURL#/rss.cfm?mode=full&mode2=cat&catid=#categoryid#" target="_blank">RSS</a>]&nbsp;|&nbsp;(#entryCount#)&nbsp;|&nbsp;<a href="#application.rootURL#/index.cfm?mode=cat&catid=#categoryid#">#categoryName#</a></small></NOBR><br></cfoutput>
		</cfif>
	</cfloop>
	
</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>