import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../utils.dart';
import '../widgets/encabezado.dart';
import '../widgets/theme_toggle.dart';

// RF3. Editor de nota (crear y editar).
// Autocompletado obligatorio con Autocomplete del SDK.
// Estilo mockups: secciones con antetítulo, validación visible,
// caja de sugerencias, contador de caracteres y Guardar superior.

class EditorNotaScreen extends StatefulWidget {
  final AppState appState;
  final String proyectoId;
  final String? notaId; // null = crear
  const EditorNotaScreen({
    super.key,
    required this.appState,
    required this.proyectoId,
    this.notaId,
  });

  @override
  State<EditorNotaScreen> createState() => _EditorNotaScreenState();
}

class _EditorNotaScreenState extends State<EditorNotaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;
  late List<String> _tags;
  late final String _initTitulo;
  late final String _initDesc;
  late final Set<String> _initTags;

  /// Controlador interno del campo Autocomplete (se captura en
  /// fieldViewBuilder para leer el texto desde optionsViewBuilder
  /// y para la caja de sugerencias en línea).
  TextEditingController? _autoCtrl;

  bool get esEdicion => widget.notaId != null;

  @override
  void initState() {
    super.initState();
    final n = widget.notaId == null
        ? null
        : widget.appState.notaPorId(widget.notaId!);
    _initTitulo = n?.titulo ?? '';
    _initDesc = n?.descripcion ?? '';
    _initTags = Set.of(n?.etiquetaIds ?? const <String>[]);
    _titulo = TextEditingController(text: _initTitulo);
    _descripcion = TextEditingController(text: _initDesc);
    _tags = List.of(_initTags);
    _titulo.addListener(() => setState(() {}));
    _descripcion.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  bool get _hayCambios =>
      _titulo.text != _initTitulo ||
      _descripcion.text != _initDesc ||
      Set.of(_tags).difference(_initTags).isNotEmpty ||
      _initTags.difference(Set.of(_tags)).isNotEmpty;

  bool get _tituloValido => _titulo.text.trim().isNotEmpty;

  void _agregarEtiquetaPorNombre(String nombre) {
    final e = widget.appState.obtenerOCrearEtiqueta(nombre);
    if (e == null) return;
    if (!_tags.contains(e.id)) {
      setState(() => _tags.add(e.id));
    }
    _autoCtrl?.clear();
  }

  Future<bool> _confirmarSalida() async {
    if (!_hayCambios) return true;
    final salir = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambios sin guardar'),
        content: const Text('Tienes cambios sin guardar. ¿Salir sin guardar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Seguir editando'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir sin guardar'),
          ),
        ],
      ),
    );
    return salir == true;
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    // Si quedó texto pendiente en el campo de etiquetas, se asigna/crea.
    final pendiente = (_autoCtrl?.text ?? '').trim();
    if (pendiente.isNotEmpty) {
      final e = widget.appState.obtenerOCrearEtiqueta(pendiente);
      if (e != null && !_tags.contains(e.id)) _tags.add(e.id);
      _autoCtrl?.clear();
    }
    if (esEdicion) {
      widget.appState.editarNota(
        id: widget.notaId!,
        titulo: _titulo.text,
        descripcion: _descripcion.text,
        etiquetaIds: _tags,
      );
    } else {
      widget.appState.crearNota(
        proyectoId: widget.proyectoId,
        titulo: _titulo.text,
        descripcion: _descripcion.text,
        etiquetaIds: _tags,
      );
    }
    Navigator.pop(context);
  }

  /// Candidatas: coinciden parcial (insensible a mayúsculas/acentos),
  /// globales, excluyendo las ya asignadas.
  Iterable<Etiqueta> _opciones(String texto) {
    if (texto.trim().isEmpty) return const Iterable<Etiqueta>.empty();
    final asignadas = Set.of(_tags);
    return widget.appState.etiquetas
        .where((e) => !asignadas.contains(e.id))
        .where((e) => coincideEtiqueta(e.nombre, texto));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final proyecto = widget.appState.proyectoPorId(widget.proyectoId);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmarSalida() && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: TituloAppBar(
            antetitulo: 'Cuaderno de estudio',
            titulo: esEdicion ? 'Editar Nota' : 'Editor de Nota',
          ),
          actions: [
            ThemeToggleButton(appState: widget.appState),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Guardar'),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ),
        // Se adapta al teclado y pantallas pequeñas sin overflow.
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Proyecto destino.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 18,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            proyecto?.nombre ?? 'Proyecto',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PildoraConteo(
                          esEdicion ? 'Borrador en edición' : 'Borrador nuevo',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Antetitulo('Título de la investigación'),
                      const Spacer(),
                      if (_tituloValido)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Válido',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titulo,
                    decoration: const InputDecoration(
                      hintText: 'Escribe el título…',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'El título es obligatorio.'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  const Antetitulo('Etiquetas (taxonomía académica)'),
                  const SizedBox(height: 8),
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final id in _tags)
                          Builder(
                            builder: (ctx) {
                              final e = widget.appState.etiquetaPorId(id);
                              if (e == null) {
                                return const SizedBox.shrink();
                              }
                              return InputChip(
                                label: Text('#${e.nombre}'),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    setState(() => _tags.remove(id)),
                              );
                            },
                          ),
                      ],
                    ),
                  if (_tags.isNotEmpty) const SizedBox(height: 8),
                  // Autocompletado de etiquetas (requisito principal).
                  Autocomplete<Etiqueta>(
                    displayStringForOption: (e) => e.nombre,
                    optionsBuilder: (v) => _opciones(v.text),
                    onSelected: (e) {
                      setState(() => _tags.add(e.id));
                      _autoCtrl?.clear();
                    },
                    fieldViewBuilder: (ctx, ctrl, focus, onSubmit) {
                      _autoCtrl = ctrl;
                      return TextField(
                        controller: ctrl,
                        focusNode: focus,
                        decoration: const InputDecoration(
                          hintText: '#bib — escribe para sugerir',
                          prefixIcon: Icon(Icons.label_outline),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (v) {
                          // Confirmar al escribir una coma.
                          if (v.contains(',')) {
                            final partes = v.split(',');
                            for (var i = 0; i < partes.length - 1; i++) {
                              final nombre = partes[i].trim();
                              if (nombre.isNotEmpty) {
                                _agregarEtiquetaPorNombre(nombre);
                              }
                            }
                            final resto = partes.last.trimLeft();
                            if (resto != v) {
                              ctrl.text = resto;
                              ctrl.selection = TextSelection.fromPosition(
                                TextPosition(offset: ctrl.text.length),
                              );
                            }
                          }
                          setState(() {});
                        },
                        onSubmitted: (v) {
                          final nombre = v.trim().replaceAll(',', '');
                          if (nombre.isNotEmpty) {
                            _agregarEtiquetaPorNombre(nombre);
                          }
                        },
                      );
                    },
                    optionsViewBuilder: (ctx, onSelected, options) {
                      final lista = options.toList();
                      final texto = (_autoCtrl?.text ?? '').trim();
                      final existeExacta =
                          texto.isNotEmpty &&
                          widget.appState.etiquetaPorNombre(texto) != null;
                      final mostrarCrear = texto.isNotEmpty && !existeExacta;
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          child: SizedBox(
                            width: MediaQuery.of(ctx).size.width - 32,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: lista.length + (mostrarCrear ? 1 : 0),
                              itemBuilder: (c, i) {
                                if (i < lista.length) {
                                  final e = lista[i];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: e.color,
                                      radius: 10,
                                    ),
                                    title: Text(e.nombre),
                                    subtitle: Text(
                                      '${widget.appState.usoDeEtiqueta(e.id)} nota(s)',
                                      style: Theme.of(
                                        ctx,
                                      ).textTheme.bodySmall,
                                    ),
                                    onTap: () => onSelected(e),
                                  );
                                }
                                return ListTile(
                                  leading: const Icon(Icons.add),
                                  title: Text('Crear etiqueta "$texto"'),
                                  onTap: () {
                                    _agregarEtiquetaPorNombre(texto);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Caja de sugerencias en línea (mockup "Sugerencias inteligentes").
                  _CajaSugerencias(
                    texto: (_autoCtrl?.text ?? ''),
                    opciones: _opciones(_autoCtrl?.text ?? '').take(3).toList(),
                    onElegir: (e) {
                      setState(() => _tags.add(e.id));
                      _autoCtrl?.clear();
                    },
                    onCrear: _agregarEtiquetaPorNombre,
                  ),
                  Text(
                    'Sugerencias de todos los proyectos (ignora mayúsculas y acentos). Si el nombre ya existe se reutiliza: nunca se duplica.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Antetitulo('Cuerpo del manuscrito'),
                      const Spacer(),
                      Text(
                        '${_descripcion.text.length} caracteres',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descripcion,
                    decoration: const InputDecoration(
                      hintText: 'Texto largo de la nota…',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    style: const TextStyle(height: 1.6),
                    maxLines: 12,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            if (await _confirmarSalida() && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _guardar,
                          child: const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Caja de sugerencias en línea bajo el campo de etiquetas.
/// Muestra coincidencias existentes y la opción de crear (mockup).
class _CajaSugerencias extends StatelessWidget {
  final String texto;
  final List<Etiqueta> opciones;
  final void Function(Etiqueta) onElegir;
  final void Function(String) onCrear;
  const _CajaSugerencias({
    required this.texto,
    required this.opciones,
    required this.onElegir,
    required this.onCrear,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (texto.trim().isEmpty) return const SizedBox.shrink();
    final q = normalizarEtiqueta(texto);
    final existeExacta = opciones.any(
      (e) => normalizarEtiqueta(e.nombre) == q,
    );
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: [
                const Antetitulo('Sugerencias inteligentes'),
                const Spacer(),
                Text(
                  '${opciones.length} disponible(s)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          for (final e in opciones)
            ListTile(
              dense: true,
              leading: CircleAvatar(backgroundColor: e.color, radius: 10),
              title: Text('#${e.nombre}'),
              subtitle: const Text('Sugerencia existente'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Existente',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              onTap: () => onElegir(e),
            ),
          if (!existeExacta)
            ListTile(
              dense: true,
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.primary),
                ),
                child: Icon(Icons.add, size: 14, color: scheme.primary),
              ),
              title: Text('Crear etiqueta "$texto"'),
              subtitle: const Text('Añadir término nuevo'),
              onTap: () => onCrear(texto),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Text(
              'Presiona Enter o , para añadir',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
