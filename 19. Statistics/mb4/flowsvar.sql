USE [MB4]
GO

/****** Object:  Table [dbo].[FlowsVar]    Script Date: 29.12.2022 16:04:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FlowsVar](
	[Id] [int] NOT NULL,
	[CaseId] [int] NOT NULL,
	[Ts] [timestamp] NOT NULL,
	[IsGood] [bit] NOT NULL,
	[Reconciled] [decimal](26, 6) NOT NULL,
	[SourceMinNorm] [float] NULL,
	[SourceMaxNorm] [float] NULL,
	[SourceRecNorm] [float] NULL,
	[DestMinNorm] [float] NULL,
	[DestMaxNorm] [float] NULL,
	[DestRecNorm] [float] NULL,
	[AI_SRFlow] [float] NULL,
	[ProductId] [int] NULL,
	[ObjectStatus] [nchar](10) NULL,
	[AI_IsImbalance] [bit] NULL,
	[TechnoUpperBound] [float] NULL,
	[TechnoLowerBound] [float] NULL,
	[FlowStatus] [int] NULL,
	[ReconciledAbsTolerance] [float] NULL,
	[Exactrounding] [bit] NULL,
	[SecondProductId] [int] NULL,
	[Redressed] [decimal](26, 6) NULL,
	[ProductForReport] [nvarchar](50) NULL,
	[Improvement] [float] NULL,
	[SAPCode] [nvarchar](50) NULL,
	[TagName] [nchar](100) NULL,
 CONSTRAINT [PK_FlowsVar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[CaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FlowsVar] ADD  CONSTRAINT [DF_FlowsVar_IsGood]  DEFAULT ((1)) FOR [IsGood]
GO

ALTER TABLE [dbo].[FlowsVar] ADD  CONSTRAINT [DF_FlowsVar_MassRec]  DEFAULT ((0)) FOR [Reconciled]
GO

ALTER TABLE [dbo].[FlowsVar]  WITH CHECK ADD  CONSTRAINT [FK_FlowsVar_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[FlowsVar] CHECK CONSTRAINT [FK_FlowsVar_Objects]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'CaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'Ts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия проблем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'IsGood'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Согласованная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'Reconciled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'ProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsVar', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


