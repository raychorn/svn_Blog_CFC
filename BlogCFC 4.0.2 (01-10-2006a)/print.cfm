<!---
	Name         : c:\projects\blog\client\print.cfm
	Author       : Raymond Camden 
	Created      : 09/23/05
	Last Updated : 11/11/05
	History      : Changed request.rooturl to app.rooturl (rkc 11/11/05)
--->

<cfif not isDefined("url.id")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cftry>
	<cfset entry = application.blog.getEntry(url.id)>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfheader name="Content-Disposition" value="inline; filename=print.pdf">
<cfdocument format="pdf">

	<cfoutput>
	<html>
	
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
	<style type="text/css">
	@import url(#application.rooturl#/includes/style.css);
	</style>
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
	
	<!--- 
	Older blog entries use class=code, so let's do a quick fix for them
	--->
	<cfset display = replace(display, "class=""code""", "class=""codePrint""", "all")>
	<cfoutput>#display#</cfoutput>

	<cfoutput>
	</body>
	</html>
	</cfoutput>
	
</cfdocument>