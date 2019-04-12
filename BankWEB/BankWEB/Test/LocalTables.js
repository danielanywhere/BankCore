var bnkAccount = [{
 AccountID : 1,
 AccountTicket : "F94259BE-92A2-4DFA-A1F9-1370A341F5F1",
 CustomerID : 8,
 AccountStatus : "Active",
 BalanceAvailable : 4887.54,
 BalancePending : 4887.54,
 DateOpened : "10/16/2001",
 DateClosed : null,
 DateLastActivity : "12/26/2017",
 BranchID : 1,
 EmployeeID : 5
}, {
 AccountID : 2,
 AccountTicket : "5E33AE21-BA5F-4974-BBC3-8A65CFBBEA25",
 CustomerID : 15,
 AccountStatus : "Active",
 BalanceAvailable : 17425.66,
 BalancePending : 17425.66,
 DateOpened : "03/14/1983",
 DateClosed : null,
 DateLastActivity : "01/27/1990",
 BranchID : 4,
 EmployeeID : 2
}, {
 AccountID : 3,
 AccountTicket : "ECA74C94-3148-4DA3-8AC2-6A34982F290D",
 CustomerID : 18,
 AccountStatus : "Active",
 BalanceAvailable : 19988.78,
 BalancePending : 8643.23,
 DateOpened : "07/18/1981",
 DateClosed : null,
 DateLastActivity : "11/22/1994",
 BranchID : 4,
 EmployeeID : 4
}, {
 AccountID : 4,
 AccountTicket : "0CED83D0-464C-4BDD-92ED-7ACB8E5155AD",
 CustomerID : 2,
 AccountStatus : "Active",
 BalanceAvailable : 8561.62,
 BalancePending : 8561.62,
 DateOpened : "01/26/2011",
 DateClosed : null,
 DateLastActivity : "02/12/2012",
 BranchID : 1,
 EmployeeID : 4
}, {
 AccountID : 5,
 AccountTicket : "D3684C78-5B0E-4A22-A687-5D627B85677F",
 CustomerID : 9,
 AccountStatus : "Active",
 BalanceAvailable : 23698.24,
 BalancePending : 23698.24,
 DateOpened : "07/17/1997",
 DateClosed : null,
 DateLastActivity : "09/07/2011",
 BranchID : 1,
 EmployeeID : 2
}, {
 AccountID : 6,
 AccountTicket : "CB98FCE0-BA25-454C-BEBC-3C7EE6733961",
 CustomerID : 5,
 AccountStatus : "Active",
 BalanceAvailable : 24205.64,
 BalancePending : 24205.64,
 DateOpened : "12/20/1983",
 DateClosed : null,
 DateLastActivity : "03/20/1988",
 BranchID : 3,
 EmployeeID : 2
}, {
 AccountID : 7,
 AccountTicket : "54FDE9A0-D45D-4AB3-9B84-7BA92596E71B",
 CustomerID : 8,
 AccountStatus : "Active",
 BalanceAvailable : 852.13,
 BalancePending : 1310.49,
 DateOpened : "12/14/2008",
 DateClosed : null,
 DateLastActivity : "10/07/2016",
 BranchID : 4,
 EmployeeID : 4
}];

var bnkBranch = [{
 BranchID : 1,
 BranchTicket : "382E9559-3AFB-4BDC-99B9-049808578789",
 Name : "North",
 Address : "4026 Lauren Drive",
 City : "Madison",
 State : "WI",
 ZipCode : 53704
}, {
 BranchID : 2,
 BranchTicket : "4C13BB4E-4072-41B1-BE31-33DF7E806470",
 Name : "South",
 Address : "1250 Buffalo Creek Road",
 City : "Nashville",
 State : "TN",
 ZipCode : 37214
}, {
 BranchID : 3,
 BranchTicket : "2B0DD67D-0AF4-4932-8DF0-543E2F9369B4",
 Name : "East",
 Address : "1104 Jacobs Street",
 City : "Pittsburgh",
 State : "PA",
 ZipCode : 15212
}, {
 BranchID : 4,
 BranchTicket : "4BEEE4EE-28D7-494E-8331-9B43313D1C08",
 Name : "West",
 Address : "3339 Ridenour Street",
 City : "Doral",
 State : "FL",
 ZipCode : 33166
}];

