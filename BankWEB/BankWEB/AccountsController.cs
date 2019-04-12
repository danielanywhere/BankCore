using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;

using BankViewModel;

namespace BankWEB
{
	//*-------------------------------------------------------------------------*
	//*	AccountsController																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Web API 2 Controller for transient account objects.
	/// </summary>
	public class AccountsController : ApiController
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private bankEntities mDB = new bankEntities();

		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	Dispose																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// When disposing, also dispose of the context.
		/// </summary>
		/// <param name="disposing"></param>
		protected override void Dispose(bool disposing)
		{
			if(disposing)
			{
				mDB.Dispose();
			}
			base.Dispose(disposing);
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new Instance of the AccountsController Item.
		/// </summary>
		public AccountsController()
		{
			mAccounts = new AccountCollection(mDB);
			mAccounts.Load();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Accounts																															*
		//*-----------------------------------------------------------------------*
		private AccountCollection mAccounts = null;
		/// <summary>
		/// Get a reference to the collection of accounts driven by this
		/// interface.
		/// </summary>
		public AccountCollection Accounts
		{
			get { return mAccounts; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DeleteAccount																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// DELETE: api/Accounts/5
		/// </summary>
		/// <remarks>
		/// Delete the specified account.
		/// </remarks>
		[ResponseType(typeof(AccountItem))]
		public IHttpActionResult DeleteAccount(int id)
		{
			AccountItem ci = mAccounts.First(r => r.AccountID == id);
			if(ci == null)
			{
				return NotFound();
			}

			mAccounts.Remove(ci);
			mAccounts.SaveChanges();

			return Ok(ci);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetAccount																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Accounts/5
		/// </summary>
		/// <remarks>
		/// <para>
		/// Return the specified account.
		/// </para>
		/// <para>
		/// Even with a single entry, it is important to return an array due to
		/// the fact that the Kendo UI DataSource will only bind to an array.
		/// </para>
		/// </remarks>
		[ResponseType(typeof(AccountItem[]))]
		public IHttpActionResult GetAccount(int id)
		{
			AccountItem ci = mAccounts.First(r => r.AccountID == id);
			AccountItem[] ro = new AccountItem[] { ci };
			if(ci == null)
			{
				return NotFound();
			}

			return Ok(ro);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetAccounts																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Accounts
		/// </summary>
		/// <remarks>
		/// Return all accounts.
		/// </remarks>
		public IQueryable<AccountItem> GetAccounts()
		{
			mAccounts.Load();
			return mAccounts.AsQueryable<AccountItem>();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Lookup																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return the identifying information for a single account record.
		/// </summary>
		/// <remarks>
		/// <para>
		/// Return the ID and default text of specified account.
		/// </para>
		/// </remarks>
		public IDTextItem Lookup(int id)
		{
			AccountItem ci = mAccounts.First(r => r.AccountID == id);
			IDTextItem di = IDTextItem.Assign(ci, "AccountID", "AccountID");

			return di;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Lookups																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return the collection of ID lookups for this entity.
		/// </summary>
		/// <remarks>
		/// Return the default Field and default text value for all accounts.
		/// </remarks>
		public IDTextCollection Lookups()
		{
			IDTextCollection rv = new IDTextCollection();
			if(mAccounts.Count() == 0)
			{
				mAccounts.Load();
			}
			rv.AddRange(mAccounts, "AccountID", "AccountID");
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PostAccount																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// POST: api/Accounts
		/// </summary>
		/// <remarks>
		/// Use an HTTP POST to store information about a account.
		/// JavaScriptSerializer is found in System.Web.Extensions.
		/// </remarks>
		[ResponseType(typeof(AccountItem))]
		public IHttpActionResult PostAccount(AccountItem account)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}


			account = mAccounts.AddOrUpdate(account);
			mAccounts.SaveChanges();

			return CreatedAtRoute("DefaultApi",
				new { id = account.AccountID }, account);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PutAccount																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// PUT: api/Accounts/5
		/// </summary>
		[ResponseType(typeof(void))]
		public IHttpActionResult PutAccount(int id, AccountItem account)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			if(id != account.AccountID || !mAccounts.Exists(id))
			{
				return BadRequest();
			}

			account = mAccounts.AddOrUpdate(account);
			mAccounts.SaveChanges();

			return StatusCode(HttpStatusCode.NoContent);
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
