<cfsetting showdebugoutput="No">
<cfprocessingdirective pageencoding="utf-8">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />
<cfoutput>
<html>
<head>
	<title>#application.blog.getProperty("blogTitle")# : #application.resourceBundle.getResource("makesearchenginelinks")#</title>
	<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
	<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
	#Request.commonCode.html_nocache()#

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

<div class="date">#application.resourceBundle.getResource("makesearchenginelinks")#</div>
<div class="body">

<cfif (session.persistData.loggedin) AND (NOT CGI.REQUEST_METHOD IS "POST")>
	<cfif (isDebugMode()) AND 0>
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
</cfif>

	<table border="1" width="100%" cellpadding="-1">
		<tr>
			<td bgcolor="silver" align="right">
				<input type="Button" class="buttonClass" value="[X]" onclick="if (!!parent.closeSElinks) parent.closeSElinks();">
			</td>
		</tr>
		<cfset Request.bulkPayloadHeader = "">
		<cfset Request.bulkPayload = ArrayNew(1)>

		<cffunction name="rowOfArticlesForSElinks" output="Yes" returntype="string">
			<cfargument name="qQ" type="query" required="Yes">
			<cfargument name="rowNum" type="numeric" required="yes">
			<cfargument name="serverNum" type="numeric" default="3">

		<cfset Request.bulkPayloadHeader = "">
		
		<cfif (serverNum gte 0) AND (serverNum lte 2)>
			<cfif (ArrayLen(Request.bulkPayload) lt rowNum)>
				<cfset Request.bulkPayload[rowNum] = "">
			</cfif>
			
			 <cftry>
				<cfoutput>
					<tr>
						<td> <!--- id  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "id", Chr(9))>
							<cfset _id = qQ.id[rowNum]>
							<cfif (serverNum gt 0)>
								<cfset _id = serverNum & "-" & qQ.id[rowNum]>
							</cfif>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], _id, Chr(9))>
							<NOBR>#_id#</NOBR>
						</td>
						<td> <!--- title  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "title", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], qQ.title[rowNum], Chr(9))>
							<NOBR>#qQ.title[rowNum]#</NOBR>
						</td>
						<td> <!--- description  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "description", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], qQ.alias[rowNum], Chr(9))>
							<NOBR>#qQ.alias[rowNum]#</NOBR>
						</td>
						<td> <!--- link  --->
							<cfset _url = application.blog.makeLink(qQ.id[rowNum])>
							<cfset _url = ListDeleteAt(_url, ListLen(_url, "/"), "/") & "/">
							
							<cfif (serverNum eq 0)>
								<!--- Do nothing because Server 0 is the Cluster Manager --->
							<cfelseif (serverNum gte 1) AND (serverNum lte 2)>
								<cfset _url = ListSetAt(_url, 1, ListFirst(_url, ".") & "." & serverNum, ".")>
							</cfif>
	
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "link", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], _url, Chr(9))>
							<NOBR>#_url#</NOBR>
						</td>
						<td> <!--- expiration_date  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "expiration_date", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], "12/31/2099", Chr(9))>
							12/31/2099
						</td>
						<td> <!--- publish_date  --->
							<cfset _date = DateFormat(qQ.posted[rowNum], "mm/dd/yyyy")>
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "publish_date", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], _date, Chr(9))>
							#_date#
						</td>
						<td> <!--- reviewer_type  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "reviewer_type", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], "editorial", Chr(9))>
							editorial
						</td>
						<td> <!--- rating  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "rating", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], "5", Chr(9))>
							5
						</td>
						<td> <!--- name_of_item_reviewed  --->
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "name_of_item_reviewed", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], qQ.alias[rowNum], Chr(9))>
							<NOBR>#qQ.alias[rowNum]#</NOBR>
						</td>
						<td> <!--- url_of_item_reviewed  --->
							<cfset _url = Request.commonCode.makeLinkToSelfBase("")>
							<cfset _url = ListDeleteAt(_url, ListLen(_url, "/"), "/")>
	
							<cfif (serverNum eq 0)>
								<!--- Do nothing because Server 0 is the Cluster Manager --->
							<cfelseif (serverNum gte 1) AND (serverNum lte 2)>
								<cfset _url = ListSetAt(_url, 1, ListFirst(_url, ".") & "." & serverNum, ".")>
							</cfif>
	
							<cfset Request.bulkPayloadHeader = ListAppend(Request.bulkPayloadHeader, "url_of_item_reviewed", Chr(9))>
							<cfset Request.bulkPayload[rowNum] = ListAppend(Request.bulkPayload[rowNum], _url, Chr(9))>
							<NOBR>#_url#</NOBR>
						</td>
					</tr>
				</cfoutput>
	
			 	<cfcatch type="Any">
					<cfdump var="#cfcatch#" label="cfcatch" expand="No">
				</cfcatch>
			 </cftry>
		</cfif>

		</cffunction>

		<tr>
			<td>
				<div id="div_data_contents" style="display: none;">
					<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
						<cfscript>
							params = structNew();
							Request.articles = application.blog.getEntries(params);
							if (IsQuery(Request.articles)) {
								_sqlStatement = "SELECT id, title, alias, posted FROM Request.articles";
								Request.commonCode.safely_execSQL('Request.qGetArticleIDs', '', _sqlStatement);
								if (Request.dbError) {
									writeOutput('<span class="redBlogArticleAccessBoldPrompt">[#Request.explainErrorText#] [#_sqlStatement#]</span>');
								} else if ( (IsDefined("Request.qGetArticleIDs")) AND (IsQuery(Request.qGetArticleIDs)) ) {
									for (i = 1; i lte Request.qGetArticleIDs.recordCount; i = i + 1) {
										writeOutput(rowOfArticlesForSElinks(Request.qGetArticleIDs, i, 0));
									}
								}
							}
						</cfscript>
					</table>
				</div>
			</td>
		</tr>
	</table>
	
	<hr color="red" width="80%">
	<small class="textClass">Server 0:</small><br>
	<textarea class="textClass" cols="120" readonly rows="10">#Request.bulkPayloadHeader##Chr(13)#<cfloop index="_i" from="1" to="#ArrayLen(Request.bulkPayload)#">#Request.bulkPayload[_i]##Chr(13)#</cfloop></textarea>
	<hr color="red" width="80%">

	<cfset Request.bulkPayload = ArrayNew(1)>
	<div id="div_data_contents1" style="display: none;">
		<cfscript>
			params = structNew();
			Request.articles = application.blog.getEntries(params);
			if (IsQuery(Request.articles)) {
				_sqlStatement = "SELECT id, title, alias, posted FROM Request.articles";
				Request.commonCode.safely_execSQL('Request.qGetArticleIDs', '', _sqlStatement);
				if (Request.dbError) {
					writeOutput('<span class="redBlogArticleAccessBoldPrompt">[#Request.explainErrorText#] [#_sqlStatement#]</span>');
				} else if ( (IsDefined("Request.qGetArticleIDs")) AND (IsQuery(Request.qGetArticleIDs)) ) {
					for (i = 1; i lte Request.qGetArticleIDs.recordCount; i = i + 1) {
						rowOfArticlesForSElinks(Request.qGetArticleIDs, i, 1);
					}
				}
			}
		</cfscript>
	</div>
	
	<hr color="red" width="80%">
	<small class="textClass">Server 1:</small><br>
	<textarea class="textClass" cols="120" readonly rows="10">#Request.bulkPayloadHeader##Chr(13)#<cfloop index="_i" from="1" to="#ArrayLen(Request.bulkPayload)#">#Request.bulkPayload[_i]##Chr(13)#</cfloop></textarea>
	<hr color="red" width="80%">

	<cfset Request.bulkPayload = ArrayNew(1)>
	<div id="div_data_contents2" style="display: none;">
		<cfscript>
			params = structNew();
			Request.articles = application.blog.getEntries(params);
			if (IsQuery(Request.articles)) {
				_sqlStatement = "SELECT id, title, alias, posted FROM Request.articles";
				Request.commonCode.safely_execSQL('Request.qGetArticleIDs', '', _sqlStatement);
				if (Request.dbError) {
					writeOutput('<span class="redBlogArticleAccessBoldPrompt">[#Request.explainErrorText#] [#_sqlStatement#]</span>');
				} else if ( (IsDefined("Request.qGetArticleIDs")) AND (IsQuery(Request.qGetArticleIDs)) ) {
					for (i = 1; i lte Request.qGetArticleIDs.recordCount; i = i + 1) {
						rowOfArticlesForSElinks(Request.qGetArticleIDs, i, 2);
					}
				}
			}
		</cfscript>
	</div>
	
	<hr color="red" width="80%">
	<small class="textClass">Server 2:</small><br>
	<textarea class="textClass" cols="120" readonly rows="10">#Request.bulkPayloadHeader##Chr(13)#<cfloop index="_i" from="1" to="#ArrayLen(Request.bulkPayload)#">#Request.bulkPayload[_i]##Chr(13)#</cfloop></textarea>
	<hr color="red" width="80%">

</div>

</body>
</html>
</cfoutput>
