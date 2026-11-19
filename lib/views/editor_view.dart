import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  const EditorView({super.key, required this.authViewModel});

  final AuthViewModel authViewModel;

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  Documento? _documento;
  DocumentosViewModel? _viewModel;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _documento = args['documento'] as Documento?;
      _viewModel = args['viewModel'] as DocumentosViewModel;
      _tituloController.text = _documento?.titulo ?? '';
      _conteudoController.text = _documento?.conteudo ?? '';
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    if (_documento == null) {
      await _viewModel!.adicionarDocumento(
        _tituloController.text.trim(),
        _conteudoController.text.trim(),
      );
    } else {
      await _viewModel!.atualizarDocumento(
        _documento!.id,
        _tituloController.text.trim(),
        _conteudoController.text.trim(),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_documento == null ? 'Novo documento' : 'Editar documento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o título'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _conteudoController,
              minLines: 10,
              maxLines: 18,
              decoration: const InputDecoration(
                labelText: 'Conteúdo',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o conteúdo'
                  : null,
            ),
            const SizedBox(height: 16),
            _saving
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar documento'),
                  ),
          ],
        ),
      ),
    );
  }
}
