import 'package:intl/intl.dart';

class Consulta {
  final int? id;
  final int petId;
  final DateTime dataHora;
  final String tipoServico;
  final String observacao;

  Consulta({
    this.id,
    required this.petId,
    required this.dataHora,
    required this.tipoServico,
    required this.observacao,
  });

  //toMap - obj -> BD
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "pet_id": petId,
      "data_hora": dataHora.toIso8601String(),
      "tipo_servico": tipoServico,
      "observacao": observacao,
    };
  }

  //fromMap - BD -> obj
  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'] as int,
      petId: map['pet_id'] as int,
      dataHora: DateTime.parse(map['data_hora'] as String),
      tipoServico: map['tipo_servico'] as String,
      observacao: map['observacao'] as String,
    );
  }

  //método formatar data e hora em formato Brasil
  String get dataHoraFormatada {
    final  formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dataHora);
  }
}
