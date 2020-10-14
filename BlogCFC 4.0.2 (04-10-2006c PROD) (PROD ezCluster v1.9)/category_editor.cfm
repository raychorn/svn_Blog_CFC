<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : category_editor.cfm
	Author       : Raymond Camden 
	Created      : August 5, 2005
	Last Updated : 
	History      : 
	Purpose		 : Handles editing an category, or creating a new category
--->

<cfif not session.persistData.loggedin>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfif len(trim(form.categoryname))>
		<cfif isDefined("form.id")>
			<cfset application.blog.saveCategory(form.id, trim(htmlEditFormat(form.categoryname)))>
		<cfelse>
			<cfset application.blog.addCategory(trim(htmlEditFormat(form.categoryname)))>
		</cfif>
	</cfif>
	<!--- no matter what, cflocate to precent reload --->
	<cflocation url="category_editor.cfm" addToken="false">
</cfif>

<cfif isDefined("url.delete")>
	<cftry>
		<cfset application.blog.deleteCategory(url.delete)>
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
</cfif>

<cfif isDefined("url.edit")>
	<cfparam name="form.categoryname" default="#application.blog.getCategory(url.edit)#">
<cfelse>
	<cfset form.categoryname = "">
</cfif>



<cfset cats = application.blog.getCategories()>

<cfmodule template="tags/layout.cfm" title="#application.resourceBundle.getResource("categoryeditor")#" suppressLayout="true" maxWidth="350">

	<cfoutput>
	<div class="date">#application.resourceBundle.getResource("categoryeditor")#</div>
	<div class="body">
	<table border="1">
		<tr>
			<td width="100%"><b>#application.resourceBundle.getResource("category")#</b></td>
			<td><b>#application.resourceBundle.getResource("posts")#</b></td>
			<td>&nbsp;</td>
		</tr>
		<cfloop query="cats">
		<tr>
			<td>#categoryname#</td>
			<td>#entrycount#</td>
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/')) & '&edit=#categoryid#'>
			<td><nobr><a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("edit")#</a> - 
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/')) & '&delete=#categoryid#'>
			<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("delete")#</a> - 
			<cfset _url = Request.commonCode._clusterizeURLForSessionOnly(Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#') & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/')) & '&mode=cat&catid=#categoryid#'>
			<a href="#_url#" <cfif isDebugMode()>title="_url = [#_url#]"</cfif>>#application.resourceBundle.getResource("view")#</a></nobr></td>
		</tr>
		</cfloop>
	</table>
	<p>
	<cfset _url = Request.commonCode._clusterizeURLForSessionOnly('http://#CGI.SERVER_NAME#' & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '_index.cfm', '/'))>
	<form action="#_url#" method="post" enctype="application/x-www-form-urlencoded">
	<input type="text" name="categoryname" value="#form.categoryname#">
	<cfif isDefined("url.edit")>
		<input type="hidden" name="id" value="#url.edit#">
		<cfif (IsDefined("Session.sessID"))>
			<input type="hidden" name="sessID" value="#Session.sessID#">
		</cfif>
		<input type="submit" name="reset" value="#application.resourceBundle.getResource("cancel")#">
		<input type="submit" name="save" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="#application.resourceBundle.getResource("editcategory")#">
	<cfelse>
		<input type="submit" name="save" <cfif isDebugMode()>title="_url = [#_url#]"</cfif> value="#application.resourceBundle.getResource("addcategory")#">
	</cfif>
	</div>
	</cfoutput>
	
</cfmodule>
<cfsetting enablecfoutputonly=false>
