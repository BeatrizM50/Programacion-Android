# ExRE — Explorador de Recursos de Estudio

## Descripción

ExRE (Explorador de Recursos de Estudio) es una aplicación móvil desarrollada con Flutter para Android.

La aplicación permite explorar recursos de estudio organizados por categorías, buscar recursos, agregarlos a favoritos y registrar el progreso de estudio.

## Tecnologías utilizadas

- Flutter
- Dart
- Android
- Material Design

## Ejecución

Requisitos: tener [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
(`sdk: ^3.13.2`) y, para Android, Android Studio con un dispositivo o emulador configurado.

```bash
# 1. Descargar dependencias
flutter pub get

# 2. Ver dispositivos disponibles
flutter devices

# 3. Ejecutar la aplicación (en vivo/hot reload)
flutter run
```

Para generar el APK de release (queda en
`build/app/outputs/flutter-apk/app-release.apk`):

```bash
flutter build apk --release
```

También es posible instalar directamente el APK incluido en la raíz del proyecto
(`ExRE.apk`) copiándolo al dispositivo y abriéndolo para instalarlo.

Para ejecutar las pruebas y el análisis estático:

```bash
flutter analyze
flutter test
```

## Funcionalidades

La aplicación cuenta con seis pantallas principales:

1. Inicio
2. Catálogo
3. Galería
4. Detalle
5. Favoritos
6. Progreso

### Inicio

Permite visualizar:

- Nombre y propósito de la aplicación.
- Estado actual del ciclo de vida.
- Accesos rápidos.
- Cantidad de recursos.
- Cantidad de favoritos.
- Cantidad de recursos completados.
- Historial reciente del ciclo de vida.

### Catálogo

Permite:

- Visualizar los recursos de estudio.
- Buscar por título, categoría o autor.
- Filtrar por categoría.
- Abrir el detalle de un recurso.
- Agregar o quitar favoritos.

### Galería

Permite visualizar los recursos mediante una cuadrícula de dos columnas.

También permite:

- Abrir el detalle de un recurso.
- Agregar o quitar favoritos.
- Identificar recursos completados.

### Detalle

Muestra:

- Título.
- Categoría.
- Autor.
- Duración.
- Nivel.
- Tipo de recurso.
- Descripción.
- Contenido.
- Estado de favorito.
- Estado de completado.

### Favoritos

Muestra los recursos marcados como favoritos y permite acceder nuevamente a su detalle o eliminarlos de favoritos.

### Progreso

Permite visualizar:

- Porcentaje general de progreso.
- Recursos completados.
- Recursos pendientes.
- Resumen por categoría.
- Recursos completados.
- Último evento del ciclo de vida.
- Historial del ciclo de vida.

## Organización del proyecto

El código está organizado en diferentes carpetas:

```text
lib/
├── datos/
│   └── recursos.dart
│
├── estado/
│   └── app_state.dart
│
├── modelos/
│   └── recurso.dart
│
├── pantallas/
│   ├── inicio.dart
│   ├── catalogo.dart
│   ├── galeria.dart
│   ├── detalle.dart
│   ├── favoritos.dart
│   └── progreso.dart
│
├── widgets/
│   └── boton_de_navegacion.dart
│
└── main.dart
```
