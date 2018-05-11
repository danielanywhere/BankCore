using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data.Entity;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	AccountCollection																												*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of AccountItem Items.
	/// </summary>
	public class AccountCollection : ObservableCollection<AccountItem>
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new Instance of the AccountCollection Item.
		/// </summary>
		public AccountCollection()
		{
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the AccountCollection Item.
		/// </summary>
		public AccountCollection(bankEntities context)
		{
			mContext = context;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Add																																		*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new AccountItem to the collection.
		/// </summary>
		public new void Add(AccountItem account)
		{
			bnkAccount ci = null;
			if(account != null)
			{
				base.Add(account);
				if(account.EntityItem == null && mContext != null)
				{
					account.HasPresetValues = true;
					ci = new bnkAccount();
					mContext.bnkAccounts.Add(ci);
					account.EntityItem = ci;
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AddOrUpdate																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new AccountItem to the collection, or update the existing one.
		/// </summary>
		public AccountItem AddOrUpdate(AccountItem account)
		{
			bnkAccount ci = null;			// Internal Item.
			AccountItem cx = null;			// Existing Item.
			if(account != null)
			{
				cx = this.First(r => r.AccountID == account.AccountID);
				if(cx == null)
				{
					// Create new item.
					base.Add(account);
					if(account.EntityItem == null && mContext != null)
					{
						account.HasPresetValues = true;
						ci = new bnkAccount();
						mContext.bnkAccounts.Add(ci);
						account.EntityItem = ci;
					}
					cx = account;
				}
				else
				{
					// Item already existed.
					account.TransferProperties(cx);
				}
			}
			return cx;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Context																																*
		//*-----------------------------------------------------------------------*
		private bankEntities mContext = null;
		/// <summary>
		/// Get/Set a reference to the current data model content.
		/// </summary>
		public bankEntities Context
		{
			get
			{
				if(mContext == null)
				{
					mContext = new bankEntities();
				}
				return mContext;
			}
			set { mContext = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Exists																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a value indicating whether the specified account exists in
		/// this collection.
		/// </summary>
		public bool Exists(int accountID)
		{
			bool rv = (this.First(r => r.AccountID == accountID) != null);
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Load																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all accounts.
		/// </summary>
		public bool Load()
		{
			bankEntities cx = Context;
			bool rv = false;   // Return Value.

			this.Clear();
			cx.bnkAccounts.Load();
			foreach(bnkAccount ci in cx.bnkAccounts)
			{
				this.Add(new AccountItem(this, ci));
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Remove																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Remove the specified account from the collection.
		/// </summary>
		public new void Remove(AccountItem account)
		{
			AccountItem ci = null;

			if(account != null)
			{
				// Value is specified.
				ci = this.First(r => r.AccountID == account.AccountID);
				if(ci != null)
				{
					// Member item found.
					if(ci.EntityItem != null && mContext != null)
					{
						mContext.bnkAccounts.Remove((bnkAccount)ci.EntityItem);
					}
					this.Remove(ci);
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	SaveChanges																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Save all of the changes in the associated entity collection.
		/// </summary>
		public void SaveChanges()
		{
			bankEntities cx = Context;

			cx.SaveChanges();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	SetItemModified																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Set the background state to modified for the specified item.
		/// </summary>
		public void SetItemModified(AccountItem item)
		{
			if(item != null && item.EntityItem != null && mContext != null)
			{
				mContext.Entry(item.EntityItem).State = EntityState.Modified;
			}
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	AccountItem																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Information about the account.
	/// </summary>
	[DataContract]
	public class AccountItem : TransientItem
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private static List<string> AccountItemPropertyNames =
			new List<string>(
			new string[] { "AccountID", "AccountTicket", "AccountStatus",
			"BalanceAvailable", "BalancePending", "BranchID", "CustomerID",
			"DateClosed", "DateLastActivity", "DateOpened", "EmployeeID" });

		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new Instance of the AccountItem Item.
		/// </summary>
		public AccountItem()
		{
			PropertyNames = AccountItemPropertyNames;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the AccountItem Item.
		/// </summary>
		public AccountItem(AccountCollection parent, bnkAccount account) :
			this()
		{
			mParent = parent;
			EntityItem = account;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AccountID																															*
		//*-----------------------------------------------------------------------*
		private int mAccountID = 0;
		/// <summary>
		/// Get/Set the AccountID of the account.
		/// </summary>
		[DataMember]
		public int AccountID
		{
			get { return mAccountID; }
			set
			{
				mAccountID = value;
				OnPropertyChanged("AccountID");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AccountStatus																													*
		//*-----------------------------------------------------------------------*
		private string mAccountStatus = "";
		/// <summary>
		/// Get/Set the AccountStatus of the account.
		/// </summary>
		[DataMember]
		public string AccountStatus
		{
			get { return mAccountStatus; }
			set
			{
				mAccountStatus = value;
				OnPropertyChanged("AccountStatus");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AccountTicket																													*
		//*-----------------------------------------------------------------------*
		private Guid mAccountTicket = Guid.Empty;
		/// <summary>
		/// Get/Set the AccountTicket of the account.
		/// </summary>
		[DataMember]
		public Guid AccountTicket
		{
			get { return mAccountTicket; }
			set
			{
				mAccountTicket = value;
				OnPropertyChanged("AccountTicket");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	BalanceAvailable																											*
		//*-----------------------------------------------------------------------*
		private decimal mBalanceAvailable = 0;
		/// <summary>
		/// Get/Set the BalanceAvailable of the account.
		/// </summary>
		[DataMember]
		public decimal BalanceAvailable
		{
			get { return mBalanceAvailable; }
			set
			{
				mBalanceAvailable = value;
				OnPropertyChanged("BalanceAvailable");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	BalancePending																												*
		//*-----------------------------------------------------------------------*
		private decimal mBalancePending = 0;
		/// <summary>
		/// Get/Set the BalancePending of the account.
		/// </summary>
		[DataMember]
		public decimal BalancePending
		{
			get { return mBalancePending; }
			set
			{
				mBalancePending = value;
				OnPropertyChanged("BalancePending");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	BranchID																															*
		//*-----------------------------------------------------------------------*
		private int mBranchID = 0;
		/// <summary>
		/// Get/Set the BranchID of the account.
		/// </summary>
		[DataMember]
		public int BranchID
		{
			get { return mBranchID; }
			set
			{
				mBranchID = value;
				OnPropertyChanged("BranchID");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	BranchName																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get the BranchName of the account.
		/// </summary>
		public string BranchName
		{
			get
			{
				return SQLHelper.GetScalarString(
					"SELECT Name AS Name " +
					"FROM bnkBranch " +
					"WHERE BranchID = " + SQLHelper.ToSql(BranchID)
				);
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CustomerID																														*
		//*-----------------------------------------------------------------------*
		private int mCustomerID = 0;
		/// <summary>
		/// Get/Set the CustomerID of the account.
		/// </summary>
		[DataMember]
		public int CustomerID
		{
			get { return mCustomerID; }
			set
			{
				mCustomerID = value;
				OnPropertyChanged("CustomerID");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CustomerName																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get the CustomerName of the account.
		/// </summary>
		public string CustomerName
		{
			get
			{
				return SQLHelper.GetScalarString(
					"SELECT Name AS Name " +
					"FROM bnkCustomer " +
					"WHERE CustomerID = " + SQLHelper.ToSql(CustomerID)
				);
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DateClosed																														*
		//*-----------------------------------------------------------------------*
		private DateTime mDateClosed = DateTime.MinValue;
		/// <summary>
		/// Get/Set the DateClosed of the account.
		/// </summary>
		[DataMember]
		public DateTime DateClosed
		{
			get { return mDateClosed; }
			set
			{
				mDateClosed = value;
				OnPropertyChanged("DateClosed");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DateLastActivity																											*
		//*-----------------------------------------------------------------------*
		private DateTime mDateLastActivity = DateTime.MinValue;
		/// <summary>
		/// Get/Set the DateLastActivity of the account.
		/// </summary>
		[DataMember]
		public DateTime DateLastActivity
		{
			get { return mDateLastActivity; }
			set
			{
				mDateLastActivity = value;
				OnPropertyChanged("DateLastActivity");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DateOpened																														*
		//*-----------------------------------------------------------------------*
		private DateTime mDateOpened = DateTime.MinValue;
		/// <summary>
		/// Get/Set the DateOpened of the account.
		/// </summary>
		[DataMember]
		public DateTime DateOpened
		{
			get { return mDateOpened; }
			set
			{
				mDateOpened = value;
				OnPropertyChanged("DateOpened");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	EmployeeID																														*
		//*-----------------------------------------------------------------------*
		private int mEmployeeID = 0;
		/// <summary>
		/// Get/Set the EmployeeID of the account.
		/// </summary>
		[DataMember]
		public int EmployeeID
		{
			get { return mEmployeeID; }
			set
			{
				mEmployeeID = value;
				OnPropertyChanged("EmployeeID");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	EmployeeName																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get the EmployeeName of the account.
		/// </summary>
		public string EmployeeName
		{
			get
			{
				return SQLHelper.GetScalarString(
					"SELECT " +
					"IIF(LEN(FirstName) > 0 AND LEN(LastName) > 0, " +
					"FirstName + \" \" + LastName, " +
					"FirstName + LastName) AS EmployeeName " +
					"FROM bnkEmployee " +
					"WHERE EmployeeID = " + SQLHelper.ToSql(EmployeeID)
				);
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Parent																																*
		//*-----------------------------------------------------------------------*
		private AccountCollection mParent = null;
		/// <summary>
		/// Get/Set a reference to the parent collection to which this item is
		/// attached.
		/// </summary>
		public AccountCollection Parent
		{
			get { return mParent; }
			set { mParent = value; }
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
