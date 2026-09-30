import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/recurso.dart';

class DetalleScreen extends StatelessWidget {
  final Recurso recurso;
  final AppState estado;

  const DetalleScreen({super.key, required this.recurso, required this.estado});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Permitimos regresar normalmente.
      canPop: true,

      // Se ejecuta cuando se realiza un intento de regresar.
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          estado.cerrarDetalle();
        }
      },

      child: Scaffold(
        backgroundColor: const Color(0xFF231C6B),

        appBar: AppBar(
          backgroundColor: const Color(0xFF231C6B),
          foregroundColor: Colors.white,

          title: const Text(
            'Detalle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),

            onPressed: () {
              estado.cerrarDetalle();
              Navigator.pop(context);
            },
          ),
        ),

        body: ListenableBuilder(
          listenable: estado,

          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // PORTADA
                  // =================================================

                  Container(
                    width: double.infinity,
                    height: 180,

                    decoration: BoxDecoration(
                      color: _obtenerColor(recurso.color),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Center(
                      child: Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // CATEGORIA
                  // =================================================
                  Text(
                    recurso.categoria.toUpperCase(),

                    style: const TextStyle(
                      color: Color(0xFFC5BFEE),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // TITULO
                  // =================================================
                  Text(
                    recurso.titulo,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // =================================================
                  // AUTOR
                  // =================================================
                  Text(
                    'Autor: ${recurso.autor}',

                    style: const TextStyle(
                      color: Color(0xFFC5BFEE),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // INFORMACION
                  // =================================================
                  Row(
                    children: [
                      Expanded(
                        child: _dato(Icons.timer, '${recurso.duracion} min'),
                      ),

                      const SizedBox(width: 10),

                      Expanded(child: _dato(Icons.school, recurso.nivel)),

                      const SizedBox(width: 10),

                      Expanded(child: _dato(Icons.play_circle, recurso.tipo)),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // DESCRIPCION
                  // =================================================
                  const Text(
                    'Descripcion',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    recurso.descripcion,

                    style: const TextStyle(
                      color: Color(0xFFC5BFEE),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =================================================
                  // CONTENIDO SIMULADO
                  // =================================================
                  const Text(
                    'Contenido',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2789),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF443BA5)),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Color(0xFFC5BFEE)),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            'recursos.exre.app/${_generarEnlace()}',

                            style: const TextStyle(
                              color: Color(0xFFC5BFEE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // FAVORITO
                  // =================================================
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        estado.cambiarFavorito(recurso);
                      },

                      icon: Icon(
                        recurso.favorito
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recurso.favorito
                            ? const Color(0xFFF43F5E)
                            : Colors.white,
                      ),

                      label: Text(
                        recurso.favorito
                            ? 'Quitar de favoritos'
                            : 'Agregar a favoritos',

                        style: const TextStyle(color: Colors.white),
                      ),

                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),

                        side: const BorderSide(color: Color(0xFF443BA5)),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // COMPLETADO / PENDIENTE
                  // =================================================
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        estado.cambiarCompletado(recurso);
                      },

                      icon: Icon(
                        recurso.completado
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),

                      label: Text(
                        recurso.completado
                            ? 'Marcar como pendiente'
                            : 'Marcar como completado',
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: recurso.completado
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF4F46E5),

                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(vertical: 15),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================
  // DATO
  // ===========================================================

  Widget _dato(IconData icono, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),

      decoration: BoxDecoration(
        color: const Color(0xFF2E2789),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Icon(icono, color: const Color(0xFFC5BFEE), size: 21),

          const SizedBox(height: 6),

          Text(
            texto,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ENLACE SIMULADO
  // ===========================================================

  String _generarEnlace() {
    String texto = recurso.titulo.toLowerCase().replaceAll(' ', '-');

    return texto;
  }
  // ===========================================================
  // COLOR
  // ===========================================================

  Color _obtenerColor(String color) {
    switch (color) {
      case '#0553B1':
        return const Color(0xFF0553B1);

      case '#1DA260':
        return const Color(0xFF1DA260);

      case '#F59E0B':
        return const Color(0xFFF59E0B);

      case '#DB2777':
        return const Color(0xFFDB2777);

      case '#7C3AED':
        return const Color(0xFF7C3AED);

      case '#DC2626':
        return const Color(0xFFDC2626);

      default:
        return const Color(0xFF4F46E5);
    }
  }
}
