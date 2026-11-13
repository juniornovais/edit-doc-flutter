port 'package:flutter/material.dart';







// ============================================================================



// SIMULADOR DE SHARED_PREFERENCES PARA DARTPAD (Evita o travamento do plugin)



// ============================================================================



class SharedPreferences {



 static final SharedPreferences _instancia = SharedPreferences._interno();



 final Map<String, dynamic> _dadosEmDisco = {};







 SharedPreferences._interno();







 static Future<SharedPreferences> getInstance() async {



  await Future.delayed(const Duration(milliseconds: 50));



  return _instancia;



 }







 Future<bool> setString(String chave, String valor) async {



  _dadosEmDisco[chave] = valor;



  return true;



 }



  



 Future<bool> setBool(String chave, bool valor) async {



  _dadosEmDisco[chave] = valor;



  return true;



 }







 String? getString(String chave) => _dadosEmDisco[chave] as String?;



 bool? getBool(String chave) => _dadosEmDisco[chave] as bool?;



}







// ============================================================================



// PERSISTÊNCIA ESTRUTURADA (SIMULADOR DE BANCO DE DADOS / SQLITE)



// ============================================================================



class Usuario {



 final String nome;



 final String email;



 final String senha;







 Usuario({required this.nome, required this.email, required this.senha});



}







class Post {



 final String usuario;



 final String avatar;



 final String tempo;



 final String conteudo;



 int curtidas;



 int comentarios;







 Post({



  required this.usuario,



  required this.avatar,



  required this.tempo,



  required this.conteudo,



  this.curtidas = 0,



  this.comentarios = 0,



 });



}







class BancoDadosLocal {



 static final List<Usuario> _tabelaUsuarios = [



  Usuario(nome: 'Professor', email: 'prof@email.com', senha: '123456'),



 ];







 static final List<Post> _tabelaPosts = [



  Post(



   usuario: 'Ana Silva',



   avatar: 'https://i.pravatar.cc/150?img=1',



   tempo: 'há 2 horas',



   conteudo: 'Explorando novas ideias de código hoje! 🚀 Alguém mais curtindo Flutter?',



   curtidas: 15,



   comentarios: 3,



  ),



 ];







 static Future<bool> cadastrarUsuario(Usuario novoUsuario) async {



  await Future.delayed(const Duration(milliseconds: 300));



  bool jaExiste = _tabelaUsuarios.any((u) => u.email == novoUsuario.email);



  if (jaExiste) return false;



  _tabelaUsuarios.add(novoUsuario);



  return true;



 }







 static Future<Usuario?> autenticar(String email, String senha) async {



  await Future.delayed(const Duration(milliseconds: 300));



  try {



   return _tabelaUsuarios.firstWhere(



    (u) => u.email == email && u.senha == senha,



   );



  } catch (e) {



   return null;



  }



 }







 static Future<List<Usuario>> obterTodosUsuarios() async {



  await Future.delayed(const Duration(milliseconds: 200));



  return List.unmodifiable(_tabelaUsuarios);



 }







 static Future<List<Post>> obterTodosPosts() async {



  await Future.delayed(const Duration(milliseconds: 200));



  return List.from(_tabelaPosts.reversed);



 }







 static Future<void> criarPost(Post novoPost) async {



  await Future.delayed(const Duration(milliseconds: 250));



  _tabelaPosts.add(novoPost);



 }



}







void main() {



 runApp(const MeuApp());



}







// ============================================================================



// VALIDADORES APRIMORADOS



// ============================================================================



String? validarNome(String? value) {



 if (value == null || value.trim().isEmpty) {



  return "Informe seu nome completo";



 }



 return null;



}







String? validarEmail(String? value) {



 if (value == null || value.trim().isEmpty) {



  return 'Informe um e-mail válido';



 }



 String email = value.trim().toLowerCase();



 bool temArroba = email.contains('@');



 bool terminaCorreto = email.endsWith('.com') || email.endsWith('.com.br');







 if (!temArroba || !terminaCorreto) {



  return 'O e-mail deve conter @ e terminar com .com ou .com.br';



 }



 return null;



}







String? validarSenha(String? value) {



 if (value == null || value.length < 6) {



  return 'A senha deve ter pelo menos 6 caracteres';



 }



 return null;



}







class MeuApp extends StatefulWidget {



 const MeuApp({super.key});







 static void setTema(BuildContext context, ThemeMode novoTema) {



  _MeuAppState? state = context.findAncestorStateOfType<_MeuAppState>();



  state?.alterarTema(novoTema);



 }







