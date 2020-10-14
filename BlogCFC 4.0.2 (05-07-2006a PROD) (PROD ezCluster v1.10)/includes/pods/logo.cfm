<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : logo.cfm
	Author       : Ray Horn 
	Created      : December 6, 2005
	Last Updated : December 6, 2005
	Purpose		 : Display logo box
--->

<cfmodule template="../../tags/podlayout.cfm" align="center" bgColor="##027FFF" title="">

	<cfoutput>
		<img src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/blog/includes/cfcontent_img.cfm?imageName=../images/Yes02b1a187x171.jpg')#" width="187" height="171" border="0">
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>