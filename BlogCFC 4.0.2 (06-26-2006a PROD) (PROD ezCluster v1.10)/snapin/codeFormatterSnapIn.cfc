<cfcomponent displayname="codeFormatterSnapIn" output="No" extends="snapIns">
	
	<cffunction name="jsCodeForHead" returntype="string" access="public" output="Yes">
		<cfset var _html = "">

		<cfreturn _html>
	</cffunction>

	<cffunction name="jsCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif session.persistData.loggedin>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlActionButton" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
				<td align="left" valign="bottom">
					<form>
						<cfset theClass = ' style="font-size: 10px; margin-top: 5px; margin-bottom: -20px;"'>
						<cfif (NOT Request.commonCode.isBrowserIE())>
							<cfset theClass = ' class="buttonClassFF"'>
						</cfif>
						<button id="btn_formatCode" #theClass# onclick="openCodeFormatter(); return false;">[Format Code]</button>
					</form>
				</td>
			</cfif>	
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="htmlCode" returntype="string" access="public">
		<cfset var _html = "">
		
		<cfsavecontent variable="_html">
			<cfif (session.persistData.loggedin) AND (Request.commonCode.isUserAdmin())>
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
