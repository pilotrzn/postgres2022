USE [MB4]
GO

/****** Object:  Table [ext].[Material]    Script Date: 29.12.2022 16:12:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ext].[Material](
	[Id] [int] NULL,
	[SAPCode] [nvarchar](20) NULL,
	[Name] [nvarchar](250) NULL,
	[Material Group] [nvarchar](250) NULL,
	[Material Category] [nvarchar](250) NULL,
	[Report Category] [nvarchar](250) NULL,
	[Report CategoryType] [nvarchar](250) NULL,
	[AUTO] [varchar](50) NULL,
	[ZHD] [varchar](50) NULL,
	[PIPE] [varchar](50) NULL,
	[Sorting Index] [int] NULL
) ON [PRIMARY]
GO


