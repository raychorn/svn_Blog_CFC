<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : editor.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : August 22, 2005
	History      : Reset history for version 4.0
				   Offset support (rkc 8/22/05)
				   No longer parse code blocks out (rkc 9/22/05)
				   A recent bug fix caused another bug with <more/>. We no longer allow <more/> to be first in the body. (rkc 11/14/05)
	Purpose		 : Handles editing an item, or creating a new item
--->

<cfif (IsDefined("url.id"))>
	<cfset url.id = Trim(url.id)>
</cfif>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />

<html>
<head>
	<cfoutput><title>#application.blog.getProperty("blogTitle")# : #application.resourceBundle.getResource("editentry")#</title></cfoutput>
	<link rel="stylesheet" href="includes/style.css" type="text/css"/>
	<cfoutput>
		#application.snapIns.rootSnapIn.html_nocache()#
	</cfoutput>
</head>

<body>
</cfoutput>

<cfif not session.loggedin>
	<!--- prompt to login --->
	<cfset hideLayout = true>
	<cfinclude template="login.cfm">
	<cfabort>
</cfif>

<cfif not isDefined("url.id")>
	<cfabort>
<cfelseif url.id is not "new">
	<cftry>
		<cfset entry = application.blog.getEntry(url.id)>
		<cfparam name="form.title" default="#entry.title#">
		<cfparam name="form.alias" default="#entry.alias#">
		<!--- We modify the posted variable by our offset. This way the user sees the date s/he would see online. --->
		<cfparam name="form.posted" default="#entry.posted#">
		<cfparam name="form.allowcomments" default="#entry.allowcomments#">
		<cfparam name="form.oldenclosure" default="#entry.enclosure#">
		<cfparam name="form.oldfilesize" default="#entry.filesize#">
		<cfparam name="form.oldmimetype" default="#entry.mimetype#">

		<cfif len(entry.morebody)>
			<cfset entry.body = entry.body & "<more/>" & entry.morebody>
		</cfif>
		<cfparam name="form.body" default="#entry.body#">
		<!--- handle case where form submitted, cant use cfparam --->
		<cfif not isDefined("form.save")>
			<cfset form.categories = structKeyList(entry.categories)>
		</cfif>
		<cfcatch>
			<!---<cfoutput>error #cfcatch.detail# #cfcatch.message#</cfoutput>--->
			<cfdump var="#cfcatch#" label="url.id = [#url.id#]">
			<cfabort>
		</cfcatch>
	</cftry>
<cfelse>
	<cfif not isDefined("form.save")>
		<cfset form.categories = "">
	</cfif>
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	<cfparam name="form.alias" default="">
	<cfparam name="form.posted" default="#dateAdd("h", application.blog.getProperty("offset"), now())#">
	<cfparam name="form.allowcomments" default="">
	<cfparam name="form.oldenclosure" default="">
	<cfparam name="form.oldfilesize" default="0">
	<cfparam name="form.oldmimetype" default="">
</cfif>

<cfparam name="form.newcategory" default="">

<cfif isDefined("form.delete_enclosure")>
	<cfif len(form.oldenclosure) and fileExists(form.oldenclosure)>
		<cffile action="delete" file="#form.oldenclosure#">
	</cfif>
	<cfset form.oldenclosure = "">
	<cfset form.oldfilesize = "0">
	<cfset form.oldmimetype = "">
	<!--- We need to set a msg to warn folks that they need to save the entry --->
	<cfif url.id is not "new">
		<cfset message = application.resourceBundle.getResource("enclosureentrywarning")>
	</cfif>
</cfif>

