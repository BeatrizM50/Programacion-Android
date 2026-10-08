import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/theme_toggle.dart';
import 'notas_proyecto_screen.dart';

// RF1. Pantalla Proyectos. Usa ListView.builder de forma obligatoria.
// Estilo mockups: buscador, stats, tarjetas con acento lateral, FAB extendido.

class ProyectosScreen extends StatefulWidget {
  final AppState appState;
  const ProyectosScreen({super.key, required this.appState});

  @override
  State<ProyectosScreen> createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _busqueda = TextEditingController();
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

  Future<void> _dialogoProyecto({Proyecto? existente}) async {
    final nombreCtrl = TextEditingController(text: existente?.nombre ?? '');
    final descCtrl = TextEditingController(text: existente?.descripcion ?? '');
    final formKey = GlobalKey<FormState>();
    final guardar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existente == null ? 'Nuevo proyecto' : 'Editar proyecto'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción corta',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (guardar == true && mounted) {
      if (existente == null) {
        widget.appState.crearProyecto(nombreCtrl.text, descCtrl.text);
      } else {
        widget.appState.editarProyecto(
          existente.id,
          nombreCtrl.text,
          descCtrl.text,
        );
      }
    }
  }

  Future<void> _confirmarEliminar(Proyecto p) async {
    final n = widget.appState.cantidadNotasDeProyecto(p.id);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proyecto'),
        content: Text(
          'Se eliminará "${p.nombre}" y sus $n nota(s). Las etiquetas se conservan. ¿Continuar?',
        ),
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
    if (ok == true) widget.appState.eliminarProyecto(p.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const TituloAppBar(
          antetitulo: 'Renotes Academic',
          titulo: 'Proyectos',
        ),
        actions: [ThemeToggleButton(appState: widget.appState)],
      ),
      body: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          final q = normalizarEtiqueta(_texto);
          final proyectos = widget.appState.proyectos
              .where(
                (p) =>
                    q.isEmpty ||
                    normalizarEtiqueta(p.nombre).contains(q) ||
                    normalizarEtiqueta(p.descripcion).contains(q),
              )
              .toList();
          final totalNotas = widget.appState.notas.length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  controller: _busqueda,
                  decoration: InputDecoration(
                    hintText: 'Buscar proyectos o palabras clave…',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Mis Proyectos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PildoraConteo(
                      '$totalNotas notas · ${widget.appState.proyectos.length} carpetas',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: proyectos.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            widget.appState.proyectos.isEmpty
                                ? 'No hay proyectos.\nCrea el primero con «Nuevo Proyecto».'
                                : 'Sin proyectos para esa búsqueda.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    // Obligatorio: ListView.builder.
                    : ListView.builder(
                        key: const PageStorageKey('lista_proyectos'),
                        itemCount: proyectos.length + 1, // +1 tarjeta de pauta
                        padding: const EdgeInsets.only(bottom: 88),
                        itemBuilder: (context, i) {
                          if (i == proyectos.length) {
                            return const _TarjetaPauta();
                          }
                          final p = proyectos[i];
                          final n = widget.appState
                              .cantidadNotasDeProyecto(p.id);
                          final tags = widget.appState
                              .etiquetasDeProyecto(p.id);
                          return _TarjetaProyecto(
                            proyecto: p,
                            notas: n,
                            primeraEtiqueta: tags.isEmpty
                                ? null
                                : tags.first.nombre,
                            onAbrir: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotasProyectoScreen(
                                    appState: widget.appState,
                                    proyectoId: p.id,
                                  ),
                                ),
                              );
                            },
                            onEditar: () =>
                                _dialogoProyecto(existente: p),
                            onEliminar: () => _confirmarEliminar(p),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogoProyecto(),
        tooltip: 'Nuevo proyecto',
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Proyecto'),
      ),
    );
  }
}

/// Tarjeta de proyecto con acento lateral terracota (mockup).
class _TarjetaProyecto extends StatelessWidget {
  final Proyecto proyecto;
  final int notas;
  final String? primeraEtiqueta;
  final VoidCallback onAbrir;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  const _TarjetaProyecto({
    required this.proyecto,
    required this.notas,
    required this.primeraEtiqueta,
    required this.onAbrir,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onAbrir,
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 20,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                proyecto.nombre,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: scheme.onSurfaceVariant,
                              ),
                              onSelected: (v) {
                                if (v == 'editar') onEditar();
                                if (v == 'eliminar') onEliminar();
                              },
                              itemBuilder: (_) => const [
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
                        if (proyecto.descripcion.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              proyecto.descripcion,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _MiniPildora(
                              icono: Icons.description_outlined,
                              texto: '$notas notas',
                              destacado: true,
                            ),
                            if (primeraEtiqueta != null) ...[
                              const SizedBox(width: 8),
                              _MiniPildora(
                                icono: Icons.label_outline,
                                texto: primeraEtiqueta!,
                              ),
                            ],
                            const Spacer(),
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatoFechaCorta(proyecto.modificada),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPildora extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool destacado;
  const _MiniPildora({
    required this.icono,
    required this.texto,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: destacado
            ? scheme.secondaryContainer.withValues(alpha: 0.55)
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            size: 13,
            color: destacado
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: destacado
                  ? scheme.onSecondaryContainer
                  : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta informativa final (mockup "Pauta Metodológica").
class _TarjetaPauta extends StatelessWidget {
  const _TarjetaPauta();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: scheme.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pauta Metodológica',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Las etiquetas se comparten entre proyectos: úsalas para cruzar notas y encontrar síntesis interdisciplinarias.',
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
