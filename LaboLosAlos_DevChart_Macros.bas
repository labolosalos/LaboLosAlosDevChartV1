
Option Explicit

' ═══════════════════════════════════════════════════════════════
' Dev Chart by Labo Los Alos 2026
' VBA de cascada: Película → Revelador → Dilución → Resultado
' ═══════════════════════════════════════════════════════════════

Private bUpdating As Boolean

' ─── Inicialización ──────────────────────────────────────────
Private Sub Workbook_Open()
    bUpdating = False
    PopulateFilms
    Call UpdateAll
End Sub

' ─── Llenar combo de películas al abrir ──────────────────────
Sub PopulateFilms()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("🎞 Dev Chart")
    
    Dim aFilms As Variant
    aFilms = Array("Adox CHS 100 II", "Adox Silvermax 100", "Bergger Pancro 400", "CineStill BwXX", "Ferrania P30", "Foma Retropan 320", "Fomapan 100", "Fomapan 200", "Fomapan 400", "Fuji Neopan Acros 100 II", "Ilford Delta 100", "Ilford Delta 3200", "Ilford Delta 400", "Ilford FP4 Plus", "Ilford HP5 Plus", "Ilford Kentmere 100", "Ilford Kentmere 400", "Ilford Pan F Plus", "Ilford SFX 200", "JCH Streetpan 400", "Kodak Double-X 5222", "Kodak Plus-X 125", "Kodak T-MAX 100", "Kodak T-MAX 400", "Kodak Tri-X 400", "Kosmo Foto Mono 100", "Lomo Babylon Kino 13", "Lomo Berlin Kino 400", "Lomo Earl Grey 100", "Lomo Fantome Kino 8", "Lomo Lady Grey 400", "Lomo Potsdam Kino 100", "Rollei RPX 100", "Rollei RPX 400")
    
    With ws.Range("C11").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:=Join(aFilms, ",")
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = False
        .ShowError = False
    End With
End Sub

' ─── Cuando cambia cualquier celda ───────────────────────────
Private Sub Workbook_SheetChange(ByVal Sh As Object, ByVal Target As Range)
    If bUpdating Then Exit Sub
    If Sh.Name <> "🎞 Dev Chart" Then Exit Sub
    
    bUpdating = True
    On Error GoTo CleanUp
    
    If Not Intersect(Target, Sh.Range("C11")) Is Nothing Then
        ' Cambió la película
        Call UpdateDevs(Sh)
        Call ClearCell(Sh, "C14")
        Call ClearCell(Sh, "C17")
    ElseIf Not Intersect(Target, Sh.Range("C14")) Is Nothing Then
        ' Cambió el revelador
        Call UpdateDils(Sh)
        Call ClearCell(Sh, "C17")
    End If
    
CleanUp:
    bUpdating = False
End Sub

' ─── Limpiar celda con placeholder ───────────────────────────
Sub ClearCell(ws As Worksheet, addr As String)
    ws.Range(addr).ClearContents
End Sub

