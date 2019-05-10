Attribute VB_Name = "BankWorksheetMain"
Option Explicit

'BankWorksheetMain.bas
'Copyright (c). 2018, 2019. Daniel Patterson, MCSD (DanielAnywhere)


Public Sub GetJSON()
'Return JSON data for the selected Table sheet.

  ClipBoard_SetData ToJSONSheet(ActiveSheet)
  MsgBox "JSON Data for the selected sheet " & _
    "has been copied to the clipboard...", vbOKOnly, "Get JSON"

End Sub

Public Sub GetJSONLookup()
'Return JSON lookup data for the selected Table sheet.
Dim ci(2) As Integer  'Column Index Array.
Dim cn(2) As String   'Column Name Array.
Dim ld() As String    'Lookup Data.
Dim sn As String      'Sheet Name.

  If Not ActiveSheet Is Nothing Then
    sn = ActiveSheet.Name
    If Len(sn) > 5 And LCase(Left(sn, 5)) = "table" Then
      sn = Right(sn, Len(sn) - 5)
    End If
    cn(1) = InputBox("ID Column Name: ", _
      "Get JSON Lookup Data", sn & "ID")
    cn(2) = InputBox("Text Column Name: ", _
      "Get JSON Lookup Data", sn & "Ticket")
    ci(1) = GetColumnIndex(ActiveSheet, cn(1))
    ci(2) = GetColumnIndex(ActiveSheet, cn(2))
    If ci(1) > 0 And ci(2) > 0 Then
      'ID and Text columns found.
      ld = ToTableArray(ActiveSheet, cn, ci)
      ClipBoard_SetData ToJSONArray(ld)
      MsgBox "JSON Lookup Data for the selected sheet " & _
        "has been copied to the clipboard...", vbOKOnly, "Get JSON"
    End If
  End If

End Sub

Public Sub GetJSONOmitNulls()
'Return JSON data for the selected Table sheet.

  ClipBoard_SetData ToJSONSheet(ActiveSheet, True)
  MsgBox "JSON Data for the selected sheet " & _
    "has been copied to the clipboard...", vbOKOnly, "Get JSON, Omit Nulls"

End Sub

Public Sub GetJSONValueList()
'Return JSON data for the selected Table sheet.
Dim cName As String     'Column name.
Dim cItems As New Collection
Dim cValue As String    'Column value.
Dim lineCount As Integer
Dim lineIndex As Integer
Dim lines() As String
Dim rCount As Integer
Dim rIndex As Integer
Dim vList() As String
Dim wSheet As Worksheet

  Set wSheet = ActiveWorkbook.ActiveSheet
  cName = InputBox("Column to list:", "Get JSON Value List", "")
  cName = ColumnTextToName(wSheet, 1, cName)
  If Len(cName) > 0 Then
    rIndex = 2
    cValue = GetValueEx(wSheet, "A", rIndex)
    Do While Len(cValue) > 0
      'Get the user-specified column.
      cValue = GetValueEx(wSheet, cName, rIndex)
      cValue = Replace(cValue, Chr(13), "")
      lines = Split(cValue, Chr(10))
      lineCount = UBound(lines)
      For lineIndex = 0 To lineCount
        cItems.Add lines(lineIndex)
      Next lineIndex
      rIndex = rIndex + 1
      cValue = GetValueEx(wSheet, "A", rIndex)
    Loop
    rCount = cItems.Count - 1
    ReDim vList(rCount)
    For rIndex = 0 To rCount
      vList(rIndex) = cItems.Item(rIndex + 1)
    Next rIndex
  
    ClipBoard_SetData ToJSONArray1(vList, "")
    MsgBox "JSON Data for the selected sheet " & _
      "has been copied to the clipboard...", vbOKOnly, "Get JSON"
  End If

End Sub




