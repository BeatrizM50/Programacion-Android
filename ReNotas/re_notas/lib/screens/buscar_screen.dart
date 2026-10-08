import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/tag_chip.dart';
import '../widgets/theme_toggle.dart';
import 'detalle_nota_screen.dart';

// RF6. Búsqueda global. Resultados con ListView.separated obligatorio.
// Estilo mockups: índice y concordancias, chips de proyecto/etiqueta,
// resumen de hallazgos y término resaltado en los resultados.

class BuscarScreen extends StatefulWidget {
  final AppState appState;
  const BuscarScreen({super.key, required this.appState});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _busqueda = TextEditingController();
  String _texto = '';
  String? _filtroProyectoId; // null = todos
  final Set<String> _filtroEtiquetas = {};

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

  List<Nota> _resultados() {
    final q = normalizarEtiqueta(_texto);
    return widget.appState.notas.where((n) {
      final okTexto =
          q.isEmpty ||
          normalizarEtiqueta(n.titulo).contains(q) ||
          normalizarEtiqueta(n.descripcion).contains(q);
      final okProyecto =
          _filtroProyectoId == null || n.proyectoId == _filtroProyectoId;
      final okTags =
          _filtroEtiquetas.isEmpty ||
          _filtroEtiquetas.every((id) => n.etiquetaIds.contains(id));
      return okTexto && okProyecto && okTags;
    }).toList()
      ..sort((a, b) => b.modificada.compareTo(a.modificada));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const TituloAppBar(
          antetitulo: 'Renotes Academic',
          titulo: 'Buscar',
        ),
        actions: [ThemeToggleButton(appState: widget.appState)],
      ),
      body: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          final resultados = _resultados();
          final nProyectos = resultados
              .map((n) => n.proyectoId)
              .toSet()
              .length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Row(
                  children: [
                    const Antetitulo('Índice & concordancias'),
                    const Spacer(),
                    PildoraConteo(
                      '${resultados.length} hallazgo(s)',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _busqueda,
                  decoration: InputDecoration(
                    hintText: 'Buscar en todas las notas…',
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
              // Filtro por proyecto (chips horizontales, mockup).
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Row(
                  children: [
                    const Antetitulo('Proyectos'),
                    const Spacer(),
                    if (_filtroProyectoId != null)
                      GestureDetector(
                        onTap: () =>
                            setState(() => _filtroProyectoId = null),
                        child: Text(
                          'Todos',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.appState.proyectos.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _ChipFiltro(
                        texto: 'Todos',
                        seleccionado: _filtroProyectoId == null,
                        onTap: () =>
                            setState(() => _filtroProyectoId = null),
                      );
                    }
                    final p = widget.appState.proyectos[i - 1];
                    return _ChipFiltro(
                      texto: p.nombre,
                      seleccionado: _filtroProyectoId == p.id,
                      onTap: () => setState(
                        () => _filtroProyectoId =
                            _filtroProyectoId == p.id ? null : p.id,
                      ),
                    );
                  },
                ),
              ),
              // Filtro por etiquetas (mockup "Etiquetas clave").
              if (widget.appState.etiquetas.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Row(
                    children: [
                      const Antetitulo('Etiquetas clave'),
                      const Spacer(),
                      if (_filtroEtiquetas.isNotEmpty)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _filtroEtiquetas.clear()),
                          child: Text(
                            'Limpiar',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.appState.etiquetas.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final e = widget.appState.etiquetas[i];
                      final sel = _filtroEtiquetas.contains(e.id);
                      return _ChipFiltro(
                        texto: sel ? '#${e.nombre} ✓' : '#${e.nombre}',
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
              ],
              // Resumen de hallazgos (mockup).
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Text(
                    '${resultados.length} nota(s) encontrada(s) en $nProyectos proyecto(s). Se actualizan al crear, editar o eliminar.',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: resultados.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Sin resultados.\nPrueba con otro texto o ajusta los filtros.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    // Obligatorio: ListView.separated.
                    : ListView.separated(
                        key: const PageStorageKey('resultados_buscar'),
                        itemCount: resultados.length,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final n = resultados[i];
                          final proyecto = widget.appState.proyectoPorId(
                            n.proyectoId,
                          );
                          return Container(
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
                                        Icon(
                                          Icons.folder_outlined,
                                          size: 14,
                                          color: scheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Antetitulo(
                                            proyecto?.nombre ?? 'Proyecto',
                                          ),
                                        ),
                                        Text(
                                          formatoFechaCorta(n.modificada),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      n.titulo,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: resaltadoBusqueda(
                                        context,
                                        extracto(n.descripcion, 140),
                                        _texto,
                                      ),
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
          );
        },
      ),
    );
  }
}

/// Chip de filtro estilo mockup.
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
        padding: const EdgeInsets.symmetric(horizontal: 14),
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
          maxLines: 1,
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
