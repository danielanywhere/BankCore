using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace BankWPF
{
	//*-------------------------------------------------------------------------*
	//*	WaitCursor																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Provides hourglass wait cursor usage within a using block during long
	/// operations.
	/// </summary>
	/// <example>
	/// <code>using(new WaitCursor()) { /* Long-running code */ ... }</code>
	/// </example>
	public class WaitCursor : IDisposable
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private Cursor mPreviousCursor;

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
		/// Create a new Instance of the WaitCursor Item.
		/// </summary>
		public WaitCursor()
		{
			mPreviousCursor = Mouse.OverrideCursor;
			Mouse.OverrideCursor = Cursors.Wait;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Dispose																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Disposes of the object when done.
		/// </summary>
		/// <remarks>
		/// This is a member of the IDisposable interface.
		/// </remarks>
		public void Dispose()
		{
			Mouse.OverrideCursor = mPreviousCursor;
		}
		//*-----------------------------------------------------------------------*
	}
	//*-------------------------------------------------------------------------*
}
