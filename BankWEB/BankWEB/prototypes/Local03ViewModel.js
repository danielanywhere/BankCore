/*****************************************************************************/
/* Global Functions and Values                                               */
/*****************************************************************************/
/*---------------------------------------------------------------------------*/
/* booleanToNumber                                                           */
/*---------------------------------------------------------------------------*/
/**
	* Return a 1 or 0 number value corresponding to the caller's input.
	* @param {boolean} value Boolean value to inspect.
	* @returns {number} 1 or 0 representation of the caller's value.
	*/
function booleanToNumber(value)
{
	return (value ? 1 : 0);
}
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* getFormattedDate                                                          */
/*---------------------------------------------------------------------------*/
/**
	* Return the user-readable version of a date.
	* @param {object} date The date to convert to printable.
	* @returns {string} The caller's date, formatted for MM/DD/YYYY.
	*/
function getFormattedDate(date)
{
 var year = date.getFullYear();

 var month = (1 + date.getMonth()).toString();
 month = month.length > 1 ? month : '0' + month;

 var day = date.getDate().toString();
 day = day.length > 1 ? day : '0' + day;
	
	return month + '/' + day + '/' + year;
}
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* toBoolean                                                                 */
/*---------------------------------------------------------------------------*/
/**
	* Return a value indicating whether the caller's parameter evaluates to
	* true or false.
	* @param {object} value Value to inspect for boolean outcome.
	* @returns {boolean} Boolean representation of the caller's value.
	*/
function toBoolean(value)
{
	var result = false;
	if(typeof(value) === "string")
	{
		value = value.trim().toLocaleLowerCase();
	}
	switch(value)
	{
		case true:
		case "true":
		case 1:
		case "1":
		case "on":
		case "yes":
			result = true;
			break;
	}
	return result;
}
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* toNumber                                                                  */
/*---------------------------------------------------------------------------*/
/**
	* Return a numeric representation of the caller's value.
	* @param {string} value Value to convert to number.
	* @returns {number} Numeric representation of the caller's value.
	*/
	function toNumber(value)
	{
		value = value.replace(/[\$, ]/g, "");
		return parseFloat(value);
	}
	/*---------------------------------------------------------------------------*/
	
