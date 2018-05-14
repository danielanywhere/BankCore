Attribute VB_Name = "BankWorksheetMain"
Option Explicit

'BankWorksheetMain.bas
'Copyright (c). 2018. Daniel Patterson, MCSD (DanielAnywhere)

Private Const ScopePrivate = 0
Private Const ScopeProtected = 1
Private Const ScopePublic = 2

Private Sub CodeFromTemplate(Target As Worksheet)
'Each class level is handled separately.
Dim bc As Boolean   'Flag - Continue.
Dim bo As Boolean   'Flag - Previous Class Open.
Dim cb As Integer   'Count of Open Brackets.
Dim cv As New NameValueCollection 'Column Values.
Dim fc As String    'File Content.
Dim fv As New NameValueCollection 'Field Values.
Dim lb As Integer   'List Begin Row.
Dim lc As Integer   'List Count.
Dim le As Integer   'List End Row.
Dim lp As Integer   'List Position.
Dim na As String    'Item Name.
Dim nc As Integer   'Next Repeater Count.
Dim ni As Integer   'Next Repeater Index.
Dim nn As String    'Next Repeater Name.
Dim nv As NameValueItem   'Working Name/Value Item.
Dim pv(2) As NameValueCollection 'Repeater Values.
Dim rb As Integer   'Remote Begin Row.
Dim rc As Integer   'Remote Row Count.
Dim re As Integer   'Remote End Row.
Dim rp As Integer   'Remote Row Position.
Dim sc As Integer   'Current Scope.
Dim sh As Worksheet 'Current Sheet.
Dim st As Worksheet 'Template Sheet.
Dim tp As Integer   'Template Row Position.
Dim tv As New NameValueCollection 'Template Values.
Dim ws As String    'Working String.

  bc = True
  sc = ScopePublic
  fc = ""
  Set sh = ActiveSheet
  ws = LCase(sh.Name)
  If Len(ws) <= 9 Then
    MsgBox "Please select a sheet prefixed with 'Component', as in " & _
      "ComponentMyItem", vbOKOnly, "Create Object Collection Code"
    bc = False
  End If

  If bc = True Then
    'Initialize the repeaters.
    For lp = 0 To 2
      Set pv(lp) = New NameValueCollection
    Next lp
    Set st = Target
    'Set the {Item} Name.
    na = Replace(sh.Name, "Component", "")
    'Count the fields.
    lb = 2
    lp = lb
    Do While Len(ValueCell("A", lp)) > 0
      lp = lp + 1
    Loop
    lc = lp - lb
    le = lp - 1
    'Initialize the field names.
    cv.Clear
    For lp = lb To le
      cv.AddValue ValueCell("A", lp), CStr(lp)
    Next lp
    cv.Sort
    'Initialize the replacement tags.
'    tv.AddValue "{Item}", na
'    tv.AddValue "{Items}", GetPlural(na)
'    tv.AddValue "{LItem}", LCase(na)
'    tv.AddValue "{LItems}", LCase(GetPlural(na))
'    tv.AddValue "{FieldNameList}", GetNativeList(sh, lb)
'    tv.AddValue "{Tab}", Chr(9)
'    tv.AddValue "{T}", Chr(9)
'    tv.AddValue "{Scope}", "Public"
'    tv.AddValue "{AAn}", GetIndefiniteArticle(na)
    UpdateComponentTags sh, tv
  
    If Not st Is Nothing Then
      'Template sheet is present.
      'Initialize Next Repeater values.
      nc = cv.Count
      ni = 1
      If ni <= nc Then
        nn = cv.Item(ni).Name
      Else
        nn = ""
      End If
      rb = 2            'Starting at remote row 2.
      rp = rb
      'Count the remote rows.
      Do While Len(ValueCellSheet(st, "A", rp)) > 0
        rp = rp + 1
      Loop
      rc = rp - rb
      re = rp - 1
      
      For rp = rb To re
        If ValueCellSheet(st, "A", rp) = "1" Then
          'Row is active.
          ws = ValueCellSheet(st, "B", rp)
          Select Case LCase(ws)
            Case "space":
              'Add a blank line of space.
              fc = fc & vbCrLf
            Case "using":
              'In this version, all using statements occur
              ' prior to the namespace.
              fc = fc & ValueCellSheet(st, "D", rp) & vbCrLf
            Case "namespace":
              'In this version, all classes are in a single namespace.
              fc = fc & "namespace " & _
                ValueCellSheet(st, "D", rp) & vbCrLf
              fc = fc & "{" & vbCrLf
              cb = cb + 1
            Case "class":
              'Each class is handled separately so the items can
              ' be arranged.
              'Get the repeaters in this class.
              For tp = 0 To 2
                pv(tp).Clear
              Next tp
              ni = 1
              If ni <= nc Then
                nn = cv.Item(ni).Name
              Else
                nn = ""
              End If
              For tp = rp + 1 To re
                If ValueCellSheet(st, "A", tp) = "1" And _
                  InStr(LCase(ValueCellSheet(st, "B", tp)), _
                  "fieldrepeat") > 0 Then
                  pv(sc).AddValue _
                    ValueCellSheet(st, "B", tp), _
                    ValueCellSheet(st, "D", tp)
                ElseIf LCase(ValueCellSheet(st, "B", tp)) = "section" Then
                  'Key the repeaters to their associated sections.
                  ws = LCase(ValueCellSheet(st, "D", tp))
                  Select Case ws
                    Case "private":
                      sc = ScopePrivate
                    Case "protected":
                      sc = ScopeProtected
                    Case "public":
                      sc = ScopePublic
                  End Select
                ElseIf LCase(ValueCellSheet(st, "B", tp)) = "class" Then
                  'Don't continue into the next class definition.
                  Exit For
                End If
              Next tp
              'Close any previous class.
              If bo = True Then
                'A previous class was open.
                fc = fc & GetTabs(1) & "}" & vbCrLf
                fc = fc & GetBorder("Class") & vbCrLf & vbCrLf
                If cb > 1 Then cb = cb - 1
                bo = False
              End If
              'Get the source for this class header.
              ws = ResolveTags(ValueCellSheet(st, "D", rp), tv)
              ws = ResolveParamTags(ws)
              fc = fc & ws & vbCrLf
              fc = fc & GetTabs(1) & "{" & vbCrLf
              cb = cb + 1
              bo = True
            Case "section":
              ws = ValueCellSheet(st, "D", rp)
              fc = fc & GetSectionBreak(ws) & vbCrLf
              tv.SetValue "{Scope}", ws
              Select Case LCase(ws)
                Case "private":
                  sc = ScopePrivate
                Case "protected":
                  sc = ScopeProtected
                Case "public":
                  sc = ScopePublic
              End Select
            Case "method", "property", "field":
              'Get the local name.
              ws = ValueCellSheet(st, "C", rp)
              If Len(nn) = 0 Or pv(sc).Count = 0 Or _
                CompareStrings(ws, nn) < 0 Then
                'Current entry occurs before the next repeater.
                ws = ResolveTags(ValueCellSheet(st, "D", rp), tv)
                ws = ResolveParamTags(ws)
                fc = fc & ws & vbCrLf
              Else
                'Next repeater occurs before the current entry.
                'Consume the next repeater.
                Set nv = cv.Item(ni)
                lp = CInt(nv.Value)
