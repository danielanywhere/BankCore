VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ColumnProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mColumnAlias As String
Private mColumnDataType As String
Private mColumnDefaultValue As String
Private mColumnDescription As String
Private mColumnDisplay As String
Private mColumnEditor As String
Private mColumnFormat As String
Private mColumnGrid As String
Private mColumnIsData As String
Private mColumnIsDefault As String
Private mColumnKeyName As String
Private mColumnKeyValue As String
Private mColumnLength As String
Private mColumnName As String
Private mColumnOverride As String
Private mColumnReadOnly As String
Private mColumnSelect As String
Private mColumnSource As String
Private mColumnTable As String
Private mColumnUIDisplay As String
Private mColumnUIKey As String
Private mColumnUISource As String
Private mColumnUIUpdate As String
Private mColumnUIValue As String

'Bulk property creation pattern.
'Find:(?i:private m(?<n>[^ ]+) as (?<t>[^\r\n]+))
'Repl:
'public property get ${n}() as ${t}
'  ${n} = m${n}
'End Property
'public property let ${n}(Value as ${t})
'  m${n} = ${n}
'End Property
'Bulk initialization pattern.
'Find:(?i:private mColumn(?<n>[^ ]+) as (?<t>[^\r\n]+))
'Repl:  mColumn${n} = GetConfigValue(pfx & "${n}")

Private Sub Class_Initialize()
Dim pfx As String   'Setting prefix.

  pfx = "ComponentColumn."
  mColumnAlias = GetConfigValue(pfx & "Alias")
  mColumnDataType = GetConfigValue(pfx & "DataType")
  mColumnDefaultValue = GetConfigValue(pfx & "DefaultValue")
  mColumnDescription = GetConfigValue(pfx & "Description")
  mColumnDisplay = GetConfigValue(pfx & "Display")
  mColumnEditor = GetConfigValue(pfx & "Editor")
  mColumnFormat = GetConfigValue(pfx & "Format")
  mColumnGrid = GetConfigValue(pfx & "Grid")
  mColumnIsData = GetConfigValue(pfx & "IsData")
  mColumnIsDefault = GetConfigValue(pfx & "IsDefault")
  mColumnKeyName = GetConfigValue(pfx & "KeyName")
  mColumnKeyValue = GetConfigValue(pfx & "KeyValue")
  mColumnLength = GetConfigValue(pfx & "Length")
  mColumnName = GetConfigValue(pfx & "Name")
  mColumnOverride = GetConfigValue(pfx & "Override")
  mColumnReadOnly = GetConfigValue(pfx & "ReadOnly")
  mColumnSelect = GetConfigValue(pfx & "Select")
  mColumnSource = GetConfigValue(pfx & "Source")
  mColumnTable = GetConfigValue(pfx & "Table")
  mColumnUIDisplay = GetConfigValue(pfx & "UIDisplay")
  mColumnUIKey = GetConfigValue(pfx & "UIKey")
  mColumnUISource = GetConfigValue(pfx & "UISource")
  mColumnUIUpdate = GetConfigValue(pfx & "UIUpdate")
  mColumnUIValue = GetConfigValue(pfx & "UIValue")


End Sub

Public Property Get ColumnAlias() As String
  ColumnAlias = mColumnAlias
End Property
Public Property Let ColumnAlias(Value As String)
  mColumnAlias = ColumnAlias
End Property

Public Property Get ColumnDataType() As String
  ColumnDataType = mColumnDataType
End Property
Public Property Let ColumnDataType(Value As String)
  mColumnDataType = ColumnDataType
End Property

Public Property Get ColumnDefaultValue() As String
  ColumnDefaultValue = mColumnDefaultValue
End Property
Public Property Let ColumnDefaultValue(Value As String)
  mColumnDefaultValue = ColumnDefaultValue
End Property

Public Property Get ColumnDescription() As String
  ColumnDescription = mColumnDescription
End Property
Public Property Let ColumnDescription(Value As String)
  mColumnDescription = ColumnDescription
End Property

Public Property Get ColumnDisplay() As String
  ColumnDisplay = mColumnDisplay
