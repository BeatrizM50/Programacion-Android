import 'package:flutter/material.dart';

import 'estado/app_state.dart';

import 'pantallas/inicio.dart';
import 'pantallas/catalogo.dart';
import 'pantallas/galeria.dart';
import 'pantallas/favoritos.dart';
import 'pantallas/progreso.dart';

import 'widgets/boton_de_navegacion.dart';

void main() {
  runApp(const ExREApp());
}

class ExREApp extends StatelessWidget {
  const ExREApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ExRE',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFF231C6B),
      ),

      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal>
    with WidgetsBindingObserver {
  // Estado general de toda la aplicación.
  final AppState estado = AppState();

  // Pantalla que está seleccionada actualmente.
  int indiceActual = 0;

  @override
  void initState() {
    super.initState();

    // Comenzamos a escuchar los cambios
    // del ciclo de vida de la aplicación.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Dejamos de escuchar el ciclo de vida.
    WidgetsBinding.instance.removeObserver(this);

    // Liberamos el estado.
    estado.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState nuevoEstado) {
    estado.registrarCicloVida(nuevoEstado);
  }

  void cambiarPantalla(int indice) {
    setState(() {
      indiceActual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _crearPantalla(),

      bottomNavigationBar: BottomNavigation(
        indiceActual: indiceActual,
        alSeleccionar: cambiarPantalla,
      ),
    );
  }

  Widget _crearPantalla() {
    switch (indiceActual) {
      case 0:
        return InicioScreen(estado: estado, cambiarPantalla: cambiarPantalla);

      case 1:
        return CatalogoScreen(estado: estado);

      case 2:
        return GaleriaScreen(estado: estado);

      case 3:
        return FavoritosScreen(estado: estado);

      case 4:
        return ProgresoScreen(estado: estado);

      default:
        return InicioScreen(estado: estado, cambiarPantalla: cambiarPantalla);
    }
  }
}
