Attribute VB_Name = "BankWorksheetMain"
Option Explicit

'BankWorksheetMain.bas
'Copyright (c). 2018, 2019. Daniel Patterson, MCSD (DanielAnywhere)

Private Const ScopePrivate = 0
Private Const ScopeProtected = 1
Private Const ScopePublic = 2
Private CCfg As New ComponentProperties
Private TCfg As New TemplateProperties

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
    Do While Len(ValueCell(CCfg.ColumnName, lp)) > 0
      lp = lp + 1
    Loop
    lc = lp - lb
    le = lp - 1
    'Initialize the field names.
    cv.Clear
    For lp = lb To le
      cv.AddValue ValueCell(CCfg.ColumnName, lp), CStr(lp)
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
      Do While Len(ValueCellSheet(st, TCfg.ColumnActive, rp)) > 0
        rp = rp + 1
      Loop
      rc = rp - rb
      re = rp - 1
      
      For rp = rb To re
        If ValueCellSheet(st, TCfg.ColumnActive, rp) = "1" Then
          'Row is active.
          ws = ValueCellSheet(st, TCfg.ColumnTypeName, rp)
          Select Case LCase(ws)
            Case "space":
              'Add a blank line of space.
              fc = fc & vbCrLf
            Case "using":
              'In this version, all using statements occur
              ' prior to the namespace.
              fc = fc & ValueCellSheet(st, TCfg.ColumnContent, rp) & vbCrLf
            Case "namespace":
              'In this version, all classes are in a single namespace.
              fc = fc & "namespace " & _
                ValueCellSheet(st, TCfg.ColumnContent, rp) & vbCrLf
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
                If ValueCellSheet(st, TCfg.ColumnActive, tp) = "1" And _
                  InStr(LCase(ValueCellSheet(st, TCfg.ColumnTypeName, tp)), _
                  "fieldrepeat") > 0 Then
                  'Field repeater found.
                  pv(sc).AddValue _
                    ValueCellSheet(st, TCfg.ColumnTypeName, tp), _
                    ValueCellSheet(st, TCfg.ColumnContent, tp)
                ElseIf LCase(ValueCellSheet(st, TCfg.ColumnTypeName, tp)) = _
                  "section" Then
                  'Key the repeaters to their associated sections.
                  ws = LCase(ValueCellSheet(st, TCfg.ColumnContent, tp))
                  Select Case ws
                    Case "private":
                      sc = ScopePrivate
                    Case "protected":
                      sc = ScopeProtected
                    Case "public":
                      sc = ScopePublic
                  End Select
                ElseIf LCase(ValueCellSheet(st, TCfg.ColumnTypeName, tp)) = _
                  "class" Then
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
              ws = ResolveTags(ValueCellSheet(st, TCfg.ColumnContent, rp), tv)
              ws = ResolveParamTags(ws)
              fc = fc & ws & vbCrLf
              fc = fc & GetTabs(1) & "{" & vbCrLf
              cb = cb + 1
              bo = True
            Case "section":
              ws = ValueCellSheet(st, TCfg.ColumnContent, rp)
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
              ws = ValueCellSheet(st, TCfg.ColumnName, rp)
              If Len(nn) = 0 Or pv(sc).Count = 0 Or _
                CompareStrings(ws, nn) < 0 Then
                'Current entry occurs before the next repeater.
                ws = _
                  ResolveTags(ValueCellSheet(st, TCfg.ColumnContent, rp), tv)
                ws = ResolveParamTags(ws)
                fc = fc & ws & vbCrLf
              Else
                'Next repeater occurs before the current entry.
                'Consume the next repeater.
                Set nv = cv.Item(ni)
                lp = CInt(nv.Value)
