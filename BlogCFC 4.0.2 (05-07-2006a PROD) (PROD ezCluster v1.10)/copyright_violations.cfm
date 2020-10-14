<cfsetting enablecfoutputonly=true showdebugoutput="No">
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : copyright_violations.cfm
	Author       : Ray Horn 
	Created      : March 28, 2006
	Last Updated : 
	History      : 
	Purpose		 : Handles management of copyright violations
--->

<cfif not session.persistData.loggedin>
	<cflocation url="_index.cfm" addToken="false">
</cfif>

<cfif (UCASE(CGI.REQUEST_METHOD) eq "POST")>
	<cfscript>
		ar = ListToArray(FORM.FIELDNAMES, ",");
		n = ArrayLen(ar);
		for (i = 1; i lte n; i = i + 1) {
			fieldName = ar[i];
			if (UCASE(fieldName) neq 'BTN_SUBMIT') {
				toksAR = ListToArray(fieldName, '_');
				recID = toksAR[ArrayLen(toksAR)];
				application.blog.setCopyrightViolations(recID, FORM[fieldName]);
			}
		}
		writeOutput('<font color="blue"><b><small>UPDATED !</small></b></font><br>');
	</cfscript>
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.resourceBundle.getResource("categoryeditor")#" suppressLayout="true" maxWidth="350">

	<cfset qQ = application.blog.getCopyrightViolations()>

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("copyrightviolationsmanager")#</div>
	<div class="body">
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
	<form action="#_url#" method="post" enctype="application/x-www-form-urlencoded">
	<table width="100%" border="1" bordercolor="black">
		<tr bgcolor="silver">
			<cfscript>
				aStruct = StructNew();
				aStruct.ID = '';
				aStruct.ARRIVALDT = 'Date';
				aStruct.CGI_SCOPE_WDDX = '';
				aStruct.QUERY_STRING = '';
				aStruct.HTTP_REFERER = 'Referer';
				aStruct.REMOTE_ADDR = 'IP';
				aStruct.SERVER_NAME = 'Domain';
				aStruct.BOOL_ISAPPROVALPENDING = 'P';
				aStruct.BOOL_ISREFERERAPPROVED = 'A';

				aListAR = ListToArray(qQ.columnList, ",");
				iNum = ArrayLen(aListAR);
				for (i = 1; i lte iNum; i = i + 1) {
					try {
						aColName = aStruct[aListAR[i]];
					} catch (Any e) {
						aColName = aListAR[i];
					}
					if (Len(aColName) gt 0) {
						writeOutput('<td align="center"><b>#aColName#</b></td>');
					}
				}
			</cfscript>
		</tr>
		<cfscript>
			for (j = 1; j lte qQ.recordCount; j = j + 1) {
				writeOutput('<tr>');
				for (i = 1; i lte iNum; i = i + 1) {
					try {
						aColName = aStruct[aListAR[i]];
					} catch (Any e) {
						aColName = aListAR[i];
					}
					if (Len(aColName) gt 0) {
						val = qQ[aListAR[i]][j];
						sOut = val;
						switch (UCASE(aColName)) {
							case 'P':
								sOut = '<input type="Radio" name="cbPending_#qQ.ID[j]#" value="0"';
								if (val eq 1) {
									sOut = sOut & ' checked';
								}
								sOut = sOut & '>';
							break;

							case 'A':
								sOut = '<input type="Radio" name="cbPending_#qQ.ID[j]#" value="1"';
								if (val eq 1) {
									sOut = sOut & ' checked';
								}
								sOut = sOut & '>';
							break;
						}
						writeOutput('<td align="left"><span style="font-size: 10px; color: blue">#sOut#</span></td>');
					}
				}
				writeOutput('</tr>');
			}
		</cfscript>
	</table>
	<cfif (IsDefined("Session.sessID"))>
		<input type="hidden" name="sessID" value="#Session.sessID#">
	</cfif>
	<input type="submit" name="btn_submit" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="[Submit]">
	</form>
	</div>
	</cfoutput>
	
</cfmodule>
<cfsetting enablecfoutputonly=false>
