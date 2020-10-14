<cfsetting enablecfoutputonly=true>

<cfprocessingdirective pageencoding="utf-8">

<cfsetting showdebugoutput="No">

<cfset ezAJAXProductName = '<NOBR>ezAJAX&##8482</NOBR>'>

<!--- 
mode=entry&entry=D55CB570-1026-0A9B-23CA9D5C63A5DCB2&sessID=DB2160AF-EF2F-E252-75506521591905E6
 --->

<cfparam name="URL.mode" type="string" default="">
<cfparam name="URL.entry" type="string" default="">

<cfif ( (NOT IsDefined("URL.mode")) AND (NOT IsDefined("URL.entry")) ) OR ( (IsDefined("URL.mode")) AND (IsDefined("URL.entry")) AND (Len(CGI.HTTP_REFERER) gt 0) AND (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) eq 0) ) OR (Request.commonCode.isSpiderBot()) OR (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
		<html>
		<head>
			<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
			<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
			<meta name="robots" content="index,follow" />	  
			<meta name="title" content="#application.blog.getProperty("blogTitle")#" />
			<meta content="text/html; charset=UTF-8" http-equiv="content-type">
			<meta name="description" content="#application.blog.getProperty("blogDescription")#" />
			<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#,#application.blog.getProperty("trackbackspamlist")#">
			<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
			<!--- For Firefox --->
			<link rel="alternate" type="application/rss+xml" title="RSS" href="#Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/rss.cfm')#&mode=full" />
			<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
<cfif 0>
			<script language="JavaScript1.2" type="text/javascript">
				var hRef = window.location.href; 
				var ar = hRef.split('?'); 
				var ar2 = ar[0].split('/'); 
				if (hRef.indexOf('/main/') > -1) { 
					ar2.pop(); ar2.pop(); 
				}; 
				ar2[ar2.length - 1] = 'original_index.cfm'; 
				ar[0] = ar2.join('/'); 
				hRef = ar.join('?'); 
				window.location.href = hRef;
				/* alert(this.id + '\n' + hRef); */
			</script>
<cfelse>
			<script language="JavaScript1.2" type="text/javascript">
				var hRef = window.location.href; 
				var ar = hRef.split('?'); 
				var ar2 = ar[0].split('/'); 
				if (hRef.indexOf('/main/') > -1) { 
					ar2.pop(); ar2.pop(); 
				}; 
				ar2[ar2.length - 1] = 'AJAX-Framework/index.cfm'; 
				ar[0] = ar2.join('/'); 
				hRef = ar.join('?'); 
				window.location.href = hRef;
			</script>
</cfif>
			
		</head>
		
		<body>
			<table width="80%" cellpadding="2" cellspacing="1" align="center">
				<tr bgcolor="##c0c0c0">
					<td width="50%" valign="top" align="center">
						<small><b>Non-AJAX Blog</b></small>
					</td>
					<td width="50%" valign="top" align="center">
						<small><b>#ezAJAXProductName# Blog</b></small>
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top" align="center">
						<small>This version of the Blog was architected to use very little AJAX except for the Login and Registration GUI.</small>
						<br><br>
						<small>You may notice how much easier it is to use the #ezAJAXProductName# Blog than the non-AJAX Blog as well as how much faster the #ezAJAXProductName# Blog seems to operate.</small>
						<br><br>
						<small>One programmer was able to recode the entire Blog GUI to use #ezAJAXProductName# in less than 2 weeks.  Just imagine how many AJAX Applications YOU will be able to code using #ezAJAXProductName#.</small>
					</td>
					<td width="50%" valign="top" align="center">
						<small>This version of the Blog was architected to use an exciting new product called #ezAJAXProductName#.</small>
						<br><br>
						<small>#ezAJAXProductName# provides a very powerful ColdFusion based Framework combined with a very powerful JavaScript AJAX Engine that allows for Rapid AJAX Application Development with very little effort and very little programming resources.</small>
						<br><br>
						<small>Return here to download your FREE Evaluation copy of #ezAJAXProductName# soon.</small>
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top" align="center">
						<button id="btn_nonAJAXBlog" class="buttonClass" onclick="var hRef = window.location.href; var ar = hRef.split('?'); var ar2 = ar[0].split('/'); if (hRef.indexOf('/main/') > -1) { ar2.pop(); ar2.pop(); }; ar2[ar2.length - 1] = 'original_index.cfm'; ar[0] = ar2.join('/'); hRef = ar.join('?'); window.location.href = hRef; /* alert(this.id + '\n' + hRef); */ return false;">Enter the Non-AJAX Blog</button>
					</td>
					<td width="50%" valign="top" align="center">
						<button id="btn_ezAJAXBlog" class="buttonClass" onclick="var hRef = window.location.href; var ar = hRef.split('?'); var ar2 = ar[0].split('/'); if (hRef.indexOf('/main/') > -1) { ar2.pop(); ar2.pop(); }; ar2[ar2.length - 1] = 'AJAX-Framework/index.cfm'; ar[0] = ar2.join('/'); hRef = ar.join('?'); window.location.href = hRef; /* alert(this.id + '\n' + hRef); */ return false;">Enter the #ezAJAXProductName# Blog</button>
					</td>
				</tr>
			</table>
		</body>
		</html>
	</cfoutput>
<cfelse>
	<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/AJAX-Framework/index.cfm?#CGI.QUERY_STRING#'>
	<cflocation url="#_url#" addtoken="No">
</cfif>

<cfsetting enablecfoutputonly=false>	