'                fv.Clear
'                fv.AddRange tv
'                fv.AddValue "{FieldName}", ValueCell(CCfg.ColumnName, lp)
'                fv.AddValue "{FieldDataType}", ValueCell(CCfg.ColumnDataType, lp)
'                fv.AddValue "{FieldDefaultValue}", ValueCell(CCfg.ColumnDefaultValue, lp)
'                fv.AddValue "{FieldNative}", ValueCell(CCfg.ColumnIsData, lp)
'                fv.AddValue "{FieldSource}", ValueCell(CCfg.ColumnSource, lp)
'                fv.AddValue "{FieldTable}", ValueCell(CCfg.ColumnTable, lp)
'                fv.AddValue "{FieldSelect}", _
'                  Replace(ValueCell(CCfg.ColumnSelect, lp), """", "\""")
'                fv.AddValue "{FieldAlias}", ValueCell(CCfg.ColumnAlias, lp)
'                fv.AddValue "{FieldKeyName}", ValueCell(CCfg.ColumnKeyName, lp)
'                fv.AddValue "{FieldKeyValue}", ValueCell(CCfg.ColumnKeyValue, lp)
'                fv.AddValue "{FieldSQLType}", _
'                  GetScalarType(ValueCell(CCfg.ColumnDataType, lp))
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

  On Local Error Resume Next
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
    Do While Len(ValueCell(CCfg.ColumnName, lp)) > 0
      bid = False
      If LCase(ValueCell(CCfg.ColumnDataType, lp)) = "object" And _
        LCase(ValueCell(CCfg.ColumnSource, lp)) = "item" Then
        'The identity specification is found on the default value of the
        ' abstract item.
        ident = "IDENTITY(" & ValueCell(CCfg.ColumnDefaultValue, lp) & ")"
      ElseIf ValueCell(CCfg.ColumnIsData, lp) = "1" Then
        'Only script to table if this is a data column.
        cName = ValueCell(CCfg.ColumnName, lp)
        cType = GetSqlType(ValueCell(CCfg.ColumnDataType, lp))
        cLen = ValueCell(CCfg.ColumnLength, lp)
        cDef = GetSqlDefault(ValueCell(CCfg.ColumnDefaultValue, lp))
        If LCase(cName) = LCase(iName) & "id" Then
          'This is the ID column. Use the prescribed identity.
          cDef = ident
          bid = True
        ElseIf LCase(cName) = LCase(iName) & "ticket" Then
          'This is the global identity column.
          cDef = "ROWGUIDCOL"
        End If
        cNull = GetSqlNullable(ValueCell(CCfg.ColumnDefaultValue, lp))
        cDesc = ValueCell(CCfg.ColumnDescription, lp)
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
      Err.Clear
      Set ts = fso.CreateTextFile(fln, True, False)
      If Err.Number = 0 Then
        ts.Write fc
        ts.Close
        MsgBox "SQL Table Script Saved to " & fln, vbOKOnly, _
          "Create SQL Table Script"
      Else
        MsgBox "Error saving SQL file: " & Err.Description & _
          vbCrLf & _
          "Check the Configuration sheet, [TableFolderName] value.", _
          vbOKOnly, "Create SQL Table Script"
        Err.Clear
      End If
      Set ts = Nothing
      Set fso = Nothing
    End If
  End If

End Sub

Public Sub CreateWebAPI2LookupControllerCode()
'Use the TemplateLookupController sheet to create code for the Component on
' the selected sheet.
  CodeFromTemplate Sheets("TemplateLookupController")

End Sub

Public Sub CreateWebAPI2ObjectControllerCode()
'Use the TemplateObjectController sheet to create code for the Component on
' the selected sheet.
  CodeFromTemplate Sheets("TemplateObjectController")

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

Private Function FindClosingElementEnd(Value As String, _
  Index As Integer) As Integer
'Return the character position of the last character of the closing element
' that matches this element.
Dim cb As Integer   'Character Begin.
Dim cc As Integer   'Character Count.
Dim ce As Integer   'Character End.
Dim cl As String    'Left Reference Character.
Dim cp As Integer   'Character Position.
Dim cr As String    'Right Reference Character.
Dim es As New StringStack
Dim ip As Integer   'Instring Position.
Dim iv As String    'Internal Value.
Dim mv As String    'Matching Value.
Dim rv As Integer   'Return Value.
Dim sv As String    'Starting Value.

  rv = 0
  cc = Len(Value)
  cb = Index
  ce = FindClosingBrace(Value, cb)
  If ce > cb + 1 Then
    'A value is known.
    cl = Mid(Value, cb, 1)
    Select Case cl
      Case "[":
        cr = "]"
      Case "{":
        cr = "}"
      Case "(":
        cr = ")"
      Case "<":
        cr = ">"
    End Select
    'Internal Value.
    iv = Mid(Value, cb + 1, ce - cb - 1)
    sv = Mid(Value, cb, ce - cb + 1)
    mv = cl & "/" & iv & cr
    ip = InStr(ce + 1, Value, mv)
    Do While ip > 0
      'A closing tag was found. Verify it is the right one.
      es.Clear
      For cp = ce To ip - 1
        If cc > cp + Len(sv) Then
          If Mid(Value, cp, Len(sv)) = sv Then
            'Open another element of the same name before close.
            es.Push mv
          End If
        End If
        If cc > cp + Len(mv) Then
          If Mid(Value, cp, Len(mv)) = mv Then
            'Balance the stack.
            es.Pop
          End If
        End If
      Next cp
      If es.Count = 0 Then
        Exit Do
      Else
        ip = ip + 1
        es.Clear
        ip = InStr(ip, Value, mv)
      End If
    Loop
    If ip > 0 Then
      'The end value was found. Return the last char pos.
      rv = ip + Len(mv) - 1
    End If
  End If
  FindClosingElementEnd = rv

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
      Exit Do
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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
    If ValueCellSheet(Sheet, CCfg.ColumnIsDefault, lp) = "1" Then
      rv = ValueCellSheet(Sheet, CCfg.ColumnDisplay, lp)
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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
    If ValueCellSheet(Sheet, CCfg.ColumnIsDefault, lp) = "1" Then
      rv = ValueCellSheet(Sheet, CCfg.ColumnName, lp)
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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
    If LCase(ValueCellSheet(Sheet, ColumnName, lp)) = tl Then
      rv = lp
    End If
    lp = lp + 1
  Loop
  GetEndRowValue = rv

