USE [MB4]
GO

/****** Object:  Table [dbo].[Cases]    Script Date: 29.12.2022 16:02:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SfId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AnalysisSfId] [uniqueidentifier] NOT NULL,
	[PrevCaseId] [int] NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[RecCount] [int] NOT NULL,
	[BaseCaseId] [int] NULL,
	[GlobalTest] [float] NULL,
	[IntegralError] [float] NULL,
	[DegreeOfRedundancy] [float] NULL,
 CONSTRAINT [PK_Cases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UX_Cases] UNIQUE NONCLUSTERED 
(
	[SfId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Cases] ADD  CONSTRAINT [DF_Cases_Status]  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [dbo].[Cases] ADD  CONSTRAINT [DF_Cases_RecCount]  DEFAULT ((0)) FOR [RecCount]
GO

ALTER TABLE [dbo].[Cases]  WITH CHECK ADD  CONSTRAINT [FK_Cases_Analyses] FOREIGN KEY([AnalysisSfId])
REFERENCES [dbo].[Analyses] ([SfId])
GO

ALTER TABLE [dbo].[Cases] CHECK CONSTRAINT [FK_Cases_Analyses]
GO

ALTER TABLE [dbo].[Cases]  WITH CHECK ADD  CONSTRAINT [FK_Cases_Cases] FOREIGN KEY([PrevCaseId])
REFERENCES [dbo].[Cases] ([Id])
GO

ALTER TABLE [dbo].[Cases] CHECK CONSTRAINT [FK_Cases_Cases]
GO

ALTER TABLE [dbo].[Cases]  WITH CHECK ADD  CONSTRAINT [CK_Cases_Status] CHECK  (([Status]>=(0) AND [Status]<=(2)))
GO

ALTER TABLE [dbo].[Cases] CHECK CONSTRAINT [CK_Cases_Status]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'SfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор анализа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'AnalysisSfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор предыдущего периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'PrevCaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Начало периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'StartTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Конец периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'EndTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество согласований' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'RecCount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор базового периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cases', @level2type=N'COLUMN',@level2name=N'BaseCaseId'
GO


