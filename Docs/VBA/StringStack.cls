VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StringStack"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'StringStack.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mCol As Collection


Private Sub Class_Initialize()
  Set mCol = New Collection
End Sub

Public Sub Clear()

  Do While mCol.Count > 0
    mCol.Remove 1
  Loop

End Sub

Public Function Count() As Integer
  Count = mCol.Count
End Function

Public Function Peek() As String
Dim rv As String    'Return Value.

  rv = ""
  If mCol.Count > 0 Then
    rv = mCol.Item(mCol.Count)
  End If
  Peek = rv

End Function

Public Function Pop() As String
Dim rv As String    'Return Value.

  rv = ""
  If mCol.Count > 0 Then
    rv = mCol.Item(mCol.Count)
    mCol.Remove (mCol.Count)
  End If
  Pop = rv

End Function

Public Sub Push(Value As String)
  mCol.Add Value
End Sub

