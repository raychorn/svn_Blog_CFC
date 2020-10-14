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
<cfif listFindNoCase("search,entry,alias",url.mode) or session.persistData.loggedin or not structIsEmpty(form)>
	<cfset disabled = true>
</cfif> 

<cfscript>
	Request.scopeCacheParms = StructNew();
	Request.scopeCacheParms.cachename = cachename;
	Request.scopeCacheParms.disabled = disabled;
</cfscript>

<!--- Try to get the articles. --->
<cftry>
	<cfscript>
		if (IsDefined("params.lastXDays")) {
			try {
				articles = application.blog.getEntries(params);
				while (articles.recordCount eq 0) {
					params.lastXDays = params.lastXDays + 30;
					if (params.lastXDays gt 360) {
						break;
					}
					articles = application.blog.getEntries(params);
				}
			} catch (Any e) {
			}
		} else {
			articles = application.blog.getEntries(params);
		}
	</cfscript>
	<!--- if using alias, switch mode to entry --->
	<cfif url.mode is "alias">
		<cfset url.mode = "entry">
		<cfset url.entry = articles.id>
	</cfif>
	<cfcatch>
		<cfset articles = queryNew("id")>
	</cfcatch>
</cftry>

<cfscript>
//	writeOutput('FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) = [#FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER)#]<br>');
//	writeOutput('Len(CGI.HTTP_REFERER) = [#Len(CGI.HTTP_REFERER)#]<br>');
</cfscript>

