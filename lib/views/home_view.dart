import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.authViewModel});

  final AuthViewModel authViewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final DocumentosViewModel _documentosViewModel;

  @override
  void initState() {
    super.initState();
    _documentosViewModel = DocumentosViewModel()..carregarDocumentos();
  }

  @override
  void dispose() {
    _documentosViewModel.dispose();
    super.dispose();
  }

  Future<void> _excluir(Documento documento) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir documento?'),
        content: Text('O documento "${documento.titulo}" será removido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _documentosViewModel.excluirDocumento(documento.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = widget.authViewModel.usuarioLogado?.nome ?? 'Usuário';
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $nome'),
        actions: [
          IconButton(
            tooltip: 'Tema escuro',
            icon: Icon(
              widget.authViewModel.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => widget.authViewModel.alternarTema(
              !widget.authViewModel.isDarkMode,
            ),
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.authViewModel.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _documentosViewModel,
        builder: (context, _) {
          if (_documentosViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_documentosViewModel.documentos.isEmpty) {
            return const Center(child: Text('Nenhum documento criado.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _documentosViewModel.documentos.length,
            itemBuilder: (context, index) {
              final documento = _documentosViewModel.documentos[index];
              return Card(
                child: ListTile(
                  title: Text(documento.titulo),
                  subtitle: Text(
                    documento.conteudo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/editor',
                    arguments: {
                      'documento': documento,
                      'viewModel': _documentosViewModel,
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _excluir(documento),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          '/editor',
          arguments: {'viewModel': _documentosViewModel},
        ),
        icon: const Icon(Icons.add),
        label: const Text('Novo documento'),
      ),
    );
  }
}
