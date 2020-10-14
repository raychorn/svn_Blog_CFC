<cfprocessingdirective pageencoding="utf-8">

<!--- This file is executed by CF whenever an external program that needs to bypass the normal internal site processing is accessed. --->

<cfscript>
//	_fname = ExpandPath(CGI.SCRIPT_NAME);
//	writeOutput('_fname = [#_fname#]<br>');
//	writeOutput('CGI.SCRIPT_NAME = [#CGI.SCRIPT_NAME#]<br>');
</cfscript>

<!--- BEGIN: This code actually loads and runs the correct file based on the actual file that is being requested. --->
<cfset _url = ListGetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, "/"), "/")>
<cfinclude template="#_url#">
<!--- END! This code actually loads and runs the correct file based on the actual file that is being requested. --->
