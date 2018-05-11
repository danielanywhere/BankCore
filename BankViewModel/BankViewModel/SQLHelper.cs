//	SQLHelper.cs
//	Copyright (c). 1998, 2018 Daniel Patterson, MCSD (danielanywhere).
//	Static helper functionality for SQL Server.
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;

namespace BankViewModel
{
	public class SQLHelper
	{
		private static string mConnectionName = "bankSQL";
		//*-----------------------------------------------------------------------*
		//*	ConnectionString																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get the default Connection String.
		/// </summary>
		public static string ConnectionString
		{
			//	ConfigurationManager class is found in System.Configuration.dll.
			get { return ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString; }
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetDbSize																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return the field size associated with the caller's value.
		/// </summary>
		/// <param name="value">
		/// Value to inspect.
		/// </param>
		/// <returns>
		/// Size for use with Command Parameters.
		/// </returns>
		public static int GetDbSize(object value)
		{
			int rv = 0;

			if (value is String)
			{
				rv = ((String)value).Length;
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetDbType																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return the DbType associated with the caller's value.
		/// </summary>
		/// <param name="value">
		/// Value to inspect.
		/// </param>
		/// <returns>
		/// SqlDbType loosely associated with the value.
		/// </returns>
		public static SqlDbType GetDbType(object value)
		{
			SqlDbType rv = SqlDbType.Int;

			if(value is Int64)
			{
				rv = SqlDbType.BigInt;
			}
			else if(value is Boolean)
			{
				rv = SqlDbType.Bit;
			}
			else if (value is Char)
			{
				rv = SqlDbType.Char;
			}
			else if (value is DataSet)
			{
				rv = SqlDbType.Date;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.DateTime;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.DateTime2;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.DateTimeOffset;
			}
			else if (value is Decimal)
			{
				rv = SqlDbType.Decimal;
			}
			else if (value is Single)
			{
				rv = SqlDbType.Float;
			}
			else if (value is Int32)
			{
				rv = SqlDbType.Int;
			}
			else if (value is Decimal)
			{
				rv = SqlDbType.Money;
			}
			else if (value is Boolean)
			{
				rv = SqlDbType.NChar;
			}
			else if (value is StringBuilder)
			{
				rv = SqlDbType.NText;
			}
			else if (value is String)
			{
				rv = SqlDbType.NVarChar;
			}
			else if (value is Single)
			{
				rv = SqlDbType.Real;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.SmallDateTime;
			}
			else if (value is Int16)
			{
				rv = SqlDbType.SmallInt;
			}
			else if (value is Decimal)
			{
				rv = SqlDbType.SmallMoney;
			}
			else if (value is Enum)
			{
				rv = SqlDbType.Structured;
			}
			else if (value is String)
			{
				rv = SqlDbType.Text;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.Time;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.Timestamp;
			}
			else if (value is Byte)
			{
				rv = SqlDbType.TinyInt;
			}
			else if (value is DateTime)
			{
				rv = SqlDbType.Udt;
			}
			else if (value is Guid)
			{
				rv = SqlDbType.UniqueIdentifier;
			}
			else if (value is String)
			{
				rv = SqlDbType.VarBinary;
			}
			else if (value is String)
			{
				rv = SqlDbType.VarChar;
			}
			else if (value is Object)
			{
				rv = SqlDbType.Variant;
			}
			else if (value is String)
			{
				rv = SqlDbType.Xml;
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetScalar																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a single value.
		/// </summary>
		/// <param name="sql">
		/// SQL SELECT Query, or other query returning rows.
		/// </param>
		/// <returns>
		/// Populated Data Table.
		/// </returns>
		public static int GetScalar(string sql)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			int rv = 0;												//	Return Value.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sql, conn);

			try
			{
				rv = Convert.ToInt32(cmd.ExecuteScalar());
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sql,
					"SQLHelper.GetScalar");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetScalarBool																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a single value.
		/// </summary>
		/// <param name="sql">
		/// SQL SELECT Query, or other query returning rows.
		/// </param>
		/// <param name="defaultValue">
		/// Default Value if no results are found.
		/// </param>
		/// <returns>
		/// Boolean Value.
		/// </returns>
		public static bool GetScalarBool(string sql, bool defaultValue)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			bool rv = defaultValue;						//	Return Value.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sql, conn);

			try
			{
				rv = Convert.ToBoolean(cmd.ExecuteScalar());
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sql,
					"SQLHelper.GetScalar");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetScalarInt																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a single value.
		/// </summary>
		/// <param name="sql">
		/// SQL SELECT Query, or other query returning rows.
		/// </param>
		/// <returns>
		/// Populated Data Table.
		/// </returns>
		public static int GetScalarInt(string sql)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			int rv = 0;												//	Return Value.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sql, conn);

			try
			{
				rv = Convert.ToInt32(cmd.ExecuteScalar());
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sql,
					"SQLHelper.GetScalar");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Return a single value.
		/// </summary>
		/// <param name="tableName">
		/// Name of the Table to search.
		/// </param>
		/// <param name="displayColumn">
		/// Name of the Column to display.
		/// </param>
		/// <param name="keyColumn">
		/// Name of the Column to match.
		/// </param>
		/// <param name="keyValue">
		/// Value to match.
		/// </param>
		/// <returns>
		/// Populated Data Table.
		/// </returns>
		public static int GetScalarInt(string tableName,
			string displayColumn, string keyColumn, object keyValue)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			int rv = 0;												//	Return Value.
			string sq = "";										//	SQL Command Text.

			sq = "SELECT " + 
				tableName + "." + displayColumn + " " +
				"FROM " + tableName + " " +
				"WHERE " +
				tableName + "." + keyColumn + " = " + ToSql(keyValue);
			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sq, conn);

			try
			{
				rv = Convert.ToInt32(cmd.ExecuteScalar());
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sq,
					"SQLHelper.GetScalarInt");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetScalarString																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a single value.
		/// </summary>
		/// <param name="sql">
		/// SQL SELECT Query, or other query returning rows.
		/// </param>
		/// <returns>
		/// Populated Data Table.
		/// </returns>
		public static string GetScalarString(string sql)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			string rv = "";										//	Return Value.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sql, conn);

			try
			{
				rv = Convert.ToString(cmd.ExecuteScalar());
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sql,
					"SQLHelper.GetScalar");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	GetTable																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a populated DataTable containing the results of the query.
		/// </summary>
		/// <param name="sql">
		/// SQL SELECT Query, or other query returning rows.
		/// </param>
		/// <returns>
		/// Populated Data Table.
		/// </returns>
		public static DataTable GetTable(string sql)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			SqlDataReader dr;									//	Working Data Reader.
			DataTable dt = new DataTable();		//	Working Data Table.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();

			cmd = new SqlCommand(sql, conn);
			try
			{
				dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
				dt.Load(dr);
				dr.Close();
				dr.Dispose();
			}
			catch { }
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return dt;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	InsertRecord																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Insert a record into the database.
		/// </summary>
		/// <param name="tableName">
		/// Name of the Table.
		/// </param>
		/// <param name="columnNames">
		/// Names of Columns.
		/// </param>
		/// <param name="columnValues">
		/// Values to insert, aligned with column names.
		/// </param>
		/// <returns>
		/// Value indicating whether the operation was a success.
		/// </returns>
		public static bool InsertRecord(string tableName,
			string[] columnNames, object[] columnValues)
		{
			int cc = columnNames.Length;		//	Column Count.
			int cp = 0;											//	Column Position.
			SqlConnection conn;							//	Working Connection.
			SqlCommand cmd;									//	Working Command.
			int dl = 0;											//	SQL Data Length.
			SqlDbType dt = SqlDbType.Int;		//	SQL Data Type.
			SqlParameter param;							//	Working Parameter.
			bool rv = false;								//	Return Value.
			StringBuilder sc = new StringBuilder();				//	SQL Column Names.
			StringBuilder sq = new StringBuilder();				//	SQL Command Text.
			StringBuilder sv = new StringBuilder();				//	SQL Values.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();

			for(cp = 0; cp < cc; cp ++)
			{
				if(sc.Length > 0)
				{
					sc.Append(",");
					sv.Append(",");
				}
				sc.Append(columnNames[cp]);
				sv.Append("@");
				sv.Append(columnNames[cp].ToLower());
			}
			if(sc.Length > 0)
			{
				sq.Append("INSERT INTO ");
				sq.Append(tableName);
				sq.Append(" (");
				sq.Append(sc.ToString());
				sq.Append(") VALUES (");
				sq.Append(sv.ToString());
				sq.Append(")");
			}
			cmd = new SqlCommand(sq.ToString(), conn);
			for(cp = 0; cp < cc; cp ++)
			{
				dt = GetDbType(columnValues[cp]);
				dl = GetDbSize(columnValues[cp]);
				if(dl > 0)
				{
					param = cmd.Parameters.Add("@" + columnNames[cp].ToLower(), dt, dl);
					param.Value = columnValues[cp];
				}
				else
				{
					param = cmd.Parameters.Add("@" + columnNames[cp].ToLower(), dt);
					param.Value = columnValues[cp];
				}
			}
			rv = (cmd.ExecuteNonQuery() != 0);
			cmd.Dispose();
			conn.Close();
			conn.Dispose();

			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	RecordExists																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a value indicating whether the specified record exists.
		/// </summary>
		/// <param name="tableName">
		/// Name of the Table to check.
		/// </param>
		/// <param name="keyColumn">
		/// Name of the Column to test.
		/// </param>
		/// <param name="keyValue">
		/// Value to test.
		/// </param>
		/// <returns>
		/// True, if the specified record was found. Otherwise, false.
		/// </returns>
		public static bool RecordExists(string tableName,
			string keyColumn, object keyValue)
		{
			SqlConnection conn;							//	Working Connection.
			SqlCommand cmd;									//	Working Command.
			int dl = 0;											//	SQL Data Length.
			SqlDbType dt = SqlDbType.Int;		//	SQL Data Type.
			SqlParameter param;							//	Working Parameter.
			SqlDataReader rdr = null;				//	Working Reader.
			bool rv = false;								//	Return Value.
			StringBuilder sq = new StringBuilder();				//	SQL Command Text.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();

			sq.Append("SELECT ");
			sq.Append(keyColumn);
			sq.Append(" FROM ");
			sq.Append(tableName);
			sq.Append(" WHERE ");
			sq.Append(keyColumn);
			sq.Append(" = ");
			sq.Append("@");
			sq.Append(keyColumn.ToLower());
			dt = GetDbType(keyValue);
			dl = GetDbSize(keyValue);
			cmd = new SqlCommand(sq.ToString(), conn);
			if (dl > 0)
			{
				param = cmd.Parameters.Add("@" + keyColumn.ToLower(), dt, dl);
			}
			else
			{
				param = cmd.Parameters.Add("@" + keyColumn.ToLower(), dt);
			}
			param.Value = keyValue;
			rdr = cmd.ExecuteReader();
			rv = (rdr.HasRows);
			rdr.Close();
			rdr.Dispose();
			cmd.Dispose();
			conn.Close();
			conn.Dispose();

			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ToSql																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Inspect the caller's value type, and return a formatted SQL value
		/// assignment.
		/// </summary>
		/// <param name="value">
		/// Value to query in SQL.
		/// </param>
		/// <returns>
		/// String value, formatted for use in SQL value assignment.
		/// </returns>
		public static string ToSql(object value)
		{
			string rv = "NULL";

			if(value != null)
			{
				rv = value.ToString();
				if(value is String)
				{
					rv = "'" + rv.Replace("'", "''") + "'";
				}
				else if(value is DateTime)
				{
					rv = "'" + ((DateTime)value).ToString("MM/dd/yyyy HH:mm") + "'";
				}
			}
			return rv;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Update																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Update the database from values in the caller-specified table.
		/// </summary>
		/// <param name="table">
		/// DataTable to send.
		/// </param>
		/// <returns>
		/// Number of rows affected.
		/// </returns>
		public static int Update(DataTable table)
		{
			string[] ca = new string[0];			//	Column Names array.
			int cc = 0;												//	Column Count.
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			int cp = 0;												//	Column Position.
			//int dl = 0;												//	Working Column Length.
			DataRow dr = null;								//	Working Row.
			//SqlDbType dt = SqlDbType.Int;			//	Working Column Type.
			int rc = 0;												//	Row Count.
			int rp = 0;												//	Row Position.
			int rv = 0;												//	Return Value.
			StringBuilder sb = new StringBuilder();
			string sq = "";										//	SQL Command Text.
			string tn = "";										//	Table Name.

			if(table != null && table.Columns.Count > 1 && table.Rows.Count > 0)
			{
				//	Create the connection.
				tn = table.Columns[0].ColumnName;
				if(tn.EndsWith("ID"))
				{
					tn = tn.Substring(0, tn.Length - 2);
				}
				else if(tn.EndsWith("Ticket"))
				{
					tn = tn.Substring(0, tn.Length - 6);
				}

				cc = table.Columns.Count;
				for(cp = 1; cp < cc; cp ++)
				{
					if(sb.Length > 0)
					{
						sb.Append(", ");
					}
					sb.Append(table.Columns[cp].ColumnName);
					sb.Append(" = @");
					sb.Append(table.Columns[cp].ColumnName.ToLower());
				}
				sq = "UPDATE " + tn + " SET " + sb.ToString() + " " +
					"WHERE " +
					table.Columns[0].ColumnName + " = @" +
					table.Columns[0].ColumnName.ToLower();

				conn = new SqlConnection(
					ConfigurationManager.
					ConnectionStrings[mConnectionName].ConnectionString);
				conn.Open();
				cmd = new SqlCommand(sq, conn);

				for(cp = 0; cp < cc; cp ++)
				{
					cmd.Parameters.Add("@" + table.Columns[cp].ColumnName.ToLower(),
						GetDbType(table.Rows[0].ItemArray[cp]),
						(table.Rows[0].ItemArray[cp] is String ? 8000 :
						GetDbSize(table.Rows[0].ItemArray[cp])));
				}

				rc = table.Rows.Count;
				for(rp = 0; rp < rc; rp ++)
				{
					dr = table.Rows[rp];
					for(cp = 0; cp < cc; cp ++)
					{
						cmd.Parameters[cp].Value = dr.ItemArray[cp];
					}
					try
					{
						rv += cmd.ExecuteNonQuery();
					}
					catch(Exception ex)
					{
						Trace.WriteLine("Error: " + ex.Message + "\r\n" + sq,
							"SQLHelper.Update(DataTable)");
					}
				}

				cmd.Dispose();
				conn.Close();
				conn.Dispose();
			}
			return rv;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Update the database with prepared SQL.
		/// </summary>
		/// <param name="sql">
		/// SQL UPDATE Query, or other query affecting rows.
		/// </param>
		/// <returns>
		/// Number of rows affected.
		/// </returns>
		public static int Update(string sql)
		{
			SqlCommand cmd;										//	Working Command.
			SqlConnection conn;								//	Working Connection.
			int rv = 0;												//	Return Value.

			//	Create the connection.
			conn = new SqlConnection(
				ConfigurationManager.
				ConnectionStrings[mConnectionName].ConnectionString);
			conn.Open();
			cmd = new SqlCommand(sql, conn);

			try
			{
				rv = cmd.ExecuteNonQuery();
			}
			catch(Exception ex)
			{
				Trace.WriteLine("Error: " + ex.Message + "\r\n" + sql,
					"SQLHelper.Update");
			}
			cmd.Dispose();
			conn.Close();
			conn.Dispose();
			return rv;
		}
		//*-----------------------------------------------------------------------*

	}
}