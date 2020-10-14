<!---
	Name         : c:\projects\blog\client\copy.cfm
	Author       : Raymond Camden 
	Created      : 09/26/05
	Last Updated : 
	History      : 
	Purpose		 : Copies one db to another. 
	
	This is not quite done yet. It doesn't move search stats.
--->

<!--- Set this to the source DSN --->
<cfset sourceDSN = "blogdev">
<!--- Set this to the destination DSN --->
<cfset destDSN = "blogdev_mysql">

<cfquery name="getcategories" datasource="#sourceDSN#">
select	*
from	tblblogcategories
</cfquery>

<cfloop query="getcategories">
	<cfquery datasource="#destDSN#">
	insert into tblblogcategories(categoryid, categoryname, blog)
	values('#categoryid#', '#categoryname#', '#blog#')
	</cfquery>
</cfloop>

<cfoutput>
Copied #getcategories.recordCount# records in tblBlogCategories.
<p>
</cfoutput>

<cfquery name="getcomments" datasource="#sourceDSN#">
select	*
from	tblblogcomments
</cfquery>

<cfloop query="getcomments">
	<cfquery datasource="#destDSN#">
	insert into tblblogcomments(id, entryidfk, name, email, comment, posted, subscribe)
	values('#id#', 
	'#entryidfk#', 
	'#name#', 
	'#email#', 
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#comment#">, 
	'#posted#', 
	<cfif subscribe is ''>0<cfelse>#subscribe#</cfif>
	)
	</cfquery>
</cfloop>

<cfoutput>
Copied #getcomments.recordCount# records in tblBlogComments.
<p>
</cfoutput>

<cfquery name="getentries" datasource="#sourceDSN#">
select	*
from	tblblogentries
</cfquery>

<cfloop query="getentries">
	<cfquery datasource="#destDSN#">
	insert into tblblogentries(id, 
	title, 
	body, 
	posted, 
	morebody, 
	alias, 
	username, 
	blog, 
	allowcomments, 
	enclosure, filesize, mimetype)
	values('#id#', 
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">, 
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#body#">, 
	'#posted#', 
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#morebody#">, 
	'#alias#',
	'#username#', 
	'#blog#', 
	#allowcomments#,
	'#enclosure#', 
	<cfif filesize is not "">#filesize#<cfelse>0</cfif>, 
	'#mimetype#' 
	)
	</cfquery>
</cfloop>

<cfoutput>
Copied #getentries.recordCount# records in tblBlogEntries.
<p>
</cfoutput>

<cfquery name="getentriescategories" datasource="#sourceDSN#">
select	*
from	tblblogentriescategories
</cfquery>

<cfloop query="getentriescategories">
	<cfquery datasource="#destDSN#">
	insert into tblblogentriescategories(categoryidfk, entryidfk)
	values('#categoryidfk#', '#entryidfk#')
	</cfquery>
</cfloop>

<cfoutput>
Copied #getentriescategories.recordCount# records in tblBlogEntriesCategories.
<p>
</cfoutput>

<cfquery name="getsubscribers" datasource="#sourceDSN#">
select	*
from	tblblogsubscribers
</cfquery>

<cfloop query="getsubscribers">
	<cfquery datasource="#destDSN#">
	insert into tblblogsubscribers(email,token,blog)
	values('#email#', '#token#', '#blog#')
	</cfquery>
</cfloop>

<cfoutput>
Copied #getsubscribers.recordCount# records in tblBlogSubscribers.
<p>
</cfoutput>

<cfquery name="gettbs" datasource="#sourceDSN#">
select	*
from	tblblogtrackbacks
</cfquery>

<cfloop query="gettbs">
	<cfquery datasource="#destDSN#">
	insert into tblblogtrackbacks(id, title, blogname, posturl, excerpt, created, entryid, blog)
	values('#id#', '#title#', '#blogname#',
	'#posturl#', '#excerpt#', '#created#', '#entryid#', '#blog#')
	</cfquery>
</cfloop>

<cfoutput>
Copied #gettbs.recordCount# records in tblBlogTrackbacks.
<p>
</cfoutput>
