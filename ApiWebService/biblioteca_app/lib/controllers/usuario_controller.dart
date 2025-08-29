import 'package:biblioteca_app/models/usuario.dart';
import 'package:biblioteca_app/services/api_service.dart';

class UsuarioController {
  
  Future<List<Usuario>> fetchAll() async{
    final list = await ApiService.getList("usuarios?_sort=nome");
    return list.map((item) => Usuario.fromJson(item)).toList();
  }

  Future<Usuario> fetchOne(String id) async{
    final usuario = await ApiService.getOne("usuarios", id);
    return Usuario.fromJson(usuario);
  }

  Future<Usuario> create(Usuario user) async{
    final created = await ApiService.post("usuarios", user.toJson());
    return Usuario.fromJson(created);
  }

  Future<Usuario> update(Usuario user) async{
    final updated = await ApiService.put("usuarios", user.toJson(), user.id!);
    return Usuario.fromJson(updated);
  }

  Future<void> delete(String id) async{
    await ApiService.delete("usuarios", id);
  }

}