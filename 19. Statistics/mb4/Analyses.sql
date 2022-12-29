USE [MB4]
GO

/****** Object:  Table [dbo].[Analyses]    Script Date: 29.12.2022 16:00:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Analyses](
	[SfId] [uniqueidentifier] NOT NULL,
	[ModelSfId] [uniqueidentifier] NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[Type] [int] NOT NULL,
	[DateFormat] [nvarchar](500) NULL,
	[IsDiscretProduction] [bit] NULL,
	[CriterionsInputType] [int] NULL,
	[SortIndex] [int] NULL,
 CONSTRAINT [PK_Analyses] PRIMARY KEY CLUSTERED 
(
	[SfId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Analyses] ADD  CONSTRAINT [DF_Analyses_Type]  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [dbo].[Analyses]  WITH CHECK ADD  CONSTRAINT [FK_Analyses_Models] FOREIGN KEY([ModelSfId])
REFERENCES [dbo].[Models] ([SfId])
GO

ALTER TABLE [dbo].[Analyses] CHECK CONSTRAINT [FK_Analyses_Models]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор в PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'SfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор модели в PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'ModelSfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор типа анализа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'Type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Формат даты' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'DateFormat'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг дискретного производства' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Analyses', @level2type=N'COLUMN',@level2name=N'IsDiscretProduction'
GO


