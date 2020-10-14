<cfsetting enablecfoutputonly="Yes">
<!--- emailContent.cfm
 --->
<cfparam name="attributes.tabTitle" type="string" default="">

<cfif (thisTag.executionMode is "start")>
	<cfoutput>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		
		<html>
		<head>
			#Request.commonCode.html_nocache()#
			<title>cfdump Function #Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
			<meta name="robots" content="index,follow" />
			<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
			<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
			<link href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/images/singleTabbedContent.css')#" rel="stylesheet" type="text/css">
		</head>
		
		<cfset hostName = Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#')>
		<cfset urlPrefix = hostName & '/' & ListFirst(CGI.SCRIPT_NAME, '/')>
		<BODY text="##000000" leftMargin="0" background="#(urlPrefix & '/images/singleTabbedContentBgMainBlue2.jpg')#" topMargin="0">
		
		<div>
<TABLE cellSpacing=0 cellPadding=0 width=792 align=center bgColor=##ffffff border=0>
  <TBODY>
  <TR>
    <TD vAlign=bottom>
      <TABLE height=1 cellSpacing=0 cellPadding=0 width=792 align=center 
      border=0>
        <TBODY>
        <TR>
          <TD vAlign=top align=right><IMG style="DISPLAY: block" height=40 
            src="#urlPrefix#/images/singleTabbedContentCleardot.gif" width=150></TD>
          <TD vAlign=top align=right><IMG style="DISPLAY: block" height=40 
            src="#urlPrefix#/images/singleTabbedContentTnWhyBottom.jpg" 
          width=41></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD vAlign=top align=middle>
      <TABLE height=0 cellSpacing=0 cellPadding=0 width=750 border=0>
        <TBODY>
        <TR>
          <TD vAlign=top align=left>&nbsp;</TD>
          <TD vAlign=top align=left>
            <TABLE height=38 cellSpacing=0 cellPadding=0 width=264 border=0>
              <TBODY>
              <TR>
                <TD class=BarHeading 
                background=#urlPrefix#/images/singleTabbedContentBar.gif>#attributes.tabTitle#&nbsp; 
                </TD></TR></TBODY></TABLE></TD>
          <TD vAlign=top align=right>&nbsp;</TD></TR>
        <TR>
          <TD vAlign=top align=left width=10><IMG style="DISPLAY: block" 
            height=7 alt="" 
            src="#urlPrefix#/images/singleTabbedContentTopLeftCorner.gif" 
            width=7></TD>
          <TD vAlign=top align=middle width="100%"><IMG style="DISPLAY: block" 
            height=1 alt="" 
            src="#urlPrefix#/images/singleTabbedContentDotPurple.gif" 
            width="100%"></TD>
          <TD vAlign=top align=right><IMG style="DISPLAY: block" height=7 
            alt="" 
            src="#urlPrefix#/images/singleTabbedContentTopRightCorner.gif" 
            width=7></TD></TR>
        <TR>
          <TD align=left width=10 height="100%"><IMG style="DISPLAY: block" 
            height="100%" alt="" 
            src="#urlPrefix#/images/singleTabbedContentDotPurple.gif" width=1></TD>
          <TD vAlign=top align=middle>
            <DIV align=center>
            <TABLE cellSpacing=0 cellPadding=0 width=700 border=0>
              <TBODY>
              <TR>
                <TD width="100%"><IMG style="DISPLAY: block" height=20 
                  src="#urlPrefix#/images/singleTabbedContentCleardot.gif"></TD></TR>
              <TR>
                <TD vAlign=top align=middle width="100%">
					<table width="100%" cellpadding="1" cellspacing="1">
						<tr>
							<td width="20%">
								<img src="#urlPrefix#/images/Yes02b1a187x171.jpg" alt="" width="187" height="171" border="0">
							</td>
							<td width="80%">
	</cfoutput>
<cfelseif (thisTag.executionMode is "end")>
	<cfoutput>
							</td>
						</tr>
					</table>
				 </TD>
                <TD vAlign=top align=middle width="23%" height=0. 
              rowSpan=2></TD></TR>
              <TR>
                <TD vAlign=top align=left width="77%" colSpan=2>
                  <P class=ValueText>&nbsp;</P></TD></TR></TBODY></TABLE></DIV></TD>
          <TD align=right height=0><IMG style="DISPLAY: block" height="100%" 
            alt="" src="#urlPrefix#/images/singleTabbedContentDotPurple.gif" 
            width=1></TD></TR>
        <TR>
          <TD vAlign=bottom align=left width=10 height=2><IMG 
            style="DISPLAY: block" height=7 alt="" 
            src="#urlPrefix#/images/singleTabbedContentBottomLeftCorner.gif" 
            width=7></TD>
          <TD vAlign=bottom align=middle height=2><IMG style="DISPLAY: block" 
            height=1 alt="" 
            src="#urlPrefix#/images/singleTabbedContentDotPurple.gif" 
            width="100%"></TD>
          <TD vAlign=bottom align=right height=2><IMG style="DISPLAY: block" 
            height=7 alt="" 
            src="#urlPrefix#/images/singleTabbedContentBottomRightCorner.gif" 
            width=7></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD vAlign=top align=left></TD></TR>
  <TR>
    <TD vAlign=top align=left>
      <TABLE height=54 cellSpacing=0 cellPadding=0 width=792 align=center 
      border=0>
        <TBODY>
        <TR>
          <TD width=528 height=25><IMG style="DISPLAY: block" height=32 
            src="#urlPrefix#/images/singleTabbedContentCleardot.gif" width=150></TD>
          <TD vAlign=bottom align=left width=264 rowSpan=2><IMG 
            style="DISPLAY: block" height=61 
            src="#urlPrefix#/images/singleTabbedContentBnRight.gif" 
        width=264></TD></TR>
        <TR>
          <TD vAlign=bottom align=left 
          background=#urlPrefix#/images/singleTabbedContentBnLeft.gif 
            height=29><DIV align=center><SPAN 
            class=SmallerCaptionWhite></SPAN>&nbsp;</DIV></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE>
		</div>
		
		</body>
		</html>
	</cfoutput>
</cfif>
