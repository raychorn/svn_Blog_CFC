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
	<cfif (NOT isDebugMode())>
		<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/decontextmenu.js" type="text/javascript"></script>
	</cfif>

	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/CrossBrowserLibrary.js" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/CrossBrowserLibrary2.js" type="text/javascript"></script>

	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/AnchorPosition.js" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/support.js" type="text/javascript"></script>
	
	<script language="JavaScript1.2" type="text/javascript">
		var tid_updateBlogStatsDateTime = -1;
		var tid_ajax_updateBlogStatsDateTime = -1;
		
		function handle_onUnLoad() {
			if ( (!!tid_updateBlogStatsDateTime) && (tid_updateBlogStatsDateTime > -1) ) {
				clearInterval(tid_updateBlogStatsDateTime);
				tid_updateBlogStatsDateTime = -1;
			}
			
			if ( (!!tid_ajax_updateBlogStatsDateTime) && (tid_ajax_updateBlogStatsDateTime > -1) ) {
				clearInterval(tid_ajax_updateBlogStatsDateTime);
				tid_ajax_updateBlogStatsDateTime = -1;
			}
		}
	</script>
</head>

<body onunload="handle_onUnLoad()">
	<cfset _launchCommentURL = Request.commonCode.makeLinkToSelfBase("addcomment.cfm")>
	<cfset _launchTrackbackURL = Request.commonCode.makeLinkToSelfBase("trackbacks.cfm")>
	<cfset _launchBlogEditorURL = Request.commonCode.makeLinkToSelfBase("editor.cfm")>
	<cfset _launchCategoryEditorURL = Request.commonCode.makeLinkToSelfBase("category_editor.cfm")>
	<cfset _launchCopyrightViolationsURL = Request.commonCode.makeLinkToSelfBase("copyright_violations.cfm")>
	<cfset _launchMakeSELinksURL = Request.commonCode.makeLinkToSelfBase("makeSElinks.cfm")>
	<cfset _launchGoogleSiteMapURL = Request.commonCode.makeLinkToSelfBase("googlesitemap.cfm")>

	<script language="JavaScript1.2" type="text/javascript">
		var js_launchCommentURL = '#_launchCommentURL#';
		var js_launchTrackbackURL = '#_launchTrackbackURL#';
		var js_launchBlogEditorURL = '#_launchBlogEditorURL#';
		var js_launchCategoryEditorURL = '#_launchCategoryEditorURL#';
		var js_launchCopyrightViolationsURL = '#_launchCopyrightViolationsURL#';
		var js_launchMakeSELinksURL = '#_launchMakeSELinksURL#';
		var js_launchGoogleSiteMapURL = '#_launchGoogleSiteMapURL#';
	</script>

	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/BlogSupportLibrary.js" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/BlogSupportLibraryAdmin.js" type="text/javascript"></script>

	<script language="JavaScript1.2" src="#_urlBase#cfcontent_js.cfm?jsName=../js/snapins.js" type="text/javascript"></script>
	
