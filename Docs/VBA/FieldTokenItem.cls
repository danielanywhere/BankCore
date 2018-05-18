VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FieldTokenItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mCompareValues As NameValueCollection   'Comparison Values.
Private mComponentType As Integer     'Current Component Type.
Private mComponentValues As NameValueCollection 'Match Values.
Private mFieldValues As NameValueCollection     'Field Values.
Private mMatchFound As Boolean        'Match Found.
Private mRowEnd As Integer            'Ending Source Row.
Private mRowIndex As Integer          'Current Source Row.
Private mSheet As Worksheet           'Working Source Sheet.
Private mTemplateValue As String      'Templated Value.

'Bulk property creation pattern.
'(LET)
'Find:(?i:private m(?<n>[^ ]+) as (?<t>(integer|boolean|string)).*)
'Repl:
'public property get ${n}() as ${t}
'  ${n} = m${n}
'End Property
'public property let ${n}(Value as ${t})
'  m${n} = Value
'End Property
'(SET)
'Find:(?i:private m(?<n>[^ ]+) as (?<t>\w+).*)
'Repl:
'public property get ${n}() as ${t}
'  set ${n} = m${n}
'End Property
'public property set ${n}(Value as ${t})
'  set m${n} = Value
'End Property

Public Property Get CompareValues() As NameValueCollection
  Set CompareValues = mCompareValues
End Property
Public Property Set CompareValues(Value As NameValueCollection)
  Set mCompareValues = Value
End Property

Public Property Get ComponentType() As Integer
  ComponentType = mComponentType
End Property
Public Property Let ComponentType(Value As Integer)
  mComponentType = Value
End Property

Public Property Get ComponentValues() As NameValueCollection
  Set ComponentValues = mComponentValues
End Property
Public Property Set ComponentValues(Value As NameValueCollection)
  Set mComponentValues = Value
End Property

Public Property Get FieldValues() As NameValueCollection
  Set FieldValues = mFieldValues
End Property
Public Property Set FieldValues(Value As NameValueCollection)
  Set mFieldValues = Value
End Property

Public Property Get MatchFound() As Boolean
  MatchFound = mMatchFound
End Property
Public Property Let MatchFound(Value As Boolean)
  mMatchFound = Value
End Property

Public Property Get RowEnd() As Integer
  RowEnd = mRowEnd
End Property
Public Property Let RowEnd(Value As Integer)
  mRowEnd = Value
End Property

Public Property Get RowIndex() As Integer
  RowIndex = mRowIndex
End Property
Public Property Let RowIndex(Value As Integer)
  mRowIndex = Value
End Property

Public Property Get Sheet() As Worksheet
  Set Sheet = mSheet
End Property
Public Property Set Sheet(Value As Worksheet)
  Set mSheet = Value
End Property

Public Property Get TemplateValue() As String
  TemplateValue = mTemplateValue
End Property
Public Property Let TemplateValue(Value As String)
  mTemplateValue = Value
End Property


