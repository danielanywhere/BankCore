Attribute VB_Name = "CommonVBA"
Option Explicit

'CommonVBA.bas
'Copyright (c). 1998-2018. Daniel Patterson, MCSD (DanielAnywhere)

'Clipboard Features...
Declare Function GlobalUnlock Lib "kernel32" (ByVal hMem As Long) As Long
Declare Function GlobalLock Lib "kernel32" (ByVal hMem As Long) As Long
Declare Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As Long) As Long
Declare Function CloseClipboard Lib "User32" () As Long
Declare Function OpenClipboard Lib "User32" (ByVal hwnd As Long) As Long
Declare Function EmptyClipboard Lib "User32" () As Long
Declare Function lstrcpy Lib "kernel32" (ByVal lpString1 As Any, ByVal lpString2 As Any) As Long
Declare Function SetClipboardData Lib "User32" (ByVal wFormat As Long, ByVal hMem As Long) As Long

Public Const GHND = &H42
Public Const CF_TEXT = 1
Public Const MAXSIZE = 4096
'/Clipboard Features...

Public Function CharToCol(ColumnName As String) As Integer
'Return the ordinal index number corresponding to the specified column name.
Dim rv As Integer   'Return value.
Dim tl As String    'Lowercase column name.

  tl = LCase(ColumnName)
  If Len(ColumnName) = 1 Then
    rv = Asc(tl) - 96
  ElseIf Len(ColumnName) = 2 Then
    rv = 26 + (26 * (Asc(Left(tl, 1)) - 96)) + _
      Asc(Right(tl, 1)) - 96
  End If
  CharToCol = rv

End Function

Public Function ClipBoard_SetData(MyString As String)
Dim hGlobalMemory As Long, lpGlobalMemory As Long
Dim hClipMemory As Long, x As Long

  ' Allocate moveable global memory.
  '-------------------------------------------
  hGlobalMemory = GlobalAlloc(GHND, Len(MyString) + 1)

  ' Lock the block to get a far pointer
  ' to this memory.
  lpGlobalMemory = GlobalLock(hGlobalMemory)

  ' Copy the string to this global memory.
  lpGlobalMemory = lstrcpy(lpGlobalMemory, MyString)

  ' Unlock the memory.
  If GlobalUnlock(hGlobalMemory) <> 0 Then
    MsgBox "Could not unlock memory location. Copy aborted."
    GoTo OutOfHere2
  End If

  ' Open the Clipboard to copy data to.
  If OpenClipboard(0&) = 0 Then
    MsgBox "Could not open the Clipboard. Copy aborted."
    Exit Function
  End If

  ' Clear the Clipboard.
  x = EmptyClipboard()

  ' Copy the data to the Clipboard.
  hClipMemory = SetClipboardData(CF_TEXT, hGlobalMemory)

OutOfHere2:

  If CloseClipboard() = 0 Then
    MsgBox "Could not close Clipboard."
  End If

End Function

Public Function ColToChar(Index As Variant) As String
'Return the Column, converted to Name from Index.
'20180212.1035 - DEP - Converted to two letter support.
Dim bp As Boolean 'Flag - Prefix Present.
Dim cp As String  'Char Prefix.
Dim cs As String  'Char Suffix.
Dim id As Long    'Working Index.
Dim im As Long    'Index Minus.
Dim ll As Long    'Left Letter.
Dim ip As Long    'Prefix Index.
Dim rl As Long    'Right Letter.
Dim rs As String  'Return String.
Dim ws As String  'Working String.

  rs = ""
  bp = False
  cp = ""
  cs = ""
  im = Index - 1    'Make Index zero-based.
  If im >= 26 Then
    'Two letter.
    ll = Int(im / 26) - 1
    rl = im Mod 26
    rs = Chr(ll + 65) & Chr(rl + 65)
  Else
    rs = Chr(im + 65)
  End If

  ColToChar = rs
End Function

