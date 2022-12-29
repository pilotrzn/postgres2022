USE [MB4]
GO

/****** Object:  Table [dbo].[MetersVar]    Script Date: 29.12.2022 16:05:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MetersVar](
	[Id] [int] NOT NULL,
	[CaseId] [int] NOT NULL,
	[Ts] [timestamp] NOT NULL,
	[IsGood] [bit] NULL,
	[Measured] [float] NULL,
	[Tolerance] [float] NULL,
	[AbsTolerance] [float] NULL,
	[Color] [nvarchar](20) NULL,
	[ObjectStatus] [nchar](2) NULL,
	[Comment] [nvarchar](250) NULL,
	[MeasuredVolume] [float] NULL,
	[MetroUpperBound] [float] NULL,
	[MetroLowerBound] [float] NULL,
	[AI_RelativeTolerance] [float] NULL,
	[MeasuredShipped] [float] NULL,
	[MeasuredUnexecuted] [float] NULL,
	[BackgroundColor] [nvarchar](50) NULL,
	[AI_Tag1] [int] NULL,
	[Measured_UpperBound] [float] NULL,
	[Measured_LowerBound] [float] NULL,
	[flowDependence] [nvarchar](250) NULL,
	[MeasuredMassLoss] [float] NULL,
	[LossNorm] [float] NULL,
	[MeasuredMassSSoT] [float] NULL,
	[ObjectStatusDigital] [float] NULL,
	[MeasuredCum] [float] NULL,
	[TechnoLowerBound] [float] NULL,
	[TechnoUpperBound] [float] NULL,
 CONSTRAINT [PK_MetersVar] PRIMARY KEY CLUSTERED 
(
	[Id] DESC,
	[CaseId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MetersVar] ADD  CONSTRAINT [DF_MetersVar_IsGood]  DEFAULT ((1)) FOR [IsGood]
GO

ALTER TABLE [dbo].[MetersVar] ADD  CONSTRAINT [DF_MetersVar_MassMeas]  DEFAULT ((0)) FOR [Measured]
GO

ALTER TABLE [dbo].[MetersVar] ADD  CONSTRAINT [DF_MetersVar_Tolerance]  DEFAULT ((0)) FOR [Tolerance]
GO

ALTER TABLE [dbo].[MetersVar]  WITH CHECK ADD  CONSTRAINT [FK_MetersVar_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[MetersVar] CHECK CONSTRAINT [FK_MetersVar_Objects]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'CaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Ts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия проблем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'IsGood'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренная масса' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Measured'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Допустимое отклонение' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Tolerance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Цвет' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Color'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Статус объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'Comment'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Измеренный объем' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MetersVar', @level2type=N'COLUMN',@level2name=N'MeasuredVolume'
GO