'                fv.Clear
'                fv.AddRange tv
'                fv.AddValue "{FieldName}", ValueCell("A", lp)
'                fv.AddValue "{FieldDataType}", ValueCell("B", lp)
'                fv.AddValue "{FieldDefaultValue}", ValueCell("C", lp)
'                fv.AddValue "{FieldNative}", ValueCell("D", lp)
'                fv.AddValue "{FieldSource}", ValueCell("E", lp)
'                fv.AddValue "{FieldTable}", ValueCell("F", lp)
'                fv.AddValue "{FieldSelect}", _
'                  Replace(ValueCell("G", lp), """", "\""")
'                fv.AddValue "{FieldAlias}", ValueCell("H", lp)
'                fv.AddValue "{FieldKeyName}", ValueCell("I", lp)
'                fv.AddValue "{FieldKeyValue}", ValueCell("J", lp)
'                fv.AddValue "{FieldSQLType}", _
'                  GetScalarType(ValueCell("B", lp))
                UpdateFieldTags sh, lp, tv, fv
                'Resolve connected repeaters.
                lc = pv(sc).Count
                For lp = 1 To lc
                  Set nv = pv(sc).Item(lp)
                  If LCase(nv.Name) = _
                    "fieldrepeat(" & LCase(fv.Item("{FieldSource}").Value) & ")" Then
                    'Field repeater found for this instance.
                    ws = ResolveTags(nv.Value, fv)
                    ws = ResolveParamTags(ws)
                    fc = fc & ws & vbCrLf
                    Exit For
                  End If
                Next lp
                'Index to the next repeater field.
                ni = ni + 1
                If ni <= cv.Count Then
                  nn = cv.Item(ni).Name
                Else
                  nn = ""
                End If
                'Re-consider the current entry on next pass.
                rp = rp - 1
              End If
            Case "fieldrepeat(get, set)":
              'Skip field repeater. It is used virtually.
            Case "fieldrepeat(get sql)":
              'Skip field repeater. It is used virtually.
          End Select
        End If
      Next rp
      Do While ni <= cv.Count
        'There are more property names that have not been written.
        Set nv = cv.Item(ni)
        lp = CInt(nv.Value)
        UpdateFieldTags sh, lp, tv, fv
        'Resolve connected repeaters.
        lc = pv(sc).Count
        For lp = 1 To lc
          Set nv = pv(sc).Item(lp)
          If LCase(nv.Name) = _
            "fieldrepeat(" & LCase(fv.Item("{FieldSource}").Value) & ")" Then
            'Field repeater found for this instance.
            ws = ResolveTags(nv.Value, fv)
            ws = ResolveParamTags(ws)
            fc = fc & ws & vbCrLf
            Exit For
          End If
        Next lp
        'Index to the next repeater field.
        ni = ni + 1
        If ni <= cv.Count Then
          nn = cv.Item(ni).Name
        Else
          nn = ""
        End If
      Loop
      If bo = True Then
        'A previous class was open.
        fc = fc & GetTabs(1) & "}" & vbCrLf
        fc = fc & GetBorder("Class") & vbCrLf & vbCrLf
        If cb > 1 Then cb = cb - 1
        bo = False
      End If
      If cb = 1 Then
        'Close the namespace.
        fc = fc & "}" & vbCrLf
        cb = cb - 1
      End If
    End If
  End If
  If Len(fc) > 0 Then
    ClipBoard_SetData fc
    MsgBox "New file text has been copied to clipboard.", vbOKOnly, _
      "Code From Template"
  End If

End Sub

Public Function CompareStrings(Value1 As String, Value2 As String) As Integer
'Compare two string values and return the result as a relative indicator.
' Value1 < Value2 = -1
' Value1 = Value2 = 0
' Value1 > Value2 = 1
Dim l1 As Integer     'Length 1.
Dim l2 As Integer     'Length 2.
Dim rv As Integer     'Return Value.
Dim s1 As String      'Shortest Value 1.
Dim s2 As String      'Shortest Value 2.
Dim t1 As String      'Value1 Lowercase.
Dim t2 As String      'Value2 Lowercase.

  rv = 0
  l1 = Len(Value1)
  l2 = Len(Value2)
  If l1 > 0 And l2 > 0 Then
    'Both values non blank.
    t1 = LCase(Value1)
    t2 = LCase(Value2)
    s1 = t1
    s2 = t2
    If l1 <> l2 Then
      If l1 > l2 Then
        'Value1 longer than Value2.
        s1 = Left(s1, l2)
      Else
        'Value2 longer than Value1.
        s2 = Left(s2, l1)
      End If
    End If
    If s1 = s2 Then
      rv = 0
      'In the case of a tie, the length will be the tie-breaker.
      If l1 <> l2 Then
        If l1 > l2 Then
          rv = 1
        Else
          rv = -1
        End If
      End If
    ElseIf s1 > s2 Then
      rv = 1
    Else
      rv = -1
    End If
  ElseIf l1 = 0 And l2 = 0 Then
    'Both values blank.
    rv = 0
  ElseIf l1 > 0 And l2 = 2 Then
    'Value1 not blank, Value2 blank.
    rv = 1
  Else
    'Value1 blank, Value2 not blank.
    rv = -1
  End If
  CompareStrings = rv

End Function

Public Sub CreateObjectCollectionCode()
'Use the TemplateObjectCollection sheet to create code for the Component on
' the selected sheet.
  CodeFromTemplate Sheets("TemplateObjectCollection")

End Sub

Public Sub CreateObjectControllerCode()
'Use the TemplateObjectController sheet to create code for the Component on
' the selected sheet.
  CodeFromTemplate Sheets("TemplateObjectController")

End Sub

Public Sub CreateSinglePageAppHTML()
'Use the TemplateHTMLSinglePageApp sheet to create HTML for all Component sheets.

  HtmlFromTemplate Sheets("TemplateHTMLSinglePageApp")

End Sub

