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
	//*	CustomerCollection																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of CustomerItem Items.
	/// </summary>
	public class CustomerCollection : ObservableCollection<CustomerItem>
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
		/// Create a new Instance of the CustomerCollection Item.
		/// </summary>
		public CustomerCollection()
		{
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the CustomerCollection Item.
		/// </summary>
		public CustomerCollection(bankEntities context)
		{
			mContext = context;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Add																																		*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new CustomerItem to the collection.
		/// </summary>
		public new void Add(CustomerItem customer)
		{
			bnkCustomer ci = null;
			if(customer != null)
			{
				base.Add(customer);
				if(customer.EntityItem == null && mContext != null)
				{
					customer.HasPresetValues = true;
					ci = new bnkCustomer();
					mContext.bnkCustomers.Add(ci);
					customer.EntityItem = ci;
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AddOrUpdate																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new CustomerItem to the collection, or update the existing one.
		/// </summary>
		public CustomerItem AddOrUpdate(CustomerItem customer)
		{
			bnkCustomer ci = null;			// Internal Item.
			CustomerItem cx = null;			// Existing Item.
			if(customer != null)
			{
				cx = this.First(r => r.CustomerID == customer.CustomerID);
				if(cx == null)
				{
					// Create new item.
					base.Add(customer);
					if(customer.EntityItem == null && mContext != null)
					{
						customer.HasPresetValues = true;
						ci = new bnkCustomer();
						mContext.bnkCustomers.Add(ci);
						customer.EntityItem = ci;
					}
					cx = customer;
				}
				else
				{
					// Item already existed.
					customer.TransferProperties(cx);
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
		/// Return a value indicating whether the specified customer exists in
		/// this collection.
		/// </summary>
		public bool Exists(int customerID)
		{
			bool rv = (this.First(r => r.CustomerID == customerID) != null);
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Load																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all customers.
		/// </summary>
		public bool Load()
		{
			bankEntities cx = Context;
			bool rv = false;   // Return Value.

			this.Clear();
			cx.bnkCustomers.Load();
			foreach(bnkCustomer ci in cx.bnkCustomers)
			{
				this.Add(new CustomerItem(this, ci));
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Remove																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Remove the specified customer from the collection.
		/// </summary>
		public new void Remove(CustomerItem customer)
		{
			CustomerItem ci = null;

			if(customer != null)
			{
				// Value is specified.
				ci = this.First(r => r.CustomerID == customer.CustomerID);
				if(ci != null)
				{
					// Member item found.
					if(ci.EntityItem != null && mContext != null)
					{
						mContext.bnkCustomers.Remove((bnkCustomer)ci.EntityItem);
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
		public void SetItemModified(CustomerItem item)
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
	//*	CustomerItem																														*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Information about the customer.
	/// </summary>
	[DataContract]
	public class CustomerItem : TransientItem
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private static List<string> CustomerItemPropertyNames =
			new List<string>(
			new string[] { "CustomerID", "CustomerTicket", "Name", "Address",
			"City", "State", "ZipCode", "TIN" });

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
		/// Create a new Instance of the CustomerItem Item.
		/// </summary>
		public CustomerItem()
		{
			PropertyNames = CustomerItemPropertyNames;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the CustomerItem Item.
		/// </summary>
		public CustomerItem(CustomerCollection parent, bnkCustomer customer) :
			this()
		{
			mParent = parent;
			EntityItem = customer;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Address																																*
		//*-----------------------------------------------------------------------*
		private string mAddress = "";
		/// <summary>
		/// Get/Set the Address of the customer.
		/// </summary>
		[DataMember]
		public string Address
		{
			get { return mAddress; }
			set
			{
				mAddress = value;
				OnPropertyChanged("Address");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	City																																	*
		//*-----------------------------------------------------------------------*
		private string mCity = "";
		/// <summary>
		/// Get/Set the City of the customer.
		/// </summary>
		[DataMember]
		public string City
		{
			get { return mCity; }
			set
			{
				mCity = value;
				OnPropertyChanged("City");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CustomerID																														*
		//*-----------------------------------------------------------------------*
		private int mCustomerID = 0;
		/// <summary>
		/// Get/Set the CustomerID of the customer.
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
		//*	CustomerTicket																												*
		//*-----------------------------------------------------------------------*
		private Guid mCustomerTicket = Guid.Empty;
		/// <summary>
		/// Get/Set the CustomerTicket of the customer.
		/// </summary>
		[DataMember]
		public Guid CustomerTicket
		{
			get { return mCustomerTicket; }
			set
			{
				mCustomerTicket = value;
				OnPropertyChanged("CustomerTicket");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Name																																	*
		//*-----------------------------------------------------------------------*
		private string mName = "";
		/// <summary>
		/// Get/Set the Name of the customer.
		/// </summary>
		[DataMember]
		public string Name
		{
			get { return mName; }
			set
			{
				mName = value;
				OnPropertyChanged("Name");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Parent																																*
		//*-----------------------------------------------------------------------*
		private CustomerCollection mParent = null;
		/// <summary>
		/// Get/Set a reference to the parent collection to which this item is
		/// attached.
		/// </summary>
		public CustomerCollection Parent
		{
			get { return mParent; }
			set { mParent = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	State																																	*
		//*-----------------------------------------------------------------------*
		private string mState = "";
		/// <summary>
		/// Get/Set the State of the customer.
		/// </summary>
		[DataMember]
		public string State
		{
			get { return mState; }
			set
			{
				mState = value;
				OnPropertyChanged("State");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	TIN																																		*
		//*-----------------------------------------------------------------------*
		private string mTIN = "";
		/// <summary>
		/// Get/Set the TIN of the customer.
		/// </summary>
		[DataMember]
		public string TIN
		{
			get { return mTIN; }
			set
			{
				mTIN = value;
				OnPropertyChanged("TIN");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ZipCode																																*
		//*-----------------------------------------------------------------------*
		private string mZipCode = "";
		/// <summary>
		/// Get/Set the ZipCode of the customer.
		/// </summary>
		[DataMember]
		public string ZipCode
		{
			get { return mZipCode; }
			set
			{
				mZipCode = value;
				OnPropertyChanged("ZipCode");
			}
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
