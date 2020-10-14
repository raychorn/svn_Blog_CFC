<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : unsubscribe.cfm
	Author       : Raymond Camden 
	Created      : October 20, 2004
	Last Updated : July 21, 2005
	History      : Removed mapping (3/20/05)
				   Adding cfsetting, procdirective (rkc 7/21/05)
	Purpose		 : Allows you to unsubscribe
--->

<cfif not isDefined("url.email")>
	<cflocation url = "#application.blog.getProperty("blogURL")#">
</cfif>


<cfmodule template="tags/layout.cfm" title="#application.resourceBundle.getResource("unsubscribe")#">

<cfoutput>
<div class="date">#application.resourceBundle.getResource("unsubscribe")#</div>
</cfoutput>

<cfif isDefined("url.commentID")>

	<!--- Attempt to unsub --->
	<cftry>
		<cfset result = application.blog.unsubscribeThread(url.commentID, url.email)>
		<cfcatch>
			<cfset result = false>
		</cfcatch>
	</cftry>
	
	<cfif result>
		<cfoutput>
		<p>#application.resourceBundle.getResource("unsubscribesuccess")#</p>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<p>#application.resourceBundle.getResource("unsubscribefailure")#</p>
		</cfoutput>
	</cfif>

<cfelseif isDefined("url.token")>

	<!--- Attempt to unsub --->
	<cftry>
		<cfset result = application.blog.removeSubscriber(url.email, url.token)>
		<cfcatch>
			<cfset result = false>
		</cfcatch>
	</cftry>
	
	<cfif result>
		<cfoutput>
		<p>#application.resourceBundle.getResource("unsubscribeblogsuccess")#</p>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<p>#application.resourceBundle.getResource("unsubscribeblogfailure")#</p>
		</cfoutput>
	</cfif>

</cfif>

<cfoutput><p><a href="#application.blog.getProperty("blogurl")#">#application.resourceBundle.getResource("returntoblog")#</a></p></cfoutput>

</cfmodule>
<cfsetting enablecfoutputonly=false>	