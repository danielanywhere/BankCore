USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkTransaction_TransactionTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransaction] DROP CONSTRAINT [DF_bnkTransaction_TransactionTicket]
GO
IF OBJECT_ID('dbo.[DF_bnkTransaction_AccountID]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransaction] DROP CONSTRAINT [DF_bnkTransaction_AccountID]
GO
IF OBJECT_ID('dbo.[DF_bnkTransaction_TransactionTypeEnum]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransaction] DROP CONSTRAINT [DF_bnkTransaction_TransactionTypeEnum]
GO
IF OBJECT_ID('dbo.[DF_bnkTransaction_Amount]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkTransaction] DROP CONSTRAINT [DF_bnkTransaction_Amount]
GO
/****** Object:  Table [dbo].[bnkTransaction] - Script Date: 04/27/2018 22:35 ******/
IF OBJECT_ID('dbo.[bnkTransaction]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkTransaction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkTransaction](
[TransactionID] [int] IDENTITY(1,1) NOT NULL, 
[TransactionTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[AccountID] [int] NOT NULL, 
[TransactionTypeEnum] [int] NOT NULL, 
[Amount] [float] NOT NULL, 
[DateTransaction] [smalldatetime] NULL, 
[DateFundsAvailable] [smalldatetime] NULL, 
[RemoteInstitution] [varchar] (32) NULL, 
[RemoteAccount] [varchar] (32) NULL,
primary key (TransactionID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkTransaction] ADD CONSTRAINT [DF_bnkTransaction_TransactionTicket] DEFAULT (newid()) FOR [TransactionTicket]
GO
ALTER TABLE [dbo].[bnkTransaction] ADD CONSTRAINT [DF_bnkTransaction_AccountID] DEFAULT ((0)) FOR [AccountID]
GO
ALTER TABLE [dbo].[bnkTransaction] ADD CONSTRAINT [DF_bnkTransaction_TransactionTypeEnum] DEFAULT ((0)) FOR [TransactionTypeEnum]
GO
ALTER TABLE [dbo].[bnkTransaction] ADD CONSTRAINT [DF_bnkTransaction_Amount] DEFAULT ((0)) FOR [Amount]
GO

