IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Administrator')
EXEC sys.sp_executesql N'CREATE SCHEMA [Administrator] AUTHORIZATION [Administrator]'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogSubscribers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogSubscribers](
	[email] [nvarchar](50) NOT NULL,
	[token] [nvarchar](35) NOT NULL,
	[blog] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogTrackBacks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogTrackBacks](
	[id] [nvarchar](35) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[blogname] [nvarchar](255) NOT NULL,
	[posturl] [nvarchar](255) NOT NULL,
	[excerpt] [ntext] NOT NULL,
	[created] [datetime] NOT NULL,
	[entryid] [nvarchar](35) NOT NULL,
	[blog] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblTrackBacks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblUsers](
	[username] [nvarchar](50) NULL,
	[uName] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblDownloads]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblDownloads](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fName] [nvarchar](255) NOT NULL,
	[descText] [nvarchar](255) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogCategories](
	[categoryid] [nvarchar](35) NOT NULL,
	[categoryname] [nvarchar](50) NULL,
	[blog] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblBlogCategories] PRIMARY KEY CLUSTERED 
(
	[categoryid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogComments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogComments](
	[id] [nvarchar](35) NOT NULL,
	[entryidfk] [nvarchar](35) NOT NULL,
	[name] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[website] [nvarchar](255) NULL,
	[comment] [ntext] NULL,
	[posted] [datetime] NULL,
	[subscribe] [bit] NULL CONSTRAINT [DF_tblBlogComments_subscribe]  DEFAULT ((0)),
 CONSTRAINT [PK_tblBlogComments] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogEntries]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogEntries](
	[id] [nvarchar](35) NOT NULL,
	[title] [nvarchar](100) NULL,
	[body] [ntext] NULL,
	[posted] [datetime] NULL,
	[morebody] [ntext] NULL,
	[alias] [nvarchar](100) NULL,
	[username] [nvarchar](100) NULL,
	[blog] [nvarchar](50) NOT NULL,
	[allowcomments] [bit] NULL CONSTRAINT [DF_tblBlogEntries_allowcomments]  DEFAULT ((1)),
	[enclosure] [nvarchar](255) NULL,
	[filesize] [numeric](18, 0) NULL,
	[mimetype] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblBlogEntries] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogEntriesCategories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogEntriesCategories](
	[categoryidfk] [nvarchar](35) NOT NULL,
	[entryidfk] [nvarchar](35) NOT NULL,
 CONSTRAINT [PK_tblBlogEntriesCategories] PRIMARY KEY CLUSTERED 
(
	[categoryidfk] ASC,
	[entryidfk] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblBlogSearchStats]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblBlogSearchStats](
	[searchterm] [nvarchar](255) NOT NULL,
	[searched] [datetime] NOT NULL,
	[blog] [nvarchar](50) NOT NULL
) ON [PRIMARY]
END
