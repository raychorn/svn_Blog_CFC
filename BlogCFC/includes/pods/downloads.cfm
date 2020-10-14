<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : downloads.cfm
	Author       : Ray Horn 
	Created      : December 6, 2005
	Last Updated : December 6, 2005
	Purpose		 : Display downloads box
--->

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("downloads")#">

<cfif 0>
	<cfdump var="#Server#" label="Server Scope" expand="No">
	<cfdump var="#Application#" label="Application Scope" expand="No">
	<cfdump var="#Session#" label="Session Scope" expand="No">
	<cfdump var="#Request#" label="Request Scope" expand="No">
	<cfdump var="#CGI#" label="CGI Scope" expand="No">
</cfif>
	
	<cfscript>
		path = GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
		downloadsPath = path & 'downloads';
		tPath = GetDirectoryFromPath(CGI.PATH_TRANSLATED);
		scriptName = ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
		
	//	writeOutput('tPath = [#tPath#], scriptName = [#scriptName#]<br>');
	</cfscript>

	<cfdirectory action="LIST" directory="#downloadsPath#" name="qDir">
<cfif 0>
	<cfdump var="#qDir#" label="qDir" expand="No">
</cfif>
	
	<cfscript>
		if (IsQuery(qDir)) {
			writeOutput('<OL style="margin-top: 0px;">');
			for (i = 1; i lte qDir.recordCount; i = i + 1) {
				ttPath = ReplaceNoCase(qDir.DIRECTORY[i], tPath, '');
				sName = 'http://' & CGI.SERVER_NAME & scriptName & '/' & ttPath & '/' & qDir.NAME[i];
				anchor = '<a href="#sName#" target="_blank">#qDir.NAME[i]#</a>';
				descText = '';
				if (UCASE(qDir.NAME[i]) eq UCASE('Geonosis_v1.zip')) {
					descText = 'AJAX Web App Generator (prototype)';
				}
				writeOutput('<LI style="margin-left: -20px;">[#anchor#&nbsp;#descText#]</LI>');
			//	writeOutput('ttPath = [#ttPath#], sName = [#sName#] [#anchor#]<br>');
			}
			writeOutput('</OL>');
		}
	</cfscript>

	<cfoutput>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>