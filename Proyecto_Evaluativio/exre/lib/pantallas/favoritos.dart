import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/recurso.dart';
import 'detalle.dart';

class FavoritosScreen extends StatelessWidget {
  final AppState estado;

  const FavoritosScreen({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231C6B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF231C6B),
        foregroundColor: Colors.white,

        title: const Text(
          'Favoritos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: estado,

        builder: (context, child) {
          final List<Recurso> favoritos = estado.favoritos;

          // ===============================================
          // ESTADO VACIO
          // ===============================================

          if (favoritos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Color(0xFF948CCB),
                      size: 70,
                    ),

                    SizedBox(height: 18),

                    Text(
                      'No tienes favoritos todavía',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Agrega recursos a favoritos '
                      'desde el catálogo, la galería '
                      'o el detalle.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Color(0xFFC5BFEE),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ===============================================
          // LISTA
          // ===============================================

          return ListView.separated(
            padding: const EdgeInsets.all(16),

            itemCount: favoritos.length,

            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },

            itemBuilder: (context, index) {
              final Recurso recurso = favoritos[index];

              return _tarjetaFavorito(context, recurso);
            },
          );
        },
      ),
    );
  }

  // =========================================================
  // TARJETA
  // =========================================================

  Widget _tarjetaFavorito(BuildContext context, Recurso recurso) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),

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
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: const Color(0xFF2E2789),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF443BA5)),
        ),

        child: Row(
          children: [
            // =============================================
            // ICONO
            // =============================================

            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: _obtenerColor(recurso.color),

                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(Icons.menu_book, color: Colors.white, size: 28),
            ),

            const SizedBox(width: 14),

            // =============================================
            // INFORMACION
            // =============================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    recurso.categoria.toUpperCase(),

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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${recurso.autor} · '
                    '${recurso.duracion} min',

                    style: const TextStyle(
                      color: Color(0xFF948CCB),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // =============================================
            // FAVORITO
            // =============================================
            IconButton(
              onPressed: () {
                estado.quitarFavorito(recurso);
              },

              icon: const Icon(Icons.favorite, color: Color(0xFFF43F5E)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COLOR
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
