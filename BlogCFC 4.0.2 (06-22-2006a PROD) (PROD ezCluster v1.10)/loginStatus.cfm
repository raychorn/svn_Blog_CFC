<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_status" type="string" default="">

<cfoutput>
	<html>
	<head>
		<title>Login Status</title>
		#Request.commonCode.html_nocache()#
		<title>#Replace(application.blog.getProperty("blogCopyright"), "YYYY", Year(Now()))#</title>
		<meta name="robots" content="index,follow" />
		<link rel="stylesheet" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/includes/style.css')#" type="text/css" />
		<link rel="shortcut icon" href="#('http://#CGI.SERVER_NAME#' & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/favicon.ico')#" type="image/x-icon" />
	</head>
	
	<body>
	
		#_status#
		<script language="JavaScript1.2" type="text/javascript">
			if (!!parent.handleSSL_LoginProblems) parent.handleSSL_LoginProblems();
		</script>
	
	</body>
	</html>
</cfoutput>
