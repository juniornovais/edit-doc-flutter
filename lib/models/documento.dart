class Documento {
  final String id;
  String titulo;
  String conteudo;
  DateTime ultimaModificacao;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.ultimaModificacao,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'conteudo': conteudo,
        'ultimaModificacao': ultimaModificacao.toIso8601String(),
      };

  factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        id: json['id'],
        titulo: json['titulo'],
        conteudo: json['conteudo'],
        ultimaModificacao: DateTime.parse(json['ultimaModificacao']),
      );
}