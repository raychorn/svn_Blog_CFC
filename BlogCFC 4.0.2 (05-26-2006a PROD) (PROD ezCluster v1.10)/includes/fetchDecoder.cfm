<!--- fetchDecoder.cfm --->
<cfsetting showdebugoutput="No">

<cfif (FindNoCase(CGI.SERVER_NAME, CGI.HTTP_REFERER) gt 0)>
	<cfsavecontent variable="_jscode2a"><cfoutput>#Request.commonCode.readAndObfuscateJSCode('../js/decontextmenu.js')#</cfoutput></cfsavecontent>
	<cfsavecontent variable="_jscode2b"><cfoutput>#Request.commonCode.readAndObfuscateJSCode('../js/CrossBrowserLibrary.js')#</cfoutput></cfsavecontent>
	<cfoutput>
		<cfif 0>
			<script language="JavaScript1.2" type="text/javascript">
				var xx$ = "#URLEncodedFormat(_jscode2a)#";
				if (!!parent.deliverDecoder) parent.deliverDecoder(xx$);
	
				function jsErrorExplainer(e, funcName) {
					var _db = ''; 
					_db += "e.number is: " + (e.number & 0xFFFF) + '\n'; 
					_db += "e.description is: " + e.description + '\n'; 
					_db += "e.name is: " + e.name + '\n'; 
					_db += "e.message is: " + e.message + '\n';
					alert(funcName + '\n' + e.toString() + '\n' + _db);
				}
	
				try {
					var xx$ = "#URLEncodedFormat(_jscode2b)#";
					if (!!parent.deliverDecoder) parent.deliverDecoder(xx$);
				//	var xx$ = "#URLEncodedFormat(_jscode2b)#";
				//	alert('parent.eval = [' + parent.eval + ']' + ', xx$.length = [' + xx$.length + ']' + ', xx$ = [' + xx$ + ']');
				//	if (!!parent.eval) parent.eval(unescape(xx$));
				} catch(e) {
					jsErrorExplainer(e, 'Error 999');
				} finally {
				}
			</script>
		</cfif>
	</cfoutput>
</cfif>
