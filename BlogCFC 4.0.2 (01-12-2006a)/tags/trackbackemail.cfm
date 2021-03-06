<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : trackbackemail.cfm
	Author       : Raymond Camden 
	Created      : September 27, 2005
	Last Updated : 
	History      : 
	Purpose		 : Handles just the email to notify us about TBs
--->

<!--- id of the TB --->
<cfparam name="attributes.trackback" type="uuid">

<cfset tb = application.blog.getTrackBack(attributes.trackback)>

<cfif structIsEmpty(tb)>
	<cfsetting enablecfoutputonly=false>
	<cfexit method="exitTag">	
</cfif>

<cftry>
	<cfset blogEntry = application.blog.getEntry(tb.entryid)>
	<cfcatch>
		<cfsetting enablecfoutputonly=false>
		<cfexit method="exitTag">	
	</cfcatch>
</cftry>

<!--- make TB killer link --->
<cfset tbKiller = application.rootURL & "/trackback.cfm?kill=#attributes.trackback#">

<cfset subject = application.resourceBundle.getResource("trackbackaddedtoentry") & ": " & application.blog.getProperty("blogTitle") & " / " & application.resourceBundle.getResource("entry") & ": " & blogEntry.title>
<cfsavecontent variable="email">
<cfoutput>
#application.resourceBundle.getResource("trackbackaddedtoblogentry")#:	#blogEntry.title#
#application.resourceBundle.getResource("trackbackadded")#: 		#application.localeUtils.dateLocaleFormat(now())# / #application.localeUtils.timeLocaleFormat(now())#
#application.resourceBundle.getResource("blogname")#:	 		#tb.blogname#
#application.resourceBundle.getResource("title")#:	 			#tb.title#
URL:				#tb.posturl#
#application.resourceBundle.getResource("excerpt")#:
#tb.excerpt#

#application.resourceBundle.getResource("deletetrackbacklink")#:
#tbKiller#

------------------------------------------------------------
This blog powered by RABID_BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com), made useful by (<a href="#Request.const_owners_blog_url#" target="_blank"><b>The Rabid CF Developer</b></a>)
</cfoutput>
</cfsavecontent>

<cfset addy = application.blog.getProperty("owneremail")>
<cfif application.blog.getProperty("mailserver") is "">
	<cfmail to="#addy#" from="#addy#" subject="#subject#" type="#Request.typeOf_emailsContent#">#email#</cfmail>
<cfelse>
	<cfmail to="#addy#" from="#addy#" subject="#subject#"
		server="#application.blog.getProperty("mailserver")#" username="#application.blog.getProperty("mailusername")#" password="#application.blog.getProperty("mailpassword")#" type="#Request.typeOf_emailsContent#">#email#</cfmail>
</cfif>

<cfsetting enablecfoutputonly=false>
<cfexit method="exitTag">