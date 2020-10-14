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
	<link rel="stylesheet" href="#Request.commonCode.clusterizeURL('#application.rooturl#/includes/style.css')#" type="text/css" />
	<!--- For Firefox --->
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#Request.commonCode.clusterizeURL('#application.rooturl#/rss.cfm?mode=full')#" />
	<link rel="shortcut icon" href="#Request.commonCode.clusterizeURL('#application.rooturl#/favicon.ico')#" type="image/x-icon" />
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsName=../js/decontextmenu.js')#" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsCodeBase=1')#" type="text/javascript"></script>
	<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_js.cfm?jsCodeBase=2')#" type="text/javascript"></script>
</head>

<body>

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
			<td align="center" valign="top">
				<cfif (IsDefined("Request.SessionCopy"))>
					<cfdump var="#Request.SessionCopy#" label="Request.SessionCopy" expand="No">
				</cfif>
			</td>
		</tr>
	</table>
</cfif>

<cfif (attributes.suppressLayout)>
	<cfset attributes.maxWidth = attributes.maxWidth + 200>
</cfif>

<table width="#attributes.maxWidth#">
<cfset innerWidth = attributes.maxWidth>
	<tr valign="top">
		<td colspan=2>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td width="45%" align="left" valign="top">
						<cfset rndBanner = RandRange(1, 4, "SHA1PRNG")>
						<cfif (rndBanner eq 1)>
							<script language="JavaScript1.2" type="text/javascript">
							<!--
							google_ad_client = "pub-9119838897885168";
							google_ad_width = 468;
							google_ad_height = 60;
							google_ad_format = "468x60_as_rimg";
							google_cpa_choice = "CAAQj6eVzgEaCIxA5niBniDSKOm293M";
							//-->
							</script>
						<cfelseif (rndBanner eq 2)>
							<script language="JavaScript1.2" type="text/javascript">
							<!--
							google_ad_client = "pub-9119838897885168";
							google_ad_width = 468;
							google_ad_height = 60;
							google_ad_format = "468x60_as_rimg";
							google_cpa_choice = "CAAQ8aaVzgEaCPJg3qtkyXM9KOm293M";
							//-->
							</script>
						<cfelseif (rndBanner eq 3)>
							<script language="JavaScript1.2" type="text/javascript">
							<!--
							google_ad_client = "pub-9119838897885168";
							google_ad_width = 468;
							google_ad_height = 60;
							google_ad_format = "468x60_as_rimg";
							google_cpa_choice = "CAAQ58WdzgEaCFLK1ovSD_DNKNvD93M";
							//-->
							</script>
						<cfelseif (rndBanner eq 4)>
							<script language="JavaScript1.2" type="text/javascript">
							<!--
							google_ad_client = "pub-9119838897885168";
							google_ad_width = 468;
							google_ad_height = 60;
							google_ad_format = "468x60_as_rimg";
							google_cpa_choice = "CAAQq8WdzgEaCCQIMpsWzihvKNvD93M";
							//-->
							</script>
						</cfif>
						<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
						</script>
					</td>
					<td width="55%" align="left" valign="middle">
						<table width="100%" border="0" cellpadding="1" cellspacing="1">
							<tr>
								<td width="25%" align="center" valign="top">
									<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
										<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("register.cfm", false), true)>
										<button name="btn_registerButton" id="btn_registerButton" type="submit" class="registerButtonClass" onclick="this.disabled = true; window.location.href = '#_url#'; return false;">[Register as New User]</button>
									</cfif>
								</td>
								<td width="30%" align="center" valign="top">
									<cfif (FindNoCase("/login.cfm", CGI.SCRIPT_NAME) eq 0) AND (FindNoCase("/register.cfm", CGI.SCRIPT_NAME) eq 0)>
										<cfif (IsDefined("Session.loggedin")) AND (NOT Session.loggedin)>
											<cfset _url = Request.commonCode._URLSessionFormat(Request.commonCode.makeLinkToSelf("login.cfm", false), true)>
											<button name="btn_loginButton" id="btn_loginButton" type="submit" class="loginButtonClass" onclick="this.disabled = true; window.location.href = '#_url#'; return false;" value="PerformLogin">[Login as Returning User]</button>
										<cfelse>
											<cfset _usersFullName = Request.commonCode.loggedInUsersFullName()>
											<span class="normalPrompt"><NOBR>Welcome back <u>#_usersFullName#</u></NOBR><br><NOBR>Click <a href="#Request.commonCode.makeLinkToSelf('', true)#&logout=youbet">Here</a> if you are not <u>#_usersFullName#</u></NOBR></span>
										</cfif>
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td width="45%" align="center" valign="top">
									<span class="normalBoldBluePrompt">There are currently #(Hour(Now()) * 60)# Users Online as of #DateFormat(Now(), "full")# #TimeFormat(Now(), "full")#</span>
								</td>
							</tr>
							<cfif (NOT Session.loggedin)>
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
		
		<cfif (session.loggedin) AND (Request.commonCode.isUserAdmin()) AND (NOT attributes.suppressLayout)>
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
									<a href="#application.rooturl#/index.cfm">Main</a>
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
									<a href="#Request.commonCode.makeLinkToSelf('', true)#&logout=youbet">#application.resourceBundle.getResource("logout")#</a>
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
		<td width="200">
		<div id="menu">
		
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
					
		</div>
		</td>
		</cfoutput>
	</cfif>
<cfoutput>
</tr>
</table>


</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>