import 'package:biblioteca_app/controllers/Livro_controller.dart';
import 'package:biblioteca_app/models/livro.dart';
import 'package:biblioteca_app/views/livro/form_livros.dart';
import 'package:flutter/material.dart';

class ListaLivros extends StatefulWidget {
  const ListaLivros({super.key});

  @override
  State<ListaLivros> createState() => _ListaLivrosState();
}

class _ListaLivrosState extends State<ListaLivros> {
  final _controller = LivroController();
  List<Livro> _livros = [];
  bool _loading = true;
  List<Livro> _filtroLivros = [];
  final _buscaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() => _loading = true);
    try {
      _livros = await _controller.fetchAll();
      _filtroLivros = _livros;
    } catch (e) {
      print(e);
    }
    setState(() => _loading = false);
  }

  void _filtrar() {
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _filtroLivros = _livros.where((book) {
        return book.titulo.toLowerCase().contains(busca) ||
            book.autor.toLowerCase().contains(busca);
      }).toList();
    });
  }

  void _openForm({Livro? book}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormLivros(book: book)),
    );
    _load();
  }

  void _delete(Livro book) async {
    if (book.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir o livro ${book.titulo}?"),
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
        await _controller.delete(book.id!);
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
                    decoration: InputDecoration(labelText: "Pesquisar Livro"),
                    onChanged: (value) => _filtrar(),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filtroLivros.length,
                      itemBuilder: (context, index) {
                        final book = _filtroLivros[index];
                        return Card(
                          child: ListTile(
                            title: Text(book.titulo),
                            subtitle: Text("${book.autor}\n ${book.disponivel == true ? "Disponível" : "Indisponível"}"),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _openForm(book: book),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _delete(book),
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
