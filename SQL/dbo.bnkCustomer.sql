USE [AnyDatabaseName]
GO
IF OBJECT_ID('dbo.[DF_bnkCustomer_CustomerTicket]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[bnkCustomer] DROP CONSTRAINT [DF_bnkCustomer_CustomerTicket]
GO
/****** Object:  Table [dbo].[bnkCustomer] - Script Date: 04/27/2018 22:35 ******/
IF OBJECT_ID('dbo.[bnkCustomer]', 'U') IS NOT NULL
  DROP TABLE [dbo].[bnkCustomer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkCustomer](
[CustomerID] [int] IDENTITY(1,1) NOT NULL, 
[CustomerTicket] [uniqueidentifier] ROWGUIDCOL NOT NULL, 
[Name] [varchar] (32) NULL, 
[Address] [varchar] (32) NULL, 
[City] [varchar] (32) NULL, 
[State] [varchar] (32) NULL, 
[ZipCode] [varchar] (12) NULL, 
[TIN] [varchar] (16) NULL,
primary key (CustomerID)
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bnkCustomer] ADD CONSTRAINT [DF_bnkCustomer_CustomerTicket] DEFAULT (newid()) FOR [CustomerTicket]
GO

