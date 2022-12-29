USE [MB4]
GO

/****** Object:  Table [dbo].[Products]    Script Date: 29.12.2022 16:10:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Products](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[GroupId] [int] NULL,
	[CategoryId] [int] NULL,
	[SortIndex] [int] NOT NULL,
	[ExcludeFromFlowName] [bit] NOT NULL,
	[CanBePassport] [bit] NOT NULL,
	[OutOfBalance] [bit] NOT NULL,
	[OutOfBalanceTceh] [bit] NOT NULL,
	[VolumeCode] [int] NULL,
	[Decomposition] [bit] NULL,
	[ExcludeFromMixing] [bit] NULL,
	[Code] [int] NULL,
	[Sort] [int] NULL,
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreateCaseId] [int] NULL,
	[DeleteCaseId] [int] NULL,
	[DecompositionInNodes] [bit] NULL,
	[MemberOfMixing] [bit] NULL,
	[SAPCode] [nvarchar](20) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_SortNumber]  DEFAULT ((0)) FOR [SortIndex]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_CanBePassport]  DEFAULT ((0)) FOR [CanBePassport]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_OutOfBalance]  DEFAULT ((0)) FOR [OutOfBalance]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_OutOfBalanceTceh]  DEFAULT ((0)) FOR [OutOfBalanceTceh]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_CasesCreate_Products] FOREIGN KEY([CreateCaseId])
REFERENCES [dbo].[Cases] ([Id])
GO

ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_CasesCreate_Products]
GO

ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_CasesDelete_Products] FOREIGN KEY([DeleteCaseId])
REFERENCES [dbo].[Cases] ([Id])
GO

ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_CasesDelete_Products]
GO

ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_ProductCategories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[ProductCategories] ([Id])
GO

ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_ProductCategories]
GO

ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_ProductGroups] FOREIGN KEY([GroupId])
REFERENCES [dbo].[ProductGroups] ([Id])
GO

ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_ProductGroups]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор группы' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'GroupId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор категории' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'CategoryId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Индекс сортировки' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'SortIndex'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг отсутствия имени продукта в названии потока' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'ExcludeFromFlowName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг возможности паспортизации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'CanBePassport'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Признак забалансового учета продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'OutOfBalance'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Признак забалансового учета продукта по цеху' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'OutOfBalanceTceh'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Код объема' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'VolumeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг выделения продукта из смешения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Decomposition'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг замены продукта в смешении' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'ExcludeFromMixing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Код' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Индекс сортировки' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Sort'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор продукта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'ProductId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'флаг удаления' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'CreateCaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода удаления' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'DeleteCaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг замены смесевых продуктов на исходные' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'DecompositionInNodes'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг запрета на разложение цепочек' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'MemberOfMixing'
GO


