import 'package:intl/intl.dart';

class Viagem {
  final int? id;
  final String titulo;
  final String destino;
  final DateTime data_inicio;
  final DateTime data_fim;

  final String descricao;
  Viagem({
    this.id,
    required this.titulo,
    required this.destino,
    required this.data_inicio,
    required this.data_fim,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "destino": destino,
      "data_inicio": data_inicio.toIso8601String(),
      "data_fim": data_fim.toIso8601String(),
      "descricao": descricao,
    };
  }

  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map["id"] as int,
      titulo: map["titulo"] as String,
      destino: map["destino"] as String,
      data_inicio: DateTime.parse(map["data_inicio"] as String),
      data_fim: DateTime.parse(map["data_fim"] as String),
      descricao: map["descricao"] as String,
    );
  }

  String get dataHoraFormatada{
    final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(data_inicio);
  }
}
