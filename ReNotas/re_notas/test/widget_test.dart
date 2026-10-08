import 'package:flutter_test/flutter_test.dart';
import 'package:re_notas/app_state.dart';
import 'package:re_notas/utils.dart';

void main() {
  test('Datos de prueba: 3 proyectos, 15 notas, 8 etiquetas', () {
    final state = AppState();
    expect(state.proyectos.length, 3);
    expect(state.notas.length, 15);
    expect(state.etiquetas.length, 8);
    for (final p in state.proyectos) {
      expect(state.cantidadNotasDeProyecto(p.id), greaterThanOrEqualTo(4));
    }
  });

  test('Unicidad de etiquetas ignora mayúsculas, acentos y espacios', () {
    expect(
      normalizarEtiqueta('  Metodología '),
      normalizarEtiqueta('METODOLOGIA'),
    );
    expect(
      normalizarEtiqueta('metodologia'),
      normalizarEtiqueta('Metodología'),
    );
  });

  test('No se crean etiquetas duplicadas', () {
    final state = AppState();
    final antes = state.etiquetas.length;
    final e = state.obtenerOCrearEtiqueta('metodologia');
    expect(e, isNotNull);
    expect(e!.nombre, 'Metodología');
    expect(state.etiquetas.length, antes);
  });

  test('Eliminar proyecto elimina sus notas pero no las etiquetas', () {
    final state = AppState();
    final etiquetasAntes = state.etiquetas.length;
    final p = state.proyectos.first;
    final notasAntes = state.cantidadNotasDeProyecto(p.id);
    expect(notasAntes, greaterThan(0));
    state.eliminarProyecto(p.id);
    expect(state.notas.any((n) => n.proyectoId == p.id), isFalse);
    expect(state.etiquetas.length, etiquetasAntes);
  });

  test('Al menos 5 notas con descripción > 600 caracteres', () {
    final state = AppState();
    final largas = state.notas.where((n) => n.descripcion.length > 600);
    expect(largas.length, greaterThanOrEqualTo(5));
  });
}
