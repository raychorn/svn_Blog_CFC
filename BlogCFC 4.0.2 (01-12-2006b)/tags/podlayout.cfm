<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : podlayout.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : July 22, 2005
	History      : PaulH added cfproc (rkc 7/22/05)
	Purpose		 : Pod Layout
--->

<cfparam name="attributes.title">

<cfif thisTag.executionMode is "start">

	<cfparam name="attributes.containerClass" type="string" default="rightMenu">

	<cfoutput>
	<p>
	<cfif (Len(attributes.containerClass) gt 0)>
		<div class="#attributes.containerClass#">
	<cfelse>
		<div>
	</cfif>
	<cfif (Len(attributes.title) gt 0)>
		<div class="menuTitle">#attributes.title#</div>
	</cfif>
	<div class="menuBody">
	</cfoutput>		

<cfelse>

	<cfoutput>
	</div>
	</div>
	</p>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>