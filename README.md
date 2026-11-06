# Compras Ecuador — Power BI

## Entrega final unificada

Se conserva COMPRAS_TRABAJADO (cinco paginas, 33 visuales, 50 medidas y cuatro relaciones) y se incorporan las dos conexiones web CSV de COMPRAS_FINAL_CONEXIONES.

- **[Descargar plantilla COMPRAS FINAL (.pbit)](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/final/COMPRAS_FINAL_UNIFICADO.pbit)**
- [Paquete completo con proyecto PBIP y consultas](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/final/COMPRAS_FINAL_UNIFICADO_COMPLETO.zip)
- [Instrucciones de apertura, conexiones y validacion](entregables/final/LEEME_FINAL.md)

Abrir en Power BI Desktop actualizado, usar acceso web **Anonimo** para las URLs CSV publicadas cuando se solicite, actualizar y guardar como PBIX. Esta entrega usa directamente las conexiones web del archivo recibido; no usa Excel local, Snapshot ni los parametros pOrigen/pGoogleSheetsURL de versiones anteriores.

Los archivos del informe se preservaron byte a byte y las consultas pasaron el analisis sintactico. Queda pendiente ejecutar la actualizacion y verificar la apertura/renderizado en Desktop: este entorno Linux no dispone del programa y el proxy bloquea los endpoints de Google. El detalle del alcance de validacion esta en la guia.

## Versiones anteriores

Informe de compras, servicios y ahorros basado en el Excel y la presentación compartidos.

## Revisión 3: importes de texto y celdas vacías de Google

Corregido el rechazo de valores de texto en Guayaquil y otras columnas numéricas. Se admiten vacíos e importes como `1,234.56` o `1.234,56`. Los errores ambiguos indican hoja, fila y columna. [Solución del error Guayaquil y actualización del PBIX existente](entregables/SOLUCION_GUAYAQUIL.md).

### Formato exacto y conexión Google

Las tarjetas monetarias muestran los importes completos con dos decimales, por ejemplo **USD 356,179.86**, sin abreviarlos en miles. El error “The document must not be an Office file” exige convertir el XLSX de Drive a una hoja nativa y usar su **URL nueva**.

Consulta [la solución paso a paso](entregables/SOLUCION_ERRORES.md). La conexión real con la nueva hoja y la representación en Desktop siguen pendientes de comprobación en el equipo del usuario.

## Descargar

- [Paquete corregido Power BI — revisión 3 (ZIP)](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/Compras_Ecuador_PowerBI_v3.zip)
- [Informe ejecutivo (PDF)](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/Resumen_ejecutivo.pdf)
- [Libro de auditoría (Excel)](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/Auditoria.xlsx)
- [Guía para abrir el proyecto y conectar Google Sheets](entregables/LEEME_CONEXION.md)

Si el navegador muestra una vista previa, usa **Download raw file / Descargar archivo sin procesar**. Para descargar todo el repositorio: **Code → Download ZIP**. Si el repositorio es privado, inicia sesión con una cuenta autorizada.

## Abrir el informe

1. Extrae el paquete completo manteniendo su estructura de carpetas.
2. Abre `Compras.pbip` con Power BI Desktop actualizado en Windows.
3. Pulsa **Actualizar** para cargar la copia incorporada del Excel.
4. Sigue la guía para cambiar `pOrigen` a `GoogleSheets` y autenticarte.
5. Valida el informe y guarda como `.pbix` desde Desktop.

**Formato entregado: proyecto PBIP; no es un PBIX compilado.** Se verificaron las conciliaciones de datos y los esquemas JSON. La ejecución y visualización en Power BI Desktop y la conexión autenticada con Google Sheets están pendientes de validación.

## Resultados del adjunto

| Indicador | USD |
|---|---:|
| Compras — agosto 2026 | 53.587,78 |
| Servicios — agosto 2026 | 302.592,08 |
| Total — agosto 2026 | 356.179,86 |
| Ahorros — enero a agosto 2026 | 15.980,72 |

Compras solo contiene agosto de 2026. El informe identifica 359 registros frente a 358 en FACTURAS, dos filas potencialmente duplicadas y cuatro registros con distribución entre ciudades. Los registros se conservan para revisión. Consulta el libro de auditoría y la guía para conocer los criterios y limitaciones.

Los archivos originales están dentro del ZIP para conservar la trazabilidad. `entregables/SHA256SUMS.txt` permite verificar la integridad de las descargas.
