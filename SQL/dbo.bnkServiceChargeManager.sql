USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkServiceChargeManager_ServiceChargeManagerTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkServiceChargeManager] DROP CONSTRAINT [DF_bnkServiceChargeManager_ServiceChargeManagerTicket]
GO
IF OBJECT_ID('dbo.[DF_bnkServiceChargeManager_AccountID]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkServiceChargeManager] DROP CONSTRAINT [DF_bnkServiceChargeManager_AccountID]
GO
/****** Object:  Table [dbo].[bnkServiceChargeManager] - Script Date: 04/28/2018 08:01 ******/
IF OBJECT_ID('dbo.[bnkServiceChargeManager]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkServiceChargeManager]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkServiceChargeManager](
[ServiceChargeManagerID] [int] IDENTITY(1,1) NOT NULL, 
[ServiceChargeManagerTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[AccountID] [int] NOT NULL, 
[ServiceChargeExpression] [varchar] (255) NULL,
primary key (ServiceChargeManagerID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkServiceChargeManager] ADD CONSTRAINT [DF_bnkServiceChargeManager_ServiceChargeManagerTicket] DEFAULT (newid()) FOR [ServiceChargeManagerTicket]
GO
ALTER TABLE [dbo].[bnkServiceChargeManager] ADD CONSTRAINT [DF_bnkServiceChargeManager_AccountID] DEFAULT ((0)) FOR [AccountID]
GO

