<!---
	import_mt.cfm (c) 2004 Sean A Corfield
	Imports a Movable Type export file into Ray Camden's blog CFC.
	Requires:
		Blog CFC installed and working.
		blogimport.txt file in this directory - the result of a Movable Type export.
	Usage:
		http://server/blog/import_mt.cfm?username=xxx&password=yyy
		Where xxx / yyy is an admin username / password for Blog CFC.

WARNING - THIS IS NOT SUPPORTED IN LATEST BLOGCFC. WILL NEED TO BE MODIFIED!!!!!!!!!!

--->

<!--- fake login to blog for username / password --->
<cflogin>
	<cfloginuser name="#url.username#" password="#url.password#" roles="admin"/>
</cflogin>
<!--- load the blog data file --->
<cffile file="#expandPath('.')#/blogimport.txt" action="read" variable="blogText" charset="utf-8"/>

<!--- somewhat hackish way to handle blank lines since CF doesn't split lists properly --->
<cfset blogText = replace(blogText,"#chr(10)##chr(10)#","#chr(10)#|#chr(10)#","all")/>
<cfset blogText = replace(blogText,"#chr(10)##chr(10)#","#chr(10)#|#chr(10)#","all")/>
<cfset blogText = replace(blogText,"#chr(10)##chr(10)#","#chr(10)#|#chr(10)#","all")/>

<!--- count entries and comments for information --->
<cfset nEntries = 0 />
<cfset nComments = 0 />

<!--- split the file into lines --->
<cfset lines = listToArray(blogText,chr(12) & chr(10))/>
<cfset nLines = arrayLen(lines)/>
<cfoutput><p>There were #nLines# lines in the file. It was #len(blogText)# bytes long.</p></cfoutput>

<!--- create a Blog CFC instance to use for importing data --->
<cfset myBlog = createObject("component","org.camden.blog.blog").init() />
<cfset startTick = getTickCount() />
<!--- for managing insertion of categories --->
<cfset categories = structNew() />

<!--- show top 10 and bottom 10 lines just for sanity checking --->
<cfloop from="1" to="10" index="lineNo">
	<cfoutput>Line #lineNo#: #lines[lineNo]#<br /></cfoutput>
</cfloop>
<cfloop from="#nLines - 10#" to="#nLines#" index="lineNo">
	<cfoutput>Line #lineNo#: #lines[lineNo]#<br /></cfoutput>
</cfloop>

