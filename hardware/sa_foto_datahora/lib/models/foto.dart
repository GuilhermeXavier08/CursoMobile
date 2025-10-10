import 'dart:io';

class Foto {
  File imagem;
  DateTime dataHora;
  String cidade;

  Foto({
    required this.imagem,
    required this.dataHora,
    required this.cidade,
  });
}