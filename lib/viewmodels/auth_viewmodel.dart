import 'package:flutter/material.dart';

import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    BancoLocalService? bancoService,
    PreferencesService? preferencesService,
  }) : _bancoService = bancoService ?? BancoLocalService(),
       _preferencesService = preferencesService ?? PreferencesService() {
    _carregarPreferencias();
  }

  final BancoLocalService _bancoService;
  final PreferencesService _preferencesService;
  Usuario? _usuarioLogado;
  bool _isDarkMode = false;
  bool _isLoading = false;
  bool _notificacoesAtivadas = true;

  Usuario? get usuarioLogado => _usuarioLogado;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isLoading => _isLoading;
  bool get notificacoesAtivadas => _notificacoesAtivadas;

  Future<void> _carregarPreferencias() async {
    _isDarkMode = await _preferencesService.carregarTema();
    _notificacoesAtivadas = await _preferencesService.carregarNotificacoes();
    final email = await _preferencesService.carregarSessao();
    if (email != null) {
      _usuarioLogado = await _bancoService.buscarUsuarioPorEmail(email);
    }
    notifyListeners();
  }

  Future<void> alternarTema(bool isDark) async {
    _isDarkMode = isDark;
    await _preferencesService.salvarTema(isDark);
    notifyListeners();
  }

  Future<void> salvarNotificacoes(bool enabled) async {
    _notificacoesAtivadas = enabled;
    await _preferencesService.salvarNotificacoes(enabled);
    notifyListeners();
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    return _bancoService.cadastrarUsuario(
      Usuario(nome: nome, email: email, senha: senha),
    );
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();
    final usuario = await _bancoService.autenticar(email, senha);
    _isLoading = false;
    if (usuario == null) {
      notifyListeners();
      return false;
    }
    _usuarioLogado = usuario;
    await _preferencesService.salvarSessao(email);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _usuarioLogado = null;
    await _preferencesService.limparSessao();
    notifyListeners();
  }
}
