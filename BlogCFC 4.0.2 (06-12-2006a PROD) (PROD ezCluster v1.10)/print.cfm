<cfsetting showdebugoutput="No">
<!---
	Name         : c:\projects\blog\client\print.cfm
	Author       : Raymond Camden 
	Created      : 09/23/05
	Last Updated : 11/11/05
	History      : Changed request.rooturl to app.rooturl (rkc 11/11/05)
--->
<cfparam name="wrapper" type="string" default="">

<cfparam name="media" type="string" default="FLASHPAPER">

<cfif (Len(wrapper) eq 0)>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
	
		<cfset Request.jsCodeObfuscationIndex = 1>
		<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
		<cfsavecontent variable="_jscode">
			<cfoutput>
				#Request.commonCode.readAndObfuscateJSCode('js/433511201010924803.dat')#
				#Request.commonCode.readAndObfuscateJSCode('js/decontextmenu.js')#
			</cfoutput>
		</cfsavecontent>
	
		<script language="JavaScript1.2" type="text/javascript">
			var isSiteHavingProblems = 0; 
			var xx$ = "#URLEncodedFormat(_jscode)#";
		</script>
	
		<script language="JavaScript1.2" type="text/javascript">
			if (!!xx$) { eval(unescape(xx$)) };
		</script>

		<script language="JavaScript1.2" type="text/javascript">
			<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
				#Request.jsCodeObfuscationDecoderAR[_i]#
			</cfloop>
		</script>
	</head>
	
	<body>
	
	<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&wrapper=yes')>
	<cfoutput>
		<cfif 1>
			<iframe id="iframe_primary_content" src="#_url#" align="left" frameborder="0" marginwidth="0" marginheight="0" scrolling="Auto" width="100%" height="100%">
			</iframe>
		<cfelse>
			#_url#
		</cfif>
	</cfoutput>
	
	</body>
	</html>
<cfelse>
	<cfif (IsDefined("url.id"))>
		<cfset url.id = Trim(url.id)>
	</cfif>
	
	<cftry>
		<cfset entry = application.blog.getEntry(url.id)>
		<cfcatch type="Any">
		</cfcatch>
	</cftry>
	
	<cfheader name="Expires" value="#GetHttpTimeString(DateAdd("yyyy", -50, Now()))#">
	<cfheader name="Content-Disposition" value="inline; filename=print.pdf">
	<cfdocument format="#media#">
		<cfoutput>
		<html>
		<head>
			<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
			<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
			<meta name="robots" content="noindex,nofollow" />
			#Request.commonCode.html_nocache()#
			<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
			<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />

			<cfsavecontent variable="_jscode">
				<cfoutput>
					function dHx$(ch) { var HX = "0123456789ABCDEF";if (!!ch) {return ((HX.indexOf(ch.charAt(0))) << 4) + HX.indexOf(ch.charAt(1));} return ch;} function _dHx$() {return dHx$(this);} String.prototype.dHx$ = _dHx$;
					function d$(enc,p){var teks="";var ar=enc[0];var p_i=0;for(var i=0;i<ar.length;i+=2){teks+=String.fromCharCode(ar.substr(i,2).dHx$()^p.charAt(p_i));p_i++;if(p_i>=p.length){p_i=0;};}return unescape(teks);}
					#Request.commonCode.readAndObfuscateJSCode('js/decontextmenu.js')#
				</cfoutput>
			</cfsavecontent>
		
			<script language="JavaScript1.2" type="text/javascript">
				var xx$ = "#URLEncodedFormat(_jscode)#";
			</script>
		
			<script language="JavaScript1.2" type="text/javascript">
				if (!!xx$) { eval(unescape(xx$)) };
			</script>
		</head>
		
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
		
		<cfset display = replace(display, "class=""code""", "class=""codePrint""", "all")>
		<cfoutput>#display#</cfoutput>
	
		<cfoutput>
		</body>
		</html>
		</cfoutput>
		
	</cfdocument>
</cfif>
