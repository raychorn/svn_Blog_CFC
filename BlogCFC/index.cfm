<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Index
	Author       : Raymond Camden 
	Created      : February 10, 2003
	Last Updated : November 14, 2005
	History      : Reset history for version 4.0
				   Call render to show blog entry (rkc 9/22/05)
				   For more links, add #more and link to it, idea from martin baur (rkc 9/26/05)
				   Two fixes to let title on single entry work right, thanks to SErat for finding (rkc 11/14/05)
	Purpose		 : Blog home page
--->

<!--- This portion handles determining which types of entries to fetch --->
<cfparam name="url.mode" default="">
<cfset params = structNew()>

<!--- 
	  SES parsing is abstracted out. This file is getting a bit large so I want to keep things nice and simple.
	  Plus if folks don't like this, they can just get rid of it.
	  Of course, the Blog makes use of it... but I'll worry about that later.
--->
<cfmodule template="tags/parseses.cfm" />

<!--- starting index --->
<cfparam name="url.startrow" default="1">
<cfif not isNumeric(url.startrow) or url.startrow lte 0 or round(url.startrow) neq url.startrow>
	<cfset url.startrow = 1>
</cfif>
<!--- number of entries to show --->
<cfset maxEntries = 10>

<!--- Handle cleaning of day, month, year --->
<cfif isDefined("url.day") and (not isNumeric(url.day) or val(url.day) is not url.day)>
	<cfset structDelete(url,"day")>
</cfif>
<cfif isDefined("url.month") and (not isNumeric(url.month) or val(url.month) is not url.month)>
	<cfset structDelete(url,"month")>
</cfif>
<cfif isDefined("url.year") and (not isNumeric(url.year) or val(url.year) is not url.year)>
	<cfset structDelete(url,"year")>
</cfif>

<cfif url.mode is "day" and isDefined("url.day") and isDefined("url.month") and url.month gte 1 and url.month lte 12 and isDefined("url.year")>
	<cfset params.byDay = val(url.day)>
	<cfset params.byMonth = val(url.month)>
	<cfset params.byYear = val(url.year)>
	<cfset month = val(url.month)>
	<cfset year = val(url.year)>
<cfelseif url.mode is "month" and isDefined("url.month") and url.month gte 1 and url.month lte 12 and isDefined("url.year")>
	<cfset params.byMonth = val(url.month)>
	<cfset params.byYear = val(url.year)>
	<cfset month = val(url.month)>
	<cfset year = val(url.year)>
<cfelseif url.mode is "cat" and isDefined("url.catid")>
	<cfset params.byCat = url.catid>
<cfelseif url.mode is "search" and (isDefined("form.search") or isDefined("url.search"))>
	<cfif isDefined("url.search")>
		<cfset form.search = url.search>
	</cfif>
	<cfset params.searchTerms = htmlEditFormat(form.search)>
<cfelseif url.mode is "entry" and isDefined("url.entry")>
	<cfset params.byEntry = url.entry>
<cfelseif url.mode is "alias" and isDefined("url.alias") and len(trim(url.alias))>
	<cfset params.byAlias = url.alias>
<cfelse>
	<!--- For default view, limit by date and max entries --->
	<cfset params.lastXDays = 30>
	<cfset url.mode = "">
</cfif>

<!--- Cache block. The following lines define our cachename, our disabled state, and the duration of the cache --->
<cfset cachename = cgi.query_string>
<cfset disabled = false>

<!--- disable cache for entry or search or form post --->
<cfif listFindNoCase("search,entry,alias",url.mode) or isUserInRole("admin") or not structIsEmpty(form)>
	<cfset disabled = true>
</cfif> 

<cfmodule template="tags/scopecache.cfm" cachename="#cachename#" scope="application" disabled="#disabled#" timeout="#application.timeout#">
<!--- End cache block. --->

<!--- Try to get the articles. --->
<cftry>
	<cfset articles = application.blog.getEntries(params)>
	<!--- if using alias, switch mode to entry --->
	<cfif url.mode is "alias">
		<cfset url.mode = "entry">
		<cfset url.entry = articles.id>
	</cfif>
	<cfcatch>
		<cfset articles = queryNew("id")>
	</cfcatch>
</cftry>

