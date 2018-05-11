using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BankViewModel
{
	//*-------------------------------------------------------------------------*
	//*	TransactionTypeEnum																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Enumeration of possible Transaction Types.
	/// </summary>
	public enum TransactionTypeEnum
	{
		/// <summary>
		/// Unknown or not specified.
		/// </summary>
		None = 0,
		/// <summary>
		/// Cash in or out.
		/// </summary>
		Cash = 1,
		/// <summary>
		/// Check ONUS.
		/// </summary>
		CheckOut = 2,
		/// <summary>
		/// Check from other institution.
		/// </summary>
		CheckIn = 3
	}
	//*-------------------------------------------------------------------------*
}
