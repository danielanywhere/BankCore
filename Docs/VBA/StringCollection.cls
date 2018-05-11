VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StringCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'StringCollection.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mCol As Collection

Private Sub Class_Initialize()
  Set mCol = New Collection
End Sub

Public Sub Add(Value As String)
  mCol.Add Value
End Sub

Public Sub Clear()
  Do While mCol.Count > 0
    mCol.Remove 1
  Loop
End Sub

Public Function Count() As Integer
  Count = mCol.Count
End Function

Public Function Item(Index As Variant) As String
  Item = mCol.Item(Index)
End Function

Public Sub Remove(Index As Variant)
  mCol.Remove Index
End Sub

