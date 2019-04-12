using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	IDTextCollection																												*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Collection of IDTextItem Items.
	/// </summary>
	public class IDTextCollection : ObservableCollection<IDTextItem>
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
		//*	AddRange																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Add a set of items to the collection, populating locally by ID and
		/// Text field names.
		/// </summary>
		public void AddRange<T>(IEnumerable<T> items, 
			string idName, string textName)
		{
			IDTextItem ti = null;
			if(items != null && items.Count() > 0)
			{
				//	Items can be added.
				foreach(object ob in items)
				{
					ti = new IDTextItem();
					try
					{
						ti.ID =	Convert.ToInt32(ob.GetType().GetProperty(idName).
							GetValue(ob, null));
					}
					catch { }
					try
					{
						ti.Text = Convert.ToString(ob.GetType().GetProperty(textName).
							GetValue(ob, null));
					}
					catch { }
					this.Add(ti);
				}
			}
		}
		//*-----------------------------------------------------------------------*


	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	IDTextItem																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Generic Identification and Text for a single row of data.
	/// </summary>
	public class IDTextItem
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
		//*	Assign																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Cast the provided object to an IDTextItem.
		/// </summary>
		/// <param name="item">
		/// Reference to the object to convert.
		/// </param>
		/// <param name="idName">
		/// Name of the source ID property.
		/// </param>
		/// <param name="textName">
		/// Name of the source Text property.
		/// </param>
		/// <returns>
		/// A newly created and assigned object.
		/// </returns>
		public static IDTextItem Assign(object item,
			string idName, string textName)
		{
			IDTextItem ti = null;
			if(item != null)
			{
				//	Item can be added.
				ti = new IDTextItem();
				try
				{
					ti.ID =	Convert.ToInt32(item.GetType().GetProperty(idName).
						GetValue(item, null));
				}
				catch { }
				try
				{
					ti.Text = Convert.ToString(item.GetType().GetProperty(textName).
						GetValue(item, null));
				}
				catch { }
			}
			return ti;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ID																																		*
		//*-----------------------------------------------------------------------*
		private int mID = 0;
		/// <summary>
		/// Get/Set the ID of this item.
		/// </summary>
		public int ID
		{
			get { return mID; }
			set { mID = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Text																																	*
		//*-----------------------------------------------------------------------*
		private string mText = "";
		/// <summary>
		/// Get/Set the Text of this item.
		/// </summary>
		public string Text
		{
			get { return mText; }
			set { mText = value; }
		}
		//*-----------------------------------------------------------------------*


	}
	//*-------------------------------------------------------------------------*
}
