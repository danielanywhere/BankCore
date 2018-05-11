USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkEmployee_EmployeeTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkEmployee] DROP CONSTRAINT [DF_bnkEmployee_EmployeeTicket]
GO
/****** Object:  Table [dbo].[bnkEmployee] - Script Date: 04/27/2018 22:35 ******/
IF OBJECT_ID('dbo.[bnkEmployee]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkEmployee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkEmployee](
[EmployeeID] [int] IDENTITY(1,1) NOT NULL, 
[EmployeeTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[FirstName] [varchar] (32) NULL, 
[LastName] [varchar] (32) NULL, 
[DateStarted] [smalldatetime] NULL, 
[DateEnded] [smalldatetime] NULL, 
[Title] [varchar] (32) NULL, 
[TIN] [varchar] (16) NULL,
primary key (EmployeeID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkEmployee] ADD CONSTRAINT [DF_bnkEmployee_EmployeeTicket] DEFAULT (newid()) FOR [EmployeeTicket]
GO

