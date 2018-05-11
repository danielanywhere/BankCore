USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkBranch_BranchTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkBranch] DROP CONSTRAINT [DF_bnkBranch_BranchTicket]
GO
/****** Object:  Table [dbo].[bnkBranch] - Script Date: 04/27/2018 22:35 ******/
IF OBJECT_ID('dbo.[bnkBranch]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkBranch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkBranch](
[BranchID] [int] IDENTITY(1,1) NOT NULL, 
[BranchTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[Name] [varchar] (32) NULL, 
[Address] [varchar] (32) NULL, 
[City] [varchar] (32) NULL, 
[State] [varchar] (32) NULL, 
[ZipCode] [varchar] (12) NULL,
primary key (BranchID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkBranch] ADD CONSTRAINT [DF_bnkBranch_BranchTicket] DEFAULT (newid()) FOR [BranchTicket]
GO