/*****************************************************************************/
/* Custom Editors                                                            */
/*****************************************************************************/
/*---------------------------------------------------------------------------*/
/* Date Type Field Editor                                                    */
/*---------------------------------------------------------------------------*/
var jsGridDateField = function(config)
{
	jsGrid.Field.call(this, config);
}
jsGridDateField.prototype = new jsGrid.Field(
{
	//	myCustomProperty: "foo",		// custom properties can be added
	align: "center",    //	general property 'align'
	css: "date-field",		// general property 'css'
	editTemplate: function(value)
	{
		var grid = this._grid;
		var $result = this._editPicker =
			$("<input>").datepicker().datepicker("setDate", new Date(value));
		$result.on("keypress", function(e)
		{
			if(e.which == 13)
			{
				grid.updateItem();
				e.preventDefault;
			}
		});
		$result.on("keyup", function(e)
		{
			if(e.keyCode == 27)
			{
				grid.cancelEdit();
				e.stopPropagation();
			}
		});
		return $result;
	},
	editValue: function()
	{
		return this._editPicker.datepicker("getDate").toISOString();
	},
	// filterTemplate: function()
	// {
	// 	var now = new Date();
	// 	this._fromPicker = $("<input>").datepicker({ defaultDate: now.setFullYear(now.getFullYear() - 1) });
	// 	this._toPicker = $("<input>").datepicker({ defaultDate: now.setFullYear(now.getFullYear() + 1) });
	// 	return $("<div>").append(this._fromPicker).append(this._toPicker);
	// },
	// filterValue: function()
	// {
	// 		return {
	// 			from: this._fromPicker.datepicker("getDate"),
	// 			to: this._toPicker.datepicker("getDate")
	// 		};
	// },
	insertTemplate: function(value)
	{
		return this._insertPicker =
			$("<input>").datepicker({ defaultDate: new Date() });
	},
	insertValue: function()
	{
		return this._insertPicker.datepicker("getDate").toISOString();
	},
	itemTemplate: function(value)
	{
		var result = "";
		if(value)
		{
			result = getFormattedDate(new Date(value));
		}
		return result;
	},
	sorter: function(date1, date2)
	{
		return new Date(date1) - new Date(date2);
	}
});
jsGrid.fields.date = jsGridDateField;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Expression Type Field Editor                                              */
/*---------------------------------------------------------------------------*/
var jsGridExpressionField = function(config)
{
	jsGrid.Field.call(this, config);
}
jsGridExpressionField.prototype = new jsGrid.Field(
{
	align: "left",    		//	General property 'align'
	css: "expression-field",	// General property 'css'
	expression: "",					//	By default, the expression is unknown.
	itemTemplate: function(value)
	{
		//	Value should be set to the record ID.
		//	In this version, only implement a very basic expression
		//	capability:
		//	{FieldName}	-	Name of a field to display. Multiple field names
		//															are supported, and the same field name can be
		//															specified multiple times.
		//	(everything else)	-	As shown in the string.
		//	Example: "{LastName}, {FirstName}"
		//			Display the display name of the person by last name, comma,
		//			then first name.
		var eValue = "";
		var grid = this._grid;
		var item = null;
		var items = grid.data;
		var matches = [];
		var mCount = 0;
		var mIndex = 0;
		var mValue = "";
		var rCount = 0;
		var result = "";
		var rIndex = 0;
		var rName = this.name;
		var rValue = "";
		if(this.expression)
		{
			//	Find the record first.
			rCount = items.length;
			// console.log("Expression field: rows count: " + rCount);
			// console.log("Expression field: value: " + value);
			// console.log("Expression field: name:  " + rName);
			for(rIndex = 0; rIndex < rCount; rIndex ++)
			{
				if(items[rIndex][rName] == value)
				{
					//	Record found.
					// console.log("Expression field: Record found...");
					item = items[rIndex];
					break;
				}
			}
			if(item)
			{
				eValue = this.expression;
				matches = eValue.match(/\{[0-9A-Za-z]+\}/g);
				mCount = matches.length;
				for(mIndex = 0; mIndex < mCount; mIndex ++)
				{
					mValue = matches[mIndex];
					mValue = mValue.substr(1, mValue.length - 2);
					// console.log("Expression field: Find replacement for " + mValue);
					//	Get the replacement value.
					rValue = item[mValue];
					// console.log("Expression field: Use " + rValue);
					//	Replace all instances of the field.
					eValue = eValue.replace(
						new RegExp("\\{" + mValue + "\\}", "gm"), rValue);
				}
				result = eValue;
			}
			//	Future reference:
			//	result = eval("x + 1");
			//	if (eval(" var1 == null && var2 != 5")) { ... }
			// result = (new Function("return " + expression)()) { };
		}
		return result;
	}
});
jsGrid.fields.expression = jsGridExpressionField;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Money Type Field Editor                                                   */
/*---------------------------------------------------------------------------*/
var jsGridMoneyField = function(config)
{
	jsGrid.Field.call(this, config);
}
jsGridMoneyField.prototype = new jsGrid.NumberField(
{
	//	myCustomProperty: "foo",		// custom properties can be added
	align: "right",    	//	general property 'align'
	css: "money-field",	// general property 'css'
	itemTemplate: function(value)
	{
		return (value).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');		
	}
});
jsGrid.fields.money = jsGridMoneyField;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* SelectExpression Type Field Editor                                        */
/*---------------------------------------------------------------------------*/
var jsGridSelectExpressionField = function(config)
{
	jsGrid.Field.call(this, config);
}
jsGridSelectExpressionField.prototype = new jsGrid.SelectField(
{
	align: "left",    	//	general property 'align'
	css: "selectexpression-field",	// general property 'css'
	createSelectControl: function()
	{
		var $result = $("<select>");
		var expression = this.expression;
		var items = this.items;
		var valueField = this.valueField;
		var textField = this.textField;
		var rex = this.resolveExpression;
		var selectedIndex = this.selectedIndex;

		$.each(this.items, function(index, item)
		{
			var value = valueField ? item[valueField] : index;
			// var text = textField ? item[textField] : item;

			console.log("CreateSelectControl: value: " +
				value + " / " + rex(value, items, valueField, expression));
			var $option = $("<option>")
				.attr("value", value)
				.text(rex(value, items, valueField, expression))
				.appendTo($result);

			$option.prop("selected", (selectedIndex === index));
		});
		$result.prop("disabled", !!this.readOnly);
		return $result;
	},
	editTemplate: function(value)
	{
		if(!this.editing)
		{
			return this.itemTemplate.apply(this, arguments);
		}
		var grid = this._grid;
		var $result = this.editControl = this.createSelectControl();
		if(value)
		{
			$result.val(value);
		}
		// (value !== undefined) && $result.val(value);
		// console.log("Wiring keypress for selector.");
		$result.on("keypress", function(e)
		{
			if(e.which == 13)
			{
				// console.log("Selector storing changes...");
				grid.updateItem();
				e.preventDefault;
			}
		});
		$result.on("keyup", function(e)
		{
			if(e.keyCode == 27)
			{
				// console.log("Selector cancelling edit...");
				grid.cancelEdit();
				e.stopPropagation();
			}
		});
		return $result;
	},
	expression: "",					//	By default, the expression is unknown.
	itemTemplate: function(value)
	{
		return this.resolveExpression(value,
			this.items, this.valueField, this.expression);
	},
	/**
		* Resolve the expression for the specified local ID value.
		* @param {object} value The value designated by the name attribute.
		* @param {object} items Array of items to inspect.
		* @param {string} valueField Name of the value field to scan.
		* @param {string} expression Expression to resolve.
		* @returns {string} Resolved value.
		*/
	resolveExpression: function(value, items, valueField, expression)
	{
		//	Value should be set to the record ID.
		//	In this version, only implement a very basic expression
		//	capability:
		//	{FieldName}	-	Name of a field to display. Multiple field names
		//															are supported, and the same field name can be
		//															specified multiple times.
		//	(everything else)	-	As shown in the string.
		//	Example: "{LastName}, {FirstName}"
		//			Display the display name of the person by last name, comma,
		//			then first name.
		var eValue = "";
		var item = null;
		var matches = [];
		var mCount = 0;
		var mIndex = 0;
		var mValue = "";
		var rCount = 0;
		var result = "";
		var rIndex = 0;
		var rName = valueField;
		var rValue = "";
		// console.log("SelectExpression...");
		rCount = items.length;
		// console.log("SelectExpression field: rows count: " + rCount);
		// console.log("SelectExpression field: value:      " + value);
		// console.log("SelectExpression field: key name:   " + rName);
		if(expression)
		{
			//	Find the record first.
			for(rIndex = 0; rIndex < rCount; rIndex ++)
			{
				if(items[rIndex][rName] == value)
				{
					//	Record found.
					// console.log("SelectExpression field: Record found...");
					item = items[rIndex];
					break;
				}
			}
			if(item)
			{
				eValue = expression;
				matches = eValue.match(/\{[0-9A-Za-z]+\}/g);
				mCount = matches.length;
				for(mIndex = 0; mIndex < mCount; mIndex ++)
				{
					mValue = matches[mIndex];
					mValue = mValue.substr(1, mValue.length - 2);
					// console.log("Expression field: Find replacement for " + mValue);
					//	Get the replacement value.
					rValue = item[mValue];
					// console.log("Expression field: Use " + rValue);
					//	Replace all instances of the field.
					eValue = eValue.replace(
						new RegExp("\\{" + mValue + "\\}", "gm"), rValue);
				}
				result = eValue;
			}
			//	Future reference:
			//	result = eval("x + 1");
			//	if (eval(" var1 == null && var2 != 5")) { ... }
			// result = (new Function("return " + expression)()) { };
		}
		return result;
	},
	sorter: function(value1, value2)
	{
		//	In this context, value1 and value2 both enter with values
		//	set to whatever was found in [field.name].
		console.log("SelectExpression lookup...");
		var result = 0;
		var text1 = this.resolveExpression(value1,
			this.items, this.valueField, this.expression);
		var text2 = this.resolveExpression(value2,
			this.items, this.valueField, this.expression);
		if(text1 > text2)
		{
			result = 1;
		}
		else if(text1 < text2)
		{
			result = -1;
		}
		return result;
	}
});
jsGrid.fields.selectexpression = jsGridSelectExpressionField;
/*---------------------------------------------------------------------------*/
/*****************************************************************************/

