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

	<cfparam name="attributes.align" type="string" default="left">
	<cfparam name="attributes.bgColor" type="string" default="white">

	<cfoutput>
		<table width="100%" cellpadding="-1" cellspacing="-1" style="border-left: thin solid Blue; border-right: thin solid Blue;">
		<tr>
		<cfif (Len(attributes.title) gt 0)>
			<td align="center" valign="top" class="menuTitle"><span class="menuTitle">#attributes.title#</span></td>
		</cfif>
		</tr>
		<tr>
			<td align="#attributes.align#" valign="middle" bgcolor="#attributes.bgColor#">
	</cfoutput>		

<cfelse>

	<cfoutput>
			</td>
		</tr>
		</table>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>