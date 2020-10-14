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

<cfparam name="attributes.maxWidth" type="integer" default="700">

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
	<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
	<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
	<cfif isDefined("url.mode") and url.mode is "entry">
		<!--- index entry page --->
		<meta name="robots" content="index,follow" />
	<cfelse>
		<!--- don't index other pages --->
		<meta name="robots" content="index,follow" />	  
	</cfif>
	#application.snapIns.rootSnapIn.html_nocache()#
	<meta name="title" content="#application.blog.getProperty("blogTitle")##additionalTitle#" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<meta name="description" content="#application.blog.getProperty("blogDescription")##additionalTitle#" />
	<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#,#application.blog.getProperty("trackbackspamlist")#">
	<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
	<!--- For Firefox --->
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/rss.cfm')#&mode=full" />
	<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
	<cfset _urlBase = 'http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/'>
	<cfif (NOT Request.bool_isDebugMode)>
		<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/decontextmenu.js" type="text/javascript"></script>
	</cfif>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsCodeBase=1" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsCodeBase=1a" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsCodeBase=2" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/AnchorPosition.js" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/support.js" type="text/javascript"></script>

	<cfif 0>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function _onUnload() {
				if (!!tid_refreshGoogleAd) {
					clearInterval(tid_refreshGoogleAd);
				}
			}
		//-->
		</script>
	</cfif>
</head>

<cfif 0>
	<body onunload="_onUnload()">
<cfelse>
	<body>
</cfif>

<cfif (Request.bool_isDebugUser) OR 1>
	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td align="center" valign="top">
				<cfdump var="#Application#" label="App Scope" expand="No">
			</td>
			<td align="center" valign="top">
				<cfdump var="#Session#" label="Session Scope [#Session.sessID#]" expand="No">
			</td>
			<td align="center" valign="top">
				<cfdump var="#Request#" label="Request Scope" expand="No">
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

</cfoutput>

</cfif>

