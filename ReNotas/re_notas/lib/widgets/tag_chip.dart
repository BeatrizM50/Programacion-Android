import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';

// Chip de etiqueta minimalista: píldora tonal con punto de color.
// Pasa a la línea siguiente con Wrap cuando no cabe.

class TagChip extends StatelessWidget {
  final AppState appState;
  final String etiquetaId;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;

  const TagChip({
    super.key,
    required this.appState,
    required this.etiquetaId,
    this.onTap,
    this.onDeleted,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Etiqueta? e = appState.etiquetaPorId(etiquetaId);
    if (e == null) return const SizedBox.shrink();
    final bg = selected ? scheme.primary : scheme.surfaceContainerHigh;
    final fg = selected ? scheme.onPrimary : scheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(e.nombre, style: TextStyle(color: fg, fontSize: 12)),
        avatar: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? fg : (e.color ?? scheme.primary),
            shape: BoxShape.circle,
          ),
        ),
        backgroundColor: bg,
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
        ),
        deleteIcon: onDeleted != null
            ? Icon(Icons.close, size: 16, color: fg)
            : null,
        onDeleted: onDeleted,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

/// Punto de color de la etiqueta para listas.
class TagDot extends StatelessWidget {
  final Etiqueta etiqueta;
  const TagDot({super.key, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: etiqueta.color ?? Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