<!--- Call layout custom tag. --->
<cfmodule template="tags/layout.cfm">

	<!--- This block shows a header when not doing the default display. --->
	<cfif url.mode is not "">
		<cfoutput><div class="blogHeader"></cfoutput>
	</cfif>
		
	<cfif url.mode is "day" or url.mode is "month">
		<cfoutput>
		<cfif url.mode is "day">#application.resourceBundle.getResource("viewingbyday")#<cfelse>#application.resourceBundle.getResource("viewingbymonth")#</cfif> : <cfif url.mode is "day">#application.localeUtils.dateLocaleFormat(createDate(url.year,url.month,url.day))#<cfelse>#application.localeUtils.getLocalizedMonth(url.month)# #application.localeUtils.getLocalizedYear(url.year)#</cfif> / <a href="#cgi.script_name#">#application.resourceBundle.getResource("main")#</a>
		</cfoutput>
	<cfelseif url.mode is "cat">
		<cftry>
			<cfset cat = application.blog.getCategory(url.catid)>
			<cfcatch>
				<cflocation url="#cgi.script_name#" addToken="false">
			</cfcatch>
		</cftry>
		<cfoutput>
		#application.resourceBundle.getResource("viewingbycategory")# : #cat# / <a href="#cgi.script_name#">#application.resourceBundle.getResource("main")#</a>
		</cfoutput>	
	<cfelseif url.mode is "search">
		<cfoutput>
		#application.resourceBundle.getResource("searchedfor")# : #htmlEditFormat(form.search)# / <a href="#cgi.script_name#">#application.resourceBundle.getResource("main")#</a>
		</cfoutput>
	<cfelseif url.mode is "entry">
		<cfoutput>
		#application.resourceBundle.getResource("viewingbyentry")# / <a href="#cgi.script_name#">#application.resourceBundle.getResource("main")#</a>
		</cfoutput>
	</cfif>

	<cfif url.mode is not "">
		<cfoutput></div></cfoutput>
	</cfif>
		
	<cfset lastDate = "">
	<cfset allowTB = application.blog.getProperty("allowtrackbacks")>
	<cfoutput query="articles" startrow="#url.startrow#" maxrows="#maxEntries#">
	
		<cfif allowTB>
			<!--- output this rdf for auto discovery of trackback links --->
			<!-- 
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
	             xmlns:dc="http://purl.org/dc/elements/1.1/"
	             xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
		    <rdf:Description
		        rdf:about="#application.blog.makeLink(id)#"
		        dc:identifier="#application.blog.makeLink(id)#"
		        dc:title="#title#"
		        trackback:ping="#application.rooturl#/trackback.cfm?#id#" />
		    </rdf:RDF>
			-->		
		</cfif>

		<cfif dateFormat(posted) neq lastDate>
			<cfset lastDate = dateFormat(posted)>
			<div class="date">#application.localeUtils.dateLocaleFormat(posted)#</div>
		<cfelseif currentRow is not 1>
			<hr noshade size=1>
		</cfif>
		
		<h1><a href="#application.blog.makeLink(id)#">#title#</a></h1>
		
		<div class="byline">#application.resourceBundle.getResource("postedat")# : #application.localeUtils.timeLocaleFormat(posted)# 
		<cfif len(username)>| #application.resourceBundle.getResource("postedby")# : #username#</cfif><br />
		#application.resourceBundle.getResource("relatedcategories")#:
		<cfloop index="x" from=1 to="#listLen(categoryNames)#">
		<a href="#application.rooturl#/index.cfm?mode=cat&catid=#listGetAt(categoryIDs,x)#">#listGetAt(categoryNames,x)#</a><cfif x is not listLen(categoryNames)>,</cfif>
		</cfloop>
		</div>

		<div class="body">
		#application.blog.renderEntry(body)#
		<cfif len(morebody) and url.mode is not "entry">
		<p align="right">
		<a href="#application.blog.makeLink(id)###more">[#application.resourceBundle.getResource("more")#]</a>
		</p>
		<cfelse>
		<a name="more"></a>
		#application.blog.renderEntry(morebody)#
		</cfif>
		</div>
		
		<div class="byline">
		<cfif allowcomments><a href="javaScript:launchComment('#id#')">#application.resourceBundle.getResource("comments")# (<cfif commentCount is "">0<cfelse>#commentCount#</cfif>)</a> | </cfif> 
		<cfif allowTB><a href="javaScript:launchTrackback('#id#')">Trackbacks (<cfif trackbackCount is "">0<cfelse>#trackbackCount#</cfif>)</a> | </cfif>
		<cfif application.isColdFusionMX7><a href="#application.rooturl#/print.cfm?id=#id#">#application.resourceBundle.getResource("print")#</a> | </cfif>
		<cfif len(enclosure)><a href="#application.rooturl#/enclosures/#urlEncodedFormat(getFileFromPath(enclosure))#">#application.resourceBundle.getResource("download")#</a> | </cfif>
    <!--- RBB 11/02/2005: Added del.icio.us and Technorati links --->
    <a href="http://del.icio.us/post?url=#application.blog.makeLink(id)#" target="_blank">del.icio.us</a>
    | <a href="http://www.technorati.com/cosmos/links.html?url=#application.blog.makeLink(id)#" target="_blank">#application.resourceBundle.getResource("linkingblogs")#</a>    
		<cfif isUserInRole("admin")>| <a href="javaScript:launchBlogEditor('#id#')">#application.resourceBundle.getResource("edit")#</a></cfif>
		</div>
		
		<!--- Handle inline display of comments if one entry --->
		<cfif articles.recordCount is 1>
			<cfif allowTB>
				<cfset trackbacks = application.blog.getTrackBacks(id)>		
				<p>
				<div class="trackbackHeader">TrackBacks</div>
				</p>
				<cfif trackbacks.recordCount>
					<cfloop query="trackbacks">
						<p>
						<div class="body">
						<b><a href="#postURL#" target="_new">#title#</a></b><br>
						#paragraphFormat2(excerpt)#
						</div>
						<div class="byline">#application.resourceBundle.getResource("trackedby")# #blogname# / #application.resourceBundle.getResource("trackedon")# #application.localeUtils.dateLocaleFormat(created,"short")# #application.localeUtils.timeLocaleFormat(created)#</div>
						<hr noshade size=1>
						</p>
					</cfloop>			
				<cfelse>
				<p>#application.resourceBundle.getResource("notrackbacks")#</p>
				</cfif>
				<p>
				<div class="body">
				#application.resourceBundle.getResource("trackbackurl")#<br>
				#application.rooturl#/trackback.cfm?#id#
				</div>
				</p>
			</cfif>
			<p>
			<div class="commentHeader">#application.resourceBundle.getResource("comments")#</div>
			<cfset comments = application.blog.getComments(id)>
			<cfif comments.recordCount and allowcomments>
				<cfloop query="comments">
				<p>
				<div class="body">#paragraphFormat2(comment)#</div>
				</p>
				<p>
				<div class="byline">#application.resourceBundle.getResource("postedby")# <cfif len(comments.website)><a href="#comments.website#">#name#</a><cfelse>#name#</cfif> / #application.resourceBundle.getResource("postedat")# #application.localeUtils.dateLocaleFormat(posted,"short")# #application.localeUtils.timeLocaleFormat(posted)#</div>
				</p>
				<hr noshade size=1 />
				</p>
				</cfloop>
			<cfelseif not allowcomments>
				<p>#application.resourceBundle.getResource("commentsnotallowed")#</p>
			<cfelse>
				<p>#application.resourceBundle.getResource("nocomments")#</p>
			</cfif>
		</cfif>
		<p>

	</cfoutput>
	
	<cfif articles.recordCount is 0>
		<cfoutput><div class="title">#application.resourceBundle.getResource("sorry")#</div></cfoutput>
		<div class="body">
		<cfif url.mode is "">
			<cfoutput>#application.resourceBundle.getResource("noentries")#</cfoutput> 
		<cfelse>
			<cfoutput>#application.resourceBundle.getResource("noentriesforcriteria")#</cfoutput>
		</cfif>
		</div>
	<cfelseif articles.recordCount gt url.startRow + maxEntries>
		
		<!--- clean out startrow from query string --->
		<cfset qs = cgi.query_string>
		<cfset qs = reReplaceNoCase(qs, "&*startrow=[0-9]+", "")>
		<cfset qs = qs & "&startRow=" & (url.startRow + maxEntries)>
		<cfif isDefined("form.search") and len(trim(form.search)) and not structKeyExists(url, "search")>
			<cfset qs = qs & "&search=#htmlEditFormat(form.search)#">
		</cfif>
		
		<cfoutput>
		<p align="right">
		<a href="#application.rooturl#/index.cfm?#qs#">#application.resourceBundle.getResource("moreentries")#</a>
		</p>
		</cfoutput>
		
	</cfif>

</cfmodule>

</cfmodule>

<cfsetting enablecfoutputonly=false>	