End Function

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

Private Function GetIDFieldName(Sheet As Worksheet) As String
'Return the ID field name that uniquely identifies the component.
Dim rv As String  'Return Value.

  If LCase(Left(Sheet.Name, 9)) = "component" Then
    rv = Right(Sheet.Name, Len(Sheet.Name) - 9) & "ID"
  End If
  GetIDFieldName = rv

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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
    If LCase(ValueCellSheet(Sheet, CCfg.ColumnSource, lp)) = "item" Then
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
  Do While Len(ValueCellSheet(Sheet, CCfg.ColumnName, lp)) > 0
    If ValueCellSheet(Sheet, CCfg.ColumnIsData, lp) = "1" Then
      If Len(rv) > 0 Then
        rv = rv & ", "
      End If
      rv = rv & """" & ValueCellSheet(Sheet, CCfg.ColumnName, lp) & """"
    End If
    lp = lp + 1
  Loop
  GetNativeList = rv

End Function

Public Function GetParameter(Value As String, Index As Integer) As String
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
'The Condition(entry,compare) directive is used to compare a resolvable
' field variable with one or more possible settings.
' For example, Condition(FieldDataType,"string") will be used if
' the data type for the current column definition is "string",
' and will be skipped otherwise.
Dim bc As Boolean   'Flag - Continue.
Dim bf As Boolean   'Flag - Found.
dim bv as Boolean		'Flag - Continue on Value.
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
dim pl as Integer		'Left position.
dim pr as Integer		'Right position.
Dim pv As New GroupNameValueTypeCollection  'Repeater groups.
Dim rp As Integer   'Reference Row Position.
dim sa() as string	'String array.
dim sf() as string	'Field name array.
Dim sh As Worksheet 'Working Sheet.
Dim st As Worksheet 'Template Sheet.
Dim tc As Integer   'Template Count.
Dim tk As New FieldTokenItem  'Token for delegating field work.
Dim tl As String    'Lowercase Value.
Dim tp As Integer   'Template Row Position.
Dim ts As String    'Transitory Working String.
Dim tv As NameValueTypeCollection 'Template Values.
dim vl as string		'Left value.
dim vr as string		'Right value.
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
    Set tk.CompareValues = cv
    Set tk.ComponentValues = mv
    Set tk.FieldValues = fv
    'Count the fields.
    lb = 2
    le = GetEndRow(st, CCfg.ColumnName, lb)
    lc = le - lb + 1
    'Initialize the repeaters (groups).
    ge = 0
    gn = ""
    Set tv = Nothing
    For lp = lb To le
      If ValueCell(CCfg.ColumnName, lp) = "1" Then
        'Row is active.
        ws = ValueCell(CCfg.ColumnDataType, lp)
        tl = LCase(ws)
        If lp > ge Then
          'Not working within the current group.
          'Update and find the end of this group.
          Set tv = New NameValueTypeCollection
          pv.Add tv
          For tp = lp To le
            If ValueCell(CCfg.ColumnName, tp) = "1" Then
              'Row is active.
              ws = ValueCell(CCfg.ColumnDataType, tp)
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
                    If ValueCell(CCfg.ColumnName, rp) = "1" Then
                      'Row is active.
                      ws = ValueCell(CCfg.ColumnDataType, rp)
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
        tv.AddValue ValueCell(CCfg.ColumnDefaultValue, lp), ValueCell(CCfg.ColumnIsData, lp), _
          ValueCell(CCfg.ColumnDataType, lp)
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
        tk.ComponentType = ct
        Select Case ct
          Case 0: 'Filler.
            ws = ResolveParamTags(nv.Value)
            fc = fc & ws & vbCrLf
          Case 1: 'Component.
            'All entries in this group are handled at this junction.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              Set tk.Sheet = sh
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
                      cv.SetMatches "{ifEditor", "False"
                      cv.SetMatches "{ifFormat", "False"
                      cv.SetValue "{ifFieldCountGT0}", _
                        CStr(GetEndRow(sh, CCfg.ColumnName, 3) > 0)
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
                      'Component / Data.
                      'Component / Entry.
                      'All fields in this component.
                      If gn = "data" Then
                        ct = 2
                      Else
                        ct = 3
                      End If
                      fb = 2
                      If ct = 2 Then
                        'Last row for data is probably early.
                        fe = GetEndRowValue(sh, CCfg.ColumnIsData, "1", fb)
                      Else
                        'All entries valid except 'item'.
                        fe = GetEndRow(sh, CCfg.ColumnName, fb)
                      End If
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      tk.MatchFound = False
                      tk.RowEnd = fe
                      tk.TemplateValue = nv.Value
                      For fp = fb To fe
                        tk.RowIndex = fp
                        fc = fc & HtmlProcessDataEntryItem(tk)
