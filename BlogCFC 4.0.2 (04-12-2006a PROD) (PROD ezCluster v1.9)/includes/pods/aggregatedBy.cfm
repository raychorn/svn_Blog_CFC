<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : aggregatedBy.cfm
	Author       : Ray Horn 
	Created      : Jan 9, 2006
	Last Updated : 
	History      : 
	Purpose		 : Show which Blog Aggregators are supplying traffic.
--->

<!--- 
	  I know. The caller. syntax is icky. This should be safe since all pods work in the same context. 
	  I may move the UDFs to the request scope so it's less icky. At the same time, it's not the big huge of
	  a deal. In fact, I bet no one is even going to read this. If you do, hi, how are you. Send me an email
	  and we can talk about how sometimes it is necessary to break the rules a bit. Then maybe we can have a
	  beer and talk about good sci-fi movies.
--->
<cfmodule template="../../tags/podlayout.cfm" title="" containerClass="">  <!--- #application.resourceBundle.getResource("aggregatedBy")# --->

	<cfoutput>
		<cfif 0>
			<img src="#application.rooturl#/images/mxna88x31_grey.gif" alt="" width="88" height="31" border="0">
		<cfelse>
			<img src="http://#CGI.SERVER_NAME#/blog/includes/cfcontent_img.cfm?imageName=../images/mxna88x31_grey.gif" alt="" width="88" height="31" border="0">
		</cfif>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>