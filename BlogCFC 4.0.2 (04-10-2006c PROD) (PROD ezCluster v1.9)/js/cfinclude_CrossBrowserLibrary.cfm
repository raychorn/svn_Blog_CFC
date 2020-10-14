<cfsetting enablecfoutputonly="Yes">
<cfset Request.bool_cfinclude_CrossBrowserLibrary_loaded = true>
<cfsavecontent variable="_html_">
	<cfoutput>
	</cfoutput>
</cfsavecontent>

<cfscript>
	_html_ = Request.commonCode.jsMinifier(_html_);
</cfscript>

<cfoutput>#_html_#</cfoutput>

