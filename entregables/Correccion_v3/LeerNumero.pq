(Valor as any, Hoja as text, Columna as text, Fila as number, optional Obligatorio as nullable logical, optional Entero as nullable logical) as nullable number =>
let
 Requerido = if Obligatorio = null then false else Obligatorio,
 EsEntero = if Entero = null then false else Entero,
 Fallar = (Motivo as text) => error Error.Record("NumeroNoInterpretable", Motivo & " | Hoja " & Hoja & ", fila " & Text.From(Fila) & ", columna " & Columna, [Hoja=Hoja, FilaOrigen=Fila, Columna=Columna, ValorOriginal=Valor]),
 Digitos = (Texto as text) as logical => Text.Length(Texto)>0 and Text.Select(Texto, {"0".."9"})=Texto,
 Recortar = (Texto as text) as text => Text.Trim(Text.Replace(Text.Replace(Text.Replace(Text.Replace(Texto, Character.FromNumber(160), " "), Character.FromNumber(8239), " "), "#(tab)", " "), "#(cr)#(lf)", " ")),
 QuitarMoneda = (Texto as text) as text => let
  Inicio = if Text.StartsWith(Texto, "USD") then Recortar(Text.Range(Texto,3)) else if Text.StartsWith(Texto, "$") then Recortar(Text.Range(Texto,1)) else Texto,
  Fin = if Text.EndsWith(Inicio, "USD") then Recortar(Text.Start(Inicio,Text.Length(Inicio)-3)) else if Text.EndsWith(Inicio, "$") then Recortar(Text.Start(Inicio,Text.Length(Inicio)-1)) else Inicio
 in Fin,
 DesdeTexto = () as nullable number => let
  Texto = QuitarMoneda(Text.Upper(Recortar(Valor))),
  Vacio = List.Contains({"", "-", "–", "—"}, Texto),
  Parentesis = Text.StartsWith(Texto,"(") and Text.EndsWith(Texto,")"),
  Interior = if Parentesis then Recortar(Text.Middle(Texto,1,Text.Length(Texto)-2)) else Texto,
  SinMoneda = QuitarMoneda(Interior),
  Negativo = Text.StartsWith(SinMoneda,"-"),
  Positivo = Text.StartsWith(SinMoneda,"+"),
  SinSigno = if Negativo or Positivo then Recortar(Text.Range(SinMoneda,1)) else SinMoneda,
  Base = QuitarMoneda(SinSigno),
  Comas = List.Count(Text.Split(Base,","))-1,
  Puntos = List.Count(Text.Split(Base,"."))-1,
  Ambos = Comas>0 and Puntos>0,
  SeparadorUnico = if Comas>0 then "," else if Puntos>0 then "." else "",
  CuentaUnica = Comas+Puntos,
  Cola = if SeparadorUnico<>"" then List.Last(Text.Split(Base,SeparadorUnico)) else "",
  Ambiguo = not Ambos and CuentaUnica=1 and Text.Length(Cola)=3,
  Decimal = if Ambos then (if Text.PositionOf(Base,",",Occurrence.Last)>Text.PositionOf(Base,".",Occurrence.Last) then "," else ".") else if CuentaUnica=1 and List.Contains({1,2},Text.Length(Cola)) then SeparadorUnico else null,
  Miles = if Ambos then (if Decimal="," then "." else ",") else if Decimal=null and CuentaUnica>0 then SeparadorUnico else null,
  Partes = if Decimal=null then {Base} else Text.Split(Base,Decimal),
  ParteEntera = Partes{0},
  Fraccion = if List.Count(Partes)=2 then Partes{1} else null,
  Grupos = if Miles=null then {ParteEntera} else Text.Split(ParteEntera,Miles),
  GruposValidos = if Miles=null then Digitos(ParteEntera) else List.Count(Grupos)>1 and Text.Length(Grupos{0})>=1 and Text.Length(Grupos{0})<=3 and Digitos(Grupos{0}) and List.AllTrue(List.Transform(List.Skip(Grupos), each Text.Length(_)=3 and Digitos(_))),
  FraccionValida = if Decimal=null then true else List.Count(Partes)=2 and Fraccion<>null and List.Contains({1,2},Text.Length(Fraccion)) and Digitos(Fraccion),
  Normalizado = Text.Combine(Grupos,"") & (if Fraccion=null then "" else "." & Fraccion),
  Numero = if Vacio then null else if Parentesis and (Negativo or Positivo) then Fallar("Signo duplicado") else if Ambiguo then Fallar("Separador ambiguo: use una celda numerica o escriba el importe con dos decimales, por ejemplo 1,234.00 o 1.234,00") else if not GruposValidos or not FraccionValida then Fallar("Formato numerico no reconocido; se admiten 1,234.56 y 1.234,56") else (if Negativo or Parentesis then -1 else 1) * Number.FromText(Normalizado,"en-US")
 in Numero,
 Convertido = if Valor=null then null else if Value.Is(Valor,type number) then Valor else if Value.Is(Valor,type text) then DesdeTexto() else Fallar("Tipo de dato no numerico"),
 Resultado = if Convertido=null then (if Requerido then Fallar("Falta un importe obligatorio") else null) else if EsEntero and Number.RoundDown(Convertido)<>Convertido then Fallar("Se requiere un numero entero") else Convertido
in Resultado
