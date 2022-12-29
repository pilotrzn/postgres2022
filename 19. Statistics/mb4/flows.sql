USE [MB4]
GO

/****** Object:  Table [dbo].[Flows]    Script Date: 29.12.2022 16:03:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Flows](
	[Id] [int] NOT NULL,
	[MeterId] [int] NULL,
	[ProductId] [int] NULL,
	[SourceId] [int] NULL,
	[DestId] [int] NULL,
	[SecondProductId] [int] NULL,
 CONSTRAINT [PK_Flows] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Flows] ADD  CONSTRAINT [DF__Flows__SourceId__6CA31EA0]  DEFAULT ((0)) FOR [SourceId]
GO

ALTER TABLE [dbo].[Flows] ADD  CONSTRAINT [DF__Flows__DestId__6D9742D9]  DEFAULT ((0)) FOR [DestId]
GO

ALTER TABLE [dbo].[Flows]  WITH CHECK ADD  CONSTRAINT [FK_Flows_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Flows] CHECK CONSTRAINT [FK_Flows_Objects]
GO

ALTER TABLE [dbo].[Flows]  WITH CHECK ADD  CONSTRAINT [FK_Flows_Objects1] FOREIGN KEY([MeterId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Flows] CHECK CONSTRAINT [FK_Flows_Objects1]
GO

ALTER TABLE [dbo].[Flows]  WITH CHECK ADD  CONSTRAINT [FK_Flows_Objects2] FOREIGN KEY([SourceId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Flows] CHECK CONSTRAINT [FK_Flows_Objects2]
GO

ALTER TABLE [dbo].[Flows]  WITH CHECK ADD  CONSTRAINT [FK_Flows_Objects3] FOREIGN KEY([DestId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Flows] CHECK CONSTRAINT [FK_Flows_Objects3]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор измерителя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'MeterId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'ProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор источника' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'SourceId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор приемника' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'DestId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор второго продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Flows', @level2type=N'COLUMN',@level2name=N'SecondProductId'
GO


