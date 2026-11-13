import 'package:flutter/material.dart';
import '../models/documento.dart';
import '../services/banco_local_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final BancoLocalService _bancoService = BancoLocalService();
  List<Documento> _documentos = [];
  bool _isLoading = false;

  List<Documento> get documentos => _documentos;
  bool get isLoading => _isLoading;

  Future<void> carregarDocumentos() async {
    _isLoading = true;
    notifyListeners();
    _documentos = await _bancoService.getDocumentos();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarDocumento(String titulo, String conteudo) async {
    final novo = Documento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
      ultimaModificacao: DateTime.now(),
    );
    _documentos.add(novo);
    await _bancoService.salvarDocumentos(_documentos);
    notifyListeners();
  }

  Future<void> atualizarDocumento(String id, String titulo, String conteudo) async {
    final index = _documentos.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documentos[index].titulo = titulo;
      _documentos[index].conteudo = conteudo;
      _documentos[index].ultimaModificacao = DateTime.now();
      await _bancoService.salvarDocumentos(_documentos);
      notifyListeners();
    }
  }

  Future<void> excluirDocumento(String id) async {
    _documentos.removeWhere((doc) => doc.id == id);
    await _bancoService.salvarDocumentos(_documentos);
    notifyListeners();
  }
}