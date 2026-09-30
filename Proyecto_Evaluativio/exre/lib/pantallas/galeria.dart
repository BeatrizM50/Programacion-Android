import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/recurso.dart';
import 'detalle.dart';

class GaleriaScreen extends StatelessWidget {
  final AppState estado;

  const GaleriaScreen({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231C6B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF231C6B),
        foregroundColor: Colors.white,

        title: const Text(
          'Galeria',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: estado,

        builder: (context, child) {
          final List<Recurso> recursos = estado.todosLosRecursos;

          return GridView.builder(
            padding: const EdgeInsets.all(16),

            // ===============================================
            // DOS COLUMNAS
            // ===============================================
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.60,
            ),

            itemCount: recursos.length,

            itemBuilder: (context, index) {
              final Recurso recurso = recursos[index];

              return _tarjetaGaleria(context, recurso);
            },
          );
        },
      ),
    );
  }

  // =========================================================
  // TARJETA
  // =========================================================

  Widget _tarjetaGaleria(BuildContext context, Recurso recurso) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        estado.abrirDetalle(recurso);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalleScreen(recurso: recurso, estado: estado),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2E2789),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF443BA5)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ===============================================
            // PORTADA
            // ===============================================

            Expanded(
              flex: 5,

              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: _obtenerColor(recurso.color),

                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),

                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),

                    // =========================================
                    // FAVORITO
                    // =========================================
                    Positioned(
                      top: 8,
                      right: 8,

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),

                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 38,
                            minHeight: 38,
                          ),

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

                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // =========================================
                    // COMPLETADO
                    // =========================================
                    if (recurso.completado)
                      Positioned(
                        left: 8,
                        top: 8,

                        child: Container(
                          padding: const EdgeInsets.all(6),

                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ===============================================
            // INFORMACION
            // ===============================================
            Expanded(
              flex: 4,

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      recurso.categoria.toUpperCase(),

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Color(0xFFC5BFEE),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      recurso.titulo,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          color: Color(0xFF948CCB),
                          size: 15,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${recurso.duracion} min',
                          style: const TextStyle(
                            color: Color(0xFF948CCB),
                            fontSize: 11,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          recurso.nivel,

                          style: const TextStyle(
                            color: Color(0xFF948CCB),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COLORES
  // =========================================================

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