Public Sub CreateSQLTableScript()
'Render the scripting of the SQL database table, and send the file to the
' SQL folder.
Dim bc As Boolean         'Flag - Continue.
Dim bid As Boolean        'Flag - ID Column.
Dim bMax As Boolean       'Max Columns require the use of TEXTIMAGE_ON
Dim cName As String       'Column Name.
Dim cProps As ColumnProperties
Dim cType As String       'Column Type.
Dim cLen As String        'Column Explicit Length.
Dim cDef As String        'Default Value.
Dim cNull As Boolean      'Value indicating whether a null is possible.
Dim cDesc As String       'Column Description.
Dim dbn As String         'Database Name.
Dim dCreate As String     'Create Constraints.
Dim dDrop As String       'Drop Constraints.
Dim fc As String          'File Content.
Dim fln As String         'Folder Name.
Dim fso As Object         'File System Object.
Dim ident As String       'Identity specification.
Dim iName As String       'Item Name.
Dim lp As Integer         'List Position.
Dim pk As String          'Primary Key String.
Dim sh As Worksheet       'Current Sheet.
Dim tc As String          'Table Content.
Dim tName As String       'Table Name.
Dim ts As Object          'Text Stream.

  bc = False
  tName = Application.ActiveSheet.Name
  If Len(tName) > 9 Then
    If LCase(Left(tName, 9)) = "component" Then
      bc = True
    End If
  End If
  If bc = False Then
    MsgBox _
      "Please select a sheet whose name is prefixed with 'Component'." & _
      vbCrLf & _
      "For example, 'ComponentCustomer', etc.", vbOKOnly, _
      "Create SQL Table Script"
  End If

  If bc = True Then
    Set cProps = New ColumnProperties
    iName = Replace(tName, "Component", "")
    tName = "bnk" & iName
  
    fln = GetConfigValue("TableFolderName")
    dbn = GetConfigValue("DatabaseName")
    'Make sure folder name has trailing slash.
    If Len(fln) > 0 Then
      If Right(fln, 1) <> "\" Then
        fln = fln & "\"
      End If
    End If
    fln = fln & "dbo." & tName & ".sql"
  
    Set sh = Application.ActiveSheet
  
    pk = ""
    lp = 2
    Do While Len(ValueCell(cProps.ColumnName, lp)) > 0
      bid = False
      If LCase(ValueCell(cProps.ColumnDataType, lp)) = "object" And _
        LCase(ValueCell(cProps.ColumnSource, lp)) = "item" Then
        'The identity specification is found on the default value of the
        ' abstract item.
        ident = "IDENTITY(" & ValueCell(cProps.ColumnDefaultValue, lp) & ")"
      ElseIf ValueCell(cProps.ColumnIsData, lp) = "1" Then
        'Only script to table if this is a data column.
        cName = ValueCell(cProps.ColumnName, lp)
        cType = GetSqlType(ValueCell(cProps.ColumnDataType, lp))
        cLen = ValueCell(cProps.ColumnLength, lp)
        cDef = GetSqlDefault(ValueCell(cProps.ColumnDefaultValue, lp))
        If LCase(cName) = LCase(iName) & "id" Then
          'This is the ID column. Use the prescribed identity.
          cDef = ident
          bid = True
        ElseIf LCase(cName) = LCase(iName) & "ticket" Then
          'This is the global identity column.
          cDef = "ROWGUIDCOL"
        End If
        cNull = GetSqlNullable(ValueCell(cProps.ColumnDefaultValue, lp))
        cDesc = ValueCell(cProps.ColumnDescription, lp)
        If Len(tc) > 0 Then
          tc = tc & ", " & vbCrLf
        End If
        If (InStr(LCase(cDef), "identity") > 0 Or _
          InStr(LCase(cDef), "newid") > 0 Or _
          InStr(LCase(cDef), "rowguidcol") > 0) Then
          tc = tc & "[" & cName & "] [" & cType & "] " & cDef & _
            IIf(Len(cDef) > 0, " ", "") & "NOT NULL"
          If InStr(LCase(cDef), "identity") > 0 Then
            pk = cName
          End If
        Else
          tc = tc & "[" & cName & "] [" & cType & "] " & _
            IIf(Len(cLen) > 0, "(" & cLen & ") ", "") & _
            IIf(cNull = False, "NOT ", "") & "NULL"
        End If
        If Len(cDef) > 0 And bid = False Then
          'Default value is defined.
          dDrop = dDrop & _
            "IF OBJECT_ID('dbo.[DF_" & tName & "_" & cName & "]', 'D') " & _
            "IS NOT NULL" & vbCrLf & _
            "  ALTER TABLE [dbo].[" & tName & "] " & _
            "DROP CONSTRAINT [DF_" & tName & "_" & cName & "]" & vbCrLf & _
            "GO" & vbCrLf
          dCreate = dCreate & "ALTER TABLE [dbo].[" & tName & "] " & _
            "ADD CONSTRAINT [DF_" & tName & "_" & cName & "] " & _
            "DEFAULT (" & GetSqlDefault(cDef) & ") FOR " & _
            "[" & cName & "]" & vbCrLf & _
            "GO" & vbCrLf
        End If
      End If
      lp = lp + 1
    Loop
    If Len(tc) > 0 Then
      If Len(pk) > 0 Then
        'If a Primary Key has been included by implication, then set it in the
        ' script.
        tc = tc & "," & vbCrLf & _
          "primary key (" & pk & ")"
      End If
      fc = "USE [" & dbn & "]" & vbCrLf
      fc = fc & "GO" & vbCrLf
      fc = fc & dDrop
      fc = fc & _
        "/****** Object:  Table [dbo].[" & tName & "] - Script Date: " & _
        Format(Now(), "MM/DD/YYYY HH:MM") & " ******/" & vbCrLf
      fc = fc & _
        "IF OBJECT_ID('dbo.[" & tName & "]', 'U') IS NOT NULL" & vbCrLf & _
        "  DROP TABLE [dbo].[" & tName & "]" & vbCrLf & _
        "GO" & vbCrLf
      fc = fc & "SET ANSI_NULLS ON" & vbCrLf & _
        "GO" & vbCrLf & _
        "SET QUOTED_IDENTIFIER ON" & vbCrLf & _
        "GO" & vbCrLf & _
        "SET ANSI_PADDING ON" & vbCrLf & _
        "GO" & vbCrLf
      fc = fc & "CREATE TABLE [dbo].[" & tName & "](" & vbCrLf
      fc = fc & tc & vbCrLf
      fc = fc & ") ON [PRIMARY]"
      If InStr(LCase(tc), "(max)") > 0 Then
        fc = fc & " TEXTIMAGE_ON [PRIMARY]"
      End If
      fc = fc & vbCrLf & _
        "GO" & vbCrLf
      fc = fc & "SET ANSI_PADDING OFF" & vbCrLf & _
        "GO" & vbCrLf
      fc = fc & dCreate & vbCrLf
      Set fso = CreateObject("Scripting.FileSystemObject")
      Set ts = fso.CreateTextFile(fln, True, False)
      ts.Write fc
      ts.Close
      Set ts = Nothing
      Set fso = Nothing
      MsgBox "SQL Table Script Saved to " & fln, vbOKOnly, _
        "Create SQL Table Script"
    End If
  End If

End Sub

Private Function FindClosingBrace(Source As String, Start As Integer) As Integer
'Return the position of the associated closing brace in the caller's string.
Dim cp As Integer   'Character Position.
Dim rv As Integer   'Return Value.
Dim sb As New StringStack
Dim sl As Integer   'String Length.
Dim ws As String    'Working String.

  rv = -1
  sl = Len(Source)
  
  For cp = Start To sl
    ws = Mid(Source, cp, 1)
    If ws = "(" Or ws = "{" Or ws = "[" Then
      sb.Push ws
    ElseIf ws = ")" Or ws = "}" Or ws = "]" Then
      sb.Pop
      If sb.Count = 0 Then
        'Closing brace was found.
        rv = cp
        Exit For
      End If
    End If
  Next cp
  FindClosingBrace = rv

End Function

Private Function GetBorder(MemberName As String) As String
'Return the border line surrounding a type of member.
Dim rv As String    'Return Value.

  Select Case LCase(MemberName)
    Case "class":
      rv = GetTabs(1) & "//*" & Repeat("-", 73) & "*"
    Case "member":
      rv = GetTabs(2) & "//*" & Repeat("-", 71) & "*"
    Case "overload":
      rv = GetTabs(2) & "//*-" & Repeat(" -", 35) & "*"
  End Select
  GetBorder = rv
End Function

Public Function GetConfigValue(ConfigName As String) As String
'Get the first value found for the specified name in the Configuration sheet.
Dim lp As Integer   'List Position.
Dim rv As String    'Return Value.
Dim sh As Worksheet 'Working Sheet.
Dim tl As String    'Lowercase Name.

  Set sh = Sheets("Configuration")
  tl = LCase(ConfigName)

  lp = 2
  Do While Len(sh.Range("A" & CStr(lp)).Value) > 0
    If LCase(sh.Range("A" & CStr(lp)).Value) = tl Then
      'Name found.
      rv = sh.Range("B" & CStr(lp)).Value
    End If
    lp = lp + 1
  Loop
  GetConfigValue = rv

End Function

