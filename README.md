# Edit Doc Flutter

Editor de documentos Flutter com arquitetura MVVM e persistência local
compatível com Flutter Web por meio de `shared_preferences`.

## Executar

```bash
flutter pub get
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

O usuário inicial para demonstração é `prof@email.com` com senha `123456`.

## Relatório de migração arquitetural

### 1. Mapeamento de classes e widgets

| Responsabilidade | Arquivo |
| --- | --- |
| Ponto de entrada, `MaterialApp`, tema e rotas | `lib/main.dart` |
| Entidades `Usuario` e `Documento` | `lib/models/usuario.dart`, `lib/models/documento.dart` |
| Persistência de usuários e documentos | `lib/models/services/banco_local_service.dart` |
| Persistência de tema, sessão e notificações | `lib/models/services/preferences_service.dart` |
| Login, cadastro, sessão e tema | `lib/viewmodels/auth_viewmodel.dart` |
| Estado e CRUD de documentos | `lib/viewmodels/documentos_viewmodel.dart` |
| Telas de login, cadastro, lista e editor | `lib/views/login_view.dart`, `cadastro_view.dart`, `home_view.dart`, `editor_view.dart` |
| Validações de nome, e-mail e senha | `lib/utils/validadores.dart` |

### 2. Alterações de estrutura e imports

O código antes concentrado em um único arquivo foi dividido por
responsabilidade. Os modelos receberam construtores e serialização JSON; os
serviços passaram a encapsular `shared_preferences`; e as telas recebem os
ViewModels por construtor. O `MaterialApp` centraliza as rotas nomeadas `/`,
`/cadastro`, `/home` e `/editor`, enquanto imports relativos deixam explícitas
as dependências entre camadas.

### 3. Mudanças no gerenciamento de estado

Os `setState` relacionados a login, cadastro, tema, sessão e documentos foram
removidos das Views. Esses valores agora pertencem a `AuthViewModel` e
`DocumentosViewModel`, que estendem `ChangeNotifier` e chamam
`notifyListeners()` após cada alteração ou operação de persistência.
As Views observam os ViewModels com `ListenableBuilder`; assim, a interface
reage às mudanças sem executar regras de negócio ou acesso direto ao banco.

## CRUD e persistência

Documentos são serializados com `jsonEncode` e `jsonDecode` e ficam salvos na
chave `documentos_db`. Tema, sessão e notificações ficam em chaves próprias.
O editor cria ou atualiza documentos; a tela inicial lista, edita e exclui
registros, que permanecem após recarregar o preview.
