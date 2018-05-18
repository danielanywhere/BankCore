VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NameValueCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'NameValueCollection.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mCol As Collection

Private Sub Class_Initialize()
  Set mCol = New Collection
End Sub

Public Sub Add(Item As NameValueItem)
  mCol.Add Item
End Sub

Public Sub AddRange(Items As NameValueCollection)
Dim lc As Integer   'List Count.
Dim lp As Integer   'List Position.

  lc = Items.Count
  If lc > 0 Then
    For lp = 1 To lc
      mCol.Add Items.Item(lp)
    Next lp
  End If
End Sub

Public Function AddValue(ItemName As String, ItemValue As String) As NameValueItem
Dim rv As New NameValueItem

  rv.Name = ItemName
  rv.Value = ItemValue
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

Public Function Item(Index As Variant) As NameValueItem
Dim ci As NameValueItem   'Current Item.
Dim lc As Integer         'List Count.
Dim lp As Integer         'List Position.
Dim rv As NameValueItem

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

Public Sub SetMatches(ItemName As String, ItemValue As String)
'Set the values of all partial or complete matches.
Dim lc As Integer         'List Count.
Dim lp As Integer         'List Position.
Dim nv As NameValueItem   'Current Item.
Dim tl As String          'Lowercase Value.

  tl = LCase(ItemName)
  lc = Count()
  For lp = 1 To lc
    Set nv = Item(lp)
    If InStr(LCase(nv.Name), tl) > 0 Then
      nv.Value = ItemValue
    End If
  Next lp

End Sub

Public Sub SetValue(ItemName As String, ItemValue As String)
Dim rv As NameValueItem

  Set rv = Item(ItemName)
  If rv Is Nothing Then
    Set rv = New NameValueItem
    rv.Name = ItemName
    rv.Value = ItemValue
    Add rv
  End If
  If Not rv Is Nothing Then
    rv.Value = ItemValue
  End If

End Sub

Public Sub Sort()
Dim bf As Boolean   'Flag - Found.
Dim nCol As New Collection
Dim sc As Integer   'Source Count.
Dim si As NameValueItem 'Source Item.
Dim sp As Integer   'Source Position.
Dim tc As Integer   'Target Count.
Dim ti As NameValueItem 'Target Item.
Dim tp As Integer   'Target Position.

  sc = mCol.Count
  tc = 0
  For sp = 1 To sc
    bf = False
    Set si = mCol.Item(sp)
    For tp = 1 To tc
      Set ti = nCol.Item(tp)
      If CompareStrings(si.Name, ti.Name) < 0 Then
        nCol.Add si, Before:=tp
        mCol.Remove sp
        bf = True
        Exit For
      End If
    Next tp
    If tp > tc Then
      'End of list.
      nCol.Add si
      mCol.Remove sp
      bf = True
    End If
    If bf = True Then
      sp = sp - 1
      sc = sc - 1
      tc = tc + 1
      If sc = 0 Then Exit For
    End If
  Next sp
  Set mCol = Nothing
  Set mCol = nCol

End Sub
