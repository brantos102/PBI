(Hoja as text, Cabeceras as list, DatosSnapshot as text) as table =>
let
 Snapshot = Table.FromRecords(Json.Document(Binary.FromText(DatosSnapshot, BinaryEncoding.Base64))),
 URLGoogle = if pGoogleSheetsURL=null or Text.Trim(pGoogleSheetsURL)="" then error Error.Record("ConfigurarGoogleSheets", "Primero convierta el Excel de Drive: Archivo > Guardar como Hojas de calculo de Google. Pegue la NUEVA URL de la hoja nativa en pGoogleSheetsURL. Renombrar el XLSX no lo convierte.", null) else Text.Trim(pGoogleSheetsURL),
 CargarExterno = () as table => let
  Navegacion = if pOrigen = "Excel" then Excel.Workbook(File.Contents(pRutaExcel), null, true) else if pOrigen = "GoogleSheets" then GoogleSheets.Contents(URLGoogle) else error "pOrigen debe ser Snapshot, Excel o GoogleSheets",
  Candidatas = Table.SelectRows(Navegacion, each if pOrigen = "Excel" then [Item] = Hoja and [Kind] = "Sheet" else List.Contains(Record.FieldValues(_), Hoja)),
  Datos = if Table.RowCount(Candidatas) = 1 then Candidatas{0}[Data] else error ("No se encontro una hoja unica: " & Hoja),
  ConCabecera = if List.ContainsAll(Table.ColumnNames(Datos), Cabeceras) then Datos else Table.PromoteHeaders(Datos, [PromoteAllScalars=true]),
  Seleccion = Table.SelectColumns(ConCabecera, Cabeceras, MissingField.Error),
  Numeradas = Table.AddIndexColumn(Seleccion, "FilaOrigen", 2, 1, Int64.Type)
 in Numeradas,
 Resultado = if pOrigen = "Snapshot" then Snapshot else let
  Intento = try Table.Buffer(CargarExterno()),
  Mensaje = if Intento[HasError] then Text.Lower(Record.FieldOrDefault(Intento[Error], "Message", "")) else ""
 in if not Intento[HasError] then Intento[Value] else if pOrigen="GoogleSheets" and Text.Contains(Mensaje, "office") then error Error.Record("ArchivoOfficeNoCompatible", "Google Sheets no admite el XLSX de Drive. Abra el original en Google y use Archivo > Guardar como Hojas de calculo de Google. Copie la URL NUEVA, actualice pGoogleSheetsURL e inicie sesion con la cuenta autorizada. No basta con cambiar el nombre o reutilizar el enlace original.", Intento[Error]) else error Intento[Error]
in Resultado