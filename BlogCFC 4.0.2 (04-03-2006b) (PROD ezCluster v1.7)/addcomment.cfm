<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : addcomment.cfm
	Author       : Raymond Camden 
	Created      : February 11, 2003
	Last Updated : November 9, 2005
	History      : Reset history for version 4.0
				   Rob Brooks-Bilson added "website" support (rkc 11/9/05)
	Purpose		 : Adds comments
--->

<cfinclude template="includes/udf.cfm">

<cfif (IsDefined("url.id"))>
	<cfset url.id = Trim(url.id)>
</cfif>

<cfif not isDefined("form.addcomment")>
	<cfif isDefined("cookie.blog_name")>
		<cfset form.name = cookie.blog_name>
		<cfset form.rememberMe = true>
	</cfif>
	<cfif isDefined("cookie.blog_email")>
		<cfset form.email = cookie.blog_email>
		<cfset form.rememberMe = true>
	</cfif>
	<!--- RBB 11/02/2005: Added new website check --->
	<cfif isDefined("cookie.blog_website")>
		<cfset form.website = cookie.blog_website>
		<cfset form.rememberMe = true>
	</cfif>	
</cfif>

<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<!--- RBB 11/02/2005: Added new website parameter --->
<cfparam name="form.website" default="">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">

<cfif isDefined("url.id")>
	<cftry>
		<cfset entry = application.blog.getEntry(url.id)>
		<cfset comments = application.blog.getComments(url.id)>
		<cfcatch>
		</cfcatch>
	</cftry>
</cfif>

<cfif isDefined("url.delete") and session.loggedin>
	<cfset application.blog.deleteComment(url.delete)>
	<cfset comments = application.blog.getComments(url.id)>
</cfif>

