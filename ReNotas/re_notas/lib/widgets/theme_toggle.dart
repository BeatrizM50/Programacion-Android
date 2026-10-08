import 'package:flutter/material.dart';

import '../app_state.dart';

// Botón minimalista para alternar entre tema claro y oscuro.
class ThemeToggleButton extends StatelessWidget {
  final AppState appState;
  const ThemeToggleButton({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return IconButton(
          tooltip: appState.esOscuro ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro',
          icon: Icon(
            appState.esOscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: appState.alternarTema,
        );
      },
    );
  }
}