var bnkCustomer = [{
 CustomerID : 1,
 CustomerTicket : "6B28522A-D002-4D28-A307-9DBBA5CD6286",
 Name : "Consolidated Messenger",
 Address : "4786 Locust Court",
 City : "Fresno",
 State : "CA",
 ZipCode : 90248,
 TIN : 33-6566647
}, {
 CustomerID : 2,
 CustomerTicket : "92FDBA50-E929-46C1-A019-8CFFE9FAE7D6",
 Name : "Alpine Ski House",
 Address : "523 Redbud Drive",
 City : "New York",
 State : "NY",
 ZipCode : 10013,
 TIN : 90-3818787
}, {
 CustomerID : 3,
 CustomerTicket : "FEEED429-AB29-41C6-B71A-5D93C4910061",
 Name : "Southridge Video",
 Address : "2205 Cooks Mine Road",
 City : "Albuquerque",
 State : "NM",
 ZipCode : 87102,
 TIN : 06-1886298
}, {
 CustomerID : 4,
 CustomerTicket : "9D0F2962-F1EC-4409-85D7-DA79D2FD503C",
 Name : "City Power & Light",
 Address : "2502 Oak Avenue",
 City : "Schaumburg",
 State : "IL",
 ZipCode : 60173,
 TIN : 19-7270587
}, {
 CustomerID : 5,
 CustomerTicket : "2806379A-6145-4357-B7AC-EA208BE25581",
 Name : "Coho Winery",
 Address : "112 West Street",
 City : "Casnovia",
 State : "MI",
 ZipCode : 49318,
 TIN : 79-9418423
}, {
 CustomerID : 6,
 CustomerTicket : "E785DAAC-9C3A-4419-9A81-898108B9253B",
 Name : "Wide World Importers",
 Address : "3148 Passaic Street",
 City : "Reston",
 State : "DC",
 ZipCode : 20191,
 TIN : 56-2467496
}, {
 CustomerID : 7,
 CustomerTicket : "65CDCEC2-368A-4B29-A156-0E0BB8FEA7FF",
 Name : "Graphic Design Institute",
 Address : "193 Poling Farm Road",
 City : "Randolph",
 State : "NE",
 ZipCode : 68771,
 TIN : 56-6751685
}, {
 CustomerID : 8,
 CustomerTicket : "ED3F3567-85A9-416B-909E-B25955D77E2A",
 Name : "Adventure Works",
 Address : "211 Farland Avenue",
 City : "Uvalde",
 State : "TX",
 ZipCode : 78801,
 TIN : 39-1309162
}, {
 CustomerID : 9,
 CustomerTicket : "924C9BAD-F3C9-445C-BDEC-C3BF20F15245",
 Name : "Humongous Insurance",
 Address : "1717 Edgewood Avenue",
 City : "Fresno",
 State : "CA",
 ZipCode : 93721,
 TIN : 40-8819895
}, {
 CustomerID : 10,
 CustomerTicket : "19E7E150-8B2A-408D-B0B5-5BAA43FD7A09",
 Name : "Woodgrove Bank",
 Address : "2110 Maple Street",
 City : "Irvine",
 State : "CA",
 ZipCode : 92614,
 TIN : 92-4691264
}, {
 CustomerID : 11,
 CustomerTicket : "04CEBA25-4680-40BD-83BE-9C68217A0E87",
 Name : "Margie's Travel",
 Address : "3379 College Street",
 City : "Decatur",
 State : "GA",
 ZipCode : 30030,
 TIN : 18-9269063
}, {
 CustomerID : 12,
 CustomerTicket : "9EFCA023-0BA6-404D-88D9-01061C419656",
 Name : "Northwind Traders",
 Address : "3850 Elk City Road",
 City : "Indianapolis",
 State : "IN",
 ZipCode : 46205,
 TIN : 87-4224500
}, {
 CustomerID : 13,
 CustomerTicket : "200DC2FD-0297-4D59-A429-5044505B4D2E",
 Name : "Blue Yonder Airlines",
 Address : "33 Trouser Leg Road",
 City : "Shelburne",
 State : "MA",
 ZipCode : 1301,
 TIN : 32-3149379
}, {
 CustomerID : 14,
 CustomerTicket : "E802AAFF-458A-4346-8E80-8FC25714476C",
 Name : "Trey Research",
 Address : "707 Bruce Street",
 City : "St. Louis",
 State : "MO",
 ZipCode : 63101,
 TIN : 53-9702721
}, {
 CustomerID : 15,
 CustomerTicket : "0DC2939F-551A-4E65-A008-C2A423E39C39",
 Name : "The Phone Company",
 Address : "1805 Tori Lane",
 City : "Midvale",
 State : "UT",
 ZipCode : 84047,
 TIN : 29-7989701
}, {
 CustomerID : 16,
 CustomerTicket : "B5BB0382-32F2-4339-B8F3-3C29EC55568A",
 Name : "Wingtip Toys",
 Address : "3280 Biddie Lane",
 City : "Hopewell",
 State : "VA",
 ZipCode : 23860,
 TIN : 41-3534687
}, {
 CustomerID : 17,
 CustomerTicket : "AEF13C51-8C70-4A30-B1B3-3E5BDA400E99",
 Name : "Lucerne Publishing",
 Address : "1336 Stoney Lonesome Road",
 City : "Scranton",
 State : "PA",
 ZipCode : 18510,
 TIN : 94-4071874
}, {
 CustomerID : 18,
 CustomerTicket : "052B2DE5-A02B-4DD4-969A-7D16F68AB290",
 Name : "Fourth Coffee",
 Address : "3288 Finwood Road",
 City : "Fresno",
 State : "NJ",
 ZipCode : 7728,
 TIN : 27-2130193
}];

