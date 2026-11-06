# COMPRAS FINAL UNIFICADO

## Qué abrir

**COMPRAS_FINAL_UNIFICADO.pbit** es la plantilla unificada. Se tomó COMPRAS_TRABAJADO.pbit como base de diseño, modelo, medidas, filtros y formatos. Las dos fuentes Web.Contents se migraron desde COMPRAS_FINAL_CONEXIONES.pbit conservando exactamente sus URLs.

El paquete completo también incluye `Proyecto/COMPRAS_FINAL.pbip`, un proyecto editable equivalente, las consultas M y los informes de validación.

## Abrir y actualizar

1. Descarga la plantilla PBIT y ábrela en Power BI Desktop actualizado para Windows. Las plantillas de origen fueron creadas con Desktop 2.159.1206.0 (2026.10); usa esa versión o una posterior compatible.
2. Cuando se solicite acceso al origen web, selecciona **Anónimo** para los endpoints CSV publicados de Google incluidos en la plantilla. Son las mismas URLs de tu archivo de conexiones. Esta entrega no publica de nuevo la hoja ni cambia permisos de Drive.
3. Mantén los controles de privacidad y configura el nivel apropiado según las políticas de tu organización. No desactives la privacidad para forzar la carga.
4. Pulsa **Cargar / Actualizar**. Ya no debes introducir pOrigen, pRutaExcel o pGoogleSheetsURL: la fuente del informe es directamente web/CSV.
5. Revisa los totales, fechas y conteos del corte actual. Si el origen sigue teniendo el corte original de agosto, la referencia anterior era compras 53,587.78 + servicios 302,592.08 = 356,179.86 y ahorros enero–agosto 15,980.72. Estos valores NO se han recalculado contra las URLs actuales, que están bloqueadas en el entorno de generación.
6. Guarda el resultado como **COMPRAS_FINAL.pbix**. El PBIT es una plantilla sin datos cargados; el PBIX se genera desde Desktop después de actualizar.

Para abrir la alternativa PBIP, extrae todo el ZIP, mantén la estructura de `Proyecto` y abre `Proyecto/COMPRAS_FINAL.pbip`. Conserva las carpetas Report y SemanticModel juntas. Usa este proyecto también para mantener el código bajo control de versiones.

## Qué se respetó de COMPRAS_TRABAJADO

- Cinco páginas: Consolidado, Guayaquil, Quito, Ahorros y Condiciones.
- 33 visuales con sus posiciones, títulos, campos, filtros, formatos y tema.
- 50 medidas DAX, sin cambios de fórmulas ni nombres.
- Las columnas y las seis tablas, incluyendo las dos tablas de fecha automáticas ocultas.
- Cuatro relaciones y sus identificadores.
- La corrección del ahorro acumulado anual que devuelve BLANK cuando el periodo no tiene registros de Ahorros.
- La función LeerNumero, las validaciones de importes, los controles de ciudades y la trazabilidad FilaOrigen.

Los 42 archivos internos Report/ de la plantilla trabajada son idénticos byte a byte en la salida. No se sustituyeron por los visuales del archivo de conexiones.

## Mapa de migración web

| Consulta en COMPRAS_FINAL_CONEXIONES | Datos reales | Conexión auxiliar final | Tabla del informe |
|---|---|---|---|
| Consulta | Compras y servicios | OrigenWebCompras | Compras |
| Compras | Cotizaciones y ahorros | OrigenWebAhorros | Ahorros |

La consulta llamada Compras en el archivo de conexiones contiene en realidad FECHA, CATEGORIA, COTI 1, COTI 2 y DIFERENCIA. Se asignó a Ahorros para conservar el significado de los indicadores y los visuales del trabajado.

La lectura usa CSV UTF-8 y QuoteStyle.Csv para respetar campos entrecomillados y saltos de línea. Antes de seleccionar columnas se limpian los espacios de los encabezados, porque el CSV de compras contiene encabezados como ` Suma de importe `, ` Quito ` y ` Guayaquil `.

Los siguientes nombres deben seguir existiendo en los CSV publicados:
- Compras: Fecha, Pais, Etiquetas de fila, Suma de importe, TIPO SERVICIO, FACTURAS, Quito, Guayaquil, F PAGO, Ciudad.
- Ahorros: FECHA, CATEGORIA, COTI 1, COTI 2, DIFERENCIA.

Los valores monetarios se convierten usando LeerNumero del trabajado. Las fechas se interpretan conforme a la cultura es-EC usada por el trabajado; comprueba mes/año tras la primera carga si cambias la configuración regional de la hoja. FilaOrigen identifica la fila recibida por CSV, no un ID permanente de transacción.

## Limpieza necesaria de la plantilla

Se eliminaron las rutas al Excel, los parámetros del conector nativo Google Sheets y los bloques de datos Snapshot. El modelo final no usa File.Contents, GoogleSheets.Contents ni datos Base64 incorporados.

COMPRAS_TRABAJADO contenía una copia de cambios pendientes (UnappliedChanges). Se compararon sus nueve consultas con las del modelo y eran equivalentes, salvo espacios extremos. Se eliminó esa copia pendiente para que al abrir no restaure la fuente anterior. Se retiraron vínculos a IDs de publicación del archivo original y enlaces de integridad antiguos de la plantilla modificada; la salida es un artefacto nuevo. No se migraron credenciales locales.

## Validación y límite de comprobación

- Archivo ZIP/PBIT comprobado íntegro.
- Conservación exacta de los archivos del informe, medidas, columnas, relaciones y consultas derivadas.
- 47 referencias de campos del informe comprobadas contra el modelo.
- Ocho consultas M analizadas sin errores de sintaxis con el parser de Microsoft.
- Once definiciones comprobadas contra esquemas Microsoft disponibles. No se obtuvo el esquema visualContainer/2.14.0 de los otros 32 visuales: GitHub devuelve 404 y el endpoint oficial esta bloqueado por el proxy. Esos visuales se conservaron identicos al original; consulta Proyecto/Validacion_esquemas.txt.
- Las dos URLs copiadas coinciden exactamente con la plantilla de conexiones.

No se ejecutó Power BI Desktop ni el motor M/DAX en este entorno Linux. Ambos endpoints web devolvieron bloqueo 403 del proxy del entorno, por lo que no se ha certificado la actualización ni el contenido remoto. La prueba final es abrir la plantilla en Desktop, autenticar el origen web si corresponde, actualizar y contrastar el corte actual. Si Desktop muestra un error, conserva su texto completo y el nombre de la consulta para localizar la causa.
