import 'package:flutter/material.dart';

import '../datos/recursos.dart';
import '../modelos/recurso.dart';

class AppState extends ChangeNotifier {
  // =========================
  // RECURSOS
  // =========================

  List<Recurso> get todosLosRecursos => recursos;

  // =========================
  // FAVORITOS Y COMPLETADOS
  // =========================

  final Set<int> idsFavoritos = {};
  final Set<int> idsCompletados = {};

  // =========================
  // BÚSQUEDA Y FILTROS
  // =========================

  String textoBusqueda = '';
  String categoriaSeleccionada = 'Todas';

  // =========================
  // DETALLE ACTUAL
  // =========================

  int? recursoDetalleId;

  // =========================
  // CICLO DE VIDA
  // =========================

  AppLifecycleState estadoCicloVidaActual = AppLifecycleState.resumed;

  String ultimoEvento = 'resumed';

  final List<String> historialCicloVida = [];

  AppState() {
    _inicializarEstado();
  }

  void _inicializarEstado() {
    for (final recurso in recursos) {
      if (recurso.favorito) {
        idsFavoritos.add(recurso.id);
      }

      if (recurso.completado) {
        idsCompletados.add(recurso.id);
      }
    }

    historialCicloVida.add('resumed');
  }

  // =========================
  // LISTAS
  // =========================

  List<Recurso> get favoritos {
    return recursos
        .where((recurso) => idsFavoritos.contains(recurso.id))
        .toList();
  }

  List<Recurso> get completados {
    return recursos
        .where((recurso) => idsCompletados.contains(recurso.id))
        .toList();
  }

  List<Recurso> get pendientes {
    return recursos
        .where((recurso) => !idsCompletados.contains(recurso.id))
        .toList();
  }

  // =========================
  // CANTIDADES
  // =========================

  int get cantidadTotal => recursos.length;

  int get cantidadFavoritos => idsFavoritos.length;

  int get cantidadCompletados => idsCompletados.length;

  int get cantidadPendientes => pendientes.length;

  // =========================
  // PORCENTAJE
  // =========================

  double get porcentajeProgreso {
    if (recursos.isEmpty) {
      return 0;
    }

    return cantidadCompletados / cantidadTotal;
  }

  // =========================
  // FAVORITOS
  // =========================

  void actualizarBusqueda(String texto) {
    textoBusqueda = texto;
    notifyListeners();
  }

  void actualizarCategoria(String categoria) {
    categoriaSeleccionada = categoria;
    notifyListeners();
  }

  void cambiarFavorito(Recurso recurso) {
    if (idsFavoritos.contains(recurso.id)) {
      idsFavoritos.remove(recurso.id);
      recurso.favorito = false;
    } else {
      idsFavoritos.add(recurso.id);
      recurso.favorito = true;
    }

    notifyListeners();
  }

  void agregarFavorito(Recurso recurso) {
    idsFavoritos.add(recurso.id);
    recurso.favorito = true;

    notifyListeners();
  }

  void quitarFavorito(Recurso recurso) {
    idsFavoritos.remove(recurso.id);
    recurso.favorito = false;

    notifyListeners();
  }

  // =========================
  // COMPLETADOS
  // =========================

  void cambiarCompletado(Recurso recurso) {
    if (idsCompletados.contains(recurso.id)) {
      idsCompletados.remove(recurso.id);
      recurso.completado = false;
    } else {
      idsCompletados.add(recurso.id);
      recurso.completado = true;
    }

    notifyListeners();
  }

  void marcarCompletado(Recurso recurso) {
    idsCompletados.add(recurso.id);
    recurso.completado = true;

    notifyListeners();
  }

  void marcarPendiente(Recurso recurso) {
    idsCompletados.remove(recurso.id);
    recurso.completado = false;

    notifyListeners();
  }

  // =========================
  // BÚSQUEDA
  // =========================

  List<Recurso> buscarRecursos(String texto) {
    textoBusqueda = texto;

    if (texto.trim().isEmpty) {
      return recursos;
    }

    String busqueda = texto.toLowerCase();

    return recursos.where((recurso) {
      return recurso.titulo.toLowerCase().contains(busqueda) ||
          recurso.categoria.toLowerCase().contains(busqueda) ||
          recurso.autor.toLowerCase().contains(busqueda);
    }).toList();
  }
  // =========================
  // FILTRO POR CATEGORÍA
  // =========================

  List<Recurso> filtrarPorCategoria(String categoria) {
    categoriaSeleccionada = categoria;

    if (categoria == 'Todas') {
      return recursos;
    }

    return recursos.where((recurso) => recurso.categoria == categoria).toList();
  }

  // =========================
  // BÚSQUEDA + CATEGORÍA
  // =========================

  List<Recurso> filtrarRecursos({
    String texto = '',
    String categoria = 'Todas',
  }) {
    return recursos.where((recurso) {
      bool coincideTexto = true;
      bool coincideCategoria = true;

      if (texto.trim().isNotEmpty) {
        final String busqueda = texto.toLowerCase();

        coincideTexto =
            recurso.titulo.toLowerCase().contains(busqueda) ||
            recurso.categoria.toLowerCase().contains(busqueda) ||
            recurso.autor.toLowerCase().contains(busqueda);
      }

      if (categoria != 'Todas') {
        coincideCategoria = recurso.categoria == categoria;
      }

      return coincideTexto && coincideCategoria;
    }).toList();
  }

  // =========================
  // DETALLE
  // =========================

  void abrirDetalle(Recurso recurso) {
    recursoDetalleId = recurso.id;
    notifyListeners();
  }

  void cerrarDetalle() {
    recursoDetalleId = null;
    notifyListeners();
  }

  // =========================
  // CICLO DE VIDA
  // =========================

  void registrarCicloVida(AppLifecycleState estado) {
    estadoCicloVidaActual = estado;
    ultimoEvento = estado.name;

    historialCicloVida.add(estado.name);

    // Conservamos solamente los últimos 10 eventos.
    if (historialCicloVida.length > 10) {
      historialCicloVida.removeAt(0);
    }

    notifyListeners();
  }
}
