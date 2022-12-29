USE [MB4]
GO

/****** Object:  Table [dbo].[ObjectTypes]    Script Date: 29.12.2022 16:09:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ObjectTypes](
	[Id] [bigint] NOT NULL,
	[CodeName] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[IsCaseScopedType] [bit] NULL,
 CONSTRAINT [PK_ObjectTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypes] ADD  CONSTRAINT [DF__ObjectTyp__IsCas__6F9F86DC]  DEFAULT ((0)) FOR [IsCaseScopedType]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ObjectTypes', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Кодовое наименование' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ObjectTypes', @level2type=N'COLUMN',@level2name=N'CodeName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ObjectTypes', @level2type=N'COLUMN',@level2name=N'Name'
GO


