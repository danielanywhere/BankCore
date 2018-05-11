using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	AccountViewModel																												*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// ViewModel for Account-based Window.
	/// </summary>
	public class AccountViewModel : ViewModelBase
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
		//*	LoadServiceChargeManagers																							*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load all of the service charge management entries for the account.
		/// </summary>
		/// <param name="account">
		/// Reference to the account for which service charge managers will be
		/// loaded.
		/// </param>
		public ObservableCollection<bnkServiceChargeManager>
			LoadServiceChargeManagers(bnkAccount account)
		{
			bankEntities cx = Context;
			ObservableCollection<bnkServiceChargeManager> ro = null;

			if(cx != null)
			{
				if(account != null)
				{
					cx.bnkServiceChargeManagers.Where(
						r => r.AccountID == account.AccountID).Load();
				}
				ro = cx.bnkServiceChargeManagers.Local;
			}
			if(ro == null)
			{
				ro = new ObservableCollection<bnkServiceChargeManager>();
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadServiceCharges																										*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load the service charges for the specified account.
		/// </summary>
		public ObservableCollection<ServiceChargeItem> LoadServiceCharges(
			bnkAccount account)
		{
			bankEntities cx = Context;				//	Local context.
			ObservableCollection<ServiceChargeItem> ro =
				new ObservableCollection<ServiceChargeItem>();	//	Return object.
			ObservableCollection<bnkServiceChargeManager> sc = null;
			ServiceChargeItem si = null;			//	Current charge.

			if(cx != null)
			{
				if(account != null)
				{
					sc = LoadServiceChargeManagers(account);
					if(sc != null && sc.Count > 0)
					{
						//	Service charges found for this instance.
						foreach(bnkServiceChargeManager ci in sc)
						{
							si = new ServiceChargeItem();
							si.Source = ci.ServiceChargeExpression;
							si.Value = CalcServiceCharge(ci);
							//	Add the finished item to the collection.
							ro.Add(si);
						}
					}
				}
			}
			return ro;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	LoadTransactions																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Load transactions specific to the current account.
		/// </summary>
		/// <param name="account">
		/// Accout for which transactions will be loaded.
		/// </param>
		public ObservableCollection<bnkTransaction> LoadTransactions(
			bnkAccount account)
		{
			bankEntities cx = Context;
			ObservableCollection<bnkTransaction> ro = null;

			if(cx != null)
			{
				if(account != null)
				{
					cx.bnkTransactions.
						Where(r => r.AccountID == account.AccountID).
						Load();
				}
				ro = cx.bnkTransactions.Local;
			}
			if(ro == null)
			{
				ro = new ObservableCollection<bnkTransaction>();
			}

			return ro;
		}
		//*-----------------------------------------------------------------------*


	}
	//*-------------------------------------------------------------------------*
}
