//	View model functionality.
(function()
{
	//	View models.
	//	Accounts.
	var accountsViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var accountIndex = $.inArray(deletedItem, this.accounts);
			this.accounts.splice(accountIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.accounts.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("accountsDB.loadData...");
			var cCount = this.accounts.length;
			var cIndex = 0;
			var cItem = null;
			//	Remove dashes from tickets.
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.accounts[cIndex];
				cItem.AccountTicket =
					cItem.AccountTicket.replace(/-/g, ' ');
			}
			return $.grep(this.accounts, function(account)
			{
				return (!filter.AccountTicket ||
					account.AccountTicket.toLowerCase().
					indexOf(filter.AccountTicket.toLowerCase()) > -1) &&
					(!filter.AccountStatus ||
					account.AccountStatus.toLowerCase().
					indexOf(filter.AccountStatus.toLowerCase()) > -1);
			});
		},
		updateItem: function(changedItem)
		{
		}
	};
	window.accountsViewModel = accountsViewModel;

	//	Customers.
	var customersViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var customerIndex = $.inArray(deletedItem, this.customers);
			this.customers.splice(customerIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.customers.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("customersDB.loadData...");
			var cCount = this.customers.length;
			var cIndex = 0;
			var cItem = null;
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.customers[cIndex];
				cItem.CustomerTicket =
					cItem.CustomerTicket.replace(/-/g, ' ');
			}
			return $.grep(this.customers, function(customer)
			{
				return (!filter.CustomerTicket ||
					customer.CustomerTicket.toLowerCase().
					indexOf(filter.CustomerTicket.toLowerCase()) > -1) &&
					(!filter.Name ||
					customer.Name.toLowerCase().
					indexOf(filter.Name.toLowerCase()) > -1) &&
					(!filter.Address ||
					customer.Address.toLowerCase().
					indexOf(filter.Address.toLowerCase()) > -1) &&
					(!filter.City ||
					customer.City.toLowerCase().
					indexOf(filter.City.toLowerCase()) > -1) &&
					(!filter.State ||
					customer.State.toLowerCase().
					indexOf(filter.State.toLowerCase()) > -1) &&
					(!filter.ZipCode ||
					customer.ZipCode == filter.ZipCode) &&
					(!filter.TIN ||
					customer.TIN.indexOf(filter.TIN) > -1);
			});
		},
		updateItem: function(changedItem)
		{
			console.log("Changed Item ID: " + changedItem.CustomerID);
			var cCount = this.customers.length;
			var cIndex = 0;
			var cItem = null;
			var cName = "";
			var fCount = 0;
			var fIndex = 0;
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.customers[cIndex];
				if(cItem.CustomerID == changedItem.CustomerID)
				{
					//	Changed item found.
					console.log("Changed item found...");
					console.log("Old Name: " + cItem.Name);
					console.log("Changed Name: " + changedItem.Name);
					fCount = Object.keys(changedItem).length;
					console.log("Field Count: " + fCount);
					for(fIndex = 1; fIndex < fCount; fIndex ++)
					{
						cName = Object.keys(changedItem)[fIndex];
						cItem[cName] = changedItem[cName];
					}
					console.log("New Name: " + this.customers[cIndex].Name);
				}
			}
		}
	};
	window.customersViewModel = customersViewModel;

	//	Models.
	accountsViewModel.accountStates =
	[
		{
			"StateName": "Active"
		},
		{
			"StateName": "Closed"
		},
		{
			"StateName": "Pending"
		}
	];
	accountsViewModel.accounts =
	[{
		"AccountID": 1,
		"AccountTicket": "F94259BE-92A2-4DFA-A1F9-1370A341F5F1",
		"CustomerID": 8,
		"AccountStatus": "Active",
		"BalanceAvailable": 4887.54,
		"BalancePending": 4887.54,
		"DateOpened": "10/16/2001",
		"DateClosed": null,
		"DateLastActivity": "12/26/2017",
		"BranchID": 1,
		"EmployeeID": 5
	},
	{
		"AccountID": 2,
		"AccountTicket": "5E33AE21-BA5F-4974-BBC3-8A65CFBBEA25",
		"CustomerID": 15,
		"AccountStatus": "Active",
		"BalanceAvailable": 17425.66,
		"BalancePending": 17425.66,
		"DateOpened": "03/14/1983",
		"DateClosed": null,
		"DateLastActivity": "01/27/1990",
		"BranchID": 4,
		"EmployeeID": 2
	},
	{
		"AccountID": 3,
		"AccountTicket": "ECA74C94-3148-4DA3-8AC2-6A34982F290D",
		"CustomerID": 18,
		"AccountStatus": "Active",
		"BalanceAvailable": 19988.78,
		"BalancePending": 8643.23,
		"DateOpened": "07/18/1981",
		"DateClosed": null,
		"DateLastActivity": "11/22/1994",
		"BranchID": 4,
		"EmployeeID": 4
	},
	{
		"AccountID": 4,
		"AccountTicket": "0CED83D0-464C-4BDD-92ED-7ACB8E5155AD",
		"CustomerID": 2,
		"AccountStatus": "Active",
		"BalanceAvailable": 8561.62,
		"BalancePending": 8561.62,
		"DateOpened": "01/26/2011",
		"DateClosed": null,
		"DateLastActivity": "02/12/2012",
		"BranchID": 1,
		"EmployeeID": 4
	},
	{
		"AccountID": 5,
		"AccountTicket": "D3684C78-5B0E-4A22-A687-5D627B85677F",
		"CustomerID": 9,
		"AccountStatus": "Active",
		"BalanceAvailable": 23698.24,
		"BalancePending": 23698.24,
		"DateOpened": "07/17/1997",
		"DateClosed": null,
		"DateLastActivity": "09/07/2011",
		"BranchID": 1,
		"EmployeeID": 2
	},
	{
		"AccountID": 6,
		"AccountTicket": "CB98FCE0-BA25-454C-BEBC-3C7EE6733961",
		"CustomerID": 5,
		"AccountStatus": "Active",
		"BalanceAvailable": 24205.64,
		"BalancePending": 24205.64,
		"DateOpened": "12/20/1983",
		"DateClosed": null,
		"DateLastActivity": "03/20/1988",
		"BranchID": 3,
		"EmployeeID": 2
	},
	{
		"AccountID": 7,
		"AccountTicket": "54FDE9A0-D45D-4AB3-9B84-7BA92596E71B",
		"CustomerID": 8,
		"AccountStatus": "Active",
		"BalanceAvailable": 852.13,
		"BalancePending": 1310.49,
		"DateOpened": "12/14/2008",
		"DateClosed": null,
		"DateLastActivity": "10/07/2016",
		"BranchID": 4,
		"EmployeeID": 4
	}
	];
	
	customersViewModel.customers =
	[{
		"CustomerID": 1,
		"CustomerTicket": "6B28522A-D002-4D28-A307-9DBBA5CD6286",
		"Name": "Consolidated Messenger",
		"Address": "4786 Locust Court",
		"City": "Fresno",
		"State": "CA",
		"ZipCode": 90248,
		"TIN": "33-6566647"
	},
	{
		"CustomerID": 2,
		"CustomerTicket": "92FDBA50-E929-46C1-A019-8CFFE9FAE7D6",
		"Name": "Alpine Ski House",
		"Address": "523 Redbud Drive",
		"City": "New York",
		"State": "NY",
		"ZipCode": 10013,
		"TIN": "90-3818787"
	},
	{
		"CustomerID": 3,
		"CustomerTicket": "FEEED429-AB29-41C6-B71A-5D93C4910061",
		"Name": "Southridge Video",
		"Address": "2205 Cooks Mine Road",
		"City": "Albuquerque",
		"State": "NM",
		"ZipCode": 87102,
		"TIN": "06-1886298"
	},
	{
		"CustomerID": 4,
		"CustomerTicket": "9D0F2962-F1EC-4409-85D7-DA79D2FD503C",
		"Name": "City Power & Light",
		"Address": "2502 Oak Avenue",
		"City": "Schaumburg",
		"State": "IL",
		"ZipCode": 60173,
		"TIN": "19-7270587"
	},
	{
		"CustomerID": 5,
		"CustomerTicket": "2806379A-6145-4357-B7AC-EA208BE25581",
		"Name": "Coho Winery",
		"Address": "112 West Street",
		"City": "Casnovia",
		"State": "MI",
		"ZipCode": 49318,
		"TIN": "79-9418423"
	},
	{
		"CustomerID": 6,
		"CustomerTicket": "E785DAAC-9C3A-4419-9A81-898108B9253B",
		"Name": "Wide World Importers",
		"Address": "3148 Passaic Street",
		"City": "Reston",
		"State": "DC",
		"ZipCode": 20191,
		"TIN": "56-2467496"
	},
	{
		"CustomerID": 7,
		"CustomerTicket": "65CDCEC2-368A-4B29-A156-0E0BB8FEA7FF",
		"Name": "Graphic Design Institute",
		"Address": "193 Poling Farm Road",
		"City": "Randolph",
		"State": "NE",
		"ZipCode": 68771,
		"TIN": "56-6751685"
	},
	{
		"CustomerID": 8,
		"CustomerTicket": "ED3F3567-85A9-416B-909E-B25955D77E2A",
		"Name": "Adventure Works",
		"Address": "211 Farland Avenue",
		"City": "Uvalde",
		"State": "TX",
		"ZipCode": 78801,
		"TIN": "39-1309162"
	},
	{
		"CustomerID": 9,
		"CustomerTicket": "924C9BAD-F3C9-445C-BDEC-C3BF20F15245",
		"Name": "Humongous Insurance",
		"Address": "1717 Edgewood Avenue",
		"City": "Fresno",
		"State": "CA",
		"ZipCode": 93721,
		"TIN": "40-8819895"
	},
	{
		"CustomerID": 10,
		"CustomerTicket": "19E7E150-8B2A-408D-B0B5-5BAA43FD7A09",
		"Name": "Woodgrove Bank",
		"Address": "2110 Maple Street",
		"City": "Irvine",
		"State": "CA",
		"ZipCode": 92614,
		"TIN": "92-4691264"
	},
	{
		"CustomerID": 11,
		"CustomerTicket": "04CEBA25-4680-40BD-83BE-9C68217A0E87",
		"Name": "Margie's Travel",
		"Address": "3379 College Street",
		"City": "Decatur",
		"State": "GA",
		"ZipCode": 30030,
		"TIN": "18-9269063"
	},
	{
		"CustomerID": 12,
		"CustomerTicket": "9EFCA023-0BA6-404D-88D9-01061C419656",
		"Name": "Northwind Traders",
		"Address": "3850 Elk City Road",
		"City": "Indianapolis",
		"State": "IN",
		"ZipCode": 46205,
		"TIN": "87-4224500"
	},
	{
		"CustomerID": 13,
		"CustomerTicket": "200DC2FD-0297-4D59-A429-5044505B4D2E",
		"Name": "Blue Yonder Airlines",
		"Address": "33 Trouser Leg Road",
		"City": "Shelburne",
		"State": "MA",
		"ZipCode": 1301,
		"TIN": "32-3149379"
	},
	{
		"CustomerID": 14,
		"CustomerTicket": "E802AAFF-458A-4346-8E80-8FC25714476C",
		"Name": "Trey Research",
		"Address": "707 Bruce Street",
		"City": "St. Louis",
		"State": "MO",
		"ZipCode": 63101,
		"TIN": "53-9702721"
	},
	{
		"CustomerID": 15,
		"CustomerTicket": "0DC2939F-551A-4E65-A008-C2A423E39C39",
		"Name": "The Phone Company",
		"Address": "1805 Tori Lane",
		"City": "Midvale",
		"State": "UT",
		"ZipCode": 84047,
		"TIN": "29-7989701"
	},
	{
		"CustomerID": 16,
		"CustomerTicket": "B5BB0382-32F2-4339-B8F3-3C29EC55568A",
		"Name": "Wingtip Toys",
		"Address": "3280 Biddie Lane",
		"City": "Hopewell",
		"State": "VA",
		"ZipCode": 23860,
		"TIN": "41-3534687"
	},
	{
		"CustomerID": 17,
		"CustomerTicket": "AEF13C51-8C70-4A30-B1B3-3E5BDA400E99",
		"Name": "Lucerne Publishing",
		"Address": "1336 Stoney Lonesome Road",
		"City": "Scranton",
		"State": "PA",
		"ZipCode": 18510,
		"TIN": "94-4071874"
	},
	{
		"CustomerID": 18,
		"CustomerTicket": "052B2DE5-A02B-4DD4-969A-7D16F68AB290",
		"Name": "Fourth Coffee",
		"Address": "3288 Finwood Road",
		"City": "Fresno",
		"State": "NJ",
		"ZipCode": 7728,
		"TIN": "27-2130193"
	}
	];

}());
