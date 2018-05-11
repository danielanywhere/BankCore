using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	TransientCollection																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of TransientItem Items.
	/// </summary>
	public class TransientCollection : List<TransientItem>
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


	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	TransientItem																														*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Interconnection between an active entity item and a normal imperative
	/// class.
	/// </summary>
	[DataContract]
	public class TransientItem : INotifyPropertyChanged
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	NotifyBusy																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Flag that protects the notifier from entering a feedback loop.
		/// </summary>
		protected bool mNotifyBusy = false;
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	OnPropertyChanged																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Raises the PropertyChanged event when the value of a property has
		/// changed.
		/// </summary>
		protected virtual void OnPropertyChanged(string propertyName)
		{
			if(!mNotifyBusy)
			{
				mNotifyBusy = true;
				//	Wire the entity update.
				if(mEntityItem != null)
				{
					WriteEntity(propertyName);
				}
				//	Wire the event for parent and listeners.
				if(PropertyChanged != null)
				{
					PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
				}
				mNotifyBusy = false;
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ReadEntity																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Read the names of all properties from the associated entity.
		/// </summary>
		protected virtual void ReadEntity()
		{
			object ob = null;			//	Transient object.
			if(mEntityItem != null &&
				mPropertyNames != null && mPropertyNames.Count > 0)
			{
				mNotifyBusy = true;
				foreach(string pn in mPropertyNames)
				{
					ob = mEntityItem.GetType().GetProperty(pn).
						GetValue(mEntityItem, null);
					this[pn] = ob;
				}
				mNotifyBusy = false;
			}
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Read the value of the local property from the associated Entity.
		/// </summary>
		protected virtual void ReadEntity(string propertyName)
		{
			object ob = null;			//	Transient object.

			if(mEntityItem != null)
			{
				ob = mEntityItem.GetType().GetProperty(propertyName).
					GetValue(mEntityItem, null);
				this[propertyName] = ob;
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	WriteEntity																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Write the value of all local properties to the associated Entity.
		/// </summary>
		protected virtual void WriteEntity()
		{
			object ob = null;			//	Transient object.

			if(mEntityItem != null &&
				mPropertyNames != null && mPropertyNames.Count > 0)
			{
				mNotifyBusy = true;
				foreach(string pn in mPropertyNames)
				{
					ob = this[pn];
					mEntityItem.GetType().GetProperty(pn).
						SetValue(mEntityItem, ob, null);
				}
				mNotifyBusy = false;
			}
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Write the value of the local property to the associated Entity.
		/// </summary>
		protected virtual void WriteEntity(string propertyName)
		{
			object ob = null;			//	Transient object.

			if(mEntityItem != null)
			{
				ob = this[propertyName];
				mEntityItem.GetType().GetProperty(propertyName).
					SetValue(mEntityItem, ob, null);
			}
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Indexer																															*
		//*-----------------------------------------------------------------------*
		// System.Reflection required.
		/// <summary>
		/// Retrieve or set the value of the specified property from the object.
		/// </summary>
		public object this[string propertyName]
		{
			get
			{
				return this.GetType().GetProperty(propertyName).GetValue(this, null);
			}
			set
			{
				PropertyInfo pi = this.GetType().GetProperty(propertyName);

				if(pi.PropertyType.Equals(typeof(Decimal)) &&
					value.GetType().Equals(typeof(Double)))
				{
					//	Explicit conversion from double to decimal required.
					pi.SetValue(this, Convert.ToDecimal(value), null);
				}
				else
				{
					pi.SetValue(this, value, null);
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	EntityItem																														*
		//*-----------------------------------------------------------------------*
		private object mEntityItem = null;
		/// <summary>
		/// Get/Set a reference to the entity to which this item is associated.
		/// </summary>
		public object EntityItem
		{
			get { return mEntityItem; }
			set
			{
				mEntityItem = value;
				if(HasPresetValues)
				{
					WriteEntity();
				}
				else
				{
					ReadEntity();
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	HasPresetValues																												*
		//*-----------------------------------------------------------------------*
		private bool mHasPresetValues = false;
		/// <summary>
		/// Get/Set a value indicating whether the local object already has preset
		/// values when being assigned to the entity.
		/// </summary>
		public bool HasPresetValues
		{
			get { return mHasPresetValues; }
			set { mHasPresetValues = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PropertyChanged																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Fired when the value of a property has changed.
		/// </summary>
		public event PropertyChangedEventHandler PropertyChanged;
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PropertyNames																													*
		//*-----------------------------------------------------------------------*
		private List<string> mPropertyNames = null;
		/// <summary>
		/// Get/Set a reference to the list of wired property names for this
		/// instance.
		/// </summary>
		/// <remarks>
		/// The list of property names for the item should be maintained at a
		/// static scope.
		/// </remarks>
		public List<string> PropertyNames
		{
			get { return mPropertyNames; }
			set { mPropertyNames = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	TransferProperties																										*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Write the value of all local properties to the specified partner.
		/// </summary>
		public virtual void TransferProperties(TransientItem target)
		{
			object ob = null;			//	Transient object.

			if(mPropertyNames != null && mPropertyNames.Count > 0 && target != null)
			{
				foreach(string pn in mPropertyNames)
				{
					ob = this[pn];
					try
					{
						target.GetType().GetProperty(pn).
							SetValue(target, ob, null);
					}
					catch { }
				}
			}
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*
}
