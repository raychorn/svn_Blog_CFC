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
<cfoutput>
<html>
<head>
	<title>#application.blog.getProperty("blogTitle")# : #application.resourceBundle.getResource("addcomments")#</title>
	<link rel="stylesheet" href="#Request.commonCode.clusterizeURL('#application.rooturl#/includes/style.css')#" type="text/css"/>
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
		#application.snapIns.rootSnapIn.html_nocache()#
		<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("_index.cfm", false), true)>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function closeCommentsAndRefreshHomePage(id) {
				alert(111);
				try {
					if (!!parent.launchComment) parent.launchComment(id, false);
				} catch(e) {
					jsErrorExplainer(e, 'A. closeCommentsAndRefreshHomePage(' + id + ')'); 
				} finally {
				}
				alert(222 + ' parent.uuid = [' + parent.uuid + ']');
				try {
					var url = '#_url#' + ((parent.uuid) ? '&uuid=' + parent.uuid() : '');
				alert(333 + ' url = [' + url + ']');
					parent.window.location.href = url;
				} catch(e) {
					jsErrorExplainer(e, 'B. closeCommentsAndRefreshHomePage(' + id + ')'); 
				} finally {
				}
			}
		//-->
		</script>
</head>

<body>

<div class="date">#application.resourceBundle.getResource("comments")#: <cfif (IsDefined("entry.title"))>#entry.title#</cfif></div>
<div class="body">

<cfif (IsDefined("comments")) AND (IsQuery(comments))>
	<cfloop query="comments" startrow="1" endrow="#comments.recordCount#">
		<p>
		<div class="body">#paragraphFormat2(comment)#</div>
		</p>
		<!--- RBB 11/02/2005:  Added conditional logic to show name as a link to website, if website exists --->
		<p>
		<div class="byline">#application.resourceBundle.getResource("postedby")# <cfif len(comments.website)><a href="#comments.website#">#name#</a><cfelse>#name#</cfif> / #application.resourceBundle.getResource("postedat")# #application.localeUtils.dateLocaleFormat(posted,"short")# #application.localeUtils.timeLocaleFormat(posted)#<cfif session.loggedin> | <a href="#Request.commonCode.makeLinkToSelf('', true)#&id=#url.id#&delete=#id#">#application.resourceBundle.getResource("delete")#</a></cfif></div>
		</p>
		<hr noshade size=1>
		</p>
	</cfloop>
</cfif>

<div class="date">#application.resourceBundle.getResource("postyourcomments")#</div>

<cfif isDefined("errorStr") and len(errorStr)>
	<b>#application.resourceBundle.getResource("correctissues")#:</b><ul>#errorStr#</ul>
</cfif>

<cfif (session.loggedin)>
	<cfset _URL = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf(ListLast(CGI.SCRIPT_NAME, "/"), false), false)>
	<form id="form_addComments" action="#_URL#" method="post" enctype="application/x-www-form-urlencoded">
	
	<table border="1" width="100%">
	<tr>
		<td width="20%">#application.resourceBundle.getResource("name")#:</td>
		<td width="*"><cfif (Request.commonCode.isUserAdmin())><input type="text" name="name" value="#Session.qauthuser.UNAME#" size="80" maxlength="255"><cfelse><span class="normalBoldBluePrompt">#Session.qauthuser.UNAME#</span></cfif></td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("emailaddress")#:</td>
		<cfset _username = Session.qauthuser.USERNAME>
		<cfif (Request.commonCode.isUserAdmin())>
			<cfset _username = instance.ownerEmail>
		</cfif>
		<td><cfif (Request.commonCode.isUserAdmin())><input type="text" name="email" value="#_username#" size="30" maxlength="255"><cfelse><span class="normalBoldBluePrompt">#_username#</span></cfif>
		</td>
	</tr>
	<!--- RBB 11/02/2005:  Added website form element --->
	<tr>
		<td>#application.resourceBundle.getResource("website")#:</td>
		<td><input type="text" name="website" value="#form.website#" size="80" maxlength="255"></td>
	</tr>
	<tr valign="top">
		<td colspan=2>
		#application.resourceBundle.getResource("comments")#:<br>
		<textarea name="comments" cols=50 rows=5 style="width:100%">#form.comments#</textarea>
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
		<td>
		<input type="submit" id="button_commentsSubmit" name="addcomment" value="#application.resourceBundle.getResource("post")#" onclick="delayedButtonDisablerByID(this.id, 'form_addComments'); return false;">&nbsp;&nbsp;
		<input type="reset" value="#application.resourceBundle.getResource("cancel")#" onClick="closeCommentsAndRefreshHomePage('#url.id#'); return false;">
		</td>
	</tr>
	</table>
	
	</form>
</cfif>

</div>

<cfif (IsDefined("form.id")) AND (CGI.REQUEST_METHOD IS "POST")>
	<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("", false), true)>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		if (!!parent.launchComment) parent.launchComment('#form.id#', false);
		var url = "#_url#" + '&uuid=' + parent.uuid();
		parent.window.location.href = url;
	//-->
	</script>
	<cfabort>
</cfif>

</body>
</html>
</cfoutput>