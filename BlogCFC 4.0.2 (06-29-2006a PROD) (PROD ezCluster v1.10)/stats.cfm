<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Stats
	Author       : Raymond Camden 
	Created      : November 19, 2004
	Last Updated : December 16, 2005
	History      : reset for 4.0, and fix for empty stats by andrew (rkc 10/25/05)
				 : case fixes for mysql (rkc 11/14/05)
				 : Use 'proper' link for SES urls. Added nofollow to stop robots (rkc 12/16/05)
	Purpose		 : Stats
--->

<cfmodule template="tags/layout.cfm" title="#application.resourceBundle.getResource("stats")#">
	
	<cfset dsn = application.blog.getProperty("dsn")>
	<cfset dbtype = application.blog.getProperty("blogdbtype")>
	<cfset blog = application.blog.getProperty("name")>
	
	<!--- get a bunch of crap --->
	<cfquery name="getTotalEntries" datasource="#dsn#">
		select	count(id) as totalentries, 
				min(posted) as firstentry,
				max(posted) as lastentry
		from	tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>
	
	<!--- get last 30 --->
	<cfset thirtyDaysAgo = dateAdd("d", -30, now())>
	<cfquery name="last30" datasource="#dsn#">
		select	count(id) as totalentries
		from	tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		posted >= <cfqueryparam cfsqltype="cf_sql_date" value="#thirtyDaysAgo#">
	</cfquery>
	
	<cfquery name="getTotalComments" datasource="#dsn#">
		select	count(tblblogcomments.id) as totalcomments
		from	tblblogcomments, tblblogentries
		where	tblblogcomments.entryidfk = tblblogentries.id
		and		tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>
	
	<!--- gets num of entries per category --->
	<cfquery name="getCategoryCount" datasource="#dsn#">
		select	categoryid, categoryname, count(categoryidfk) as total
		from	tblblogcategories, tblblogentriescategories
		where	tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and		tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by tblblogcategories.categoryid, tblblogcategories.categoryname
		<cfif dbtype is not "msaccess">
			order by total desc
		<cfelse>
			order by count(categoryidfk) desc
		</cfif>
	</cfquery>
	
	<!--- gets num of comments per entry, top 10 --->
	<cfquery name="topCommentedEntries" datasource="#dsn#">
		select 
		<cfif dbtype is not "mysql">top 10</cfif>
		tblblogentries.id, tblblogentries.title, count(tblblogcomments.id) as commentcount
		from			tblblogentries, tblblogcomments
		where			tblblogcomments.entryidfk = tblblogentries.id
		and				tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">

		group by		tblblogentries.id, tblblogentries.title
		<cfif dbtype is not "msaccess">
			order by	commentcount desc
		<cfelse>
			order by 	count(tblblogcomments.id) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>

	<!--- gets num of comments per category, top 10 --->
	<cfquery name="topCommentedCategories" datasource="#dsn#">
		select 
		<cfif dbtype is not "mysql">top 10</cfif>
						tblblogcategories.categoryid, 
						tblblogcategories.categoryname, 
						count(tblblogcomments.id) as commentcount
		from			tblblogcategories, tblblogcomments, tblblogentriescategories
		where			tblblogcomments.entryidfk = tblblogentriescategories.entryidfk
		and				tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and				tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by		tblblogcategories.categoryid, tblblogcategories.categoryname
		<cfif dbtype is not "msaccess">
			order by	commentcount desc
		<cfelse>
			order by	count(tblblogcomments.id) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>

	<cfquery name="topSearchTerms" datasource="#dsn#">
		select		
		<cfif dbtype is not "mysql">top 10</cfif>
					searchterm, count(searchterm) as total
		from		tblblogsearchstats
		where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by	searchterm
		<cfif dbtype is not "msaccess">
			order by	total desc
		<cfelse>
			order by	count(searchterm) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>
		
	<cfif getTotalEntries.totalEntries>
		<cfset dur = dateDiff("d",getTotalEntries.firstEntry, now())>
	</cfif>
	
	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("generalstats")#</div>
	<div class="body">
	<table border="1" width="100%">
		<tr>
			<td><b>#application.resourceBundle.getResource("totalnumentries")#:</b></td>
			<td>#getTotalEntries.totalEntries#</td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("last30")#:</b></td>
			<td>#last30.totalEntries#</td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("last30avg")#:</b></td>
			<td><cfif last30.totalentries gt 0>#numberFormat(last30.totalEntries/30,"999.99")#<cfelse>&nbsp;</cfif></td>
		</tr>				
		<tr>
			<td><b>#application.resourceBundle.getResource("firstentry")#:</b></td>
			<td><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("lastentry")#:</b></td>
			<td><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("bloggingfor")#:</b></td>
			<td><cfif isDefined("dur")>#dur# #application.resourceBundle.getResource("days")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td><b>#application.resourceBundle.getResource("totalcomments")#:</b></td>
			<td>#getTotalComments.totalComments#</td>
		</tr>
	</table>
	</div>
	
	<p />
	
	<div class="date">#application.resourceBundle.getResource("categorystats")#</div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="getCategoryCount">
		<tr>
			<td>#categoryname#</td>
			<td>#total#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	
	<div class="date">#application.resourceBundle.getResource("topentriesbycomments")#</div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topCommentedEntries">
		<tr>
			<td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td>#commentCount#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	
	<div class="date">#application.resourceBundle.getResource("topcategoriesbycomments")#</div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topCommentedCategories">
			<!--- 
				This is ugly code.
				I want to find the avg number of posts
				per entry for this category.
			--->
			<cfquery name="getTotalForThisCat" dbtype="query">
				select	total
				from	getCategoryCount
				where	categoryid = '#categoryid#'
			</cfquery>
			<cfset avg = commentCount / getTotalForThisCat.total>
			<cfset avg = numberFormat(avg,"___.___")>
			<tr>
				<td><b><a href="index.cfm?mode=cat&catid=#categoryid#" rel="nofollow">#categoryname#</a></b></td>
				<td>#commentCount# (#application.resourceBundle.getResource("avgcommentperentry")#: #avg#)</td>
			</tr>
		</cfloop>
	</table>
	</div>

	<p />
	
	<div class="date">#application.resourceBundle.getResource("topsearchterms")#</div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topSearchTerms">
		<tr>
			<td><b><a href="#application.rooturl#/index.cfm?mode=search&search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></b></td>
			<td>#total#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>