'                        If (ct = 3 Or _
'                          ValueCellSheet(sh, CCfg.ColumnIsData, fp) = _
'                          "1") And _
'                          LCase(ValueCellSheet(sh, CCfg.ColumnSource, fp)) <> _
'                          "item" Then
'                          'Matching field. Run the template on these values.
'                          cv.SetMatches "{ifEditor", "False"
'                          cv.SetMatches "{ifFormat", "False"
'                          cv.SetValue "{ifFirst}", CStr(Not bf)
'                          cv.SetValue "{ifNotFirst}", CStr(bf)
'                          cv.SetValue "{ifLast}", CStr(fp >= fe)
'                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                          cv.SetValue "{ifReadOnly}", _
'                            CStr(IsFieldReadOnly(sh, fp))
'                          ws = ValueCellSheet(sh, CCfg.ColumnEditor, fp)
'                          If Len(ws) > 0 Then
'                            cv.SetValue "{ifEditor" & ws & "}", "True"
'                          End If
'                          bf = True
'                          UpdateFieldTags sh, fp, mv, fv
'                          ts = ResolveTags(nv.Value, fv)
'                          ts = ResolveParamTags(ts)
'                          ts = ResolveConditionTags(ts, cv)
'                          If Len(ts) > 0 Then
'                            fc = fc & ts & vbCrLf
'                          End If
'                        End If
                      Next fp
                    Case "edit":
                      'Component / Edit.
                      'Add editor fields in this component.
                      fb = 2
                      'Last row for edit is probably early.
                      fe = GetEndRowNonBlank(sh, CCfg.ColumnEditor, fb)
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      tk.MatchFound = False
                      tk.RowEnd = fe
                      tk.TemplateValue = nv.Value
                      For fp = fb To fe
                        tk.RowIndex = fp
                        fc = fc & HtmlProcessEditItem(tk)
'                        ws = ValueCellSheet(sh, CCfg.ColumnEditor, fp)
'                        If Len(ws) > 0 Then
'                          'Matching field. Run the template on these values.
'                          cv.SetMatches "{ifEditor", "False"
'                          cv.SetMatches "{ifFormat", "False"
'                          cv.SetValue "{ifFirst}", CStr(Not bf)
'                          cv.SetValue "{ifNotFirst}", CStr(bf)
'                          cv.SetValue "{ifLast}", CStr(fp >= fe)
'                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                          cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
'                          cv.SetValue "{ifEditor" & ws & "}", "True"
'                          bf = True
'                          UpdateFieldTags sh, fp, mv, fv
'                          ts = ResolveTags(nv.Value, fv)
'                          ts = ResolveParamTags(ts)
'                          ts = ResolveConditionTags(ts, cv)
'                          If Len(ts) > 0 Then
'                            fc = fc & ts & vbCrLf
'                          End If
'                        End If
                      Next fp
                    Case "gridcol":
                      'Component / Grid.
                      'Add grid column fields in this component.
                      'Non-default only.
                      fb = 2
                      'Last row for edit is probably early.
                      fe = GetEndRowNonBlank(sh, CCfg.ColumnGrid, fb)
                      cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
                      tk.MatchFound = False
                      tk.RowEnd = fe
                      tk.TemplateValue = nv.Value
                      For fp = fb To fe
                        tk.RowIndex = fp
                        fc = fc & HtmlProcessGridColItem(tk)
'                        If Len(ValueCellSheet(sh, CCfg.ColumnGrid, fp)) > 0 And _
'                          ValueCellSheet(sh, CCfg.ColumnIsDefault, fp) <> "1" Then
'                          'Matching field. Run the template on these values.
'                          cv.SetMatches "{ifEditor", "False"
'                          cv.SetMatches "{ifFormat", "False"
'                          cv.SetValue "{ifFirst}", CStr(Not bf)
'                          cv.SetValue "{ifNotFirst}", CStr(bf)
'                          cv.SetValue "{ifLast}", CStr(fp >= fe)
'                          cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                          cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
'                          ws = ValueCellSheet(sh, CCfg.ColumnGridFormat, fp)
'                          If Len(ws) > 0 Then
'                            cv.SetValue "{ifFormatGrid}", "True"
'                          End If
'                          bf = True
'                          UpdateFieldTags sh, fp, mv, fv
'                          ts = ResolveTags(nv.Value, fv)
'                          ts = ResolveParamTags(ts)
'                          ts = ResolveConditionTags(ts, cv)
'                          fc = fc & ts & vbCrLf
'                        End If
                      Next fp
                  End Select
                Else
                  'Normal line. Treat as component repeat.
                  'Check first to see if the line matches the condition.
                  if instr(tl, "condition(") > 0 then
                    'A row condition is being specified.
                    ws = trim(mid(ws, 11, len(ws) - 2))
                    pl = instr(ws, "[")
                    pr = instr(ws, "]")
                    if pl > 0 and pr > 0 then
                      ws = left(ws, pl - 1) & _
                        replace(mid(ws, pl, pr - pl), ",", ";") & _
                        right(ws, len(ws) - pr)
                    end if
                    sa = split(ws, ",");
                    if ubound(sa) > 0 then
                      sb = split(sa(1), ";")
                    Else
                      redim sb, 0
                      sb(0) = ""
                    end if
                    bv = false
                    vl = lcase(ResolveTags("{" & sa(0) & "}", fv))
                    pr = ubound(sb)
                    for pl = 0 to pr
                      vr = lcase(sb(pl))
                      if vr = vr then
                        bv = true
                        exit for
                      end if
                    next pl
                  end if
                  If(bv) Then
                    cv.SetMatches "{ifEditor", "False"
                    cv.SetMatches "{ifFormat", "False"
                    cv.SetValue "{ifFieldCountGT0}", _
                      CStr(GetEndRow(sh, CCfg.ColumnName, 3) > 0)
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
                End If
              Next mp
            Next cp
            'Done processing for entire group.
            Exit For
          Case 2, 3: 'Data, Entry.
            'Standalone Data.
            'Standalone Entry.
            'List all fields in every component.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              Set tk.Sheet = sh
              UpdateComponentTags sh, mv
              fb = 2
              If ct = 2 Then
                'Last row for data is probably early.
                fe = GetEndRowValue(sh, CCfg.ColumnIsData, "1", fb)
              Else
                'All entries valid except 'item'.
                fe = GetEndRow(sh, CCfg.ColumnName, fb)
              End If
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              tk.MatchFound = False
              tk.RowEnd = fe
              tk.TemplateValue = nv.Value
              For fp = fb To fe
                tk.RowIndex = fp
                fc = fc & HtmlProcessDataEntryItem(tk)
