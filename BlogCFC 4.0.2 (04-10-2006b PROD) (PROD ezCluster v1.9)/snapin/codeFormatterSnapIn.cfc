<cfcomponent displayname="codeFormatterSnapIn" output="No" extends="snapIns">
	
	<cffunction name="jsCodeForHead" returntype="string" access="public" output="Yes">
		<cfset var _html = "">

		<cfif session.persistData.loggedin>
			<cfsavecontent variable="_html">
				<cfparam name="Request.bool_cfinclude_CrossBrowserLibrary_loaded" type="boolean" default="false">
				<cfif (NOT Request.bool_cfinclude_CrossBrowserLibrary_loaded)>
					<script language="JavaScript1.2" type="text/javascript">
					<!--
						<cfinclude template="../js/cfinclude_CrossBrowserLibrary.cfm">
					//-->
					</script>
				</cfif>
			</cfsavecontent>
		</cfif>
		
		<cfscript>
			if (session.persistData.loggedin) {
			//	_html = Replace(Replace(_html, Chr(10), '', 'all'), Chr(13), '', 'all');
			//	_html = Replace(_html, ';', '; ', 'all');
			}
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="jsCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif session.persistData.loggedin>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					function openCodeFormatter() {
						var cObj = $('div_code_formatter');
						if (cObj != null) {
							cObj.style.display = const_inline_style;
						}
						
						var cObj = $('btn_formatCode');
						if (cObj != null) {
							cObj.disabled = true;
						}
					}
					
					function closeCodeFormatter() {
						var cObj = $('div_code_formatter');
						if (cObj != null) {
							cObj.style.display = const_none_style;
						}
			
						var cObj = $('btn_formatCode');
						if (cObj != null) {
							cObj.disabled = false;
						}
					}
			
					function replaceLeadingWhiteSpaceWithPadding(s) {
						var i = -1;
						var ch = -1;
						var d = '';
						var t = '';
						var lineBreakCnt = 1;
						var lineBreakDelta = 200;
						
						for (i = 0; i < s.length; i++) {
							ch = s.charCodeAt(i);
							if (ch <= 32) {
								t = '&nbsp;';
							} else {
								if (ch == 60) {
									t = '&lt;';
								} else if (ch == 62) {
									t = '&gt;';
								} else {
									t = s.substring(i,i + 1);
								}
							}
							d += t;
							if (d.length > lineBreakDelta) {
								d += '<br>';
								lineBreakCnt++;
								lineBreakDelta += 200;
							}
						}
						return d;
					}
					
					function performCodeFormatter() {
						var s = '';
						var i = -1;
						var a = -1;
						var fmtCode = '';
						var cObj = $('ta_code_to_format');
						var dObj = $('ta_formated_code');
						if ( (cObj != null) && (dObj != null) ) {
							s = cObj.value;
							a = s.split('\n');
							fmtCode = '';
							fmtCode += '<table width="100%" border="0" cellspacing="-1" cellpadding="-1" class="code">';
							for (i = 0; i < a.length; i++) {
								fmtCode += '<tr>';
								fmtCode += '<td>';
								fmtCode += replaceLeadingWhiteSpaceWithPadding(a[i]);
								fmtCode += '</td>';
								fmtCode += '</tr>';
								fmtCode += '\n';
							}
							fmtCode += '</table>';
							dObj.value = fmtCode;
						}
					}
				//-->
				</script>
			</cfif>	
		</cfsavecontent>
		
		<cfscript>
			_html = Request.commonCode.jsMinifier(Request.commonCode.obfuscateJScode(_html));
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlActionButton" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif session.persistData.loggedin>
				<td align="center" valign="bottom">
					<form>
						<button id="btn_formatCode" style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;" onclick="openCodeFormatter(); return false;">[Format Code]</button>
					</form>
				</td>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif session.persistData.loggedin>
				<div id="div_code_formatter" style="display: none;">
					<table width="600px" border="0" cellpadding="-1" cellspacing="-1">
						<tr>
							<td width="100%" align="right" bgcolor="silver" colspan="3">
								<button id="btn_formatCodeClose" style="font-size: 10px;" onclick="closeCodeFormatter(); return false;">[X]</button>
							</td>
						</tr>
						<tr>
							<td width="45%">
								<textarea id="ta_code_to_format" cols="50" rows="20" wrap="hard" style="font-size: 10px"></textarea>
							</td>
							<td width="5%" valign="middle">
								<button id="btn_formatCode_right" style="font-size: 10px;" onclick="performCodeFormatter(); return false;">[>>]</button>
							</td>
							<td width="45%">
								<textarea id="ta_formated_code" cols="50" rows="20" wrap="hard" style="font-size: 10px"></textarea>
							</td>
						</tr>
					</table>
				</div>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cfscript>
		function init() {
			if ((session.persistData.loggedin) AND 0) {
				Request.e_jsCodeForHead = encodedEncryptedString2(jsCodeForHead());
				Request.e_jsCode = encodedEncryptedString2(jsCode());
				Request.e_htmlActionButton = encodedEncryptedString2(htmlActionButton());
				Request.e_htmlCode = encodedEncryptedString2(htmlCode());
			}
			return this;
		}

		function cgiEvent() {
		}
	</cfscript>
</cfcomponent>
