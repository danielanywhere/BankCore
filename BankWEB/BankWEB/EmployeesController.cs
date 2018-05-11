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
	//*	EmployeesController																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Web API 2 Controller for transient employee objects.
	/// </summary>
	public class EmployeesController : ApiController
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
		/// Create a new Instance of the EmployeesController Item.
		/// </summary>
		public EmployeesController()
		{
			mEmployees = new EmployeeCollection(mDB);
			mEmployees.Load();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DeleteEmployee																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// DELETE: api/Employees/5
		/// </summary>
		/// <remarks>
		/// Delete the specified employee.
		/// </remarks>
		[ResponseType(typeof(EmployeeItem))]
		public IHttpActionResult DeleteEmployee(int id)
		{
			EmployeeItem ci = mEmployees.First(r => r.EmployeeID == id);
			if(ci == null)
			{
				return NotFound();
			}

			mEmployees.Remove(ci);
			mEmployees.SaveChanges();

			return Ok(ci);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Employees																															*
		//*-----------------------------------------------------------------------*
		private EmployeeCollection mEmployees = null;
		/// <summary>
		/// Get a reference to the collection of employees driven by this
		/// interface.
		/// </summary>
		public EmployeeCollection Employees
		{
			get { return mEmployees; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetEmployee																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Employees/5
		/// </summary>
		/// <remarks>
		/// <para>
		/// Return the specified employee.
		/// </para>
		/// <para>
		/// Even with a single entry, it is important to return an array due to
		/// the fact that the Kendo UI DataSource will only bind to an array.
		/// </para>
		/// </remarks>
		[ResponseType(typeof(EmployeeItem[]))]
		public IHttpActionResult GetEmployee(int id)
		{
			EmployeeItem ci = mEmployees.First(r => r.EmployeeID == id);
			EmployeeItem[] ro = new EmployeeItem[] { ci };
			if(ci == null)
			{
				return NotFound();
			}

			return Ok(ro);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetEmployees																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Employees
		/// </summary>
		/// <remarks>
		/// Return all employees.
		/// </remarks>
		public IQueryable<EmployeeItem> GetEmployees()
		{
			mEmployees.Load();
			return mEmployees.AsQueryable<EmployeeItem>();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PostEmployee																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// POST: api/Employees
		/// </summary>
		/// <remarks>
		/// Use an HTTP POST to store information about a employee.
		/// JavaScriptSerializer is found in System.Web.Extensions.
		/// </remarks>
		[ResponseType(typeof(EmployeeItem))]
		public IHttpActionResult PostEmployee(EmployeeItem employee)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}


			employee = mEmployees.AddOrUpdate(employee);
			mEmployees.SaveChanges();

			return CreatedAtRoute("DefaultApi",
				new { id = employee.EmployeeID }, employee);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PutEmployee																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// PUT: api/Employees/5
		/// </summary>
		[ResponseType(typeof(void))]
		public IHttpActionResult PutEmployee(int id, EmployeeItem employee)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			if(id != employee.EmployeeID || !mEmployees.Exists(id))
			{
				return BadRequest();
			}

			employee = mEmployees.AddOrUpdate(employee);
			mEmployees.SaveChanges();

			return StatusCode(HttpStatusCode.NoContent);
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