'                If (ct = 3 Or ValueCellSheet(sh, CCfg.ColumnIsData, fp) = "1") And _
'                  LCase(ValueCellSheet(sh, CCfg.ColumnSource, fp)) <> "item" Then
'                  'Matching field. Run the template on these values.
'                  cv.SetMatches "{ifEditor", "False"
'                  cv.SetValue "{ifFirst}", CStr(Not bf)
'                  cv.SetValue "{ifNotFirst}", CStr(bf)
'                  cv.SetValue "{ifLast}", CStr(fp >= fe)
'                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
'                  ws = ValueCellSheet(sh, CCfg.ColumnEditor, fp)
'                  If Len(ws) > 0 Then
'                    cv.SetValue "{ifEditor" & ws & "}", "True"
'                  End If
'                  bf = True
'                  UpdateFieldTags sh, fp, mv, fv
'                  ts = ResolveTags(nv.Value, fv)
'                  ts = ResolveParamTags(ts)
'                  ts = ResolveConditionTags(ts, cv)
'                  If Len(ts) > 0 Then
'                    fc = fc & ts & vbCrLf
'                  End If
'                End If
              Next fp
            Next cp
          Case 4: 'Edit.
            'Standalone Edit.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              Set tk.Sheet = sh
              UpdateComponentTags sh, mv
              fb = 2
              'Last row for edit is probably early.
              fe = GetEndRowNonBlank(sh, CCfg.ColumnEditor, fb)
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              tk.MatchFound = False
              tk.RowEnd = fe
              tk.TemplateValue = nv.Value
              For fp = fb To fe
                tk.RowIndex = fp
                fc = fc & HtmlProcessEditItem(tk)
'                ws = ValueCellSheet(sh, CCfg.ColumnEditor, fp)
'                If Len(ws) > 0 Then
'                  'Matching field. Run the template on these values.
'                  cv.SetMatches "{ifEditor", "False"
'                  cv.SetValue "{ifFirst}", CStr(Not bf)
'                  cv.SetValue "{ifNotFirst}", CStr(bf)
'                  cv.SetValue "{ifLast}", CStr(fp >= fe)
'                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
'                  cv.SetValue "{ifEditor" & ws & "}", "True"
'                  bf = True
'                  UpdateFieldTags sh, fp, mv, fv
'                  ts = ResolveTags(nv.Value, fv)
'                  ts = ResolveParamTags(ts)
'                  ts = ResolveConditionTags(ts, cv)
'                  If Len(ts) > 0 Then
'                    fc = fc & ts & vbCrLf
'                  End If
'                End If
              Next fp
            Next cp
          Case 5: 'GridCol.
            'Standalone Grid.
            'Non-default grid columns only.
            For cp = 0 To cc - 1
              'Select the component sheet.
              Set sh = Sheets(ca(cp))
              Set tk.Sheet = sh
              UpdateComponentTags sh, mv
              fb = 2
              'Last row for edit is probably early.
              fe = GetEndRowNonBlank(sh, CCfg.ColumnGrid, fb)
              cv.SetValue "{ifFieldCountGT0}", CStr(fe > 0)
              tk.MatchFound = False
              tk.RowEnd = fe
              tk.TemplateValue = nv.Value
              For fp = fb To fe
                tk.RowIndex = fp
                fc = fc & HtmlProcessGridColItem(tk)
