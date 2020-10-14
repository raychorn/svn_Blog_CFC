<cfsetting showdebugoutput="No">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_tPath" type="string" default="">
<cfparam name="_folder" type="string" default="">

<cfoutput>
	<html>
	<head>
		#Request.commonCode.html_nocache()#
		<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />

		<cfset Request.jsCodeObfuscationIndex = 1>
		<cfset Request.jsCodeObfuscationDecoderAR = ArrayNew(1)>
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

		<script language="JavaScript1.2" type="text/javascript">
			<cfloop index="_i" from="1" to="#ArrayLen(Request.jsCodeObfuscationDecoderAR)#">
				#Request.jsCodeObfuscationDecoderAR[_i]#
			</cfloop>
		</script>
	</head>

	<body>
		<cfset _url = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/'>
		<cfscript>
			path = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
			downloadsPath = path & 'downloads' & Request.folder_mask;
			if ( (Len(_tPath) gt 0) AND (Len(_folder) gt 0) ) {
				downloadsPath = ReplaceNoCase(_tPath, 'downloads\', 'downloads' & Request.folder_mask & '\') & _folder;
			}
			tPath = GetDirectoryFromPath(CGI.PATH_TRANSLATED);
			
			bool_isError = Request.commonCode.cf_directory('Request.qDir', downloadsPath, '', false);
			if ( (NOT bool_isError) AND (Request.qDir.recordCount eq 0) ) {
				driveLetter = Left(downloadsPath, 1);
				if (driveLetter IS 'C') {
					driveLetter = 'D';
				} else {
					driveLetter = 'C';
				}
				downloadsPath = driveLetter & Right(downloadsPath, Len(downloadsPath) - 1);
				bool_isError = Request.commonCode.cf_directory('Request.qDir', downloadsPath, '', false);
			}
		</cfscript>

		<cfif ( (CGI.REMOTE_ADDR eq "71.133.203.30") OR (CGI.REMOTE_ADDR eq "127.0.0.1") OR (CGI.REMOTE_ADDR eq "192.168.1.71") ) AND 0>
			<cfdump var="#Request.qDir#" label="Request.qDir [#CGI.REMOTE_ADDR#] [#CGI.PATH_TRANSLATED#] [#downloadsPath#]" expand="No">
		</cfif>

		<cftry>
			<cfscript>
				if (NOT bool_isError) {
					bool_upFolder = false;
					writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
					for (i = 1; ( (i lte Request.qDir.recordCount) OR ( (Request.qDir.recordCount eq 0) AND (NOT bool_upFolder) ) ); i = i + 1) {
						ttPath = ReplaceNoCase(Request.qDir.DIRECTORY[i], tPath, '');
						_ttPath = ReplaceNoCase(ttPath, "\downloads#Request.folder_mask#", "\downloads");
						sName = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & Replace(_ttPath, '\', '/', 'all') & '/' & Request.qDir.NAME[i];

						_fnameURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/i/downloadFile');
						_fnameURL_ = _fnameURL & '?filename=' & URLEncodedFormat(ReplaceNoCase(sName, "/downloads#Request.folder_mask#/", "/downloads/"));
						_fnameURL = _fnameURL & '?filename=' & URLEncodedFormat(sName);

						ar = ListToArray(ttPath, '\');
						arN = ArrayLen(ar);
						for (k = 1; k lte arN; k = k + 1) {
							if (FindNoCase('downloads_', ar[k]) gt 0) {
								ar2 = ListToArray(ar[k], '_');
								ar[k] = ar2[1];
							}
						}
						_ttPath = ArrayToList(ar, '\');
						if ( (NOT (_ttPath is 'downloads')) AND (NOT bool_upFolder) ) {
							_urlOpenDir = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#' & CGI.SCRIPT_NAME & '?_tPath=' & URLEncodedFormat(tPath) & '&_folder=');
							writeOutput('<tr>');
							writeOutput('<td>');
							writeOutput('-<a href="#_urlOpenDir#" title="#_tPath#">');
							upFolderName = ListFirst(ttPath, '\');
							if (Request.qDir.recordCount eq 0) {
								upFolderName = ListLast(_tPath, '\');
							}
							ar = ListToArray(upFolderName, '_');
							writeOutput('<img src="images/FolderClosed.gif" width="16" height="16" border="0">&nbsp;' & ar[1]);
							writeOutput('</a>');
							writeOutput('</td>');
							writeOutput('</tr>');
							bool_upFolder = true;
						}
						writeOutput('<tr>');
						writeOutput('<td>');
						if (Request.qDir.TYPE[i] is 'Dir') {
							_urlOpenDir = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#' & CGI.SCRIPT_NAME & '?_tPath=' & URLEncodedFormat(tPath & _ttPath & '\') & '&_folder=' & URLEncodedFormat(Request.qDir.NAME[i]));
							writeOutput('-<a href="#_urlOpenDir#" title="#_urlOpenDir#">');
							writeOutput('<img src="images/FolderClosed.gif" width="16" height="16" border="0">');
							writeOutput('&nbsp;' & Request.qDir.NAME[i]);
							writeOutput('</a>');
						} else {
							if ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) ) {
								jsCode = "window.open('#_fnameURL#','download','width=800,height=600,resizeable=yes,scrollbars=1')";
							} else {
								jsCode = "parent.downloadsRequiresPremiumBlock()";
							}
							writeOutput('-<a href="" onclick="#jsCode#; return false;">');
							writeOutput(Request.qDir.NAME[i]);
							writeOutput('</a>');
							jsCode = "parent._alert('#_fnameURL_#');";
							if ( (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin()) ) {
								writeOutput('&nbsp;<a href="" onClick="#jsCode# return false;"><img src="images/Link.gif" border="0"></a>');
							}
						}
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
		
		<script language="JavaScript1.2" type="text/javascript">
			try {
				var oFrame = ((!!parent.$) ? parent.$('iframe_newDownloads') : null);
				if (!!oFrame) {
					oFrame.style.height = Math.max((#Request.qDir.recordCount# * 20),100) + 'px';
				}
			} catch(e) {
			} finally {
			}
		</script>
	</body>
	</html>
</cfoutput>

