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
	//*	MainWindow																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// The main window for this application session.
	/// </summary>
	/// <remarks>
	/// Interaction logic for MainWindow.xaml
	/// </remarks>
	public partial class MainWindow : Window
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		/// <summary>
		/// View Model collection hosting Accounts.
		/// </summary>
		private System.Windows.Data.CollectionViewSource mAccountItemViewSource =
			null;
		/// <summary>
		/// View Model collection hosting Branches.
		/// </summary>
		private System.Windows.Data.CollectionViewSource mBranchItemViewSource =
			null;
		/// <summary>
		/// View Model collection hosting Customers.
		/// </summary>
		private System.Windows.Data.CollectionViewSource mCustomerItemViewSource =
			null;
		/// <summary>
		/// View Model collection hosting Employees.
		/// </summary>
		private System.Windows.Data.CollectionViewSource mEmployeeItemViewSource =
			null;

		//*-----------------------------------------------------------------------*
		//*	Row_DoubleClick																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Data Grid Row has been double clicked.
		/// </summary>
		/// <param name="sender">
		/// The object raising this event.
		/// </param>
		/// <param name="e">
		/// Mouse Button Event Arguments.
		/// </param>
		/// <remarks>
		/// Opening a new window is purely the work of the View. Although setting
		/// the data key for the form might be seen as the work of the ViewModel,
		/// a significant number of steps are saved by initiating the key from
		/// here.
		/// </remarks>
		private void Row_DoubleClick(object sender, MouseButtonEventArgs e)
		{
			if(sender != null && sender is DataGridRow)
			{
				DataGridRow row = (DataGridRow)sender;
				if(row.Item != null)
				{
					switch(row.Item.GetType().ToString())
					{
						case "BankViewModel.bnkCustomer":
							//mViewModel.ProjectOpenCommand((ProjectItem)row.Item);
							break;
						case "BankViewModel.bnkAccount":
							WindowOpenAccount((bnkAccount)row.Item);
							break;
						case "BankViewModel.bnkBranch":
							break;
						case "BankViewMode.bnkEmployee":
							break;
						default:
							break;
					}
				}
			}
		}
		//*-----------------------------------------------------------------------*

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
						case "tabAccounts":
							if(mAccountItemViewSource.Source == null)
							{
								//	Account data hasn't yet been loaded.
								mAccountItemViewSource.Source = mViewModel.LoadAccounts();
							}
							break;
						case "tabBranches":
							if(mBranchItemViewSource.Source == null)
							{
								//	Branch data hasn't yet been loaded.
								mBranchItemViewSource.Source = mViewModel.LoadBranches();
							}
							break;
						case "tabEmployees":
							if(mEmployeeItemViewSource.Source == null)
							{
								//	Employee data hasn't yet been loaded.
								mEmployeeItemViewSource.Source = mViewModel.LoadEmployees();
							}
							break;
						default:
							break;
					}
				}
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Window_Loaded																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Called when the Window has loaded and is ready to display for the first
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
			mCustomerItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("customerItemViewSource")));
			mAccountItemViewSource= ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("accountItemViewSource")));
			mBranchItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("branchItemViewSource")));
			mEmployeeItemViewSource = ((System.Windows.Data.CollectionViewSource)
				(this.FindResource("employeeItemViewSource")));
			//	Load the front page. All other tabs use ultra-lazy load.
			mCustomerItemViewSource.Source = mViewModel.LoadCustomers();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	WindowOpenAccount																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Open an Account Window.
		/// </summary>
		public void WindowOpenAccount(bnkAccount account)
		{
			AccountWindow tw = new AccountWindow();

			tw.Account = account;
			tw.Show();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	WindowOpenBranch																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Open a Branch Window.
		/// </summary>
		public void WindowOpenBranch(bnkBranch branch)
		{
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	WindowOpenCustomer																										*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Open a Customer Window.
		/// </summary>
		public void WindowOpenCustomer(bnkCustomer customer)
		{
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	WindowOpenEmployee																										*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Open an Employee Window.
		/// </summary>
		public void WindowOpenEmployee(bnkEmployee employee)
		{
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	OnClosing																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Called when the form is closing.
		/// </summary>
		/// <param name="e">
		/// Cancel Event Arguments.
		/// </param>
		protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
		{
			base.OnClosing(e);
			//this._context.Dispose();
			mViewModel.Close();
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new Instance of the MainWindow Item.
		/// </summary>
		public MainWindow()
		{
			InitializeComponent();
			mViewModel = new MainViewModel();

		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ViewModel																															*
		//*-----------------------------------------------------------------------*
		private MainViewModel mViewModel = null;
		/// <summary>
		/// Get/Set a reference to the main ViewModel.
		/// </summary>
		public MainViewModel ViewModel
		{
			get { return mViewModel; }
			set { mViewModel = value; }
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*
}
