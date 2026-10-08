import 'package:flutter/material.dart';

import 'models.dart';
import 'utils.dart';

// Estado global en memoria. Solo usa ChangeNotifier del SDK.
// Se escucha con ListenableBuilder / AnimatedBuilder (sin paquetes externos).

class AppState extends ChangeNotifier {
  final List<Proyecto> proyectos = [];
  final List<Nota> notas = [];
  final List<Etiqueta> etiquetas = [];

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get esOscuro => _themeMode == ThemeMode.dark;

  void alternarTema() {
    _themeMode = esOscuro ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  int _seqProyecto = 0;
  int _seqNota = 0;
  int _seqEtiqueta = 0;

  AppState() {
    _cargarDatosPrueba();
  }

  // ---------- Consultas ----------

  Proyecto? proyectoPorId(String id) {
    for (final p in proyectos) {
      if (p.id == id) return p;
    }
    return null;
  }

  Nota? notaPorId(String id) {
    for (final n in notas) {
      if (n.id == id) return n;
    }
    return null;
  }

  Etiqueta? etiquetaPorId(String id) {
    for (final e in etiquetas) {
      if (e.id == id) return e;
    }
    return null;
  }

  Etiqueta? etiquetaPorNombre(String nombre) {
    final q = normalizarEtiqueta(nombre);
    if (q.isEmpty) return null;
    for (final e in etiquetas) {
      if (normalizarEtiqueta(e.nombre) == q) return e;
    }
    return null;
  }

  List<Nota> notasDeProyecto(String proyectoId) {
    return notas.where((n) => n.proyectoId == proyectoId).toList()
      ..sort((a, b) => b.modificada.compareTo(a.modificada));
  }

  int cantidadNotasDeProyecto(String proyectoId) {
    var c = 0;
    for (final n in notas) {
      if (n.proyectoId == proyectoId) c++;
    }
    return c;
  }

  int usoDeEtiqueta(String etiquetaId) {
    var c = 0;
    for (final n in notas) {
      if (n.etiquetaIds.contains(etiquetaId)) c++;
    }
    return c;
  }

  List<Nota> notasConEtiqueta(String etiquetaId) {
    return notas.where((n) => n.etiquetaIds.contains(etiquetaId)).toList()
      ..sort((a, b) => b.modificada.compareTo(a.modificada));
  }

  /// Etiquetas presentes en las notas de un proyecto (para filtros de RF2).
  List<Etiqueta> etiquetasDeProyecto(String proyectoId) {
    final ids = <String>{};
    for (final n in notas) {
      if (n.proyectoId == proyectoId) ids.addAll(n.etiquetaIds);
    }
    final res =
        etiquetas.where((e) => ids.contains(e.id)).toList()
          ..sort((a, b) => a.nombre.compareTo(b.nombre));
    return res;
  }

  // ---------- Proyectos ----------

  Proyecto crearProyecto(String nombre, String descripcion) {
    final ahora = DateTime.now();
    final p = Proyecto(
      id: 'p${++_seqProyecto}',
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      creada: ahora,
      modificada: ahora,
    );
    proyectos.add(p);
    notifyListeners();
    return p;
  }

  void editarProyecto(String id, String nombre, String descripcion) {
    final p = proyectoPorId(id);
    if (p == null) return;
    p.nombre = nombre.trim();
    p.descripcion = descripcion.trim();
    p.modificada = DateTime.now();
    notifyListeners();
  }

  void eliminarProyecto(String id) {
    proyectos.removeWhere((p) => p.id == id);
    notas.removeWhere((n) => n.proyectoId == id);
    // Las etiquetas no se eliminan.
    notifyListeners();
  }

  void tocarProyecto(String id) {
    final p = proyectoPorId(id);
    if (p == null) return;
    p.modificada = DateTime.now();
    notifyListeners();
  }

  // ---------- Notas ----------

  Nota crearNota({
    required String proyectoId,
    required String titulo,
    required String descripcion,
    required List<String> etiquetaIds,
  }) {
    final ahora = DateTime.now();
    final n = Nota(
      id: 'n${++_seqNota}',
      proyectoId: proyectoId,
      titulo: titulo.trim(),
      descripcion: descripcion,
      creada: ahora,
      modificada: ahora,
      etiquetaIds: etiquetaIds,
    );
    notas.add(n);
    tocarProyectoSilencioso(proyectoId);
    notifyListeners();
    return n;
  }

  void editarNota({
    required String id,
    required String titulo,
    required String descripcion,
    required List<String> etiquetaIds,
  }) {
    final n = notaPorId(id);
    if (n == null) return;
    n.titulo = titulo.trim();
    n.descripcion = descripcion;
    n.etiquetaIds = List.of(etiquetaIds);
    n.modificada = DateTime.now();
    tocarProyectoSilencioso(n.proyectoId);
    notifyListeners();
  }

  void eliminarNota(String id) {
    final n = notaPorId(id);
    if (n == null) return;
    notas.removeWhere((x) => x.id == id);
    tocarProyectoSilencioso(n.proyectoId);
    notifyListeners();
  }

  void tocarProyectoSilencioso(String proyectoId) {
    final p = proyectoPorId(proyectoId);
    if (p != null) p.modificada = DateTime.now();
  }

  // ---------- Etiquetas ----------

  /// Obtiene la etiqueta existente (comparación normalizada) o la crea.
  /// Nunca crea duplicados. Retorna null si el nombre está vacío.
  Etiqueta? obtenerOCrearEtiqueta(String nombre) {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return null;
    final existente = etiquetaPorNombre(limpio);
    if (existente != null) return existente;
    final e = Etiqueta(
      id: 'e${++_seqEtiqueta}',
      nombre: limpio,
      color: _colorParaEtiqueta(_seqEtiqueta),
    );
    etiquetas.add(e);
    notifyListeners();
    return e;
  }

  /// Crea una etiqueta independiente. Retorna mensaje de error o null si ok.
  String? crearEtiquetaIndependiente(String nombre) {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return 'El nombre no puede estar vacío.';
    if (etiquetaPorNombre(limpio) != null) {
      return 'Ya existe una etiqueta con ese nombre.';
    }
    final e = Etiqueta(
      id: 'e${++_seqEtiqueta}',
      nombre: limpio,
      color: _colorParaEtiqueta(_seqEtiqueta),
    );
    etiquetas.add(e);
    notifyListeners();
    return null;
  }

  /// Renombra. Retorna mensaje de error o null si ok.
  String? renombrarEtiqueta(String id, String nuevoNombre) {
    final limpio = nuevoNombre.trim();
    if (limpio.isEmpty) return 'El nombre no puede estar vacío.';
    final e = etiquetaPorId(id);
    if (e == null) return 'Etiqueta no encontrada.';
    final otra = etiquetaPorNombre(limpio);
    if (otra != null && otra.id != id) {
      return 'Ya existe una etiqueta llamada "$limpio".';
    }
    e.nombre = limpio;
    notifyListeners();
    return null;
  }

  void eliminarEtiqueta(String id) {
    etiquetas.removeWhere((e) => e.id == id);
    for (final n in notas) {
      n.etiquetaIds.removeWhere((x) => x == id);
    }
    notifyListeners();
  }

  Color _colorParaEtiqueta(int seq) {
    const paleta = [
      Colors.teal,
      Colors.indigo,
      Colors.deepOrange,
      Colors.purple,
      Colors.green,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
    ];
    return paleta[(seq - 1) % paleta.length];
  }

  // ---------- Datos de prueba ----------
  //
  // 3 proyectos, 15 notas (5 por proyecto), 8 etiquetas.
  // - 3 etiquetas usadas en proyectos diferentes.
  // - 5 notas con descripción > 600 caracteres.
  // - 1 nota sin etiquetas, 1 etiqueta sin notas.

  void _cargarDatosPrueba() {
    final base = DateTime(2026, 9, 1, 10, 0);

    // Etiquetas (la última queda sin usar).
    final nombresEtiquetas = [
      'Metodología',
      'Trabajo de campo',
      'Bibliografía',
      'Hipótesis',
      'Resultados',
      'Entrevistas',
      'Análisis',
      'Pendiente de revisión',
    ];
    final mapa = <String, Etiqueta>{};
    for (var i = 0; i < nombresEtiquetas.length; i++) {
      final e = Etiqueta(
        id: 'e${i + 1}',
        nombre: nombresEtiquetas[i],
        color: _colorParaEtiqueta(i + 1),
      );
      etiquetas.add(e);
      mapa[e.nombre] = e;
    }
    _seqEtiqueta = nombresEtiquetas.length;

    // Proyectos.
    final p1 = Proyecto(
      id: 'p1',
      nombre: 'Ecología urbana del río',
      descripcion: 'Estudio de la biodiversidad y calidad del agua en tramos urbanos.',
      creada: base,
      modificada: base.add(const Duration(days: 30)),
    );
    final p2 = Proyecto(
      id: 'p2',
      nombre: 'Historia oral del barrio',
      descripcion: 'Recopilación de testimonios y memoria colectiva vecinal.',
      creada: base.add(const Duration(days: 2)),
      modificada: base.add(const Duration(days: 28)),
    );
    final p3 = Proyecto(
      id: 'p3',
      nombre: 'Energías renovables locales',
      descripcion: 'Viabilidad de paneles solares comunitarios y microeólica.',
      creada: base.add(const Duration(days: 5)),
      modificada: base.add(const Duration(days: 25)),
    );
    proyectos.addAll([p1, p2, p3]);
    _seqProyecto = 3;

    Etiqueta et(String nombre) => mapa[nombre]!;

    // Textos largos (> 600 caracteres).
    final largo1 = _textoLargo(
      'Diseño metodológico del muestreo en el tramo urbano del río. ',
    );
    final largo2 = _textoLargo(
      'Revisión bibliográfica sobre bioindicadores de calidad del agua. ',
    );
    final largo3 = _textoLargo(
      'Guion de entrevistas semiestructuradas para memoria del barrio. ',
    );
    final largo4 = _textoLargo(
      'Dimensionamiento inicial del sistema solar comunitario propuesto. ',
    );
    final largo5 = _textoLargo(
      'Protocolo de análisis de datos mixtos y triangulación. ',
    );

    final corta1 =
        'Salida de reconocimiento del tramo norte. Se identificaron tres puntos de vertido y dos zonas con vegetación de ribera en buen estado.';
    final corta2 =
        'Lista de lecturas pendientes: capítulos 3 y 4 del manual de limnología y el artículo sobre macroinvertebrados como bioindicadores.';
    final corta3 =
        'Borrador de hipótesis: la cobertura vegetal de ribera reduce la temperatura del agua y aumenta la diversidad de macroinvertebrados.';
    final corta4 =
        'Primeros resultados del muestreo de septiembre: pH estable, oxígeno disuelto aceptable y presencia de libélulas en el tramo 2.';
    final corta5 = 'Nota de planificación sin clasificar todavía.';
    final corta6 =
        'Entrevista con la señora Marta: recuerdos del mercado antiguo, la lavandería comunal y las fiestas de 1985.';
    final corta7 =
        'Visita al archivo municipal. Se fotografiaron 40 planos del barrio entre 1950 y 1990 para georreferenciar.';
    final corta8 =
        'Hipótesis de trabajo: la memoria del barrio se organiza alrededor del mercado y la escuela como nodos de encuentro.';
    final corta9 =
        'Transcripción parcial de la entrevista con don Emilio, antiguo ferroviario. Habla del taller y la cooperativa.';
    final corta10 =
        'Cotización de 12 paneles de 550 W con inversor híbrido y estructura para techo comunitario. Retorno estimado en 6 años.';

    final datos = [
      // proyecto, título, descripción, etiquetas
      [p1.id, 'Diseño del muestreo', largo1, ['Metodología', 'Hipótesis']],
      [p1.id, 'Revisión bibliográfica', largo2, ['Bibliografía', 'Metodología']],
      [p1.id, 'Salida de reconocimiento', corta1, ['Trabajo de campo']],
      [p1.id, 'Lecturas pendientes', corta2, ['Bibliografía']],
      [p1.id, 'Borrador de hipótesis', corta3, ['Hipótesis']],
      [p2.id, 'Guion de entrevistas', largo3, ['Entrevistas', 'Metodología']],
      [p2.id, 'Entrevista señora Marta', corta6, ['Entrevistas', 'Trabajo de campo']],
      [p2.id, 'Archivo municipal', corta7, ['Trabajo de campo', 'Bibliografía']],
      [p2.id, 'Hipótesis del barrio', corta8, ['Hipótesis']],
      [p2.id, 'Transcripción don Emilio', corta4, ['Entrevistas', 'Resultados']],
      [p3.id, 'Dimensionamiento solar', largo4, ['Resultados', 'Análisis']],
      [p3.id, 'Protocolo de análisis', largo5, ['Análisis', 'Metodología']],
      [p3.id, 'Cotización de paneles', corta10, ['Resultados', 'Bibliografía']],
      [p3.id, 'Entrevista técnico local', corta9, ['Entrevistas', 'Trabajo de campo']],
      [p3.id, 'Nota sin clasificar', corta5, const <String>[]],
    ];

    for (var i = 0; i < datos.length; i++) {
      final fila = datos[i];
      final pid = fila[0] as String;
      final titulo = fila[1] as String;
      final desc = fila[2] as String;
      final tags = (fila[3] as List).cast<String>();
      final creada = base.add(Duration(days: i, hours: i));
      notas.add(
        Nota(
          id: 'n${i + 1}',
          proyectoId: pid,
          titulo: titulo,
          descripcion: desc,
          creada: creada,
          modificada: creada.add(const Duration(hours: 5)),
          etiquetaIds: tags.map((t) => et(t).id).toList(),
        ),
      );
    }
    _seqNota = datos.length;
  }

  String _textoLargo(String semilla) {
    final sb = StringBuffer();
    const parrafos = [
      'Se describe el objetivo general, los objetivos específicos y las preguntas que guían el trabajo. Cada decisión queda registrada con su justificación para permitir la replicabilidad por parte de otros equipos. ',
      'El procedimiento se divide en fases con responsables, plazos y criterios de calidad. Se detallan los instrumentos, las variables observadas y el plan de registro en cuaderno de campo y en esta aplicación. ',
      'Se discuten las limitaciones conocidas, los sesgos potenciales y las estrategias de mitigación. También se anotan las decisiones pendientes y los supuestos que deberán validarse en la próxima salida. ',
      'Finalmente se proponen los pasos siguientes, los indicadores de avance y la lista de verificación para la revisión por pares antes de cerrar cada hito del proyecto. ',
    ];
    while (sb.length < 700) {
      sb.write(semilla);
      for (final p in parrafos) {
        sb.write(p);
      }
    }
    return sb.toString();
  }
}
