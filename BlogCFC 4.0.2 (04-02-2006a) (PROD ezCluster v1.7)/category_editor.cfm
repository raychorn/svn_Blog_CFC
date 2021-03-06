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

<cfif not session.loggedin>
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
	<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
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
			<td><nobr><a href="#cgi.script_name#?edit=#categoryid#">#application.resourceBundle.getResource("edit")#</a> - 
			<a href="#cgi.script_name#?delete=#categoryid#">#application.resourceBundle.getResource("delete")#</a> - 
			<a href="index.cfm?mode=cat&catid=#categoryid#">#application.resourceBundle.getResource("view")#</a></nobr></td>
		</tr>
		</cfloop>
	</table>
	<p>
	<form action="#cgi.script_name#" method="post">
	<input type="text" name="categoryname" value="#form.categoryname#">
	<cfif isDefined("url.edit")>
		<input type="hidden" name="id" value="#url.edit#">
		<input type="submit" name="reset" value="#application.resourceBundle.getResource("cancel")#">
		<input type="submit" name="save" value="#application.resourceBundle.getResource("editcategory")#">
	<cfelse>
		<input type="submit" name="save" value="#application.resourceBundle.getResource("addcategory")#">
	</cfif>
	</div>
	</cfoutput>
	
</cfmodule>
<cfsetting enablecfoutputonly=false>
