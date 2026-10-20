# RA06 — Generación y mantenimiento de documentación

Trabajo práctico realizado por **Marco Antonio**.

## Contenido

- `Factorial.java`: función de factorial documentada con Javadoc.
- `docs/javadoc/`: documentación HTML generada a partir de los comentarios Javadoc.
- `docs/formatos/`: exportaciones DOCX, ODT, XML y PDF.
- `informe/INFORME_RA06.md`: explicación de RA06_a a RA06_h y pasos reproducibles.
- `scripts/generar-documentacion.ps1`: regeneración del HTML y de los otros formatos.
- `gitlab-pipeline/`: ejemplo listo para subir a un proyecto GitLab y ejecutar CI.
- `capturas/`: guía y nombres de las capturas que faltan por obtener en las cuentas personales.

## Generar de nuevo

Desde PowerShell, situado en esta carpeta:

```powershell
.\scripts\generar-documentacion.ps1
```

Se requiere un JDK que incluya `javadoc` y Microsoft Edge para exportar PDF.
DOCX, ODT y XML se crean con PowerShell y no requieren Microsoft Word. La ruta
al ejecutable de Javadoc puede indicarse mediante `$env:JAVADOC_EXE`.

## Importante

Las extensiones **Javadoc Tools** (1.8.1) y **PHPDoc Generator** (1.1.1) se
instalaron en Visual Studio Code. La creación del repositorio remoto y las
capturas de GitHub/GitLab requieren iniciar sesión con la cuenta personal del
alumno; no se almacenan contraseñas ni tokens en estos archivos.
