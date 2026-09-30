import 'package:flutter/material.dart';

import '../estado/app_state.dart';
import '../modelos/recurso.dart';
import 'detalle.dart';

class CatalogoScreen extends StatelessWidget {
  final AppState estado;

  const CatalogoScreen({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231C6B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF231C6B),
        foregroundColor: Colors.white,

        title: const Text(
          'Catalogo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: estado,

        builder: (context, child) {
          final List<Recurso> recursosFiltrados = estado.filtrarRecursos(
            texto: estado.textoBusqueda,
            categoria: estado.categoriaSeleccionada,
          );

          return Column(
            children: [
              // =================================================
              // BUSCADOR
              // =================================================

              Padding(
                padding: const EdgeInsets.all(16),

                child: TextField(
                  style: const TextStyle(color: Colors.white),

                  onChanged: (texto) {
                    estado.actualizarBusqueda(texto);
                  },

                  decoration: InputDecoration(
                    hintText: 'Buscar por titulo, categoria o autor',

                    hintStyle: const TextStyle(color: Color(0xFFC5BFEE)),

                    prefixIcon: const Icon(Icons.search, color: Colors.white),

                    suffixIcon: estado.textoBusqueda.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              estado.actualizarBusqueda('');
                            },
                          )
                        : null,

                    filled: true,

                    fillColor: const Color(0xFF2E2789),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // =================================================
              // CATEGORIAS
              // =================================================
              SizedBox(
                height: 50,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  children: [
                    _botonCategoria('Todas'),

                    _botonCategoria('Flutter'),

                    _botonCategoria('Android'),

                    _botonCategoria('Layouts'),

                    _botonCategoria('Scrollables'),

                    _botonCategoria('Slivers'),

                    _botonCategoria('Navegacion'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // =================================================
              // RESULTADOS
              // =================================================
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Text(
                    'RESULTADOS (${recursosFiltrados.length})',

                    style: const TextStyle(
                      color: Color(0xFFC5BFEE),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // =================================================
              // LISTA
              // =================================================
              Expanded(
                child: recursosFiltrados.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron recursos',

                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        itemCount: recursosFiltrados.length,

                        itemBuilder: (context, index) {
                          final Recurso recurso = recursosFiltrados[index];

                          return _tarjetaRecurso(context, recurso);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================================
  // BOTON CATEGORIA
  // ===========================================================

  Widget _botonCategoria(String categoria) {
    final bool seleccionado = estado.categoriaSeleccionada == categoria;

    return Padding(
      padding: const EdgeInsets.only(right: 8),

      child: ChoiceChip(
        label: Text(categoria),

        selected: seleccionado,

        onSelected: (valor) {
          if (valor) {
            estado.actualizarCategoria(categoria);
          }
        },

        selectedColor: const Color(0xFF4F46E5),

        backgroundColor: const Color(0xFF2E2789),

        labelStyle: TextStyle(
          color: seleccionado ? Colors.white : const Color(0xFFC5BFEE),
        ),
      ),
    );
  }

  // ===========================================================
  // TARJETA
  // ===========================================================

  Widget _tarjetaRecurso(BuildContext context, Recurso recurso) {
    return Card(
      color: const Color(0xFF2E2789),

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: InkWell(
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

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              // =================================================
              // ICONO
              // =================================================

              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: _obtenerColor(recurso.color),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              // =================================================
              // INFORMACION
              // =================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      recurso.categoria.toUpperCase(),

                      style: const TextStyle(
                        color: Color(0xFFC5BFEE),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      recurso.titulo,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${recurso.autor} · '
                      '${recurso.duracion} min · '
                      '${recurso.nivel}',

                      style: const TextStyle(
                        color: Color(0xFF948CCB),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // FAVORITO
              // =================================================
              IconButton(
                onPressed: () {
                  estado.cambiarFavorito(recurso);
                },

                icon: Icon(
                  recurso.favorito ? Icons.favorite : Icons.favorite_border,

                  color: recurso.favorito
                      ? const Color(0xFFF43F5E)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // COLORES
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