 @override



 State<MeuApp> createState() => _MeuAppState();



}







class _MeuAppState extends State<MeuApp> {



 ThemeMode _themeMode = ThemeMode.light;







 void alterarTema(ThemeMode novoTema) {



  setState(() {



   _themeMode = novoTema;



  });



 }







 @override



 Widget build(BuildContext context) {



  return MaterialApp(



   debugShowCheckedModeBanner: false,



   title: 'Aula de Roteamento e Form',



   theme: ThemeData(



    primarySwatch: Colors.blue,



    useMaterial3: true,



    brightness: Brightness.light,



   ),



   darkTheme: ThemeData(



    brightness: Brightness.dark,



    useMaterial3: true,



    primarySwatch: Colors.blue,



   ),



   themeMode: _themeMode,



   initialRoute: '/login',



   routes: {



    '/login': (context) => const TelaLogin(),



    '/cadastro': (context) => const TelaCadastro(),



    '/home': (context) => const TelaHome(),



   },



  );



 }



}







// ============================================================================



// TELA DE LOGIN



// ============================================================================



class TelaLogin extends StatefulWidget {



 const TelaLogin({super.key});







 @override



 State<TelaLogin> createState() => _TelaLoginState();



}







class _TelaLoginState extends State<TelaLogin> {



 final _formKey = GlobalKey<FormState>();



 final _emailController = TextEditingController();



 final _senhaController = TextEditingController();



 bool _carregando = false;







 void _fazerLogin() async {



  if (_formKey.currentState!.validate()) {



   setState(() => _carregando = true);



    



   Usuario? usuarioLogado = await BancoDadosLocal.autenticar(



    _emailController.text.trim(),



    _senhaController.text,



   );



    



   setState(() => _carregando = false);



    



   if (usuarioLogado != null) {



    if (!mounted) return;



    Navigator.pushReplacementNamed(



     context, 



     '/home', 



     arguments: usuarioLogado.nome,



    );



   } else {



    if (!mounted) return;



    ScaffoldMessenger.of(context).showSnackBar(



     const SnackBar(



      content: Text('E-mail ou senha incorretos! Usuário não cadastrado.'),



      backgroundColor: Colors.red,



     ),



    );



   }



  }



 }







 @override



 Widget build(BuildContext context) {



  return Scaffold(



   appBar: AppBar(title: const Text('Login')),



   body: Padding(



    padding: const EdgeInsets.all(16.0),



    child: Form(



     key: _formKey,



     child: Column(



      mainAxisAlignment: MainAxisAlignment.center,



      children: [



       TextFormField(



        controller: _emailController,



        decoration: const InputDecoration(



         labelText: 'E-mail (ex: seu@email.com)',



         border: OutlineInputBorder(),



        ),



        keyboardType: TextInputType.emailAddress,



        validator: validarEmail,



       ),



       const SizedBox(height: 12),



       TextFormField(



        controller: _senhaController,



        decoration: const InputDecoration(



         labelText: 'Senha',



         border: OutlineInputBorder(),



        ),



        obscureText: true,



        validator: validarSenha,



       ),



       const SizedBox(height: 24),



       _carregando



         ? const CircularProgressIndicator()



         : ElevatedButton(



           onPressed: _fazerLogin,



           child: const Text('Entrar'),



          ),



       TextButton(



        onPressed: () {



         Navigator.pushNamed(context, '/cadastro');



        },



        child: const Text('Não tem uma conta? Cadastre-se'),



       ),



      ],



     ),



    ),



   ),



  );



 }



}







// ============================================================================



// TELA DE CADASTRO (Apenas Credenciais e Notificações - Tema removido)



// ============================================================================



class TelaCadastro extends StatefulWidget {



 const TelaCadastro({super.key});







 @override



 State<TelaCadastro> createState() => _TelaCadastroState();



}







class _TelaCadastroState extends State<TelaCadastro> {



 final _formKey = GlobalKey<FormState>();



 final _nomeController = TextEditingController();



 final _emailController = TextEditingController();



 final _senhaController = TextEditingController();



  



 bool _notificacoesAtivadas = true;



 bool _carregando = false;







