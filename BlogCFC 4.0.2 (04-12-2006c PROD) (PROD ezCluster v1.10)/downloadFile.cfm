<cfprocessingdirective pageencoding="utf-8">

<cfparam name="filename" type="string" default="">

<cfif (Len(filename) gt 0)>
	<cfset filename = URLDecode(filename)>
</cfif>

<cfsavecontent variable="downloadContent">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("download")#</div>
	<div class="body">
		<h5 align="center" style="color: blue;">Downloading... (<a href="#filename#" target="_blank">#filename#</a>)</h5>
		<cfset _mainURL = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/main')>
		<a href="#filename#" target="_blank">Click HERE to Download in case your requested file does not begin to download automatically...</a>
		<br><br><br><br>
		<a href="#_mainURL#">Click HERE to continue...</a>
	</div>
	<cfif (FindNoCase(".ZIP", filename) gt 0)>
		<form name="myForm" action="#filename#" method="get" target="_blank">
			<input type="Submit" name="btn_submit" value="[Download]" style="display: none;">
		</form>
		<script language="JavaScript1.2" type="text/javascript">
			document.myForm.submit();
		</script>
	<cfelse>
		<script language="JavaScript1.2" type="text/javascript">
			downloadWin = window.open('#filename#',"download", "width=800,height=600,resizeable=yes,scrollbars=1");
		</script>
	</cfif>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>

	<cfmodule template="tags/layout.cfm">
		<cfoutput>#downloadContent#</cfoutput>
	</cfmodule>
	
<cfelse>
	
	<cfoutput>#downloadContent#</cfoutput>
	
</cfif>
