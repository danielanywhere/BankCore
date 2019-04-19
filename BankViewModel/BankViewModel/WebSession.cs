using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	WebSession																															*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Handle the data needs of a web-based session.
	/// </summary>
	public class WebSession
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
		//*	GetAll																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return all data in the database as a collection of tables.
		/// </summary>
		public BankModelCollection GetAll()
		{
			AccountCollection accounts = null;
			BranchCollection branches = null;
			CustomerCollection customers = null;
			EmployeeCollection employees = null;
			bankEntities db = new bankEntities();
			BankModelCollection result = new BankModelCollection();

			accounts = new AccountCollection(db);
			accounts.Load();
			branches = new BranchCollection(db);
			branches.Load();
			customers = new CustomerCollection(db);
			customers.Load();
			employees = new EmployeeCollection(db);
			employees.Load();

			result.Add("Accounts", accounts);
			result.Add("Branches", branches);
			result.Add("Customers", customers);
			result.Add("Employees", employees);
			return result;
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*
}