'                If Len(ValueCellSheet(sh, CCfg.ColumnGrid, fp)) > 0 And _
'                  ValueCellSheet(sh, CCfg.ColumnIsDefault, fp) <> "1" Then
'                  'Matching field. Run the template on these values.
'                  cv.SetMatches "{ifEditor", "False"
'                  cv.SetMatches "{ifFormat", "False"
'                  cv.SetValue "{ifFirst}", CStr(Not bf)
'                  cv.SetValue "{ifNotFirst}", CStr(bf)
'                  cv.SetValue "{ifLast}", CStr(fp >= fe)
'                  cv.SetValue "{ifNotLast}", CStr(fp < fe)
'                  cv.SetValue "{ifReadOnly}", CStr(IsFieldReadOnly(sh, fp))
'                  ws = ValueCellSheet(sh, CCfg.ColumnGridFormat, fp)
'                  If Len(ws) > 0 Then
'                    cv.SetValue "{ifFormatGrid}", "True"
'                  End If
'                  bf = True
'                  UpdateFieldTags sh, fp, mv, fv
'                  ts = ResolveTags(nv.Value, fv)
'                  ts = ResolveParamTags(ts)
'                  ts = ResolveConditionTags(ts, cv)
'                  fc = fc & ts & vbCrLf
'                End If
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

Private Function HtmlProcessDataEntryItem(token As FieldTokenItem) As String
'Process a single Data or Entry Item on the Html Template.
Dim rv As String    'Return Value.
Dim ws As String    'Working String.

  rv = ""
  If (token.ComponentType = 3 Or _
    ValueCellSheet(token.Sheet, CCfg.ColumnIsData, token.RowIndex) = "1") And _
    LCase(ValueCellSheet(token.Sheet, CCfg.ColumnSource, _
    token.RowIndex)) <> "item" Then
    'Matching field. Run the template on these values.
    token.CompareValues.SetMatches "{ifEditor", "False"
    token.CompareValues.SetMatches "{ifFormat", "False"
    token.CompareValues.SetValue "{ifFirst}", CStr(Not token.MatchFound)
    token.CompareValues.SetValue "{ifNotFirst}", CStr(token.MatchFound)
    token.CompareValues.SetValue "{ifLast}", _
      CStr(token.RowIndex >= token.RowEnd)
    token.CompareValues.SetValue "{ifNotLast}", _
      CStr(token.RowIndex < token.RowEnd)
    token.CompareValues.SetValue "{ifReadOnly}", _
      CStr(IsFieldReadOnly(token.Sheet, token.RowIndex))
    ws = ValueCellSheet(token.Sheet, CCfg.ColumnEditor, token.RowIndex)
    If Len(ws) > 0 Then
      token.CompareValues.SetValue "{ifEditor" & ws & "}", "True"
    End If
    token.MatchFound = True
    UpdateFieldTags token.Sheet, token.RowIndex, _
      token.ComponentValues, token.FieldValues
    ws = ResolveTags(token.TemplateValue, token.FieldValues)
    ws = ResolveParamTags(ws)
    ws = ResolveConditionTags(ws, token.CompareValues)
    If Len(ws) > 0 Then
      rv = ws & vbCrLf
    End If
  End If
  HtmlProcessDataEntryItem = rv

End Function

Private Function HtmlProcessEditItem(token As FieldTokenItem) As String
'Process a single Edit Item on the Html Template.
Dim rv As String    'Return Value.
Dim ws As String    'Working String.

  rv = ""
  ws = ValueCellSheet(token.Sheet, CCfg.ColumnEditor, token.RowIndex)
  If Len(ws) > 0 Then
    'Matching field. Run the template on these values.
    token.CompareValues.SetMatches "{ifEditor", "False"
    token.CompareValues.SetMatches "{ifFormat", "False"
    token.CompareValues.SetValue "{ifFirst}", CStr(Not token.MatchFound)
    token.CompareValues.SetValue "{ifNotFirst}", CStr(token.MatchFound)
    token.CompareValues.SetValue "{ifLast}", _
      CStr(token.RowIndex >= token.RowEnd)
    token.CompareValues.SetValue "{ifNotLast}", _
      CStr(token.RowIndex < token.RowEnd)
    token.CompareValues.SetValue "{ifReadOnly}", _
      CStr(IsFieldReadOnly(token.Sheet, token.RowIndex))
    token.CompareValues.SetValue "{ifEditor" & ws & "}", "True"
    token.MatchFound = True
    UpdateFieldTags token.Sheet, token.RowIndex, _
      token.ComponentValues, token.FieldValues
    ws = ResolveTags(token.TemplateValue, token.FieldValues)
    ws = ResolveParamTags(ws)
    ws = ResolveConditionTags(ws, token.CompareValues)
    If Len(ws) > 0 Then
      rv = ws & vbCrLf
    End If
  End If

  HtmlProcessEditItem = rv

End Function

