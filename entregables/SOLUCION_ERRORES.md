# Corrección de importes y conexión — revisión 2

## 1. Total exacto
El importe conciliado es **USD 356,179.86** (compras 53,587.78 + servicios 302,592.08). La primera versión dejaba las tarjetas con unidades automáticas. Eso podía abreviar el total en miles; fue una omisión de formato. No se ha detectado una diferencia en la suma del modelo.

La revisión 2 fija unidades sin escala y dos decimales. Las tarjetas monetarias muestran texto numérico con el formato exacto `356,179.86`; los cálculos siguen usando las medidas numéricas con decimal fijo.

Descarga y extrae la revisión 2 en una carpeta nueva para evitar mezclar definiciones con el proyecto anterior. Abre Compras.pbip y Actualizar; primero verifica con pOrigen=Snapshot.

Si corriges tu PBIX existente: selecciona la tarjeta, ve a Formato visual > Etiqueta de datos o Valor destacado, pon Unidades de visualización = Ninguno y Decimales = 2. Repite en ejes y etiquetas de gráficos. Dos representaciones equivalentes son 356,179.86 y 356.179,86; 356,18 con escala de miles es una abreviación, no el importe completo.

## 2. Error “The document must not be an Office file”
Ese error significa que el conector recibe un XLSX de Drive, aunque se vea dentro del editor de Google. No significa que las tablas Compras/Ahorros hayan perdido datos. DistribucionCiudad depende de Compras y falla en cascada.

1. Abre el archivo original en Google Sheets desde Drive, con una cuenta con permiso para convertir/guardar una copia.
2. Usa **Archivo > Guardar como Hojas de cálculo de Google**. Si partes de Drive, primero Abrir con > Hojas de cálculo de Google. Otra ruta es crear una hoja nativa nueva e importar el XLSX en ella, comprobando ambas pestañas.
3. Se crea otro documento. Abre ese documento nuevo y **copia su URL nueva**. No reutilices el enlace del XLSX, no lo renombres para simular una conversión y no publiques los datos en la web.
4. Comprueba las pestañas `BASE KPIS` y `AHORROS`, sus encabezados y los importes antes de conectarlo.
5. En Power BI: **Transformar datos > Administrar parámetros**. Pega la URL nueva en `pGoogleSheetsURL` y cambia `pOrigen` a `GoogleSheets`.
6. Inicia sesión con Google cuando Power BI lo solicite. Si conservó la conexión anterior, revisa **Configuración de origen de datos** y corrige/borra únicamente los permisos de la URL antigua; vuelve a autenticar la URL nueva. Borrar credenciales por sí solo no convierte el archivo.
7. Cerrar y aplicar > Actualizar. Verifica el total 356,179.86 si no agregaste ni modificaste registros, las 359 filas y los ahorros 15,980.72.

No se necesita hacer público el archivo. Si no tienes permiso para convertirlo, pide al propietario una copia nativa compartida con tu cuenta. La conexión real y la representación en Power BI Desktop requieren esa comprobación en tu equipo; no han sido ejecutadas en el entorno Linux de generación.

## Trabajo inmediato mientras se convierte
Mantén pOrigen=Snapshot para revisar los datos adjuntos. O usa pOrigen=Excel con pRutaExcel apuntando a la copia local del XLSX. Esos modos no sincronizan Google y no sustituyen la conexión final.
