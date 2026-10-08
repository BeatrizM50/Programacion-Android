import 'package:flutter/material.dart';

// Modelo de datos ReNotes. Todo vive en memoria.

/// Proyecto de investigación. Tiene cero o muchas notas.
class Proyecto {
  final String id;
  String nombre;
  String descripcion;
  final DateTime creada;
  DateTime modificada;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.creada,
    required this.modificada,
  });
}

/// Nota. Pertenece a un solo proyecto, tiene cero o muchas etiquetas.
class Nota {
  final String id;
  String proyectoId;
  String titulo;
  String descripcion;
  final DateTime creada;
  DateTime modificada;
  List<String> etiquetaIds;

  Nota({
    required this.id,
    required this.proyectoId,
    required this.titulo,
    required this.descripcion,
    required this.creada,
    required this.modificada,
    required List<String> etiquetaIds,
  }) : etiquetaIds = List.of(etiquetaIds);
}

/// Etiqueta global. No pertenece a ningún proyecto.
/// El nombre es único según comparación normalizada (ver utils.dart).
class Etiqueta {
  final String id;
  String nombre;
  Color? color;

  Etiqueta({required this.id, required this.nombre, this.color});
}
