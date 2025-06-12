import 'package:sa_diario_viagens/models/entrada_diaria_model.dart';
import 'package:sa_diario_viagens/services/diarioViagem_dbhelper.dart';

class EntradaDiariaController {
  final _dbHelper = DiarioViagemDBHelper();

  Future<int> createEntrada(EntradaDiaria entrada) async {
    return _dbHelper.insertEntrada(entrada);
  }

  Future<List<EntradaDiaria>> readEntradaForViagem(int viagemId) async {
    return _dbHelper.getEntradasForViagem(viagemId);
  }

  Future<int> deleteEntrada(int id) async {
    return _dbHelper.deleteEntrada(id);
  }
}