/*****************************************************************************/
/* View -> View Model Wiring                                                 */
/*****************************************************************************/
$(document).ready(function()
{
/*---------------------------------------------------------------------------*/
/* Column Visibility                                                         */
/*---------------------------------------------------------------------------*/
	$(".columnVisibility .container input[type=checkbox]").change(function()
	{
		//	Column Name Pattern: chkcolctlxxxNNNNN
		var columnName = $(this).attr("id").substr(12);
		var fCount = 0;
		var fields = [];
		var fIndex = 0;
		var fItem = null;
		var $grid = null;
		//	Parent Name Pattern: colctlNNNNN
		var parentName = $(this).parent().parent().attr("id").substr(6);

		$grid = $("#grd" + parentName);
		console.log("Updating column visibility...");
		console.log("Parent Name: " + parentName);

		//	Check fields for match.
		fields = $grid.jsGrid("option", "fields");
		fCount = fields.length;
		console.log("Field count: " + fCount);
		for(fIndex = 0; fIndex < fCount; fIndex ++)
		{
			fItem = fields[fIndex];
			console.log("Checking " + fItem.name)
			if(fItem.name == columnName)
			{
				//	Name matches.
				break;
			}
			else if(fItem.title == columnName)
			{
				//	Switch to explicit name.
				columnName = fItem.name;
				break;
			}
		}
		$grid.jsGrid("fieldOption", columnName,
			"visible", $(this).prop("checked"));
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Row Filtering                                                             */
/*---------------------------------------------------------------------------*/
	$(".rowFilter input[type=button]").click(function()
	{
		//	Button Name Pattern: btnfiltxxxNNNNN.
		var buttonName = $(this).attr("id").substr(10);
		var externalFilters = [];
		var fields = [];
		var $grid = null;
		//	Text Name Pattern: txtfiltxxxNNNNN.
		var itemName = "";
		var itemValue = "";
		//	Parent Name Pattern: filtNNNN
		var parentName = $(this).parent().attr("id").substr(4);
		var $texts = $(this).parent().find("label input[type=text]");

		$grid = $("#grd" + parentName);
		fields = $grid.jsGrid("option", "fields");
		externalFilters = $grid.jsGrid("option", "externalFilters");
		if(buttonName == "Apply")
		{
			$texts.each(function(tItem)
			{
				itemName = $(this).attr("id").substr(10);
				itemValue = $(this).val();
				externalFilters[itemName] = itemValue;
				// console.log("External Filtering: " +
				// 	itemName + "=" + externalFilters[itemName]);
			});
		}
		else if(buttonName == "Clear")
		{
			$texts.each(function(tItem)
			{
				$(this).val("");
				itemName = $(this).attr("id").substr(10);
				externalFilters[itemName] = "";
			});
		}
		//	In this context, search is used to reload the data to the UI.
		$grid.jsGrid("search");
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Expanding Sections                                                        */
/*---------------------------------------------------------------------------*/
	$(".tabAccordian").accordion(
		{ collapsible: true, active: false, heightStyle: "content" }
	);
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Tab Pages                                                                 */
/*---------------------------------------------------------------------------*/
	$("#tabs").tabs({
		activate: function(event, ui)
		{
			switch(ui.newPanel.attr('id'))
			{
				case "Accounts":
					console.log("Tab Selected: Accounts...");
					$("#grdAccounts").jsGrid("fieldOption", "CustomerID",
						"items", customersViewModel.customers);
					$("#grdAccounts").jsGrid("fieldOption", "BranchID",
						"items", branchesViewModel.branches);
					$("#grdAccounts").jsGrid("fieldOption", "EmployeeID",
						"items", employeesViewModel.employees);
					$("#grdAccounts").jsGrid("refresh");
					break;
				case "Branches":
					$("#grdBranches").jsGrid("refresh");
				case "Customers":
					$("#grdCustomers").jsGrid("refresh");
				case "Employees":
					$("#grdEmployees").jsGrid("refresh");
					break;
			}
		}
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Accounts View                                                             */
/*---------------------------------------------------------------------------*/
	$("#grdAccounts").jsGrid(
	{
		height: "70vh",
		width: "100%",

		filtering: false,
		editing: true,
		sorting: true,
		paging: true,
		autoload: true,

		pageSize: 4,
		pageButtonCount: 5,

		deleteConfirm: "Do you really want to delete the account?",

		controller: accountsViewModel,

		fields: [
			{ name: "AccountTicket", type: "text", editing: false, width: 150 },
			{ name: "CustomerID", title: "Customer", type: "select",
				items: customersViewModel.customers,
				valueField: "CustomerID", textField: "Name", width: 150 },
			{ name: "AccountStatus", title: "Account Status", type: "select",
				items: accountsViewModel.accountStates,
				valueField: "StateName", textField: "StateName" },
			{ name: "BalanceAvailable", title: "Balance Available", type: "money" },
			{ name: "BalancePending", title: "Balance Pending", type: "money" },
			{ name: "DateOpened", title: "Date Opened", type: "date" },
			{ name: "DateClosed", title: "Date Closed", type: "date" },
			{ name: "DateLastActivity", title: "Date Last Activity", type: "date" },
			{ name: "BranchID", title: "Branch", type: "select",
				items: branchesViewModel.branches,
				valueField: "BranchID", textField: "Name" },
			{ name: "EmployeeID", title: "Employee", type: "selectexpression",
				items: employeesViewModel.employees, valueField: "EmployeeID",
				expression: "{LastName}, {FirstName}" },
			{ type: "control" }
		]
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Branches View                                                             */
/*---------------------------------------------------------------------------*/
	$("#grdBranches").jsGrid(
	{
		height: "70vh",
		width: "100%",

		filtering: false,
		editing: true,
		sorting: true,
		paging: true,
		autoload: true,

		pageSize: 4,
		pageButtonCount: 5,

		deleteConfirm: "Do you really want to delete the branch?",

		controller: branchesViewModel,

		fields:
		[
			{ name: "BranchTicket", title: "Branch Ticket", type: "text",
				editing: false, width: 150 },
			{ name: "Name", type: "text", editing: false },
			{ name: "Address", type: "text" },
			{ name: "City", type: "text" },
			{ name: "State", type: "text" },
			{ name: "ZipCode", title: "Zip Code", type: "text" }
		]
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Customers View                                                            */
/*---------------------------------------------------------------------------*/
	$("#grdCustomers").jsGrid(
	{
		// height: "70vh",
		width: "100%",

		filtering: false,
		editing: true,
		sorting: true,
		paging: true,
		autoload: true,

		pageSize: 4,
		pageButtonCount: 5,

		deleteConfirm: "Do you really want to delete the customer?",

		controller: customersViewModel,

		fields: [
			{ name: "CustomerTicket", type: "text", editing: false, width: 150 },
			{ name: "Name", type: "text", width: 150 },
			{ name: "Address", type: "text" },
			{ name: "City", type: "text" },
			{ name: "State", type: "text" },
			{ name: "ZipCode", type: "text" },
			{ name: "TIN", type: "text" },
			{ type: "control" }
		]
	});
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Employees View                                                            */
/*---------------------------------------------------------------------------*/
	$("#grdEmployees").jsGrid(
	{
		height: "70vh",
		width: "100%",

		filtering: false,
		editing: true,
		sorting: true,
		paging: true,
		autoload: true,

		pageSize: 4,
		pageButtonCount: 5,

		deleteConfirm: "Do you really want to delete the employee?",

		controller: employeesViewModel,

		fields:
		[
			{ name: "EmployeeTicket", title: "Employee Ticket", type: "text",
				editing: false, width: 150 },
			{ name: "EmployeeID", title: "Display Name", type: "expression",
				expression: "{LastName}, {FirstName}" },
			{ name: "Title", type: "text" },
			{ name: "TIN", type: "text" },
			{ name: "DateStarted", title: "Date Started", type: "date" },
			{ name: "DateEnded", title: "Date Ended", type: "date" }
		]
	});
/*---------------------------------------------------------------------------*/
});
/*****************************************************************************/

(function()
{
/*****************************************************************************/
/* View Models                                                               */
/*****************************************************************************/
/*---------------------------------------------------------------------------*/
/* Accounts View Model                                                       */
/*---------------------------------------------------------------------------*/
	var accountsViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var accountIndex = $.inArray(deletedItem, this.accounts);
			this.accounts.splice(accountIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.accounts.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("accountsDB.loadData...");
			var cCount = this.accounts.length;
			var cIndex = 0;
			var cItem = null;
			var grid = $("#grdAccounts");
			var result = this.accounts;
			//	Remove dashes from tickets.
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.accounts[cIndex];
				cItem.AccountTicket =
					cItem.AccountTicket.replace(/-/g, ' ');
			}
			if(grid.jsGrid("option", "filtering"))
			{
				//	This leg used when grid filtering is on.
				result = $.grep(this.accounts, function(account)
				{
					return (!filter.AccountTicket ||
						account.AccountTicket.toLowerCase().
						indexOf(filter.AccountTicket.toLowerCase()) > -1) &&
						(!filter.AccountStatus ||
						account.AccountStatus.toLowerCase().
						indexOf(filter.AccountStatus.toLowerCase()) > -1);
				});
			}
			else if(grid.jsGrid("option", "externalFilters"))
			{
				//	This leg supports external filtering.
				var externalFilters = grid.jsGrid("option", "externalFilters");
				var fCount = 0;
				var fields = grid.jsGrid("option", "fields");
				var filterName = "";
				var filterValue = "";
				var fIndex = 0;
				var fItem = null;
				// var itemTemplate = grid.jsGrid("fieldOption", columnName, "itemTemplate");
				var itemTemplate = null;
				var kCount = 0;
				var keys = Object.keys(externalFilters);
				var kIndex = 0;

				kCount = keys.length;
				fCount = fields.length;
				// console.log("Account loadData / key count:   " + kCount);
				// console.log("Account loadData / field count: " + fCount);
				if(kCount > 0 && fCount > 0)
				{
					for(kIndex = 0; kIndex < kCount; kIndex ++)
					{
						filterName = keys[kIndex];
						filterValue = externalFilters[filterName];
						if(filterValue)
						{
							//	Filter specified. Get the actual field name.
							for(fIndex = 0; fIndex < fCount; fIndex ++)
							{
								if(filterName == fields[fIndex].Title)
								{
									//	Assign the same search to the filter for the base column.
									externalFilters[fields[fIndex].name] = filterValue;
									break;
								}
							}
						}
					}

					//	Indirect filtering example.
					result = $.grep(this.accounts, function(account)
					{
						var fieldItem = null;
						var fieldName = "";
						var fieldType = "";
						var filterFunction = "";
						var filterParts = [];
						var gResult = true;
						var itemValue = null;

						// console.log("Checking " + kCount + " filters...");
						for(kIndex = 0; kIndex < kCount; kIndex ++)
						{
							filterName = keys[kIndex];
							console.log("Filter: " + filterName);
							filterFunction = "";
							filterValue = externalFilters[filterName];
							if(filterName.indexOf(".") > -1)
							{
								//	Aggregate, Range, or Function is in use.
								//	Currently, only range is supported.
								filterParts = filterName.split(".");
								filterName = filterParts[0];
								filterFunction = filterParts[1].toLowerCase();
							}
							if(filterValue)
							{
								//	Filter specified.
								fieldName = "";
								for(fIndex = 0; fIndex < fCount; fIndex ++)
								{
									fieldItem = fields[fIndex];
									if(fieldItem.name == filterName ||
										fieldItem.title == filterName)
									{
										//	Field found for filter.
										fieldName = fieldItem.name;
										itemTemplate = fieldItem.itemTemplate;
										if(fieldItem.title == filterName)
										{
											//	Copy the filter to the actual field.
											externalFilters[fieldName] = filterValue;
										}
										break;
									}
								}
								if(fieldName)
								{
									itemValue = itemTemplate.call(fieldItem, account[fieldName]);
									// console.log("Checking " + fieldName + " for " + itemValue);
									if(filterFunction)
									{
										//	Aggregate, Range, or Function comparison.
										//	Currently, only range is supported.
										fieldType = fieldItem.type;
										switch(filterFunction)
										{
											case "max":
												switch(fieldType)
												{
													case "checkbox":
														if(booleanToNumber(toBoolean(itemValue)) >
															booleanToNumber(toBoolean(filterValue)))
														{
															gResult = false;
														}
														break;
													case "date":
														if(new Date(itemValue) > new Date(filterValue))
														{
															gResult = false;
														}
														break;
													case "money":
													case "number":
														if(toNumber(itemValue) > toNumber(filterValue))
														{
															gResult = false;
														}
														break;
													case "select":
													case "selectexpression":
													case "text":
													case "textarea":
														if(itemValue > filterValue)
														{
															gResult = false;
														}
														break;
												}
												break;
											case "min":
												switch(fieldType)
												{
													case "checkbox":
														if(booleanToNumber(toBoolean(itemValue)) <
															booleanToNumber(toBoolean(filterValue)))
														{
															gResult = false;
														}
														break;
													case "date":
														console.log("Min Date Filter (" +
															itemValue + " < " + filterValue + ")?");
														if(new Date(itemValue) < new Date(filterValue))
														{
															gResult = false;
														}
														break;
													case "money":
													case "number":
														console.log("Min Number Filter (" +
														toNumber(itemValue) + " < " + toNumber(filterValue) + ")?");
														if(toNumber(itemValue) < toNumber(filterValue))
														{
															gResult = false;
														}
														break;
													case "select":
													case "selectexpression":
													case "text":
													case "textarea":
														if(itemValue < filterValue)
														{
															gResult = false;
														}
														break;
												}
												break;
										}
										if(!gResult)
										{
											break;
										}
									}
									else
									{
										//	Straight value comparison.
										if(itemValue.toLowerCase().
										indexOf(externalFilters[fieldName]) < 0)
										{
											// console.log("Filter non-match in " + fieldName);
											gResult = false;
											break;
										}
									}
								}
							}
							else
							{
								//	Make sure that if this filter is empty, any indirectly related
								//	filter value is also empty.
								fieldName = "";
								for(fIndex = 0; fIndex < fCount; fIndex ++)
								{
									fieldItem = fields[fIndex];
									if(fieldItem.title == filterName)
									{
										//	Field found for filter.
										externalFilters[fieldItem.name] = "";
										break;
									}
								}
							}
						}
						return gResult;
					});
					}
			}
			return result;
		},
		updateItem: function(changedItem)
		{
		}
	};
	window.accountsViewModel = accountsViewModel;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Branches View Model                                                       */
/*---------------------------------------------------------------------------*/
	var branchesViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var branchIndex = $.inArray(deletedItem, this.branches);
			this.branches.splice(branchIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.branches.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("branchesDB.loadData...");
			var cCount = this.branches.length;
			var cIndex = 0;
			var cItem = null;
			//	Remove dashes from tickets.
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.branches[cIndex];
				cItem.BranchTicket =
					cItem.BranchTicket.replace(/-/g, ' ');
			}
			return $.grep(this.branches, function(branch)
			{
				return (!filter.BranchTicket ||
					branch.BranchTicket.toLowerCase().
					indexOf(filter.BranchTicket.toLowerCase()) > -1);
			});
		},
		updateItem: function(changedItem)
		{
		}
	};
	window.branchesViewModel = branchesViewModel;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Customers View Model                                                      */
/*---------------------------------------------------------------------------*/
	var customersViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var customerIndex = $.inArray(deletedItem, this.customers);
			this.customers.splice(customerIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.customers.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("customersDB.loadData...");
			var cCount = this.customers.length;
			var cIndex = 0;
			var cItem = null;
			var grid = $("#grdCustomers");
			var result = this.customers;
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.customers[cIndex];
				cItem.CustomerTicket =
					cItem.CustomerTicket.replace(/-/g, ' ');
			}
			if(grid.jsGrid("option", "filtering"))
			{
				//	Support for built-in filtering.
				result = $.grep(this.customers, function(customer)
				{
					return (!filter.CustomerTicket ||
						customer.CustomerTicket.toLowerCase().
						indexOf(filter.CustomerTicket.toLowerCase()) > -1) &&
						(!filter.Name ||
						customer.Name.toLowerCase().
						indexOf(filter.Name.toLowerCase()) > -1) &&
						(!filter.Address ||
						customer.Address.toLowerCase().
						indexOf(filter.Address.toLowerCase()) > -1) &&
						(!filter.City ||
						customer.City.toLowerCase().
						indexOf(filter.City.toLowerCase()) > -1) &&
						(!filter.State ||
						customer.State.toLowerCase().
						indexOf(filter.State.toLowerCase()) > -1) &&
						(!filter.ZipCode ||
						customer.ZipCode == filter.ZipCode) &&
						(!filter.TIN ||
						customer.TIN.indexOf(filter.TIN) > -1);
				});
			}
			else if(grid.jsGrid("option", "externalFilters"))
			{
				//	Support for external filters.
				var externalFilters = grid.jsGrid("option", "externalFilters");
				// console.log("Customers Grid: Process external filters...");
				result = $.grep(this.customers, function(customer)
				{
					return (!externalFilters.CustomerTicket ||
						customer.CustomerTicket.toLowerCase().
						indexOf(externalFilters.CustomerTicket.toLowerCase()) > -1) &&
						(!externalFilters.Name ||
						customer.Name.toLowerCase().
						indexOf(externalFilters.Name.toLowerCase()) > -1) &&
						(!externalFilters.Address ||
						customer.Address.toLowerCase().
						indexOf(externalFilters.Address.toLowerCase()) > -1) &&
						(!externalFilters.City ||
						customer.City.toLowerCase().
						indexOf(externalFilters.City.toLowerCase()) > -1) &&
						(!externalFilters.State ||
						customer.State.toLowerCase().
						indexOf(externalFilters.State.toLowerCase()) > -1) &&
						(!externalFilters.ZipCode ||
						customer.ZipCode == externalFilters.ZipCode) &&
						(!externalFilters.TIN ||
						customer.TIN.indexOf(externalFilters.TIN) > -1);
				});
			}
			return result;
		},
		updateItem: function(changedItem)
		{
			console.log("Changed Item ID: " + changedItem.CustomerID);
			var cCount = this.customers.length;
			var cIndex = 0;
			var cItem = null;
			var cName = "";
			var fCount = 0;
			var fIndex = 0;
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.customers[cIndex];
				if(cItem.CustomerID == changedItem.CustomerID)
				{
					//	Changed item found.
					console.log("Changed item found...");
					console.log("Old Name: " + cItem.Name);
					console.log("Changed Name: " + changedItem.Name);
					fCount = Object.keys(changedItem).length;
					console.log("Field Count: " + fCount);
					for(fIndex = 1; fIndex < fCount; fIndex ++)
					{
						cName = Object.keys(changedItem)[fIndex];
						cItem[cName] = changedItem[cName];
					}
					console.log("New Name: " + this.customers[cIndex].Name);
				}
			}
		}
	};
	window.customersViewModel = customersViewModel;
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Employees View Model                                                      */
/*---------------------------------------------------------------------------*/
	var employeesViewModel =
	{
		deleteItem: function(deletedItem)
		{
			var employeeIndex = $.inArray(deletedItem, this.employees);
			this.employees.splice(employeeIndex, 1);
		},
		insertItem: function(newItem)
		{
			this.employees.push(newItem);
		},
		loadData: function(filter)
		{
			console.log("employeesDB.loadData...");
			var cCount = this.employees.length;
			var cIndex = 0;
			var cItem = null;
			//	Remove dashes from tickets.
			for(; cIndex < cCount; cIndex ++)
			{
				cItem = this.employees[cIndex];
				cItem.EmployeeTicket =
					cItem.EmployeeTicket.replace(/-/g, ' ');
			}
			return $.grep(this.employees, function(employee)
			{
				return (!filter.EmployeeTicket ||
					employee.EmployeeTicket.toLowerCase().
					indexOf(filter.EmployeeTicket.toLowerCase()) > -1);
			});
		},
		updateItem: function(changedItem)
		{
		}
	};
	window.employeesViewModel = employeesViewModel;
/*---------------------------------------------------------------------------*/
/*****************************************************************************/

/*****************************************************************************/
/* Models                                                                    */
/*****************************************************************************/
/*---------------------------------------------------------------------------*/
/* Account Models                                                            */
/*---------------------------------------------------------------------------*/
	accountsViewModel.accountStates =
	[
		{
			"StateName": "Active"
		},
		{
			"StateName": "Closed"
		},
		{
			"StateName": "Pending"
		}
	];
	accountsViewModel.accounts =
	[{
		"AccountID": 1,
		"AccountTicket": "F94259BE-92A2-4DFA-A1F9-1370A341F5F1",
		"CustomerID": 8,
		"AccountStatus": "Active",
		"BalanceAvailable": 4887.54,
		"BalancePending": 4887.54,
		"DateOpened": "10/16/2001",
		"DateClosed": null,
		"DateLastActivity": "12/26/2017",
		"BranchID": 1,
		"EmployeeID": 5
	},
	{
		"AccountID": 2,
		"AccountTicket": "5E33AE21-BA5F-4974-BBC3-8A65CFBBEA25",
		"CustomerID": 15,
		"AccountStatus": "Active",
		"BalanceAvailable": 17425.66,
		"BalancePending": 17425.66,
		"DateOpened": "03/14/1983",
		"DateClosed": null,
		"DateLastActivity": "01/27/1990",
		"BranchID": 4,
		"EmployeeID": 2
	},
	{
		"AccountID": 3,
		"AccountTicket": "ECA74C94-3148-4DA3-8AC2-6A34982F290D",
		"CustomerID": 18,
		"AccountStatus": "Active",
		"BalanceAvailable": 19988.78,
		"BalancePending": 8643.23,
		"DateOpened": "07/18/1981",
		"DateClosed": null,
		"DateLastActivity": "11/22/1994",
		"BranchID": 4,
		"EmployeeID": 4
	},
	{
		"AccountID": 4,
		"AccountTicket": "0CED83D0-464C-4BDD-92ED-7ACB8E5155AD",
		"CustomerID": 2,
		"AccountStatus": "Active",
		"BalanceAvailable": 8561.62,
		"BalancePending": 8561.62,
		"DateOpened": "01/26/2011",
		"DateClosed": null,
		"DateLastActivity": "02/12/2012",
		"BranchID": 1,
		"EmployeeID": 4
	},
	{
		"AccountID": 5,
		"AccountTicket": "D3684C78-5B0E-4A22-A687-5D627B85677F",
		"CustomerID": 9,
		"AccountStatus": "Active",
		"BalanceAvailable": 23698.24,
		"BalancePending": 23698.24,
		"DateOpened": "07/17/1997",
		"DateClosed": null,
		"DateLastActivity": "09/07/2011",
		"BranchID": 1,
		"EmployeeID": 2
	},
	{
		"AccountID": 6,
		"AccountTicket": "CB98FCE0-BA25-454C-BEBC-3C7EE6733961",
		"CustomerID": 5,
		"AccountStatus": "Active",
		"BalanceAvailable": 24205.64,
		"BalancePending": 24205.64,
		"DateOpened": "12/20/1983",
		"DateClosed": null,
		"DateLastActivity": "03/20/1988",
		"BranchID": 3,
		"EmployeeID": 2
	},
	{
		"AccountID": 7,
		"AccountTicket": "54FDE9A0-D45D-4AB3-9B84-7BA92596E71B",
		"CustomerID": 8,
		"AccountStatus": "Active",
		"BalanceAvailable": 852.13,
		"BalancePending": 1310.49,
		"DateOpened": "12/14/2008",
		"DateClosed": null,
		"DateLastActivity": "10/07/2016",
		"BranchID": 4,
		"EmployeeID": 4
	}
	];
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Branch Models                                                             */
/*---------------------------------------------------------------------------*/
	branchesViewModel.branches =
	[{
		"BranchID": 1,
		"BranchTicket": "382E9559-3AFB-4BDC-99B9-049808578789",
		"Name": "North",
		"Address": "4026 Lauren Drive",
		"City": "Madison",
		"State": "WI",
		"ZipCode": 53704
	},
	{
		"BranchID": 2,
		"BranchTicket": "4C13BB4E-4072-41B1-BE31-33DF7E806470",
		"Name": "South",
		"Address": "1250 Buffalo Creek Road",
		"City": "Nashville",
		"State": "TN",
		"ZipCode": 37214
	},
	{
		"BranchID": 3,
		"BranchTicket": "2B0DD67D-0AF4-4932-8DF0-543E2F9369B4",
		"Name": "East",
		"Address": "1104 Jacobs Street",
		"City": "Pittsburgh",
		"State": "PA",
		"ZipCode": 15212
	},
	{
		"BranchID": 4,
		"BranchTicket": "4BEEE4EE-28D7-494E-8331-9B43313D1C08",
		"Name": "West",
		"Address": "3339 Ridenour Street",
		"City": "Doral",
		"State": "FL",
		"ZipCode": 33166
	}
	];
/*---------------------------------------------------------------------------*/
	
/*---------------------------------------------------------------------------*/
/* Customer Models                                                           */
/*---------------------------------------------------------------------------*/
	customersViewModel.customers =
	[{
		"CustomerID": 1,
		"CustomerTicket": "6B28522A-D002-4D28-A307-9DBBA5CD6286",
		"Name": "Consolidated Messenger",
		"Address": "4786 Locust Court",
		"City": "Fresno",
		"State": "CA",
		"ZipCode": 90248,
		"TIN": "33-6566647"
	},
	{
		"CustomerID": 2,
		"CustomerTicket": "92FDBA50-E929-46C1-A019-8CFFE9FAE7D6",
		"Name": "Alpine Ski House",
		"Address": "523 Redbud Drive",
		"City": "New York",
		"State": "NY",
		"ZipCode": 10013,
		"TIN": "90-3818787"
	},
	{
		"CustomerID": 3,
		"CustomerTicket": "FEEED429-AB29-41C6-B71A-5D93C4910061",
		"Name": "Southridge Video",
		"Address": "2205 Cooks Mine Road",
		"City": "Albuquerque",
		"State": "NM",
		"ZipCode": 87102,
		"TIN": "06-1886298"
	},
	{
		"CustomerID": 4,
		"CustomerTicket": "9D0F2962-F1EC-4409-85D7-DA79D2FD503C",
		"Name": "City Power & Light",
		"Address": "2502 Oak Avenue",
		"City": "Schaumburg",
		"State": "IL",
		"ZipCode": 60173,
		"TIN": "19-7270587"
	},
	{
		"CustomerID": 5,
		"CustomerTicket": "2806379A-6145-4357-B7AC-EA208BE25581",
		"Name": "Coho Winery",
		"Address": "112 West Street",
		"City": "Casnovia",
		"State": "MI",
		"ZipCode": 49318,
		"TIN": "79-9418423"
	},
	{
		"CustomerID": 6,
		"CustomerTicket": "E785DAAC-9C3A-4419-9A81-898108B9253B",
		"Name": "Wide World Importers",
		"Address": "3148 Passaic Street",
		"City": "Reston",
		"State": "DC",
		"ZipCode": 20191,
		"TIN": "56-2467496"
	},
	{
		"CustomerID": 7,
		"CustomerTicket": "65CDCEC2-368A-4B29-A156-0E0BB8FEA7FF",
		"Name": "Graphic Design Institute",
		"Address": "193 Poling Farm Road",
		"City": "Randolph",
		"State": "NE",
		"ZipCode": 68771,
		"TIN": "56-6751685"
	},
	{
		"CustomerID": 8,
		"CustomerTicket": "ED3F3567-85A9-416B-909E-B25955D77E2A",
		"Name": "Adventure Works",
		"Address": "211 Farland Avenue",
		"City": "Uvalde",
		"State": "TX",
		"ZipCode": 78801,
		"TIN": "39-1309162"
	},
	{
		"CustomerID": 9,
		"CustomerTicket": "924C9BAD-F3C9-445C-BDEC-C3BF20F15245",
		"Name": "Humongous Insurance",
		"Address": "1717 Edgewood Avenue",
		"City": "Fresno",
		"State": "CA",
		"ZipCode": 93721,
		"TIN": "40-8819895"
	},
	{
		"CustomerID": 10,
		"CustomerTicket": "19E7E150-8B2A-408D-B0B5-5BAA43FD7A09",
		"Name": "Woodgrove Bank",
		"Address": "2110 Maple Street",
		"City": "Irvine",
		"State": "CA",
		"ZipCode": 92614,
		"TIN": "92-4691264"
	},
	{
		"CustomerID": 11,
		"CustomerTicket": "04CEBA25-4680-40BD-83BE-9C68217A0E87",
		"Name": "Margie's Travel",
		"Address": "3379 College Street",
		"City": "Decatur",
		"State": "GA",
		"ZipCode": 30030,
		"TIN": "18-9269063"
	},
	{
		"CustomerID": 12,
		"CustomerTicket": "9EFCA023-0BA6-404D-88D9-01061C419656",
		"Name": "Northwind Traders",
		"Address": "3850 Elk City Road",
		"City": "Indianapolis",
		"State": "IN",
		"ZipCode": 46205,
		"TIN": "87-4224500"
	},
	{
		"CustomerID": 13,
		"CustomerTicket": "200DC2FD-0297-4D59-A429-5044505B4D2E",
		"Name": "Blue Yonder Airlines",
		"Address": "33 Trouser Leg Road",
		"City": "Shelburne",
		"State": "MA",
		"ZipCode": 1301,
		"TIN": "32-3149379"
	},
	{
		"CustomerID": 14,
		"CustomerTicket": "E802AAFF-458A-4346-8E80-8FC25714476C",
		"Name": "Trey Research",
		"Address": "707 Bruce Street",
		"City": "St. Louis",
		"State": "MO",
		"ZipCode": 63101,
		"TIN": "53-9702721"
	},
	{
		"CustomerID": 15,
		"CustomerTicket": "0DC2939F-551A-4E65-A008-C2A423E39C39",
		"Name": "The Phone Company",
		"Address": "1805 Tori Lane",
		"City": "Midvale",
		"State": "UT",
		"ZipCode": 84047,
		"TIN": "29-7989701"
	},
	{
		"CustomerID": 16,
		"CustomerTicket": "B5BB0382-32F2-4339-B8F3-3C29EC55568A",
		"Name": "Wingtip Toys",
		"Address": "3280 Biddie Lane",
		"City": "Hopewell",
		"State": "VA",
		"ZipCode": 23860,
		"TIN": "41-3534687"
	},
	{
		"CustomerID": 17,
		"CustomerTicket": "AEF13C51-8C70-4A30-B1B3-3E5BDA400E99",
		"Name": "Lucerne Publishing",
		"Address": "1336 Stoney Lonesome Road",
		"City": "Scranton",
		"State": "PA",
		"ZipCode": 18510,
		"TIN": "94-4071874"
	},
	{
		"CustomerID": 18,
		"CustomerTicket": "052B2DE5-A02B-4DD4-969A-7D16F68AB290",
		"Name": "Fourth Coffee",
		"Address": "3288 Finwood Road",
		"City": "Fresno",
		"State": "NJ",
		"ZipCode": 7728,
		"TIN": "27-2130193"
	}
	];
/*---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------*/
/* Employee Models                                                           */
/*---------------------------------------------------------------------------*/
	employeesViewModel.employees =
	[{
		"EmployeeID": 1,
		"EmployeeTicket": "0760656E-5790-4615-AE50-3032236AAC1D",
		"FirstName": "Eva",
		"LastName": "Kilpatrick",
		"DateStarted": "12/19/2011",
		"DateEnded": null,
		"Title": "Teller",
		"TIN": "115-98-6023"
	},
	{
		"EmployeeID": 2,
		"EmployeeTicket": "81B4F116-1080-4E0C-96B5-C2EA781B21C7",
		"FirstName": "Joyce",
		"LastName": "Kearney",
		"DateStarted": "03/03/2014",
		"DateEnded": null,
		"Title": "Teller",
		"TIN": "937-46-1306"
	},
	{
		"EmployeeID": 3,
		"EmployeeTicket": "907826F3-1ED0-4565-AB95-13CA3C8A36C7",
		"FirstName": "Paula",
		"LastName": "Fuller",
		"DateStarted": "08/23/2010",
		"DateEnded": null,
		"Title": "New Accounts",
		"TIN": "281-76-4390"
	},
	{
		"EmployeeID": 4,
		"EmployeeTicket": "C9853CE7-5546-4940-8BE0-96589595C70C",
		"FirstName": "Frank",
		"LastName": "Wozniak",
		"DateStarted": "04/08/2011",
		"DateEnded": null,
		"Title": "New Accounts",
		"TIN": "925-37-2799"
	},
	{
		"EmployeeID": 5,
		"EmployeeTicket": "FE833889-725F-4693-BC9B-B2AB2B86B522",
		"FirstName": "Donald",
		"LastName": "Crawley",
		"DateStarted": "01/25/1988",
		"DateEnded": null,
		"Title": "Operations Supervisor",
		"TIN": "777-11-9237"
	}
	];
/*---------------------------------------------------------------------------*/
/*****************************************************************************/
}());