Private Function HtmlProcessGridColItem(token As FieldTokenItem) As String
'Process a single Grid Column Item on the Html Template.
Dim rv As String    'Return Value.
Dim ws As String    'Working String.

  rv = ""
  If Len(ValueCellSheet(token.Sheet, CCfg.ColumnGrid, _
    token.RowIndex)) > 0 And _
    ValueCellSheet(token.Sheet, CCfg.ColumnIsDefault, _
    token.RowIndex) <> "1" Then
    'Matching field. Run the template on these values.
    token.CompareValues.SetMatches "{ifEditor", "False"
    token.CompareValues.SetMatches "{ifFormat", "False"
    token.CompareValues.SetValue "{ifFirst}", CStr(Not token.MatchFound)
    token.CompareValues.SetValue "{ifNotFirst}", CStr(token.MatchFound)
    token.CompareValues.SetValue "{ifLast}", _
      CStr(token.RowIndex >= token.RowEnd)
    token.CompareValues.SetValue "{ifNotLast}", _
      CStr(token.RowIndex < token.RowEnd)
    token.CompareValues.SetValue "{ifReadOnly}", _
      CStr(IsFieldReadOnly(token.Sheet, token.RowIndex))
    ws = ValueCellSheet(token.Sheet, CCfg.ColumnGridFormat, _
      token.RowIndex)
    If Len(ws) > 0 Then
      'Grid format has been specified.
      token.CompareValues.SetValue "{ifFormatGrid}", "True"
    End If
    UpdateFieldTags token.Sheet, token.RowIndex, _
      token.ComponentValues, token.FieldValues
    ws = ResolveTags(token.TemplateValue, token.FieldValues)
    ws = ResolveParamTags(ws)
    ws = ResolveConditionTags(ws, token.CompareValues)
    If Len(ws) > 0 Then
      rv = ws & vbCrLf
    End If
  End If

  HtmlProcessGridColItem = rv

End Function

Private Function IsComponentReadOnly(Sheet As Worksheet) As Boolean
'Return a value indicating whether the specified component is read only.
Dim lp As Integer   'List Position.
Dim rv As Boolean   'Return Value.

  lp = GetItemRow(Sheet)
  If lp > 0 Then
    rv = (ValueCellSheet(Sheet, CCfg.ColumnReadOnly, lp) = "1")
  End If
  IsComponentReadOnly = rv

End Function

Private Function IsFieldReadOnly(Sheet As Worksheet, Index As Integer) As Boolean
'Return a value indicating whether the specified field is read only.
Dim lp As Integer   'List Position.
Dim rv As Boolean   'Return Value.

  If Index > 0 Then
    rv = (ValueCellSheet(Sheet, CCfg.ColumnReadOnly, Index) = "1")
  End If
  IsFieldReadOnly = rv

End Function

Private Function NameValues(ColumnIndex As Integer, currentRow As Integer) As String
'Return the string of Name/Value pairs starting at the specified column index.
Dim cp As Long      'Column Position.
Dim nm As String    'Name/Value Name.
Dim nv As String    'Name/Value Value.
Dim rv As String    'Return Value.

  rv = ""
  If ColumnIndex > 0 And currentRow > 0 Then
    cp = ColumnIndex
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
Dim le As Integer     'List End.
Dim lp As Integer     'List Position.
Dim ni As NameValueItem
Dim rl As Integer     'Return Value Length.
Dim rv As String      'Return Value.
Dim sl As String      'Left String.
Dim sr As String      'Right String.
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
    'The inline backreference replacement to nothing is not
    ' working on this version of VBScript
'    ws = "\{if([^\}]*)\}(.*)\{/if\1\}"
'    rv = Replace(RegExReplace(Replace(rv, vbCrLf, "%^"), ws, ""), "%^", vbCrLf)
    'Work-around. Manually check for and remove
    ' all conditional braces still existing on the string.
    'The following can be compressed, but provides detail for debugging.
    'lp reassigned to character position.
    'lc reassigned to count of characters.
    lp = InStr(rv, "{if")
    le = FindClosingElementEnd(rv, lp)
    sl = ""
    sr = ""
    rl = Len(rv)
    If le > 0 Then
      'Starting and ending characters found. Remove.
      If lp > 1 Then
        sl = Left(rv, lp - 1)
      End If
      If rl > le Then
        sr = Right(rv, rl - le)
      End If
      rv = sl & sr
    End If
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
Dim ab As String    'Abbreviation.
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
    ab = ValueCellSheet(Sheet, CCfg.ColumnAbbrev3, 2)
    List.AddValue "{Abbrev3}", ab
    List.AddValue "{LAbbrev3}", LCase(ab)
    'Name of the Default Text Field.
    List.AddValue "{DefaultFieldName}", GetDefaultFieldName(Sheet)
    'Label of the Default Text Field.
    List.AddValue "{DefaultFieldDisplayName}", GetDefaultFieldDisplayName(Sheet)
    'Name of the Identification Field.
    List.AddValue "{IDFieldName}", GetIDFieldName(Sheet)
  End If

End Sub