Public Function ColumnTextToName(Sheet As Worksheet, RowIndex As Integer, Text As String)
'Find the column name from the text in the specified cell.
Dim ch As Integer 'High column.
Dim cp As Integer 'Column position.
Dim cv As String  'Cell value.
Dim rv As String  'Return value.
Dim tl As String  'Lower case text.

  rv = ""
  tl = LCase(Text)
  cp = 1
  cv = LCase(GetValueEx(Sheet, ColToChar(cp), RowIndex))
  Do While Len(cv) > 0
    ch = cp
    If cv = tl Then
      rv = ColToChar(cp)
      Exit Do
    End If
    cp = cp + 1
    cv = LCase(GetValueEx(Sheet, ColToChar(cp), RowIndex))
  Loop
  If Len(rv) = 0 And Len(tl) > 0 And Len(tl) < 3 Then
    'The specific text was not found, but there is a possibility
    ' the actual column name is needed.
    If Asc(Left(tl, 1)) >= 97 And Asc(Left(tl, 1)) <= 122 And _
      Asc(Right(tl, 1)) >= 97 And Asc(Right(tl, 1)) <= 122 Then
      cp = CharToCol(tl)
      If cp <= ch Then rv = tl
    End If
  End If
  ColumnTextToName = rv

End Function

Public Function InlineOr(Value1 As Boolean, _
  Optional Value2 As Boolean = False, _
  Optional Value3 As Boolean = False, _
  Optional Value4 As Boolean = False, _
  Optional Value5 As Boolean = False) As Boolean
  InlineOr = Value1 Or Value2 Or Value3 Or Value4 Or Value5
End Function

Public Function GetColumnIndex(Sheet As Worksheet, _
  ItemName As String) As Integer
'Return the 1-based index of the column prefixed by the
' specified header name.
Dim cp As Long        'Column Position.
Dim cs As String      'Cell String.
Dim lp As Integer     'List Position.
Dim rv As Integer     'Return Value.
Dim sh As Worksheet   'Abbreviated Sheet.
Dim tl As String      'Lowercase Value.

  rv = 0
  Set sh = Sheet
  If Not sh Is Nothing Then
    tl = LCase(ItemName)
    cp = 1
    lp = 1
    'Get the named column.
    cs = sh.Range(ColToChar(cp) & CStr(lp)).Value
    Do While Len(cs) > 0
      If LCase(cs) = tl Then
        rv = cp
        Exit Do
      End If
      cp = cp + 1
      cs = sh.Range(ColToChar(cp) & CStr(lp)).Value
    Loop
  End If
  GetColumnIndex = rv

End Function

Public Function GetValue(ColumnName As String, currentRow As Integer) As String
'Return the value of the specified cell.
  GetValue = Range(ColumnName & CStr(currentRow)).Value
End Function

Public Function GetValueEx(Sheet As Worksheet, _
  ColumnName As String, currentRow As Integer) As String
'Return the value of the specified cell.
  GetValueEx = Sheet.Range(ColumnName & CStr(currentRow)).Value
End Function

Public Function GetValueNext(ColumnName As String, currentRow As Integer) As String
'Return the value of the cell at the next row.
  GetValueNext = Range(ColumnName & CStr(currentRow + 1)).Value
End Function

Public Function GetValuePrev(ColumnName As String, currentRow As Integer) As String
'Return the value of the cell at the previous row.
  GetValuePrev = Range(ColumnName & CStr(currentRow - 1)).Value
End Function

Public Function IsBoolean(Value As String) As Boolean
'Return a value indicating whether the caller's value is
' boolean.
Dim tl As String  'Lowercase Value.

  tl = LCase(trim(Value))
  IsBoolean = (tl = "true" Or tl = "false")
End Function

Public Function IsFloatingPoint(Value As String) As Boolean
'Return a value indicating whether the caller's value is
' floating-point numeric.
Dim bc As Boolean 'Flag - continue.
Dim ip As Integer 'Instring position.
Dim ws As String  'Working string.
Dim rv As Boolean 'Return value.

  bc = True
  rv = False
  If Len(Value) > 0 Then
    If InStr(Value, ",") > 0 Then
      bc = False
    End If
    If bc Then
      'Don't pass multiple leading zeros as floating point.
      ' They will probably disappear on the other end.
      If Left(Value, 1) = "0" And InStr(Value, ".") <> 2 Then
        bc = False
      End If
    End If
    If bc Then
      If Left(Value, 1) = "-" Then
        'Only allow the leftmost character to be minus sign.
        ws = Right(Value, Len(Value) - 1)
      Else
        ws = Value
      End If
      ip = InStr(ws, ".")
      If ip > 0 And ip < Len(ws) Then
        ip = InStr(Right(ws, ip + 1), ".")
        If ip > 0 Then
          'Multiple decimal points.
          bc = False
        End If
      End If
    End If
    If bc Then
      ws = Replace(Value, ".", "")
      rv = IsNumeric(ws)
    End If
  End If
  IsFloatingPoint = rv

