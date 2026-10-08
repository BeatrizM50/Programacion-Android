// Utilidades compartidas: normalización de etiquetas, extractos y formato de fecha.
// Sin dependencias externas: solo SDK de Flutter.

/// Normaliza un nombre de etiqueta para comparar unicidad.
///
/// Ignora mayúsculas/minúsculas, acentos y espacios al inicio/final.
/// "  Metodología " == "metodologia" == "METODOLOGIA".
String normalizarEtiqueta(String input) {
  final t = input.trim().toLowerCase();
  return _quitarAcentos(t);
}

/// Coincidencia parcial insensible a mayúsculas y acentos.
/// Busca [query] en cualquier parte de [nombre].
bool coincideEtiqueta(String nombre, String query) {
  if (query.trim().isEmpty) return true;
  final n = normalizarEtiqueta(nombre);
  final q = normalizarEtiqueta(query);
  return n.contains(q);
}

String _quitarAcentos(String s) {
  const conAcento =
      'áàäâãåāăąǎǟǡǻȁȃạảấầẩẫậắằẳẵặ';
  const conE = 'éèëêēĕėęěȅȇẹẻẽếềểễệ';
  const conI = 'íìïîīĭįǐȉȋịỉ';
  const conO = 'óòöôõøōŏőǒȍȏọỏốồổỗộớờởỡợ';
  const conU = 'úùüûũūŭůűųǔȕȗụủứừửữự';
  const conC = 'çćĉċč';
  const conN = 'ñńņňŉ';
  const conY = 'ýÿŷ';
  const conS = 'śŝşšș';
  const conZ = 'źżž';
  const conG = 'ĝğġģ';
  const conD = 'ďđ';
  const conR = 'ŕŗř';
  const conL = 'ĺļľŀł';
  const conT = 'ţťŧț';

  String out = s;
  for (final c in conAcento.split('')) {
    out = out.replaceAll(c, 'a');
  }
  for (final c in conE.split('')) {
    out = out.replaceAll(c, 'e');
  }
  for (final c in conI.split('')) {
    out = out.replaceAll(c, 'i');
  }
  for (final c in conO.split('')) {
    out = out.replaceAll(c, 'o');
  }
  for (final c in conU.split('')) {
    out = out.replaceAll(c, 'u');
  }
  for (final c in conC.split('')) {
    out = out.replaceAll(c, 'c');
  }
  for (final c in conN.split('')) {
    out = out.replaceAll(c, 'n');
  }
  for (final c in conY.split('')) {
    out = out.replaceAll(c, 'y');
  }
  for (final c in conS.split('')) {
    out = out.replaceAll(c, 's');
  }
  for (final c in conZ.split('')) {
    out = out.replaceAll(c, 'z');
  }
  for (final c in conG.split('')) {
    out = out.replaceAll(c, 'g');
  }
  for (final c in conD.split('')) {
    out = out.replaceAll(c, 'd');
  }
  for (final c in conR.split('')) {
    out = out.replaceAll(c, 'r');
  }
  for (final c in conL.split('')) {
    out = out.replaceAll(c, 'l');
  }
  for (final c in conT.split('')) {
    out = out.replaceAll(c, 't');
  }
  return out;
}

/// Extracto de una descripción larga para vistas de lista.
String extracto(String texto, [int max = 120]) {
  final t = texto.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (t.isEmpty) return 'Sin descripción';
  if (t.length <= max) return t;
  return '${t.substring(0, max).trim()}…';
}

/// Formato corto de fecha sin paquete intl: 07/10/2026 14:30.
String formatoFecha(DateTime d) {
  String p(int n) => n.toString().padLeft(2, '0');
  return '${p(d.day)}/${p(d.month)}/${d.year} ${p(d.hour)}:${p(d.minute)}';
}

/// Formato solo fecha: 07/10/2026.
String formatoFechaCorta(DateTime d) {
  String p(int n) => n.toString().padLeft(2, '0');
  return '${p(d.day)}/${p(d.month)}/${d.year}';
}
