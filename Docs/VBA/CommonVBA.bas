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

Public Function NewGuid() As String
'Create and return a new GUID to the caller.
Dim rs As String

  rs = CStr(CreateObject("Scriptlet.TypeLib").Guid)
  rs = Left(rs, 38)
  NewGuid = rs

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

'Public Function ColToChar(Index As Long) As String
''Return the Column, converted to Name from Index.
'Dim bp As Boolean 'Flag - Prefix Present.
'Dim cp As String  'Char Prefix.
'Dim cs As String  'Char Suffix.
'Dim Id As Long    'Working Index.
'Dim ip As Long    'Prefix Index.
'Dim rs As String  'Return String.
'
'  rs = ""
'  bp = False
'  cp = ""
'  cs = ""
'  Id = Index
'  ip = Int(Id / 26)
'  If ip > 0 And Id Mod 26 = 0 Then
'    ip = ip - 1
'    Id = 26
'  End If
'  If Id Mod 26 <> 0 Then
'    Id = Id Mod 26
''  ElseIf id <> 0 And id <> 26 Then
''    id = 1
'  End If
'  If ip > 0 Then
'    'Prefix was found.
''    id = id + 1
'    rs = Chr(ip + 64)
'  End If
'  rs = rs & Chr(Id + 64)
'  ColToChar = rs
'End Function

Public Function ColToChar(Index As Long) As String
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

Public Function PadLeft(Value As String, TotalWidth As Integer, Char As String) As String
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

Public Function RegExMatches(Source As String, Pattern As String) As Object
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

Public Function RegExReplace(Source As String, Find As String, Replace As String) As String
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


