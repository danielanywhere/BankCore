using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace SimpleExpressionEvaluator
{
	//*-------------------------------------------------------------------------*
	//*	ExpressionEvaluator																											*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Class for compiling and evaluating simple mathematical expressions.
	/// </summary>
	/// <remarks>
	/// <para>
	/// Original project was written by Giorgi Dalakishvili is found at 
	/// <a href="https://github.com/Giorgi/Math-Expression-Evaluator">
	/// Giorgi / Math-Expression-Evaluator</a>. It can be installed as a NuGet
	/// package with the name of Math-Expression-Evaluator in Visual Studio
	/// 2017 and later.
	/// </para>
	/// <para>
	/// This version has been strictly type formatted, and was modified by
	/// Daniel Patterson to be backward-compatible with Visual Studio 2013.
	/// </para>
	/// </remarks>
	/// <example>
	/// <para>
	/// Use variables in an expression.
	/// </para>
	/// <code>
	/// var a = 6;
	/// var b = 4.32m;
	/// var c = 24.15m;
	/// Assert.That(engine.Evaluate("(((9-a/2)*2-b)/2-a-1)/(2+c/(2+4))",
	///  new { a, b, c}),
	///  Is.EqualTo((((9 - a / 2) * 2 - b) / 2 - a - 1) /
	///  (2 + c / (2 + 4))));
	/// </code>
	/// <para>
	/// Use named variables.
	/// </para>
	/// <code>
	/// dynamic dynamicEngine = new ExpressionEvaluator();
	///
	/// var a = 6;
	/// var b = 4.5m;
	/// var c = 2.6m;
	/// Assert.That(dynamicEngine.Evaluate("(c+b)*a", a: 6, b: 4.5, c: 2.6),
	///  Is.EqualTo((c + b) * a));
	/// </code>
	/// </example>
	public class ExpressionEvaluator : DynamicObject
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private readonly Stack<Expression> expressionStack =
			new Stack<Expression>();
		private readonly Stack<Symbol> operatorStack = new Stack<Symbol>();
		private readonly List<string> parameters = new List<string>();

		//*-----------------------------------------------------------------------*
		//*	Evaluate																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Evaluate the expression using the list of argument names and values.
		/// </summary>
		/// <param name="expression">
		/// Expression to analyze.
		/// </param>
		/// <param name="arguments">
		/// Dictionary of argument names and values.
		/// </param>
		/// <returns>
		/// Final result of the expression.
		/// </returns>
		private decimal Evaluate(string expression,
			Dictionary<string, decimal> arguments)
		{
			Func<Decimal[], Decimal> compiled = Parse(expression);

			return Execute(compiled, arguments, parameters);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	EvaluateWhile																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Evaluate while the specified condition is true.
		/// </summary>
		/// <param name="condition">
		/// Condition to test.
		/// </param>
		private void EvaluateWhile(Func<bool> condition)
		{
			while(condition())
			{
				Operation operation = (Operation)operatorStack.Pop();

				Expression[] expressions = new Expression[operation.NumberOfOperands];
				for(var i = operation.NumberOfOperands - 1; i >= 0; i--)
				{
					expressions[i] = expressionStack.Pop();
				}
				expressionStack.Push(operation.Apply(expressions));
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Execute																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Execute the compiled expression.
		/// </summary>
		/// <param name="compiled">
		/// The pre-evaluated expression.
		/// </param>
		/// <param name="arguments">
		/// List of argument names and values to resolve.
		/// </param>
		/// <param name="parameters">
		/// List of parameters to use in solution.
		/// </param>
		/// <returns>
		/// Value indicating whether execution was a success.
		/// </returns>
		private decimal Execute(Func<decimal[], decimal> compiled,
			Dictionary<string, decimal> arguments, List<string> parameters)
		{
			arguments = arguments ?? new Dictionary<string, decimal>();

			if(parameters.Count != arguments.Count)
			{
				//	DEP-20180502.0637 - Back-formatted for compatibility with VS2013.
				throw new ArgumentException("Expression contains " +
					"{parameters.Count} parameters but got {arguments.Count} arguments");
				//	Original
				//throw new ArgumentException(
				//	$"Expression contains {parameters.Count} " +
				//	"parameters but got {arguments.Count} arguments");
			}

			var missingParameters =
				parameters.Where(p => !arguments.ContainsKey(p)).ToList();

			if(missingParameters.Any())
			{
				throw new ArgumentException("No values provided for parameters: " +
					string.Join(",", missingParameters));
			}

			var values =
				parameters.Select(parameter => arguments[parameter]).ToArray();

			return compiled(values);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	IsNumeric																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a value indicating whether the specified type is a numeric
		/// type.
		/// </summary>
		/// <param name="type">
		/// Type to consider.
		/// </param>
		/// <returns>
		/// True if the specified type is always numeric. Otherwise, false.
		/// </returns>
		private bool IsNumeric(Type type)
		{
			switch(Type.GetTypeCode(type))
			{
				case TypeCode.SByte:
				case TypeCode.Byte:
				case TypeCode.Int16:
				case TypeCode.UInt16:
				case TypeCode.Int32:
				case TypeCode.UInt32:
				case TypeCode.Int64:
				case TypeCode.UInt64:
				case TypeCode.Single:
				case TypeCode.Double:
				case TypeCode.Decimal:
					return true;
			}
			return false;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Parse																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Parse the expression.
		/// </summary>
		/// <param name="expression">
		/// Expression to analyze.
		/// </param>
		/// <returns>
		/// Value indicating whether the compilation of the expression succeeded.
		/// </returns>
		private Func<decimal[], decimal> Parse(string expression)
		{
			if(string.IsNullOrWhiteSpace(expression))
			{
				return s => 0;
			}

			ParameterExpression arrayParameter =
				Expression.Parameter(typeof(decimal[]), "args");

			parameters.Clear();
			operatorStack.Clear();
			expressionStack.Clear();

			using(StringReader reader = new StringReader(expression))
			{
				int peek;
				while((peek = reader.Peek()) > -1)
				{
					char next = (char)peek;

					if(char.IsDigit(next))
					{
						expressionStack.Push(ReadOperand(reader));
						continue;
					}

					if(char.IsLetter(next))
					{
						expressionStack.Push(ReadParameter(reader, arrayParameter));
						continue;
					}

					if(Operation.IsDefined(next))
					{
						if(next == '-' && expressionStack.Count == 0)
						{
							reader.Read();
							operatorStack.Push(Operation.UnaryMinus);
							continue;
						}

						Operation currentOperation = ReadOperation(reader);

						EvaluateWhile(() => operatorStack.Count > 0 &&
							operatorStack.Peek() != Parentheses.Left &&
							currentOperation.Precedence <=
							((Operation)operatorStack.Peek()).Precedence);

						operatorStack.Push(currentOperation);
						continue;
					}

					if(next == '(')
					{
						reader.Read();
						operatorStack.Push(Parentheses.Left);

						if(reader.Peek() == '-')
						{
							reader.Read();
							operatorStack.Push(Operation.UnaryMinus);
						}

						continue;
					}

					if(next == ')')
					{
						reader.Read();
						EvaluateWhile(() => operatorStack.Count > 0 &&
							operatorStack.Peek() != Parentheses.Left);
						operatorStack.Pop();
						continue;
					}

					if(next == ' ')
					{
						reader.Read();
					}
					else
					{
						//	DEP-20180502.0637-Back-formatted for compatibility with VS2013.
						throw new ArgumentException(
							"Encountered invalid character in {next}");
						//	Original.
						//throw new ArgumentException(
						//	$"Encountered invalid character {next}", nameof(expression));
					}
				}
			}

			EvaluateWhile(() => operatorStack.Count > 0);

			Expression<Func<decimal[], decimal>> lambda =
				Expression.Lambda<Func<decimal[],
				decimal>>(expressionStack.Pop(), arrayParameter);
			Func<decimal[], decimal> compiled = lambda.Compile();
			return compiled;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ParseArguments																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Resolve the arguments of the expression.
		/// </summary>
		/// <param name="argument">
		/// Single argument to parse.
		/// </param>
		/// <returns>
		/// Names and values of the argument resolved.
		/// </returns>
		private Dictionary<string, decimal> ParseArguments(object argument)
		{
			if(argument == null)
			{
				return new Dictionary<string, decimal>();
			}

			Type argumentType = argument.GetType();

			IEnumerable<PropertyInfo> properties = argumentType.GetProperties(
				BindingFlags.Instance | BindingFlags.Public).
				Where(p => p.CanRead && IsNumeric(p.PropertyType));

			Dictionary<string, decimal> arguments =
				properties.ToDictionary(property => property.Name,
				property => Convert.ToDecimal(property.GetValue(argument, null)));

			return arguments;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ReadOperand																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Read the current character in line as an operand.
		/// </summary>
		/// <param name="reader">
		/// Text Reader positioned at the next available character.
		/// </param>
		/// <returns>
		/// Expression representing the next available character as an operand.
		/// </returns>
		private Expression ReadOperand(TextReader reader)
		{
			char decimalSeparator = Culture.NumberFormat.NumberDecimalSeparator[0];
			char groupSeparator = Culture.NumberFormat.NumberGroupSeparator[0];

			string operand = string.Empty;

			int peek;

			while((peek = reader.Peek()) > -1)
			{
				char next = (char)peek;

				if(char.IsDigit(next) ||
					next == decimalSeparator ||
					next == groupSeparator)
				{
					reader.Read();
					operand += next;
				}
				else
				{
					break;
				}
			}

			return Expression.Constant(decimal.Parse(operand, Culture));
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ReadOperation																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Read the current character in line as an operator.
		/// </summary>
		/// <param name="reader">
		/// Text Reader positioned at the next available character.
		/// </param>
		/// <returns>
		/// Expression representing the next available character as an operator.
		/// </returns>
		private Operation ReadOperation(TextReader reader)
		{
			char operation = (char)reader.Read();
			return (Operation)operation;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	ReadParameter																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Read the current character in line as a parameter.
		/// </summary>
		/// <param name="reader">
		/// Text Reader positioned at the next available character.
		/// </param>
		/// <param name="arrayParameter">
		/// Parameter of an array.
		/// </param>
		/// <returns>
		/// Expression representing the next available character an a parameter of
		/// an array.
		/// </returns>
		private Expression ReadParameter(TextReader reader,
			Expression arrayParameter)
		{
			string parameter = string.Empty;

			int peek;

			while((peek = reader.Peek()) > -1)
			{
				char next = (char)peek;

				if(char.IsLetter(next))
				{
					reader.Read();
					parameter += next;
				}
				else
				{
					break;
				}
			}

			if(!parameters.Contains(parameter))
			{
				parameters.Add(parameter);
			}

			return Expression.ArrayIndex(arrayParameter,
				Expression.Constant(parameters.IndexOf(parameter)));
		}
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		/// <summary>
		/// Gets the current culture used by <see cref="ExpressionEvaluator">
		/// </see> when parsing strings into numbers
		/// </summary>
		public CultureInfo Culture { get; set; }

		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new Instance of the ExpressionEvaluator Item.
		/// </summary>
		/// <remarks>
		/// Initializes new instance of <see cref="ExpressionEvaluator"></see> 
		/// using <see cref="CultureInfo.InvariantCulture" />
		/// </remarks>
		public ExpressionEvaluator()
			: this(CultureInfo.InvariantCulture)
		{
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Initializes new instance of <see cref="ExpressionEvaluator"></see> 
		/// using specified culture info
		/// </summary>
		/// <param name="culture">
		/// Culture to use for parsing decimal numbers.
		/// </param>
		public ExpressionEvaluator(CultureInfo culture)
		{
			Culture = culture;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Compile																																*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Compiles parameterized mathematical expression into a delegate which
		/// can be invoked with different arguments without having to parse the
		/// expression again.
		/// </summary>
		/// <param name="expression">Expression to parse and compile</param>
		/// <returns>Delegate compiled from the expression</returns>
		public Func<object, decimal> Compile(string expression)
		{
			Func<decimal[], decimal> compiled = Parse(expression);

			Func<List<string>, Func<object, decimal>> curriedResult =
				list => argument =>
			{
				Dictionary<string, decimal> arguments = ParseArguments(argument);
				return Execute(compiled, arguments, list);
			};

			Func<object, decimal> result = curriedResult(parameters.ToList());

			return result;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Evaluate																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Parses and evaluates an expression with the specified arguments
		/// </summary>
		/// <param name="expression">
		/// Expression to parse.
		/// </param>
		/// <param name="argument">
		/// An object containing arguments for the expression.
		/// </param>
		/// <returns>
		/// The evaluated expression.
		/// </returns>
		public decimal Evaluate(string expression, object argument = null)
		{
			Dictionary<string, decimal> arguments = ParseArguments(argument);

			return Evaluate(expression, arguments);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	TryInvokeMember																												*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Invoke Member.
		/// </summary>
		/// <param name="binder"></param>
		/// <param name="args"></param>
		/// <param name="result"></param>
		/// <returns></returns>
		public override bool TryInvokeMember(InvokeMemberBinder binder,
			object[] args, out object result)
		{
			//	DEP-20180502.0637 - Back-formatted for compatibility with VS2013.
			if(binder != null && binder.GetType().Name != "Evaluate")
			{
				return base.TryInvokeMember(binder, args, out result);
			}
			//	Original.
			//if(nameof(Evaluate) != binder.Name)
			//{
			//	return base.TryInvokeMember(binder, args, out result);
			//}

			if(!(args[0] is string))
			{
				throw new ArgumentException("No expression specified for parsing");
			}

			//args will contain expression and arguments,
			//ArgumentNames will contain only named arguments
			if(args.Length != binder.CallInfo.ArgumentNames.Count + 1)
			{
				throw new ArgumentException("Argument names missing.");
			}

			Dictionary<string, decimal> arguments =
				new Dictionary<string, decimal>();

			for(int i = 0; i < binder.CallInfo.ArgumentNames.Count; i++)
			{
				if(IsNumeric(args[i + 1].GetType()))
				{
					arguments.Add(binder.CallInfo.ArgumentNames[i],
						Convert.ToDecimal(args[i + 1]));
				}
			}

			result = Evaluate((string)args[0], arguments);

			return true;
		}
		//*-----------------------------------------------------------------------*
	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	Operation																																*
	//*-------------------------------------------------------------------------*
	/// <summary>
	/// Encapsulates the behavior of a single operation.
	/// </summary>
	internal sealed class Operation : Symbol
	{
		//*************************************************************************
		//*	Private																																*
		//*************************************************************************
		private readonly Func<Expression, Expression, Expression> operation;
		private readonly Func<Expression, Expression> unaryOperation;

		//*-----------------------------------------------------------------------*
		//*	_Predefined Operators																									*
		//*-----------------------------------------------------------------------*
		public static readonly Operation Addition =
			new Operation(1, Expression.Add, "Addition");
		public static readonly Operation Division =
			new Operation(2, Expression.Divide, "Division");
		public static readonly Operation Multiplication =
			new Operation(2, Expression.Multiply, "Multiplication");
		public static readonly Operation Subtraction =
			new Operation(1, Expression.Subtract, "Subtraction");
		public static readonly Operation UnaryMinus =
			new Operation(2, Expression.Negate, "Negation");
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Apply																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Apply a unary expression to the caller's value.
		/// </summary>
		/// <param name="expression">
		/// Expression to exercise.
		/// </param>
		/// <returns>
		/// Newly created Expression object conforming to the caller's unary
		/// expression.
		/// </returns>
		private Expression Apply(Expression expression)
		{
			return unaryOperation(expression);
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Apply a binary expression to the caller's value.
		/// </summary>
		/// <param name="left">
		/// Left side expression.
		/// </param>
		/// <param name="right">
		/// Right side expression.
		/// </param>
		/// <returns>
		/// Newly created Expression object conforming to the caller's binary
		/// expression.
		/// </returns>
		private Expression Apply(Expression left, Expression right)
		{
			return operation(left, right);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Operations																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// List of fundamental operations.
		/// </summary>
		/// <remarks>
		/// This member must occur after the definition of the predefined
		/// operators, due to the fact that both sets are static.
		/// </remarks>
		private static readonly Dictionary<char, Operation> Operations =
			new Dictionary<char, Operation>
		{
			{ '+', Addition },
			{ '-', Subtraction },
			{ '*', Multiplication},
			{ '/', Division }
		};
		//*-----------------------------------------------------------------------*

		//*************************************************************************
		//*	Protected																															*
		//*************************************************************************
		//*************************************************************************
		//*	Public																																*
		//*************************************************************************
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new instance of the Operation object.
		/// </summary>
		/// <param name="precedence">
		/// Precedence level.
		/// </param>
		/// <param name="name">
		/// Name of the operator.
		/// </param>
		private Operation(int precedence, string name)
		{
			Name = name;
			Precedence = precedence;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new instance of the Operation object.
		/// </summary>
		/// <param name="precedence">
		/// Precedence level.
		/// </param>
		/// <param name="unaryOperation">
		/// Unary operation to perform.
		/// </param>
		/// <param name="name">
		/// Name of the operator.
		/// </param>
		private Operation(int precedence,
			Func<Expression, Expression> unaryOperation, string name)
			: this(precedence, name)
		{
			this.unaryOperation = unaryOperation;
			NumberOfOperands = 1;
		}
		//*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
		/// <summary>
		/// Create a new instance of the Operation object.
		/// </summary>
		/// <param name="precedence">
		/// Precedence level.
		/// </param>
		/// <param name="operation">
		/// Operation to perform.
		/// </param>
		/// <param name="name">
		/// Name of the operator.
		/// </param>
		private Operation(int precedence,
			Func<Expression, Expression, Expression> operation, string name)
			: this(precedence, name)
		{
			this.operation = operation;
			NumberOfOperands = 2;
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	_Explicit Operator Operator op = (char)value;													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Cast a character value to an Operator.
		/// </summary>
		/// <param name="operation">
		/// Char representation of the operation.
		/// </param>
		/// <returns>
		/// Reference to an Operator configured with the specified operation.
		/// </returns>
		public static explicit operator Operation(char operation)
		{
			Operation result;


			if(Operations.TryGetValue(operation, out result))
			{
				return result;
			}
			else
			{
				throw new InvalidCastException();
			}
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Apply																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Apply operation to the caller's array of expressions.
		/// </summary>
		/// <param name="expressions">
		/// Array of expressions to which the operator will be applied.
		/// </param>
		/// <returns>
		/// New Expression representing application of operator on the specified
		/// expressions.
		/// </returns>
		/// <remarks>
		/// This method will throw a NotImplementedException if expressions.Length
		/// is not either 1 or 2.
		/// </remarks>
		public Expression Apply(params Expression[] expressions)
		{
			if(expressions.Length == 1)
			{
				return Apply(expressions[0]);
			}

			if(expressions.Length == 2)
			{
				return Apply(expressions[0], expressions[1]);
			}

			throw new NotImplementedException();
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	IsDefined																															*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Return a value indicating whether the caller's specified operation is
		/// pre-defined.
		/// </summary>
		/// <param name="operation">
		/// Operation to inspect.
		/// </param>
		/// <returns>
		/// True if the specified operation is pre-defined. Otherwise, false.
		/// </returns>
		public static bool IsDefined(char operation)
		{
			return Operations.ContainsKey(operation);
		}
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Name																																	*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get/Set the Name of the Operator.
		/// </summary>
		public string Name { get; private set; }
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	NumberOfOperands																											*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get/Set the Number of Operands in the Operator.
		/// </summary>
		public int NumberOfOperands { get; private set; }
		//*-----------------------------------------------------------------------*

		//*-----------------------------------------------------------------------*
		//*	Precedence																														*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Get/Set the Precedence Level.
		/// </summary>
		public int Precedence { get; private set; }
		//*-----------------------------------------------------------------------*

	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	Parentheses																															*
	//*-------------------------------------------------------------------------*
	internal class Parentheses : Symbol
	{
		//*-----------------------------------------------------------------------*
		//*	_Constructor																													*
		//*-----------------------------------------------------------------------*
		/// <summary>
		/// Create a new instance of the Parenthesis object.
		/// </summary>
		private Parentheses()
		{

		}
		//*-----------------------------------------------------------------------*

		public static readonly Parentheses Left = new Parentheses();
		public static readonly Parentheses Right = new Parentheses();

	}
	//*-------------------------------------------------------------------------*

	//*-------------------------------------------------------------------------*
	//*	Symbol																																	*
	//*-------------------------------------------------------------------------*
	internal class Symbol
	{
	}
	//*-------------------------------------------------------------------------*

}
