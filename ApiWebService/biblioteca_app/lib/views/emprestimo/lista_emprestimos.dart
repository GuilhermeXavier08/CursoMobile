import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo.dart';
import 'package:biblioteca_app/views/emprestimo/form_emprestimos.dart';
import 'package:flutter/material.dart';

class ListaEmprestimos extends StatefulWidget {
  const ListaEmprestimos({super.key});

  @override
  State<ListaEmprestimos> createState() => _ListaEmprestimosState();
}

class _ListaEmprestimosState extends State<ListaEmprestimos> {
  final _controller = EmprestimoController();
  List<Emprestimo> _emprestimos = [];
  List<Emprestimo> _filtro = [];
  final _buscaField = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() => _loading = true);
    try {
      _emprestimos = await _controller.fetchAll();
      _filtro = _emprestimos;
    } catch (e) {
      print(e);
    }
    setState(() => _loading = false);
  }

  void _filtrar() {
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _filtro = _emprestimos.where((e) {
        return e.usuario_id.toLowerCase().contains(busca) ||
            e.livro_id.toLowerCase().contains(busca);
      }).toList();
    });
  }

  void _openForm({Emprestimo? emprestimo}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEmprestimos(emprestimo: emprestimo),
      ),
    );
    _load();
  }

  void _delete(Emprestimo emprestimo) async {
    if (emprestimo.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content:
            Text("Deseja realmente excluir o empréstimo do usuário ${emprestimo.usuario_id}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _controller.delete(emprestimo.id!);
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
                    decoration: InputDecoration(labelText: "Pesquisar Empréstimo"),
                    onChanged: (value) => _filtrar(),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filtro.length,
                      itemBuilder: (context, index) {
                        final e = _filtro[index];
                        return Card(
                          child: ListTile(
                            title: Text("Usuário: ${e.usuario_id}"),
                            subtitle: Text(
                              "Livro: ${e.livro_id}\n"
                              "Devolução: ${e.data_devolucao.toLocal().toString().split(' ')[0]}\n"
                              "${e.devolvido ? "Devolvido" : "Pendente"}",
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _openForm(emprestimo: e),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _delete(e),
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
