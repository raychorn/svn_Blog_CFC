<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : layout.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : October 3, 2005
	History      : Reset history for version 4.0
				   Added trackback js code, switch to request.rooturl (rkc 9/22/05)
				   Switched to app.rooturl (rkc 10/3/05)
	Purpose		 : Layout
--->

<cfif thisTag.executionMode is "start">

<cfparam name="attributes.suppressLayout" type="boolean" default="false">

<cfparam name="attributes.maxWidth" type="integer" default="600">

<cfif isDefined("attributes.title")>
	<cfset additionalTitle = ": " & attributes.title>
<cfelse>	
	<cfset additionalTitle = "">
	<cfif isDefined("url.mode") and url.mode is "cat">
		<cftry>
			<cfset cat = application.blog.getCategory(url.catid)>
			<cfset additionalTitle = ": #cat#">
			<cfcatch></cfcatch>
		</cftry>
	<cfelseif isDefined("url.mode") and url.mode is "entry">
		<cftry>
			<cfset entry = application.blog.getEntry(url.entry)>
			<cfset additionalTitle = ": #entry.title#">
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
</cfif>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>#application.blog.getProperty("blogTitle")##additionalTitle# [#Application.applicationName#]</title>
	<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
	<cfif isDefined("url.mode") and url.mode is "entry">
	<!--- index entry page --->
	<meta name="robots" content="index,follow" />
	<cfelse>
	<!--- don't index other pages --->
	<meta name="robots" content="index,follow" />	  
	</cfif>
	<cfoutput>
		#application.snapIns.rootSnapIn.html_nocache()#
	</cfoutput>
	<meta name="title" content="#application.blog.getProperty("blogTitle")##additionalTitle#" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<meta name="description" content="#application.blog.getProperty("blogDescription")##additionalTitle#" />
	<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#,#application.blog.getProperty("trackbackspamlist")#">
	<cfif 1>
		<link rel="stylesheet" href="#application.rooturl#/includes/style.css" type="text/css" />
	<cfelse>
		<link rel="stylesheet" href="includes/style.css" type="text/css" />
	</cfif>
	<!--- For Firefox --->
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#application.rooturl#/rss.cfm?mode=full" />
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		<cfinclude template="../js/cfinclude_CrossBrowserLibrary.cfm">
	//-->
	</script>
	<cfset Request.CodeSnapinsLibraryPragma = "head">
	<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		<cfinclude template="../js/cfinclude_BlogSupportLibrary.cfm">
	//-->
	</script>
</head>

<body>

<cfif (attributes.suppressLayout)>
	<cfset attributes.maxWidth = attributes.maxWidth + 200>
</cfif>
<table width="#attributes.maxWidth#">
<cfset innerWidth = attributes.maxWidth>
<cfif (NOT attributes.suppressLayout)>
	<tr valign="top">
		<td colspan=2><div id="banner">#application.blog.getProperty("blogTitle")#</div></td>
	</tr>
</cfif>
<tr valign="top">
	<td width="#innerWidth#">

	<div id="content">
	
		<div id="blogText">
		
		<cfif isUserInRole("admin") AND (NOT attributes.suppressLayout)>
			<cfoutput>
			<div class="date">
			<table width="#innerWidth#" border="0" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td align="left">
									<b>#application.resourceBundle.getResource("admin")#:</b> 
								</td>
								<td align="center">
									<a href="#application.rooturl#/index.cfm">Main</a>
								</td>
								<td align="center">
									<a href="" onclick="launchBlogEditor(true, 'new'); return false;">#application.resourceBundle.getResource("addnewentry")#</a>
								</td>
								<td align="center">
									<a href="" onclick="launchCategoryEditor(true); return false;">#application.resourceBundle.getResource("categoryeditor")#</a>
								</td>
								<td align="center">
									<a href="#cgi.script_name#?logout=youbet">#application.resourceBundle.getResource("logout")#</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<cfset Request.CodeSnapinsLibraryPragma = "body1">
				<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
			</table>
			<cfset Request.CodeSnapinsLibraryPragma = "body2">
			<cfinclude template="../js/cfinclude_CodeSnapinsLibrary.cfm">
			</div>

			<div id="div_category_editor" style="display: none;">
				<table width="#innerWidth#" border="1" cellpadding="-1" cellspacing="-1">
					<tr>
						<td bgcolor="silver">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="center">
										<span class="normalBoldPrompt">(You may Edit your Categories using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
									</td>
									<td align="right">
										<button class="normalBoldPrompt" onclick="launchCategoryEditor(false); return false;">[X]</button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<iframe id="iframe_category_editor" width="#innerWidth#" height="350" frameborder="1"></iframe>
						</td>
					</tr>
				</table>
			</div>
			</cfoutput>

			<div id="div_blog_editor" style="display: none;">
				<table width="#innerWidth#" border="1" cellpadding="-1" cellspacing="-1">
					<tr>
						<td bgcolor="silver">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="center">
										<span class="normalBoldPrompt">(You may Edit your Blog Entry or Add a New Entry using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
									</td>
									<td align="right">
										<button class="normalBoldPrompt" onclick="launchBlogEditor(false); return false;">[X]</button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<iframe id="iframe_blog_editor" width="#innerWidth#" height="650" frameborder="1"></iframe>
						</td>
					</tr>
				</table>
			</div>
		</cfif>

</cfoutput>		
<cfelse>
<cfoutput>
		</div>
		
	</td>
	</cfoutput>
	<cfif (NOT attributes.suppressLayout)>
		<cfoutput>
		<td width="200">
		<div id="menu">
		
			</cfoutput>
			
			<cfinclude template="../includes/pods/logo.cfm">
	
			<cfinclude template="../includes/pods/search.cfm">
			
			<cfinclude template="../includes/pods/recent.cfm">
	
			<cfinclude template="../includes/pods/paypal.cfm">
			
			<cfinclude template="../includes/pods/downloads.cfm">
			
			<cfinclude template="../includes/pods/calendar.cfm">
	
			<cfinclude template="../includes/pods/archives.cfm">
	
			<cfinclude template="../includes/pods/rss.cfm">
			
			<cfinclude template="../includes/pods/advertisements.cfm">
	
			<cfinclude template="../includes/pods/subscribe.cfm">
			
			<cfinclude template="../includes/pods/aggregatedBy.cfm">
			
			<cfoutput>
					
		</div>
		</td>
		</cfoutput>
	</cfif>
<cfoutput>
</tr>
</table>


</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>