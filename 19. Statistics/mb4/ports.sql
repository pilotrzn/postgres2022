USE [MB4]
GO

/****** Object:  Table [dbo].[Ports]    Script Date: 29.12.2022 16:09:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Ports](
	[Id] [int] NOT NULL,
	[UnitId] [int] NOT NULL,
	[FlowId] [int] NOT NULL,
	[IsInput] [int] NOT NULL,
	[ConnectionObjId] [int] NULL,
 CONSTRAINT [PK_Ports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Ports]  WITH CHECK ADD  CONSTRAINT [FK_Ports_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Ports] CHECK CONSTRAINT [FK_Ports_Objects]
GO

ALTER TABLE [dbo].[Ports]  WITH CHECK ADD  CONSTRAINT [FK_Ports_Objects1] FOREIGN KEY([UnitId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Ports] CHECK CONSTRAINT [FK_Ports_Objects1]
GO

ALTER TABLE [dbo].[Ports]  WITH CHECK ADD  CONSTRAINT [FK_Ports_Objects2] FOREIGN KEY([FlowId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[Ports] CHECK CONSTRAINT [FK_Ports_Objects2]
GO

ALTER TABLE [dbo].[Ports]  WITH CHECK ADD  CONSTRAINT [CK_Ports] CHECK  (([IsInput]=(0) OR [IsInput]=(1)))
GO

ALTER TABLE [dbo].[Ports] CHECK CONSTRAINT [CK_Ports]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ports', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор установки' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ports', @level2type=N'COLUMN',@level2name=N'UnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор потока' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ports', @level2type=N'COLUMN',@level2name=N'FlowId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Флаг входа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ports', @level2type=N'COLUMN',@level2name=N'IsInput'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор соединения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ports', @level2type=N'COLUMN',@level2name=N'ConnectionObjId'
GO