Private Sub UpdateFieldTags(Sheet As Worksheet, Index As Integer, _
  ComponentTags As NameValueCollection, _
  FieldTags As NameValueCollection)
'Update the list of tags for the specified field.
Dim na As String    'Field Name.
Dim rs As String    'Replacement String.
Dim ws As String    'Working String.

  FieldTags.Clear
  FieldTags.AddRange ComponentTags
  FieldTags.AddValue "{FieldAlias}", _
    ValueCellSheet(Sheet, CCfg.ColumnAlias, Index)
  FieldTags.AddValue "{FieldDataType}", _
    ValueCellSheet(Sheet, CCfg.ColumnDataType, Index)
  FieldTags.AddValue "{FieldDefaultValue}", _
    ValueCellSheet(Sheet, CCfg.ColumnDefaultValue, Index)
  FieldTags.AddValue "{FieldDescription}", _
    ValueCellSheet(Sheet, CCfg.ColumnDescription, Index)
  FieldTags.AddValue "{FieldDisplayName}", _
    ValueCellSheet(Sheet, CCfg.ColumnDisplay, Index)
  FieldTags.AddValue "{FieldEditorName}", _
    ValueCellSheet(Sheet, CCfg.ColumnEditor, Index)
  FieldTags.AddValue "{FieldGrid}", _
    ValueCellSheet(Sheet, CCfg.ColumnGrid, Index)
  FieldTags.AddValue "{FieldIsData}", _
    ValueCellSheet(Sheet, CCfg.ColumnIsData, Index)
  FieldTags.AddValue "{FieldIsDefault}", _
    ValueCellSheet(Sheet, CCfg.ColumnIsDefault, Index)
  FieldTags.AddValue "{FieldKeyName}", _
    ValueCellSheet(Sheet, CCfg.ColumnKeyName, Index)
  FieldTags.AddValue "{FieldKeyValue}", _
    ValueCellSheet(Sheet, CCfg.ColumnKeyValue, Index)
  FieldTags.AddValue "{FieldLength}", _
    ValueCellSheet(Sheet, CCfg.ColumnLength, Index)
  FieldTags.AddValue "{FieldName}", _
    ValueCellSheet(Sheet, CCfg.ColumnName, Index)
  FieldTags.AddValue "{FieldNative}", _
    ValueCellSheet(Sheet, CCfg.ColumnIsData, Index)
  FieldTags.AddValue "{FieldOverride}", _
    ValueCellSheet(Sheet, CCfg.ColumnOverride, Index)
  FieldTags.AddValue "{FieldReadOnly}", _
    ValueCellSheet(Sheet, CCfg.ColumnReadOnly, Index)
  FieldTags.AddValue "{FieldSelect}", _
    Replace(ValueCellSheet(Sheet, CCfg.ColumnSelect, Index), """", "\""")
  FieldTags.AddValue "{FieldSource}", _
    ValueCellSheet(Sheet, CCfg.ColumnSource, Index)
  FieldTags.AddValue "{FieldSQLType}", _
    GetScalarType(ValueCellSheet(Sheet, CCfg.ColumnDataType, Index))
  FieldTags.AddValue "{FieldTable}", _
    ValueCellSheet(Sheet, CCfg.ColumnTable, Index)
  FieldTags.AddValue "{FieldUIDisplay}", _
    ValueCellSheet(Sheet, CCfg.ColumnUIDisplay, Index)
  FieldTags.AddValue "{FieldUIKey}", _
    ValueCellSheet(Sheet, CCfg.ColumnUIKey, Index)
  FieldTags.AddValue "{FieldUISource}", _
    ValueCellSheet(Sheet, CCfg.ColumnUISource, Index)
  FieldTags.AddValue "{FieldUIUpdate}", _
    ValueCellSheet(Sheet, CCfg.ColumnUIUpdate, Index)
  FieldTags.AddValue "{FieldUIValue}", _
    ValueCellSheet(Sheet, CCfg.ColumnUIValue, Index)
  'When defined at the end, the member may refer to other field tags.
  ws = ValueCellSheet(Sheet, CCfg.ColumnEditorFormat, Index)
  'This item may refer to its own field.
  FieldTags.AddValue "{FieldEditorFormat}", ws
  If Len(ws) > 0 Then
    rs = GetConfigValue("FormatEditor." & ws)
    If Len(rs) > 0 Then
      'A replacement is available.
      ws = ResolveTags(rs, FieldTags)
    End If
  End If
  FieldTags.SetValue "{FieldEditorFormat}", ws
  ws = ValueCellSheet(Sheet, CCfg.ColumnGridFormat, Index)
  'This item may refer to its own field.
  FieldTags.AddValue "{FieldGridFormat}", ws
  If Len(ws) > 0 Then
    rs = GetConfigValue("FormatGrid." & ws)
    If Len(rs) > 0 Then
      'A replacement is available.
      ws = ResolveTags(rs, FieldTags)
    End If
  End If
  FieldTags.SetValue "{FieldGridFormat}", ws
  


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




