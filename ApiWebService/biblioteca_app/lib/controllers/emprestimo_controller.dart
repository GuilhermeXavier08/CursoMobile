import 'package:biblioteca_app/models/emprestimo.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {
  Future<List<Emprestimo>> fetchAll() async{
    final list = await ApiService.getList("emprestimos?_sort=nome");
    return list.map((item) => Emprestimo.fromJson(item)).toList();
  }

  Future<Emprestimo> fetchOne(String id) async{
    final emprestimo = await ApiService.getOne("emprestimos", id);
    return Emprestimo.fromJson(emprestimo);
  }

  Future<Emprestimo> create(Emprestimo empres) async{
    final created = await ApiService.post("emprestimos", empres.toJson());
    return Emprestimo.fromJson(created);
  }

  Future<Emprestimo> updated(Emprestimo empres) async{
    final updated = await ApiService.put("emprestimos", empres.toJson(), empres.id!);
    return Emprestimo.fromJson(updated);
  }

  Future<void> delete(String id) async{
    await ApiService.delete("emprestimos", id);
  }
}