<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : recent.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : July 12, 2005
	History      : added processingdir (rkc 11/10/03)
				   New link code (rkc 7/12/05)
	Purpose		 : Display recent entries
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="pod_recententries" scope="application" timeout="#application.timeout#">

	<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("recententries")#">
	
		<br>
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<cfset params = structNew()>
			<cfset params.maxEntries = 10>
			<cfset params.lastXDays = 20>
			<cfset _i = 1>
			<cfloop index="_iCount" from="1" to="15">
				<cfset entries = application.blog.getEntries(duplicate(params))>
				<cfloop query="entries">
					<cfset bgColor = "##BFFFFF">
					<cfif (_i MOD 2) eq 0>
						<cfset bgColor = "##FFFFA8">
					</cfif>
					<cfoutput>
						<tr>
							<td<cfif (Len(bgColor) gt 0)> bgcolor="#bgColor#"</cfif>>
								<a href="#application.blog.makeLink(id)#">#title#</a>
							</td>
						</tr>
					</cfoutput>
					<cfset _i = _i + 1>
					<cfif (_i gte params.maxEntries)>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif (entries.recordCount gt 5) OR (_i gte params.maxEntries)>
					<cfbreak>
				</cfif>
				<cfset params.lastXDays = params.lastXDays + 20>
			</cfloop>
	
			<cfif not entries.recordCount>
				<tr>
					<td>
						<cfoutput>#application.resourceBundle.getResource("norecententries")#</cfoutput>
					</td>
				</tr>
			</cfif>
		</table>
		
	</cfmodule>

</cfmodule>
	
<cfsetting enablecfoutputonly=false>
