using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace BankViewModel
{
	//	The IMultiValueConverter interface is found in Presentation.Framework.dll
	//	in the namespace System.Windows.Data.
	//*-------------------------------------------------------------------------*
	//*	PersonDisplayNameConverter																							*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Handles a person's display name from first name, last name fields.
	/// </summary>
	public class PersonDisplayNameConverter : IMultiValueConverter
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
		//*	Convert																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Convert the values to the desired output format.
		/// </summary>
		/// <param name="values">
		/// One or more name values.
		/// </param>
		/// <param name="targetType">
		/// Type of value to which the output will be converted.
		/// </param>
		/// <param name="parameter">
		/// The name of a FirstNameLastNameTypeEnum member of the format desired.
		/// </param>
		/// <param name="culture">
		/// Current system culture value.
		/// </param>
		/// <returns>
		/// The display name of the person, formatted as requested.
		/// </returns>
		public object Convert(object[] values, Type targetType, object parameter,
			CultureInfo culture)
		{
			string displayName = "";			//	Display Name.
			FirstNameLastNameTypeEnum pv = FirstNameLastNameTypeEnum.None;
			string s1 = "";								//	Left Value.
			string s2 = "";								//	Right Value.

			if(values != null && values.Length > 0)
			{
				if(values.Length > 1)
				{
					//	At least first and last name are provided.
					if(parameter != null)
					{
						try
						{
							pv = (FirstNameLastNameTypeEnum)
								Enum.Parse(typeof(FirstNameLastNameTypeEnum),
								(string)parameter);
						}
						catch { }
					}
					if(pv != FirstNameLastNameTypeEnum.None)
					{
						s1 = values[0].ToString();
						s2 = values[1].ToString();
						switch((FirstNameLastNameTypeEnum)pv)
						{
							case FirstNameLastNameTypeEnum.FirstName:
								displayName = s1;
								break;
							case FirstNameLastNameTypeEnum.LastName:
								displayName = s2;
								break;
							case FirstNameLastNameTypeEnum.FirstNameLastName:
								if(s1.Length > 0 && s2.Length > 0)
								{
									displayName = s1 + " " + s2;
								}
								else if(s1.Length > 0)
								{
									displayName = s1;
								}
								else
								{
									displayName = s2;
								}
								break;
							case FirstNameLastNameTypeEnum.LastNameFirstName:
								if(s1.Length > 0 && s2.Length > 0)
								{
									displayName = s2 + ", " + s1;
								}
								else if(s1.Length > 0)
								{
									displayName = s1;
								}
								else
								{
									displayName = s2;
								}
								break;
							default:
								break;
						}
					}
				}
				else
				{
					//	Only one name is provided.
					displayName = values[0].ToString();
				}
			}
			return displayName;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ConvertBack																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Convert the formatted value back to individual values.
		/// </summary>
		/// <param name="value">
		/// Formatted display name.
		/// </param>
		/// <param name="targetTypes">
		/// Target types.
		/// </param>
		/// <param name="parameter">
		/// Format type used for initial conversion.
		/// </param>
		/// <param name="culture">
		/// Local culture setting.
		/// </param>
		/// <returns>
		/// Original values.
		/// </returns>
		public object[] ConvertBack(object value, Type[] targetTypes,
			object parameter, CultureInfo culture)
		{
			string[] splitValues = ((string)value).Split(' ');
			return splitValues;
		}
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	FirstNameLastNameTypeEnum																								*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Enumeration of first name, last name formats.
	/// </summary>
	public enum FirstNameLastNameTypeEnum
	{
		/// <summary>
		/// Unknown or not defined.
		/// </summary>
		None = 0,
		/// <summary>
		/// First name only.
		/// </summary>
		FirstName,
		/// <summary>
		/// Last name only.
		/// </summary>
		LastName,
		/// <summary>
		/// First name, then last name.
		/// </summary>
		FirstNameLastName,
		/// <summary>
		/// Last name, then first name.
		/// </summary>
		LastNameFirstName
	}
	//*-------------------------------------------------------------------------*



}
