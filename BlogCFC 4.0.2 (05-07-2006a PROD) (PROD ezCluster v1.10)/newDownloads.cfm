<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_tPath" type="string" default="">
<cfparam name="_folder" type="string" default="">

<cfoutput>
	<html>
	<head>
		<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />

		<cfsavecontent variable="_jscode">
			<cfoutput>
				#Request.commonCode.readAndObfuscateJSCode('js/433511201010924803.dat')#
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
		<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/'>
		<cfscript>
			path = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
			downloadsPath = path & 'downloads';
			if ( (Len(_tPath) gt 0) AND (Len(_folder) gt 0) ) {
				downloadsPath = _tPath & _folder;
			}
			tPath = GetDirectoryFromPath(CGI.PATH_TRANSLATED);
			scriptName = ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
			
		//	writeOutput('<small><b>downloadsPath = [#downloadsPath#], tPath = [#tPath#], _tPath = [#_tPath#], _folder = [#_folder#]</b></small><br>');

			bool_isError = Request.commonCode.cf_directory('Request.qDir', downloadsPath, '', false);
		</cfscript>

		<cfif (0)>
			<cfdump var="#Request.qDir#" label="Request.qDir [#bool_isError#]" expand="No">
		</cfif>

		<cftry>
			<cfscript>
				if (NOT bool_isError) {
					bool_upFolder = false;
					writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
					for (i = 1; ( (i lte Request.qDir.recordCount) OR ( (Request.qDir.recordCount eq 0) AND (NOT bool_upFolder) ) ); i = i + 1) {
						ttPath = ReplaceNoCase(Request.qDir.DIRECTORY[i], tPath, '');
						sName = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & Replace(ttPath, '\', '/', 'all') & '/' & Request.qDir.NAME[i];
						if ( (NOT (ttPath is 'downloads')) AND (NOT bool_upFolder) ) {
							_urlOpenDir = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#' & CGI.SCRIPT_NAME & '?_tPath=' & URLEncodedFormat(tPath) & '&_folder=');
							writeOutput('<tr>');
							writeOutput('<td>');
							writeOutput('-<a href="#_urlOpenDir#" title="#_tPath#">');
							upFolderName = ListFirst(ttPath, '\');
							if (Request.qDir.recordCount eq 0) {
								upFolderName = ListLast(_tPath, '\');
							}
							writeOutput('<img src="images/FolderClosed.gif" width="16" height="16" border="0">&nbsp;' & upFolderName);
							writeOutput('</a>');
							writeOutput('</td>');
							writeOutput('</tr>');
							bool_upFolder = true;
						}
						writeOutput('<tr>');
						writeOutput('<td>');
						if (Request.qDir.TYPE[i] is 'Dir') {
							_urlOpenDir = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#' & CGI.SCRIPT_NAME & '?_tPath=' & URLEncodedFormat(tPath & ttPath & '\') & '&_folder=' & URLEncodedFormat(Request.qDir.NAME[i]));
							writeOutput('-<a href="#_urlOpenDir#" title="#_urlOpenDir#">');
							writeOutput('<img src="images/FolderClosed.gif" width="16" height="16" border="0">');
							writeOutput('&nbsp;' & Request.qDir.NAME[i]);
						} else {
							if ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) ) {
								jsCode = "window.open('#sName#','download','width=800,height=600,resizeable=yes,scrollbars=1')";
							} else {
								jsCode = "parent.downloadsRequiresPremiumBlock()";
							}
							writeOutput('-<a href="" title="#sName#" onclick="#jsCode#; return false;">');
							writeOutput(Request.qDir.NAME[i]);
						}
						writeOutput('</a>');
						writeOutput('</td>');
						writeOutput('</tr>');
					}
					writeOutput('</table>');
				}
			</cfscript>

			<cfcatch type="Any">
				<cfdump var="#cfcatch#" label="CF Error" expand="No">
			</cfcatch>
		</cftry>
	</body>
	</html>
</cfoutput>

