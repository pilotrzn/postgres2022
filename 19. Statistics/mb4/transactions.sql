USE [MB4]
GO

/****** Object:  Table [dbo].[Transactions]    Script Date: 29.12.2022 16:12:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Transactions](
	[Id] [int] NOT NULL,
	[CaseId] [int] NOT NULL,
	[Ts] [timestamp] NOT NULL,
	[IsGood] [bit] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[SourceId] [int] NOT NULL,
	[DestId] [int] NOT NULL,
	[ProductId] [int] NULL,
	[SecondProductId] [int] NULL,
	[Measured] [float] NOT NULL,
	[Reconciled] [decimal](26, 6) NOT NULL,
	[Tolerance] [float] NOT NULL,
	[Route] [nvarchar](50) NULL,
	[Car] [int] NULL,
	[IsRecycling] [bit] NULL,
	[SelfCalculatingFlag] [bit] NULL,
	[IsConst] [bit] NULL,
	[CreationType] [int] NULL,
	[AssortmentId] [int] NULL,
	[PrototypeId] [int] NULL,
	[NumRow_OT] [bigint] NULL,
	[CalcMethod] [int] NULL,
	[OrderId] [int] NULL,
	[Lot] [nvarchar](30) NULL,
	[Number] [nvarchar](50) NULL,
	[Shift] [nvarchar](10) NULL,
	[AbsTolerance] [float] NULL,
	[TechnoUpperBound] [float] NULL,
	[TechnoLowerBound] [float] NULL,
	[MetroUpperBound] [float] NULL,
	[MetroLowerBound] [float] NULL,
	[FlowStatus] [int] NULL,
	[ReconciledAbsTolerance] [float] NULL,
	[RecalcType] [bit] NULL,
	[SpecialTransfer] [int] NULL,
	[ExactRounding] [bit] NULL,
	[Redressed] [decimal](26, 6) NULL,
	[Measured_UpperBound] [float] NULL,
	[Measured_LowerBound] [float] NULL,
	[ObjectStatus] [nchar](2) NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[Id] DESC,
	[CaseId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_IsGood]  DEFAULT ((1)) FOR [IsGood]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_MassMeas]  DEFAULT ((0)) FOR [Measured]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_MassRec]  DEFAULT ((0)) FOR [Reconciled]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_Tolerance]  DEFAULT ((0)) FOR [Tolerance]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_IsRecycling]  DEFAULT ((0)) FOR [IsRecycling]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_SelfCalculatingFlag]  DEFAULT ((0)) FOR [SelfCalculatingFlag]
GO

ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF__Transacti__IsCon__02084FDA]  DEFAULT ((0)) FOR [IsConst]
GO

ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Objects] FOREIGN KEY([SourceId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Objects]
GO

ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Objects1] FOREIGN KEY([DestId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Objects1]
GO

ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Objects2] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Objects2]
GO

ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON UPDATE SET NULL
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Orders]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'CaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Ts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия проблем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'IsGood'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время начала' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'StartTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время завершения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'EndTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор источника' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'SourceId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор приемника' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'DestId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'ProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор второго продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'SecondProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Measured'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Согласованная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Reconciled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Допустимая погрешность' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Tolerance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Маршрут' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Route'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг постоянной транзакции' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'IsConst'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Причина создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'CreationType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор ассортимента' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'AssortmentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор прототипа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'PrototypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор метода расчета' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'CalcMethod'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор заказа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'OrderId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions', @level2type=N'COLUMN',@level2name=N'Number'
GO


