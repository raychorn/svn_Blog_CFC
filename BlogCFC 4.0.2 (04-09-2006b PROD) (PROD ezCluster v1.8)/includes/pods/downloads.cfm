<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : downloads.cfm
	Author       : Ray Horn 
	Created      : December 6, 2005
	Last Updated : December 6, 2005
	Purpose		 : Display downloads box
--->

<cfmodule template="../../tags/podlayout.cfm" containerClass="rightMenuWide" title="#application.resourceBundle.getResource("downloads")#">

	<cfif (session.loggedin) AND (Request.commonCode.isUserAdmin())>
		<cfoutput>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post" enctype="multipart/form-data">
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

	<cfif (session.loggedin) AND (Request.commonCode.isUserAdmin())>
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
						<cfdump var="#cfcatch#" label="cfcatch" expand="No">
					</cfcatch>
				</cftry>
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
						<cfdump var="#cfcatch#" label="cfcatch - [#ExpandPath('downloads')#]" expand="No">
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
							<cfdump var="#cfcatch#" label="cfcatch" expand="No">
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
				<cfdump var="#cfcatch#" label="cfcatch" expand="No">
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
			for (i = 1; i lte qDir.recordCount; i = i + 1) {
				ttPath = ReplaceNoCase(qDir.DIRECTORY[i], tPath, '');
				sName = Request.commonCode.clusterizeURL(application.rootURL) & '/' & ttPath & '/' & qDir.NAME[i];
				anchor = '#qDir.NAME[i]#';
				if (session.loggedin) {
					anchor = '<a href="#sName#" target="_blank">#qDir.NAME[i]#</a>';
				}
				_fStruct = GetDescriptionFromFileName(qDir.NAME[i], dsn);
				formObj = '';
				if ( (session.loggedin) AND (Request.commonCode.isUserAdmin()) ) {
					formObj = '<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post"><input type="submit" name="btn_submitDownload" value="[-]"><input type="Hidden" name="downloads_id" value="#_fStruct.id#"></form>';
				}
				_hr = '';
				if ( (i lt qDir.recordCount) AND 0) {
					_hr = '<hr align="center" width="80%" color="blue">';
				}
				writeOutput('<tr><td width="170" style="line-height: 14px;">(#i#)&nbsp;#formObj#&nbsp;<NOBR>#anchor# | #_fStruct.descText#</NOBR>#_hr#</td></tr>');
			}
			writeOutput('</table>');
		}
	</cfscript>

	<cfoutput>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>