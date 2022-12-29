USE [MB4]
GO

/****** Object:  Table [dbo].[TanksVar]    Script Date: 29.12.2022 16:10:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TanksVar](
	[Id] [int] NOT NULL,
	[CaseId] [int] NOT NULL,
	[Ts] [timestamp] NOT NULL,
	[IsGood] [bit] NOT NULL,
	[ProductId] [int] NULL,
	[Measured] [float] NOT NULL,
	[Reconciled] [decimal](26, 6) NOT NULL,
	[Tolerance] [float] NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[PassportState] [nvarchar](50) NULL,
	[HasVirtual] [bit] NOT NULL,
	[VirtualMass]  AS (((((((((isnull([VirtualMass1],(0))+isnull([VirtualMass2],(0)))+isnull([VirtualMass3],(0)))+isnull([VirtualMass4],(0)))+isnull([VirtualMass5],(0)))+isnull([VirtualMass6],(0)))+isnull([VirtualMass7],(0)))+isnull([VirtualMass8],(0)))+isnull([VirtualMass9],(0)))+isnull([VirtualMass10],(0))),
	[AI_Info01] [float] NULL,
	[AI_Info02] [float] NULL,
	[AI_Info03] [float] NULL,
	[AI_Info04] [float] NULL,
	[AI_Info05] [float] NULL,
	[AI_Info06] [float] NULL,
	[AI_Info07] [float] NULL,
	[AI_Info08] [float] NULL,
	[AI_Info09] [float] NULL,
	[AI_Info10] [float] NULL,
	[AI_Info11] [float] NULL,
	[AI_Info12] [float] NULL,
	[AI_Info13] [int] NULL,
	[AI_Info14] [nvarchar](10) NULL,
	[AI_Info15] [float] NULL,
	[ObjectStatus] [nchar](2) NULL,
	[AI_BeforeMeasuredMass] [float] NULL,
	[AI_Info16] [float] NULL,
	[AI_RelativeTolerance] [float] NULL,
	[AI_Info17] [float] NULL,
	[AI_Info18] [float] NULL,
	[AI_Info19] [float] NULL,
	[AI_Info20] [nvarchar](50) NULL,
	[AI_Info21] [float] NULL,
	[AI_Info22] [float] NULL,
	[AI_Info23] [float] NULL,
	[AI_Info24] [float] NULL,
	[NachMass] [float] NOT NULL,
	[AI_MeasuredMass] [float] NULL,
	[VirtualProductId1] [int] NULL,
	[VirtualMass1] [float] NULL,
	[VirtualProductId2] [int] NULL,
	[VirtualMass2] [float] NULL,
	[VirtualProductId3] [int] NULL,
	[VirtualMass3] [float] NULL,
	[VirtualProductId4] [int] NULL,
	[VirtualMass4] [float] NULL,
	[VirtualProductId5] [int] NULL,
	[VirtualMass5] [float] NULL,
	[VirtualProductId6] [int] NULL,
	[VirtualMass6] [float] NULL,
	[VirtualProductId7] [int] NULL,
	[VirtualMass7] [float] NULL,
	[VirtualProductId8] [int] NULL,
	[VirtualMass8] [float] NULL,
	[VirtualProductId9] [int] NULL,
	[VirtualMass9] [float] NULL,
	[VirtualProductId10] [int] NULL,
	[VirtualMass10] [float] NULL,
	[Comment] [nvarchar](250) NULL,
	[MeasuredVolume] [float] NULL,
	[IsSystemCategory] [nvarchar](250) NULL,
	[NachProductId] [int] NULL,
	[AbsTolerance] [float] NULL,
	[TechnoUpperBound] [float] NULL,
	[TechnoLowerBound] [float] NULL,
	[MetroUpperBound] [float] NULL,
	[MetroLowerBound] [float] NULL,
	[FlowStatus] [int] NULL,
	[ReconciledAbsTolerance] [float] NULL,
	[CheckProdBalance] [bit] NULL,
	[IsMeasured] [bit] NULL,
	[Grouping] [nvarchar](250) NULL,
	[NotPermittedFlows] [bit] NULL,
	[FirstStruct] [int] NULL,
	[SecondStruct] [int] NULL,
	[ThirdStruct] [int] NULL,
	[ExactRounding] [bit] NULL,
	[Redressed] [decimal](26, 6) NULL,
	[Measured_UpperBound] [float] NULL,
	[Measured_LowerBound] [float] NULL,
	[MaximumVolume] [float] NULL,
	[Density] [float] NULL,
	[GetMass] [float] NULL,
	[PDD] [float] NULL,
	[RecImbalance] [float] NULL,
	[MinLoss] [float] NULL,
	[MaxLoss] [float] NULL,
	[ExcessiveLosses] [bit] NULL,
	[ToleranceForTank] [float] NULL,
	[MapTable] [varchar](50) NULL,
	[BallastPercent] [float] NULL,
	[RootCategory] [varchar](250) NULL,
	[SubCategory] [varchar](250) NULL,
	[ObjectStatusDig] [float] NULL,
	[ObjectStatusDigMonth] [float] NULL,
	[ObjectStatusMonth] [nchar](2) NULL,
	[MeasuredMassTag] [float] NULL,
 CONSTRAINT [PK_TanksVar] PRIMARY KEY CLUSTERED 
(
	[Id] DESC,
	[CaseId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_IsGood]  DEFAULT ((1)) FOR [IsGood]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_MassMeas]  DEFAULT ((0)) FOR [Measured]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_MassRec]  DEFAULT ((0)) FOR [Reconciled]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_Tolerance]  DEFAULT ((0)) FOR [Tolerance]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_HasVirtual]  DEFAULT ((0)) FOR [HasVirtual]
GO

ALTER TABLE [dbo].[TanksVar] ADD  CONSTRAINT [DF_TanksVar_NachMass_1]  DEFAULT ((0)) FOR [NachMass]
GO

ALTER TABLE [dbo].[TanksVar]  WITH CHECK ADD  CONSTRAINT [FK_TanksVar_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[TanksVar] CHECK CONSTRAINT [FK_TanksVar_Objects]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'CaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Ts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия проблем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'IsGood'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'ProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Measured'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Согласованная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Reconciled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Допустимое отклонение' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Tolerance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный флаг ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'IsSystem'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус паспорта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'PassportState'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг виртуальности' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'HasVirtual'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info01'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info02'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info03'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info04'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info05'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info06'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info07'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info08'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info09'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info11'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info12'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info13'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info14'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info15'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 16' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info16'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info17'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 18' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info18'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 19' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info19'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 20' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info20'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 21' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info21'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 22' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info22'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 23' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info23'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Информация 24' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_Info24'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Начальная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'NachMass'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренная масса в PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'AI_MeasuredMass'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass3'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass4'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass5'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId6'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass6'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId7'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass7'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId8'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass8'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId9'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass9'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальный продукт 10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualProductId10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Виртуальная масса 10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'VirtualMass10'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'Comment'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренный объем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'MeasuredVolume'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системная категория' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'IsSystemCategory'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор начального продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TanksVar', @level2type=N'COLUMN',@level2name=N'NachProductId'
GO


