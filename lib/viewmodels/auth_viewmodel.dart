import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/banco_local_service.dart';
import '../services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BancoLocalService _bancoService = BancoLocalService();
  final PreferencesService _prefsService = PreferencesService();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Usuario? _usuarioLogado;
  Usuario? get usuarioLogado => _usuarioLogado;

  AuthViewModel() {
    _carregarConfiguracoesIniciais();
  }

  Future<void> _carregarConfiguracoesIniciais() async {
    _isDarkMode = await _prefsService.carregarTema();
    notifyListeners();
  }

  Future<void> alternarTema(bool valor) async {
    _isDarkMode = valor;
    await _prefsService.salvarTema(valor);
    notifyListeners();
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    Usuario novo = Usuario(nome: nome, email: email, senha: senha);
    bool sucesso = await _bancoService.cadastrarUsuario(novo);
    return sucesso;
  }

  Future<bool> login(String email, String senha) async {
    Usuario? usuario = await _bancoService.autenticar(email, senha);
    if (usuario != null) {
      _usuarioLogado = usuario;
      await _prefsService.salvarSessao(email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _usuarioLogado = null;
    await _prefsService.limparSessao();
    notifyListeners();
  }
}