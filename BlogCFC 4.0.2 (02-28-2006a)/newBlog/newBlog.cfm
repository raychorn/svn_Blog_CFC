<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>newBlog.cfm</title>
</head>

<body>

<b>Make a new blog - for reuse.</b>

<!--- 
	Purpose:
	
		(1). Determine if the new Blog has tables in the Db using the Owner which is the blog name.
		(2). IFF the new blog's tables do not exist then create them by copying the dbo's tables by inspecting the schema programmatically.
		(3). Create the tables for the new blog, if necessary.
		(4). Set the Client.blogname variable with the name of the new blog and then <cflocation> to the index.cfm
		
		Each new blog will be placed in a folder under the root for this application.
		Each new blog's folder will get a copy of the index.cfm that performs the work outlined above.
		The code that performs the work outlined above will reside in a reusable file.
		A GUI interface will be created to allow people to sign-up for blogs of their own.
		Google AdSense channels will be created to track the ads traffic per user's blog.
		User's may pay $1 per month to have Ads removed from their blog space.
		Users's get a 50/50 split from the Google AdSense Revenues that are generated each month, if any.
		User's may pay to get a custom domain name of their own $4.95 using the form of blogname.contentopia.net
		User's may pay to get a domain name of their own $9.95 setup and $2 per month (1 year registration) - ROI is $24.95 - $9.95 = 8 months
 --->

</body>
</html>
