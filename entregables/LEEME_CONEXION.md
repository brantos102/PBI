# Compras Ecuador — entrega y conexión (revisión 3)

## Contenido y estado
- `Compras.pbip`: proyecto editable de Power BI con siete pestañas, modelo semántico, medidas DAX y consultas Power Query.
- `Auditoria.xlsx`: detalle íntegro, controles, filas excluidas y diccionario.
- `Resumen_ejecutivo.pdf`: lectura inmediata de resultados, generada independientemente; no es una captura de Power BI.
- `Fuentes/BASE COMPRAS.xlsx`: copia exacta del adjunto. `manifest.json` contiene su SHA-256.
- `Consultas`: código M y parámetros para revisión o recuperación manual.
- `MEDIDAS_DAX.txt`: definiciones de las medidas.
- `Validacion_esquemas.txt` y `Validacion_datos.txt`: alcance de las comprobaciones realizadas.

Se entrega un proyecto PBIP, no un PBIX compilado. Se validaron los JSON del informe contra esquemas oficiales Microsoft y se recalcularon los importes con Python. Esta máquina Linux no dispone de Power BI Desktop: la apertura, ejecución de M/DAX, representación visual y autenticación Google quedan por comprobar en Windows. No se afirma una conexión en vivo ni actualización programada ya configurada.

## 1. Abrir y obtener el archivo PBIX
1. Extraer TODO el ZIP a una carpeta local, manteniendo juntas las carpetas `Compras.Report` y `Compras.SemanticModel` y el archivo `Compras.pbip`.
2. Instalar/actualizar Power BI Desktop en Windows (versión reciente compatible con PBIP y PBIR). Si la versión lo solicita: Archivo > Opciones y configuración > Opciones > Características de versión preliminar, habilitar proyectos Power BI (.pbip) y formato mejorado de informe PBIR; reiniciar Desktop.
3. Abrir `Compras.pbip`. El parámetro `pOrigen` está en `Snapshot`: utiliza datos incorporados del adjunto, sin necesitar rutas locales ni acceso a Google.
4. Pulsar Inicio > Actualizar. Si aparece una advertencia de consultas nativas/código del proyecto, revisar el código M suministrado antes de aceptar. No desactivar controles de privacidad.
5. Confirmar en Consolidado (sin filtros): compras 53.587,78; servicios 302.592,08; total 356.179,86; FACTURAS 358. En Auditoría: 359 registros, 1 FACTURAS vacío y 2 filas potencialmente duplicadas. En Ahorros sin filtro: 15.980,72.
6. Archivo > Guardar como > Archivo Power BI (.pbix), por ejemplo `Compras_Ecuador.pbix`. Conservar también el proyecto para auditoría y mantenimiento.

Si Desktop no acepta el formato, actualizarlo primero. Como recuperación, se incluyen todas las consultas y medidas: crear parámetros y la función LeerHoja primero; después Compras, Ahorros, DistribucionCiudad y Calendario. Crear relaciones Calendario[Fecha] (1) a cada tabla de hechos (*) con dirección única. Importar las medidas y reconstruir los visuales conforme a las páginas documentadas. Esta alternativa es manual y no equivale a haber validado el proyecto en Desktop.

## 2. Preparar Google Sheets
El enlace recibido incluye `rtpof=true`, habitual al abrir un XLSX en Drive; su contenido remoto no se pudo leer desde este entorno por bloqueo de red. Abrirlo en el navegador con la cuenta autorizada. La captura de error recibida confirma que el conector reconoce el documento original como archivo Office. Usar Archivo > Guardar como Hojas de cálculo de Google. Esa conversión puede generar un ID/URL nuevo: copiar la URL nueva y conservar el Excel original como respaldo. No es necesario publicar los datos en la web ni hacerlos públicos.

Conservar dos pestañas con estos nombres y encabezados en fila 1:
- `BASE KPIS`: Fecha | Pais | Etiquetas de fila | Suma de importe | TIPO SERVICIO | FACTURAS | Quito | Guayaquil | F PAGO | Ciudad
- `AHORROS`: FECHA | CATEGORIA | COTI 1 | COTI 2 | DIFERENCIA

