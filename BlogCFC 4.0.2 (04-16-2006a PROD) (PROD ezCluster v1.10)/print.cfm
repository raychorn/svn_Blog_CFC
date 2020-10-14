<cfsetting showdebugoutput="No">
<!---
	Name         : c:\projects\blog\client\print.cfm
	Author       : Raymond Camden 
	Created      : 09/23/05
	Last Updated : 11/11/05
	History      : Changed request.rooturl to app.rooturl (rkc 11/11/05)
--->
<cfparam name="wrapper" type="string" default="">

<cfparam name="media" type="string" default="FLASHPAPER">

<cfif (Len(wrapper) eq 0)>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
	
		<cfoutput>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
		</cfoutput>
	
	</head>
	
	<body>
	
	<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&wrapper=yes')>
	<cfoutput>
		<cfif 1>
			<iframe id="iframe_primary_content" src="#_url#" align="left" frameborder="0" marginwidth="0" marginheight="0" scrolling="Auto" width="100%" height="100%">
			</iframe>
		<cfelse>
			#_url#
		</cfif>
	</cfoutput>
	
	</body>
	</html>
<cfelse>
	<cfif (IsDefined("url.id"))>
		<cfset url.id = Trim(url.id)>
	</cfif>
	
	<cftry>
		<cfset entry = application.blog.getEntry(url.id)>
		<cfcatch type="Any">
		</cfcatch>
	</cftry>
	
	<cfheader name="Expires" value="#GetHttpTimeString(DateAdd("yyyy", -50, Now()))#">
	<cfheader name="Content-Disposition" value="inline; filename=print.pdf">
	<cfdocument format="#media#">
		<cfoutput>
		<html>
		<head>
			<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
			<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
			<meta name="robots" content="noindex,nofollow" />
			#application.snapIns.rootSnapIn.html_nocache()#
			<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
			<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
			<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
		</head>
		
		<body>
		</cfoutput>
		
		<cfdocumentitem type="header">
		<cfoutput>
		<div style="font-size: 8px; text-align: right;">
		#application.blog.getProperty("blogTitle")#: #entry.title#
		</div>	
		</cfoutput>
		</cfdocumentitem>
	
		<cfsavecontent variable="display">	
		<cfoutput>
		<div class="date">#application.localeUtils.dateLocaleFormat(entry.posted)#</div>
		<div class="title">#entry.title#</div>
		<div class="body">
		#application.blog.renderEntry(entry.body,true)#
		#application.blog.renderEntry(entry.morebody,true)#
		</div>
		<div class="byline">#application.resourceBundle.getResource("postedat")# : #application.localeUtils.timeLocaleFormat(entry.posted)#. | 
		<cfif len(entry.username)>#application.resourceBundle.getResource("postedby")# : #entry.username# </div></cfif>
		</cfoutput>
		</cfsavecontent>
		
		<cfset display = replace(display, "class=""code""", "class=""codePrint""", "all")>
		<cfoutput>#display#</cfoutput>
	
		<cfoutput>
		</body>
		</html>
		</cfoutput>
		
	</cfdocument>
</cfif>
