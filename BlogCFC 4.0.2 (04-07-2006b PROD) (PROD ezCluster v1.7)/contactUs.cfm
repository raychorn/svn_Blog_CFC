<cfprocessingdirective pageencoding="utf-8">

<cfset statusMsg = "">

<cfif ( (IsDefined("FORM.input_emailAddress")) AND (IsDefined("FORM.textarea_yourMessage")) ) OR ( (IsDefined("URL.input_emailAddress")) AND (IsDefined("URL.textarea_yourMessage")) )>
	<cfif (IsDefined("URL.input_emailAddress"))>
		<cfset FORM.input_emailAddress = URL.input_emailAddress>
	</cfif>

	<cfif (IsDefined("URL.textarea_yourMessage"))>
		<cfset FORM.textarea_yourMessage = URL.textarea_yourMessage>
	</cfif>

	<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
		<cfset instance = application.blog.instance>
	</cfif>

	<cfsavecontent variable="visitorsMessage">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H3>Site Visitor EMail from (#FORM.input_emailAddress#) for #instance.blogTitle#</H3>

<p align="justify" style="font-size: 10px;"><small>
#FORM.textarea_yourMessage#
</small>
</p>

</body>
</html>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		Request.commonCode.safely_cfmail('rabid_one@contentopia.net', FORM.input_emailAddress, 'Site Visitor EMail from (#FORM.input_emailAddress#) for #instance.blogTitle#', visitorsMessage);
		if (NOT Request.anError) {
			statusMsg = statusMsg & '<span class="normalBoldBluePrompt">Your email message was sent.  PLS allow 2 business days for a response.</span>';
		} else {
			statusMsg = statusMsg & '<span class="errorBoldPrompt">#Request.errorMsg#</span>';
		}
		statusMsg = statusMsg & '<br><br><a href="#Request.commonCode.dropURLScopeFromURL(Request.commonCode.makeLinkToSelf('_index.cfm', false))#">Click HERE to continue...</a>';
	</cfscript>
</cfif>

<cfsavecontent variable="contactUsStatus">
	<cfoutput>
	<div class="body">
	<br><br>#statusMsg#
	</div>
	</cfoutput>

</cfsavecontent>

<cfif not isDefined("hideLayout")>
	<cfmodule template="tags/layout.cfm">
		<cfoutput>#contactUsStatus#</cfoutput>
	</cfmodule>
<cfelse>
	<cfoutput>#contactUsStatus#</cfoutput>
</cfif>
