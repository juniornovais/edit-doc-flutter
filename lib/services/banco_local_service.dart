import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../models/documento.dart';

class BancoLocalService {
  static const String _keyUsuarios = 'usuarios_db';
  static const String _keyDocumentos = 'documentos_db';

  Future<List<Usuario>> getUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyUsuarios);
    if (data == null) return [];
    List decoded = jsonDecode(data);
    return decoded.map((e) => Usuario.fromJson(e)).toList();
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    if (usuarios.any((u) => u.email == usuario.email)) {
      return false; // E-mail já cadastrado
    }
    usuarios.add(usuario);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDocumentos, jsonEncode(usuarios.map((u) => u.toJson()).toList()));
    return true;
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final usuarios = await getUsuarios();
    try {
      return usuarios.firstWhere((u) => u.email == email && u.senha == senha);
    } catch (_) {
      return null;
    }
  }

  Future<List<Documento>> getDocumentos() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyDocumentos);
    if (data == null) return [];
    List decoded = jsonDecode(data);
    return decoded.map((e) => Documento.fromJson(e)).toList();
  }

  Future<void> salvarDocumentos(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDocumentos, jsonEncode(documentos.map((e) => e.toJson()).toList()));
  }
}