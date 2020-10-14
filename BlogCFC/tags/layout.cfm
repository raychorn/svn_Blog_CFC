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
	<title>#application.blog.getProperty("blogTitle")##additionalTitle#</title>
	<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
	<cfif isDefined("url.mode") and url.mode is "entry">
	<!--- index entry page --->
	<meta name="robots" content="index,follow" />
	<cfelse>
	<!--- don't index other pages --->
	<meta name="robots" content="index,follow" />	  
	</cfif>
	<meta name="title" content="#application.blog.getProperty("blogTitle")##additionalTitle#" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<meta name="description" content="#application.blog.getProperty("blogDescription")##additionalTitle#" />
	<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#">
	<link rel="stylesheet" href="#application.rooturl#/includes/style.css" type="text/css" />
	<!--- For Firefox --->
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#application.rooturl#/rss.cfm?mode=full" />
	<script>
	function launchComment(id) {
		cWin = window.open("#application.rooturl#/addcomment.cfm?id="+id,"cWin","width=550,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
	}
	function launchTrackback(id) {
		cWin = window.open("#application.rooturl#/trackbacks.cfm?id="+id,"cWin","width=500,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	<cfif isUserInRole("admin")>
	function launchBlogEditor(id) {
		eWin = window.open("#application.rooturl#/editor.cfm?id="+id,"eWin","width=550,height=700,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=yes,scrollbars=yes,resizable=yes");
	}
	</cfif>	
	</script>
</head>

<body>

<table width="800">

<tr valign="top">
	<td colspan=2><div id="banner">#application.blog.getProperty("blogTitle")#</div></td>
</tr>
<tr valign="top">
	<td width="600">

	<div id="content">
	
		<div id="blogText">
		
		<cfif isUserInRole("admin")>
			<cfoutput>
			<div class="date">
			<b>#application.resourceBundle.getResource("admin")#:</b> 
			<a href="#application.rooturl#/index.cfm">Main</a> - 
			<a href="javaScript:launchBlogEditor('new')">#application.resourceBundle.getResource("addnewentry")#</a> - 
			<a href="#application.rooturl#/category_editor.cfm">#application.resourceBundle.getResource("categoryeditor")#</a> - 
			<a href="#cgi.script_name#?logout=youbet">#application.resourceBundle.getResource("logout")#</a>
			</div>
			</cfoutput>
		</cfif>

</cfoutput>		
<cfelse>
<cfoutput>
		</div>
		
	</td>
	<td width="200">
	<div id="menu">
	
		</cfoutput>
		
		<cfinclude template="../includes/pods/search.cfm">
		
		<cfinclude template="../includes/pods/logo.cfm">

		<cfinclude template="../includes/pods/paypal.cfm">
		
		<cfinclude template="../includes/pods/downloads.cfm">
		
		<cfinclude template="../includes/pods/calendar.cfm">

		<cfinclude template="../includes/pods/subscribe.cfm">
		
		<cfinclude template="../includes/pods/archives.cfm">

		<cfinclude template="../includes/pods/recent.cfm">

		<cfinclude template="../includes/pods/rss.cfm">
		
		<cfoutput>
				
	</div>
	</td>
</tr>
</table>


</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>