<cfif isDefined("form.addcomment")>
	<cfset form.name = trim(form.name)>
	<cfset form.email = trim(form.email)>
	<!--- RBB 11/02/2005: Added new website option --->
	<cfset form.website = trim(form.website)>
	<cfset form.comments = trim(form.comments)>

	<cfset errorStr = "">

	<cfif not len(form.name)>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludename") & "<br>">
	</cfif>
	<cfif not len(form.email) or not isEmail(form.email)>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeemail") & "<br>">
	</cfif>
	<cfif not len(form.comments)>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludecomments") & "<br>">
	</cfif>
	<cfif not len(errorStr)>
	  <!--- RBB 11/02/2005: added website to commentID --->
		<cfset commentID = application.blog.addComment(url.id,left(form.name,100), left(form.email,100), left(form.website,255), form.comments, form.subscribe)>
		<!--- Form a message about the comment --->
		<cfset subject = application.resourceBundle.getResource("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & application.resourceBundle.getResource("entry") & ": " & entry.title>
		<cfsavecontent variable="email">
		<cfoutput>
#application.resourceBundle.getResource("commentaddedtoblogentry")#:	#entry.title#
#application.resourceBundle.getResource("commentadded")#: 			#application.localeUtils.dateLocaleFormat(now())# / #application.localeUtils.timeLocaleFormat(now())#
#application.resourceBundle.getResource("commentmadeby")#:	 		#form.name# (#form.email# / #form.website#)
URL: #application.blog.makeLink(url.id)#

#form.comments#

------------------------------------------------------------
#application.resourceBundle.getResource("unsubscribe")#: %unsubscribe%
This blog powered by RABID_BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com), made useful by (The Rabid CF Developer #Request.const_owners_blog_url#)
		</cfoutput>
		</cfsavecontent>

		<cfset application.blog.notifyEntry(entry.id, trim(email), subject, form.email)>
		
		<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
		<cfset comments = application.blog.getComments(url.id)>
		<!--- clear form data --->
		<cfif form.rememberMe>
			<cfcookie name="blog_name" value="#trim(htmlEditFormat(form.name))#" expires="never">
			<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
      		<!--- RBB 11/02/2005: Added new website cookie --->
			<cfcookie name="blog_website" value="#trim(htmlEditFormat(form.website))#" expires="never">
		<cfelse>
			<cfcookie name="blog_name" expires="now">
			<cfcookie name="blog_email" expires="now">
			<!--- RBB 11/02/2005: Added new website form var --->
			<cfset form.name = "">
			<cfset form.email = "">
			<cfset form.website = "">
		</cfif>
		<cfset form.comments = "">
	</cfif>	
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />

<html>
<head>
	<cfoutput><title>#application.blog.getProperty("blogTitle")# : #application.resourceBundle.getResource("addcomments")#</title></cfoutput>
	<link rel="stylesheet" href="includes/style.css" type="text/css"/>
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<cfoutput>
		#application.snapIns.rootSnapIn.html_nocache()#
	</cfoutput>
	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function closeCommentsAndRefreshHomePage(id) {
				if (!!parent.launchComment) parent.launchComment(id, false);
				var url = "#Request.commonCode.makeLinkToSelf('', true)#" + '&uuid=' + parent.uuid();
				parent.window.location.href = url;
			}
		//-->
		</script>
	</cfoutput>
</head>

<body>

<cfoutput>
<div class="date">#application.resourceBundle.getResource("comments")#: <cfif (IsDefined("entry.title"))>#entry.title#</cfif></div>
<div class="body">
</cfoutput>

<cfif (IsDefined("comments")) AND (IsQuery(comments))>
	<cfoutput query="comments">
		<p>
		<div class="body">#paragraphFormat2(comment)#</div>
		</p>
		<!--- RBB 11/02/2005:  Added conditional logic to show name as a link to website, if website exists --->
		<p>
		<div class="byline">#application.resourceBundle.getResource("postedby")# <cfif len(comments.website)><a href="#comments.website#">#name#</a><cfelse>#name#</cfif> / #application.resourceBundle.getResource("postedat")# #application.localeUtils.dateLocaleFormat(posted,"short")# #application.localeUtils.timeLocaleFormat(posted)#<cfif session.loggedin> | <a href="#Request.commonCode.makeLinkToSelf('', true)#&id=#url.id#&delete=#id#">#application.resourceBundle.getResource("delete")#</a></cfif></div>
		</p>
		<hr noshade size=1>
		</p>
	</cfoutput>
</cfif>

<cfoutput><div class="date">#application.resourceBundle.getResource("postyourcomments")#</div></cfoutput>

<cfif isDefined("errorStr") and len(errorStr)>
	<cfoutput><b>#application.resourceBundle.getResource("correctissues")#:</b><ul>#errorStr#</ul></cfoutput>
</cfif>

<cfoutput>
<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post">

<table border="0" width="100%">
<tr>
	<td>#application.resourceBundle.getResource("name")#:</td>
	<td><input type="text" name="name" value="#form.name#" style="width:100%"></td>
</tr>
<tr>
	<td>#application.resourceBundle.getResource("emailaddress")#:</td>
	<td><input type="text" name="email" value="#form.email#" style="width:100%"></td>
</tr>
<!--- RBB 11/02/2005:  Added website form element --->
<tr>
	<td>#application.resourceBundle.getResource("website")#:</td>
	<td><input type="text" name="website" value="#form.website#" style="width:100%" maxlength="255"></td>
</tr>
<tr valign="top">
	<td colspan=2>
	#application.resourceBundle.getResource("comments")#:<br>
	<textarea name="comments" cols=50 rows=10 style="width:100%">#form.comments#</textarea>
	</td>
</tr>
<tr>
	<td>#application.resourceBundle.getResource("remembermyinfo")#:</td>
	<td><input type="checkbox" name="rememberMe" value="1" <cfif form.rememberMe>checked</cfif>></td>
</tr>
<tr>
	<td>#application.resourceBundle.getResource("subscribe")#:</td>
	<td><input type="checkbox" name="subscribe" value="1" <cfif form.subscribe>checked</cfif>></td>
</tr>
<tr>
	<td colspan="2">#application.resourceBundle.getResource("subscribetext")#</td>
</tr>
<input type="hidden" name="id" value="#url.id#">
<tr>
	<td>&nbsp;</td>
	<td><input type="reset" value="#application.resourceBundle.getResource("cancel")#" onClick="closeCommentsAndRefreshHomePage('#url.id#'); return false;"> <input type="submit" name="addcomment" value="#application.resourceBundle.getResource("post")#"></td>
</tr>
</table>

</form>
</cfoutput>

</div>

<cfif (IsDefined("form.id")) AND (CGI.REQUEST_METHOD IS "POST")>
	<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		if (!!parent.launchComment) parent.launchComment('#form.id#', false);
		var url = "#Request.commonCode.makeLinkToSelf('', true)#" + '&uuid=' + parent.uuid();
		parent.window.location.href = url;
	//-->
	</script>
	</cfoutput>
	<cfabort>
</cfif>

</body>
</html>