Option Explicit

' EduBoek - rugsteunmetode om die Access-databasis handmatig te skep.
' Die Delphi-program skep normaalweg self die databasis tydens die eerste loop.

Dim fso, basisPad, dataPad, dbPad, connStr, cat, conn
Set fso = CreateObject("Scripting.FileSystemObject")
basisPad = fso.GetParentFolderName(WScript.ScriptFullName)
dataPad = fso.BuildPath(basisPad, "Data")
If Not fso.FolderExists(dataPad) Then fso.CreateFolder(dataPad)
dbPad = fso.BuildPath(dataPad, "Boekwinkel.mdb")

If fso.FileExists(dbPad) Then
  MsgBox "Die databasis bestaan reeds:" & vbCrLf & dbPad, vbInformation, "EduBoek"
  WScript.Quit
End If

connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbPad & ";Jet OLEDB:Engine Type=5;"
Set cat = CreateObject("ADOX.Catalog")
cat.Create connStr
Set cat = Nothing

Set conn = CreateObject("ADODB.Connection")
conn.Open connStr
conn.Execute "CREATE TABLE tblBoeke (BoekID COUNTER CONSTRAINT pkBoeke PRIMARY KEY, BoekKode TEXT(10) NOT NULL, Titel TEXT(80) NOT NULL, Graad INTEGER NOT NULL, Vak TEXT(30) NOT NULL, Kategorie TEXT(30) NOT NULL, Prys CURRENCY NOT NULL, VoorraadHoeveelheid INTEGER NOT NULL, MinimumVoorraad INTEGER NOT NULL, Aktief YESNO NOT NULL)"
conn.Execute "CREATE UNIQUE INDEX idxBoekKode ON tblBoeke (BoekKode)"
conn.Execute "CREATE TABLE tblVerkope (VerkoopID COUNTER CONSTRAINT pkVerkope PRIMARY KEY, BoekID LONG NOT NULL, VerkoopDatum DATETIME NOT NULL, Hoeveelheid INTEGER NOT NULL, EenheidsPrys CURRENCY NOT NULL, GebruikerRol TEXT(20) NOT NULL)"
conn.Execute "ALTER TABLE tblVerkope ADD CONSTRAINT fkVerkopeBoeke FOREIGN KEY (BoekID) REFERENCES tblBoeke (BoekID)"
conn.Execute "INSERT INTO tblBoeke (BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) VALUES ('IT11','IT Delphi Gr 11',11,'Inligtingstegnologie','Handboek',340,12,5,True)"
conn.Execute "INSERT INTO tblBoeke (BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) VALUES ('WIS10','Wiskunde Gr 10',10,'Wiskunde','Werkboek',285,2,5,True)"
conn.Execute "INSERT INTO tblBoeke (BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) VALUES ('AFR11','Afrikaans Huistaal Gr 11',11,'Afrikaans','Handboek',210,18,4,True)"
conn.Execute "INSERT INTO tblBoeke (BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) VALUES ('ENG08','English FAL Gr 8',8,'Engels','Leesboek',195,4,5,True)"
conn.Close
Set conn = Nothing
MsgBox "EduBoek-databasis is geskep:" & vbCrLf & dbPad, vbInformation, "EduBoek"
