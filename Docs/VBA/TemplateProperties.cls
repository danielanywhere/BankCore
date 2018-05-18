VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TemplateProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mColumnActive As String
Private mColumnContent As String
Private mColumnName As String
Private mColumnRemark As String
Private mColumnTypeName As String

'Bulk member creation pattern.
'Find:(?i:templatecolumn\.(?<f>[^\r\n]+))
'Repl:private m${f} as string
'Bulk property creation pattern.
'Find:(?i:private m(?<n>[^ ]+) as (?<t>[^\r\n]+))
'Repl:
'public property get ${n}() as ${t}
'  ${n} = m${n}
'End Property
'public property let ${n}(Value as ${t})
'  m${n} = Value
'End Property
'Bulk initialization pattern.
'Find:(?i:private mColumn(?<n>[^ ]+) as (?<t>[^\r\n]+))
'Repl:  mColumn${n} = GetConfigValue(pfx & "${n}")

Private Sub Class_Initialize()
Dim pfx As String
  pfx = "TemplateColumn."
  mColumnActive = GetConfigValue(pfx & "Active")
  mColumnContent = GetConfigValue(pfx & "Content")
  mColumnName = GetConfigValue(pfx & "Name")
  mColumnRemark = GetConfigValue(pfx & "Remark")
  mColumnTypeName = GetConfigValue(pfx & "TypeName")
End Sub

Public Property Get ColumnActive() As String
  ColumnActive = mColumnActive
End Property
Public Property Let ColumnActive(Value As String)
  mColumnActive = Value
End Property

Public Property Get ColumnContent() As String
  ColumnContent = mColumnContent
End Property
Public Property Let ColumnContent(Value As String)
  mColumnContent = Value
End Property

Public Property Get ColumnName() As String
  ColumnName = mColumnName
End Property
Public Property Let ColumnName(Value As String)
  mColumnName = Value
End Property

Public Property Get ColumnRemark() As String
  ColumnRemark = mColumnRemark
End Property
Public Property Let ColumnRemark(Value As String)
  mColumnRemark = Value
End Property

Public Property Get ColumnTypeName() As String
  ColumnTypeName = mColumnTypeName
End Property
Public Property Let ColumnTypeName(Value As String)
  mColumnTypeName = Value
End Property


