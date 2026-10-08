import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/tag_chip.dart';
import '../widgets/theme_toggle.dart';
import 'detalle_nota_screen.dart';

// RF5. Pantalla Etiquetas. Usa ListView.builder de forma obligatoria.
// Estilo mockups: índice temático, toggle OR/AND, taxonomía en pares,
// notas coincidentes en línea y botón "+ Nueva" en cabecera.

enum ModoAgrupacion { todas, alMenosUna }

class EtiquetasScreen extends StatefulWidget {
  final AppState appState;
  final String? filtroInicialEtiquetaId;
  const EtiquetasScreen({
    super.key,
    required this.appState,
    this.filtroInicialEtiquetaId,
  });

  @override
  State<EtiquetasScreen> createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _busqueda = TextEditingController();
  String _texto = '';
  final Set<String> _seleccionadas = {};
  ModoAgrupacion _modo = ModoAgrupacion.alMenosUna;
  String? _expandida;

  @override
  void initState() {
    super.initState();
    _busqueda.addListener(() => setState(() => _texto = _busqueda.text));
    if (widget.filtroInicialEtiquetaId != null) {
      _seleccionadas.add(widget.filtroInicialEtiquetaId!);
      _expandida = widget.filtroInicialEtiquetaId;
    }
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  List<Etiqueta> _etiquetasFiltradas() {
    final todas = List.of(widget.appState.etiquetas)
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
    if (_texto.trim().isEmpty) return todas;
    return todas.where((e) => coincideEtiqueta(e.nombre, _texto)).toList();
  }

  List<Nota> _notasAgrupadas() {
    if (_seleccionadas.isEmpty) return const [];
    final notas = widget.appState.notas;
    return notas.where((n) {
      if (_modo == ModoAgrupacion.todas) {
        return _seleccionadas.every((id) => n.etiquetaIds.contains(id));
      }
      return _seleccionadas.any((id) => n.etiquetaIds.contains(id));
    }).toList()
      ..sort((a, b) => b.modificada.compareTo(a.modificada));
  }

  void _alternarSeleccion(String id) {
    setState(() {
      if (_seleccionadas.contains(id)) {
        _seleccionadas.remove(id);
      } else {
        _seleccionadas.add(id);
      }
    });
  }

  int _proyectosDistintos(List<Nota> notas) {
    return notas.map((n) => n.proyectoId).toSet().length;
  }

  Future<void> _dialogoCrear() async {
    final ctrl = TextEditingController();
    String? error;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Nueva etiqueta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: ctrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio.'
                    : null,
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final msg = widget.appState.crearEtiquetaIndependiente(
                  ctrl.text,
                );
                if (msg == null) {
                  Navigator.pop(ctx, true);
                } else {
                  setD(() => error = msg);
                }
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Etiqueta creada.')));
    }
  }

