# Error «Columna Guayaquil: use celdas numericas...» — revisión 3

La versión 2 rechazaba cualquier texto en las columnas numéricas. Google puede devolver una celda vacía como `""`, o un importe como texto. Ese control era demasiado estricto. El mensaje no permite identificar el contenido concreto de tu celda; no se ha leído tu hoja nueva desde este entorno.

Calendario depende de Compras y Ahorros, por eso aparece bloqueado junto con las demás consultas. No debe borrarse Calendario.

## Opción A: abrir el paquete corregido
1. Anota la URL nativa de Google que ya configuraste en tu Power BI.
2. Descarga `Compras_Ecuador_PowerBI_v3.zip` y extrae TODO en una carpeta nueva.
3. Abre Compras.pbip. En Administrar parámetros, pega tu URL nativa en pGoogleSheetsURL y cambia pOrigen a GoogleSheets.
4. Inicia sesión si se solicita, Cerrar y aplicar > Actualizar.
5. Si la base sigue en el corte original: compras 53,587.78, servicios 302,592.08, total 356,179.86; 359 registros, FACTURAS 358; ahorros 15,980.72. Si añadiste datos, el total debe conciliarse con el nuevo corte.

## Opción B: corregir tu PBIX actual conservando los visuales y parámetros
En la carpeta `Consultas` del ZIP están los archivos de texto que hay que copiar. En GitHub también están en `entregables/Correccion_v3/`.
1. Transformar datos > Nueva fuente > Consulta en blanco > Editor avanzado. Pega TODO `LeerNumero.pq` y llama a la consulta **LeerNumero**, exactamente. Es una función auxiliar, no una tabla para cargar.
2. Selecciona la consulta **Compras** > Editor avanzado. Sustituye todo su código por el contenido de `Compras.pq`.
3. Selecciona la consulta **Ahorros** > Editor avanzado. Sustituye todo su código por el contenido de `Ahorros.pq`.
4. Conserva `LeerHoja`, los parámetros, DistribucionCiudad y Calendario. No crees copias de Compras/Ahorros, porque los visuales referencian esos nombres.
5. Cerrar y aplicar > Actualizar. La fuente sigue siendo la elegida por tu parámetro pOrigen; el código incluye el respaldo Snapshot pero no lo activa si pOrigen=GoogleSheets.

## Conversión y trazabilidad
- `null`, `""`, espacios normales/no separables y guiones contables en Quito, Guayaquil o FACTURAS → null, no cero inventado.
- Números nativos → se conservan.
- `356,179.86`, `356.179,86`, `$ 356,179.86`, `USD 356.179,86` → 356179.86.
- `-1,234.56` y `(1,234.56)` → -1234.56.
- `1,234` o `1.234` como texto → error por ambigüedad entre miles y decimales. Usar una celda numérica real o `1,234.00` / `1.234,00` si representa mil doscientos treinta y cuatro.
- Texto ilegible, agrupaciones incorrectas, importes obligatorios vacíos o FACTURAS fraccionarias → error con hoja, fila, columna y valor original.
- AHORROS usa la misma conversión para cotizaciones y DIFERENCIA. Un valor declarado vacío/guion solo equivale a cero cuando ambas cotizaciones son cero.
- No se borran filas con importes ilegibles ni se sustituyen errores por cero. Los vacíos de ciudad se conservan y el control de distribución detecta diferencias frente al importe.

La sintaxis de las 10 consultas M se verificó con el analizador de Microsoft. Los datos del adjunto y las conciliaciones se volvieron a comprobar. El motor de Power Query/Power BI y la conexión a la hoja nueva no están disponibles aquí; su ejecución debe verificarse al actualizar en Desktop.

Se incluye `PruebasLeerNumero.pq` con 34 casos de comprobación para ejecutar opcionalmente como consulta independiente en Desktop, después de crear LeerNumero. Debe devolver todas las filas con Correcto=true; en caso contrario genera un error. Estos casos no se han ejecutado en el entorno de generación.