<cfif isDefined("form.delete")>
	<cfif isDefined("variables.entry")>
		<cftry>
			<cfset application.blog.deleteEntry(url.id)>
			<cfcatch>
			</cfcatch>
		</cftry>
	</cfif>
	<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			if (!!parent.refreshHomePage) {
				id = <cfif form._id is not "new">'#form._id#'<cfelse>''</cfif>;
				parent.refreshHomePage(id, '#Request.commonCode.makeLinkToSelf('', true)#');
			}
		//-->
		</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfif isDefined("form.save")>
	<cfset errorStr = "">
	<cfif not len(trim(form.title))>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludetitle") & "<br>">
	<cfelse>
		<cfset form.title = trim(form.title)>
	</cfif>
	<cfif not isDate(form.posted)>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("invaliddate") & "<br>">
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludebody") & "<br>">
		<cfset origbody = "">
	<cfelse>
		<cfset form.body = trim(form.body)>
		<cfset origbody = form.body>

		<!--- Handle potential <more/> --->
		<!--- fix by Andrew --->
		<cfset strMoreTag = "<more/>">
		<cfset moreStart = findNoCase(strMoreTag,form.body)>
		<cfif moreStart gt 1>
			<cfset moreText = trim(mid(form.body,(moreStart+len(strMoreTag)),len(form.body)))>
			<cfset form.body = trim(left(form.body,moreStart-1))>
		<cfelseif moreStart is 1>
			<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludebody") & "<br>">
		<cfelse>
			<cfset moreText = "">
		</cfif>

	</cfif>
	
	<cfif (not isDefined("form.categories") or form.categories is 0) and not len(trim(form.newCategory))>
		<cfset errorStr = errorStr & application.resourceBundle.getResource("mustincludecategory") & "<br>">
	<cfelse>
		<cfset form.newCategory = trim(htmlEditFormat(form.newCategory))>
	</cfif>

	<cfif len(form.alias)>
		<cfset form.alias = trim(htmlEditFormat(form.alias))>
	<cfelse>
		<!--- Auto create the alias --->
		<cfset form.alias = application.blog.makeTitle(form.title)>
	</cfif>
	
	<!--- handle file upload. later  --->
	<cfif len(trim(form.enclosure))>
		<cfset destination = expandPath("./enclosures")>
		<!--- first off, potentially make the folder --->
		<cfif not directoryExists(destination)>
			<cfdirectory action="create" directory="#destination#">
		</cfif>
		
		<cffile action="upload" filefield="enclosure" destination="#destination#" nameconflict="makeunique">
		<cfif cffile.filewassaved>
			<cfset form.oldenclosure = cffile.serverDirectory & "/" & cffile.serverFile>
			<cfset form.oldfilesize = cffile.filesize>
			<cfset form.oldmimetype = cffile.contenttype & "/" & cffile.contentsubtype>
		</cfif>
	</cfif>
	
	<cfif not isNumeric(form.oldfilesize)>
		<cfset form.oldfilesize = 0>
	</cfif>
	
	<cfif not len(errorStr)>
		<!--- Before we save, modify the posted time by -1 * posted --->
		<cfset form.posted = dateAdd("h", -1 * application.blog.getProperty("offset"), form.posted)>
		<cfif isDefined("variables.entry")>
			<cfset application.blog.saveEntry(url.id,form.title,form.body,moreText,form.alias,form.posted,form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype)>
		<cfelse>
			<cfset url.id = application.blog.addEntry(form.title,form.body,moreText,form.alias,form.posted,form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype)>
		</cfif>
		<!--- remove all old cats that arent passed in --->
		<cfif url.id is not "new">
			<cfset application.blog.removeCategories(url.id)>
		</cfif>
		<!--- potentially add new cat --->
		<cfif len(trim(form.newCategory))>
			<cfparam name="form.categories" default="">
			<cfset form.categories = listAppend(form.categories,application.blog.addCategory(form.newCategory))>
		</cfif>
		<cfset application.blog.assignCategories(url.id,form.categories)>
		<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
		<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				if (!!parent.refreshHomePage) {
					id = <cfif form._id is not "new">'#form._id#'<cfelse>''</cfif>;
					parent.refreshHomePage(id, '#Request.commonCode.makeLinkToSelf('', true)#');
				}
			//-->
			</script>
		</cfoutput>
		<cfabort>
	<cfelse>
		<!--- restore body, since it loses more body --->
		<cfset form.body = origbody>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly=false>

