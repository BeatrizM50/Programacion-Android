import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int indiceActual;
  final Function(int) alSeleccionar;

  const BottomNavigation({
    super.key,
    required this.indiceActual,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,

      onTap: alSeleccionar,

      backgroundColor: const Color(0xFF2E2789),

      selectedItemColor: Colors.white,

      unselectedItemColor: const Color(0xFF948CCB),

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),

        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catálogo'),

        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Galería'),

        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),

        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progreso'),
      ],
    );
  }
}
