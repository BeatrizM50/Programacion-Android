import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/recurso.dart';

class ProgresoScreen extends StatelessWidget {
  final AppState estado;

  const ProgresoScreen({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231C6B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF231C6B),
        foregroundColor: Colors.white,

        title: const Text(
          'Progreso',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: estado,

        builder: (context, child) {
          final int total = estado.cantidadTotal;
          final int completados = estado.cantidadCompletados;
          final int pendientes = estado.cantidadPendientes;

          final double porcentaje = estado.porcentajeProgreso;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================================
                // PORCENTAJE
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2789),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF443BA5)),
                  ),

                  child: Column(
                    children: [
                      Text(
                        '${(porcentaje * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Progreso de estudio',
                        style: TextStyle(
                          color: Color(0xFFC5BFEE),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 18),

                      LinearProgressIndicator(
                        value: porcentaje,
                        minHeight: 10,

                        backgroundColor: const Color(0xFF443BA5),

                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // COMPLETADOS / PENDIENTES
                // =================================================
                Row(
                  children: [
                    Expanded(
                      child: _contador(
                        numero: '$completados',
                        texto: 'Completados',
                        icono: Icons.check_circle,
                        color: const Color(0xFF16A34A),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _contador(
                        numero: '$pendientes',
                        texto: 'Pendientes',
                        icono: Icons.pending,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: _contador(
                        numero: '$total',
                        texto: 'Total',
                        icono: Icons.library_books,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // =================================================
                // ULTIMO EVENTO
                // =================================================
                const Text(
                  'Ultimo evento de ciclo de vida',
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
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.sync,
                        color: Color(0xFFC5BFEE),
                        size: 25,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          estado.ultimoEvento,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // RESUMEN POR CATEGORIA
                // =================================================
                const Text(
                  'Resumen por categoria',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                _resumenCategoria('Flutter'),
                _resumenCategoria('Android'),
                _resumenCategoria('Layouts'),
                _resumenCategoria('Scrollables'),
                _resumenCategoria('Slivers'),
                _resumenCategoria('Navegacion'),

                const SizedBox(height: 30),

                // =================================================
                // RECURSOS COMPLETADOS
                // =================================================
                const Text(
                  'Recursos completados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                if (estado.completados.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2789),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: const Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF948CCB),
                          size: 40,
                        ),

                        SizedBox(height: 10),
                        Text(
                          'Todavia no has completado recursos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFC5BFEE),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: estado.completados.length,

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },

                    itemBuilder: (context, index) {
                      final recurso = estado.completados[index];

                      return _recursoCompletado(recurso);
                    },
                  ),

                const SizedBox(height: 25),

                // =================================================
                // HISTORIAL
                // =================================================
                const Text(
                  'Historial del ciclo de vida',
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
                      for (final evento in estado.historialCicloVida.reversed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 7,
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
              ],
            ),
          );
        },
      ),
    );
  }

  // ===========================================================
  // CONTADOR
  // ===========================================================

  Widget _contador({
    required String numero,
    required String texto,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),

      decoration: BoxDecoration(
        color: const Color(0xFF2E2789),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [
          Icon(icono, color: color, size: 24),

          const SizedBox(height: 7),

          Text(
            numero,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),

          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF948CCB), fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // RESUMEN POR CATEGORIA
  // ===========================================================

  Widget _resumenCategoria(String categoria) {
    final List<Recurso> recursosCategoria = estado.todosLosRecursos
        .where((recurso) => recurso.categoria == categoria)
        .toList();

    final int total = recursosCategoria.length;

    final int completados = recursosCategoria
        .where((recurso) => estado.idsCompletados.contains(recurso.id))
        .length;

    double porcentaje = 0;

    if (total > 0) {
      porcentaje = completados / total;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFF2E2789),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  categoria,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                '$completados/$total',
                style: const TextStyle(color: Color(0xFFC5BFEE), fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: porcentaje,
            minHeight: 6,

            backgroundColor: const Color(0xFF443BA5),

            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // RECURSO COMPLETADO
  // ===========================================================

  Widget _recursoCompletado(Recurso recurso) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: const Color(0xFF2E2789),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: const Color(0xFF16A34A),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(Icons.check, color: Colors.white),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
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

                const SizedBox(height: 4),

                Text(
                  '${recurso.categoria} · ${recurso.duracion} min',
                  style: const TextStyle(
                    color: Color(0xFF948CCB),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