Mantener tipos numéricos reales en importes y cotizaciones y fechas reales (o ISO yyyy-MM-dd). Se recomiendan celdas numéricas reales. La revisión 3 también admite números como texto con formatos explícitos `1,234.56` y `1.234,56`, signos y prefijos/sufijos USD o $. Las celdas vacías, espacios o guiones en las columnas opcionales se conservan como null. Un único separador seguido de tres dígitos, como `1,234`, es ambiguo: usar una celda numérica real o escribir dos decimales. Los errores indican hoja, fila y columna. DIFERENCIA puede ser numérica o texto numérico; un valor ausente/guion se interpreta como cero únicamente cuando ambas cotizaciones son cero. Con cotizaciones distintas de cero se exige un importe declarado. Conservar las filas sin totalizar dentro del detalle; las filas sin fecha y sin descripción de BASE KPIS se excluyen como vacías/subtotales. No borrar errores ni sustituirlos por cero para forzar la actualización.

Agregar cada mes debajo del anterior, sin sobrescribir agosto, si se quiere construir una tendencia. Los encabezados y tipos deben mantenerse. No pegar el total general como transacción. Se recomienda añadir posteriormente ID de documento, ID de línea, ID de proveedor, RUC, moneda, fecha real de documento y plazo de pago; esas columnas requerirán ampliar el modelo. FilaOrigen es trazabilidad de ubicación en cada actualización, no una clave estable entre versiones.

## 3. Conectar de forma autenticada en Power BI
1. Inicio > Transformar datos > Administrar parámetros.
2. Cambiar `pGoogleSheetsURL` por la URL de la hoja nativa final, sin enlaces de descarga CSV. El parámetro está vacío deliberadamente: el enlace original corresponde a un archivo Office y no funciona con el conector Google Sheets. Debe pegar la URL NUEVA creada al convertir a hoja nativa.
3. Cambiar `pOrigen` de `Snapshot` a `GoogleSheets`.
4. Cuando se soliciten credenciales, iniciar sesión en la cuenta Google que tenga permiso de lectura. El código usa el conector nativo `GoogleSheets.Contents`; no usa publicación pública ni tokens incrustados.
5. Si no aparece el diálogo o se necesita reconocer el origen: Inicio > Obtener datos > Más > Google Sheets, pegar la misma URL y autenticar. Revisar que el navegador muestra BASE KPIS y AHORROS; cancelar la carga adicional para no duplicar tablas. Volver a actualizar las consultas del proyecto.
6. Cerrar y aplicar; pulsar Actualizar. Comparar con Auditoria.xlsx solo si Google conserva exactamente el mismo corte. Si tiene nuevas filas, conciliar el nuevo corte por separado.
7. Si falla la navegación: revisar nombre exacto de pestañas, encabezados, permiso de la cuenta y conversión de XLSX a hoja nativa. La función busca exactamente una pestaña por nombre y falla explícitamente si no la encuentra. Revisar Configuración de origen de datos para corregir credenciales/privacidad, sin desactivar comprobaciones.
8. Guardar como PBIX una vez validado. Mientras `pOrigen=Snapshot`, Actualizar vuelve a cargar el adjunto incorporado: NO consulta Google.

Alternativa local: `pOrigen=Excel` y `pRutaExcel` con la ruta absoluta real de `BASE COMPRAS.xlsx`. Este modo sirve para archivos locales; no sincroniza Drive por sí solo.

## 4. Actualización en Power BI Service (opcional)
Una vez validado en Desktop y con autorización para el espacio de trabajo: Publicar. En la configuración del modelo semántico del servicio, configurar conexión/credenciales OAuth2 para Google y permisos de la cuenta que administrará la actualización. Ejecutar una actualización manual y comprobar su historial antes de programar frecuencia. El conector cloud Google Sheets normalmente no requiere gateway local; el modo Excel con ruta local sí requiere un gateway/ruta accesible o migrar la fuente. La disponibilidad depende de licencia y políticas del tenant. La publicación y programación no están realizadas en esta entrega.

## Pestañas y correspondencia con la presentación
1. Consolidado: diapositiva 3; compras y servicios como columnas y FACTURAS declaradas como línea. Tarjetas de ambos totales al inicio.
2. Guayaquil: diapositiva 4; dinero distribuido por columna Guayaquil y volumen de registros con asignación.
3. Quito: diapositiva 5; dinero distribuido por columna Quito y volumen de registros con asignación.
4. Ahorros: diapositiva 6; ahorro mensual, acumulado anual y participación por categoría.
5. Condiciones: diapositiva 7; crédito/contado por importe y por registros. No se muestra cantidad de proveedores porque no hay identificador fiable.
6. Auditoría: detalle y alertas de BASE KPIS.
7. Detalle ahorros: comparación de cotizaciones y diferencias.

