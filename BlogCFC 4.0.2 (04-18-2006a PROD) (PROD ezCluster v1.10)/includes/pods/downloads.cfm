<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : downloads.cfm
	Author       : Ray Horn 
	Created      : December 6, 2005
	Last Updated : December 6, 2005
	Purpose		 : Display downloads box
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="pod_downloads" scope="db" timeout="#application.timeout#">

	<cfmodule template="../../tags/podlayout.cfm" containerClass="rightMenuWide" title="#application.resourceBundle.getResource("downloads")#">
	
		<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin()) AND 0>
			<cfoutput>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post" enctype="multipart/form-data">
								<cfif (IsDefined("Session.sessID"))>
									<input type="hidden" name="sessID" value="#Session.sessID#">
								</cfif>
								<input type="file" name="upload_fileName" id="upload_fileName"><br>
								<span class="normalPrompt">Desc:</span>&nbsp;<input name="downloads_desc" value="" size="20" maxlength="255">&nbsp;
								<input type="submit" name="btn_submitDownload" value="[+]">
							</form>
							<hr color="blue" width="80%" align="center">
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfif>
	
		<cfset dsn = application.blog.getProperty("dsn")>
	
		<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin()) AND 0>
			<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST")>
				<cfif (IsDefined("downloads_id"))>
					<cfset dbError = false>
					<cftry>
						<cfquery name="qDropDownload" datasource="#dsn#">
							DELETE FROM tblDownloads
							WHERE (id = <cfqueryparam value="#downloads_id#" cfsqltype="CF_SQL_INTEGER">)
						</cfquery>
			
						<cfcatch type="Any">
							<cfset dbError = true>
						</cfcatch>
					</cftry>
					<cfmodule template="tags/scopecache.cfm" cachename="pod_downloads" scope="db" clear="true">		
				<cfelseif (IsDefined("upload_fileName"))>
					<cfset fileError = false>
					<cftry>
						<cffile action = "upload" 
						     fileField = "upload_fileName" 
						     destination = "#ExpandPath('downloads')#" 
						     accept = "application/x-zip-compressed" 
						     nameConflict = "MakeUnique">
						<cfcatch type="Any">
							<cfset fileError = true>
						</cfcatch>
					</cftry>
				  
					<cfif (NOT fileError)>
						<cfset dbError = false>
						<cftry>
							<cfquery name="qAddDownloadToDb" datasource="#dsn#">
								INSERT INTO tblDownloads
				                      (fName, descText)
								VALUES (<cfqueryparam value="#ListLast(upload_fileName, "\")#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,<cfqueryparam value="#downloads_desc#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">)
							</cfquery>
				
							<cfcatch type="Any">
								<cfset dbError = true>
							</cfcatch>
						</cftry>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	
		<cfscript>
			path = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
			downloadsPath = path & 'downloads';
			tPath = GetDirectoryFromPath(CGI.PATH_TRANSLATED);
			scriptName = ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
		</cfscript>
	
		<cfdirectory action="LIST" directory="#downloadsPath#" name="qDir">
	
		<cffunction name="GetDescriptionFromFileName" access="public" returntype="struct">
			<cfargument name="_fName_" type="string" required="Yes">
			<cfargument name="_dsn_" type="string" required="Yes">
	
			<cfset var fStruct = StructNew()>
			
			<cfset dbError = false>
			<cftry>
				<cfquery name="qGetFileDescText" datasource="#_dsn_#">
					SELECT id, descText
					FROM tblDownloads
					WHERE (UPPER(fName) = <cfqueryparam value="#UCASE(_fName_)#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">)
				</cfquery>
	
				<cfcatch type="Any">
					<cfset dbError = true>
				</cfcatch>
			</cftry>
			
			<cfif (NOT dbError)>
				<cfset fStruct.descText = qGetFileDescText.descText>
				<cfset fStruct.id = qGetFileDescText.id>
				<cfreturn fStruct>
			</cfif>
			
			<cfset fStruct.id = -1>
			<cfset fStruct.descText = ''>
			<cfreturn fStruct>
		</cffunction>
	
		<cfscript>
			if (IsQuery(qDir)) {
				writeOutput('<table id="table_downloads_list" width="200" cellpadding="-1" cellspacing="-1">');
				iDownload = 0;
				for (i = 1; i lte qDir.recordCount; i = i + 1) {
					ttPath = ReplaceNoCase(qDir.DIRECTORY[i], tPath, '');
					_fnameURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/i/downloadFile');
					sName = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/' & ttPath & '/' & qDir.NAME[i];
					_fnameURL = _fnameURL & '?filename=' & URLEncodedFormat(sName);
					_fStruct = GetDescriptionFromFileName(qDir.NAME[i], dsn);
					_fSize = NumberFormat(qDir.size[i], ',');
					if ( (session.persistData.loggedin) AND (Request.commonCode.isUserPremium()) ) {
						anchor = '<a href="#_fnameURL#" title="#_fStruct.descText#">(#_fSize# bytes)&nbsp;#qDir.NAME[i]#</a>';
					} else {
						anchorTitle = '';
						if (NOT session.persistData.loggedin) {
							anchorTitle = 'Access to Downloads is restricted to Registered Users Only !  Be sure to Register for your User Account today !';
						} else {
							anchorTitle = 'Access to Downloads is restricted to Premium Users Only !  Kindly upgrade your User Account to Premium today !';
						}
						anchor = '<a href="" title="#anchorTitle#" onclick="return false;">(#_fSize# bytes)&nbsp;' & qDir.NAME[i] & '&nbsp;|&nbsp;' & _fStruct.descText & '</a>';
					}
					formObj = '';
					if ( (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin()) AND 0 ) {
						formObj = '<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post"><input type="submit" name="btn_submitDownload" value="[-]"><input type="Hidden" name="downloads_id" value="#_fStruct.id#"><cfif (IsDefined("Session.sessID"))><input type="hidden" name="sessID" value="#Session.sessID#"></cfif></form>';
					}
					_hr = '';
					if (qDir.size[i] gt 0) {
						iDownload = iDownload + 1;
						writeOutput('<tr><td width="170" style="line-height: 14px;">(#iDownload#)&nbsp;#formObj#&nbsp;<NOBR>#anchor#</NOBR>#_hr#</td></tr>');
					}
				}
				writeOutput('</table>');
			}
		</cfscript>
	
	</cfmodule>

</cfmodule>
	
<cfsetting enablecfoutputonly=false>