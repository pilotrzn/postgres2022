USE [MB4]
GO

/****** Object:  Table [dbo].[Objects]    Script Date: 29.12.2022 16:08:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Objects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SfId] [uniqueidentifier] NOT NULL,
	[ParentId] [int] NULL,
	[Name] [nvarchar](250) NULL,
	[SfName] [nvarchar](250) NULL,
	[ModelSfId] [uniqueidentifier] NOT NULL,
	[TemplateSfId] [uniqueidentifier] NOT NULL,
	[ObjectTypeId] [bigint] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[CreateCaseId] [int] NULL,
	[DeleteCaseId] [int] NULL,
	[GroupId] [int] NULL,
	[IsManuallyCreated] [bit] NOT NULL,
	[RootCategory] [varchar](250) NULL,
	[SubCategory] [varchar](250) NULL,
 CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Objects] ADD  CONSTRAINT [DF_Objects_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Objects] ADD  CONSTRAINT [DF_Objects_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
GO

ALTER TABLE [dbo].[Objects] ADD  CONSTRAINT [DF_Objects_IsManuallyCreated]  DEFAULT ((0)) FOR [IsManuallyCreated]
GO

ALTER TABLE [dbo].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_Cases1] FOREIGN KEY([CreateCaseId])
REFERENCES [dbo].[Cases] ([Id])
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_Cases1]
GO

ALTER TABLE [dbo].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_Cases2] FOREIGN KEY([DeleteCaseId])
REFERENCES [dbo].[Cases] ([Id])
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_Cases2]
GO

ALTER TABLE [dbo].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_Models] FOREIGN KEY([ModelSfId])
REFERENCES [dbo].[Models] ([SfId])
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_Models]
GO

ALTER TABLE [dbo].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_Objects] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_Objects]
GO

ALTER TABLE [dbo].[Objects]  WITH NOCHECK ADD  CONSTRAINT [FK_Objects_ObjectTypes] FOREIGN KEY([ObjectTypeId])
REFERENCES [dbo].[ObjectTypes] ([Id])
ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_ObjectTypes]
GO

ALTER TABLE [dbo].[Objects]  WITH CHECK ADD  CONSTRAINT [FK_Objects_Templates] FOREIGN KEY([TemplateSfId])
REFERENCES [dbo].[Templates] ([SfId])
GO

ALTER TABLE [dbo].[Objects] CHECK CONSTRAINT [FK_Objects_Templates]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор в PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'SfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор родителя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'ParentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наименование в PI AF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'SfName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор модели' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'ModelSfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор шаблона' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'TemplateSfId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор типа объекта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'ObjectTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг удаления' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг видимости' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'IsVisible'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'CreateCaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор периода удаления' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'DeleteCaseId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор группы объектов' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Objects', @level2type=N'COLUMN',@level2name=N'GroupId'
GO