Private Function GetDefaultFieldDisplayName(Sheet As Worksheet) As String
'Return the default display name that textually labels the component.
Dim lp As Integer 'List Position.
Dim rv As String  'Return Value.

  rv = 0
  lp = 2
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If ValueCellSheet(Sheet, "V", lp) = "1" Then
      rv = ValueCellSheet(Sheet, "L", lp)
      Exit Do
    End If
    lp = lp + 1
  Loop
  GetDefaultFieldDisplayName = rv

End Function

Private Function GetDefaultFieldName(Sheet As Worksheet) As String
'Return the default field name that textually identifies the component.
Dim lp As Integer 'List Position.
Dim rv As String  'Return Value.

  rv = 0
  lp = 2
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If ValueCellSheet(Sheet, "V", lp) = "1" Then
      rv = ValueCellSheet(Sheet, "A", lp)
      Exit Do
    End If
    lp = lp + 1
  Loop
  GetDefaultFieldName = rv

End Function

Private Function GetEndRow(Sheet As Worksheet, _
  ColumnName As String, StartIndex As Integer) As Integer
'Return the index of the last row containing data for the specified column.
Dim lp As Integer 'List Position.
Dim rv As Integer 'Return Value.

  rv = 0
  lp = StartIndex
  Do While Len(ValueCellSheet(Sheet, ColumnName, lp)) > 0
    rv = lp
    lp = lp + 1
  Loop
  GetEndRow = rv

End Function

Private Function GetEndRowNonBlank(Sheet As Worksheet, _
  ColumnName As String, StartIndex As Integer) As Integer
'Return the index of the last row containing data for the specified column.
Dim lp As Integer 'List Position.
Dim rv As Integer 'Return Value.

  rv = 0
  lp = StartIndex
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If Len(ValueCellSheet(Sheet, ColumnName, lp)) > 0 Then
      rv = lp
    End If
    lp = lp + 1
  Loop
  GetEndRowNonBlank = rv

End Function

Private Function GetEndRowValue(Sheet As Worksheet, _
  ColumnName As String, CellValue As String, StartIndex As Integer) As Integer
'Return the index of the last row containing the specified data for the
' specified column.
Dim lp As Integer 'List Position.
Dim rv As Integer 'Return Value.
Dim tl As String  'Lowercase Value.

  rv = 0
  tl = LCase(CellValue)
  lp = StartIndex
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If LCase(ValueCellSheet(Sheet, ColumnName, lp)) = tl Then
      rv = lp
    End If
    lp = lp + 1
  Loop
  GetEndRowValue = rv

End Function

Private Function GetIndefiniteArticle(Value As String) As String
'Return the indefinite article for the caller's word.
' The choice of 'a' or 'an' is determined not only by the
' consonant : vowel status of the first letter, but whether
' that letter is pronounced at the beginning of the word.
' For example, 'h' is a consonant, but since it is often silent,
' it is preceded with 'an'. In contrast, the 'y' is
' sometimes a vowel, but is pronounced, so is preceded by
' 'a'.
' This function doesn't pass in all cases, but should
' survive in the majority.
Dim rv As String    'Return Value.
Dim tl As String    'Lowercase Value.

  rv = "a"
  tl = LCase(Value)
  Select Case tl
    Case "a", "e", "i", "o", "u", "h":
      rv = "an"
  End Select
  GetIndefiniteArticle = rv

End Function

Private Function GetScalarType(DataType As String) As String
Dim rv As String    'Return Value.

  rv = "String"
  Select Case LCase(DataType)
    Case "bool":
      rv = "Bool"
    Case "datetime":
      rv = "DateTime"
    Case "decimal":
      rv = "Decimal"
    Case "guid":
      rv = "Guid"
    Case "int":
      rv = "Int"
    Case "string":
      rv = "String"
  End Select
  GetScalarType = rv

End Function

Private Function GetSectionBreak(Scope As String) As String
Dim rv As String    'Return Value.

  rv = GetTabs(2) & "//" & Repeat("*", 73) & vbCrLf & _
    GetTabs(2) & "//*" & GetTabs(1) & Scope & _
    GetTabs(35 - IIf(Len(Scope) Mod 2 = 1, _
      (Len(Scope) - 1) / 2, _
      Len(Scope) / 2)) & "*" & vbCrLf & _
    GetTabs(2) & "//" & Repeat("*", 73)
  GetSectionBreak = rv

End Function

Private Function GetItemRow(Sheet As Worksheet) As Integer
'Return the index of the item row.
Dim lp As Integer 'List Position.
Dim rv As Integer 'Return Value.

  lp = 2
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If LCase(ValueCellSheet(Sheet, "E", lp)) = "item" Then
      rv = lp
      Exit Do
    End If
    lp = lp + 1
  Loop
  GetItemRow = rv

End Function

Private Function GetNativeList(Sheet As Worksheet, _
  StartIndex As Integer) As String
'Return a delimited list of quoted native column names.
Dim lp As Integer 'List Position.
Dim rv As String  'Return Value.

  lp = StartIndex
  Do While Len(ValueCellSheet(Sheet, "A", lp)) > 0
    If ValueCellSheet(Sheet, "D", lp) = "1" Then
      If Len(rv) > 0 Then
        rv = rv & ", "
      End If
      rv = rv & """" & ValueCellSheet(Sheet, "A", lp) & """"
    End If
    lp = lp + 1
  Loop
  GetNativeList = rv

End Function

Private Function GetParameter(Value As String, Index As Integer) As String
'Return the parameter at the specified index.
Dim id As Integer 'Arrays are 0-based.
Dim pl As Integer 'Left Parameter Position.
Dim pr As Integer 'Right Parameter Position.
Dim rv As String  'Return Value.
Dim sa() As String  'String Array.

  rv = ""
  pl = InStr(Value, "(")
  If pl > 0 Then
    pr = InStr(pl + 1, Value, ")")
    If pr > pl + 1 Then
      id = Index - 1
      sa = Split(Mid(Value, pl + 1, pr - pl - 1), ",")
      If id <= UBound(sa) Then
        rv = sa(id)
      End If
    End If
  End If
  GetParameter = rv

End Function

Private Function GetPlural(Value As String) As String
'Return the plural version of the caller's word.
' For Speed: No irregular nouns in this version.
Dim rc As String  'Right Character.
Dim rv As String  'Return Value.
Dim tl As String  'Lowercase Value.

  rv = "s"
  If Len(Value) > 0 Then
    tl = LCase(Value)
    rc = Right(tl, 1)
    Select Case rc
      Case "h", "s", "x", "z":
        'Value ends in ch, s, sh, x, or z
        If rc = "h" Then
          If Len(tl) > 1 Then
            rc = Mid(tl, Len(tl) - 1, 1)
            If rc = "c" Or rc = "s" Then
              'Value ends in 'ch' or 'sh'
              rv = Value & "es"
            Else
              rv = Value & "s"
            End If
          Else
            rv = Value & "s"
          End If
        Else
          'Value ends in 's', 'x', or 'z'.
          rv = Value & "es"
        End If
      Case "y":
        'Value ends in 'y'.
        rv = Left(Value, Len(Value) - 1) & "ies"
      Case Else:
        'All other possibilities.
        rv = Value & "s"
    End Select
  End If
  GetPlural = rv

End Function

Private Function GetQuotedList(Values As NameValueCollection, _
  Delimiter As String) As String
'Return a delimited list of quoted values.
Dim lc As Integer 'List Count.
Dim lp As Integer 'List Position.
Dim rv As String  'Return Value.

  lc = Values.Count
  For lp = 1 To lc
    If lp > 1 Then
      rv = rv & Delimiter
    End If
    rv = rv & """" & Values.Item(lp).Name & """"
  Next lp
  GetQuotedList = rv

