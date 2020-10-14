<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfinclude template="cfinclude_AJAX_Init.cfm">

<cfscript>
	Request.qryObj = Request.commonCode.initQryObj("name, val");
	Request.qryStruct = StructNew();
</cfscript>

<cfif (bool_using_xmlHttpRequest)>
	<cfscript>
		_CGI_QUERY_STRING = '';
		if (IsDefined("CGI.QUERY_STRING")) {
			_CGI_QUERY_STRING = CGI.QUERY_STRING;
		}
		_form_QUERY_STRING = '';
		if (IsDefined("form.QUERY_STRING")) {
			_form_QUERY_STRING = form.QUERY_STRING;
		}

		_QUERY_STRING = '';
		if (bool_using_xmlHttpRequest_viaGET) {
			_QUERY_STRING = '#_CGI_QUERY_STRING#';
		} else if (bool_using_xmlHttpRequest_viaPOST) {
			_QUERY_STRING = '#_form_QUERY_STRING#';
		}
	</cfscript>
<cfelse>
	<cfoutput>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		
		<html>
		<head>
			<cfoutput>
				#Request.commonCode.html_nocache()#
			</cfoutput>
			<cfscript>
				if (bool_canDebugHappen) {
					_prefix = '.';
					if (FileExists(ExpandPath('..\StyleSheet.css'))) {
						_prefix = '../';
					} else if (FileExists(ExpandPath('StyleSheet.css'))) {
						_prefix = '';
					}
					if (_prefix neq '.') {
						writeOutput('<LINK rel="STYLESHEET" type="text/css" href="#_prefix#StyleSheet.css"> ');
					}
				}
			</cfscript>
		</head>
		<body>
	</cfoutput>
	
	<cfoutput>
		<cfif (bool_canDebugHappen)>
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
								<td>
									<cfdump var="#URL#" label="URL Scope" expand="No">
								</td>
								<td>
									<cfdump var="#FORM#" label="FORM Scope" expand="No">
								</td>
								<td>
									<cfdump var="#CGI#" label="CGI Scope" expand="No">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<small>
						BEGIN: #Request.commonCode.blue_formattedModuleName('A. cfinclude_AJAX_Begin.cfm')#<br>
						(isDefined("url.data")) = [#(isDefined("url.data"))#]<br>
						(isDefined("form.packet")) = [#(isDefined("form.packet"))#]<br>
						(isDefined("url.wddx")) = [#(isDefined("url.wddx"))#]<br>
						(isDefined("form.wddx")) = [#(isDefined("form.wddx"))#]<br>
						(isDefined("CGI.QUERY_STRING")) = [#(isDefined("CGI.QUERY_STRING"))#]<br>
						</small>
					</td>
				</tr>
			</table>
		</cfif>

		<!--- BEGIN: Determine the data source from all available sources of data and route to _QUERY_STRING --->
		<cfscript>
			_QUERY_STRING = '';
			if (isDefined("url.data")) {
				if (Len(url.data) gt 0) {
					_QUERY_STRING = TRIM(url.data);
				}
			} else if (isDefined("form.packet")) {
				if (Len(form.packet) gt 0) {
					_QUERY_STRING = TRIM(form.packet);
				}
			} else if (isDefined("CGI.QUERY_STRING")) {
				if (Len(CGI.QUERY_STRING) gt 0) {
					_QUERY_STRING = TRIM(CGI.QUERY_STRING);
				}
			}
		</cfscript>
		<!--- END! Determine the data source from all available sources of data and route to _QUERY_STRING --->
		
		<cfif (Len(_QUERY_STRING) gt 0)>
			<cfif (bool_canDebugHappen)>
				_QUERY_STRING = [#_QUERY_STRING#]<br>
			</cfif>
			<cfloop index="_item" list="#_QUERY_STRING#" delimiters="&">
				<cfif (bool_canDebugHappen)>
					_item = [#_item#]
				</cfif>
				<cfif (ListLen(_item, "=") eq 2)>
					<cfif (bool_canDebugHappen)>
						&nbsp;[#Request.commonCode._GetToken(_item, 1, "=")#]&nbsp;[#Request.commonCode._GetToken(_item, 2, "=")#]<br>
					</cfif>
					<cfif (LCase(Request.commonCode._GetToken(_item, 1, "=")) eq LCase("wddx"))>
						<cfif (bool_canDebugHappen)>
							0. Exec WDDX2CFML<br>
							[#Request.commonCode._GetToken(_item, 2, "=")#]<br>
						</cfif>
						<cfset input_item = URLDecode(Request.commonCode._GetToken(_item, 2, "="))>
						<cfif (bool_canDebugHappen)>
							input_item = [#input_item#]<br>
						</cfif>
						<cfwddx action="WDDX2CFML" input="#input_item#" output="_CMD_">
	
						<cfif (IsDefined("_CMD_"))>
							<cfif (bool_canDebugHappen)>
								<cfif (IsQuery(_CMD_))>
									<cfdump var="#_CMD_#" label="_CMD_" expand="No">
								<cfelse>
									_CMD_ = [#_CMD_#]<br>
								</cfif>
							</cfif>
						</cfif>
					<cfelse>
						<cfparam name="_CMD_" type="string" default="">
						<cfset _CMD_ = ListAppend(_CMD_, _item, "&")>
					</cfif>
				</cfif>
				<cfif (bool_canDebugHappen)>
					<br>
				</cfif>
			</cfloop>
		</cfif>
		<cfif (bool_canDebugHappen)>
			<cfif (isDefined("url.wddx"))>
				url.wddx = [#url.wddx#] [#URLDecode(url.wddx)#]<br>
			<cfelseif (isDefined("form.wddx"))>
				form.wddx = [#URLDecode(form.wddx)#]<br>
			</cfif>
			END! #Request.commonCode.blue_formattedModuleName('A. cfinclude_AJAX_Begin.cfm')#<br>
		</cfif>
	</cfoutput>
	
	<cfif (isDefined("url.wddx"))>
		<cfif (bool_canDebugHappen)>
			<cfoutput>
				A. Exec WDDX2CFML<br>
			</cfoutput>
		</cfif>
	
		<cfwddx action="WDDX2CFML" input="#url.wddx#" output="_CMD_">
	<cfelseif (isDefined("form.wddx"))>
		<cfif (bool_canDebugHappen)>
			<cfoutput>
				B. Exec WDDX2CFML<br>
			</cfoutput>
		</cfif>
	
		<cfwddx action="WDDX2CFML" input="#form.wddx#" output="_CMD_">
	</cfif>

	<cfset Request._CMD_ = _CMD_>
	
	<cfif (bool_canDebugHappen)>
		<cfoutput>
			BEGIN: #Request.commonCode.blue_formattedModuleName('B. cfinclude_AJAX_Begin.cfm')#<br>
			(IsDefined("Request._CMD_") = [#IsDefined("Request._CMD_")#]<br>
			<cfif (IsDefined("Request._CMD_"))>
				(IsQuery(Request._CMD_)) = [#(IsQuery(Request._CMD_))#]<br>
				<cfif (IsQuery(Request._CMD_))>
					#Request.primitiveCode.debugQueryInTable(Request._CMD_, "Request._CMD_")#
				<cfelse>
					Request._CMD_ = [#Request._CMD_#]<br>
				</cfif>
			</cfif>
			END! #Request.commonCode.blue_formattedModuleName('B. cfinclude_AJAX_Begin.cfm')#<br>
		</cfoutput>
	</cfif>

	<cfscript>
		_QUERY_STRING = Request._CMD_;
	</cfscript>
</cfif>

<cfscript>
	aa = ListToArray(_QUERY_STRING, '&');
	aaN = ArrayLen(aa);
	for (i = 1; i lte aaN; i = i + 1) {
		QueryAddRow(Request.qryObj, 1);
		aaP = ListToArray(URLDecode(aa[i]), '=');
		QuerySetCell(Request.qryObj, 'NAME', aaP[1], Request.qryObj.recordCount);
		QuerySetCell(Request.qryObj, 'VAL', aaP[2], Request.qryObj.recordCount);
		Request.qryStruct[aaP[1]] = aaP[2];
	}
</cfscript>