 void _cadastrar() async {



  if (_formKey.currentState!.validate()) {



   setState(() => _carregando = true);







   final prefs = await SharedPreferences.getInstance();



   await prefs.setBool('notificacoes_ativadas', _notificacoesAtivadas);







   Usuario novoUsuario = Usuario(



    nome: _nomeController.text.trim(),



    email: _emailController.text.trim(),



    senha: _senhaController.text,



   );







   bool sucesso = await BancoDadosLocal.cadastrarUsuario(novoUsuario);







   setState(() => _carregando = false);







   if (!mounted) return;







   if (sucesso) {



    ScaffoldMessenger.of(context).showSnackBar(



     const SnackBar(



      content: Text('Usuário cadastrado com sucesso!'),



      backgroundColor: Colors.green,



     ),



    );



    Navigator.pop(context);



   } else {



    ScaffoldMessenger.of(context).showSnackBar(



     const SnackBar(



      content: Text('Este e-mail já está cadastrado no sistema!'),



      backgroundColor: Colors.red,



     ),



    );



   }



  }



 }







 @override



 Widget build(BuildContext context) {



  return Scaffold(



   appBar: AppBar(title: const Text('Cadastro de Usuário')),



   body: Padding(



    padding: const EdgeInsets.all(16.0),



    child: Form(



     key: _formKey,



     child: ListView(



      children: [



       const Text(



        'Credenciais de Acesso',



        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),



       ),



       const SizedBox(height: 8),



       TextFormField(



        controller: _nomeController,



        decoration: const InputDecoration(



         labelText: 'Nome Completo',



         border: OutlineInputBorder(),



        ),



        validator: validarNome,



       ),



       const SizedBox(height: 12),



       TextFormField(



        controller: _emailController,



        decoration: const InputDecoration(



         labelText: 'E-mail (ex: teste@email.com.br)',



         border: OutlineInputBorder(),



        ),



        keyboardType: TextInputType.emailAddress,



        validator: validarEmail,



       ),



       const SizedBox(height: 12),



       TextFormField(



        controller: _senhaController,



        decoration: const InputDecoration(



         labelText: 'Senha (mín. 6 caracteres)',



         border: OutlineInputBorder(),



        ),



        obscureText: true,



        validator: validarSenha,



       ),



       const SizedBox(height: 20),



       const Divider(),



       const Text(



        'Preferências do Aplicativo',



        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),



       ),



       const SizedBox(height: 8),



       SwitchListTile(



        title: const Text('Ativar Notificações Push'),



        subtitle: const Text('Receber alertas de novas publicações'),



        value: _notificacoesAtivadas,



        onChanged: (value) {



         setState(() {



          _notificacoesAtivadas = value;



         });



        },



       ),



       const SizedBox(height: 24),



       _carregando



         ? const Center(child: CircularProgressIndicator())



         : ElevatedButton(



           onPressed: _cadastrar,



           child: const Text('Salvar Cadastro'),



          ),



      ],



     ),



    ),



   ),



  );



 }



}







// ============================================================================



// TELA HOME COM POP-UP DE TEMA NO CANTO DIREITO INFERIOR



// ============================================================================



class TelaHome extends StatefulWidget {



 const TelaHome({super.key});







 @override



 State<TelaHome> createState() => _TelaHomeState();



}







class _TelaHomeState extends State<TelaHome> {



 late Future<List<Post>> _futurePosts;







 @override



 void initState() {



  super.initState();



  _atualizarFeed();



 }







 void _atualizarFeed() {



  setState(() {



   _futurePosts = BancoDadosLocal.obterTodosPosts();



  });



 }







 void _mostrarPreferenciasSalvas(BuildContext context) async {



  final prefs = await SharedPreferences.getInstance();



  bool notificacoes = prefs.getBool('notificacoes_ativadas') ?? false;







  if (!context.mounted) return;







  showDialog(



   context: context,



   builder: (context) => AlertDialog(



    title: const Text('Preferências do Usuário'),



    content: Column(



     mainAxisSize: MainAxisSize.min,



     crossAxisAlignment: CrossAxisAlignment.start,



     children: [



      Text('Notificações: ${notificacoes ? 'Ativadas' : 'Desativadas'}'),



     ],



    ),



    actions: [



     TextButton(



      onPressed: () => Navigator.pop(context),



      child: const Text('Fechar'),



     ),



    ],



   ),



  );



 }