var bnkEmployee = [{
 EmployeeID : 1,
 EmployeeTicket : "0760656E-5790-4615-AE50-3032236AAC1D",
 FirstName : "Eva",
 LastName : "Kilpatrick",
 DateStarted : "12/19/2011",
 DateEnded : null,
 Title : "Teller",
 TIN : 115-98-6023
}, {
 EmployeeID : 2,
 EmployeeTicket : "81B4F116-1080-4E0C-96B5-C2EA781B21C7",
 FirstName : "Joyce",
 LastName : "Kearney",
 DateStarted : "03/03/2014",
 DateEnded : null,
 Title : "Teller",
 TIN : 937-46-1306
}, {
 EmployeeID : 3,
 EmployeeTicket : "907826F3-1ED0-4565-AB95-13CA3C8A36C7",
 FirstName : "Paula",
 LastName : "Fuller",
 DateStarted : "08/23/2010",
 DateEnded : null,
 Title : "New Accounts",
 TIN : 281-76-4390
}, {
 EmployeeID : 4,
 EmployeeTicket : "C9853CE7-5546-4940-8BE0-96589595C70C",
 FirstName : "Frank",
 LastName : "Wozniak",
 DateStarted : "04/08/2011",
 DateEnded : null,
 Title : "New Accounts",
 TIN : 925-37-2799
}, {
 EmployeeID : 5,
 EmployeeTicket : "FE833889-725F-4693-BC9B-B2AB2B86B522",
 FirstName : "Donald",
 LastName : "Crawley",
 DateStarted : "01/25/1988",
 DateEnded : null,
 Title : "Operations Supervisor",
 TIN : 777-11-9237
}];

var bnkServiceChargeManager = [{
 ServiceChargeManagerID : 1,
 ServiceChargeManagerTicket : "CE873E13-B05C-4324-879E-8C99153F9DA6",
 AccountID : 6,
 ServiceChargeExpression : "({v1}*0.27)-({v2}*0.027)"
}, {
 ServiceChargeManagerID : 2,
 ServiceChargeManagerTicket : "76EBFE98-A024-49EB-BDE6-C3D8F344B621",
 AccountID : 7,
 ServiceChargeExpression : "({v1}*0.03)-({v2}*0.003)"
}, {
 ServiceChargeManagerID : 3,
 ServiceChargeManagerTicket : "C8EB4087-89A3-4A27-B0E1-11B2A5F6D476",
 AccountID : 7,
 ServiceChargeExpression : "({v1}*0.88)-({v2}*0.088)"
}, {
 ServiceChargeManagerID : 4,
 ServiceChargeManagerTicket : "27306C87-232F-469A-B100-69A4A8A1EF5A",
 AccountID : 4,
 ServiceChargeExpression : "({v1}*0.53)-({v2}*0.053)"
}, {
 ServiceChargeManagerID : 5,
 ServiceChargeManagerTicket : "2B05B659-C17F-45B6-B359-1C2AF17A8A96",
 AccountID : 5,
 ServiceChargeExpression : "({v1}*0.56)-({v2}*0.056)"
}, {
 ServiceChargeManagerID : 6,
 ServiceChargeManagerTicket : "9C921975-A25A-4723-9FF6-30EE6CA84489",
 AccountID : 3,
 ServiceChargeExpression : "({v1}*0.45)-({v2}*0.045)"
}, {
 ServiceChargeManagerID : 7,
 ServiceChargeManagerTicket : "5B8A5D85-9448-478C-AA3B-55068CE5A06C",
 AccountID : 2,
 ServiceChargeExpression : "({v1}*0.63)-({v2}*0.063)"
}, {
 ServiceChargeManagerID : 8,
 ServiceChargeManagerTicket : "ED23C380-A8E4-4230-A32E-A0AEA8788735",
 AccountID : 6,
 ServiceChargeExpression : "({v1}*0.03)-({v2}*0.003)"
}, {
 ServiceChargeManagerID : 9,
 ServiceChargeManagerTicket : "7E6106DD-7237-4332-BACC-E53B24FFDF54",
 AccountID : 2,
 ServiceChargeExpression : "({v1}*0.47)-({v2}*0.047)"
}, {
 ServiceChargeManagerID : 10,
 ServiceChargeManagerTicket : "41D92C19-87CD-4AB7-85E7-4D1E56A405BD",
 AccountID : 4,
 ServiceChargeExpression : "({v1}*0.00)-({v2}*0.097)"
}, {
 ServiceChargeManagerID : 11,
 ServiceChargeManagerTicket : "DB0F8298-68D5-4E60-8CAB-EA698A1FE16E",
 AccountID : 2,
 ServiceChargeExpression : "({v1}*0.75)-({v2}*0.075)"
}, {
 ServiceChargeManagerID : 12,
 ServiceChargeManagerTicket : "90A42D1C-D81C-462B-A089-2A58AE5E1EDA",
 AccountID : 1,
 ServiceChargeExpression : "({v1}*0.76)-({v2}*0.076)"
}];

