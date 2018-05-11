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
	//*	CustomerCollectionController																						*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Web API 2 Controller for Transient Customer objects.
	/// </summary>
	public class CustomersController : ApiController
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
		/// Create a new Instance of the CustomerCollectionController Item.
		/// </summary>
		public CustomersController()
		{
			mCustomers = new CustomerCollection(mDB);
			mCustomers.Load();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Customers																															*
		//*-----------------------------------------------------------------------*
		private CustomerCollection mCustomers = null;
		/// <summary>
		/// Get a reference to the collection of customers driven by this
		/// interface.
		/// </summary>
		public CustomerCollection Customers
		{
			get { return mCustomers; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DeleteCustomer																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// DELETE: api/Customers/5
		/// </summary>
		/// <remarks>
		/// Delete the specified customer.
		/// </remarks>
		[ResponseType(typeof(CustomerItem))]
		public IHttpActionResult DeleteCustomer(int id)
		{
			CustomerItem ci = mCustomers.First(r => r.CustomerID == id);
			if(ci == null)
			{
				return NotFound();
			}

			mCustomers.Remove(ci);
			mCustomers.SaveChanges();

			return Ok(ci);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetCustomer																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Customers/5
		/// </summary>
		/// <remarks>
		/// <para>
		/// Return the specified customer.
		/// </para>
		/// <para>
		/// Even with a single entry, it is important to return an array due to
		/// the fact that the Kendo UI DataSource will only bind to an array.
		/// </para>
		/// </remarks>
		[ResponseType(typeof(CustomerItem[]))]
		public IHttpActionResult GetCustomer(int id)
		{
			CustomerItem ci = mCustomers.First(r => r.CustomerID == id);
			CustomerItem[] ro = new CustomerItem[] { ci };
			if(ci == null)
			{
				return NotFound();
			}

			return Ok(ro);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetCustomers																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Customers
		/// </summary>
		/// <remarks>
		/// Return all customers.
		/// </remarks>
		public IQueryable<CustomerItem> GetCustomers()
		{
			mCustomers.Load();
			return mCustomers.AsQueryable<CustomerItem>();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PostCustomer																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// POST: api/Customers
		/// </summary>
		/// <remarks>
		/// Use an HTTP POST to store information about a customer.
		/// JavaScriptSerializer is found in System.Web.Extensions.
		/// </remarks>
		[ResponseType(typeof(CustomerItem))]
		public IHttpActionResult PostCustomer(CustomerItem customer)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

	
			customer = mCustomers.AddOrUpdate(customer);
			mCustomers.SaveChanges();

			return CreatedAtRoute("DefaultApi",
				new { id = customer.CustomerID }, customer);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PutCustomer																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// PUT: api/Customers/5
		/// </summary>
		[ResponseType(typeof(void))]
		public IHttpActionResult PutCustomer(int id, CustomerItem customer)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			if(id != customer.CustomerID || !mCustomers.Exists(id))
			{
				return BadRequest();
			}

			customer = mCustomers.AddOrUpdate(customer);
			mCustomers.SaveChanges();

			return StatusCode(HttpStatusCode.NoContent);
		}
		//*-----------------------------------------------------------------------*


	}
	//*-------------------------------------------------------------------------*

}