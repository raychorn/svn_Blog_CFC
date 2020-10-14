<cfparam name="bool_canDebugHappen" type="boolean" default="false">

<cfif (bool_canDebugHappen)>
	<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">

	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<cfdump var="#Application#" label="App Scope" expand="No">
						</td>
						<td>
							<cfdump var="#Session#" label="Session Scope" expand="No">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfif>

<cfscript>
	___jsName___ = 'qObj';
	if (IsDefined("Request.qryStruct.___jsName___")) {
		___jsName___ = Request.qryStruct.___jsName___;
	}
</cfscript>

<cfsavecontent variable="_jsInitCode">
	<cfoutput>
		if (!!#___jsName___#) {
		} else {
			var #___jsName___# = -1;
		}
		#___jsName___# = AJAXObj.get$();
		_#___jsName___# = new Object();
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="_jsCode_">
	<cfoutput>
		#Request.commonCode.populate_JS_queryObj(Request.qryObj, '_#___jsName___#.qParms', true)#
		if (#___jsName___# != null) #___jsName___#.init();
		<cfif (IsDefined("Request.qryData"))>
			<cfif (IsArray(Request.qryData))>
				<cfset n = ArrayLen(Request.qryData)>

				<cfscript>
					qStats = QueryNew('num'); 
					QueryAddRow(qStats, 1); 
					QuerySetCell(qStats, 'num', n, qStats.recordCount); 
				</cfscript>

				#Request.commonCode.populate_JS_queryObj(qStats, '_#___jsName___#.qStats', true)#
				#___jsName___#.push('qDataNum', _#___jsName___#.qStats); 
				<cfloop index="_i" from="1" to="#n#">
					#Request.commonCode.populate_JS_queryObj(Request.qryData[_i], '_#___jsName___#.qData#_i#', true)#
					#___jsName___#.push('qData#_i#', _#___jsName___#.qData#_i#); 
				</cfloop>
			</cfif>
		</cfif>
		#___jsName___#.push('qParms', _#___jsName___#.qParms); 
		_#___jsName___# = null; 
	</cfoutput>
</cfsavecontent>

<cfscript>
	_jsFinaleCode = '';
	if (NOT IsDefined("Request.qryStruct.callBack")) {
		Request.qryStruct.callBack = '_alert("No callback was specified...")';
	}
	if (UCASE(Request.qryStruct.callBack) neq 'UNDEFINED') {
		_jsFinaleCode = Request.qryStruct.callBack;
		openParen_i = Find('(', _jsFinaleCode);
		closeParen_i = Find(')', _jsFinaleCode, openParen_i);
		if ( (openParen_i eq 0) AND (closeParen_i eq 0) ) {
			_jsFinaleCode = _jsFinaleCode & '()';
		}
		if (Find(';', _jsFinaleCode) eq 0) {
			_jsFinaleCode = _jsFinaleCode & ';';
		}
	}
</cfscript>

<cfif (bool_using_xmlHttpRequest)>
	<cfoutput>
		/* BOF CFAJAX */
		#_jsInitCode#
		#ReplaceList(_jsCode_, Chr(13) & "," & Chr(10) & ",parent.", ",,")#
		#_jsFinaleCode#
		/* EOF CFAJAX */
	</cfoutput>
<cfelse>
	<!--- BEGIN: create a JavaScript object to store the query object --->
	<cfscript>
		_jsCode = _jsCode_;
		_jsCode = _jsInitCode & _jsCode & _jsFinaleCode;
		_jsCode = ReplaceList(_jsCode, Chr(13) & "," & Chr(10) & ",parent.", ",,");
		if (bool_canDebugHappen) writeOutput('JS Code: (#_jsInitCode#) (length=#Len(_jsCode)#) <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
	</cfscript>
	<!--- END! create a JavaScript object to store the query object --->

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			#Request.parentKeyword#server_response_queue = [];
			
			#Request.parentKeyword#server_response_queue.push("#_jsCode#");
	
			// this passes the packet back to the client
			if (#Request.parentKeyword#oAJAXEngine) {
				#Request.parentKeyword#oAJAXEngine.receivePacket(#Request.parentKeyword#server_response_queue);
			}
		//-->
		</script>
	</cfoutput>

	</body>
	</html>
</cfif>
 