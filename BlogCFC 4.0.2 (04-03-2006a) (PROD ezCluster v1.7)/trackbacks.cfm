<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : c:\projects\blog\client\trackbacks.cfm
	Author       : Dave Lobb 
	Created      : 09/22/05
	Last Updated : 9/22/05
	History      : Ray modified it for 4.0
--->

<cfinclude template="includes/udf.cfm">

<cfparam name="form.blog_name" default="">
<cfparam name="form.title" default="">
<cfparam name="form.excerpt" default="">
<cfparam name="form.url" default="">

<cfif (session.loggedin)>
	<cfif (IsDefined("url.id"))>
		<cfset url.id = Trim(url.id)>
	</cfif>

	<cfif not isDefined("url.id") or not application.blog.getProperty("allowtrackbacks")>
		<cfabort>
	</cfif>
	
	<cfif isDefined("url.delete") and session.loggedin>
		<cfset application.blog.deleteTrackback(url.delete)>
	</cfif>
	
	<cfif isDefined("form.addtrackback")>
		<cfset errorStr = "">
	
		<cfif not len(trim(form.blog_name))>
			<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeblogname") & "<br>">
		</cfif>
	
		<cfif not len(trim(form.title))>
			<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeblogtitle") & "<br>">
		</cfif>
	
		<cfif not len(trim(form.excerpt))>
			<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeblogexcerpt") & "<br>">
		</cfif>
	
		<cfif not len(trim(form.url)) or not isURL(form.url)>
			<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeblogentryurl") & "<br>">
		</cfif>
	
		<cfif not len(errorStr)>
			<cfset id = application.blog.addTrackBack(form.title, form.url, form.blog_name, form.excerpt, url.id)>
			<!--- Form a message about the TB --->
			<cfmodule template="tags/trackbackemail.cfm" trackback="#id#" />
			<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
			<cfset form.blog_name = "">
			<cfset form.title = "">
			<cfset form.excerpt = "">
			<cfset form.url = "">
		</cfif>
	
	</cfif>
<cfelse>
	<h1>Go Away Fucking MORON Hacker !  Try masterbating instead !</h1>
</cfif>
<!--- +++ --->

<cfset params.byEntry = url.id>
<cfset article = application.blog.getEntries(params)>
<cfset trackbacks = application.blog.getTrackBacks(url.id)>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />

<html>
<head>
	<title>#application.blog.getProperty("blogTitle")# : Trackbacks for #article.title#</title>
	<link rel="stylesheet" href="#application.rootURL#/includes/style.css" type="text/css"/>
	#application.snapIns.rootSnapIn.html_nocache()#
</head>

<body>


<div class="date">Trackbacks: #article.title#</div>
</cfoutput>

<cfloop query="trackbacks">
	<cfoutput>
	<p>
	<div class="body">
	<b><a href="#postURL#" target="_new">#title#</a></b><br>
	#paragraphFormat2(excerpt)#
	</div>
	<div class="byline">#application.resourceBundle.getResource("trackedby")# #blogname# / #application.resourceBundle.getResource("trackedon")# #application.localeUtils.dateLocaleFormat(created,"short")# #application.localeUtils.timeLocaleFormat(created)#
	<cfif session.loggedin> | <a href="#Request.commonCode.makeLinkToSelf('', true)#&id=#url.id#&delete=#id#">#application.resourceBundle.getResource("delete")#</a></cfif></div>		
	<hr noshade size=1>
	</p>
	</cfoutput>
</cfloop>

<cfoutput>
<cfif (session.loggedin)>
	<div class="date">Add TrackBack</div>
	<div class="body">
	<cfif isDefined("errorStr") and len(errorStr)>
		<b>#application.resourceBundle.getResource("correctissues")#:</b><ul>#errorStr#</ul>
	</cfif>
	<form action="#Request.commonCode.makeLinkToSelf('', true)#&id=#url.id#" method="post" enctype="application/x-www-form-urlencoded">
	<table>
	<tr>
		<td><NOBR>Your Blog Name:</NOBR></td>
		<td><input type="text" name="blog_name" value="#form.blog_name#" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td><NOBR>Your Blog Entry Title:</NOBR></td>
		<td><input type="text" name="title" value="#form.title#" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td colspan=2>
		Excerpt from your Blog Entry:<br>
		<textarea name="excerpt" cols=65 rows=10>#form.excerpt#</textarea>
		</td>
	</tr>
	<tr>
		<td><NOBR>Your Blog Entry URL:</NOBR></td>
		<td><input type="text" name="url" value="#form.url#" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="addtrackback" value="#application.resourceBundle.getResource("post")#"></td>
	</tr>
	</table>
	
	</form> 
	
	</div>
</cfif>

<cfif session.loggedin>
<div class="date">Send TrackBack</div>
<div class="body">
<script language="javascript">
	function setAction() {
		if (document.sendtb.trackbackURL.value == "") {
			alert('Please provide the trackback url');
			return false;
		}
		else {
			document.sendtb.action = document.sendtb.trackbackURL.value;
			document.sendtb.submit();
			return true;
		}
		
	}
</script>
<form action="" name="sendtb" method="post" enctype="application/x-www-form-urlencoded" onSubmit="return setAction();">
<table>
<tr>
	<td>Trackback URL:</td>
	<td><input type="text" name="trackbackURL" value=""></td>
</tr>
<tr>
	<td>Blog Name:</td>
	<td><input type="text" name="blog_name" value="#application.blog.getProperty("blogTitle")#"></td>
</tr>
<tr>
	<td>Your Blog Entry Title:</td>
	<td><input type="text" name="title" value="#article.title#" ></td>
</tr>
<tr>
	<td colspan=2>
	Excerpt from your Blog Entry:<br>
	<textarea name="excerpt" cols=50 rows=10>#left(article.body,255)#</textarea>
	</td>
</tr>
<tr>
	<td>Your Blog Entry URL:</td>
	<td><input type="text" name="url" value="#application.blog.makeLink(url.id)#"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="addtrackback" value="#application.resourceBundle.getResource("post")#"></td>
</tr>
</table>

</form> 

</div>
</cfif>
</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly=false>