Se conserva la estructura analítica y paleta azul de la presentación, adaptada a visuales editables. No se copiaron como datos las cifras históricas de imágenes. Las portadas sin datos no se incluyen como pestañas adicionales. Las notas de eventos de junio/julio pertenecen a la presentación histórica y no se atribuyen a agosto.

## Reglas de auditoría y limitaciones
- Corte compras: agosto 2026 exclusivamente. La Fecha es 01/08/2026 para todo el detalle: no permite análisis diario ni deducir vencimientos. Las descripciones pueden mencionar otros meses; manda la fecha contable del origen.
- Compras: 105 filas, USD 53.587,78. Servicios: 254 filas, USD 302.592,08. Total USD 356.179,86.
- Quito USD 165.774,87; Guayaquil USD 190.404,99. Se incluyen cuatro filas compartidas (83, 173, 306, 314) según su distribución original. Los conteos por ciudad se superponen: no sumarlos como documentos únicos.
- BASE KPIS filas 363, 365 y 369 son controles/subtotales excluidos; las filas vacías se ignoran.
- Fila 171: FACTURAS vacío en una amortización de USD 4.950,38. Se conserva vacío, sin asumir error ni completar una factura ficticia. 359 registros y 358 FACTURAS son indicadores diferentes.
- Filas 11 y 274: idénticas, USD 749,69 cada una. Se conservan ambas hasta revisar respaldo. Si se confirmara duplicidad y correspondiera retirar una, el total bajaría a USD 355.430,17; NO se aplicó esa corrección.
- AHORROS: 21 filas; 18 con cotizaciones y 3 filas cero sin categoría (enero–marzo). Ahorro calculado USD 15.980,72, igual al declarado. El ahorro equivale al 8,49% de COTI 1. Se interpreta como diferencia entre cotizaciones, pendiente acreditar adjudicación/realización.
- AHORROS no tiene ciudad ni vínculo a facturas: no se atribuye ahorro por ciudad ni se resta del gasto. La fecha común es la única dimensión compartida.
- Crédito USD 349.688,26 (98,18% del importe); contado USD 6.491,60 (1,82%). Por registros: 342/359 a crédito (95,26%) y 17/359 al contado (4,74%). No son porcentajes de proveedores ni días de crédito.
- No hay importes de IVA separados: no se afirma que sean netos o brutos. USD se asume por Ecuador y la presentación; confirmar si el alcance incorpora otras monedas.
- No se incorporó histórico enero–julio de compras como transacciones: falta el detalle fuente. Esos meses deben aparecer sin dato, no como cero de gasto.


## Corrección de importes (revisión 3)
Las medidas financieras numéricas conservan sus valores y tipo decimal fijo. Las tarjetas monetarias utilizan medidas auxiliares de presentación con FORMAT(..., "#,##0.00", "en-US") para mostrar **356,179.86** sin abreviaturas de miles/millones. Estas medidas de texto son solo para tarjetas: los gráficos y cálculos conservan las medidas numéricas originales. Se fijaron las unidades de visualización en Ninguno y la precisión monetaria en dos decimales. Las tarjetas indican USD en el título. Las cifras no se dividieron por 1.000 ni se recalcularon.

Para corregir un informe existente manualmente: seleccionar tarjeta > Formato visual > Etiqueta de datos/Valor destacado > Unidades de visualización = Ninguno, Decimales = 2. En gráficos revisar también ejes y etiquetas de datos. La posición exacta varía entre tarjetas clásicas y nuevas.


## Revisión 3 — vacíos e importes de Google
La función `LeerNumero` admite números nativos, importes de texto con separadores comprobables y celdas opcionales vacías. Compras y Ahorros usan la misma conversión; FACTURAS debe seguir siendo entero y puede estar vacío. Importe/COTI 1/COTI 2 son obligatorios para filas de detalle. Los errores no se reemplazan por cero. Las filas vacías enviadas por Google como cadenas vacías se excluyen junto con los subtotales que carecen de fecha y descripción.

Para conservar tu diseño existente, consulta `SOLUCION_GUAYAQUIL.md`: se pueden reemplazar únicamente tres consultas en Power Query. Antes de abrir un nuevo proyecto, anota tu URL de hoja nativa: el ZIP no contiene las credenciales ni la URL nueva de tu conexión local.
