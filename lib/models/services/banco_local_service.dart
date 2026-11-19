import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';
import '../usuario.dart';

class BancoLocalService {
  static const _usuariosKey = 'usuarios_db';
  static const _documentosKey = 'documentos_db';

  Future<List<Usuario>> getUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usuariosKey);
    if (data == null) {
      return [
        Usuario(nome: 'Professor', email: 'prof@email.com', senha: '123456'),
      ];
    }
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded
        .map((item) => Usuario.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    if (usuarios.any((item) => item.email == usuario.email)) return false;
    usuarios.add(usuario);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usuariosKey,
      jsonEncode(usuarios.map((item) => item.toJson()).toList()),
    );
    return true;
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final usuarios = await getUsuarios();
    for (final usuario in usuarios) {
      if (usuario.email == email && usuario.senha == senha) return usuario;
    }
    return null;
  }

  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    final usuarios = await getUsuarios();
    for (final usuario in usuarios) {
      if (usuario.email == email) return usuario;
    }
    return null;
  }

  Future<List<Documento>> getDocumentos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_documentosKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded
        .map((item) => Documento.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvarDocumentos(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _documentosKey,
      jsonEncode(documentos.map((item) => item.toJson()).toList()),
    );
  }
}
