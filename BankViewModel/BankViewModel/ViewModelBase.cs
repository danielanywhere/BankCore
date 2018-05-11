using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

using SimpleExpressionEvaluator;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	ViewModelBase																														*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Base implementation common to all ViewModels in this application.
	/// </summary>
	public abstract class ViewModelBase
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	OnCanSaveChanged																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Fires the CanSaveChanged event when the value of CanSave has changed.
		/// </summary>
		protected virtual void OnCanSaveChanged()
		{
			if(CanSaveChanged != null)
			{
				CanSaveChanged(this, new EventArgs());
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	val1																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Hard-coded working value 1.
		/// </summary>
		private float mval1 = 16;
		protected virtual float val1
		{
			get { return mval1; }
			set { mval1 = value; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	val2																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Hard-coded working value 2.
		/// </summary>
		private float mval2 = 8;
		protected virtual float val2
		{
			get {  return mval2; }
			set {  mval2 = value; }
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	AccountsAtBranch																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return an array of accounts at the specified branch.
		/// </summary>
		public int[] AccountsAtBranch(bnkBranch branch)
		{
			List<bnkAccount> ac = null;			//	Account collection.
			bankEntities cx = Context;			//	Current context.
			int lp = 0;											//	List Position.
			int[] ro = new int[0];					//	Return object.

			if(branch != null)
			{
				//	Branch is specified.
				ac = (List<bnkAccount>)
					cx.bnkAccounts.Where(r => r.BranchID == branch.BranchID);
				if(ac.Count > 0)
				{
					lp = 0;
					ro = new int[ac.Count];
					foreach(bnkAccount ai in ac)
					{
						ro[lp++] = ai.AccountID;
					}
				}
			}
			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	AccountsOfCustomer																										*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return an array of accounts owned by the specified customer.
		/// </summary>
		public int[] AccountsOfCustomer(bnkCustomer customer)
		{
			List<bnkAccount> ac = null;			//	Account collection.
			bankEntities cx = Context;			//	Current context.
			int lp = 0;											//	List Position.
			int[] ro = new int[0];					//	Return object.

			if(customer != null)
			{
				//	Customer is specified.
				ac = (List<bnkAccount>)
					cx.bnkAccounts.Where(r => r.CustomerID == customer.CustomerID);
				if(ac.Count > 0)
				{
					lp = 0;
					ro = new int[ac.Count];
					foreach(bnkAccount ai in ac)
					{
						ro[lp++] = ai.AccountID;
					}
				}
			}
			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CalcServiceCharge																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Calculate the service charges for the specified account.
		/// </summary>
		/// <param name="account">
		/// Reference to an account for which the service charges will be
		/// calculated.
		/// </param>
		/// <returns>
		/// Floating point value representing the service charge to be applied
		/// to the specified entity.
		/// </returns>
		/// <remarks>
		/// This routine actually has nothing to do with real-world service
		/// charges. The exercise here is to take two values hard-coded in the
		/// application, plus a collection of one or more user-values specified
		/// in the database, to make a resulting value that can be stored as a
		/// transaction.
		/// </remarks>
		/// <example>
		/// See https://github.com/StefH/System.Linq.Dynamic.Core/
		/// wiki/Dynamic-Expressions
		/// </example>
		public decimal CalcServiceCharge(bnkAccount account)
		{
			bankEntities cx = Context;								//	Working Context.
			decimal rv = 0;														//	Return Value.
			List<bnkServiceChargeManager> sc = null;	//	Service Charges.

			if(account != null)
			{
				if(cx.bnkServiceChargeManagers.Count() == 0)
				{
					cx.bnkServiceChargeManagers.Load();
				}
				sc = (List<bnkServiceChargeManager>)
					(cx.bnkServiceChargeManagers.ToList()).
					Where(r => r.AccountID == account.AccountID);
				if(sc.Count > 0)
				{
					rv = CalcServiceCharge(sc);
				}
			}
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Calculate service charges for all accounts domicilied at the specified
		/// branch.
		/// </summary>
		/// <param name="branch">
		/// Reference to the branch for which all service charges should be
		/// calculated.
		/// </param>
		/// <returns>
		/// Floating point value representing the service charge to be applied
		/// to the specified entity.
		/// </returns>
		/// <remarks>
		/// This routine actually has nothing to do with real-world service
		/// charges. The exercise here is to take two values hard-coded in the
		/// application, plus a collection of one or more user-values specified
		/// in the database, to make a resulting value that can be stored as a
		/// transaction.
		/// </remarks>
		/// <example>
		/// See https://github.com/StefH/System.Linq.Dynamic.Core/
		/// wiki/Dynamic-Expressions
		/// </example>
		public decimal CalcServiceCharge(bnkBranch branch)
		{
			int[] aa = new int[0];										//	Accounts at branch.
			bankEntities cx = Context;								//	Working Context.
			decimal rv = 0;														//	Return Value.
			List<bnkServiceChargeManager> sc = null;	//	Service Charges.

			if(branch != null)
			{
				if(cx.bnkServiceChargeManagers.Count() == 0)
				{
					cx.bnkServiceChargeManagers.Load();
				}
				aa = AccountsAtBranch(branch);
				if(aa.Length > 0)
				{
					sc = (List<bnkServiceChargeManager>)
						(cx.bnkServiceChargeManagers.ToList()).
						Where(r => aa.Contains(r.AccountID));
					if(sc.Count > 0)
					{
						rv = CalcServiceCharge(sc);
					}
				}
			}
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Calculate the service charges for all accounts registered to the
		/// specified customer.
		/// </summary>
		/// <param name="customer">
		/// Reference to the customer whose accounts should be calculated for
		/// service charge.
		/// </param>
		/// <returns>
		/// Floating point value representing the service charge to be applied
		/// to the specified entity.
		/// </returns>
		/// <remarks>
		/// This routine actually has nothing to do with real-world service
		/// charges. The exercise here is to take two values hard-coded in the
		/// application, plus a collection of one or more user-values specified
		/// in the database, to make a resulting value that can be stored as a
		/// transaction.
		/// </remarks>
		/// <example>
		/// See https://github.com/StefH/System.Linq.Dynamic.Core/
		/// wiki/Dynamic-Expressions
		/// </example>
		public decimal CalcServiceCharge(bnkCustomer customer)
		{
			int[] ca = new int[0];										//	Accounts with customer.
			bankEntities cx = Context;								//	Working Context.
			decimal rv = 0;														//	Return Value.
			List<bnkServiceChargeManager> sc = null;	//	Service Charges.

			if(customer != null)
			{
				if(cx.bnkServiceChargeManagers.Count() == 0)
				{
					cx.bnkServiceChargeManagers.Load();
				}
				ca = AccountsOfCustomer(customer);
				if(ca.Length > 0)
				{
					sc = (List<bnkServiceChargeManager>)
						(cx.bnkServiceChargeManagers.ToList()).
						Where(r => ca.Contains(r.AccountID));
					if(sc.Count > 0)
					{
						rv = CalcServiceCharge(sc);
					}
				}
			}
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Calculate the service charges for the specified account.
		/// </summary>
		/// <param name="managers">
		/// Reference to a collection of user-defined service charge managers to
		/// tally.
		/// </param>
		/// <returns>
		/// Floating point value representing the service charge to be applied
		/// to the entity in context.
		/// </returns>
		/// <remarks>
		/// This routine actually has nothing to do with real-world service
		/// charges. The exercise here is to take two values hard-coded in the
		/// application, plus a collection of one or more user-values specified
		/// in the database, to make a resulting value that can be stored as a
		/// transaction.
		/// </remarks>
		/// <example>
		/// See https://github.com/StefH/System.Linq.Dynamic.Core/
		/// wiki/Dynamic-Expressions
		/// </example>
		public decimal CalcServiceCharge(bnkServiceChargeManager manager)
		{
			bankEntities cx = Context;								//	Working Context.
			ExpressionEvaluator ev = new ExpressionEvaluator();
			decimal rv = 0;														//	Return Value.
			string se = "";														//	Working Expression.
			bnkServiceChargeManager si = manager;			//	Abbreviated value.

			if(manager != null)
			{
				//	Get the current charge template.
				se = si.ServiceChargeExpression;
				//	Insert the hard-coded values.
				se = se.Replace("{v1}", val1.ToString("0.0")).
					Replace("{v2}", val2.ToString("0.0"));
				//	Get the solution.
				//	Note. We could just as easily place value 1 and value 2
				//	replacement values in the arguments list using @0 and @1
				//	designation placeholder syntax.
				rv += ev.Evaluate(se);
			}
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Calculate the service charges for the specified account.
		/// </summary>
		/// <param name="managers">
		/// Reference to a collection of user-defined service charge managers to
		/// tally.
		/// </param>
		/// <returns>
		/// Floating point value representing the service charge to be applied
		/// to the entity in context.
		/// </returns>
		/// <remarks>
		/// This routine actually has nothing to do with real-world service
		/// charges. The exercise here is to take two values hard-coded in the
		/// application, plus a collection of one or more user-values specified
		/// in the database, to make a resulting value that can be stored as a
		/// transaction.
		/// </remarks>
		/// <example>
		/// See https://github.com/StefH/System.Linq.Dynamic.Core/
		/// wiki/Dynamic-Expressions
		/// </example>
		public decimal CalcServiceCharge(List<bnkServiceChargeManager> managers)
		{
			bankEntities cx = Context;								//	Working Context.
			decimal rv = 0;															//	Return Value.

			if(managers != null)
			{
				//	Service charges exist for this record.
				foreach(bnkServiceChargeManager si in managers)
				{
					rv += CalcServiceCharge(si);
				}
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CanSave																																*
		//*-----------------------------------------------------------------------*
		private bool mCanSave = false;
		/// <summary>
		/// Get/Set a value indicating whether changes can be saved.
		/// </summary>
		public bool CanSave
		{
			get
			{
				bool rv = false;				//	Return Value.
				if(mContext != null && mContext.ChangeTracker.HasChanges())
				{
					rv = true;
				}
				if(rv != mCanSave)
				{
					mCanSave = rv;
					OnCanSaveChanged();
				}
				return rv;
			}
			set
			{
				bool bc = (value != mCanSave);
				mCanSave = value;
				if(bc)
				{
					OnCanSaveChanged();
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	CanSaveChanged																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Raised when the value of CanSave has changed.
		/// </summary>
		public event EventHandler CanSaveChanged;
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Close																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Close the View Model instance.
		/// </summary>
		public void Close()
		{
			if(mContext != null)
			{
				mContext.Dispose();
				mContext = null;
			}
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
		//*	LoadAccounts																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all accounts currently registered.
		/// </summary>
		public ObservableCollection<bnkAccount> LoadAccounts()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkAccount> ro = null;

			if(cx != null)
			{
				cx.bnkAccounts.Load();
				ro = cx.bnkAccounts.Local;
			}

			return ro;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Load all accounts for the specified customer.
		/// </summary>
		public ObservableCollection<bnkAccount> LoadAccounts(bnkCustomer customer)
		{
			bankEntities cx = Context;
			ObservableCollection<bnkAccount> ro = null;

			if(cx != null && customer != null)
			{
				cx.bnkAccounts.Where(c => c.CustomerID == customer.CustomerID);
				ro = cx.bnkAccounts.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadBranches																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the branches.
		/// </summary>
		public ObservableCollection<bnkBranch> LoadBranches()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkBranch> ro = null;

			if(cx != null)
			{
				cx.bnkBranches.Load();
				ro = cx.bnkBranches.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadCustomers																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all customers currently registered.
		/// </summary>
		public ObservableCollection<bnkCustomer> LoadCustomers()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkCustomer> ro = null;

			if(cx != null)
			{
				cx.bnkCustomers.Load();
				ro = cx.bnkCustomers.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadEmployees																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the employees.
		/// </summary>
		public ObservableCollection<bnkEmployee> LoadEmployees()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkEmployee> ro = null;

			if(cx != null)
			{
				cx.bnkEmployees.Load();
				ro = cx.bnkEmployees.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadServiceChargeManagers																							*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the service charge management entries.
		/// </summary>
		public ObservableCollection<bnkServiceChargeManager>
			LoadServiceChargeManagers()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkServiceChargeManager> ro = null;

			if(cx != null)
			{
				cx.bnkServiceChargeManagers.Load();
				ro = cx.bnkServiceChargeManagers.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadTransactions																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the transactions.
		/// </summary>
		public ObservableCollection<bnkTransaction> LoadTransactions()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkTransaction> ro = null;

			if(cx != null)
			{
				cx.bnkTransactions.Load();
				ro = cx.bnkTransactions.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadTransactionTypes																									*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the transaction types.
		/// </summary>
		public ObservableCollection<bnkTransactionType> LoadTransactionTypes()
		{
			bankEntities cx = Context;
			ObservableCollection<bnkTransactionType> ro = null;

			if(cx != null)
			{
				cx.bnkTransactionTypes.Load();
				ro = cx.bnkTransactionTypes.Local;
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*
}
