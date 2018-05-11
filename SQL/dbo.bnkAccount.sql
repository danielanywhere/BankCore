USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_AccountTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_AccountTicket]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_CustomerID]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_CustomerID]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_BalanceAvailable]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_BalanceAvailable]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_BalancePending]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_BalancePending]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_BranchID]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_BranchID]
GO
IF OBJECT_ID('dbo.[DF_bnkAccount_EmployeeID]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkAccount] DROP CONSTRAINT [DF_bnkAccount_EmployeeID]
GO
/****** Object:  Table [dbo].[bnkAccount] - Script Date: 04/27/2018 22:33 ******/
IF OBJECT_ID('dbo.[bnkAccount]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkAccount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkAccount](
[AccountID] [int] IDENTITY(1,1) NOT NULL, 
[AccountTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[CustomerID] [int] NOT NULL, 
[AccountStatus] [varchar] (10) NULL, 
[BalanceAvailable] [float] NOT NULL, 
[BalancePending] [float] NOT NULL, 
[DateOpened] [smalldatetime] NULL, 
[DateClosed] [smalldatetime] NULL, 
[DateLastActivity] [smalldatetime] NULL, 
[BranchID] [int] NOT NULL, 
[EmployeeID] [int] NOT NULL,
primary key (AccountID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_AccountTicket] DEFAULT (newid()) FOR [AccountTicket]
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_CustomerID] DEFAULT ((0)) FOR [CustomerID]
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_BalanceAvailable] DEFAULT ((0)) FOR [BalanceAvailable]
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_BalancePending] DEFAULT ((0)) FOR [BalancePending]
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_BranchID] DEFAULT ((0)) FOR [BranchID]
GO
ALTER TABLE [dbo].[bnkAccount] ADD CONSTRAINT [DF_bnkAccount_EmployeeID] DEFAULT ((0)) FOR [EmployeeID]
GO

