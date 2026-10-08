import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/buscar_screen.dart';
import 'screens/etiquetas_screen.dart';
import 'screens/proyectos_screen.dart';

// Navegación básica con BottomNavigationBar (solo Navigator.push en toda la app).
// Cada destino conserva su estado con IndexedStack + keep-alive.

class HomeShell extends StatefulWidget {
  final AppState appState;
  const HomeShell({super.key, required this.appState});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: [
          ProyectosScreen(appState: widget.appState),
          EtiquetasScreen(appState: widget.appState),
          BuscarScreen(appState: widget.appState),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            activeIcon: Icon(Icons.label),
            label: 'Etiquetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
        ],
      ),
    );
  }
}