<cfif (isDebugMode()) AND (NOT attributes.suppressLayout)>
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
				<cfif (NOT attributes.suppressLayout)>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<cfif (NOT Request.commonCode.isUserPremium())>
								<td width="45%" align="left" valign="top">
									<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'agooglead.cfm', '/'))>
									<iframe id="iframe_google_ad" name="iframe_google_ad" frameborder="0" scrolling="No" width="480" height="75" src="#_url#&enableMetaRefresh=30"></iframe>
									<center><span class="redBlogArticleAccessBoldPrompt">Upgrade to a Premium Subscription to remove these Ads.</span></center>
								</td>
							</cfif>
							<td width="55%" align="left" valign="middle">
								<table width="100%" border="0" cellpadding="1" cellspacing="1">
									<tr>
										<td width="15%" align="center" valign="top">
											<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>
												<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
													<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'register.cfm', '/'))>
													<button name="btn_registerButton" id="btn_registerButton" type="submit" class="registerButtonClass" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="this.disabled = true; window.location.href = '#_url#'; return false;">[Register]</button>
												</cfif>
											</cfif>
										</td>
										<td width="15%" align="center" valign="top">
											<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
												<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Session.persistData.loggedin)>
													<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'login.cfm', '/'))>
													<button name="btn_loginButton" id="btn_loginButton" type="submit" class="loginButtonClass" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> onclick="this.disabled = true; window.location.href = '#_url#'; return false;" value="PerformLogin">[Login]</button>
												<cfelse>
													<cfset _usersFullName = Request.commonCode.loggedInUsersFullName()>
													<cfset _logoutURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/logout')>
													<span class="normalPrompt"><NOBR>Welcome back <u>#_usersFullName#</u></NOBR><br><NOBR>Click <a href="#_logoutURL#" <cfif isDebugMode()>title="_url = [#_logoutURL#]"</cfif>>Here</a> if you are not <u>#_usersFullName#</u></NOBR><br><NOBR><a href="#_logoutURL#">Click Here to Logout</a></NOBR></span>
												</cfif>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="15%" align="center" valign="top">
											<cfif (IsDefined("Session.persistData.loggedin")) AND (NOT Request.commonCode.isUserPremium())>
												<cfif (IsDefined("Session.persistData.loggedin")) AND (Session.persistData.loggedin) AND (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/premium.cfm", CGI.SCRIPT_NAME) eq 0)>
													<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'premium.cfm', '/'))>
													<button name="btn_premiumButton" id="btn_premiumButton" type="submit" class="registerButtonClass" title="Premium Services are under development and will be released soon." onclick="this.disabled = true; window.location.href = '#_url#'; return false;">[Premium]</button>
												</cfif>
											</cfif>
										</td>
										<td width="55%" align="center" valign="top">
											<cfset diffT = 1>
											<cfset periodT = (Minute(Now()) / 10)>
											<cfif (periodT MOD 2) eq 0>
												<cfset diffT = -1>
											</cfif>
											<span class="normalBoldBluePrompt"><div id="div_blogStatsDateTime0">There are currently #Ceiling((Hour(Now()) * 60) + ((diffT * 5) * periodT))# Users Online as of </div><div id="div_blogStatsDateTime">#DateFormat(Now(), "full")# #TimeFormat(Now(), "full")#</div></span>
										</td>
									</tr>
									<cfsavecontent variable="ezClusterLink">
										<cfoutput>
											<a href="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')#/blog/downloads/ezCluster(tm).htm" target="_blank"><span class="normalBoldGreenPrompt">ezCluster</span><SUP><span class="normalBoldGreenTmPrompt">TM</span></SUP></a>
										</cfoutput>
									</cfsavecontent>
									<cfsavecontent variable="_poweredHTML">
										<cfoutput>
											<center>
												<span class="normalBoldGreenPrompt">This Blog is powered by </span>#ezClusterLink#
											</center>
											#ezClusterLink#<span class="normalBluePrompt"> makes 2 or more of your web servers into a single super-computer web server using cheap off-the-shelf PC's.</span>
										</cfoutput>
									</cfsavecontent>
									<cfif (NOT Session.persistData.loggedin)>
										<tr>
											<td colspan="3" align="left" valign="top">
												<span class="redBlogArticleAccessBoldPrompt">Registered Users get <u>unlimited</u> access to Downloads, Blog Articles, Comments and Trackbacks as well as other soon to be announced Features.  There is <u>No Cost</u> to Get Registered.</span>
											</td>
											<td colspan="2" align="left" valign="top">
												#_poweredHTML#
											</td>
										</tr>
									<cfelseif (NOT Request.commonCode.isUserPremium())>
										<tr>
											<td colspan="3" align="left" valign="top">
												<span class="redBlogArticleAccessBoldPrompt">Premium Users get <u>unlimited</u> access to Downloads, RSS Feeds and Online Chat and NO BANNER ADs as well as other soon to be announced Features.</span>
											</td>
											<td colspan="2" align="left" valign="top">
												#_poweredHTML#
											</td>
										</tr>
									</cfif>
								</table>
							</td>
						</tr>
					</table>
				</cfif>
			</td>
		</tr>
	<cfif (NOT attributes.suppressLayout)>
		<tr valign="top">
			<td colspan=2><div id="banner">#application.blog.getProperty("blogTitle")#</div></td>
		</tr>
	</cfif>
	<cfif (Session.rejectedLogin) OR (Session.rejectedInvalidLogin)>
		<tr valign="top">
			<cfset _eulaURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/i/eula')>
			<cfset _eulaContent = Replace(application.resourceBundle.getResource("rejectedloginattempt"), "(+++)", _eulaURL)>
			<td colspan=2><h3 align="center" style="color: red;">#_eulaContent#</h3></td>
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
										<a href="" onclick="launchBlogEditor(true, 'new'); return false;">#application.resourceBundle.getResource("addnewentry")#</a>
									</td>
									<td align="center">
										<a href="" onclick="launchCategoryEditor(true, #innerWidth#); return false;">#application.resourceBundle.getResource("categoryeditor")#</a>
									</td>
									<td align="center">
										<a href="" onclick="launchCopyrightViolations(true, #innerWidth#); return false;">#application.resourceBundle.getResource("copyrightviolations")#</a>
									</td>
									<td align="left">
										<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
										<a href="#_mainURL#?reinit=7660">#application.resourceBundle.getResource("resetscopecache")#</a>
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

