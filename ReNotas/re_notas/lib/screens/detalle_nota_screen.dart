import 'package:flutter/material.dart';

import '../app_state.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/tag_chip.dart';
import '../widgets/theme_toggle.dart';
import 'editor_nota_screen.dart';
import 'etiquetas_screen.dart';

// RF4. Detalle de nota.
// Estilo mockups: antetítulo del proyecto, píldora de lectura,
// fechas, acciones, citas con acento lateral y navegación.

class DetalleNotaScreen extends StatelessWidget {
  final AppState appState;
  final String notaId;
  const DetalleNotaScreen({
    super.key,
    required this.appState,
    required this.notaId,
  });

  Future<void> _confirmarEliminar(BuildContext context, String titulo) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('Se eliminará "$titulo". ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      appState.eliminarNota(notaId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final nota = appState.notaPorId(notaId);
        if (nota == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Nota no encontrada.')),
          );
        }
        final proyecto = appState.proyectoPorId(nota.proyectoId);
        final parrafos = nota.descripcion
            .split(RegExp(r'\n\s*\n|\n'))
            .map((p) => p.trim())
            .where((p) => p.isNotEmpty)
            .toList();
        return Scaffold(
          appBar: AppBar(
            title: const TituloAppBar(
              antetitulo: 'Cuaderno de estudio',
              titulo: 'Detalle de Nota',
            ),
            actions: [ThemeToggleButton(appState: appState)],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Antetitulo(
                          proyecto?.nombre ?? 'Proyecto',
                        ),
                      ),
                      PildoraConteo(tiempoLectura(nota.descripcion)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Creada: ${formatoFechaCorta(nota.creada)}   ·   Revisada: ${formatoFecha(nota.modificada)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nota.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.015,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Acciones (mockup).
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Editar nota'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditorNotaScreen(
                                  appState: appState,
                                  proyectoId: nota.proyectoId,
                                  notaId: nota.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Eliminar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.error,
                            side: BorderSide(
                              color: scheme.error.withValues(alpha: 0.5),
                            ),
                          ),
                          onPressed: () =>
                              _confirmarEliminar(context, nota.titulo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (nota.etiquetaIds.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final id in nota.etiquetaIds)
                          TagChip(
                            appState: appState,
                            etiquetaId: id,
                            onTap: () {
                              // Abre Etiquetas filtrada por esa etiqueta.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EtiquetasScreen(
                                    appState: appState,
                                    filtroInicialEtiquetaId: id,
                                  ),
                                ),
                              );
                            },
                          ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditorNotaScreen(
                                  appState: appState,
                                  proyectoId: nota.proyectoId,
                                  notaId: nota.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            child: Text(
                              '+ Etiqueta',
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (nota.etiquetaIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Toca una etiqueta para consultar referencias cruzadas de todos los proyectos.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (parrafos.isEmpty)
                    Text(
                      'Sin descripción.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  for (final p in parrafos)
                    _ParrafoDetalle(texto: p),
                  const SizedBox(height: 20),
                  // Pie: proyecto + volver.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Antetitulo('Ecosistema del cuaderno'),
                              Text(
                                proyecto?.nombre ?? '—',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PildoraConteo(
                          '${appState.cantidadNotasDeProyecto(nota.proyectoId)} notas',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Párrafo del detalle: los que parecen cita («…» o "…") llevan
/// fondo tonal y acento lateral (mockup).
class _ParrafoDetalle extends StatelessWidget {
  final String texto;
  const _ParrafoDetalle({required this.texto});

  bool get esCita {
    final t = texto.trim();
    return (t.startsWith('«') && t.contains('»')) ||
        (t.startsWith('"') && t.length > 80);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!esCita) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 15, height: 1.65),
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: scheme.primary, width: 3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          fontStyle: FontStyle.italic,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
