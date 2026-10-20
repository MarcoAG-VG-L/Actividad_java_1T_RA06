# Informe de la actividad RA06

**Alumno/a:** Marco Antonio  
**Actividad:** Generación, publicación y mantenimiento de documentación de software

## RA06_a — Herramientas generadoras de documentación

### Javadoc

Javadoc es la herramienta del JDK que procesa comentarios estructurados
Javadoc escritos en el código fuente Java y genera documentación navegable,
normalmente en HTML. Las etiquetas como `@param`, `@return` y `@throws`
permiten describir la interfaz pública de clases y métodos. La documentación
queda vinculada al código y puede regenerarse al actualizarlo.

En `Factorial.java` se documenta el método `factorial`: su propósito, el
parámetro entero `number`, el valor devuelto (`BigInteger`) y la excepción
para un argumento no positivo. El HTML se genera en `docs/javadoc/`.

### Javadoc Tools para Visual Studio Code

**Javadoc Tools** es una extensión de Visual Studio Code que ayuda a generar
comentarios Javadoc para clases y métodos Java y a exportar Javadoc. Está
instalada en este entorno (versión 1.8.1). Para localizarla, abre la vista
**Extensiones** (`Ctrl+Shift+X`) y busca `Javadoc Tools`; la ficha instalada
debe mostrar el botón de administración/desinstalación.

### PHPDoc Generator

**PHPDoc Generator** es una extensión de Visual Studio Code que genera un
bloque de documentación PHPDoc para el código PHP, normalmente mediante un
atajo de teclado. PHPDoc describe parámetros, tipos, valores devueltos y
excepciones en comentarios `/** ... */`, para facilitar la lectura y el
soporte del análisis estático y autocompletado. No genera Javadoc ni sustituye
al generador de documentación de Java. Está instalada en este entorno
(versión 1.1.1).

**Capturas:** guarda las capturas reales de las dos fichas instaladas en la
carpeta `capturas/` con los nombres indicados en `capturas/README.md`.

## RA06_b — Documentación de factorial con Javadoc

La función está implementada en `Factorial.java`. Su firma es:

```java
public static BigInteger factorial(int number)
```

- **Descripción:** calcula el factorial de un entero positivo.
- **Parámetro:** `int number`, número positivo cuyo factorial se calcula.
- **Retorno:** un `BigInteger` con el producto de los enteros de 1 a `number`.
- **Validación:** lanza `IllegalArgumentException` cuando el número no es
  positivo.

`BigInteger` evita el desbordamiento que se produciría con tipos enteros de
tamaño fijo para valores relativamente pequeños. El HTML generado desde los
comentarios fuente se encuentra en `docs/javadoc/Factorial.html`.

Para volver a generarlo, ejecuta desde `TAREA_INDIVIDUAL_2`:

```powershell
.\scripts\generar-documentacion.ps1
```

También puede ejecutarse solo Javadoc desde una terminal con el JDK instalado:

```powershell
javadoc -encoding UTF-8 -docencoding UTF-8 -charset UTF-8 -d docs/javadoc Factorial.java
```

## RA06_c — Otros formatos

La documentación de clase generada por Javadoc se entrega en DOCX, ODT, XML y
PDF en `docs/formatos/`. El PDF se imprime desde la página HTML de clase con
Microsoft Edge; DOCX y ODT son documentos OpenDocument Office empaquetados, y
XML presenta los mismos datos documentados en una estructura legible por
máquinas. Se eligió DOCX (en lugar del antiguo DOC binario).

Archivos entregados:

- `docs/formatos/Factorial.docx`
- `docs/formatos/Factorial.odt`
- `docs/formatos/Factorial.xml`
- `docs/formatos/Factorial.pdf`

Los formatos pueden regenerarse con el script indicado en RA06_b. Se requiere
un JDK y Microsoft Edge; Word no es necesario.

## RA06_d, RA06_e y RA06_f — Git, GitHub y seguridad/accesibilidad

### Crear la cuenta y el repositorio GitHub

