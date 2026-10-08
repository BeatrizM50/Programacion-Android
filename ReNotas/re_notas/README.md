# ReNotes — Notas de Investigación

Aplicación Flutter para organizar el trabajo de investigación en proyectos,
escribir notas largas dentro de cada proyecto y clasificarlas con etiquetas
globales que el usuario crea y reutiliza.

Sin servidor, sin base de datos, sin almacenamiento local y sin autenticación:
todos los datos viven en memoria mientras la app está en ejecución y se cargan
desde datos de prueba incluidos en el proyecto al iniciarla.

## Requisitos

- Flutter 3.13+ (probado con Flutter 3.47, Dart 3.13).
- Android SDK para compilar el APK, o Chrome para ejecutar en web.
- No se necesita nada más: el proyecto **no usa paquetes externos**
  (solo `cupertino_icons` y `flutter_lints` del template).

## Inicializar y ejecutar

```bash
cd re_notas
flutter pub get
flutter run              # emulador o dispositivo Android conectado
flutter run -d chrome    # alternativa: ejecutar en web
```

Elegir un dispositivo concreto:

```bash
flutter devices
flutter run -d <id_dispositivo>
```

Compilar el APK de Android:

```bash
flutter build apk --debug
# El APK queda en build/app/outputs/flutter-apk/app-debug.apk
```

Verificar el proyecto (análisis estático + pruebas):

```bash
flutter analyze
flutter test
```

## Uso de la app

- **Proyectos**: lista de proyectos con nº de notas y última modificación.
  Botón `Nuevo Proyecto` para crear (nombre obligatorio), menú `⋮` para
  editar o eliminar (con confirmación; borra sus notas, conserva etiquetas).
- **Notas del proyecto**: al tocar un proyecto. Buscador por título/contenido,
  chips de filtro (`Todas` + etiquetas del proyecto), botón `Nueva Nota`.
  El menú `⋯` de cada nota permite abrir, editar o eliminar (confirmada).
- **Editor de nota**: título obligatorio con validación, descripción larga
  multilínea con contador de caracteres y etiquetas con autocompletado:
  escribe para ver sugerencias (ignora mayúsculas y acentos), tócala para
  asignarla, o crea una nueva con Enter, coma o la opción `Crear etiqueta`.
  Si sales con cambios sin guardar, la app te avisa.
- **Detalle de nota**: fechas, proyecto, tiempo de lectura, descripción
  completa, etiquetas (tócalas para ver notas cruzadas de todos los
  proyectos), botones Editar, Eliminar y Volver.
- **Etiquetas**: índice temático con contador de notas por etiqueta, botón
  `Nueva`, buscador, modo `Al menos una (OR)` / `Todas (AND)` y
  `Notas coincidentes` de todos los proyectos. Menú `⋮` por etiqueta para
  renombrar (rechaza duplicados) o eliminar (indica notas afectadas).
- **Buscar**: búsqueda global con filtros por proyecto y etiquetas clave,
  término resaltado en los resultados y actualización inmediata.
- El botón **sol/luna** del `AppBar` alterna entre tema claro y oscuro.

## Estructura del código

```text
lib/
  main.dart                    # App + tema claro/oscuro (solo SDK)
  models.dart                  # Proyecto, Nota, Etiqueta
  app_state.dart               # Estado en memoria + datos de prueba + ThemeMode
  app_theme.dart               # Paletas editorial clara y oscura (minimalista)
  utils.dart                   # Normalización, extractos, fechas
  home_shell.dart              # BottomNavigationBar (Proyectos/Etiquetas/Buscar)
  widgets/
    tag_chip.dart              # Chips reutilizables de etiqueta
    theme_toggle.dart          # Botón claro/oscuro
    encabezado.dart            # Antetítulos, píldoras de conteo, resaltado
  screens/
    proyectos_screen.dart      # RF1 (ListView.builder)
    notas_proyecto_screen.dart # RF2 (ListView.builder + ListView.separated)
    editor_nota_screen.dart    # RF3 (Autocomplete + Enter/coma + crear)
    detalle_nota_screen.dart   # RF4
    etiquetas_screen.dart      # RF5 (ListView.builder)
    buscar_screen.dart         # RF6 (ListView.separated)
test/
  widget_test.dart             # Datos de prueba, unicidad, cascada, texto largo
```

## Diseño y temas

- Estilo **editorial minimalista**: capas tonales planas, bordes hairline de
  1px, radios 8/16/píldora, sin sombras duras; cabeceras con antetítulo en
  versalitas (`Renotes Academic`, `Cuaderno de estudio`).
- **Tema claro** "Academic Editorial Notebook": marfil `#FFF8F7`, primario
  terracota `#954335`, texto burdeos `#360C17`.
- **Tema oscuro** "Academic Deep Wine Minimal": vino `#200E14`, primario
  melocotón `#FFB4A7`, texto marfil `#FDD9E2`.

## Decisiones técnicas

- **Estado solo con el SDK**: `ChangeNotifier` + `ListenableBuilder`.
- **Un solo método de navegación**: `Navigator.push` / `pop` en toda la app.
- Cada pestaña conserva su estado (`IndexedStack` +
  `AutomaticKeepAliveClientMixin` + `PageStorageKey`).
- Etiquetas globales con nombre único normalizado (minúsculas, sin acentos,
  sin espacios extra): `Metodología` = `metodologia` = `METODOLOGIA`.
- Datos de prueba: 3 proyectos, 15 notas (5 por proyecto), 8 etiquetas
  (3 usadas en varios proyectos, 1 sin uso), 5 notas de más de 600
  caracteres y 1 nota sin etiquetas.

## Capturas de pantalla

Carpeta `Capturas de Pantalla/`: las seis pantallas más el autocompletado
de etiquetas en funcionamiento.