<cfif ( (NOT IsDefined("URL.mode")) AND (NOT IsDefined("URL.entry")) ) OR ( (IsDefined("URL.mode")) AND (IsDefined("URL.entry")) AND (Len(CGI.HTTP_REFERER) gt 0) AND (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) eq 0) ) OR (Request.commonCode.isSpiderBot()) OR (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<!--- Call layout custom tag. --->
	<cfmodule template="tags/layout.cfm">
		<!--- This block shows a header when not doing the default display. --->
		<cfif url.mode is not "">
			<cfoutput><div class="blogHeader"></cfoutput>
		</cfif>
			
		<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
	
		<cfif url.mode is "day" or url.mode is "month">
			<cfoutput>
			<cfif url.mode is "day">#application.resourceBundle.getResource("viewingbyday")#<cfelse>#application.resourceBundle.getResource("viewingbymonth")#</cfif> : <cfif url.mode is "day">#application.localeUtils.dateLocaleFormat(createDate(url.year,url.month,url.day))#<cfelse>#application.localeUtils.getLocalizedMonth(url.month)# #application.localeUtils.getLocalizedYear(url.year)#</cfif> / <a href="#_mainURL#">#application.resourceBundle.getResource("main")#</a>
			</cfoutput>
		<cfelseif url.mode is "cat">
			<cftry>
				<cfset cat = application.blog.getCategory(url.catid)>
				<cfcatch>
					<cflocation url="#Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#')#" addToken="false">
				</cfcatch>
			</cftry>
			<cfoutput>
			#application.resourceBundle.getResource("viewingbycategory")# : #cat# / <a href="#_mainURL#">#application.resourceBundle.getResource("main")#</a>
			</cfoutput>	
		<cfelseif url.mode is "search">
			<cfoutput>
			#application.resourceBundle.getResource("searchedfor")# : #htmlEditFormat(form.search)# / <a href="#_mainURL#">#application.resourceBundle.getResource("main")#</a>
			</cfoutput>
		<cfelseif url.mode is "entry">
			<cfoutput>
			#application.resourceBundle.getResource("viewingbyentry")# / <a href="#_mainURL#">#application.resourceBundle.getResource("main")#</a>
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
			
			<h1><cfif (session.persistData.loggedin)><a name="#id#" href="#application.blog.makeLink(id)#" target="_top">#title#</a><cfelse>#title#</cfif></h1>
			
			<cfset displayStyle = "none">
			<cfif (IsDefined("URL.MODE")) AND (IsDefined("URL.ENTRY"))>
				<cfif (URL.MODE IS "entry") AND (URL.ENTRY IS NOT "")>
					<cfset displayStyle = "inline">
				</cfif>
			</cfif>
			
			<cfsavecontent variable="_html_">
				<div class="byline">#application.resourceBundle.getResource("postedat")# : #application.localeUtils.datetimeLocaleFormat(posted, "long", "long")# 
				<cfif len(username)>| #application.resourceBundle.getResource("postedby")# : #application.blog._getAuthUser(username)#</cfif><br />
				#application.resourceBundle.getResource("relatedcategories")#:
				<cfloop index="x" from=1 to="#listLen(categoryNames)#">
					<cfif 0>
						<cfset _url_ = Request.commonCode.clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#') & "&mode=cat&catid=#listGetAt(categoryIDs,x)#">
					<cfelse>
						<cfset _url_ = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & listGetAt(categoryIDs,x) & '/cat')>
					</cfif>
					<a href="#_url_#">#listGetAt(categoryNames,x)#</a><cfif x is not listLen(categoryNames)>,</cfif>
				</cfloop>
				</div>
			</cfsavecontent>
			
			<cfif (displayStyle IS "none")>
				<table width="600" border="0" cellpadding="-1" cellspacing="-1">
					<tr>
						<td width="120" align="<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>center<cfelse>left</cfif>" valign="top" style="margin-right: 40px;">
							<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>
								<span class="redBlogArticleAccessBoldPrompt">[Access to Blog Articles is Restricted to Registered Users]</span>
							</cfif>
						</td>
						<td align="left" valign="top" width="*" style="margin-left: 40px;">
							#_html_#
						</td>
					</tr>
				</table>
			<cfelse>
				#_html_#
			</cfif>
	
			<div class="body">
			<table width="600" border="0" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left" width="*">
						<cfif (IsDefined("Session.persistData.loggedin")) AND (Session.persistData.loggedin)>
							#application.blog.renderEntry(body)#
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</tr>
			</table>
			<cfif len(morebody) and url.mode is not "entry">
			<p align="right">
			<a href="#application.blog.makeLink(id)###more" target="_top">[#application.resourceBundle.getResource("more")#]</a>
			</p>
			<cfelse>
			<a name="more"></a>
			#application.blog.renderEntry(morebody)#
			</cfif>
			</div>
			
			<div class="byline">
			<cfset _commentsComment = '#application.resourceBundle.getResource("comments")# (<cfif commentCount is "">0<cfelse>#commentCount#</cfif>)'>
			<cfif allowcomments AND (session.persistData.loggedin)><a href="" onclick="launchComment('#id#', true); return false;">#_commentsComment#</a><cfelse>#_commentsComment#</cfif> | 
			<cfset _trackbacksComment = 'Trackbacks (<cfif trackbackCount is "">0<cfelse>#trackbackCount#</cfif>)'>
			<cfif allowTB AND (session.persistData.loggedin)><a href="" onclick="launchTrackback('#id#', true); return false;">#_trackbacksComment#</a><cfelse>#_trackbacksComment#</cfif> | 
	
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/print/#id#') & '?media=flashpaper'>
			<cfif application.isColdFusionMX7 AND (session.persistData.loggedin)><a href="#_url#" target="_blank" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("print")#</a><cfelse>#application.resourceBundle.getResource("print")#</cfif> | 
	
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/print/#id#') & '?media=pdf'>
			<cfif application.isColdFusionMX7 AND (session.persistData.loggedin)><a href="#_url#" target="_blank" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>PDF</a><cfelse>#application.resourceBundle.getResource("print")#</cfif> | 
	
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/enclosures/' & getFileFromPath(enclosure))>
			<cfif len(enclosure)><a href="#_url#" target="_blank" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("download")#</a> | </cfif>
	
	    <!--- RBB 11/02/2005: Added del.icio.us and Technorati links --->
			<cfset _urlPrime = application.blog.makeLink(id)>
			<cfif (ListLen(_urlPrime, "?") gt 1)>
				<cfset _urlPrime = ListDeleteAt(_urlPrime, 2, "?")>
			</cfif>
	    <a href="http://del.icio.us/post?url=#_urlPrime#&title=#URLEncodedFormat("#application.blog.getProperty('blogTitle')#:#title#")#" target="_blank">del.icio.us</a>
	    | <a href="http://www.technorati.com/cosmos/links.html?url=#_urlPrime#" target="_blank">#application.resourceBundle.getResource("linkingblogs")#</a>    
		<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>| <a href="" onclick="if (!!launchBlogEditor) { launchBlogEditor(true, '#id#'); };  return false;">#application.resourceBundle.getResource("edit")#</a>
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/editor.cfm') & '&id=#id#' & '&delete=yes'>
			| <a href="#_url#" onclick="return confirm('#application.resourceBundle.getResource("areyousure")#');">#application.resourceBundle.getResource("delete")#</a></cfif>
			</div>
			
			<cfif (NOT session.persistData.loggedin)>
				<span class="redBlogArticleAccessBoldPrompt">Registered users get unlimited access to Blog Articles, Trackbacks, Comments, Downloads and RSS Feeds.</span>
			</cfif>
			
			<cfif allowcomments>
				<div id="div_addComments_#id#" style="display: none;">
					<table width="580" border="1" cellpadding="-1" cellspacing="-1">
						<tr>
							<td bgcolor="silver">
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td align="center">
											<span class="normalBoldPrompt">(You may Add your Comments using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
										</td>
										<td align="right">
											<button class="normalBoldPrompt" onclick="launchComment('#id#', false); return false;">[X]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<div id="div_iframe_addComments_#id#">
								</div>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
			
			<cfif allowTB>
				<div id="div_addTrackback_#id#" style="display: none;">
					<table width="580" border="1" cellpadding="-1" cellspacing="-1">
						<tr>
							<td bgcolor="silver">
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td align="center">
											<span class="normalBoldPrompt">(You may Add your Trackback using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
										</td>
										<td align="right">
											<button class="normalBoldPrompt" onclick="launchTrackback('#id#', false); return false;">[X]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<div id="div_iframe_addTrackback_#id#">
								</div>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
			
			<cfif session.persistData.loggedin>
				<div id="div_blog_editor_#id#" style="display: none;">
					<table width="600" border="1" cellpadding="-1" cellspacing="-1">
						<tr>
							<td bgcolor="silver">
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td align="center">
											<span class="normalBoldPrompt">(You may Edit your Blog Entry or Add a New Entry using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
										</td>
										<td align="right">
											<button class="normalBoldPrompt" onclick="launchBlogEditor(false, '#id#'); return false;">[X]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<div id="div_iframe_blog_editor_#id#">
								</div>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
	
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
							#Request.commonCode.paragraphFormat2(excerpt)#
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
					<div class="body">#Request.commonCode.paragraphFormat2(comment)#</div>
					</p>
					<p>
					<cfset _http = Request.commonCode.cf_http(comments.website)>
					<cfset bool_isURL_valid = (Trim(_http.Statuscode) IS "200 OK")>
					<div class="byline">#application.resourceBundle.getResource("postedby")# <cfif len(comments.website) AND (bool_isURL_valid)><a href="#comments.website#" target="_blank">#name#</a><cfelse>#name#</cfif> / #application.resourceBundle.getResource("postedat")# #application.localeUtils.dateLocaleFormat(posted,"short")# #application.localeUtils.timeLocaleFormat(posted)#</div>
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
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/original_index.cfm') & qs>
			<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("moreentries")#</a>
			</p>
			</cfoutput>
		</cfif>
	</cfmodule>
<cfelse>
	<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/AJAX-Framework/index.cfm?#CGI.QUERY_STRING#'>
	<cflocation url="#_url#" addtoken="No">
</cfif>

<cfsetting enablecfoutputonly=false>	
