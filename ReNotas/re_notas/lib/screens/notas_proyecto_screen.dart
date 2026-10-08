import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/tag_chip.dart';
import '../widgets/theme_toggle.dart';
import 'detalle_nota_screen.dart';
import 'editor_nota_screen.dart';

// RF2. Notas del proyecto.
// Usa ListView.builder (notas) y ListView.separated (filtros).
// Estilo mockups: tarjeta de proyecto, chips Todas/#etiqueta, FAB extendido.

class NotasProyectoScreen extends StatefulWidget {
  final AppState appState;
  final String proyectoId;
  const NotasProyectoScreen({
    super.key,
    required this.appState,
    required this.proyectoId,
  });

  @override
  State<NotasProyectoScreen> createState() => _NotasProyectoScreenState();
}

class _NotasProyectoScreenState extends State<NotasProyectoScreen> {
  final TextEditingController _busqueda = TextEditingController();
  final Set<String> _filtroEtiquetas = {};
  String _texto = '';

  @override
  void initState() {
    super.initState();
    _busqueda.addListener(() => setState(() => _texto = _busqueda.text));
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  List<Nota> _filtradas(List<Nota> todas) {
    final q = normalizarEtiqueta(_texto);
    return todas.where((n) {
      final okTexto =
          q.isEmpty ||
          normalizarEtiqueta(n.titulo).contains(q) ||
          normalizarEtiqueta(n.descripcion).contains(q);
      final okTags =
          _filtroEtiquetas.isEmpty ||
          _filtroEtiquetas.every((id) => n.etiquetaIds.contains(id));
      return okTexto && okTags;
    }).toList();
  }

  Future<void> _confirmarEliminar(Nota n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('Se eliminará "${n.titulo}". ¿Continuar?'),
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
    if (ok == true) widget.appState.eliminarNota(n.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final proyecto = widget.appState.proyectoPorId(widget.proyectoId);
        if (proyecto == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Proyecto no encontrado.')),
          );
        }
        final todas = widget.appState.notasDeProyecto(proyecto.id);
        final visibles = _filtradas(todas);
        final etiquetasFiltro = widget.appState.etiquetasDeProyecto(
          proyecto.id,
        );

        return Scaffold(
          appBar: AppBar(
            title: const TituloAppBar(
              antetitulo: 'Cuaderno de estudio',
              titulo: 'Detalle de Proyecto',
            ),
            actions: [ThemeToggleButton(appState: widget.appState)],
          ),
          body: Column(
            children: [
              // Tarjeta del proyecto (mockup).
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Antetitulo(proyecto.nombre),
                        const Spacer(),
                        PildoraConteo('${todas.length} notas'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      proyecto.nombre,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.01,
                      ),
                    ),
                    if (proyecto.descripcion.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        proyecto.descripcion,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _busqueda,
                  decoration: InputDecoration(
                    hintText: 'Buscar en este proyecto…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _texto.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _busqueda.clear(),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (etiquetasFiltro.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: etiquetasFiltro.length + 1, // +1 chip Todas
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        final todasSel = _filtroEtiquetas.isEmpty;
                        return _ChipFiltro(
                          texto: 'Todas',
                          seleccionado: todasSel,
                          onTap: () =>
                              setState(() => _filtroEtiquetas.clear()),
                        );
                      }
                      final e = etiquetasFiltro[i - 1];
                      final sel = _filtroEtiquetas.contains(e.id);
                      return _ChipFiltro(
                        texto: '#${e.nombre}',
                        seleccionado: sel,
                        onTap: () {
                          setState(() {
                            if (sel) {
                              _filtroEtiquetas.remove(e.id);
                            } else {
                              _filtroEtiquetas.add(e.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: visibles.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            todas.isEmpty
                                ? 'Este proyecto no tiene notas.\nCrea la primera con «Nueva Nota».'
                                : 'Sin resultados para los filtros actuales.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    // Obligatorio: ListView.builder.
                    : ListView.builder(
                        key: PageStorageKey('notas_${proyecto.id}'),
                        itemCount: visibles.length,
                        padding: const EdgeInsets.only(bottom: 88),
                        itemBuilder: (context, i) {
                          final n = visibles[i];
                          final primera = n.etiquetaIds.isEmpty
                              ? null
                              : widget.appState.etiquetaPorId(
                                  n.etiquetaIds.first,
                                );
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetalleNotaScreen(
                                      appState: widget.appState,
                                      notaId: n.id,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Antetitulo(
                                            primera?.nombre ??
                                                'Nota de investigación',
                                          ),
                                        ),
                                        Text(
                                          formatoFechaCorta(n.modificada),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 18,
                                            color: scheme.onSurfaceVariant,
                                          ),
                                          onSelected: (v) {
                                            if (v == 'abrir') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      DetalleNotaScreen(
                                                        appState:
                                                            widget.appState,
                                                        notaId: n.id,
                                                      ),
                                                ),
                                              );
                                            } else if (v == 'editar') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditorNotaScreen(
                                                        appState:
                                                            widget.appState,
                                                        proyectoId:
                                                            proyecto.id,
                                                        notaId: n.id,
                                                      ),
                                                ),
                                              );
                                            } else if (v == 'eliminar') {
                                              _confirmarEliminar(n);
                                            }
                                          },
                                          itemBuilder: (_) => const [
                                            PopupMenuItem(
                                              value: 'abrir',
                                              child: Text('Abrir'),
                                            ),
                                            PopupMenuItem(
                                              value: 'editar',
                                              child: Text('Editar'),
                                            ),
                                            PopupMenuItem(
                                              value: 'eliminar',
                                              child: Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      n.titulo,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      extracto(n.descripcion, 140),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (n.etiquetaIds.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          for (final id in n.etiquetaIds)
                                            TagChip(
                                              appState: widget.appState,
                                              etiquetaId: id,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditorNotaScreen(
                    appState: widget.appState,
                    proyectoId: proyecto.id,
                  ),
                ),
              );
            },
            tooltip: 'Nueva nota',
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Nueva Nota'),
          ),
        );
      },
    );
  }
}

/// Chip de filtro estilo mockup (píldora, seleccionado en primario).
class _ChipFiltro extends StatelessWidget {
  final String texto;
  final bool seleccionado;
  final VoidCallback onTap;
  const _ChipFiltro({
    required this.texto,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: seleccionado
              ? scheme.primary
              : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: seleccionado ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: seleccionado ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
