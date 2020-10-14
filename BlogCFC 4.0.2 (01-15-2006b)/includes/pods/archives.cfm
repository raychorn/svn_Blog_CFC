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
			<cfoutput><a href="#application.rootURL#/index.cfm?mode=cat&catid=#categoryid#">#categoryName# (#entryCount#)</a> [<a href="rss.cfm?mode=full&mode2=cat&catid=#categoryid#">RSS</a>]<br></cfoutput>
		</cfif>
	</cfloop>
	
</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>