class Recurso {
  final int id;
  final String titulo;
  final String categoria;
  final String autor;
  final int duracion;
  final String nivel;
  final String descripcion;
  final String tipo;
  final String color;

  bool favorito;
  bool completado;

  Recurso({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.autor,
    required this.duracion,
    required this.nivel,
    required this.descripcion,
    required this.tipo,
    required this.color,
    this.favorito = false,
    this.completado = false,
  });
}