' ─── Actualizar lista de reveladores según película ──────────
Sub UpdateDevs(ws As Worksheet)
    Dim sFilm As String
    sFilm = ws.Range("C11").Value
    If sFilm = "" Then Exit Sub
    
    Dim aDevs As Variant
    
    Select Case sFilm
        Case "Adox CHS 100 II": aDevs = Array("Adox Adonal", "D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "XTOL")
        Case "Adox Silvermax 100": aDevs = Array("Adox Silvermax Dev", "D-76", "Rodinal", "Romek PQ7", "Romek R09")
        Case "Bergger Pancro 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "XTOL")
        Case "CineStill BwXX": aDevs = Array("D-76", "HC-110", "Rodinal", "Romek R09")
        Case "Ferrania P30": aDevs = Array("D-76", "HC-110", "Rodinal", "Romek R09")
        Case "Foma Retropan 320": aDevs = Array("D-76", "Foma Retro Special Dev", "HC-110", "Ilfotec LC29", "Microphen", "Rodinal", "Romek R09")
        Case "Fomapan 100": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Rodinal", "Romek PQ7", "Romek R09", "XTOL")
        Case "Fomapan 200": aDevs = Array("D-76", "HC-110", "Rodinal", "Romek PQ7", "Romek R09")
        Case "Fomapan 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "XTOL")
        Case "Fuji Neopan Acros 100 II": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "XTOL")
        Case "Ilford Delta 100": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microdol-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Ilford Delta 3200": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Microdol-X", "Microphen", "Romek PQ7", "T-MAX Dev")
        Case "Ilford Delta 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microdol-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Ilford FP4 Plus": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microdol-X", "Microphen", "Perceptol", "Rodinal", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Ilford HP5 Plus": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microdol-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Ilford Kentmere 100": aDevs = Array("D-76", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09")
        Case "Ilford Kentmere 400": aDevs = Array("D-76", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microphen", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09")
        Case "Ilford Pan F Plus": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Microdol-X", "Microphen", "Perceptol", "Rodinal", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Ilford SFX 200": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "T-MAX Dev")
        Case "JCH Streetpan 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "T-MAX Dev", "XTOL")
        Case "Kodak Double-X 5222": aDevs = Array("D-76", "D-96", "HC-110", "ID-11", "Ilfosol 3", "Microphen", "Rodinal", "Romek R09", "XTOL")
        Case "Kodak Plus-X 125": aDevs = Array("D-76", "HC-110", "Microdol-X", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Kodak T-MAX 100": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfotec HC", "Microdol-X", "Rodinal", "Romek PQ7", "T-MAX RS", "XTOL")
        Case "Kodak T-MAX 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfotec HC", "Microdol-X", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "T-MAX RS", "XTOL")
        Case "Kodak Tri-X 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfotec HC", "Microdol-X", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "T-MAX RS", "XTOL")
        Case "Kosmo Foto Mono 100": aDevs = Array("D-76", "ID-11", "Ilfotec DD-X", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "T-MAX Dev", "XTOL")
        Case "Lomo Babylon Kino 13": aDevs = Array("D-76", "HC-110", "Ilfotec HC")
        Case "Lomo Berlin Kino 400": aDevs = Array("D-76", "HC-110", "Ilfosol 3", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "XTOL")
        Case "Lomo Earl Grey 100": aDevs = Array("D-76", "HC-110", "Ilfosol 3", "Rodinal", "Romek PQ7", "Romek R09")
        Case "Lomo Fantome Kino 8": aDevs = Array("D-96", "HC-110", "Ilfosol 3", "Ilfotec HC", "Rodinal", "Romek R09")
        Case "Lomo Lady Grey 400": aDevs = Array("D-23", "D-76", "HC-110", "Microphen", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "T-MAX Dev", "T-MAX RS", "XTOL")
        Case "Lomo Potsdam Kino 100": aDevs = Array("D-76", "HC-110", "Ilfosol 3", "Rodinal", "Romek PQ7", "Romek R09", "T-MAX Dev")
        Case "Rollei RPX 100": aDevs = Array("D-76", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec LC29", "Microphen", "Perceptol", "Rodinal", "Romek PQ7", "Romek R09", "XTOL")
        Case "Rollei RPX 400": aDevs = Array("D-76", "HC-110", "ID-11", "Ilfosol 3", "Ilfotec DD-X", "Ilfotec LC29", "Microphen", "Perceptol", "Rodinal", "Romek PQ6", "Romek PQ7", "Romek PQ9", "Romek R09", "XTOL")
        Case Else: aDevs = Array("")
    End Select
    
    With ws.Range("C14").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:=Join(aDevs, ",")
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = False
        .ShowError = False
    End With
    
    ' Auto-seleccionar si hay un solo revelador
    If UBound(aDevs) = 0 Then
        ws.Range("C14").Value = aDevs(0)
        Call UpdateDils(ws)
    End If
End Sub

' ─── Actualizar lista de diluciones según película+revelador ─
Sub UpdateDils(ws As Worksheet)
    Dim sFilm As String, sDev As String, sKey As String
    sFilm = ws.Range("C11").Value
    sDev  = ws.Range("C14").Value
    If sFilm = "" Or sDev = "" Then Exit Sub
    sKey = sFilm & "||" & sDev
    
    Dim aDils As Variant
    
    Select Case sKey
        Case "Adox CHS 100 II||Adox Adonal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Adox CHS 100 II||D-76": aDils = Array("Stock")
        Case "Adox CHS 100 II||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Adox CHS 100 II||ID-11": aDils = Array("Stock")
        Case "Adox CHS 100 II||Ilfosol 3": aDils = Array("1+9")
        Case "Adox CHS 100 II||Ilfotec DD-X": aDils = Array("1+4")
        Case "Adox CHS 100 II||Microphen": aDils = Array("Stock")
        Case "Adox CHS 100 II||Perceptol": aDils = Array("Stock")
        Case "Adox CHS 100 II||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Adox CHS 100 II||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Adox CHS 100 II||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Adox CHS 100 II||XTOL": aDils = Array("Stock")
        Case "Adox Silvermax 100||Adox Silvermax Dev": aDils = Array("1+29")
        Case "Adox Silvermax 100||D-76": aDils = Array("Stock")
        Case "Adox Silvermax 100||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Adox Silvermax 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Adox Silvermax 100||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Bergger Pancro 400||D-76": aDils = Array("Stock", "1+1")
        Case "Bergger Pancro 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Bergger Pancro 400||ID-11": aDils = Array("Stock", "1+1")
        Case "Bergger Pancro 400||Ilfosol 3": aDils = Array("1+9")
        Case "Bergger Pancro 400||Ilfotec DD-X": aDils = Array("1+4")
        Case "Bergger Pancro 400||Microphen": aDils = Array("Stock", "1+1")
        Case "Bergger Pancro 400||Perceptol": aDils = Array("1+1")
        Case "Bergger Pancro 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Bergger Pancro 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Bergger Pancro 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Bergger Pancro 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Bergger Pancro 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Bergger Pancro 400||XTOL": aDils = Array("Stock", "1+1")
        Case "CineStill BwXX||D-76": aDils = Array("Stock")
        Case "CineStill BwXX||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "CineStill BwXX||Rodinal": aDils = Array("1+25")
        Case "CineStill BwXX||Romek R09": aDils = Array("1+25")
        Case "Ferrania P30||D-76": aDils = Array("Stock")
        Case "Ferrania P30||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ferrania P30||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Ferrania P30||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Foma Retropan 320||D-76": aDils = Array("Stock")
        Case "Foma Retropan 320||Foma Retro Special Dev": aDils = Array("Stock")
        Case "Foma Retropan 320||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Foma Retropan 320||Ilfotec LC29": aDils = Array("1+29")
        Case "Foma Retropan 320||Microphen": aDils = Array("Stock")
        Case "Foma Retropan 320||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Foma Retropan 320||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Fomapan 100||D-76": aDils = Array("Stock", "1+1")
        Case "Fomapan 100||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Fomapan 100||ID-11": aDils = Array("Stock", "1+1")
        Case "Fomapan 100||Ilfosol 3": aDils = Array("1+9")
        Case "Fomapan 100||Ilfotec DD-X": aDils = Array("1+4")
        Case "Fomapan 100||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Fomapan 100||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Fomapan 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Fomapan 100||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Fomapan 100||XTOL": aDils = Array("Stock")
        Case "Fomapan 200||D-76": aDils = Array("Stock")
        Case "Fomapan 200||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Fomapan 200||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Fomapan 200||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Fomapan 200||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Fomapan 400||D-76": aDils = Array("Stock", "1+1")
        Case "Fomapan 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Fomapan 400||ID-11": aDils = Array("Stock", "1+1")
        Case "Fomapan 400||Ilfosol 3": aDils = Array("1+9")
        Case "Fomapan 400||Ilfotec DD-X": aDils = Array("1+4")
        Case "Fomapan 400||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Fomapan 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Fomapan 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Fomapan 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Fomapan 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Fomapan 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Fomapan 400||XTOL": aDils = Array("Stock")
        Case "Fuji Neopan Acros 100 II||D-76": aDils = Array("Stock", "1+1")
        Case "Fuji Neopan Acros 100 II||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Fuji Neopan Acros 100 II||ID-11": aDils = Array("Stock")
        Case "Fuji Neopan Acros 100 II||Ilfosol 3": aDils = Array("1+9")
        Case "Fuji Neopan Acros 100 II||Ilfotec DD-X": aDils = Array("1+4")
        Case "Fuji Neopan Acros 100 II||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Fuji Neopan Acros 100 II||Microphen": aDils = Array("Stock")
        Case "Fuji Neopan Acros 100 II||Perceptol": aDils = Array("Stock")
        Case "Fuji Neopan Acros 100 II||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Fuji Neopan Acros 100 II||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Fuji Neopan Acros 100 II||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Fuji Neopan Acros 100 II||XTOL": aDils = Array("Stock")
        Case "Ilford Delta 100||D-76": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 100||HC-110": aDils = Array("Dil. B (1+31)", "Dil. A (1+15)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford Delta 100||ID-11": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 100||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford Delta 100||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Delta 100||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford Delta 100||Ilfotec LC29": aDils = Array("1+19")
        Case "Ilford Delta 100||Microdol-X": aDils = Array("Stock", "1+3")
        Case "Ilford Delta 100||Microphen": aDils = Array("Stock")
        Case "Ilford Delta 100||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 100||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford Delta 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford Delta 100||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford Delta 100||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford Delta 100||T-MAX RS": aDils = Array("1+4")
        Case "Ilford Delta 100||XTOL": aDils = Array("Stock")
        Case "Ilford Delta 3200||D-76": aDils = Array("Stock")
        Case "Ilford Delta 3200||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford Delta 3200||ID-11": aDils = Array("Stock")
        Case "Ilford Delta 3200||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford Delta 3200||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Delta 3200||Microdol-X": aDils = Array("Stock")
        Case "Ilford Delta 3200||Microphen": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 3200||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford Delta 3200||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford Delta 400||D-76": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. A (1+15)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford Delta 400||ID-11": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 400||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford Delta 400||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Delta 400||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford Delta 400||Ilfotec LC29": aDils = Array("1+9", "1+19")
        Case "Ilford Delta 400||Microdol-X": aDils = Array("Stock")
        Case "Ilford Delta 400||Microphen": aDils = Array("Stock")
        Case "Ilford Delta 400||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford Delta 400||Rodinal": aDils = Array("1+25")
        Case "Ilford Delta 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Ilford Delta 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford Delta 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Ilford Delta 400||Romek R09": aDils = Array("1+25")
        Case "Ilford Delta 400||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford Delta 400||T-MAX RS": aDils = Array("1+4")
        Case "Ilford Delta 400||XTOL": aDils = Array("Stock")
        Case "Ilford FP4 Plus||D-76": aDils = Array("Stock")
        Case "Ilford FP4 Plus||HC-110": aDils = Array("Dil. B (1+31)", "Dil. A (1+15)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford FP4 Plus||ID-11": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford FP4 Plus||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford FP4 Plus||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford FP4 Plus||Ilfotec HC": aDils = Array("1+15 (Dil.A)", "1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford FP4 Plus||Ilfotec LC29": aDils = Array("1+19")
        Case "Ilford FP4 Plus||Microdol-X": aDils = Array("Stock", "1+3")
        Case "Ilford FP4 Plus||Microphen": aDils = Array("Stock", "1+1")
        Case "Ilford FP4 Plus||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford FP4 Plus||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford FP4 Plus||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford FP4 Plus||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford FP4 Plus||T-MAX RS": aDils = Array("1+4")
        Case "Ilford FP4 Plus||XTOL": aDils = Array("Stock", "1+1")
        Case "Ilford HP5 Plus||D-76": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford HP5 Plus||HC-110": aDils = Array("Dil. B (1+31)", "Dil. A (1+15)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford HP5 Plus||ID-11": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford HP5 Plus||Ilfosol 3": aDils = Array("1+9", "1+14")
        Case "Ilford HP5 Plus||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford HP5 Plus||Ilfotec HC": aDils = Array("1+15 (Dil.A)", "1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford HP5 Plus||Ilfotec LC29": aDils = Array("1+19", "1+29")
        Case "Ilford HP5 Plus||Microdol-X": aDils = Array("Stock")
        Case "Ilford HP5 Plus||Microphen": aDils = Array("Stock", "1+1")
        Case "Ilford HP5 Plus||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford HP5 Plus||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford HP5 Plus||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Ilford HP5 Plus||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford HP5 Plus||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Ilford HP5 Plus||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford HP5 Plus||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford HP5 Plus||T-MAX RS": aDils = Array("1+4")
        Case "Ilford HP5 Plus||XTOL": aDils = Array("Stock", "1+1")
        Case "Ilford Kentmere 100||D-76": aDils = Array("1+1", "1+3")
        Case "Ilford Kentmere 100||ID-11": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford Kentmere 100||Ilfosol 3": aDils = Array("1+9", "1+14")
        Case "Ilford Kentmere 100||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Kentmere 100||Ilfotec HC": aDils = Array("1+15 (Dil.A)", "1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford Kentmere 100||Ilfotec LC29": aDils = Array("1+9", "1+19", "1+29")
        Case "Ilford Kentmere 100||Microphen": aDils = Array("Stock", "1+1")
        Case "Ilford Kentmere 100||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford Kentmere 100||Rodinal": aDils = Array("1+25")
        Case "Ilford Kentmere 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford Kentmere 100||Romek R09": aDils = Array("1+25")
        Case "Ilford Kentmere 400||D-76": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford Kentmere 400||ID-11": aDils = Array("Stock", "1+1", "1+3")
        Case "Ilford Kentmere 400||Ilfosol 3": aDils = Array("1+9", "1+14")
        Case "Ilford Kentmere 400||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Kentmere 400||Ilfotec HC": aDils = Array("1+15 (Dil.A)", "1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford Kentmere 400||Ilfotec LC29": aDils = Array("1+9", "1+19", "1+29")
        Case "Ilford Kentmere 400||Microphen": aDils = Array("Stock", "1+1")
        Case "Ilford Kentmere 400||Perceptol": aDils = Array("1+1")
        Case "Ilford Kentmere 400||Rodinal": aDils = Array("1+25")
        Case "Ilford Kentmere 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Ilford Kentmere 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford Kentmere 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Ilford Kentmere 400||Romek R09": aDils = Array("1+25")
        Case "Ilford Pan F Plus||D-76": aDils = Array("Stock", "1+1")
        Case "Ilford Pan F Plus||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford Pan F Plus||ID-11": aDils = Array("Stock", "1+1")
        Case "Ilford Pan F Plus||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford Pan F Plus||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford Pan F Plus||Microdol-X": aDils = Array("Stock")
        Case "Ilford Pan F Plus||Microphen": aDils = Array("Stock")
        Case "Ilford Pan F Plus||Perceptol": aDils = Array("Stock", "1+1")
        Case "Ilford Pan F Plus||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford Pan F Plus||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Ilford Pan F Plus||T-MAX Dev": aDils = Array("1+4")
        Case "Ilford Pan F Plus||T-MAX RS": aDils = Array("1+4")
        Case "Ilford Pan F Plus||XTOL": aDils = Array("Stock")
        Case "Ilford SFX 200||D-76": aDils = Array("Stock", "1+1")
        Case "Ilford SFX 200||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Ilford SFX 200||ID-11": aDils = Array("Stock", "1+1")
        Case "Ilford SFX 200||Ilfosol 3": aDils = Array("1+9")
        Case "Ilford SFX 200||Ilfotec DD-X": aDils = Array("1+4")
        Case "Ilford SFX 200||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Ilford SFX 200||Ilfotec LC29": aDils = Array("1+19")
        Case "Ilford SFX 200||Microphen": aDils = Array("Stock")
        Case "Ilford SFX 200||Perceptol": aDils = Array("Stock")
        Case "Ilford SFX 200||Rodinal": aDils = Array("1+25")
        Case "Ilford SFX 200||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Ilford SFX 200||Romek R09": aDils = Array("1+25")
        Case "Ilford SFX 200||T-MAX Dev": aDils = Array("1+4")
        Case "JCH Streetpan 400||D-76": aDils = Array("1+1")
        Case "JCH Streetpan 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "JCH Streetpan 400||ID-11": aDils = Array("1+1")
        Case "JCH Streetpan 400||Ilfosol 3": aDils = Array("1+3")
        Case "JCH Streetpan 400||Perceptol": aDils = Array("1+1")
        Case "JCH Streetpan 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "JCH Streetpan 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "JCH Streetpan 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "JCH Streetpan 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "JCH Streetpan 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "JCH Streetpan 400||T-MAX Dev": aDils = Array("1+4")
        Case "JCH Streetpan 400||XTOL": aDils = Array("1+1")
        Case "Kodak Double-X 5222||D-76": aDils = Array("Stock", "1+1", "1+2")
        Case "Kodak Double-X 5222||D-96": aDils = Array("Stock", "1+1")
        Case "Kodak Double-X 5222||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Kodak Double-X 5222||ID-11": aDils = Array("Stock")
        Case "Kodak Double-X 5222||Ilfosol 3": aDils = Array("1+9")
        Case "Kodak Double-X 5222||Microphen": aDils = Array("Stock")
        Case "Kodak Double-X 5222||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kodak Double-X 5222||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kodak Double-X 5222||XTOL": aDils = Array("Stock", "1+1")
        Case "Kodak Plus-X 125||D-76": aDils = Array("Stock", "1+1")
        Case "Kodak Plus-X 125||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Kodak Plus-X 125||Microdol-X": aDils = Array("Stock", "1+3")
        Case "Kodak Plus-X 125||T-MAX Dev": aDils = Array("Stock")
        Case "Kodak Plus-X 125||T-MAX RS": aDils = Array("1+4")
        Case "Kodak Plus-X 125||XTOL": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 100||D-76": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 100||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Kodak T-MAX 100||ID-11": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 100||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Kodak T-MAX 100||Microdol-X": aDils = Array("Stock")
        Case "Kodak T-MAX 100||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kodak T-MAX 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Kodak T-MAX 100||T-MAX RS": aDils = Array("1+4")
        Case "Kodak T-MAX 100||XTOL": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 400||D-76": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Kodak T-MAX 400||ID-11": aDils = Array("Stock", "1+1")
        Case "Kodak T-MAX 400||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Kodak T-MAX 400||Microdol-X": aDils = Array("Stock")
        Case "Kodak T-MAX 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kodak T-MAX 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Kodak T-MAX 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Kodak T-MAX 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Kodak T-MAX 400||T-MAX RS": aDils = Array("1+4")
        Case "Kodak T-MAX 400||XTOL": aDils = Array("Stock", "1+1")
        Case "Kodak Tri-X 400||D-76": aDils = Array("Stock", "1+1")
        Case "Kodak Tri-X 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Kodak Tri-X 400||ID-11": aDils = Array("Stock", "1+1")
        Case "Kodak Tri-X 400||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Kodak Tri-X 400||Microdol-X": aDils = Array("Stock")
        Case "Kodak Tri-X 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kodak Tri-X 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Kodak Tri-X 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Kodak Tri-X 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Kodak Tri-X 400||T-MAX RS": aDils = Array("1+4")
        Case "Kodak Tri-X 400||XTOL": aDils = Array("Stock", "1+1")
        Case "Kosmo Foto Mono 100||D-76": aDils = Array("Stock", "1+1")
        Case "Kosmo Foto Mono 100||ID-11": aDils = Array("Stock", "1+1")
        Case "Kosmo Foto Mono 100||Ilfotec DD-X": aDils = Array("1+4")
        Case "Kosmo Foto Mono 100||Microphen": aDils = Array("Stock")
        Case "Kosmo Foto Mono 100||Perceptol": aDils = Array("Stock", "1+1")
        Case "Kosmo Foto Mono 100||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kosmo Foto Mono 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Kosmo Foto Mono 100||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Kosmo Foto Mono 100||T-MAX Dev": aDils = Array("1+4")
        Case "Kosmo Foto Mono 100||XTOL": aDils = Array("Stock")
        Case "Lomo Babylon Kino 13||D-76": aDils = Array("Stock")
        Case "Lomo Babylon Kino 13||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Lomo Babylon Kino 13||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Lomo Berlin Kino 400||D-76": aDils = Array("Stock", "1+1")
        Case "Lomo Berlin Kino 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Lomo Berlin Kino 400||Ilfosol 3": aDils = Array("1+9")
        Case "Lomo Berlin Kino 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Lomo Berlin Kino 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Lomo Berlin Kino 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Lomo Berlin Kino 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Lomo Berlin Kino 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Lomo Berlin Kino 400||XTOL": aDils = Array("Stock")
        Case "Lomo Earl Grey 100||D-76": aDils = Array("Stock", "1+1")
        Case "Lomo Earl Grey 100||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Lomo Earl Grey 100||Ilfosol 3": aDils = Array("1+9")
        Case "Lomo Earl Grey 100||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Earl Grey 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Lomo Earl Grey 100||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Fantome Kino 8||D-96": aDils = Array("Stock")
        Case "Lomo Fantome Kino 8||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Lomo Fantome Kino 8||Ilfosol 3": aDils = Array("1+9")
        Case "Lomo Fantome Kino 8||Ilfotec HC": aDils = Array("1+31 (Dil.B)", "1+47 (Dil.E)", "Dil. H (1+63)")
        Case "Lomo Fantome Kino 8||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Fantome Kino 8||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Lady Grey 400||D-23": aDils = Array("Stock", "1+1")
        Case "Lomo Lady Grey 400||D-76": aDils = Array("Stock", "1+1", "1+3")
        Case "Lomo Lady Grey 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Lomo Lady Grey 400||Microphen": aDils = Array("Stock")
        Case "Lomo Lady Grey 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Lomo Lady Grey 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Lomo Lady Grey 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Lomo Lady Grey 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Lomo Lady Grey 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Lomo Lady Grey 400||T-MAX Dev": aDils = Array("1+4")
        Case "Lomo Lady Grey 400||T-MAX RS": aDils = Array("Stock")
        Case "Lomo Lady Grey 400||XTOL": aDils = Array("Stock", "1+3")
        Case "Lomo Potsdam Kino 100||D-76": aDils = Array("Stock", "1+1")
        Case "Lomo Potsdam Kino 100||HC-110": aDils = Array("1+11")
        Case "Lomo Potsdam Kino 100||Ilfosol 3": aDils = Array("1+9")
        Case "Lomo Potsdam Kino 100||Rodinal": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Potsdam Kino 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Lomo Potsdam Kino 100||Romek R09": aDils = Array("1+50", "1+100", "1+200")
        Case "Lomo Potsdam Kino 100||T-MAX Dev": aDils = Array("1+9")
        Case "Rollei RPX 100||D-76": aDils = Array("Stock")
        Case "Rollei RPX 100||ID-11": aDils = Array("Stock", "1+1")
        Case "Rollei RPX 100||Ilfosol 3": aDils = Array("1+9")
        Case "Rollei RPX 100||Ilfotec DD-X": aDils = Array("1+4")
        Case "Rollei RPX 100||Ilfotec LC29": aDils = Array("1+19")
        Case "Rollei RPX 100||Microphen": aDils = Array("Stock", "1+1")
        Case "Rollei RPX 100||Perceptol": aDils = Array("Stock", "1+1")
        Case "Rollei RPX 100||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Rollei RPX 100||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Rollei RPX 100||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Rollei RPX 100||XTOL": aDils = Array("Stock", "1+1")
        Case "Rollei RPX 400||D-76": aDils = Array("Stock")
        Case "Rollei RPX 400||HC-110": aDils = Array("Dil. B (1+31)", "Dil. H (1+63)", "Dil. E (1+47)")
        Case "Rollei RPX 400||ID-11": aDils = Array("Stock", "1+1", "1+3")
        Case "Rollei RPX 400||Ilfosol 3": aDils = Array("1+9", "1+14")
        Case "Rollei RPX 400||Ilfotec DD-X": aDils = Array("1+4")
        Case "Rollei RPX 400||Ilfotec LC29": aDils = Array("1+9", "1+19")
        Case "Rollei RPX 400||Microphen": aDils = Array("Stock", "1+1")
        Case "Rollei RPX 400||Perceptol": aDils = Array("1+1")
        Case "Rollei RPX 400||Rodinal": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Rollei RPX 400||Romek PQ6": aDils = Array("1+3 (verificar)")
        Case "Rollei RPX 400||Romek PQ7": aDils = Array("(verificar con Romek)")
        Case "Rollei RPX 400||Romek PQ9": aDils = Array("1+3 ó 1+6 (verificar)")
        Case "Rollei RPX 400||Romek R09": aDils = Array("1+25", "1+50", "1+100", "1+200")
        Case "Rollei RPX 400||XTOL": aDils = Array("Stock", "1+1")
        Case Else: aDils = Array("")
    End Select
    
    With ws.Range("C17").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:=Join(aDils, ",")
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = False
        .ShowError = False
    End With
    
    ' Auto-seleccionar si hay una sola dilución
    If UBound(aDils) = 0 Then
        ws.Range("C17").Value = aDils(0)
    End If
End Sub

' ─── Actualizar todo (llamado al abrir) ──────────────────────
Sub UpdateAll()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("🎞 Dev Chart")
    
    ' Temperatura default
    If ws.Range("C20").Value = "" Then
        ws.Range("C20").Value = "20°C"
    End If
    
    ' Agitación default
    If ws.Range("C23").Value = "" Then
        ws.Range("C23").Value = "30s — Estándar (4 inv./30s)"
    End If
    
    ' Temperatura - validación fija
    With ws.Range("C20").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="18°C,19°C,20°C,21°C,22°C,23°C,24°C"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = False
        .ShowError = False
    End With
    
    ' Agitación - validación fija
    With ws.Range("C23").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, _
             Formula1:="30s — Estándar (4 inv./30s),Continuo — Rotary / JOBO (×0.85),Stand / Desatendido"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = False
        .ShowError = False
    End With
    
    PopulateFilms
End Sub
