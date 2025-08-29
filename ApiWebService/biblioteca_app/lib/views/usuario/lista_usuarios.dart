import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario.dart';
import 'package:biblioteca_app/views/usuario/form_usuarios.dart';
import 'package:flutter/material.dart';

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({super.key});

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  final _controller = UsuarioController();
  List<Usuario> _usuarios = [];
  bool _loading = true;
  List<Usuario> _filtroUsuarios = [];
  final _buscaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() => _loading = true);
    try {
      _usuarios = await _controller.fetchAll();
      _filtroUsuarios = _usuarios;
    } catch (e) {
      print(e);
    }
    setState(() => _loading = false);
  }

  void _filtrar(){
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _filtroUsuarios = _usuarios.where((user) {
        return user.nome.toLowerCase().contains(busca) || //filtra pelo nome
        user.email.toLowerCase().contains(busca); //filtra pelo email
      }).toList(); //converte em lista
    });
  }

  void _openForm({Usuario? user}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormUsuarios(user: user)),
    );
    _load();
  }

  void _delete(Usuario user) async {
    if (user.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente Excluir o Usuário ${user.nome}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluír"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _controller.delete(user.id!);
        _load();
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _buscaField,
                    decoration: InputDecoration(labelText: "Pesquisar Usuário"),
                    onChanged: (value) => _filtrar(),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filtroUsuarios.length,
                      itemBuilder: (context, index) {
                        final user = _filtroUsuarios[index];
                        return Card(
                          child: ListTile(
                            title: Text(user.nome),
                            subtitle: Text(user.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _openForm(user: user),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _delete(user),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
