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

<cfset _ID = -1>
<cfif isDefined("url.id")>
	<cfset _ID = url.id>
<cfelseif isDefined("form.id")>
	<cfset _ID = form.id>
</cfif>

<cftry>
	<cfset entry = application.blog.getEntry(_ID)>
	<cfset comments = application.blog.getComments(_ID)>
	<cfcatch type="Any">
	</cfcatch>
</cftry>

<cfif isDefined("url.delete") and session.persistData.loggedin>
	<cfset application.blog.deleteComment(url.delete)>
	<cfset comments = application.blog.getComments(_ID)>
</cfif>

<cfif isDefined("form.addcomment")>
	<cfset form.name = trim(form.name)>
	<cfset form.email = trim(form.email)>
	<!--- RBB 11/02/2005: Added new website option --->
	<cfset form.website = trim(form.website)>
	<cfset form.comments = trim(form.comments)>

	<cfset errorStr = "">

	<cfif not len(form.name) AND (NOT IsDefined("Session.persistData.qauthuser.UNAME"))>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludename") & "<br>">
	<cfelseif (IsDefined("Session.persistData.qauthuser.UNAME"))>
		<cfset form.name = Session.persistData.qauthuser.UNAME>
	</cfif>
	<cfif (not len(form.email) or not Request.commonCode.isEmail(form.email)) AND (NOT IsDefined("Session.persistData.qauthuser.USERNAME"))>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludeemail") & "<br>">
	<cfelseif (IsDefined("Session.persistData.qauthuser.USERNAME"))>
		<cfset form.email = Session.persistData.qauthuser.USERNAME>
	</cfif>
	<cfif not len(form.comments)>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludecomments") & "<br>">
	</cfif>
	<cfif not len(errorStr)>
	  <!--- RBB 11/02/2005: added website to commentID --->
		<cfset commentID = application.blog.addComment(_ID,left(form.name,100), left(form.email,100), left(form.website,255), form.comments, form.subscribe)>
		<!--- Form a message about the comment --->
		<cfset subject = application.resourceBundle.getResource("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & application.resourceBundle.getResource("entry") & ": " & entry.title>
		<cfsavecontent variable="email">
		<cfoutput>
#application.resourceBundle.getResource("commentaddedtoblogentry")#:	#entry.title#<br>
#application.resourceBundle.getResource("commentadded")#: 			#application.localeUtils.dateLocaleFormat(now())# / #application.localeUtils.timeLocaleFormat(now())#<br>
#application.resourceBundle.getResource("commentmadeby")#:	 		#form.name# (#form.email# / #form.website#)<br>
URL: #application.blog.makeLink(_ID)#
<br><br>
#form.comments#
<br><br>
------------------------------------------------------------
#application.resourceBundle.getResource("unsubscribe")#: %unsubscribe%
&copy; Hierarchical Applications Limited, All Rights Reserved.		</cfoutput>
		</cfsavecontent>

		<cfset application.blog.notifyEntry(entry.id, trim(email), subject, form.email)>
		
		<cfset comments = application.blog.getComments(_ID)>
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
	<link rel="stylesheet" href="#Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<link rel="shortcut icon" href="#Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
	#application.snapIns.rootSnapIn.html_nocache()#

	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/_index.cfm')>

	<script language="JavaScript1.2" type="text/javascript">
	<!--
		function closeCommentsAndRefreshHomePage(id) {
			if (!!parent.launchComment) parent.launchComment(id, false);
		}
	//-->
	</script>
	<cfif (NOT isDebugMode())>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
	</cfif>
</head>

<body>

<div class="date">#application.resourceBundle.getResource("comments")#: <cfif (IsDefined("entry.title"))>#entry.title#</cfif></div>
<div class="body">

<cfif (IsDefined("comments")) AND (IsQuery(comments))>
	<cfloop query="comments" startrow="1" endrow="#comments.recordCount#">
		<p>
		<div class="body">#Request.commonCode.paragraphFormat2(comment)#</div>
		</p>
		<!--- RBB 11/02/2005:  Added conditional logic to show name as a link to website, if website exists --->
		<p>
		<div class="byline">#application.resourceBundle.getResource("postedby")# <cfif len(comments.website)><a href="#comments.website#">#name#</a><cfelse>#name#</cfif> / #application.resourceBundle.getResource("postedat")# #application.localeUtils.dateLocaleFormat(posted,"short")# #application.localeUtils.timeLocaleFormat(posted)#<cfif session.persistData.loggedin> | <a href="#Request.commonCode.makeLinkToSelf('', true)#&id=#_ID#&delete=#id#">#application.resourceBundle.getResource("delete")#</a></cfif></div>
		</p>
		<hr noshade size=1>
		</p>
	</cfloop>
</cfif>

<div class="date">#application.resourceBundle.getResource("postyourcomments")#</div>

<cfif isDefined("errorStr") and len(errorStr)>
	<b>#application.resourceBundle.getResource("correctissues")#:</b><ul>#errorStr#</ul>
</cfif>

<cfif (session.persistData.loggedin) AND (NOT CGI.REQUEST_METHOD IS "POST")>
	<cfif (Request.bool_isDebugUser)>
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td align="center" valign="top">
					<cfdump var="#Application#" label="Application Scope" expand="No">
				</td>
				<td align="center" valign="top">
					<cfdump var="#Session#" label="Session Scope" expand="No">
				</td>
				<td align="center" valign="top">
					<cfdump var="#CGI#" label="CGI Scope" expand="No">
				</td>
				<td align="center" valign="top">
					<cfdump var="#FORM#" label="FORM Scope" expand="No">
				</td>
				<td align="center" valign="top">
					<cfdump var="#URL#" label="URL Scope" expand="No">
				</td>
			</tr>
		</table>
	</cfif>

	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/_index.cfm')>
	<form id="form_addComments" action="#_url#" method="post" enctype="application/x-www-form-urlencoded">
	
	<table border="1" width="100%">
	<tr>
		<td width="20%">#application.resourceBundle.getResource("name")#:</td>
		<td width="*"><cfif (Request.commonCode.isUserAdmin())><input type="text" name="name" value="#Session.persistData.qauthuser.UNAME#" size="80" maxlength="255"><cfelse><span class="normalBoldBluePrompt">#Session.persistData.qauthuser.UNAME#</span></cfif></td>
	</tr>
	<tr>
		<td>#application.resourceBundle.getResource("emailaddress")#:</td>
		<cfset _username = Session.persistData.qauthuser.USERNAME>
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
	<input type="hidden" name="id" value="#_ID#">
	<cfif (IsDefined("Session.sessID"))>
		<input type="hidden" name="sessID" value="#Session.sessID#">
	</cfif>
	<tr>
		<td>&nbsp;</td>
		<td>
		<input type="submit" id="button_commentsSubmit" name="addcomment" value="#application.resourceBundle.getResource("post")#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>&nbsp;&nbsp;
		<input type="reset" value="#application.resourceBundle.getResource("cancel")#" onClick="closeCommentsAndRefreshHomePage('#_ID#'); return false;">
		</td>
	</tr>
	</table>
	
	</form>
<cfelseif (NOT IsDefined("session.persistData.loggedin")) OR (NOT session.persistData.loggedin)>
	<h2 align="center" style="color: red;">Your user session has expired.  PLS login again to resume your user session.</h2>
<cfelseif (CGI.REQUEST_METHOD IS "POST")>
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
	<a href="" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="if (!!parent.launchComment) parent.launchComment(id, false, '#_url#'); return false;">Click Here to Close the Add Comments Panel and Continue...</a>
</cfif>

</div>

</body>
</html>
</cfoutput>
