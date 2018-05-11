using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

using BankViewModel;

namespace BankWPF
{
	//*-------------------------------------------------------------------------*
	//*	AccountWindow																														*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Window for handling account-based information.
	/// </summary>
	/// <remarks>
	/// Interaction logic for AccountWindow.xaml
	/// </remarks>
	public partial class AccountWindow : Window
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		/// <summary>
		/// Link to the collection of branches available for the account.
		/// </summary>
		System.Windows.Data.CollectionViewSource mBranchItemViewSource = null;
		System.Windows.Data.CollectionViewSource mEmployeeItemViewSource = null;
		System.Windows.Data.CollectionViewSource mTransactionItemViewSource = null;
		System.Windows.Data.CollectionViewSource mServiceChargeViewSource = null;

		//*-----------------------------------------------------------------------*
		//*	Window_Loaded																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Called when the window has loaded and is ready to display for the first
		/// time.
		/// </summary>
		/// <param name="sender">
		/// The object raising this event.
		/// </param>
		/// <param name="e">
		/// Routed Event Arguments.
		/// </param>
		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			//	Link the model resources.
			mBranchItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("branchItemViewSource")));
			mEmployeeItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("employeeItemViewSource")));
			mTransactionItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("transactionItemViewSource")));
			mServiceChargeViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("chargeItemViewSource")));
			mBranchItemViewSource.Source = mViewModel.LoadBranches();
			mEmployeeItemViewSource.Source = mViewModel.LoadEmployees();
		}
		//*-----------------------------------------------------------------------*

		//	TODO: Load Transactions and ServiceCharges for context on tab switch.
		//*-----------------------------------------------------------------------*
		//*	TabItem_GotFocus																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// A TabItem got focus.
		/// </summary>
		/// <param name="sender">
		/// The object raising this event.
		/// </param>
		/// <param name="e">
		/// Routed Event Arguments.
		/// </param>
		/// <remarks>
		/// Code-behind wiring to ultra-lazy load for items not on the first page.
		/// </remarks>
		private void TabItem_GotFocus(object sender, RoutedEventArgs e)
		{
			string sn = "";			//	Original Source Name.

			if(e.OriginalSource is TabItem)
			{
				using(new WaitCursor())
				{
					sn = ((TabItem)e.OriginalSource).Name;
					switch(sn)
					{
						case "tabTransactions":
							if(mTransactionItemViewSource.Source == null)
							{
								//	Transaction data hasn't yet been loaded.
								mTransactionItemViewSource.Source =
									mViewModel.LoadTransactions(mAccount);
							}
							break;
						case "tabServiceCharges":
							if(mServiceChargeViewSource.Source == null)
							{
								//	Service Charge data hasn't yet been loaded.
								mServiceChargeViewSource.Source =
									mViewModel.LoadServiceCharges(mAccount);
							}
							break;
						default:
							break;
					}
				}
			}
		}
		//*-----------------------------------------------------------------------*

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
		/// Create a new Instance of the AccountWindow Item.
		/// </summary>
		public AccountWindow()
		{
			InitializeComponent();
			mViewModel = new AccountViewModel();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Account																																*
		//*-----------------------------------------------------------------------*
		private bnkAccount mAccount = null;
		/// <summary>
		/// Get/Set a reference to the Account in focus.
		/// </summary>
		public bnkAccount Account
		{
			get { return mAccount; }
			set
			{
				mAccount = value;
				FrameworkElement res =
					(FrameworkElement)this.FindName("tabDetailsGrid");
				if(res != null)
				{
					//	The Grid back for the Details tab has been found.
					res.DataContext = mAccount;
				}
			}
		}
		//*-----------------------------------------------------------------------*


		//*-----------------------------------------------------------------------*
		//*	ViewModel																															*
		//*-----------------------------------------------------------------------*
		private AccountViewModel mViewModel = null;
		/// <summary>
		/// Get/Set a reference to the View Model driving this window.
		/// </summary>
		public AccountViewModel ViewModel
		{
			get { return mViewModel; }
			set { mViewModel = value; }
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*
}