<cfset lineNo = 1 />
<cfset importing = true />
<cfloop condition="#importing#">
	<cfif lineNo ge nLines>
		<cfset importing = false />
	<cfelse>
		<!--- accumulate the beginning of an entry --->
		<cfset title = lines[lineNo + 1] />
		<cfset morebody = "" />
		<cfset alias = lines[lineNo] />
		<cfset title = mid(title,len('TITLE: ')+1,len(title)-len('TITLE: ')) />
		<cfset alias = mid(alias,len('AUTHOR: ')+1,len(alias)-len('AUTHOR: ')) />
		<cfset catIDs = "" />
		<cfset lineNo = lineNo + 7 />
		<!--- we ignore the primary category but collect all the category entries:
			Movable Type duplicates the primary category entry as a category entry --->
		<cfloop condition="#lines[lineNo]# is not '|'">
			<cfset cat = lines[lineNo] />
			<cfset cat = mid(cat,len('CATEGORY: ')+1,len(cat)-len('CATEGORY: ')) />
			<cfif not structKeyExists(categories,cat)>
				<cfoutput><p>addCategory(#cat#)</p></cfoutput>
				<cfset categories[cat] = myBlog.addCategory(cat) />
			</cfif>
			<cfset catIDs = listAppend(catIDs,categories[cat]) />
			<cfset lineNo = lineNo + 1 />
		</cfloop>
		<cfset lineNo = lineNo + 1 />
		<cfset posted = lines[lineNo] />
		<cfset posted = mid(posted,len('DATE: ')+1,len(posted)-len('DATE: ')) />
		<!--- ensure we have a timestamp --->
		<cfset posted = dateAdd('d',0,posted) />
		<cfset lineNo = lineNo + 3 />	<!--- advance to start of the body --->
		<cfset body = lines[lineNo] />
		<cfif body is "|"><cfset body = "" /></cfif>
		<cfloop condition="#lines[lineNo+1]# is not '-----'">
			<cfset lineNo = lineNo + 1 />
			<cfif lines[lineNo] is "|"><cfset lines[lineNo] = "" /></cfif>
			<cfset body = body & chr(10) & lines[lineNo] />
		</cfloop>
		<cfset lineNo = lineNo + 3 />
		<cfif lines[lineNo] is not "|">
			<!--- there is an extended body --->
			<cfset morebody = lines[lineNo] />
			<cfif morebody is "|"><cfset morebody = "" /></cfif>
			<cfloop condition="#lines[lineNo+1]# is not '-----'">
				<cfset lineNo = lineNo + 1 />
				<cfif lines[lineNo] is "|"><cfset lines[lineNo] = "" /></cfif>
				<cfset morebody = morebody & chr(10) & lines[lineNo] />
			</cfloop>
		</cfif>
		<cfset nEntries = nEntries + 1 />
		<!--- display what we're about to add --->
		<cfoutput><p>addEntry(#title#,#left(body,min(20,len(body)))#...,<cfif morebody is "">
		<cfelse>#left(morebody,min(20,len(morebody)))#...</cfif>,#alias#,#posted#)</p></cfoutput>
		<cfset entryID = myBlog.addEntry(title,body,morebody,alias,posted) />
		<cfoutput><p>assignCategories(#entryID#,#catIDs#)</p></cfoutput>
		<cfset myBlog.assignCategories(entryID,catIDs) />
		<!--- skip to start of comment, if any --->
		<cfloop condition="#lines[lineNo]# is not '--------' and #lines[lineNo]# is not 'COMMENT:'">
			<cfset lineNo = lineNo + 1 />
		</cfloop>
		<cfloop condition="#lines[lineNo]# is 'COMMENT:'">
			<cfset cmtAuthor = lines[lineNo+1] />
			<cfset cmtEmail = lines[lineNo+2] />
			<cfset comment = lines[lineNo+6] />
			<cfif comment is "|"><cfset comment = "" /></cfif>
			<cfset cmtAuthor = mid(cmtAuthor,len('AUTHOR: ')+1,len(cmtAuthor)-len('AUTHOR: ')) />
			<cfset cmtEmail = mid(cmtEmail,len('EMAIL: ')+1,len(cmtEmail)-len('EMAIL: ')) />
			<cfset lineNo = lineNo + 6 />
			<cfloop condition="#lines[lineNo+1]# is not '-----'">
				<cfset lineNo = lineNo + 1 />
				<cfif lines[lineNo] is "|"><cfset lines[lineNo] = "" /></cfif>
				<cfset comment = comment & "<br />" & lines[lineNo] />
			</cfloop>
			<cfoutput><p>addComment(#entryID#,#cmtAuthor#,#cmtEmail#,#left(comment,min(20,len(comment)))#...)</p></cfoutput>
			<cfset myBlog.addComment(entryID,cmtAuthor,cmtEmail,comment) />
			<cfset nComments = nComments + 1 />
			<cfset lineNo = lineNo + 2 />
		</cfloop>
		<!--- skip to end of entry --->
		<cfloop condition="#lines[lineNo]# is not '--------'">
			<cfset lineNo = lineNo + 1 />
		</cfloop>
		<cfset lineNo = lineNo + 1 />
	</cfif>
</cfloop>
<cfset endTick = getTickCount() />
<cfoutput><p>Imported #nEntries# entries and #nComments# comments in #(endTick - startTick) / 1000.0# seconds.</p></cfoutput>