import 'package:flutter/foundation.dart';

import '../models/documento.dart';
import '../models/services/banco_local_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  DocumentosViewModel({BancoLocalService? bancoService})
    : _bancoService = bancoService ?? BancoLocalService();

  final BancoLocalService _bancoService;
  List<Documento> _documentos = [];
  bool _isLoading = false;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  bool get isLoading => _isLoading;

  Future<void> carregarDocumentos() async {
    _isLoading = true;
    notifyListeners();
    _documentos = await _bancoService.getDocumentos();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarDocumento(String titulo, String conteudo) async {
    _documentos.add(
      Documento(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: titulo,
        conteudo: conteudo,
        ultimaModificacao: DateTime.now(),
      ),
    );
    await _bancoService.salvarDocumentos(_documentos);
    notifyListeners();
  }

  Future<void> atualizarDocumento(
    String id,
    String titulo,
    String conteudo,
  ) async {
    final index = _documentos.indexWhere((documento) => documento.id == id);
    if (index == -1) return;
    final documento = _documentos[index];
    documento.titulo = titulo;
    documento.conteudo = conteudo;
    documento.ultimaModificacao = DateTime.now();
    await _bancoService.salvarDocumentos(_documentos);
    notifyListeners();
  }

  Future<void> excluirDocumento(String id) async {
    _documentos.removeWhere((documento) => documento.id == id);
    await _bancoService.salvarDocumentos(_documentos);
    notifyListeners();
  }
}