End Function

Private Function GetTabs(Count As Integer) As String
'Return the specified number of tabs.
  GetTabs = Repeat(Chr(9), Count)
End Function

Private Function GetSqlDefault(DefaultValue As String) As String
'Return the default SQL value corresponding to the default object value.
Dim lv As String      'Lower.
Dim rv As String      'Return Value.

  lv = LCase(DefaultValue)
  Select Case lv
    Case "guid.empty":
      rv = "NULL"
    Case "datetime.minvalue":
      rv = "NULL"
    Case "rowguidcol":
      rv = "newid()"
  End Select

  If IsNumeric(lv) Then
    rv = "(" & DefaultValue & ")"
  ElseIf Len(lv) = 0 Then
    rv = "NULL"
  ElseIf Left(lv, 1) = " " Or InStr(lv, """") > 0 Then
    rv = Trim(Replace(lv, """", "'"))
  ElseIf Len(rv) = 0 Then
    rv = lv
  End If
  GetSqlDefault = rv

End Function

Private Function GetSqlNullable(DefaultValue As String) As Boolean
'Return a value indicating whether the specified value can be null.
Dim rv As Boolean     'Return Value.

  rv = False
  If Len(DefaultValue) = 0 Then
    rv = True
  ElseIf LCase(DefaultValue) = "null" Then
    rv = True
  End If
  
  GetSqlNullable = rv

End Function
Private Function GetSqlType(DataTypeName As String) As String
'Return the SQL Data Type Name for the caller's type.
Dim lv As String      'Lower Case Value.
Dim rv As String      'Return Value.

  lv = LCase(DataTypeName)
  Select Case lv
    Case "bool", "bit", "yes/no":
      rv = "bit"
    Case "date", "datetime", "date/time", "smalldatetime":
      rv = "smalldatetime"
    Case "int", "int32", "pk":
      rv = "int"
    Case "float":
      rv = "float"
    Case "decimal":
      rv = "float"
    Case "guid", "uniqueidentifier":
      rv = "uniqueidentifier"
    Case "string", "varchar":
      rv = "varchar"
    Case Else:
      If Len(lv) > 5 Then
        If Left(lv, 5) = "float" Then
          rv = "float"
        End If
      End If
  End Select
  GetSqlType = rv
End Function

Private Sub HtmlFromTemplate(Target As Worksheet)
'Create HTML code from a template.
'In this variation, the approach is inline, and multiple repeaters
' can work as a group.
'The FieldRepeat(component,x) repeater maps to the 'item' source.
'The FieldRepeat(entry,x) repeater maps to the 'get*' sources.
'The FieldRepeat(data,x) repeater maps to the 'get, set' sources.
'The FieldRepeat(edit,x) repeater maps to non-blank Editor column.
'The FieldRepeat(gridcol,x) repeater maps to non-blank GridVisible column.
'Normal code placed between FieldRepeat(component,x) rows is repeated
' for every component in the group.
'A component group is repeated only after all of the members in
' the group have been resolved.
Dim bc As Boolean   'Flag - Continue.
Dim bf As Boolean   'Flag - Found.
Dim ca() As String  'Component Names.
Dim cc As Integer   'Component Count.
Dim cp As Integer   'Component Position.
Dim ct As Integer   'Cycle Type.
Dim cv As New NameValueCollection 'Conditional Values.
Dim fb As Integer   'Field Begin Row.
Dim fc As String    'File Content.
Dim fe As Integer   'Field End Row.
Dim fp As Integer   'Field Position.
Dim fv As New NameValueCollection 'Field Values.
Dim ge As Integer   'Group End.
Dim gn As String    'Group Name.
Dim lb As Integer   'List Begin Row.
Dim lc As Integer   'List Count.
Dim le As Integer   'List End Row.
Dim lp As Integer   'List Position.
Dim mc As Integer   'Member Count.
Dim mp As Integer   'Member Position.
Dim mv As New NameValueCollection 'Component Values.
Dim nv As NameValueTypeItem   'Working Name/Value Item.
Dim pi As NameValueTypeCollection 'Current repeater group.
Dim pv As New GroupNameValueTypeCollection  'Repeater groups.
Dim rp As Integer   'Reference Row Position.
Dim sh As Worksheet 'Working Sheet.
Dim st As Worksheet 'Template Sheet.
Dim tc As Integer   'Template Count.
Dim tl As String    'Lowercase Value.
Dim tp As Integer   'Template Row Position.
Dim ts As String    'Transitory Working String.
Dim tv As NameValueTypeCollection 'Template Values.
Dim ws As String    'Working String.

  bc = True
  fc = ""

  If Not Target Is Nothing Then
    Set st = Target
    'In this scenario, set the template as the main sheet.
    st.Select
  Else
    MsgBox "Template sheet not found...", vbOKOnly, "HTML From Template"
    bc = False
  End If

  If bc = True Then
    'Count the fields.
    lb = 2
    le = GetEndRow(st, "A", lb)
    lc = le - lb + 1
    'Initialize the repeaters (groups).
    ge = 0
    gn = ""
    Set tv = Nothing
    For lp = lb To le
      If ValueCell("A", lp) = "1" Then
        'Row is active.
        ws = ValueCell("B", lp)
        tl = LCase(ws)
        If lp > ge Then
          'Not working within the current group.
          'Update and find the end of this group.
          Set tv = New NameValueTypeCollection
          pv.Add tv
          For tp = lp To le
            If ValueCell("A", tp) = "1" Then
              'Row is active.
              ws = ValueCell("B", tp)
              tl = LCase(ws)
              If InStr(tl, "fieldrepeat(") > 0 Then
                'Field repeater found.
                ' If located at current row, then it starts this group.
                ' If located further down, it starts the next group.
                If tp = lp Then
                  'Field repeater starts the group.
                  ' Identify and include all repeaters in this group.
                  gn = GetParameter(ws, 2)
                  bf = False
                  For rp = tp + 1 To le
                    If ValueCell("A", rp) = "1" Then
                      'Row is active.
                      ws = ValueCell("B", rp)
                      tl = LCase(ws)
                      If InStr(tl, "fieldrepeat(") > 0 Then
                        If GetParameter(ws, 2) = gn Then
                          'A matching repeater was found further down.
                          bf = True
                          ge = rp
                        Else
                          'Next repeater is in a different group.
                          Exit For
                        End If
                      End If
                    End If
                  Next rp
                  If bf = False Then
                    'No matching repeaters found. This repeater is
                    ' in a group by itself.
                    ge = lp
                    Exit For
                  End If
                Else
                  'Next group is found at that row.
                  ' Previous loop establishes the end of this group.
                End If
                'Unconditionally done with this inspection.
                Exit For
              End If
              'When falling through, this row is included.
              ge = tp
            End If
          Next tp
        End If
        'Add this item to the current group list.
        tv.AddValue ValueCell("C", lp), ValueCell("D", lp), _
          ValueCell("B", lp)
      End If
    Next lp
    'All lines in the template sheet are now stored as groups and
    ' are packed in the pv collection.
    'Prepare the conditional values list.
    cv.AddValue "{ifFirst}", "1"            'Updated with context.
    cv.AddValue "{ifNotFirst}", "0"         'Updated with context.
    cv.AddValue "{ifLast}", "1"             'Updated with context.
    cv.AddValue "{ifNotLast}", "0"          'Updated with context.
    cv.AddValue "{ifFieldCountGT0}", "0"    'Updated with component.
    cv.AddValue "{ifReadOnly}", "1"         'Updated with context.
    'Initialize Component Info.
    cc = 0
    ws = GetConfigValue("ComponentPages")
    If Len(ws) > 0 Then
      ca = Split(ws, ",")
      'Using normal count on components.
      cc = UBound(ca) + 1
    End If
    For cp = 0 To cc - 1
      ca(cp) = Trim(ca(cp))
    Next cp
    'Cycle Type.
    ' 0 - One-time filler.
    ' 1 - Component.
    ' 2 - Data.
    ' 3 - Entry.
    ' 4 - Edit.
    ' 5 - GridCol.
    ct = 0
    tc = pv.Count
    For tp = 1 To tc
      'Process each group.
      Set pi = pv.Item(tp)
      lc = pi.Count
      For lp = 1 To lc
        'Each line in the template.
        Set nv = pi.Item(lp)
        ws = nv.ItemType
        tl = LCase(ws)
        If lp = 1 Then
          'Key the group according to the entry on the first line.
          If InStr(tl, "fieldrepeat(") > 0 Then
            'Repeaters.
            gn = LCase(GetParameter(ws, 1))
            Select Case gn
              Case "component":
                'All entries in the template will be repeated per component.
                ct = 1
              Case "data", "entry":
                'All data fields from all components will be cycled for this
                ' and other 'data' and 'entry' members. 'component' members
                ' will be treated as filler.
                If gn = "data" Then
                  ct = 2
                Else
                  ct = 3
                End If
              Case "edit":
                'All editable fields from all components will be cycled for
                ' members. 'component' members will be treated as filler.
                ct = 4
              Case "gridcol":
                'All grid fields from all components will be cycled for
                ' members.
                ct = 5
            End Select
          Else
            'Normal filler.
            ct = 0
          End If
        End If
        Select Case ct
          Case 0: 'Filler.
            ws = ResolveParamTags(nv.Value)
            fc = fc & ws & vbCrLf
          Case 1: 'Component.
            'All entries in this group are handled at this junction.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              'Update the component tags.
              UpdateComponentTags sh, mv
              mc = pi.Count
              For mp = 1 To mc
                Set nv = pi.Item(mp)
                ws = nv.ItemType
                tl = LCase(ws)
                If InStr(tl, "fieldrepeat(") > 0 Then
                  gn = GetParameter(tl, 1)
                  Select Case gn
                    Case "component":
                      'Data with this component.
                      cv.SetValue "{ifFieldCountGT0}", _
                        CStr(GetEndRow(sh, "A", 3) > 0)
                      cv.SetValue "{ifFirst}", CStr(cp = 0)
                      cv.SetValue "{ifNotFirst}", CStr(cp <> 0)
                      cv.SetValue "{ifLast}", CStr(cp >= cc - 1)
                      cv.SetValue "{ifNotLast}", CStr(cp < cc - 1)
                      cv.SetValue "{ifReadOnly}", CStr(IsComponentReadOnly(sh))
                      ts = ResolveTags(nv.Value, mv)
                      ts = ResolveParamTags(ts)
                      ts = ResolveConditionTags(ts, cv)
                      fc = fc & ts & vbCrLf
                    Case "data", "entry":
                      'All fields in this component.
                      If gn = "data" Then
                        ct = 2
                      Else
                        ct = 3
                      End If
                      fb = 2
                      If ct = 2 Then
                        'Last row for data is probably early.
                        fe = GetEndRowValue(sh, "D", "1", fb)
                      Else
                        'All entries valid except 'item'.
                        fe = GetEndRow(sh, "A", fb)
                      End If
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      bf = False
                      For fp = fb To fe
                        If (ct = 3 Or ValueCellSheet(sh, "D", fp) = "1") And _
                          LCase(ValueCellSheet(sh, "E", fp)) <> "item" Then
                          'Matching field. Run the template on these values.
                          cv.SetValue "{ifFirst}", CStr(Not bf)
                          cv.SetValue "{ifNotFirst}", CStr(bf)
                          cv.SetValue "{ifLast}", CStr(fp >= fe)
                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
                          cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                          bf = True
                          UpdateFieldTags sh, fp, mv, fv
                          ts = ResolveTags(nv.Value, fv)
                          ts = ResolveParamTags(ts)
                          ts = ResolveConditionTags(ts, cv)
                          fc = fc & ts & vbCrLf
                        End If
                      Next fp
                    Case "edit":
                      'Add editor fields in this component.
                      fb = 2
                      'Last row for edit is probably early.
                      fe = GetEndRowNonBlank(sh, "O", fb)
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      bf = False
                      For fp = fb To fe
                        If Len(ValueCellSheet(sh, "O", fp)) > 0 Then
                          'Matching field. Run the template on these values.
                          cv.SetValue "{ifFirst}", CStr(Not bf)
                          cv.SetValue "{ifNotFirst}", CStr(bf)
                          cv.SetValue "{ifLast}", CStr(fp >= fe)
                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
                          cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                          bf = True
                          UpdateFieldTags sh, fp, mv, fv
                          ts = ResolveTags(nv.Value, fv)
                          ts = ResolveParamTags(ts)
                          ts = ResolveConditionTags(ts, cv)
                          fc = fc & ts & vbCrLf
                        End If
                      Next fp
                    Case "gridcol":
                      'Add grid column fields in this component.
                      'Non-default only.
                      fb = 2
                      'Last row for edit is probably early.
                      fe = GetEndRowNonBlank(sh, "N", fb)
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      bf = False
                      For fp = fb To fe
                        If Len(ValueCellSheet(sh, "N", fp)) > 0 And _
                          ValueCellSheet(sh, "V", fp) <> "1" Then
                          'Matching field. Run the template on these values.
                          cv.SetValue "{ifFirst}", CStr(Not bf)
                          cv.SetValue "{ifNotFirst}", CStr(bf)
                          cv.SetValue "{ifLast}", CStr(fp >= fe)
                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
                          cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                          bf = True
                          UpdateFieldTags sh, fp, mv, fv
                          ts = ResolveTags(nv.Value, fv)
                          ts = ResolveParamTags(ts)
                          ts = ResolveConditionTags(ts, cv)
                          fc = fc & ts & vbCrLf
                        End If
                      Next fp
                  End Select
                Else
                  'Normal line. Treat as component repeat.
                  cv.SetValue "{ifFieldCountGT0}", _
                    CStr(GetEndRow(sh, "A", 3) > 0)
                  cv.SetValue "{ifFirst}", CStr(cp = 0)
                  cv.SetValue "{ifNotFirst}", CStr(cp <> 0)
                  cv.SetValue "{ifLast}", CStr(cp >= cc - 1)
                  cv.SetValue "{ifNotLast}", CStr(cp < cc - 1)
                  cv.SetValue "{ifReadOnly}", CStr(IsComponentReadOnly(sh))
                  ts = ResolveTags(nv.Value, mv)
                  ts = ResolveParamTags(ts)
                  ts = ResolveConditionTags(ts, cv)
                  fc = fc & ts & vbCrLf
                End If
              Next mp
            Next cp
            'Done processing for entire group.
            Exit For
          Case 2, 3: 'Data, Entry.
            'List all fields in every component.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              UpdateComponentTags sh, mv
              fb = 2
              If ct = 2 Then
                'Last row for data is probably early.
                fe = GetEndRowValue(sh, "D", "1", fb)
              Else
                'All entries valid except 'item'.
                fe = GetEndRow(sh, "A", fb)
              End If
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              bf = False
              For fp = fb To fe
                If (ct = 3 Or ValueCellSheet(sh, "D", fp) = "1") And _
                  LCase(ValueCellSheet(sh, "E", fp)) <> "item" Then
                  'Matching field. Run the template on these values.
                  cv.SetValue "{ifFirst}", CStr(Not bf)
                  cv.SetValue "{ifNotFirst}", CStr(bf)
                  cv.SetValue "{ifLast}", CStr(fp >= fe)
                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                  bf = True
                  UpdateFieldTags sh, fp, mv, fv
                  ts = ResolveTags(nv.Value, fv)
                  ts = ResolveParamTags(ts)
                  ts = ResolveConditionTags(ts, cv)
                  fc = fc & ts & vbCrLf
                End If
              Next fp
            Next cp
          Case 4: 'Edit.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              UpdateComponentTags sh, mv
              fb = 2
              'Last row for edit is probably early.
              fe = GetEndRowNonBlank(sh, "O", fb)
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              bf = False
              For fp = fb To fe
                If Len(ValueCellSheet(sh, "O", fp)) > 0 Then
                  'Matching field. Run the template on these values.
                  cv.SetValue "{ifFirst}", CStr(Not bf)
                  cv.SetValue "{ifNotFirst}", CStr(bf)
                  cv.SetValue "{ifLast}", CStr(fp >= fe)
                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                  bf = True
                  UpdateFieldTags sh, fp, mv, fv
                  ts = ResolveTags(nv.Value, fv)
                  ts = ResolveParamTags(ts)
                  ts = ResolveConditionTags(ts, cv)
                  fc = fc & ts & vbCrLf
                End If
              Next fp
            Next cp
          Case 5: 'GridCol.
            'Non-default grid columns only.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              UpdateComponentTags sh, mv
              fb = 2
              'Last row for edit is probably early.
              fe = GetEndRowNonBlank(sh, "N", fb)
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              bf = False
              For fp = fb To fe
                If Len(ValueCellSheet(sh, "N", fp)) > 0 And _
                  ValueCellSheet(sh, "V", fp) <> "1" Then
                  'Matching field. Run the template on these values.
                  cv.SetValue "{ifFirst}", CStr(Not bf)
                  cv.SetValue "{ifNotFirst}", CStr(bf)
                  cv.SetValue "{ifLast}", CStr(fp >= fe)
                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
                  bf = True
                  UpdateFieldTags sh, fp, mv, fv
                  ts = ResolveTags(nv.Value, fv)
                  ts = ResolveParamTags(ts)
                  ts = ResolveConditionTags(ts, cv)
                  fc = fc & ts & vbCrLf
                End If
              Next fp
            Next cp
        End Select
      Next lp
    Next tp
  End If
  If Len(fc) > 0 Then
    ClipBoard_SetData fc
    MsgBox "New file text has been copied to clipboard.", vbOKOnly, _
      "HTML From Template"
  End If

End Sub

Private Function IsComponentReadOnly(Sheet As Worksheet) As Boolean
'Return a value indicating whether the specified component is read only.
Dim lp As Integer   'List Position.
Dim rv As Boolean   'Return Value.

  lp = GetItemRow(Sheet)
  If lp > 0 Then
    rv = (ValueCellSheet(Sheet, "P", lp) = "1")
  End If
  IsComponentReadOnly = rv

End Function

Private Function IsFieldReadOnly(Sheet As Worksheet, Index As Integer) As Boolean
'Return a value indicating whether the specified field is read only.
Dim lp As Integer   'List Position.
Dim rv As Boolean   'Return Value.

  If Index > 0 Then
    rv = (ValueCellSheet(Sheet, "P", Index) = "1")
  End If
  IsFieldReadOnly = rv

End Function

Private Function NameValues(columnIndex As Integer, currentRow As Integer) As String
'Return the string of Name/Value pairs starting at the specified column index.
Dim cp As Long      'Column Position.
Dim nm As String    'Name/Value Name.
Dim nv As String    'Name/Value Value.
Dim rv As String    'Return Value.

  rv = ""
  If columnIndex > 0 And currentRow > 0 Then
    cp = columnIndex
    Do While Len(ValueCell(ColToChar(cp), currentRow)) > 0
      nm = ValueCell(ColToChar(cp), currentRow)
      nv = ValueCell(ColToChar(cp + 1), currentRow)
      If Len(rv) > 0 Then
        rv = rv & " "
      End If
      rv = rv & nm
      rv = rv & "="""
      rv = rv & nv
      rv = rv & """"
      cp = cp + 2
    Loop
  End If
  NameValues = rv
End Function

Private Function ReplaceStringSection(Source As String, _
  StartIndex As Integer, EndIndex As Integer, _
  ReplaceText As String) As String
Dim cl As String    'Left Section.
Dim cr As String    'Right Section.
Dim rv As String    'Return Value.
Dim sl As Integer   'String Length.

  sl = Len(Source)

  If StartIndex > 1 Then
    cl = Left(Source, StartIndex - 1)
  End If
  If StartIndex > 0 And EndIndex >= StartIndex And _
    sl >= EndIndex Then
    cr = Right(Source, sl - EndIndex)
  End If
  rv = cl & ReplaceText & cr
  ReplaceStringSection = rv

End Function

Private Function ResolveConditionTags(Source As String, _
  List As NameValueCollection) As String
'Include or exclude conditional tags.
'Conditional tags have the following syntax:
' {ifSomeCondition}...{/ifSomeCondition}
'If the condition is not found in the list, the content
' is removed from the source.
'If the condition is found but evaluates to false, then
' it is removed from the source.
'If the condition if found and it evaluates to true, then
' the enclosing tags are removed.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim ni As NameValueItem
Dim rv As String      'Return Value.
Dim ws As String      'Working String.

  rv = Source
  lc = List.Count
  For lp = 1 To lc
    Set ni = List.Item(lp)
    If InStr(rv, ni.Name) > 0 Then
      'Matching item found.
      If CBool(ni.Value) = True Then
        rv = Replace(rv, ni.Name, "")
        rv = Replace(rv, Left(ni.Name, 1) & "/" & _
          Right(ni.Name, Len(ni.Name) - 1), "")
      Else
        ws = Replace(Replace(ni.Name, "{", "\{"), "}", "\}")
        ws = ws & ".*?" & Left(ws, 2) & "/" & Right(ws, Len(ws) - 2)
        rv = RegExReplace(rv, ws, "")
      End If
    End If
  Next lp
  Do While InStr(rv, "{if") > 0
    'No remaining conditional items were specified in the list.
    ws = "\{if([^\}]*)\}.*?\{/if\1}"
    rv = RegExReplace(rv, ws, "")
  Loop
  ResolveConditionTags = rv

End Function

Private Function ResolveParamTags(Source As String) As String
'Replace tags that use parameters.
Dim c1 As String      'Construction String Left.
Dim c2 As String      'Construction String Middle.
Dim c3 As String      'Construction String Right.
Dim cc As Integer     'Character Count.
Dim cp As Integer     'Character Position.
Dim bf As Boolean     'Flag - Found.
Dim pb As Integer     'Pattern Begin.
Dim pe As Integer     'Pattern End.
Dim ps As String      'Pattern String.
Dim rv As String      'Return Value.
Dim sa() As String    'String Array.
Dim sc As Integer     'String Count.
Dim sh As Worksheet   'Working Sheet.
Dim sl As Integer     'String Length.
Dim sp As Integer     'String Position.
Dim tl As String      'Lower case working value.
Dim tv As NameValueCollection 'Tag Values List.
Dim wv As Integer     'Working Value.
Dim ws As String      'Working String.

  rv = Source
  bf = True
  Do While bf = True
    bf = False
    tl = LCase(rv)
    If InStr(tl, "{t,") > 0 Then
      '{T,RepeatCount}
      'Insert the specified number of tabs.
      sl = Len(tl)
      pb = InStr(tl, "{t,")
      pe = FindClosingBrace(tl, pb)
      If pe > 0 Then
        ps = Mid(rv, pb, pe - pb + 1)
        sa = Split(ps, ",")
        ws = Left(sa(1), Len(sa(1)) - 1)
        wv = CInt(ws)
        ws = IIf(wv > 0, GetTabs(wv), "")
        rv = ReplaceStringSection(rv, pb, pe, ws)
        bf = True
      End If
    ElseIf InStr(tl, "{componentinfo,") > 0 Then
      '{ComponentInfo,ComponentIndex,TagName}
      'Select the value of a tag, using the component whose
      ' order is specified in:
      ' Sheets("Configuration").Item("ComponentPages")
      pb = InStr(tl, "{componentinfo,")
      pe = FindClosingBrace(tl, pb)
      If pe > 0 Then
        ps = Mid(rv, pb, pe - pb + 1)
        sa = Split(ps, ",")
        wv = CInt(sa(1))  'Index.
        ps = "{" & sa(2)  'TagName.
        ws = GetConfigValue("ComponentPages")
        If Len(ws) > 0 Then
          ws = Replace(ws, " ", "")
          sa = Split(ws, ",")
          'Arrays are 0-based.
          wv = wv - 1
          If UBound(sa) >= wv Then
            ws = sa(wv)
            Set sh = Sheets(ws)
            If Not sh Is Nothing Then
              'Component Sheet was found.
              Set tv = New NameValueCollection
              UpdateComponentTags sh, tv
              ps = ResolveTags(ps, tv)
              rv = ReplaceStringSection(rv, pb, pe, ps)
              bf = True
            End If
          End If
        End If
      End If
    ElseIf InStr(tl, "{tabsto,") > 0 Then
      '{TabsTo,TargetCharacterIndex,LeftContent}
      'Insert tabs that will bring the cursor position to the
      ' specified Target Character Index.
      sl = Len(tl)
      pb = InStr(tl, "{tabsto,")
      pe = FindClosingBrace(tl, pb)
      If pe > 0 Then
        ps = Mid(rv, pb, pe - pb + 1)
        sa = Split(ps, ",")
        sc = UBound(sa)
        wv = CInt(sa(1))
        ws = ""
        For sp = 2 To sc
          ws = ws & sa(sp)
        Next sp
        ws = Left(ws, Len(ws) - 1)
        cp = InStr(ws, Chr(9))
        Do While cp > 0
          If cp Mod 2 = 1 Then
            ws = Left(ws, cp - 1) & "  " & _
              Right(ws, Len(ws) - cp)
          Else
            ws = Left(ws, cp - 1) & " " & _
              Right(ws, Len(ws) - cp)
          End If
          cp = InStr(ws, Chr(9))
        Loop
        cc = 0
        sl = Len(ws)
        Do While sl < wv - 1
          If sl Mod 2 = 0 Then
            ws = ws & "  "
          Else
            ws = ws & " "
          End If
          cc = cc + 1
          sl = Len(ws)
        Loop
        'All of the tabs have been inserted.
        ws = IIf(cc > 0, GetTabs(cc), "")
        rv = ReplaceStringSection(rv, pb, pe, ws)
        bf = True
      End If
    End If
  Loop
  ResolveParamTags = rv

End Function

Private Function ResolveTags(Source As String, List As NameValueCollection) As String
'Replace all tags found in the source with the associated values in the List.
Dim lc As Integer     'List Count.
Dim lp As Integer     'List Position.
Dim ni As NameValueItem
Dim rv As String      'Return Value.

  rv = Source
  lc = List.Count
  For lp = 1 To lc
    Set ni = List.Item(lp)
    rv = Replace(rv, ni.Name, ni.Value)
  Next lp
  ResolveTags = rv

End Function

Private Sub UpdateComponentTags(Sheet As Worksheet, List As NameValueCollection)
'Update the list of tags for the specified component.
Dim na As String    'Component Name.

  List.Clear
  If Len(Sheet.Name) > 9 And LCase(Left(Sheet.Name, 9)) = "component" Then
    na = Right(Sheet.Name, Len(Sheet.Name) - 9)
    List.AddValue "{Item}", na
    List.AddValue "{Items}", GetPlural(na)
    List.AddValue "{LItem}", LCase(na)
    List.AddValue "{LItems}", LCase(GetPlural(na))
    List.AddValue "{FieldNameList}", GetNativeList(Sheet, 2)
    List.AddValue "{Tab}", Chr(9)
    List.AddValue "{T}", Chr(9)
    List.AddValue "{Scope}", "Public"
    List.AddValue "{AAn}", GetIndefiniteArticle(na)
    List.AddValue "{DefaultFieldName}", GetDefaultFieldName(Sheet)
    List.AddValue "{DefaultFieldDisplayName}", GetDefaultFieldDisplayName(Sheet)
  End If

End Sub

Private Sub UpdateFieldTags(Sheet As Worksheet, Index As Integer, _
  ComponentTags As NameValueCollection, _
  FieldTags As NameValueCollection)
'Update the list of tags for the specified field.
Dim na As String    'Field Name.

  FieldTags.Clear
  FieldTags.AddRange ComponentTags
  FieldTags.AddValue "{FieldName}", ValueCellSheet(Sheet, "A", Index)
  FieldTags.AddValue "{FieldDataType}", ValueCellSheet(Sheet, "B", Index)
  FieldTags.AddValue "{FieldDefaultValue}", ValueCellSheet(Sheet, "C", Index)
  FieldTags.AddValue "{FieldNative}", ValueCellSheet(Sheet, "D", Index)
  FieldTags.AddValue "{FieldSource}", ValueCellSheet(Sheet, "E", Index)
  FieldTags.AddValue "{FieldTable}", ValueCellSheet(Sheet, "F", Index)
  FieldTags.AddValue "{FieldSelect}", _
    Replace(ValueCellSheet(Sheet, "G", Index), """", "\""")
  FieldTags.AddValue "{FieldAlias}", ValueCellSheet(Sheet, "H", Index)
  FieldTags.AddValue "{FieldKeyName}", ValueCellSheet(Sheet, "I", Index)
  FieldTags.AddValue "{FieldKeyValue}", ValueCellSheet(Sheet, "J", Index)
  FieldTags.AddValue "{FieldSQLType}", _
    GetScalarType(ValueCellSheet(Sheet, "B", Index))
  FieldTags.AddValue "{FieldDisplayName}", ValueCellSheet(Sheet, "L", Index)

End Sub

Private Function ValueCell(ColumnName As String, currentRow As Integer) As String
'Return the value of the specified cell.
  ValueCell = Range(ColumnName & CStr(currentRow)).Value
End Function

Private Function ValueCellSheet(Sheet As Worksheet, _
  ColumnName As String, currentRow As Integer) As String
'Return the value of the specified cell.
  ValueCellSheet = Sheet.Range(ColumnName & CStr(currentRow)).Value
End Function

Private Function ValueNext(ColumnName As String, currentRow As Integer) As String
'Return the value of the cell at the next row.
  ValueNext = Range(ColumnName & CStr(currentRow + 1)).Value
End Function

Private Function ValuePrev(ColumnName As String, currentRow As Integer) As String
'Return the value of the cell at the previous row.
  ValuePrev = Range(ColumnName & CStr(currentRow - 1)).Value
End Function