<cfif (NOT attributes.suppressLayout)>
	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<span class="normalBluePrompt">&copy; Hierarchical Applications Limited, All Rights Reserved.  No Content may be used or reused from this site without specific written permission from the owners of this site.<br>
				This Blog was created using State-of-the-Art Techniques powered by #ezClusterLink#.  This Blog is the shape of things to come; Blogging combined and Social Networking - together at last !
				</span>
			</td>
			<td>
				<cfset _actionURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), 'contactUs.cfm', '/'))>
				<a name="anchor_contactUs" href="" <cfif isDebugMode()>title="_url = [#_actionURL#]"</cfif> onclick="var anchorPos = getAnchorPosition('anchor_contactUs'); var oObj = displayPopUpAtForDiv($('div_contactUs'), anchorPos); displayContactUsContentIn(oObj, '#_actionURL#'); return false;">Contact Us</a>
			</td>
		</tr>
	</table>
	
	<div id="div_contactUs" style="display: none;"></div>
</cfif>

<iframe id="iframe_updateBlogStatsDateTime" frameborder="1" scrolling="Auto" width="100%" height="100" style="display: none;"></iframe>

<script language="JavaScript1.2" type="text/javascript">
	function ajax_updateBlogStatsDateTime() {
		var oFrame = $('iframe_updateBlogStatsDateTime');
		if (!!oFrame) {
			var ar = window.location.href.split('/')
			var sHref = '';
			try {
				var sAR = ar[2].split('.');
				var sAR2 = [];
				sAR2.push(sAR[0]);
				sAR2.push(sAR[sAR.length - 2]);
				sAR2.push(sAR[sAR.length - 1]);
				sHref = sAR2.join('.');
				oFrame.src = 'http:\/\/' + sHref + '\/' + ar[3] + '\/' + 'updateBlogStatsDateTime.cfm?uuid=' + uuid();
			} catch(e) {
			} finally {
			}
		}
	}
	
	function updateBlogStatsDateTime() {
		var tObj = $('div_blogStatsDateTime');
		if (!!tObj) {
			try {
				var i = -1;
				var ar = tObj.innerHTML.split(',');
				for (i = 0; i < ar.length; i++) {
					ar[i] = ar[i].split(' ');
				}
				var dt = new Date(tObj.innerHTML);
				if (!isNaN(dt)) {
					dt.setSeconds(dt.getSeconds() + 1);
					tObj.innerHTML = dt.toLocaleString() + ' ' + ar[2][ar[2].length - 1];
				} else {
				//	window.status = dt.toUTCString() + '| ' + dt.toLocaleString() + ' [' + ar.join('|') + ']' + ' (' + ar[2][ar[2].length - 1] + ')';
				}
			} catch(e) {
			//	jsErrorExplainer(e, '111');
			} finally {
			}
		}
	}
	
	function refresh_blogStatsDateTimeFromAjax(x1, x2) {
		var oObj1 = $('div_blogStatsDateTime0');
		var oObj2 = $('div_blogStatsDateTime');
		if ( (!!oObj1) && (!!oObj2) && (!!x1) && (!!x2) ) {
			oObj1.innerHTML = x1;
			oObj2.innerHTML = x2;
		}
	}
	
	tid_updateBlogStatsDateTime = setInterval("updateBlogStatsDateTime()", 1000);

	tid_ajax_updateBlogStatsDateTime = setInterval("ajax_updateBlogStatsDateTime", 1000 * (60 * 10));
</script>

</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>
