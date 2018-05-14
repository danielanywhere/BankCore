USE [AnyDatabaseName]
GO
/****** Object:  Table [dbo].[bnkTransactionType]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkTransactionType]
GO
/****** Object:  Table [dbo].[bnkTransaction]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkTransaction]
GO
/****** Object:  Table [dbo].[bnkServiceChargeManager]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkServiceChargeManager]
GO
/****** Object:  Table [dbo].[bnkEmployee]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkEmployee]
GO
/****** Object:  Table [dbo].[bnkCustomer]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkCustomer]
GO
/****** Object:  Table [dbo].[bnkBranch]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkBranch]
GO
/****** Object:  Table [dbo].[bnkAccount]    Script Date: 05/12/2018 07:23:54 ******/
DROP TABLE [dbo].[bnkAccount]
GO
/****** Object:  Table [dbo].[bnkAccount]    Script Date: 05/12/2018 07:23:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkAccount](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[AccountTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkAccount_AccountTicket]  DEFAULT (newid()),
	[CustomerID] [int] NOT NULL CONSTRAINT [DF_bnkAccount_CustomerID]  DEFAULT ((0)),
	[AccountStatus] [varchar](10) NULL,
	[BalanceAvailable] [float] NOT NULL CONSTRAINT [DF_bnkAccount_BalanceAvailable]  DEFAULT ((0)),
	[BalancePending] [float] NOT NULL CONSTRAINT [DF_bnkAccount_BalancePending]  DEFAULT ((0)),
	[DateOpened] [smalldatetime] NULL,
	[DateClosed] [smalldatetime] NULL,
	[DateLastActivity] [smalldatetime] NULL,
	[BranchID] [int] NOT NULL CONSTRAINT [DF_bnkAccount_BranchID]  DEFAULT ((0)),
	[EmployeeID] [int] NOT NULL CONSTRAINT [DF_bnkAccount_EmployeeID]  DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkBranch]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkBranch](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[BranchTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkBranch_BranchTicket]  DEFAULT (newid()),
	[Name] [varchar](32) NULL,
	[Address] [varchar](32) NULL,
	[City] [varchar](32) NULL,
	[State] [varchar](32) NULL,
	[ZipCode] [varchar](12) NULL,
PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkCustomer]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkCustomer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkCustomer_CustomerTicket]  DEFAULT (newid()),
	[Name] [varchar](32) NULL,
	[Address] [varchar](32) NULL,
	[City] [varchar](32) NULL,
	[State] [varchar](32) NULL,
	[ZipCode] [varchar](12) NULL,
	[TIN] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkEmployee]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkEmployee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkEmployee_EmployeeTicket]  DEFAULT (newid()),
	[FirstName] [varchar](32) NULL,
	[LastName] [varchar](32) NULL,
	[DateStarted] [smalldatetime] NULL,
	[DateEnded] [smalldatetime] NULL,
	[Title] [varchar](32) NULL,
	[TIN] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkServiceChargeManager]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkServiceChargeManager](
	[ServiceChargeManagerID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceChargeManagerTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkServiceChargeManager_ServiceChargeManagerTicket]  DEFAULT (newid()),
	[AccountID] [int] NOT NULL CONSTRAINT [DF_bnkServiceChargeManager_AccountID]  DEFAULT ((0)),
	[ServiceChargeExpression] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceChargeManagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkTransaction]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkTransaction](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkTransaction_TransactionTicket]  DEFAULT (newid()),
	[AccountID] [int] NOT NULL CONSTRAINT [DF_bnkTransaction_AccountID]  DEFAULT ((0)),
	[TransactionTypeEnum] [int] NOT NULL CONSTRAINT [DF_bnkTransaction_TransactionTypeEnum]  DEFAULT ((0)),
	[Amount] [float] NOT NULL CONSTRAINT [DF_bnkTransaction_Amount]  DEFAULT ((0)),
	[DateTransaction] [smalldatetime] NULL,
	[DateFundsAvailable] [smalldatetime] NULL,
	[RemoteInstitution] [varchar](32) NULL,
	[RemoteAccount] [varchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bnkTransactionType]    Script Date: 05/12/2018 07:23:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bnkTransactionType](
	[TransactionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionTypeTicket] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_bnkTransactionType_TransactionTypeTicket]  DEFAULT (newid()),
	[TransactionTypeEnum] [int] NOT NULL CONSTRAINT [DF_bnkTransactionType_TransactionTypeEnum]  DEFAULT ((0)),
	[TransactionTypeSortIndex] [int] NOT NULL CONSTRAINT [DF_bnkTransactionType_TransactionTypeSortIndex]  DEFAULT ((0)),
	[TransactionTypeName] [varchar](32) NULL,
	[TransactionTypeDescription] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[bnkAccount] ON 

INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (1, N'f94259be-92a2-4dfa-a1f9-1370a341f5f1', 8, N'Active', 4887.54, 4887.54, CAST(N'2001-10-16 00:00:00' AS SmallDateTime), NULL, CAST(N'2017-12-26 00:00:00' AS SmallDateTime), 1, 5)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (2, N'5e33ae21-ba5f-4974-bbc3-8a65cfbbea25', 15, N'Active', 17425.66, 17425.66, CAST(N'1983-03-14 00:00:00' AS SmallDateTime), NULL, CAST(N'1990-01-27 00:00:00' AS SmallDateTime), 4, 2)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (3, N'eca74c94-3148-4da3-8ac2-6a34982f290d', 18, N'Active', 19988.78, 8643.23, CAST(N'1981-07-18 00:00:00' AS SmallDateTime), NULL, CAST(N'1994-11-22 00:00:00' AS SmallDateTime), 4, 4)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (4, N'0ced83d0-464c-4bdd-92ed-7acb8e5155ad', 2, N'Active', 8561.62, 8561.62, CAST(N'2011-01-26 00:00:00' AS SmallDateTime), NULL, CAST(N'2012-02-12 00:00:00' AS SmallDateTime), 1, 4)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (5, N'd3684c78-5b0e-4a22-a687-5d627b85677f', 9, N'Active', 23698.24, 23698.24, CAST(N'1997-07-17 00:00:00' AS SmallDateTime), NULL, CAST(N'2011-09-07 00:00:00' AS SmallDateTime), 1, 2)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (6, N'cb98fce0-ba25-454c-bebc-3c7ee6733961', 5, N'Active', 24205.64, 24205.64, CAST(N'1983-12-20 00:00:00' AS SmallDateTime), NULL, CAST(N'1988-03-20 00:00:00' AS SmallDateTime), 3, 2)
INSERT [dbo].[bnkAccount] ([AccountID], [AccountTicket], [CustomerID], [AccountStatus], [BalanceAvailable], [BalancePending], [DateOpened], [DateClosed], [DateLastActivity], [BranchID], [EmployeeID]) VALUES (7, N'54fde9a0-d45d-4ab3-9b84-7ba92596e71b', 8, N'Active', 852.13, 1310.49, CAST(N'2008-12-14 00:00:00' AS SmallDateTime), NULL, CAST(N'2016-10-07 00:00:00' AS SmallDateTime), 4, 4)
SET IDENTITY_INSERT [dbo].[bnkAccount] OFF
SET IDENTITY_INSERT [dbo].[bnkBranch] ON 

INSERT [dbo].[bnkBranch] ([BranchID], [BranchTicket], [Name], [Address], [City], [State], [ZipCode]) VALUES (1, N'382e9559-3afb-4bdc-99b9-049808578789', N'North', N'4026 Lauren Drive', N'Madison', N'WI', N'53704')
INSERT [dbo].[bnkBranch] ([BranchID], [BranchTicket], [Name], [Address], [City], [State], [ZipCode]) VALUES (2, N'4c13bb4e-4072-41b1-be31-33df7e806470', N'South', N'1250 Buffalo Creek Road', N'Nashville', N'TN', N'37214')
INSERT [dbo].[bnkBranch] ([BranchID], [BranchTicket], [Name], [Address], [City], [State], [ZipCode]) VALUES (3, N'2b0dd67d-0af4-4932-8df0-543e2f9369b4', N'East', N'1104 Jacobs Street', N'Pittsburgh', N'PA', N'15212')
INSERT [dbo].[bnkBranch] ([BranchID], [BranchTicket], [Name], [Address], [City], [State], [ZipCode]) VALUES (4, N'4beee4ee-28d7-494e-8331-9b43313d1c08', N'West', N'3339 Ridenour Street', N'Doral', N'FL', N'33166')
SET IDENTITY_INSERT [dbo].[bnkBranch] OFF
SET IDENTITY_INSERT [dbo].[bnkCustomer] ON 

INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (1, N'6b28522a-d002-4d28-a307-9dbba5cd6286', N'Consolidated Messengers', N'4786 Locust Court', N'Gardena', N'CA', N'90248', N'33-6566647
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (2, N'92fdba50-e929-46c1-a019-8cffe9fae7d6', N'Alpine Ski House', N'523 Redbud Drive', N'New York', N'NY', N'10013', N'90-3818787
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (3, N'feeed429-ab29-41c6-b71a-5d93c4910061', N'Southridge Video', N'2205 Cooks Mine Road', N'Albuquerque', N'NM', N'87102', N'06-1886298
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (4, N'9d0f2962-f1ec-4409-85d7-da79d2fd503c', N'City Power & Light', N'2502 Oak Avenue', N'Schaumburg', N'IL', N'60173', N'19-7270587
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (5, N'2806379a-6145-4357-b7ac-ea208be25581', N'Coho Winery', N'112 West Street', N'Casnovia', N'MI', N'49318', N'79-9418423
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (6, N'e785daac-9c3a-4419-9a81-898108b9253b', N'Wide World Importers', N'3148 Passaic Street', N'Reston', N'DC', N'20191', N'56-2467496
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (7, N'65cdcec2-368a-4b29-a156-0e0bb8fea7ff', N'Graphic Design Institute', N'193 Poling Farm Road', N'Randolph', N'NE', N'68771', N'56-6751685
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (8, N'ed3f3567-85a9-416b-909e-b25955d77e2a', N'Adventure Works', N'211 Farland Avenue', N'Uvalde', N'TX', N'78801', N'39-1309162
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (9, N'924c9bad-f3c9-445c-bdec-c3bf20f15245', N'Humongous Insurance', N'1717 Edgewood Avenue', N'Fresno', N'CA', N'93721', N'40-8819895
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (10, N'19e7e150-8b2a-408d-b0b5-5baa43fd7a09', N'Woodgrove Bank', N'2110 Maple Street', N'Irvine', N'CA', N'92614', N'92-4691264
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (11, N'04ceba25-4680-40bd-83be-9c68217a0e87', N'Margie''s Travel', N'3379 College Street', N'Decatur', N'GA', N'30030', N'18-9269063
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (12, N'9efca023-0ba6-404d-88d9-01061c419656', N'Northwind Traders', N'3850 Elk City Road', N'Indianapolis', N'IN', N'46205', N'87-4224500
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (13, N'200dc2fd-0297-4d59-a429-5044505b4d2e', N'Blue Yonder Airlines', N'33 Trouser Leg Road', N'Shelburne', N'MA', N'01301', N'32-3149379
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (14, N'e802aaff-458a-4346-8e80-8fc25714476c', N'Trey Research', N'707 Bruce Street', N'St. Louis', N'MO', N'63101', N'53-9702721
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (15, N'0dc2939f-551a-4e65-a008-c2a423e39c39', N'The Phone Company', N'1805 Tori Lane', N'Midvale', N'UT', N'84047', N'29-7989701
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (16, N'b5bb0382-32f2-4339-b8f3-3c29ec55568a', N'Wingtip Toys', N'3280 Biddie Lane', N'Hopewell', N'VA', N'23860', N'41-3534687
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (17, N'aef13c51-8c70-4a30-b1b3-3e5bda400e99', N'Lucerne Publishing', N'1336 Stoney Lonesome Road', N'Scranton', N'PA', N'18510', N'94-4071874
')
INSERT [dbo].[bnkCustomer] ([CustomerID], [CustomerTicket], [Name], [Address], [City], [State], [ZipCode], [TIN]) VALUES (18, N'052b2de5-a02b-4dd4-969a-7d16f68ab290', N'Fourth Coffee', N'3288 Finwood Road', N'Freehold', N'NJ', N'07728', N'27-2130193
')
SET IDENTITY_INSERT [dbo].[bnkCustomer] OFF
SET IDENTITY_INSERT [dbo].[bnkEmployee] ON 

INSERT [dbo].[bnkEmployee] ([EmployeeID], [EmployeeTicket], [FirstName], [LastName], [DateStarted], [DateEnded], [Title], [TIN]) VALUES (1, N'0760656e-5790-4615-ae50-3032236aac1d', N'Eva', N'Kilpatrick', CAST(N'2011-12-19 00:00:00' AS SmallDateTime), NULL, N'Teller', N'115-98-6023
')
INSERT [dbo].[bnkEmployee] ([EmployeeID], [EmployeeTicket], [FirstName], [LastName], [DateStarted], [DateEnded], [Title], [TIN]) VALUES (2, N'81b4f116-1080-4e0c-96b5-c2ea781b21c7', N'Joyce', N'Kearney', CAST(N'2014-03-03 00:00:00' AS SmallDateTime), NULL, N'Teller', N'937-46-1306')
INSERT [dbo].[bnkEmployee] ([EmployeeID], [EmployeeTicket], [FirstName], [LastName], [DateStarted], [DateEnded], [Title], [TIN]) VALUES (3, N'907826f3-1ed0-4565-ab95-13ca3c8a36c7', N'Paula', N'Fuller', CAST(N'2010-08-23 00:00:00' AS SmallDateTime), NULL, N'New Accounts', N'281-76-4390')
INSERT [dbo].[bnkEmployee] ([EmployeeID], [EmployeeTicket], [FirstName], [LastName], [DateStarted], [DateEnded], [Title], [TIN]) VALUES (4, N'c9853ce7-5546-4940-8be0-96589595c70c', N'Frank', N'Wozniak', CAST(N'2011-04-08 00:00:00' AS SmallDateTime), NULL, N'New Accounts', N'925-37-2799')
INSERT [dbo].[bnkEmployee] ([EmployeeID], [EmployeeTicket], [FirstName], [LastName], [DateStarted], [DateEnded], [Title], [TIN]) VALUES (5, N'fe833889-725f-4693-bc9b-b2ab2b86b522', N'Donald', N'Crawley', CAST(N'1988-01-25 00:00:00' AS SmallDateTime), NULL, N'Operations Supervisor', N'777-11-9237')
SET IDENTITY_INSERT [dbo].[bnkEmployee] OFF
SET IDENTITY_INSERT [dbo].[bnkServiceChargeManager] ON 

INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (1, N'ce873e13-b05c-4324-879e-8c99153f9da6', 6, N'({v1}*0.27)-({v2}*0.027)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (2, N'76ebfe98-a024-49eb-bde6-c3d8f344b621', 7, N'({v1}*0.03)-({v2}*0.003)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (3, N'c8eb4087-89a3-4a27-b0e1-11b2a5f6d476', 7, N'({v1}*0.88)-({v2}*0.088)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (4, N'27306c87-232f-469a-b100-69a4a8a1ef5a', 4, N'({v1}*0.53)-({v2}*0.053)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (5, N'2b05b659-c17f-45b6-b359-1c2af17a8a96', 5, N'({v1}*0.56)-({v2}*0.056)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (6, N'9c921975-a25a-4723-9ff6-30ee6ca84489', 3, N'({v1}*0.45)-({v2}*0.045)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (7, N'5b8a5d85-9448-478c-aa3b-55068ce5a06c', 2, N'({v1}*0.63)-({v2}*0.063)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (8, N'ed23c380-a8e4-4230-a32e-a0aea8788735', 6, N'({v1}*0.03)-({v2}*0.003)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (9, N'7e6106dd-7237-4332-bacc-e53b24ffdf54', 2, N'({v1}*0.47)-({v2}*0.047)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (10, N'41d92c19-87cd-4ab7-85e7-4d1e56a405bd', 4, N'({v1}*0.00)-({v2}*0.097)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (11, N'db0f8298-68d5-4e60-8cab-ea698a1fe16e', 2, N'({v1}*0.75)-({v2}*0.075)')
INSERT [dbo].[bnkServiceChargeManager] ([ServiceChargeManagerID], [ServiceChargeManagerTicket], [AccountID], [ServiceChargeExpression]) VALUES (12, N'90a42d1c-d81c-462b-a089-2a58ae5e1eda', 1, N'({v1}*0.76)-({v2}*0.076)')
SET IDENTITY_INSERT [dbo].[bnkServiceChargeManager] OFF
SET IDENTITY_INSERT [dbo].[bnkTransaction] ON 

INSERT [dbo].[bnkTransaction] ([TransactionID], [TransactionTicket], [AccountID], [TransactionTypeEnum], [Amount], [DateTransaction], [DateFundsAvailable], [RemoteInstitution], [RemoteAccount]) VALUES (1, N'3fb83d82-3f04-4a94-813f-50b207a29034', 6, 2, 11306.32, CAST(N'2013-09-07 00:00:00' AS SmallDateTime), CAST(N'2013-09-07 00:00:00' AS SmallDateTime), N'Bank of the Best', N'44972')
INSERT [dbo].[bnkTransaction] ([TransactionID], [TransactionTicket], [AccountID], [TransactionTypeEnum], [Amount], [DateTransaction], [DateFundsAvailable], [RemoteInstitution], [RemoteAccount]) VALUES (2, N'2b157ddc-0153-4162-904b-0f6f9cc0eb98', 4, 2, 17413.31, CAST(N'1998-04-23 00:00:00' AS SmallDateTime), CAST(N'1998-04-23 00:00:00' AS SmallDateTime), N'Legion Bank', N'92420')
INSERT [dbo].[bnkTransaction] ([TransactionID], [TransactionTicket], [AccountID], [TransactionTypeEnum], [Amount], [DateTransaction], [DateFundsAvailable], [RemoteInstitution], [RemoteAccount]) VALUES (3, N'0c356039-ee05-4bd7-a828-fef9d8dc1a3f', 2, 2, 9558.14, CAST(N'1988-06-24 00:00:00' AS SmallDateTime), CAST(N'1988-06-24 00:00:00' AS SmallDateTime), N'Omni Bank', N'63077')
INSERT [dbo].[bnkTransaction] ([TransactionID], [TransactionTicket], [AccountID], [TransactionTypeEnum], [Amount], [DateTransaction], [DateFundsAvailable], [RemoteInstitution], [RemoteAccount]) VALUES (4, N'b9ebd756-1f02-4abd-8c93-275f8d4a5d3a', 1, 2, 8751.14, CAST(N'1992-09-20 00:00:00' AS SmallDateTime), CAST(N'1992-09-20 00:00:00' AS SmallDateTime), N'Roadhouse Bank', N'74285')
INSERT [dbo].[bnkTransaction] ([TransactionID], [TransactionTicket], [AccountID], [TransactionTypeEnum], [Amount], [DateTransaction], [DateFundsAvailable], [RemoteInstitution], [RemoteAccount]) VALUES (5, N'03872633-6727-4d60-9f2b-00359af48229', 4, 2, 786.72, CAST(N'1997-06-09 00:00:00' AS SmallDateTime), CAST(N'1997-06-09 00:00:00' AS SmallDateTime), N'Red Baron State Bank', N'88678')
SET IDENTITY_INSERT [dbo].[bnkTransaction] OFF
SET IDENTITY_INSERT [dbo].[bnkTransactionType] ON 

INSERT [dbo].[bnkTransactionType] ([TransactionTypeID], [TransactionTypeTicket], [TransactionTypeEnum], [TransactionTypeSortIndex], [TransactionTypeName], [TransactionTypeDescription]) VALUES (1, N'f8dc94d7-dc76-4908-84aa-1dcde01cfeb8', 0, 0, N'None', N'Unknown or no type defined.')
INSERT [dbo].[bnkTransactionType] ([TransactionTypeID], [TransactionTypeTicket], [TransactionTypeEnum], [TransactionTypeSortIndex], [TransactionTypeName], [TransactionTypeDescription]) VALUES (2, N'5078f3b7-f0db-4f83-ae13-44c468db2f7d', 1, 1, N'Cash', N'Cash Deposit or Withdrawal.')
INSERT [dbo].[bnkTransactionType] ([TransactionTypeID], [TransactionTypeTicket], [TransactionTypeEnum], [TransactionTypeSortIndex], [TransactionTypeName], [TransactionTypeDescription]) VALUES (3, N'd3be1ba3-d265-412d-95de-8fa874bc8709', 2, 2, N'CheckOut', N'Check ONUS.')
INSERT [dbo].[bnkTransactionType] ([TransactionTypeID], [TransactionTypeTicket], [TransactionTypeEnum], [TransactionTypeSortIndex], [TransactionTypeName], [TransactionTypeDescription]) VALUES (4, N'2c253a85-b9aa-4442-b7a1-7512f71fa50d', 3, 3, N'CheckIn', N'Check Deposited on other institution.')
SET IDENTITY_INSERT [dbo].[bnkTransactionType] OFF
