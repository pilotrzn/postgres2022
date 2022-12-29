USE [MB4]
GO

/****** Object:  Table [dbo].[NodesVar]    Script Date: 29.12.2022 16:06:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NodesVar](
	[Id] [int] NOT NULL,
	[CaseId] [int] NOT NULL,
	[Ts] [timestamp] NOT NULL,
	[IsGood] [bit] NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[IsMixing] [bit] NOT NULL,
	[ObjectStatus] [nchar](2) NULL,
	[CheckProdBalance] [bit] NULL,
	[NotPermittedFlows] [bit] NULL,
	[MinLoss] [float] NULL,
	[MaxLoss] [float] NULL,
	[RecImbalance] [float] NULL,
	[ExcessiveLosses] [bit] NULL,
	[AI_InMeasured] [float] NULL,
	[AI_OutMeasured] [float] NULL,
	[RootCategory] [varchar](250) NULL,
	[SubCategory] [varchar](250) NULL,
 CONSTRAINT [PK_NodesVar] PRIMARY KEY CLUSTERED 
(
	[Id] DESC,
	[CaseId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[NodesVar] ADD  CONSTRAINT [DF_NodesVar_IsGood]  DEFAULT ((1)) FOR [IsGood]
GO

ALTER TABLE [dbo].[NodesVar] ADD  CONSTRAINT [DF_NodesVar_IsBalanceNode]  DEFAULT ((0)) FOR [IsVisible]
GO

ALTER TABLE [dbo].[NodesVar] ADD  CONSTRAINT [DF_NodesVar_IsMixing]  DEFAULT ((0)) FOR [IsMixing]
GO

ALTER TABLE [dbo].[NodesVar]  WITH CHECK ADD  CONSTRAINT [FK_NodesVar_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[NodesVar] CHECK CONSTRAINT [FK_NodesVar_Objects]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'CaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'Ts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия проблем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'IsGood'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг видимости' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'IsVisible'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг смешения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'IsMixing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NodesVar', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