var bnkTransaction = [{
 TransactionID : 1,
 TransactionTicket : "3FB83D82-3F04-4A94-813F-50B207A29034",
 AccountID : 6,
 TransactionTypeEnum : 2,
 Amount : 11306.32,
 DateTransaction : "09/07/2013",
 DateFundsAvailable : "09/07/2013",
 RemoteInstitution : "Bank of the Best",
 RemoteAccount : 44972
}, {
 TransactionID : 2,
 TransactionTicket : "2B157DDC-0153-4162-904B-0F6F9CC0EB98",
 AccountID : 4,
 TransactionTypeEnum : 2,
 Amount : 17413.31,
 DateTransaction : "04/23/1998",
 DateFundsAvailable : "04/23/1998",
 RemoteInstitution : "Legion Bank",
 RemoteAccount : 92420
}, {
 TransactionID : 3,
 TransactionTicket : "0C356039-EE05-4BD7-A828-FEF9D8DC1A3F",
 AccountID : 2,
 TransactionTypeEnum : 2,
 Amount : 9558.14,
 DateTransaction : "06/24/1988",
 DateFundsAvailable : "06/24/1988",
 RemoteInstitution : "Omni Bank",
 RemoteAccount : 63077
}, {
 TransactionID : 4,
 TransactionTicket : "B9EBD756-1F02-4ABD-8C93-275F8D4A5D3A",
 AccountID : 1,
 TransactionTypeEnum : 2,
 Amount : 8751.14,
 DateTransaction : "09/20/1992",
 DateFundsAvailable : "09/20/1992",
 RemoteInstitution : "Roadhouse Bank",
 RemoteAccount : 74285
}, {
 TransactionID : 5,
 TransactionTicket : "03872633-6727-4D60-9F2B-00359AF48229",
 AccountID : 4,
 TransactionTypeEnum : 2,
 Amount : 786.72,
 DateTransaction : "06/09/1997",
 DateFundsAvailable : "06/09/1997",
 RemoteInstitution : "Red Baron State Bank",
 RemoteAccount : 88678
}];

var bnkTransactionType = [{
 TransactionTypeID : 1,
 TransactionTypeTicket : "F8DC94D7-DC76-4908-84AA-1DCDE01CFEB8",
 TransactionTypeEnum : 0,
 TransactionTypeSortIndex : 0,
 TransactionTypeName : "None",
 TransactionTypeDescription : "Unknown or no type defined."
}, {
 TransactionTypeID : 2,
 TransactionTypeTicket : "5078F3B7-F0DB-4F83-AE13-44C468DB2F7D",
 TransactionTypeEnum : 1,
 TransactionTypeSortIndex : 1,
 TransactionTypeName : "Cash",
 TransactionTypeDescription : "Cash Deposit or Withdrawal."
}, {
 TransactionTypeID : 3,
 TransactionTypeTicket : "D3BE1BA3-D265-412D-95DE-8FA874BC8709",
 TransactionTypeEnum : 2,
 TransactionTypeSortIndex : 2,
 TransactionTypeName : "CheckOut",
 TransactionTypeDescription : "Check ONUS."
}, {
 TransactionTypeID : 4,
 TransactionTypeTicket : "2C253A85-B9AA-4442-B7A1-7512F71FA50D",
 TransactionTypeEnum : 3,
 TransactionTypeSortIndex : 3,
 TransactionTypeName : "CheckIn",
 TransactionTypeDescription : "Check Deposited on other institution."
}];
