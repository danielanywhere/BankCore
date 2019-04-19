using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using BankViewModel;

namespace BankWEB.Controllers
{
	public class IndexController : ApiController
	{
		/// <summary>
		/// Retrieve the full dataset needed for the index.html page.
		/// </summary>
		/// <returns>
		/// Complete client-side dataset that includes Accounts, Branches,
		/// Customers, and Employees. Relational data is expressed as RecordID.
		/// </returns>
		[Route("indexdata")]
		public IHttpActionResult Get()
		{
			IHttpActionResult result = null;
			WebSession session = new WebSession();
			BankModelCollection tables = session.GetAll();
			if(tables.Count > 0)
			{
				result = Ok(tables);
			}
			else
			{
				result = NotFound();
			}
			return result;
		}
	}
}