 void _mostrarUsuariosCadastrados(BuildContext context) async {



  List<Usuario> usuarios = await BancoDadosLocal.obterTodosUsuarios();







  if (!context.mounted) return;







  showModalBottomSheet(



   context: context,



   builder: (context) => Container(



    padding: const EdgeInsets.all(16),



    child: Column(



     crossAxisAlignment: CrossAxisAlignment.start,



     mainAxisSize: MainAxisSize.min,



     children: [



      const Text(



       'Usuários no Banco Local (SQLite Simulado)',



       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),



      ),



      const Divider(),



      Expanded(



       child: ListView.builder(



        shrinkWrap: true,



        itemCount: usuarios.length,



        itemBuilder: (context, index) {



         final u = usuarios[index];



         return ListTile(



          leading: const Icon(Icons.person),



          title: Text(u.nome),



          subtitle: Text(u.email),



         );



        },



       ),



      ),



     ],



    ),



   ),



  );



 }







 void _mostrarPopupTema(BuildContext context) {



  showGeneralDialog(



   context: context,



   barrierDismissible: true,



   barrierLabel: 'Tema',



   transitionDuration: const Duration(milliseconds: 200),



   pageBuilder: (context, anim1, anim2) {



    return Align(



     alignment: Alignment.bottomRight,



     child: Padding(



      padding: const EdgeInsets.only(right: 16.0, bottom: 80.0),



      child: Material(



       elevation: 6,



       borderRadius: BorderRadius.circular(12),



       child: Container(



        width: 200,



        padding: const EdgeInsets.all(12),



        child: Column(



         mainAxisSize: MainAxisSize.min,



         crossAxisAlignment: CrossAxisAlignment.start,



         children: [



          const Text(



           'Escolha o Tema:',



           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),



          ),



          const Divider(),



          ListTile(



           dense: true,



           leading: const Icon(Icons.wb_sunny, color: Colors.orange),



           title: const Text('Claro'),



           onTap: () {



            MeuApp.setTema(context, ThemeMode.light);



            Navigator.pop(context);



           },



          ),



          ListTile(



           dense: true,



           leading: const Icon(Icons.nightlight_round, color: Colors.indigo),



           title: const Text('Escuro'),



           onTap: () {



            MeuApp.setTema(context, ThemeMode.dark);



            Navigator.pop(context);



           },



          ),



         ],



        ),



       ),



      ),



     ),



    );



   },



  );



 }







 void _abrirModalCriarPost(String nomeUsuarioLogado) {



  final conteudoController = TextEditingController();







  showModalBottomSheet(



   context: context,



   isScrollControlled: true,



   builder: (context) {



    return Padding(



     padding: EdgeInsets.only(



      bottom: MediaQuery.of(context).viewInsets.bottom,



      left: 16,



      right: 16,



      top: 16,



     ),



     child: Column(



      mainAxisSize: MainAxisSize.min,



      crossAxisAlignment: CrossAxisAlignment.stretch,



      children: [



       const Text(



        'Criar Nova Publicação',



        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),



       ),



       const SizedBox(height: 12),



       TextField(



        controller: conteudoController,



        maxLines: 4,



        decoration: const InputDecoration(



         hintText: 'O que você está pensando?',



         border: OutlineInputBorder(),



        ),



       ),



       const SizedBox(height: 16),



       ElevatedButton(



        onPressed: () async {



         if (conteudoController.text.trim().isNotEmpty) {



          Post novoPost = Post(



           usuario: nomeUsuarioLogado,



           avatar: 'https://i.pravatar.cc/150?img=12',



           tempo: 'agora mesmo',



           conteudo: conteudoController.text.trim(),



          );







          await BancoDadosLocal.criarPost(novoPost);







          if (!mounted) return;



          Navigator.pop(context);



          _atualizarFeed();







          ScaffoldMessenger.of(context).showSnackBar(



           const SnackBar(content: Text('Post publicado com sucesso!')),



          );



         }



        },



        child: const Text('Publicar'),



       ),



       const SizedBox(height: 24),



      ],



     ),



    );



   },



  );



 }







 @override



 Widget build(BuildContext context) {



  final String nomeUsuario = ModalRoute.of(context)?.settings.arguments as String? ?? 'Visitante';







  return Scaffold(



   appBar: AppBar(



    title: Text('Bem-vindo(a), $nomeUsuario'),



    actions: [



     IconButton(



      icon: const Icon(Icons.refresh),



      onPressed: _atualizarFeed,



     ),



     IconButton(



      icon: const Icon(Icons.logout),



      onPressed: () {



       Navigator.pushReplacementNamed(context, '/login');



      },



     )



    ],



   ),



   body: Column(



    children: [



     Padding(



      padding: const EdgeInsets.all(8.0),



      child: Row(



       children: [



        Expanded(



         child: InkWell(



          onTap: () => _mostrarPreferenciasSalvas(context),



          child: Card(



           color: Colors.blue.shade50,



           child: const Padding(



            padding: EdgeInsets.all(12.0),



            child: Column(



             children: [



              Icon(Icons.settings, color: Colors.blue),



              SizedBox(height: 4),



              Text('Ver Preferências', style: TextStyle(fontWeight: FontWeight.bold)),



             ],



            ),



           ),



          ),



         ),



        ),



        Expanded(



         child: InkWell(



          onTap: () => _mostrarUsuariosCadastrados(context),



          child: Card(



           color: Colors.green.shade50,



           child: const Padding(



            padding: EdgeInsets.all(12.0),



            child: Column(



             children: [



              Icon(Icons.storage, color: Colors.green),



              SizedBox(height: 4),



              Text('Ver Usuários', style: TextStyle(fontWeight: FontWeight.bold)),



             ],



            ),



           ),



          ),



         ),



        ),



       ],



      ),



     ),



     const Divider(),



     const Text(



      'Feed de Publicações do Banco Local',



      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),



     ),



     const SizedBox(height: 4),



     Expanded(



      child: FutureBuilder<List<Post>>(



       future: _futurePosts,



       builder: (context, snapshot) {



        if (snapshot.connectionState == ConnectionState.waiting) {



         return const Center(child: CircularProgressIndicator());



        }



        if (snapshot.hasError) {



         return Center(child: Text('Erro ao carregar posts: ${snapshot.error}'));



        }







        final posts = snapshot.data ?? [];







        if (posts.isEmpty) {



         return const Center(



          child: Text('Nenhuma publicação encontrada no banco de dados.'),



         );



        }







        return ListView.builder(



         itemCount: posts.length,



         itemBuilder: (context, index) {



          final post = posts[index];



          return Card(



           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),



           elevation: 2,



           shape: RoundedRectangleBorder(



            borderRadius: BorderRadius.circular(12),



           ),



           child: Padding(



            padding: const EdgeInsets.all(12.0),



            child: Column(



             crossAxisAlignment: CrossAxisAlignment.start,



             children: [



              Row(



               children: [



                CircleAvatar(



                 backgroundImage: NetworkImage(post.avatar),



                 radius: 20,



                ),



                const SizedBox(width: 10),



                Column(



                 crossAxisAlignment: CrossAxisAlignment.start,



                 children: [



                  Text(



                   post.usuario,



                   style: const TextStyle(



                    fontWeight: FontWeight.bold,



                    fontSize: 16,



                   ),



                  ),



                  Text(



                   post.tempo,



                   style: TextStyle(



                    color: Colors.grey[600],



                    fontSize: 12,



                   ),



                  ),



                 ],



                ),



               ],



              ),



              const SizedBox(height: 12),



              Text(



               post.conteudo,



               style: const TextStyle(fontSize: 15),



              ),



              const SizedBox(height: 12),



              const Divider(height: 1),



              const SizedBox(height: 4),



              Row(



               mainAxisAlignment: MainAxisAlignment.spaceAround,



               children: [



                TextButton.icon(



                 onPressed: () {



                  setState(() {



                   post.curtidas++;



                  });



                 },



                 icon: const Icon(Icons.thumb_up_outlined, size: 20),



                 label: Text('${post.curtidas} Curtidas'),



                 style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),



                ),



                TextButton.icon(



                 onPressed: () {},



                 icon: const Icon(Icons.chat_bubble_outline, size: 20),



                 label: Text('${post.comentarios} Comentários'),



                 style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),



                ),



               ],



              ),



             ],



            ),



           ),



          );



         },



        );



       },



      ),



     ),



    ],



   ),



   floatingActionButton: Row(



    mainAxisAlignment: MainAxisAlignment.end,



    children: [



     FloatingActionButton(



      heroTag: 'btnTema',



      backgroundColor: Colors.amber,



      onPressed: () => _mostrarPopupTema(context),



      child: const Icon(Icons.palette, color: Colors.black87),



     ),



     const SizedBox(width: 12),



     FloatingActionButton(



      heroTag: 'btnPost',



      onPressed: () => _abrirModalCriarPost(nomeUsuario),



      child: const Icon(Icons.add),



     ),



    ],



   ),



   bottomNavigationBar: Container(



    padding: const EdgeInsets.all(12.0),



    color: Colors.grey.shade200,



    child: const Text(



     'Desenvolvido por: Adailton Junior Novais Mafra',



     textAlign: TextAlign.center,



     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),



    ),



   ),



  );



 }



}