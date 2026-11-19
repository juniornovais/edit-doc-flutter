import 'package:flutter/material.dart';

import 'models/services/preferences_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/cadastro_view.dart';
import 'views/editor_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

void main() {
  runApp(EditDocApp(authViewModel: AuthViewModel()));
}

class EditDocApp extends StatelessWidget {
  EditDocApp({super.key, AuthViewModel? authViewModel})
    : authViewModel = authViewModel ?? AuthViewModel();

  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Editor de Documentos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: authViewModel.themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginView(authViewModel: authViewModel),
          '/cadastro': (context) => CadastroView(authViewModel: authViewModel),
          '/home': (context) => HomeView(authViewModel: authViewModel),
          '/editor': (context) => EditorView(authViewModel: authViewModel),
        },
      ),
    );
  }

  static Future<ThemeMode> loadTheme() async {
    final isDark = await PreferencesService().carregarTema();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
