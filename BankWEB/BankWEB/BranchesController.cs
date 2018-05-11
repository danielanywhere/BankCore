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
	//*	BranchesController																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Web API 2 Controller for transient branch objects.
	/// </summary>
	public class BranchesController : ApiController
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
		/// Create a new Instance of the BranchesController Item.
		/// </summary>
		public BranchesController()
		{
			mBranches = new BranchCollection(mDB);
			mBranches.Load();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Branches																															*
		//*-----------------------------------------------------------------------*
		private BranchCollection mBranches = null;
		/// <summary>
		/// Get a reference to the collection of branches driven by this
		/// interface.
		/// </summary>
		public BranchCollection Branches
		{
			get { return mBranches; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	DeleteBranch																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// DELETE: api/Branches/5
		/// </summary>
		/// <remarks>
		/// Delete the specified branch.
		/// </remarks>
		[ResponseType(typeof(BranchItem))]
		public IHttpActionResult DeleteBranch(int id)
		{
			BranchItem ci = mBranches.First(r => r.BranchID == id);
			if(ci == null)
			{
				return NotFound();
			}

			mBranches.Remove(ci);
			mBranches.SaveChanges();

			return Ok(ci);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetBranch																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Branches/5
		/// </summary>
		/// <remarks>
		/// <para>
		/// Return the specified branch.
		/// </para>
		/// <para>
		/// Even with a single entry, it is important to return an array due to
		/// the fact that the Kendo UI DataSource will only bind to an array.
		/// </para>
		/// </remarks>
		[ResponseType(typeof(BranchItem[]))]
		public IHttpActionResult GetBranch(int id)
		{
			BranchItem ci = mBranches.First(r => r.BranchID == id);
			BranchItem[] ro = new BranchItem[] { ci };
			if(ci == null)
			{
				return NotFound();
			}

			return Ok(ro);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetBranches																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// GET: api/Branches
		/// </summary>
		/// <remarks>
		/// Return all branches.
		/// </remarks>
		public IQueryable<BranchItem> GetBranches()
		{
			mBranches.Load();
			return mBranches.AsQueryable<BranchItem>();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PostBranch																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// POST: api/Branches
		/// </summary>
		/// <remarks>
		/// Use an HTTP POST to store information about a branch.
		/// JavaScriptSerializer is found in System.Web.Extensions.
		/// </remarks>
		[ResponseType(typeof(BranchItem))]
		public IHttpActionResult PostBranch(BranchItem branch)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}


			branch = mBranches.AddOrUpdate(branch);
			mBranches.SaveChanges();

			return CreatedAtRoute("DefaultApi",
				new { id = branch.BranchID }, branch);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	PutBranch																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// PUT: api/Branches/5
		/// </summary>
		[ResponseType(typeof(void))]
		public IHttpActionResult PutBranch(int id, BranchItem branch)
		{
			if(!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			if(id != branch.BranchID || !mBranches.Exists(id))
			{
				return BadRequest();
			}

			branch = mBranches.AddOrUpdate(branch);
			mBranches.SaveChanges();

			return StatusCode(HttpStatusCode.NoContent);
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

}
