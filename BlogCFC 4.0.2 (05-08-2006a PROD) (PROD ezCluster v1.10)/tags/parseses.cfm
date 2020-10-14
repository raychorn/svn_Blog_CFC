<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : parseses.cfm
	Author       : Raymond Camden 
	Created      : June 23, 2005
	Last Updated : November 28, 2005
	History      : Support for day
				   Removed some old code (rkc 11/28/05)
	Purpose		 : Attempts to find SES info in URL and set URL vars
--->

<cfscript>
/**
 * Parses my SES format. Demands /YYYY/MMMM/TITLE or /YYYY/MMMM/DDDD/TITLE
 * One line from MikeD
 *
 * @author Raymond Camden (ray@camdenfamily.com)
 * @version 1, June 23, 2005
 */ 
function parseMySES() {
	//line below from Mike D.
	var urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '');
	var r = structNew();
	var theLen = listLen(urlVars,"/");

	if(theLen lte 2) return r;
		
	r.year = listFirst(urlVars,"/");
	r.month = listGetAt(urlVars,2,"/");
	
	if(theLen is 4) {
		r.day = listGetAt(urlVars,3,"/");
	}

	//r.title = replace(listLast(urlVars,"/"),"_"," ","all");		
	r.title = listLast(urlVars, "/");
	return r;
}
</cfscript>

<!--- Try to load my info from the URL ... --->
<cfset sesInfo = parseMySES()>

<!--- I don't have the right info, so we are outa here! --->
<cfif structIsEmpty(sesInfo)>
	<cfsetting enablecfoutputonly=false>
	<cfexit method="exitTag">
</cfif>

<!--- The blog checks, but lets be extra careful --->
<cfif not isNumeric(sesInfo.year) or not isNumeric(sesInfo.month) or not (sesInfo.month gte 1 and sesInfo.month lte 12) or not len(trim(sesInfo.title))>
	<cfsetting enablecfoutputonly=false>
	<cfexit method="exitTag">
</cfif>

<!--- Ok, so I have a structure with Year, Month, and Title. Call the new method to see if we have a match. --->
<cfset params = structNew()>
<cfset params.byMonth = sesInfo.month>
<cfset params.byYear = sesInfo.year>
<cfif structKeyExists(sesInfo,"day")>
	<cfset params.byDay = sesInfo.day>
</cfif>

<cfset params.byAlias = sesInfo.title>
<cfset url.mode = "alias">
<cfset url.alias = params.byAlias>

<!--- Copy to caller --->
<cfset caller.params = params>

<cfsetting enablecfoutputonly=false>
<cfexit method="exitTag">