1. Accede a [https://github.com/](https://github.com/) y crea una cuenta o
   inicia sesión.
2. Crea un repositorio llamado `documentacion-ra06` (o un nombre equivalente).
   Si se crea desde cero, no inicialices allí otro README: ya existe uno local.
3. Para una entrega académica privada, selecciona **Private** y añade al
   profesor como colaborador. Si el profesor debe acceder sin invitación, usa
   un repositorio **Public** solo después de revisar que no contenga datos
   personales, credenciales ni información privada.

### Instalar y configurar Git

Git for Windows ya está instalado en el equipo usado para preparar la actividad.
En otro equipo, se puede instalar desde [https://git-scm.com/download/win](https://git-scm.com/download/win).
Comprueba la instalación en PowerShell:

```powershell
git --version
```

Configura el nombre y correo que deben asociarse a los commits, sustituyendo
los valores de ejemplo por los de la cuenta del alumno:

```powershell
git config --global user.name "Marco Antonio"
git config --global user.email "TU_CORREO_DE_GITHUB"
```

En PowerShell, entra en la carpeta `TAREA_INDIVIDUAL_2`, inicializa el
repositorio local y enlázalo al repositorio remoto recién creado (reemplaza la
URL por la URL HTTPS real):

```powershell
git init
git branch -M main
git remote add origin https://github.com/TU_USUARIO/documentacion-ra06.git
```

Si Git solicita autenticación HTTPS, utiliza el navegador/administrador de
credenciales de GitHub o un token introducido de forma segura en el diálogo de
autenticación. **No** escribas tokens en comandos, archivos fuente o el informe.

### Actualizaciones del repositorio (dos entregas)

Para reflejar la entrega progresiva pedida en RA06_f, el primer commit contiene
el código, README, informe, configuración y HTML; en una segunda actualización
se añaden las exportaciones PDF/DOCX/ODT/XML:

```powershell
git add Factorial.java README.md informe scripts docs/javadoc .gitignore
git commit -m "Publica documentación HTML de Factorial"
git push -u origin main

git add docs/formatos
git commit -m "Añade documentación en PDF y otros formatos"
git push
```

El primer envío publica el HTML; el segundo añade PDF/DOCX/ODT/XML, cumpliendo
la actualización progresiva solicitada. No añadas secretos ni archivos
temporales.

### Accesibilidad y seguridad

- Concede únicamente el acceso necesario; para un repositorio privado, invita
  al docente como colaborador en vez de publicar toda la cuenta.
- Revisa el contenido antes de cada `git push`. Usa `.gitignore` y nunca
  incluyas contraseñas, tokens, claves privadas, datos personales innecesarios
  o archivos `.env`.
- Protege la cuenta con contraseña única y autenticación multifactor.
- Mantén Git, el sistema operativo y el editor actualizados.
- Verifica desde la web de GitHub que los archivos y permisos sean correctos.
- Los commits no sustituyen a una copia de seguridad ni eliminan por completo
  secretos que ya se hayan subido; si se filtra un token, revócalo de inmediato.

## RA06_g — Registro de instalación, configuración y uso

El procedimiento reproducible está descrito en RA06_d/e/f de este informe:
instalación/verificación de Git, configuración del autor, inicialización,
conexión HTTPS al repositorio remoto, commits y `push` de dos actualizaciones,
y medidas de permisos y protección de datos. Los comandos usan placeholders
para el usuario, correo y URL porque dependen de la cuenta personal.

## RA06_h — Integración continua con GitLab

La carpeta `gitlab-pipeline/` es un proyecto independiente para subir a GitLab.
Su `.gitlab-ci.yml` define una etapa y un trabajo que ejecuta exactamente:

```yaml
echo "Pipeline de prueba de Marco Antonio"
```

Pasos:

1. Accede a [https://gitlab.com/](https://gitlab.com/) e inicia sesión.
2. Crea un proyecto en blanco llamado **pipeline de Marco Antonio**.
3. Sube `gitlab-pipeline/README.md` y `gitlab-pipeline/.gitlab-ci.yml` a la
   raíz del proyecto (mediante la web o Git).
4. Abre **Build > Pipelines** y espera a que el trabajo `mensaje` termine con
   estado **Passed**.
5. Abre el trabajo y comprueba que el registro muestra
   `Pipeline de prueba de Marco Antonio`.
6. Guarda la captura del pipeline exitoso en `capturas/` siguiendo los nombres
   de `capturas/README.md`.

El repositorio GitLab, su ejecución y su captura dependen del acceso a la
cuenta del alumno y no pueden acreditarse hasta que se complete este paso.
