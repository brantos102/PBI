# Compras Ecuador — Power BI

Informe de compras, servicios y ahorros basado en el Excel y la presentación compartidos.

## Revisión 2: importes completos y conexión Google

Las tarjetas monetarias muestran los importes completos con dos decimales, por ejemplo **USD 356,179.86**, sin abreviarlos en miles. El error “The document must not be an Office file” exige convertir el XLSX de Drive a una hoja nativa y usar su **URL nueva**.

Consulta [la solución paso a paso](entregables/SOLUCION_ERRORES.md). La conexión real con la nueva hoja y la representación en Desktop siguen pendientes de comprobación en el equipo del usuario.

## Descargar

- [Paquete corregido Power BI — revisión 2 (ZIP)](https://github.com/brantos102/PBI/raw/refs/heads/main/entregables/Compras_Ecuador_PowerBI_v2.zip)
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