<cfif (attributes.suppressLayout)>
	<cfset attributes.maxWidth = attributes.maxWidth + 200>
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
	
	<table width="#attributes.maxWidth#">
	<cfset innerWidth = attributes.maxWidth>
		<tr valign="top">
			<td colspan=2>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td width="45%" align="left" valign="top">
							<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'agooglead.cfm', '/'))>
							<iframe id="iframe_google_ad" name="iframe_google_ad" frameborder="0" scrolling="No" width="480" height="75" src="#_url#&enableMetaRefresh=30"></iframe>

							<cfif 0>
								<script language="JavaScript1.2" type="text/javascript">
								<!--
									function refreshGoogleAd(url) {
										var oObj = $('iframe_google_ad');
										if (!!oObj) {
											oObj.src = url + '&uuid=' + uuid();
										}
									}
		
									var oObj = $('iframe_google_ad');
									if (!!oObj) {
										var tid_refreshGoogleAd = setInterval("refreshGoogleAd('" + oObj.src + "')", 30000);
									}
								//-->
								</script>
							</cfif>
						</td>
						<td width="55%" align="left" valign="middle">
							<table width="100%" border="0" cellpadding="1" cellspacing="1">
								<tr>
									<td width="25%" align="center" valign="top">
										<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>
											<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
												<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'register.cfm', '/'))>
												<button name="btn_registerButton" id="btn_registerButton" type="submit" class="registerButtonClass" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="this.disabled = true; window.location.href = '#_url#'; return false;">[Register as New User]</button>
											</cfif>
										</cfif>
									</td>
									<td width="30%" align="center" valign="top">
										<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
											<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>
												<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'login.cfm', '/'))>
												<button name="btn_loginButton" id="btn_loginButton" type="submit" class="loginButtonClass" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="this.disabled = true; window.location.href = '#_url#'; return false;" value="PerformLogin">[Login as Returning User]</button>
											<cfelse>
												<cfset _usersFullName = Request.commonCode.loggedInUsersFullName()>
												<cfset _logoutURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/_index.cfm') & "&logout=youbet">
												<span class="normalPrompt"><NOBR>Welcome back <u>#_usersFullName#</u></NOBR><br><NOBR>Click <a href="#_logoutURL#" <cfif isDebugMode()>title="_url = [#_logoutURL#]"</cfif>>Here</a> if you are not <u>#_usersFullName#</u></NOBR><br><NOBR><a href="#_logoutURL#">Click Here to Logout</a></NOBR></span>
											</cfif>
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td width="45%" align="center" valign="top">
										<span class="normalBoldBluePrompt">There are currently #(Hour(Now()) * 60)# Users Online as of #DateFormat(Now(), "full")# #TimeFormat(Now(), "full")#</span>
									</td>
								</tr>
								<cfif (NOT Session.persistData.loggedin)>
									<tr>
										<td colspan="3" align="left" valign="top">
											<span class="redBlogArticleAccessBoldPrompt">Registered Users get <u>unlimited</u> access to Downloads, Blog Articles, Comments and Trackbacks as well as other soon to be announced Features.  There is <u>No Cost</u> to Get Registered.</span>
										</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	<cfif (NOT attributes.suppressLayout)>
		<tr valign="top">
			<td colspan=2><div id="banner">#application.blog.getProperty("blogTitle")#</div></td>
		</tr>
	</cfif>
	<tr valign="top">
		<td width="#innerWidth#">
	
		<div id="content">
		
			<div id="blogText">
			
			<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin()) AND (NOT attributes.suppressLayout)>
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
										<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
										<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>Main</a>
									</td>
									<td align="center">
										<a href="" onclick="launchBlogEditor(true, 'new'); return false;">#application.resourceBundle.getResource("addnewentry")#</a>
									</td>
									<td align="center">
										<a href="" onclick="launchCategoryEditor(true, #innerWidth#); return false;">#application.resourceBundle.getResource("categoryeditor")#</a>
									</td>
									<td align="center">
										<a href="" onclick="launchCopyrightViolations(true, #innerWidth#); return false;">#application.resourceBundle.getResource("copyrightviolations")#</a>
									</td>
									<td align="center">
										<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/_index.cfm') & "&logout=youbet">
										<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("logout")#</a>
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
											<button class="normalBoldPrompt" onclick="launchCategoryEditor(false, #innerWidth#); return false;">[X]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<div id="div_iframe_category_editor">
								</div>
							</td>
						</tr>
					</table>
				</div>
	
				<div id="div_copyright_violations" style="display: none;">
					<table width="#innerWidth#" border="1" cellpadding="-1" cellspacing="-1">
						<tr>
							<td bgcolor="silver">
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td align="center">
											<span class="normalBoldPrompt">(You may Manage your Copyright Violations using the form below and then Click the "[X]" to the right when you are done and wish to proceed.)</span>
										</td>
										<td align="right">
											<button class="normalBoldPrompt" onclick="launchCopyrightViolations(false, #innerWidth#); return false;">[X]</button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<div id="div_iframe_copyright_violations">
								</div>
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
								<div id="div_iframe_blog_editor">
								</div>
							</td>
						</tr>
					</table>
				</div>
			<cfelse>
			</cfif>
	
	</cfoutput>
<cfelse>

	<cfoutput>
			</div>
			
		</td>
		</cfoutput>
		<cfif (NOT attributes.suppressLayout)>
			<cfoutput>
			<td width="100%">
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
			</td>
			</cfoutput>
		</cfif>
	<cfoutput>
	</tr>
	</table>
	</cfoutput>

</cfif>

<cfif NOT thisTag.executionMode is "start">

<cfoutput>

<table width="100%" cellpadding="-1" cellspacing="-1">
	<tr>
		<td>
			<span class="normalBluePrompt">&copy; Hierarchical Applications Limited, All Rights Reserved.  No Content may be used or reused from this site without specific written permission from the owners of this site.</span>
		</td>
		<td>
			<cfset _actionURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'contactUs.cfm', '/'))>
			<a name="anchor_contactUs" href="" <cfif isDebugMode()>title="_url = [#_actionURL#]"</cfif> onclick="var anchorPos = getAnchorPosition('anchor_contactUs'); var oObj = displayPopUpAtForDiv($('div_contactUs'), anchorPos); displayContactUsContentIn(oObj, '#_actionURL#'); return false;">Contact Us</a>
		</td>
	</tr>
</table>

<div id="div_contactUs" style="display: none;"></div>

</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>