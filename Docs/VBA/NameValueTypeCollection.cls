VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NameValueTypeCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'NameValueTypeCollection.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mCol As Collection


Private Sub Class_Initialize()
  Set mCol = New Collection
End Sub

Public Sub Add(Value As NameValueTypeItem)
  mCol.Add Value
End Sub

Public Sub AddRange(Items As NameValueTypeCollection)
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
  ItemType As String) As NameValueTypeItem
Dim rv As New NameValueTypeItem

  rv.Name = ItemName
  rv.Value = ItemValue
  rv.ItemType = ItemType
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

Public Function Item(Index As Variant) As NameValueTypeItem
Dim ci As NameValueTypeItem   'Current Item.
Dim lc As Integer         'List Count.
Dim lp As Integer         'List Position.
Dim rv As NameValueTypeItem

  If VarType(Index) = vbString Then
    lc = mCol.Count
    For lp = 1 To lc
      Set ci = mCol.Item(lp)
      If ci.Name = Index Then
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

Public Sub SetType(ItemName As String, ItemType As String)
Dim rv As NameValueTypeItem

  Set rv = Item(ItemName)
  If Not rv Is Nothing Then
    rv.ItemType = ItemType
  End If

End Sub

Public Sub SetValue(ItemName As String, ItemValue As String)
Dim rv As NameValueTypeItem

  Set rv = Item(ItemName)
  If Not rv Is Nothing Then
    rv.Value = ItemValue
  End If

End Sub


