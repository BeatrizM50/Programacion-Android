import 'package:flutter/material.dart';

import '../estado/app_state.dart';

class InicioScreen extends StatelessWidget {
  final AppState estado;
  final Function(int) cambiarPantalla;

  const InicioScreen({
    super.key,
    required this.estado,
    required this.cambiarPantalla,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231C6B),

      body: SafeArea(
        child: ListenableBuilder(
          listenable: estado,

          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const SizedBox(height: 25),

                  // =========================
                  // TITULO
                  // =========================
                  const Text(
                    'BIENVENIDO A',
                    style: TextStyle(
                      color: Color(0xFFC5BFEE),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'ExRE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Explorador de Recursos de Estudio',
                    style: TextStyle(color: Color(0xFFC5BFEE), fontSize: 15),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // CICLO DE VIDA
                  // =========================
                  const Text(
                    'Estado del ciclo de vida',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2789),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF443BA5)),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,

                          decoration: BoxDecoration(
                            color: _colorEstado(estado.estadoCicloVidaActual),
                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            _iconoEstado(estado.estadoCicloVidaActual),
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                estado.ultimoEvento,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                _descripcionEstado(
                                  estado.estadoCicloVidaActual,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFFC5BFEE),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // ACCESOS RAPIDOS
                  // =========================
                  const Text(
                    'Accesos rapidos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _accesoRapido(
                          icono: Icons.menu_book,
                          titulo: 'Catalogo',
                          color: const Color(0xFF0553B1),
                          indice: 1,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _accesoRapido(
                          icono: Icons.grid_view,
                          titulo: 'Galeria',
                          color: const Color(0xFF7C3AED),
                          indice: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _accesoRapido(
                          icono: Icons.favorite,
                          titulo: 'Favoritos',
                          color: const Color(0xFFF43F5E),
                          indice: 3,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _accesoRapido(
                          icono: Icons.bar_chart,
                          titulo: 'Progreso',
                          color: const Color(0xFF16A34A),
                          indice: 4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // RESUMEN
                  // =========================
                  const Text(
                    'Resumen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _resumen(
                          '${estado.cantidadTotal}',
                          'Recursos',
                          Icons.library_books,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _resumen(
                          '${estado.cantidadFavoritos}',
                          'Favoritos',
                          Icons.favorite,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _resumen(
                          '${estado.cantidadCompletados}',
                          'Completados',
                          Icons.check_circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =========================
                  // HISTORIAL
                  // =========================
                  const Text(
                    'Historial reciente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2789),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        for (final evento
                            in estado.historialCicloVida.reversed.take(5))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF16A34A),
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  evento,
                                  style: const TextStyle(
                                    color: Color(0xFFC5BFEE),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // ACCESO RAPIDO
  // =========================================================

  Widget _accesoRapido({
    required IconData icono,
    required String titulo,
    required Color color,
    required int indice,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        cambiarPantalla(indice);
      },

      child: Container(
        height: 115,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: const Color(0xFF2E2789),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF443BA5)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icono, color: color, size: 30),

            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // RESUMEN
  // =========================================================

  Widget _resumen(String numero, String texto, IconData icono) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),

      decoration: BoxDecoration(
        color: const Color(0xFF2E2789),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [
          Icon(icono, color: const Color(0xFFC5BFEE), size: 23),

          const SizedBox(height: 7),

          Text(
            numero,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF948CCB), fontSize: 10),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DESCRIPCION DEL ESTADO
  // =========================================================

  String _descripcionEstado(AppLifecycleState estadoActual) {
    switch (estadoActual) {
      case AppLifecycleState.resumed:
        return 'La app esta activa y visible';

      case AppLifecycleState.inactive:
        return 'La app esta inactiva';

      case AppLifecycleState.hidden:
        return 'La app esta oculta';

      case AppLifecycleState.paused:
        return 'La app esta en segundo plano';

      case AppLifecycleState.detached:
        return 'La app esta separada del motor';
    }
  }

  // =========================================================
  // ICONO DEL ESTADO
  // =========================================================

  IconData _iconoEstado(AppLifecycleState estadoActual) {
    switch (estadoActual) {
      case AppLifecycleState.resumed:
        return Icons.visibility;

      case AppLifecycleState.inactive:
        return Icons.visibility_off;

      case AppLifecycleState.hidden:
        return Icons.hide_source;

      case AppLifecycleState.paused:
        return Icons.pause_circle;

      case AppLifecycleState.detached:
        return Icons.link_off;
    }
  }

  // =========================================================
  // COLOR DEL ESTADO
  // =========================================================

  Color _colorEstado(AppLifecycleState estadoActual) {
    switch (estadoActual) {
      case AppLifecycleState.resumed:
        return const Color(0xFF16A34A);

      case AppLifecycleState.inactive:
        return const Color(0xFFF59E0B);

      case AppLifecycleState.hidden:
        return const Color(0xFF7C3AED);

      case AppLifecycleState.paused:
        return const Color(0xFFDB2777);

      case AppLifecycleState.detached:
        return const Color(0xFFDC2626);
    }
  }
}
