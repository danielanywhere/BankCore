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
	//*	EmployeeCollection																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of EmployeeItem Items.
	/// </summary>
	public class EmployeeCollection : ObservableCollection<EmployeeItem>
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
		/// Create a new Instance of the EmployeeCollection Item.
		/// </summary>
		public EmployeeCollection()
		{
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the EmployeeCollection Item.
		/// </summary>
		public EmployeeCollection(bankEntities context)
		{
			mContext = context;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Add																																		*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new EmployeeItem to the collection.
		/// </summary>
		public new void Add(EmployeeItem employee)
		{
			bnkEmployee ci = null;
			if(employee != null)
			{
				base.Add(employee);
				if(employee.EntityItem == null && mContext != null)
				{
					employee.HasPresetValues = true;
					ci = new bnkEmployee();
					mContext.bnkEmployees.Add(ci);
					employee.EntityItem = ci;
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AddOrUpdate																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new EmployeeItem to the collection, or update the existing one.
		/// </summary>
		public EmployeeItem AddOrUpdate(EmployeeItem employee)
		{
			bnkEmployee ci = null;			// Internal Item.
			EmployeeItem cx = null;			// Existing Item.
			if(employee != null)
			{
				cx = this.First(r => r.EmployeeID == employee.EmployeeID);
				if(cx == null)
				{
					// Create new item.
					base.Add(employee);
					if(employee.EntityItem == null && mContext != null)
					{
						employee.HasPresetValues = true;
						ci = new bnkEmployee();
						mContext.bnkEmployees.Add(ci);
						employee.EntityItem = ci;
					}
					cx = employee;
				}
				else
				{
					// Item already existed.
					employee.TransferProperties(cx);
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
		/// Return a value indicating whether the specified employee exists in
		/// this collection.
		/// </summary>
		public bool Exists(int employeeID)
		{
			bool rv = (this.First(r => r.EmployeeID == employeeID) != null);
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Load																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all employees.
		/// </summary>
		public bool Load()
		{
			bankEntities cx = Context;
			bool rv = false;   // Return Value.

			this.Clear();
			cx.bnkEmployees.Load();
			foreach(bnkEmployee ci in cx.bnkEmployees)
			{
				this.Add(new EmployeeItem(this, ci));
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Remove																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Remove the specified employee from the collection.
		/// </summary>
		public new void Remove(EmployeeItem employee)
		{
			EmployeeItem ci = null;

			if(employee != null)
			{
				// Value is specified.
				ci = this.First(r => r.EmployeeID == employee.EmployeeID);
				if(ci != null)
				{
					// Member item found.
					if(ci.EntityItem != null && mContext != null)
					{
						mContext.bnkEmployees.Remove((bnkEmployee)ci.EntityItem);
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
		public void SetItemModified(EmployeeItem item)
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
	//*	EmployeeItem																														*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Information about the employee.
	/// </summary>
	[DataContract]
	public class EmployeeItem : TransientItem
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private static List<string> EmployeeItemPropertyNames =
			new List<string>(
			new string[] { "EmployeeID", "EmployeeTicket", "FirstName", "LastName",
			"DateStarted", "DateEnded", "Title", "TIN" });

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
		/// Create a new Instance of the EmployeeItem Item.
		/// </summary>
		public EmployeeItem()
		{
			PropertyNames = EmployeeItemPropertyNames;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the EmployeeItem Item.
		/// </summary>
		public EmployeeItem(EmployeeCollection parent, bnkEmployee employee) :
			this()
		{
			mParent = parent;
			EntityItem = employee;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DateEnded																															*
		//*-----------------------------------------------------------------------*
		private DateTime mDateEnded = DateTime.MinValue;
		/// <summary>
		/// Get/Set the DateEnded of the employee.
		/// </summary>
		[DataMember]
		public DateTime DateEnded
		{
			get { return mDateEnded; }
			set
			{
				mDateEnded = value;
				OnPropertyChanged("DateEnded");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DateStarted																														*
		//*-----------------------------------------------------------------------*
		private DateTime mDateStarted = DateTime.MinValue;
		/// <summary>
		/// Get/Set the DateStarted of the employee.
		/// </summary>
		[DataMember]
		public DateTime DateStarted
		{
			get { return mDateStarted; }
			set
			{
				mDateStarted = value;
				OnPropertyChanged("DateStarted");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DisplayName																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get the DisplayName of the employee.
		/// </summary>
		[DataMember]
		public string DisplayName
		{
			get
			{
				return (FirstName.Length > 0 && LastName.Length > 0 ?
				FirstName + " " + LastName : FirstName + LastName);
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	EmployeeID																														*
		//*-----------------------------------------------------------------------*
		private int mEmployeeID = 0;
		/// <summary>
		/// Get/Set the EmployeeID of the employee.
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
		//*	EmployeeTicket																												*
		//*-----------------------------------------------------------------------*
		private Guid mEmployeeTicket = Guid.Empty;
		/// <summary>
		/// Get/Set the EmployeeTicket of the employee.
		/// </summary>
		[DataMember]
		public Guid EmployeeTicket
		{
			get { return mEmployeeTicket; }
			set
			{
				mEmployeeTicket = value;
				OnPropertyChanged("EmployeeTicket");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	FirstName																															*
		//*-----------------------------------------------------------------------*
		private string mFirstName = "";
		/// <summary>
		/// Get/Set the FirstName of the employee.
		/// </summary>
		[DataMember]
		public string FirstName
		{
			get { return mFirstName; }
			set
			{
				mFirstName = value;
				OnPropertyChanged("FirstName");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LastName																															*
		//*-----------------------------------------------------------------------*
		private string mLastName = "";
		/// <summary>
		/// Get/Set the LastName of the employee.
		/// </summary>
		[DataMember]
		public string LastName
		{
			get { return mLastName; }
			set
			{
				mLastName = value;
				OnPropertyChanged("LastName");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Parent																																*
		//*-----------------------------------------------------------------------*
		private EmployeeCollection mParent = null;
		/// <summary>
		/// Get/Set a reference to the parent collection to which this item is
		/// attached.
		/// </summary>
		public EmployeeCollection Parent
		{
			get { return mParent; }
			set { mParent = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	TIN																																		*
		//*-----------------------------------------------------------------------*
		private string mTIN = "";
		/// <summary>
		/// Get/Set the TIN of the employee.
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
		//*	Title																																	*
		//*-----------------------------------------------------------------------*
		private string mTitle = "";
		/// <summary>
		/// Get/Set the Title of the employee.
		/// </summary>
		[DataMember]
		public string Title
		{
			get { return mTitle; }
			set
			{
				mTitle = value;
				OnPropertyChanged("Title");
			}
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
