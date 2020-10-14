ReadMe

This blog was created by Raymond Camden (ray@camdenfamily.com) of Mindseye (www.mindseye.com). You
may use this blog as you will. I ask that you link back to my blog though. 

If you find this blog worthy, I have a Amazon wish list set up (www.amazon.com/o/registry/2TCL1D08EZEYE ). Gifts are always welcome. ;)

Install Instructions:
	Extract
	Run SQL script (for MS SQL users)
	Edit the users table to add yourself as a user.
	Edit the ini file. All the settings should make sense.
	Run.
	
	Or read the more details instructions in the Word doc.
	
To admin, go to <yourblogurl>?designmode=1

Last Updated: November 28, 2005
/org/hastings/locale/utils.cfc - much better fix by paul hastings
/org/camden/blog/blog.cfc - bluedragon fix, ping weblogs, blogkeywords meta info (last two from Rob Gonda)
/org/camden/blog/blog.ini - new keywords ini setting
/client/tags/parses.cfm - removed some old code that caused a bug if an alias had _ in it.
/client/tags/layout.cfm - both meta/title and meta/keywords show up now in header (Rob Gonda)
/client/stats.cfm - just a fixed cfsetting
/client/index.cfm - bluedragon fix
/client/googlesitemap.cfm - initial add
/install/BlogCFC.doc updated for stuff above, and PDF version included in zip

Last Updated: November 22, 2005
/org/hastings/locale/utils.cfc - bug fix for mysql/msaccess
/org/camden/blog/blog.ini - TB spam list updated

Last Updated: November 14, 2005
/client/index.cfm -> Two fixes to allow title to work right on single entry pages
/client/editor.cfm -> fix with <more/> issue. You are no longer allowed to have <more/> in the beginning.
/org/camden/blog/blog.cfc -> Two case issues with mysql
/client/stats.cfm -> ditto above

Last Updated: November 11, 2005
Access.mdb was missing a db column
blog.cfc had a fix for ms access
print.cfm was using request.rooturl, not app.rooturl

Current Version: 4.0
Almost every file has been updated.
Trackback table added.
Search stats table added.
Comments table modified to add website