import 'package:flutter/material.dart';

// Piezas editoriales compartidas (tema claro/oscuro):
// antetítulo en versalitas, píldoras de conteo y resaltado de búsqueda.

/// Antetítulo en versalitas color primario (p. ej. "RENOTES ACADEMIC").
class Antetitulo extends StatelessWidget {
  final String texto;
  const Antetitulo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.12,
      ),
    );
  }
}

/// Título de AppBar con antetítulo encima (estilo mockups).
class TituloAppBar extends StatelessWidget {
  final String antetitulo;
  final String titulo;
  const TituloAppBar({
    super.key,
    required this.antetitulo,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Antetitulo(antetitulo),
        Text(
          titulo,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Píldora de conteo (p. ej. "8 activas", "4 hallazgos").
class PildoraConteo extends StatelessWidget {
  final String texto;
  const PildoraConteo(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: scheme.onSecondaryContainer,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Resalta la primera ocurrencia de [query] (insensible a mayúsculas).
TextSpan resaltadoBusqueda(
  BuildContext context,
  String texto,
  String query, {
  TextStyle? estilo,
}) {
  final base =
      estilo ??
      DefaultTextStyle.of(context).style.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
  final q = query.trim();
  if (q.isEmpty) return TextSpan(text: texto, style: base);
  final idx = texto.toLowerCase().indexOf(q.toLowerCase());
  if (idx < 0) return TextSpan(text: texto, style: base);
  final scheme = Theme.of(context).colorScheme;
  return TextSpan(
    style: base,
    children: [
      TextSpan(text: texto.substring(0, idx)),
      TextSpan(
        text: texto.substring(idx, idx + q.length),
        style: base.copyWith(
          backgroundColor: scheme.primaryContainer.withValues(alpha: 0.7),
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
      TextSpan(text: texto.substring(idx + q.length)),
    ],
  );
}

/// Tiempo estimado de lectura ("3 min lect.").
String tiempoLectura(String texto) {
  final palabras = texto.trim().isEmpty
      ? 0
      : texto.trim().split(RegExp(r'\s+')).length;
  final min = (palabras / 200).ceil().clamp(1, 999);
  return '$min min lect.';
}
