VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NameValueTypeItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'NameValueTypeItem.cls
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

Private mItemType As String
Private mName As String
Private mValue As String

Public Property Get ItemType() As String
  ItemType = mItemType
End Property
Public Property Let ItemType(Value As String)
  mItemType = Value
End Property

Public Property Get Name() As String
  Name = mName
End Property
Public Property Let Name(ItemName As String)
  mName = ItemName
End Property

Public Property Get Value() As String
  Value = mValue
End Property
Public Property Let Value(ItemValue As String)
  mValue = ItemValue
End Property

