<cffunction name="cf_dump" access="public">
	<cfargument name="_aVar_" type="any" required="yes">
	<cfargument name="_aLabel_" type="string" required="yes">
	<cfargument name="_aBool_" type="boolean" default="False">
	
	<cfif (_aBool_)>
		<cfdump var="#_aVar_#" label="#_aLabel_#" expand="Yes">
	<cfelse>
		<cfdump var="#_aVar_#" label="#_aLabel_#" expand="No">
	</cfif>
</cffunction>

<cffunction name="cfdump" access="public" returntype="string">
	<cfargument name="_aVar_" type="any" required="yes">
	<cfargument name="_aLabel_" type="string" required="yes">
	<cfargument name="_aBool_" type="boolean" default="False">
	
	<cfsavecontent variable="_html">
		<cfoutput>
			#cf_dump(_aVar_, _aLabel_, _aBool_)#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn _html>
</cffunction>