  Future<void> _dialogoRenombrar(Etiqueta e) async {
    final ctrl = TextEditingController(text: e.nombre);
    String? error;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Renombrar etiqueta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nuevo nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final msg = widget.appState.renombrarEtiqueta(
                  e.id,
                  ctrl.text,
                );
                if (msg == null) {
                  Navigator.pop(ctx);
                } else {
                  setD(() => error = msg);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(Etiqueta e) async {
    final n = widget.appState.usoDeEtiqueta(e.id);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar etiqueta'),
        content: Text(
          'Se quitará "${e.nombre}" de $n nota(s). Las notas no se borran. ¿Continuar?',
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
    if (ok == true) {
      widget.appState.eliminarEtiqueta(e.id);
      _seleccionadas.remove(e.id);
    }
  }

  void _abrirDetalle(String notaId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DetalleNotaScreen(appState: widget.appState, notaId: notaId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final scheme = Theme.of(context).colorScheme;
    final esPantallaFiltrada = widget.filtroInicialEtiquetaId != null;
    return Scaffold(
      appBar: AppBar(
        title: esPantallaFiltrada
            ? const TituloAppBar(
                antetitulo: 'Renotes Academic',
                titulo: 'Etiqueta',
              )
            : const TituloAppBar(
                antetitulo: 'Renotes Academic',
                titulo: 'Etiquetas',
              ),
        actions: [ThemeToggleButton(appState: widget.appState)],
      ),
      body: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          final etiquetas = _etiquetasFiltradas();
          final agrupadas = _notasAgrupadas();
          // Pares para la cuadrícula de 2 columnas con ListView.builder.
          final filas = (etiquetas.length + 1) ~/ 2;
          return SingleChildScrollView(
            key: const PageStorageKey('scroll_etiquetas'),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera: índice + conteo + nueva (mockup).
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 16, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Índice Temático',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.01,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PildoraConteo(
                        '${widget.appState.etiquetas.length} activas',
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _dialogoCrear,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Nueva'),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _busqueda,
                    decoration: InputDecoration(
                      hintText: 'Filtrar etiquetas por nombre…',
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
                const SizedBox(height: 10),
                // Toggle OR/AND de ancho completo (mockup).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _OpcionModo(
                            texto: 'Al menos una (OR)',
                            activo: _modo == ModoAgrupacion.alMenosUna,
                            onTap: () => setState(
                              () => _modo = ModoAgrupacion.alMenosUna,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _OpcionModo(
                            texto: 'Todas (AND)',
                            activo: _modo == ModoAgrupacion.todas,
                            onTap: () => setState(
                              () => _modo = ModoAgrupacion.todas,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    children: [
                      const Antetitulo('Taxonomía transversal'),
                      const Spacer(),
                      Text(
                        'Toca para filtrar notas',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (etiquetas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No hay etiquetas.\nCrea la primera con «Nueva».',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  // Obligatorio: ListView.builder (2 etiquetas por fila).
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filas,
                    itemBuilder: (context, f) {
                      final a = etiquetas[f * 2];
                      final b = f * 2 + 1 < etiquetas.length
                          ? etiquetas[f * 2 + 1]
                          : null;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PildoraEtiqueta(
                                appState: widget.appState,
                                etiqueta: a,
                                seleccionada: _seleccionadas.contains(a.id),
                                onTap: () => _alternarSeleccion(a.id),
                                onRenombrar: () => _dialogoRenombrar(a),
                                onEliminar: () => _confirmarEliminar(a),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: b == null
                                  ? const SizedBox.shrink()
                                  : _PildoraEtiqueta(
                                      appState: widget.appState,
                                      etiqueta: b,
                                      seleccionada: _seleccionadas.contains(
                                        b.id,
                                      ),
                                      onTap: () => _alternarSeleccion(b.id),
                                      onRenombrar: () =>
                                          _dialogoRenombrar(b),
                                      onEliminar: () =>
                                          _confirmarEliminar(b),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                // Notas coincidentes en línea (mockup).
                if (_seleccionadas.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Row(
                      children: [
                        const Text(
                          'Notas coincidentes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        PildoraConteo('${agrupadas.length} notas'),
                        const Spacer(),
                        Text(
                          '${_proyectosDistintos(agrupadas)} proyectos',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (agrupadas.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text('Sin notas para esa combinación.'),
                    ),
                  for (final n in agrupadas)
                    _TarjetaNotaCoincidente(
                      appState: widget.appState,
                      nota: n,
                      onTap: () => _abrirDetalle(n.id),
                    ),
                ],
                // Notas de la etiqueta expandida (chevron).
                if (_expandida != null &&
                    widget.appState.etiquetaPorId(_expandida!) != null)
                  _BloqueExpandida(
                    appState: widget.appState,
                    etiqueta: widget.appState.etiquetaPorId(_expandida!)!,
                    onCerrar: () => setState(() => _expandida = null),
                    onAbrir: _abrirDetalle,
                  ),
                // Tarjeta informativa (mockup "Interconexión Académica").
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.menu_book_outlined, color: scheme.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interconexión Académica',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Las etiquetas operan transversalmente uniendo ideas sin importar la frontera de proyectos. Usa combinaciones múltiples para síntesis interdisciplinarias.',
                              style: TextStyle(fontSize: 13, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Opción del toggle OR/AND.
class _OpcionModo extends StatelessWidget {
  final String texto;
  final bool activo;
  final VoidCallback onTap;
  const _OpcionModo({
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: activo ? scheme.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: activo
              ? Border.all(color: scheme.outlineVariant)
              : null,
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: activo ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Píldora grande de etiqueta con conteo y menú (mockup).
class _PildoraEtiqueta extends StatelessWidget {
  final AppState appState;
  final Etiqueta etiqueta;
  final bool seleccionada;
  final VoidCallback onTap;
  final VoidCallback onRenombrar;
  final VoidCallback onEliminar;
  const _PildoraEtiqueta({
    required this.appState,
    required this.etiqueta,
    required this.seleccionada,
    required this.onTap,
    required this.onRenombrar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final uso = appState.usoDeEtiqueta(etiqueta.id);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionada
              ? scheme.primary
              : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: seleccionada ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '#${etiqueta.nombre}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: seleccionada ? scheme.onPrimary : scheme.onSurface,
                  decoration: uso == 0 ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: seleccionada
                    ? scheme.onPrimary.withValues(alpha: 0.25)
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                uso == 0 ? 'Sin notas' : '$uso',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: seleccionada
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 16,
                color: seleccionada
                    ? scheme.onPrimary
                    : scheme.onSurfaceVariant,
              ),
              padding: EdgeInsets.zero,
              onSelected: (v) {
                if (v == 'renombrar') onRenombrar();
                if (v == 'eliminar') onEliminar();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'renombrar',
                  child: Text('Renombrar'),
                ),
                PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de nota coincidente (mockup).
class _TarjetaNotaCoincidente extends StatelessWidget {
  final AppState appState;
  final Nota nota;
  final VoidCallback onTap;
  const _TarjetaNotaCoincidente({
    required this.appState,
    required this.nota,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      appState.proyectoPorId(nota.proyectoId)?.nombre ??
                          'Proyecto',
                    ),
                  ),
                  Text(
                    formatoFechaCorta(nota.modificada),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                nota.titulo,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                extracto(nota.descripcion, 110),
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final id in nota.etiquetaIds)
                          TagChip(appState: appState, etiquetaId: id),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bloque de notas de la etiqueta expandida (chevron / llegada filtrada).
class _BloqueExpandida extends StatelessWidget {
  final AppState appState;
  final Etiqueta etiqueta;
  final VoidCallback onCerrar;
  final void Function(String notaId) onAbrir;
  const _BloqueExpandida({
    required this.appState,
    required this.etiqueta,
    required this.onCerrar,
    required this.onAbrir,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final notas = appState.notasConEtiqueta(etiqueta.id);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: TagDot(etiqueta: etiqueta),
            title: Text(
              '#${etiqueta.nombre} · ${notas.length} nota(s)',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_less),
              onPressed: onCerrar,
            ),
            onTap: onCerrar,
          ),
          if (notas.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Ninguna nota usa esta etiqueta.'),
            ),
          for (final n in notas)
            ListTile(
              dense: true,
              leading: const Icon(Icons.note_outlined, size: 20),
              title: Text(n.titulo),
              subtitle: Text(
                '${appState.proyectoPorId(n.proyectoId)?.nombre ?? '—'} · ${extracto(n.descripcion, 80)}',
              ),
              onTap: () => onAbrir(n.id),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