<cfif lsIsDate(form.posted)>
	<cfset form.posted = createODBCDateTime(form.posted)>
	<cfset form.posted = application.localeUtils.dateLocaleFormat(form.posted,"short") & " " & application.localeUtils.timeLocaleFormat(form.posted)>
</cfif>

<cfset allCats = application.blog.getCategories()>
	
<cfif isDefined("variables.entry")>

	<cfoutput><div class="date">#application.resourceBundle.getResource("editing")# : #entry.title#</div></cfoutput>

<cfelse>

	<cfoutput><div class="date">#application.resourceBundle.getResource("editingnewentry")#</div></cfoutput>

</cfif>

<cfoutput>
<div class="body">

<cfif isDefined("errorStr")>
<p>
<b>#application.resourceBundle.getResource("correctissues")#:</b><br>#errorStr#
</p>
<cfelseif isDefined("message")>
<p>
<b>#message#</b>
</p>
</cfif>

<form action="#Request.commonCode.makeLinkToSelf('', true)#" method="post" enctype="multipart/form-data">
<table width="100%" border=0>
	<tr>
		<td><b>#application.resourceBundle.getResource("title")#</b></td>
		<td><input type="text" name="title" value="#htmlEditFormat(form.title)#" size="100" maxlength="100" style="width:100%"></td>
	</tr>
	<tr>
		<td colspan=2><b>#application.resourceBundle.getResource("body")#</b><br>
		<textarea name="body" cols=50 rows=17 style="width:100%">#htmlEditFormat(form.body)#</textarea></td>
	</tr>
	<tr>
		<td><b>#application.resourceBundle.getResource("postedat")#</b></td>
		<td><input type="text" name="posted" value="#form.posted#" style="width:100%"></td>
	</tr>
	<tr valign="top">
		<td><b>#application.resourceBundle.getResource("categories")#</b></td>
		<td><cfif allCats.recordCount><select name="categories" multiple size=4 style="width:100%">
		<cfloop query="allCats">
		<option value="#categoryID#" <cfif isDefined("form.categories") and listFind(form.categories,categoryID)>selected</cfif>>#categoryName#</option>
		</cfloop>
		</select><br></cfif>
		<input type="text" name="newcategory" value="#htmlEditFormat(form.newcategory)#"> #application.resourceBundle.getResource("newcategory")#</td>
	</tr>
	<tr>
		<td><b>#application.resourceBundle.getResource("alias")#</b></td>
		<td><input type="text" name="alias" value="#form.alias#" style="width:100%"></td>
	</tr>
	<tr>
		<td><b>#application.resourceBundle.getResource("allowcomments")#</b></td>
		<td>
			<select name="allowcomments">
			<option value="true" <cfif form.allowcomments is "true">selected</cfif>>Yes</option>
			<option value="false" <cfif form.allowcomments is "false">selected</cfif>>No</option>
			</select>
		</td>
	</tr>
	<tr valign="top">
		<td><b>#application.resourceBundle.getResource("enclosure")#</b></td>
		<td>
		<input type="hidden" name="oldenclosure" value="#form.oldenclosure#">
		<input type="hidden" name="oldfilesize" value="#form.oldfilesize#">
		<input type="hidden" name="oldmimetype" value="#form.oldmimetype#">
		<cfif len(form.oldenclosure)>#listLast(form.oldenclosure,"/\")# <input type="submit" name="delete_enclosure" value="#application.resourceBundle.getResource("deleteenclosure")#"></cfif>
		<input type="file" name="enclosure" style="width:100%">
		<cfif (IsDefined("url.id"))>
			<input type="hidden" name="_id" value="#url.id#">
		</cfif>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="#application.resourceBundle.getResource("save")#">
		<cfif url.id is not "new"><input type="submit" name="delete" value="#application.resourceBundle.getResource("delete")#" onClick="return confirm('#application.resourceBundle.getResource("areyousure")#')"></cfif> 
		<input type="submit" name="cancel" value="#application.resourceBundle.getResource("cancel")#" onClick="parent.launchBlogEditor(false <cfif url.id is not "new">, '#url.id#'</cfif>);"></td>
	</tr>
</table>
</form>
</cfoutput>

</body>
</html>


