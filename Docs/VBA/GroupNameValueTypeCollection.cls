VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "GroupNameValueTypeCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'GroupNameValueTypeCollection.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mCol As Collection


Private Sub Class_Initialize()
  Set mCol = New Collection
End Sub

Public Sub Add(Value As NameValueTypeCollection)
  mCol.Add Value
End Sub

Public Sub AddRange(Items As GroupNameValueTypeCollection)
Dim lc As Integer   'List Count.
Dim lp As Integer   'List Position.

  lc = Items.Count
  If lc > 0 Then
    For lp = 1 To lc
      mCol.Add Items.Item(lp)
    Next lp
  End If
End Sub

Public Function AddValue(ItemName As String, ItemValue As String, _
  ItemType As String) As NameValueTypeCollection
Dim rv As New NameValueTypeCollection

  rv.AddValue ItemName, ItemValue, ItemType
  mCol.Add rv
  Set AddValue = rv
End Function

Public Sub Clear()
  Do While mCol.Count > 0
    mCol.Remove 1
  Loop
End Sub

Public Function Count() As Integer
  Count = mCol.Count
End Function

Public Function Item(Index As Variant) As NameValueTypeCollection
Dim ci As NameValueTypeCollection   'Current Item.
Dim cm As NameValueTypeItem         'Current Member.
Dim lc As Integer         'List Count.
Dim lp As Integer         'List Position.
Dim rv As NameValueTypeCollection

  If VarType(Index) = vbString Then
    lc = mCol.Count
    For lp = 1 To lc
      Set ci = mCol.Item(lp)
      Set cm = ci.Item(Index)
      If Not cm Is Nothing Then
        Set rv = ci
        Exit For
      End If
    Next lp
  Else
    Set rv = mCol.Item(Index)
  End If
  Set Item = rv

End Function

Public Sub Remove(Index As Variant)

  mCol.Remove (Index)

End Sub