End Property
Public Property Let ColumnDisplay(Value As String)
  mColumnDisplay = ColumnDisplay
End Property

Public Property Get ColumnEditor() As String
  ColumnEditor = mColumnEditor
End Property
Public Property Let ColumnEditor(Value As String)
  mColumnEditor = ColumnEditor
End Property

Public Property Get ColumnFormat() As String
  ColumnFormat = mColumnFormat
End Property
Public Property Let ColumnFormat(Value As String)
  mColumnFormat = ColumnFormat
End Property

Public Property Get ColumnGrid() As String
  ColumnGrid = mColumnGrid
End Property
Public Property Let ColumnGrid(Value As String)
  mColumnGrid = ColumnGrid
End Property

Public Property Get ColumnIsData() As String
  ColumnIsData = mColumnIsData
End Property
Public Property Let ColumnIsData(Value As String)
  mColumnIsData = ColumnIsData
End Property

Public Property Get ColumnIsDefault() As String
  ColumnIsDefault = mColumnIsDefault
End Property
Public Property Let ColumnIsDefault(Value As String)
  mColumnIsDefault = ColumnIsDefault
End Property

Public Property Get ColumnKeyName() As String
  ColumnKeyName = mColumnKeyName
End Property
Public Property Let ColumnKeyName(Value As String)
  mColumnKeyName = ColumnKeyName
End Property

Public Property Get ColumnKeyValue() As String
  ColumnKeyValue = mColumnKeyValue
End Property
Public Property Let ColumnKeyValue(Value As String)
  mColumnKeyValue = ColumnKeyValue
End Property

Public Property Get ColumnLength() As String
  ColumnLength = mColumnLength
End Property
Public Property Let ColumnLength(Value As String)
  mColumnLength = ColumnLength
End Property

Public Property Get ColumnName() As String
  ColumnName = mColumnName
End Property
Public Property Let ColumnName(Value As String)
  mColumnName = ColumnName
End Property

Public Property Get ColumnOverride() As String
  ColumnOverride = mColumnOverride
End Property
Public Property Let ColumnOverride(Value As String)
  mColumnOverride = ColumnOverride
End Property

Public Property Get ColumnReadOnly() As String
  ColumnReadOnly = mColumnReadOnly
End Property
Public Property Let ColumnReadOnly(Value As String)
  mColumnReadOnly = ColumnReadOnly
End Property

Public Property Get ColumnSelect() As String
  ColumnSelect = mColumnSelect
End Property
Public Property Let ColumnSelect(Value As String)
  mColumnSelect = ColumnSelect
End Property

Public Property Get ColumnSource() As String
  ColumnSource = mColumnSource
End Property
Public Property Let ColumnSource(Value As String)
  mColumnSource = ColumnSource
End Property

Public Property Get ColumnTable() As String
  ColumnTable = mColumnTable
End Property
Public Property Let ColumnTable(Value As String)
  mColumnTable = ColumnTable
End Property

Public Property Get ColumnUIDisplay() As String
  ColumnUIDisplay = mColumnUIDisplay
End Property
Public Property Let ColumnUIDisplay(Value As String)
  mColumnUIDisplay = ColumnUIDisplay
End Property

Public Property Get ColumnUIKey() As String
  ColumnUIKey = mColumnUIKey
End Property
Public Property Let ColumnUIKey(Value As String)
  mColumnUIKey = ColumnUIKey
End Property

Public Property Get ColumnUISource() As String
  ColumnUISource = mColumnUISource
End Property
Public Property Let ColumnUISource(Value As String)
  mColumnUISource = ColumnUISource
End Property

Public Property Get ColumnUIUpdate() As String
  ColumnUIUpdate = mColumnUIUpdate
End Property
Public Property Let ColumnUIUpdate(Value As String)
  mColumnUIUpdate = ColumnUIUpdate
End Property

Public Property Get ColumnUIValue() As String
  ColumnUIValue = mColumnUIValue
End Property
Public Property Let ColumnUIValue(Value As String)
  mColumnUIValue = ColumnUIValue
End Property

