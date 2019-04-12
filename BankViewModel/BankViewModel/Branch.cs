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
	//*	BranchCollection																												*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of BranchItem Items.
	/// </summary>
	public class BranchCollection : ObservableCollection<BranchItem>
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
		/// Create a new Instance of the BranchCollection Item.
		/// </summary>
		public BranchCollection()
		{
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the BranchCollection Item.
		/// </summary>
		public BranchCollection(bankEntities context)
		{
			mContext = context;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Add																																		*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new BranchItem to the collection.
		/// </summary>
		public new void Add(BranchItem branch)
		{
			bnkBranch ci = null;
			if(branch != null)
			{
				base.Add(branch);
				if(branch.EntityItem == null && mContext != null)
				{
					branch.HasPresetValues = true;
					ci = new bnkBranch();
					mContext.bnkBranches.Add(ci);
					branch.EntityItem = ci;
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AddOrUpdate																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a new BranchItem to the collection, or update the existing one.
		/// </summary>
		public BranchItem AddOrUpdate(BranchItem branch)
		{
			bnkBranch ci = null;			// Internal Item.
			BranchItem cx = null;			// Existing Item.
			if(branch != null)
			{
				cx = this.First(r => r.BranchID == branch.BranchID);
				if(cx == null)
				{
					// Create new item.
					base.Add(branch);
					if(branch.EntityItem == null && mContext != null)
					{
						branch.HasPresetValues = true;
						ci = new bnkBranch();
						mContext.bnkBranches.Add(ci);
						branch.EntityItem = ci;
					}
					cx = branch;
				}
				else
				{
					// Item already existed.
					branch.TransferProperties(cx);
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
		/// Return a value indicating whether the specified branch exists in
		/// this collection.
		/// </summary>
		public bool Exists(int branchID)
		{
			bool rv = (this.First(r => r.BranchID == branchID) != null);
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Load																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all branches.
		/// </summary>
		public bool Load()
		{
			bankEntities cx = Context;
			bool rv = false;   // Return Value.

			this.Clear();
			cx.bnkBranches.Load();
			foreach(bnkBranch ci in cx.bnkBranches)
			{
				this.Add(new BranchItem(this, ci));
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Remove																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Remove the specified branch from the collection.
		/// </summary>
		public new void Remove(BranchItem branch)
		{
			BranchItem ci = null;

			if(branch != null)
			{
				// Value is specified.
				ci = this.First(r => r.BranchID == branch.BranchID);
				if(ci != null)
				{
					// Member item found.
					if(ci.EntityItem != null && mContext != null)
					{
						mContext.bnkBranches.Remove((bnkBranch)ci.EntityItem);
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
		public void SetItemModified(BranchItem item)
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
	//*	BranchItem																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Information about the branch.
	/// </summary>
	[DataContract]
	public class BranchItem : TransientItem
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private static List<string> BranchItemPropertyNames =
			new List<string>(
			new string[] { "BranchID", "BranchTicket",
				"Name", "Address", "City", "State", "ZipCode" });

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
		/// Create a new Instance of the BranchItem Item.
		/// </summary>
		public BranchItem()
		{
			PropertyNames = BranchItemPropertyNames;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new Instance of the BranchItem Item.
		/// </summary>
		public BranchItem(BranchCollection parent, bnkBranch branch) :
			this()
		{
			mParent = parent;
			EntityItem = branch;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Address																																*
		//*-----------------------------------------------------------------------*
		private string mAddress = "";
		/// <summary>
		/// Get/Set the Address of the branch.
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
		//*	BranchID																															*
		//*-----------------------------------------------------------------------*
		private int mBranchID = 0;
		/// <summary>
		/// Get/Set the BranchID of the branch.
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
		//*	BranchTicket																													*
		//*-----------------------------------------------------------------------*
		private Guid mBranchTicket = Guid.Empty;
		/// <summary>
		/// Get/Set the BranchTicket of the branch.
		/// </summary>
		[DataMember]
		public Guid BranchTicket
		{
			get { return mBranchTicket; }
			set
			{
				mBranchTicket = value;
				OnPropertyChanged("BranchTicket");
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	City																																	*
		//*-----------------------------------------------------------------------*
		private string mCity = "";
		/// <summary>
		/// Get/Set the City of the branch.
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
		//*	Name																																	*
		//*-----------------------------------------------------------------------*
		private string mName = "";
		/// <summary>
		/// Get/Set the Name of the branch.
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
		private BranchCollection mParent = null;
		/// <summary>
		/// Get/Set a reference to the parent collection to which this item is
		/// attached.
		/// </summary>
		public BranchCollection Parent
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
		/// Get/Set the State of the branch.
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
		//*	ZipCode																																*
		//*-----------------------------------------------------------------------*
		private string mZipCode = "";
		/// <summary>
		/// Get/Set the ZipCode of the branch.
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
