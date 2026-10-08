import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_theme.dart';
import 'home_shell.dart';

// Tema editorial minimalista claro/oscuro, conmutable en la app.
// Estado solo con ChangeNotifier del SDK (ListenableBuilder).

void main() {
  final appState = AppState();
  runApp(ReNotesApp(appState: appState));
}

class ReNotesApp extends StatelessWidget {
  final AppState appState;
  const ReNotesApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'ReNotes',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: appState.themeMode,
          home: HomeShell(appState: appState),
        );
      },
    );
  }
}