End Function

Public Function IsNull(Value As String) As Boolean
'Return a value indicating whether the caller's value is null.
Dim tl As String  'Lowercase value.

  tl = LCase(Value)
  IsNull = (tl = "null")

End Function

Private Function JSONPrepareString(Value As String)
Dim lc As Integer     'Line count.
Dim lp As Integer     'Line position.
Dim result As String
Dim sa() As String    'String line array.
Dim sc As String      'String content.

  result = Replace(Value, """", "\""")
  result = Replace(result, Chr(9), "\t")
  If InStr(result, Chr(13)) > 0 Or _
    InStr(result, Chr(10)) > 0 Then
    'Multi-line string.
    sc = Replace(result, Chr(13), "")
    sa = Split(sc, Chr(10))
    lc = UBound(sa)
    sc = ""
    For lp = 0 To lc
      If Len(sc) > 0 Then
        sc = sc & "," & vbCrLf
      End If
      sc = sc & """" & sa(lp) & """"
    Next lp
    result = vbCrLf & "[" & vbCrLf & sc & vbCrLf & "]"
  Else
    'Single-line string.
    result = """" & result & """"
  End If
  JSONPrepareString = result
End Function

Public Function Min(Value1 As Variant, _
  Value2 As Variant)
'Return the Minimum of two values.
Dim rv As Variant

  On Local Error Resume Next
  Err.Clear
  If TypeName(Value1) = TypeName(Value2) Then
    Set rv = IIf(Value1 < Value2, Value1, Value2)
    If Err.Number <> 0 Then
      rv = IIf(Value1 < Value2, Value1, Value2)
    End If
  End If
  
  Min = rv

End Function

Public Function NewGuid() As String
'Create and return a new GUID to the caller.
Dim rs As String

  rs = CStr(CreateObject("Scriptlet.TypeLib").Guid)
  rs = Left(rs, 38)
  NewGuid = rs

End Function

Public Function PadLeft(Value As String, _
  TotalWidth As Integer, Char As String) As String
'Pad the string to the left with the specified character.
Dim rv As String  'Return Value.

  rv = Value
  If Len(Char) > 0 Then
    Do While Len(rv) < TotalWidth
      rv = Char & rv
    Loop
  End If
  PadLeft = rv

End Function

Public Function RegExMatches(Source As String, _
  Pattern As String) As Object
Dim mc As Object
Dim rx As Object

  Set rx = CreateObject("VBScript.RegExp")
  rx.IgnoreCase = True
  rx.Pattern = Pattern
  rx.Global = True    'Set global applicability.

  Set mc = rx.Execute(Source)  ' Execute search.
'  For Each Match In Matches   ' Iterate Matches collection.
'    RetStr = RetStr & "Match found at position "
'    RetStr = RetStr & Match.FirstIndex & ". Match Value is '"
'    RetStr = RetStr & Match.Value & "'." & vbCrLf
'  Next
  Set RegExMatches = mc

End Function

Public Function RegExReplace(Source As String, _
  Find As String, Replace As String) As String
Dim rv As String  'Return Value.
Dim rx As Object  'RegExp

  Set rx = CreateObject("VBScript.RegExp")
  rx.IgnoreCase = True
  rx.Pattern = Find
  rv = rx.Replace(Source, Replace)
  RegExReplace = rv

End Function

Public Function Repeat(Character As String, Count As Integer) As String
  Repeat = Replace(Space(Count), " ", Character)
End Function

Private Sub TestJSONPrepareString()

  Debug.Print "JSONPrepareString(This\r\nis a multiline\r\nstring...\r\n) : " & _
    JSONPrepareString("This" & vbCrLf & _
    "is a multiline" & vbCrLf & _
    "string..." & vbCrLf)

End Sub

Private Sub TestIsFloatingPoint()
  Debug.Print "IsFloatingPoint(10.10.10.15): " & _
    CStr(IsFloatingPoint("10.10.10.15"))
End Sub

Public Function ToJSONArray(Grid() As String) As String
'Convert content on the specified 2 dimensional array to JSON.
Dim cc As Integer     'Column Count.
Dim cp As Long        'Column Position.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim rs As String      'Record String.
Dim rv As String      'Return Value.
Dim ws As String      'Working String.
    
  lc = UBound(Grid, 1)
  cc = UBound(Grid, 2)
  'Get row content.
  For lp = 1 To lc
    'Each row.
    If Len(rv) = 0 Then
      rv = "[" & vbCrLf
    Else
      rv = rv & "," & vbCrLf
    End If
    rv = rv & "{" & vbCrLf
    rs = ""
    For cp = 1 To cc
      'Each column.
      If Len(rs) > 0 Then
        rs = rs & "," & vbCrLf
      End If
      ws = Grid(lp, cp)
      ws = Replace(ws, "NULL", "null")
      If Len(ws) = 0 Then
        ws = "null"
      End If
      If Len(rs) > 0 Then
        rs = rs & "," & vbCrLf
      End If
      rs = rs & " """ & Grid(0, cp) & """: " & _
        IIf(InlineOr(IsFloatingPoint(ws), _
          IsBoolean(ws), _
          IsNull(ws)), _
          ws, JSONPrepareString(ws))
    Next cp
    rv = rv & rs & vbCrLf & "}"
  Next lp
  rv = rv & vbCrLf
  rv = rv & "];" & vbCrLf
  
  ToJSONArray = rv

End Function

Public Function ToJSONArray1(List() As String, _
  Optional NullValue As String = "null") As String
'Convert content on the specified 1 dimensional array to JSON.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim rv As String      'Return Value.
Dim ws As String      'Working String.
    
  lc = UBound(List)
  'Get row content.
  rv = ""
  For lp = 0 To lc
    'Each row.
    If Len(rv) > 0 Then
      rv = rv & "," & vbCrLf
    End If
    ws = List(lp)
    ws = Replace(ws, "NULL", NullValue)
    If Len(ws) = 0 Then
      ws = NullValue
    End If
    rv = rv & _
      IIf(InlineOr(IsFloatingPoint(ws), _
        IsBoolean(ws), _
        IsNull(ws)), _
        ws, JSONPrepareString(ws))
  Next lp
  rv = "[" & vbCrLf & rv & vbCrLf & "]" & vbCrLf
  
  ToJSONArray1 = rv

End Function

Public Function ToJSONSheet(Sheet As Worksheet, _
  Optional OmitNulls As Boolean = False) As String
'Convert content on the specified Worksheet to JSON.
Dim ca() As String    'Column Names.
Dim cl As Long        'Column Length.
Dim cp As Long        'Column Position.
Dim lp As Integer     'List Position.
Dim rs As String      'Record String.
Dim rv As String      'Return Value.
Dim sh As Worksheet   'Abbreviated Sheet.
Dim ws As String      'Working String.

  rv = ""
  Set sh = Sheet
  If Not sh Is Nothing Then
    cp = 1
    lp = 1
    'Get the column names.
    Do While Len(sh.Range(ColToChar(cp) & CStr(lp)).Value) > 0
      cp = cp + 1
    Loop
    cl = cp - 1
    'Assign column names.
    ReDim ca(cl)
    For cp = 1 To cl
      ca(cp) = sh.Range(ColToChar(cp) & CStr(lp)).Value
    Next cp
    lp = 2
    'Get row content.
    Do While Len(sh.Range("A" & CStr(lp)).Value) > 0
      If Len(rv) = 0 Then
        rv = "[" & vbCrLf
      Else
        rv = rv & "," & vbCrLf
      End If
      rv = rv & "{" & vbCrLf
      rs = ""
      For cp = 1 To cl
        ws = sh.Range(ColToChar(cp) & CStr(lp)).Value
        ws = Replace(ws, "NULL", "null")
        If Len(ws) = 0 Then
          ws = "null"
        End If
        If Not OmitNulls Or ws <> "null" Then
          If Len(rs) > 0 Then
            rs = rs & "," & vbCrLf
          End If
          rs = rs & " """ & Replace(ca(cp), " ", "") & """: " & _
            IIf(InlineOr(IsFloatingPoint(ws), _
              IsBoolean(ws), _
              IsNull(ws)), _
              ws, JSONPrepareString(ws))
        End If
      Next cp
      rv = rv & rs & vbCrLf & "}"
      lp = lp + 1
    Loop
    rv = rv & vbCrLf
    rv = rv & "];" & vbCrLf
  End If
  ToJSONSheet = rv

End Function

Public Function ToTableArray(Sheet As Worksheet, _
  ColumnName() As String, _
  ColumnIndex() As Integer) As String()
'Return a table, formatted as a two-dimensional
' 1-based array.
'Row is left element. Column is right element.
'Header data appears at row 0.
Dim cc As Integer     'Column Count.
Dim cp As Integer     'Column Position.
Dim cs As String      'Cell String.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim rv() As String    'Return Value.
Dim sh As Worksheet   'Abbreviated Sheet.

  If Not Sheet Is Nothing And _
    UBound(ColumnName) > 0 And _
    UBound(ColumnIndex) > 0 Then
    Set sh = Sheet
    cc = Min(UBound(ColumnName), UBound(ColumnIndex))
    'Count Rows.
    lp = 2
    cs = sh.Range("A" & CStr(lp)).Value
    Do While Len(cs) > 0
      lp = lp + 1
      cs = sh.Range("A" & CStr(lp)).Value
    Loop
    lc = lp - 1
    'Prepare the grid.
    ReDim rv(lc - 1, cc)
    'Set the Header.
    For cp = 1 To cc
      rv(0, cp) = ColumnName(cp)
    Next cp
    'Get Content.
    For lp = 2 To lc
      'Each Row.
      For cp = 1 To cc
        'Each Column.
        rv(lp - 1, cp) = _
          sh.Range(ColToChar(CLng(ColumnIndex(cp))) & CStr(lp)).Value
      Next cp
    Next lp
  End If
  ToTableArray = rv

End Function

Public Function ToTitleCase(Value As String) As String
'Return the caller's string, converted to Title Case.
Dim bh As Boolean     'Flag - Handled.
Dim la                'Value Array.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim rs As String      'Return String.
Dim tl As String      'Lower Case Working String.
Dim ts As String      'Temporary String.
Dim ws As String      'Working String.

  rs = ""
  la = Split(Value, " ")
  lc = UBound(la)
  If lc > 0 Then
    For lp = 0 To lc
      bh = False
      ws = la(lp)
      tl = LCase(ws)
      If Len(ws) > 0 Then
        If Len(rs) > 0 Then
          rs = rs & " "
        End If
        If Len(ws) = 2 Then
          '2 character strings.
          Select Case tl
            Case "ii", "iv", "vi", "po":
              rs = rs & UCase(ws)
              bh = True
          End Select
        ElseIf Len(ws) = 3 Then
          '3 character strings.
          Select Case tl
            Case "iii", "vii", "llc", "dba", "c/o":
              rs = rs & UCase(ws)
              bh = True
          End Select
        ElseIf Len(ws) = 4 Then
          '4 character strings.
          Select Case tl
            Case "p.o.":
              rs = rs & UCase(ws)
              bh = True
          End Select
        Else
          'Other variations.
          If Left(tl, 2) = "o'" Then
            rs = rs & "O'" & UCase(Mid(ws, 3, 1)) & Right(tl, Len(tl) - 3)
            bh = True
          End If
          If Left(tl, 2) = "mc" Then
            rs = rs & "Mc" & UCase(Mid(ws, 3, 1)) & Right(tl, Len(tl) - 3)
            bh = True
          End If
          If InStr(tl, "-") > 0 Then
            rs = rs & Replace(ToTitleCase(Replace(ws, "-", " ")), " ", "-")
            bh = True
          End If
        End If
        If bh = False Then
          rs = rs & UCase(Left(ws, 1)) & LCase(Right(ws, Len(ws) - 1))
        End If
      End If
    Next lp
  Else
    If Len(Value) > 0 Then
      rs = UCase(Left(Value, 1)) & LCase(Right(Value, Len(Value) - 1))
    End If
  End If
  ToTitleCase = rs

End Function


