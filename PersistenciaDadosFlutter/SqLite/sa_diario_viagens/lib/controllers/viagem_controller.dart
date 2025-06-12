import 'package:sa_diario_viagens/models/viagem_model.dart';
import 'package:sa_diario_viagens/services/diarioViagem_dbhelper.dart';

class ViagemController {
  final DiarioViagemDBHelper _dbHelper = DiarioViagemDBHelper();

  Future<int> createViagem(Viagem viagem) async {
    return _dbHelper.insertViagem(viagem);
  }

  Future<List<Viagem>> readPets() async {
    return _dbHelper.getViagens();
  }

  Future<Viagem?> readViagemById(int id) async {
    return _dbHelper.getViagemById(id);
  }

  Future<int> deleteViagem(int id) async {
    return _dbHelper.deleteViagem(id);
  }
}