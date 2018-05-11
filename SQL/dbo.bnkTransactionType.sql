USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkTransactionType_TransactionTypeTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransactionType] DROP CONSTRAINT [DF_bnkTransactionType_TransactionTypeTicket]
GO
IF OBJECT_ID('dbo.[DF_bnkTransactionType_TransactionTypeEnum]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransactionType] DROP CONSTRAINT [DF_bnkTransactionType_TransactionTypeEnum]
GO
IF OBJECT_ID('dbo.[DF_bnkTransactionType_TransactionTypeSortIndex]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransactionType] DROP CONSTRAINT [DF_bnkTransactionType_TransactionTypeSortIndex]
GO
/****** Object:  Table [dbo].[bnkTransactionType] - Script Date: 04/27/2018 23:23 ******/
IF OBJECT_ID('dbo.[bnkTransactionType]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkTransactionType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkTransactionType](
[TransactionTypeID] [int] IDENTITY(1,1) NOT NULL, 
[TransactionTypeTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[TransactionTypeEnum] [int] NOT NULL, 
[TransactionTypeSortIndex] [int] NOT NULL, 
[TransactionTypeName] [varchar] (32) NULL, 
[TransactionTypeDescription] [varchar] (255) NULL,
primary key (TransactionTypeID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkTransactionType] ADD CONSTRAINT [DF_bnkTransactionType_TransactionTypeTicket] DEFAULT (newid()) FOR [TransactionTypeTicket]
GO
ALTER TABLE [dbo].[bnkTransactionType] ADD CONSTRAINT [DF_bnkTransactionType_TransactionTypeEnum] DEFAULT ((0)) FOR [TransactionTypeEnum]
GO
ALTER TABLE [dbo].[bnkTransactionType] ADD CONSTRAINT [DF_bnkTransactionType_TransactionTypeSortIndex] DEFAULT ((0)) FOR [TransactionTypeSortIndex]
GO

