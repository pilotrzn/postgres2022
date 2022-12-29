USE [MB4]
GO

/****** Object:  Table [dbo].[FlowsMeters]    Script Date: 29.12.2022 16:03:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FlowsMeters](
	[Id] [int] NOT NULL,
	[FlowId] [int] NULL,
	[MeterId] [int] NULL,
 CONSTRAINT [PK_FlowsMeters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FlowsMeters]  WITH CHECK ADD  CONSTRAINT [FK_FlowsMeters_Objects] FOREIGN KEY([Id])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[FlowsMeters] CHECK CONSTRAINT [FK_FlowsMeters_Objects]
GO

ALTER TABLE [dbo].[FlowsMeters]  WITH CHECK ADD  CONSTRAINT [FK_FlowsMeters_Objects1] FOREIGN KEY([FlowId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[FlowsMeters] CHECK CONSTRAINT [FK_FlowsMeters_Objects1]
GO

ALTER TABLE [dbo].[FlowsMeters]  WITH CHECK ADD  CONSTRAINT [FK_FlowsMeters_Objects2] FOREIGN KEY([MeterId])
REFERENCES [dbo].[Objects] ([Id])
GO

ALTER TABLE [dbo].[FlowsMeters] CHECK CONSTRAINT [FK_FlowsMeters_Objects2]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsMeters', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор потока' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsMeters', @level2type=N'COLUMN',@level2name=N'FlowId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор измерителя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FlowsMeters', @level2type=N'COLUMN',@level2name=N'MeterId'
GO


