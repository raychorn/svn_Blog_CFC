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

	<cfset Request.cats = application.blog.getCategories()>
	<cfscript>
		_maxEntryCount = -1;
		_sqlStatement = "SELECT * FROM Request.cats ORDER BY entryCount DESC";
		Request.commonCode.safely_execSQL('Request.qGetMaxEntryCount', '', _sqlStatement);
		if (NOT Request.dbError) {
			_maxEntryCount = Request.qGetMaxEntryCount.entryCount[1];
		}
		_paddingCnt = 0;
		if (_maxEntryCount gt -1) {
			_paddingCnt = Len(_maxEntryCount);
		}
	</cfscript>
	<cfloop query="Request.cats">
		<cfif entryCount>
			<cfset _rssURL = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("rss.cfm?mode=full&mode2=cat&catid=#categoryid#", false), false)>
			<cfset _catURL = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("_index.cfm?mode=cat&catid=#categoryid#", false), false)>
			<cfoutput><NOBR><small>[<cfif (session.loggedin)><a href="#_rssURL#" target="_blank">RSS</a><cfelse>RSS</cfif>]&nbsp;|&nbsp;(#RepeatString('&nbsp;', _paddingCnt - Len(entryCount))##entryCount#)&nbsp;|&nbsp;<a href="#_catURL#">#categoryName#</a></small></NOBR><br></cfoutput>
		</cfif>
	</cfloop>
	
</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>