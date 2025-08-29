class Emprestimo {
  final String? id;
  final String usuario_id;
  final String livro_id;
  final DateTime data_emprestimo;
  final DateTime data_devolucao;
  final bool devolvido;

  Emprestimo({this.id, required this.usuario_id, required this.livro_id, required this.data_emprestimo, required this.data_devolucao, required this.devolvido});

  Map<String,dynamic> toJson() => {
    "id": id,
    "usuario_id": usuario_id,
    "livro_id": livro_id,
    "data_emprestimo": data_emprestimo.toIso8601String(),
    "data_devolucao": data_devolucao.toIso8601String(),
    "devolvido": devolvido
  };

  factory Emprestimo.fromJson(Map<String,dynamic> json) => Emprestimo(
    id: json["id"].toString(),
    usuario_id: json["usuario_id"].toString(),
    livro_id: json["livro_id"].toString(),
    data_emprestimo: DateTime.parse(json["data_emprestimo"]),
    data_devolucao: DateTime.parse(json["data_devolucao"]),
    devolvido: json["devolvido"] ?? true
  );
}