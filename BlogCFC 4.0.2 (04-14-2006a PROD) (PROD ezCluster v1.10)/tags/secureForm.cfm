<cfsetting enablecfoutputonly="Yes">
<!--- secureForm.cfm
	Sets-up a Secure FORM using SSL that works for each server in the server Farm.
	FORMs must post back to the server of origin rather than be clusterized to post against any available server.
	CGI.SERVER_NAME is the input that drives the choice for SSL server name.
	Request.SSL_Server_Matrix is the input that drives the SSL server to physical server mapping...
		rabid.1.contentopia.net/blog=babylon5.ssl-docs.com/wwwroot/blog is an example of this.
 --->
<cfset rndForm = RandRange(1, 65535, "SHA1PRNG")>
<cfparam name="attributes.formName" type="string" default="secureForm#rndForm#">
<cfparam name="attributes.enctype" type="string" default="application/x-www-form-urlencoded">
<cfparam name="attributes.action" type="string" default="">

<cfif (Len(Trim(attributes.action)) eq 0)>
	<cfexit method="exitTemplate">
</cfif>

<cfif (NOT isDebugMode())>
</cfif>

<cfscript>
	ar = ListToArray(Request.SSL_Server_Matrix, ',');
	n = ArrayLen(ar);
	for (i = 1; i lte n; i = i + 1) {
		ar2 = ListToArray(ar[i], '=');
		if (ArrayLen(ar2) eq 2) {
			if (FindNoCase(CGI.SERVER_NAME, ar2[1]) gt 0) {
				attributes.action = ReplaceNoCase(attributes.action, ar2[1], ar2[2]);
			}
		}
	}
</cfscript>

<cfif (Len(Trim(attributes.formName)) eq 0) OR (ListFindNoCase("application/x-www-form-urlencoded,multipart/form-data", attributes.enctype, ",") eq 0)>
	<cfexit method="exitTemplate">
</cfif>

<cfset _prefix = "https://">
<cfif (isDebugMode()) OR (FindNoCase(".ssl-docs.com", attributes.action) eq 0)>
	<cfset _prefix = "http://">
</cfif>

<cfscript>
	attributes.action = ReplaceNoCase(attributes.action, 'http://', '');

	if ( (isDebugMode()) AND (thisTag.executionMode is "start") ) {
		writeOutput('attributes.action = [#_prefix##attributes.action#], ThisTag.HasEndTag = [#ThisTag.HasEndTag#], thisTag.executionMode = [#thisTag.executionMode#]<br>');
	}
</cfscript>

<cfif (thisTag.executionMode is "start")>
	<cfoutput>
		<form name="#attributes.formName#" id="#attributes.formName#" action="#_prefix##attributes.action#" enctype="#attributes.enctype#" method="post">
	</cfoutput>
<cfelseif (thisTag.executionMode is "end")>
	<cfoutput>
		</form>
		<cfif (_prefix IS "https://")>
			<br><br><h6 align="left" style="color: blue;">This page is protected by SSL Encryption.</h6>
		</cfif>
	</cfoutput>
</cfif>
